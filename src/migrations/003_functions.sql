-- =====================================================
-- FUNCTION 1: Menghitung total biaya sewa
-- =====================================================

DROP FUNCTION IF EXISTS hitung_total_sewa;

DELIMITER //

CREATE FUNCTION hitung_total_sewa(
    p_id_mobil INT,
    p_tanggal_pinjam DATE,
    p_tanggal_kembali DATE
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
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

DELIMITER ;


-- =====================================================
-- FUNCTION 2: Menghitung denda keterlambatan
-- =====================================================

DROP FUNCTION IF EXISTS hitung_denda;

DELIMITER //

CREATE FUNCTION hitung_denda(
    p_keterlambatan_hari INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE denda DECIMAL(12,2);

    SET denda = p_keterlambatan_hari * 100000;

    RETURN denda;
END //

DELIMITER ;