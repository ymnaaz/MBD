-- =====================================================
-- PROCEDURE: Menambahkan peminjaman baru
-- =====================================================

DROP PROCEDURE IF EXISTS tambah_peminjaman;

DELIMITER //

CREATE PROCEDURE tambah_peminjaman(
    IN p_id_pelanggan INT,
    IN p_id_mobil INT,
    IN p_id_pembayaran INT,
    IN p_tanggal_pinjam DATE,
    IN p_tanggal_kembali DATE
)
BEGIN
    DECLARE total DECIMAL(12,2);

    -- Menghitung total biaya menggunakan Function
    SET total = hitung_total_sewa(
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
        'dipinjam',
        CURDATE(),
        total,
        p_tanggal_pinjam,
        0,
        0,
        'Peminjaman baru'
    );

    -- Mengubah status mobil menjadi disewa
    UPDATE mobil
    SET status = 'disewa'
    WHERE id_mobil = p_id_mobil;
END //

DELIMITER ;