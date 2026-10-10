-- =====================================================
-- MENGHAPUS PROCEDURE LAMA JIKA SUDAH ADA
-- =====================================================

DROP PROCEDURE IF EXISTS sp_mendaftarkan_pelanggan;
DROP PROCEDURE IF EXISTS sp_lihat_daftar_mobil;
DROP PROCEDURE IF EXISTS sp_tambah_peminjaman;
DROP PROCEDURE IF EXISTS sp_pengembalian_mobil;

DELIMITER //


-- =====================================================
-- PROCEDURE 1: MENDAFTARKAN DATA PELANGGAN
-- =====================================================

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


-- =====================================================
-- PROCEDURE 2: MELIHAT DAFTAR MOBIL
-- =====================================================

CREATE PROCEDURE sp_lihat_daftar_mobil()
BEGIN
    -- Mengambil daftar mobil melalui View
    SELECT *
    FROM view_daftar_mobil;
END //


-- =====================================================
-- PROCEDURE 3: MELAKUKAN PEMINJAMAN MOBIL
-- =====================================================

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

    -- Memastikan mobil terdaftar
    SELECT COUNT(*)
    INTO v_jumlah_mobil
    FROM view_daftar_mobil
    WHERE id_mobil = p_id_mobil;

    IF v_jumlah_mobil = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mobil tidak ditemukan';
    END IF;

    -- Memeriksa status mobil
    SELECT status
    INTO v_status_mobil
    FROM view_daftar_mobil
    WHERE id_mobil = p_id_mobil;

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
        tanggal_rencana_kembali,
        tanggal_pengembalian,
        status,
        tanggal_dibuat,
        total_biaya,
        tanggal_pinjam,
        keterlambatan_hari,
        denda,
        catatan
    )
    VALUES (
        p_id_pelanggan,
        p_id_mobil,
        p_id_pembayaran,
        p_tanggal_kembali,
        NULL,
        'dipinjam',
        CURDATE(),
        v_total,
        p_tanggal_pinjam,
        0,
        0,
        'Peminjaman baru'
    );

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

    -- Memastikan peminjaman masih aktif
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

    -- Mengambil data peminjaman dan mobil
    SELECT
        vp.status_peminjaman,
        vp.tanggal_rencana_kembali,
        m.id_mobil
    INTO
        v_status_peminjaman,
        v_tanggal_rencana,
        v_id_mobil
    FROM view_peminjaman vp
    JOIN mobil m
        ON m.nomor_plat = vp.nomor_plat
    WHERE vp.id_peminjaman = p_id_peminjaman
    LIMIT 1;

    -- Memastikan tanggal pengembalian tidak sebelum tanggal pinjam
    SELECT tanggal_pinjam
    INTO v_tanggal_pinjam
    FROM peminjaman
    WHERE id_peminjaman = p_id_peminjaman;

    IF p_tanggal_pengembalian < v_tanggal_pinjam THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal pengembalian tidak valid';
    END IF;

    -- Menghitung hari keterlambatan
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

    COMMIT;

    SELECT
        'OK' AS status,
        'Mobil berhasil dikembalikan' AS message;
END //

DELIMITER ;