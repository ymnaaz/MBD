-- =====================================================
-- MENGHAPUS TRIGGER LAMA JIKA SUDAH ADA
-- =====================================================

DROP TRIGGER IF EXISTS trg_mobil_dipinjam;
DROP TRIGGER IF EXISTS trg_mobil_kembali;

DELIMITER //


-- =====================================================
-- TRIGGER 1: Mengubah status mobil menjadi disewa
-- saat peminjaman baru ditambahkan
-- =====================================================

CREATE TRIGGER trg_mobil_dipinjam
AFTER INSERT ON peminjaman
FOR EACH ROW
BEGIN
    IF NEW.status = 'dipinjam' THEN
        UPDATE mobil
        SET status = 'disewa'
        WHERE id_mobil = NEW.id_mobil;
    END IF;
END //


-- =====================================================
-- TRIGGER 2: Mengubah status mobil menjadi tersedia
-- saat peminjaman dikembalikan
-- =====================================================

CREATE TRIGGER trg_mobil_kembali
AFTER UPDATE ON peminjaman
FOR EACH ROW
BEGIN
    IF NEW.status = 'dikembalikan'
       AND OLD.status = 'dipinjam' THEN

        UPDATE mobil
        SET status = 'tersedia'
        WHERE id_mobil = NEW.id_mobil;

    END IF;
END //

DELIMITER ;