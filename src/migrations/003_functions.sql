-- hitung_total_sewa mengambil tarif mobil dari tabel mobil, menghitung lama sewa, 
-- lalu menghasilkan total biaya. Function ini digunakan oleh Procedure peminjaman.
DROP FUNCTION IF EXISTS hitung_total_sewa;

DELIMITER //

CREATE FUNCTION hitung_total_sewa(
    p_id_mobil INT,
    p_tanggal_pinjam DATE,
    p_tanggal_kembali DATE
)
RETURNS DECIMAL(12,2)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE tarif DECIMAL(12,2);
    DECLARE jumlah_hari INT;
    DECLARE total DECIMAL(12,2);

    SELECT tarif_sewa_per_hari
    INTO tarif
    FROM mobil
    WHERE id_mobil = p_id_mobil;

    SET jumlah_hari = DATEDIFF(
        p_tanggal_kembali,
        p_tanggal_pinjam
    );

    IF jumlah_hari <= 0 THEN
        SET jumlah_hari = 1;
    END IF;
    SET total = tarif * jumlah_hari;
    RETURN total;
END //


-- hitung_denda menghitung denda sebesar Rp100.000 per hari keterlambatan. 
-- Function ini akan digunakan oleh Procedure pengembalian.

DROP FUNCTION IF EXISTS hitung_denda;

CREATE FUNCTION hitung_denda(
    p_keterlambatan_hari INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE denda DECIMAL(12,2);

    IF p_keterlambatan_hari IS NULL
       OR p_keterlambatan_hari <= 0 THEN
        SET denda = 0;
    ELSE
        SET denda = p_keterlambatan_hari * 100000;
    END IF;
    RETURN denda;
END //

DELIMITER ;