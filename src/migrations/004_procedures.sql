
-- mendaftarkan data pelanggan
DROP PROCEDURE IF EXISTS sp_mendaftarkan_pelanggan;

DELIMITER //

CREATE PROCEDURE sp_mendaftarkan_pelanggan(
    IN p_nama VARCHAR(100),
    IN p_nomor_telepon VARCHAR(20),
    IN p_alamat VARCHAR(255)
)
BEGIN
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
END //

-- melihat daftar mobil
DROP PROCEDURE IF EXISTS sp_lihat_daftar_mobil;

CREATE PROCEDURE sp_lihat_daftar_mobil()
BEGIN
    SELECT *
    FROM view_daftar_mobil;
END //


-- melakukan peminjaman mobil
DROP PROCEDURE IF EXISTS sp_tambah_peminjaman;

CREATE PROCEDURE sp_tambah_peminjaman(
    IN p_id_pelanggan INT,
    IN p_id_mobil INT,
    IN p_id_pembayaran INT,
    IN p_tanggal_pinjam DATE,
    IN p_tanggal_kembali DATE
)
BEGIN
    DECLARE v_status_mobil VARCHAR(20);
    DECLARE v_jumlah_mobil INT DEFAULT 0;
    DECLARE v_total DECIMAL(12,2);

    SELECT COUNT(*)
    INTO v_jumlah_mobil
    FROM mobil
    WHERE id_mobil = p_id_mobil;

    IF v_jumlah_mobil = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mobil tidak ditemukan';
    END IF;

    SELECT status
    INTO v_status_mobil
    FROM mobil
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

    -- Menambahkan data peminjaman
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
END //


-- melakukan pengembalian mobil
DROP PROCEDURE IF EXISTS sp_pengembalian_mobil;

CREATE PROCEDURE sp_pengembalian_mobil(
    IN p_id_peminjaman INT,
    IN p_tanggal_pengembalian DATE
)
BEGIN
    DECLARE v_status_peminjaman VARCHAR(20);
    DECLARE v_tanggal_rencana DATE;
    DECLARE v_keterlambatan INT DEFAULT 0;
    DECLARE v_jumlah_peminjaman INT DEFAULT 0;
    DECLARE v_denda DECIMAL(12,2);

    SELECT COUNT(*)
    INTO v_jumlah_peminjaman
    FROM peminjaman
    WHERE id_peminjaman = p_id_peminjaman;

    IF v_jumlah_peminjaman = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data peminjaman tidak ditemukan';
    END IF;

    SELECT status, tanggal_rencana_kembali
    INTO v_status_peminjaman, v_tanggal_rencana
    FROM peminjaman
    WHERE id_peminjaman = p_id_peminjaman;

    IF v_status_peminjaman <> 'dipinjam' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Peminjaman tidak sedang berlangsung';
    END IF;

    SET v_keterlambatan = GREATEST(
        DATEDIFF(
            p_tanggal_pengembalian,
            v_tanggal_rencana
        ),
        0
    );

    SET v_denda = hitung_denda(v_keterlambatan);

    UPDATE peminjaman
    SET
        tanggal_pengembalian = p_tanggal_pengembalian,
        status = 'dikembalikan',
        keterlambatan_hari = v_keterlambatan,
        denda = v_denda,
        catatan = 'Mobil telah dikembalikan'
    WHERE id_peminjaman = p_id_peminjaman;
END //

DELIMITER ;