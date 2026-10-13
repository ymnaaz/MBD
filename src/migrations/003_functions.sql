-- Menghapus Function jika sebelumnya sudah ada
DROP FUNCTION IF EXISTS hitung_total_sewa;
DROP FUNCTION IF EXISTS hitung_denda;

DELIMITER //

-- Function menghitung total biaya sewa
CREATE FUNCTION hitung_total_sewa(
    p_id_mobil INT,
    p_tanggal_pinjam DATE,
    p_tanggal_kembali DATE
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_tarif DECIMAL(12,2);
    DECLARE v_hari INT;
    DECLARE v_total DECIMAL(12,2);

    -- Mengambil tarif sewa berdasarkan ID mobil
    SELECT tarif_sewa_per_hari
    INTO v_tarif
    FROM mobil
    WHERE id_mobil = p_id_mobil;

    -- Menghitung lama sewa berdasarkan selisih tanggal
    SET v_hari = DATEDIFF(
        p_tanggal_kembali,
        p_tanggal_pinjam
    );

    -- Minimal lama sewa dihitung satu hari
    IF v_hari <= 0 THEN
        SET v_hari = 1;
    END IF;

    -- Menghitung total biaya sewa
    SET v_total = v_tarif * v_hari;

    RETURN v_total;
END //


-- Function menghitung denda keterlambatan
-- Denda sebesar 50% tarif harian dikali jumlah hari terlambat
CREATE FUNCTION hitung_denda(
    p_id_mobil INT,
    p_keterlambatan_hari INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_tarif DECIMAL(12,2);

    -- Jika tidak terlambat, denda menjadi nol
    IF p_keterlambatan_hari IS NULL
       OR p_keterlambatan_hari <= 0 THEN
        RETURN 0;
    END IF;

    -- Mengambil tarif sewa mobil
    SELECT tarif_sewa_per_hari
    INTO v_tarif
    FROM mobil
    WHERE id_mobil = p_id_mobil;

    -- Menghitung denda sebesar 50% tarif harian per hari
    RETURN v_tarif * p_keterlambatan_hari * 0.5;
END //

DELIMITER ;


-- -- hitung_total_sewa: hitung biaya sewa berdasarkan tarif mobil dan lama sewa
-- DROP FUNCTION IF EXISTS hitung_total_sewa;

-- DELIMITER //

-- CREATE FUNCTION hitung_total_sewa(
--     p_id_mobil INT,
--     p_tanggal_pinjam DATE,
--     p_tanggal_kembali DATE
-- )
-- RETURNS DECIMAL(12,2)
-- DETERMINISTIC
-- READS SQL DATA
-- BEGIN
--     DECLARE v_tarif DECIMAL(12,2);
--     DECLARE v_hari INT;
--     DECLARE v_total DECIMAL(12,2);

--     SELECT tarif_sewa_per_hari INTO v_tarif
--     FROM mobil WHERE id_mobil = p_id_mobil;

--     SET v_hari = DATEDIFF(p_tanggal_kembali, p_tanggal_pinjam);
--     IF v_hari <= 0 THEN SET v_hari = 1; END IF;

--     SET v_total = v_tarif * v_hari;
--     RETURN v_total;
-- END //


-- -- hitung_denda: denda 50% dari tarif harian × hari terlambat
-- DROP FUNCTION IF EXISTS hitung_denda;

-- CREATE FUNCTION hitung_denda(
--     p_id_mobil INT,
--     p_keterlambatan_hari INT
-- )
-- RETURNS DECIMAL(12,2)
-- DETERMINISTIC
-- READS SQL DATA
-- BEGIN
--     DECLARE v_tarif DECIMAL(12,2);

--     IF p_keterlambatan_hari IS NULL OR p_keterlambatan_hari <= 0 THEN
--         RETURN 0;
--     END IF;

--     SELECT tarif_sewa_per_hari INTO v_tarif
--     FROM mobil WHERE id_mobil = p_id_mobil;

--     RETURN v_tarif * p_keterlambatan_hari * 0.5;
-- END //

-- DELIMITER ;