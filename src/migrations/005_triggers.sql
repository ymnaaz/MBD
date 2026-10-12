-- Menghapus Trigger lama jika sudah ada
DROP TRIGGER IF EXISTS trg_mobil_dipinjam;
DROP TRIGGER IF EXISTS trg_mobil_kembali;

DELIMITER //

-- Trigger mengubah status mobil saat peminjaman dibuat
CREATE TRIGGER trg_mobil_dipinjam
AFTER INSERT ON peminjaman
FOR EACH ROW
BEGIN
    IF NEW.status = 'dipinjam' THEN
        UPDATE mobil
        SET status = 'dipinjam'
        WHERE id_mobil = NEW.id_mobil;
    END IF;
END //


-- Trigger mengubah status mobil saat pengembalian selesai
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