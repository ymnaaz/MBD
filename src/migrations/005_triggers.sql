-- =====================================================
-- TRIGGER: Menghitung denda otomatis
-- =====================================================

DROP TRIGGER IF EXISTS hitung_denda_peminjaman;

DELIMITER //

CREATE TRIGGER hitung_denda_peminjaman
BEFORE INSERT ON peminjaman
FOR EACH ROW
BEGIN
    -- Menggunakan Function untuk menghitung denda
    IF NEW.keterlambatan_hari > 0 THEN
        SET NEW.denda = hitung_denda(
            NEW.keterlambatan_hari
        );
    ELSE
        SET NEW.denda = 0;
    END IF;
END //

DELIMITER ;