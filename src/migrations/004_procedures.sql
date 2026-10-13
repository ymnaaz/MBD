
-- MENGHAPUS PROCEDURE LAMA JIKA SUDAH ADA
DROP PROCEDURE IF EXISTS sp_mendaftarkan_pelanggan;
DROP PROCEDURE IF EXISTS sp_lihat_daftar_mobil;
DROP PROCEDURE IF EXISTS sp_tambah_peminjaman;
DROP PROCEDURE IF EXISTS sp_pengembalian_mobil;

DELIMITER //

-- PROCEDURE 1: MENDAFTARKAN DATA PELANGGAN
CREATE PROCEDURE sp_mendaftarkan_pelanggan(
    IN p_nama VARCHAR(100),
    IN p_nomor_telepon VARCHAR(20),
    IN p_alamat VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Menambahkan pelanggan dengan tanggal saat ini
    INSERT INTO pelanggan (
        nama,
        nomor_telepon,
        alamat,
        tanggal_dibuat
    )
    VALUES (
        p_nama,
        p_nomor_telepon,
        p_alamat,
        CURDATE()
    );

    COMMIT;

    SELECT
        'OK' AS status,
        'Pelanggan berhasil didaftarkan' AS message;
END //

-- PROCEDURE 2: MELIHAT DAFTAR MOBIL

CREATE PROCEDURE sp_lihat_daftar_mobil()
BEGIN
    -- Mengambil daftar mobil melalui View
    SELECT *
    FROM view_daftar_mobil;
END //

-- PROCEDURE 3: MELAKUKAN PEMINJAMAN MOBIL
CREATE PROCEDURE sp_tambah_peminjaman(
    IN p_id_pelanggan INT,
    IN p_id_mobil INT,
    IN p_id_pembayaran INT,
    IN p_tanggal_pinjam DATE,
    IN p_tanggal_kembali DATE
)
BEGIN
    DECLARE v_status_mobil VARCHAR(20) DEFAULT NULL;
    DECLARE v_jumlah_mobil INT DEFAULT 0;
    DECLARE v_total DECIMAL(12,2);

    -- Membatalkan transaksi jika terjadi error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Memastikan tanggal peminjaman valid
    IF p_tanggal_pinjam IS NULL
       OR p_tanggal_kembali IS NULL
       OR p_tanggal_kembali < p_tanggal_pinjam THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal peminjaman tidak valid';
    END IF;

    -- Memeriksa keberadaan mobil melalui View
    SELECT COUNT(*)
    INTO v_jumlah_mobil
    FROM view_daftar_mobil
    WHERE id_mobil = p_id_mobil;

    IF v_jumlah_mobil = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mobil tidak ditemukan';
    END IF;

    -- Memeriksa dan mengunci data mobil selama transaksi
    SELECT status
    INTO v_status_mobil
    FROM mobil
    WHERE id_mobil = p_id_mobil
    FOR UPDATE;

    -- Memastikan mobil tersedia untuk disewa
    IF v_status_mobil <> 'tersedia' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mobil tidak tersedia untuk disewa';
    END IF;

    -- Menghitung total biaya menggunakan Function
    SET v_total = hitung_total_sewa(
        p_id_mobil,
        p_tanggal_pinjam,
        p_tanggal_kembali
    );

    -- Menambahkan transaksi peminjaman
    INSERT INTO peminjaman (
        id_pelanggan,
        id_mobil,
        id_pembayaran,
        tanggal_pinjam,
        tanggal_rencana_kembali,
        tanggal_pengembalian,
        status,
        total_biaya,
        keterlambatan_hari,
        denda,
        catatan,
        tanggal_dibuat
    )
    VALUES (
        p_id_pelanggan,
        p_id_mobil,
        p_id_pembayaran,
        p_tanggal_pinjam,
        p_tanggal_kembali,
        NULL,
        'dipinjam',
        v_total,
        0,
        0,
        'Peminjaman baru',
        CURDATE()
    );

    -- Trigger akan mengubah status mobil menjadi dipinjam
    COMMIT;

    SELECT
        'OK' AS status,
        'Peminjaman berhasil dibuat' AS message;
END //


-- =====================================================
-- PROCEDURE 4: MELAKUKAN PENGEMBALIAN MOBIL
-- =====================================================

CREATE PROCEDURE sp_pengembalian_mobil(
    IN p_id_peminjaman INT,
    IN p_tanggal_pengembalian DATE
)
BEGIN
    DECLARE v_status_peminjaman VARCHAR(20) DEFAULT NULL;
    DECLARE v_tanggal_pinjam DATE;
    DECLARE v_tanggal_rencana DATE;
    DECLARE v_id_mobil INT;
    DECLARE v_keterlambatan INT DEFAULT 0;
    DECLARE v_jumlah_peminjaman INT DEFAULT 0;
    DECLARE v_denda DECIMAL(12,2);

    -- Membatalkan transaksi jika terjadi error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Memastikan tanggal pengembalian diisi
    IF p_tanggal_pengembalian IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal pengembalian wajib diisi';
    END IF;

    -- Memeriksa peminjaman yang masih aktif melalui View
    SELECT COUNT(*)
    INTO v_jumlah_peminjaman
    FROM view_peminjaman
    WHERE id_peminjaman = p_id_peminjaman
      AND status_peminjaman = 'dipinjam';

    IF v_jumlah_peminjaman = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Peminjaman tidak ditemukan atau sudah dikembalikan';
    END IF;

    -- Mengambil data peminjaman melalui View
    SELECT
        status_peminjaman,
        tanggal_pinjam,
        tanggal_rencana_kembali,
        id_mobil
    INTO
        v_status_peminjaman,
        v_tanggal_pinjam,
        v_tanggal_rencana,
        v_id_mobil
    FROM view_peminjaman
    WHERE id_peminjaman = p_id_peminjaman
    AND status_peminjaman = 'dipinjam'
    LIMIT 1;

    -- Memastikan tanggal pengembalian tidak sebelum tanggal pinjam
    IF p_tanggal_pengembalian < v_tanggal_pinjam THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal pengembalian tidak valid';
    END IF;

    -- Menghitung jumlah hari keterlambatan
    SET v_keterlambatan = GREATEST(
        DATEDIFF(
            p_tanggal_pengembalian,
            v_tanggal_rencana
        ),
        0
    );

    -- Menghitung denda menggunakan Function
    SET v_denda = hitung_denda(
        v_id_mobil,
        v_keterlambatan
    );

    -- Memperbarui data pengembalian
    UPDATE peminjaman
    SET
        tanggal_pengembalian = p_tanggal_pengembalian,
        status = 'dikembalikan',
        keterlambatan_hari = v_keterlambatan,
        denda = v_denda,
        catatan = 'Mobil telah dikembalikan'
    WHERE id_peminjaman = p_id_peminjaman;

    -- Trigger akan mengubah status mobil menjadi tersedia
    COMMIT;

    SELECT
        'OK' AS status,
        'Mobil berhasil dikembalikan' AS message;
END //

DELIMITER ;