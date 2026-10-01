-- =====================================================
-- PROCEDURE PELANGGAN
-- =====================================================

DROP PROCEDURE IF EXISTS tambah_pelanggan;
DROP PROCEDURE IF EXISTS ubah_pelanggan;
DROP PROCEDURE IF EXISTS hapus_pelanggan;

DELIMITER $$

CREATE PROCEDURE tambah_pelanggan(
    IN p_nama VARCHAR(100),
    IN p_nomor_telepon VARCHAR(20),
    IN p_alamat VARCHAR(255),
    IN p_tanggal_dibuat DATE
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
        p_tanggal_dibuat
    );
END $$

CREATE PROCEDURE ubah_pelanggan(
    IN p_id_pelanggan INT,
    IN p_nama VARCHAR(100),
    IN p_nomor_telepon VARCHAR(20),
    IN p_alamat VARCHAR(255)
)
BEGIN
    UPDATE pelanggan
    SET
        nama = p_nama,
        nomor_telepon = p_nomor_telepon,
        alamat = p_alamat
    WHERE id_pelanggan = p_id_pelanggan;
END $$

CREATE PROCEDURE hapus_pelanggan(
    IN p_id_pelanggan INT
)
BEGIN
    DELETE FROM pelanggan
    WHERE id_pelanggan = p_id_pelanggan;
END $$

DELIMITER ;


-- =====================================================
-- PROCEDURE MOBIL
-- =====================================================

DROP PROCEDURE IF EXISTS tambah_mobil;
DROP PROCEDURE IF EXISTS ubah_mobil;
DROP PROCEDURE IF EXISTS hapus_mobil;

DELIMITER $$

CREATE PROCEDURE tambah_mobil(
    IN p_nomor_plat VARCHAR(15),
    IN p_merk VARCHAR(50),
    IN p_model VARCHAR(50),
    IN p_tahun_produksi INT,
    IN p_tarif_sewa_per_hari DECIMAL(12,2),
    IN p_status VARCHAR(20),
    IN p_tanggal_ditambahkan DATE
)
BEGIN
    INSERT INTO mobil (
        nomor_plat,
        merk,
        model,
        tahun_produksi,
        tarif_sewa_per_hari,
        status,
        tanggal_ditambahkan
    )
    VALUES (
        p_nomor_plat,
        p_merk,
        p_model,
        p_tahun_produksi,
        p_tarif_sewa_per_hari,
        p_status,
        p_tanggal_ditambahkan
    );
END $$

CREATE PROCEDURE ubah_mobil(
    IN p_id_mobil INT,
    IN p_nomor_plat VARCHAR(15),
    IN p_merk VARCHAR(50),
    IN p_model VARCHAR(50),
    IN p_tahun_produksi INT,
    IN p_tarif_sewa_per_hari DECIMAL(12,2),
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE mobil
    SET
        nomor_plat = p_nomor_plat,
        merk = p_merk,
        model = p_model,
        tahun_produksi = p_tahun_produksi,
        tarif_sewa_per_hari = p_tarif_sewa_per_hari,
        status = p_status
    WHERE id_mobil = p_id_mobil;
END $$

CREATE PROCEDURE hapus_mobil(
    IN p_id_mobil INT
)
BEGIN
    DELETE FROM mobil
    WHERE id_mobil = p_id_mobil;
END $$

DELIMITER ;


-- =====================================================
-- PROCEDURE PEMBAYARAN
-- =====================================================

DROP PROCEDURE IF EXISTS tambah_pembayaran;
DROP PROCEDURE IF EXISTS ubah_pembayaran;
DROP PROCEDURE IF EXISTS hapus_pembayaran;

DELIMITER $$

CREATE PROCEDURE tambah_pembayaran(
    IN p_metode_pembayaran VARCHAR(30),
    IN p_tanggal_bayar DATE,
    IN p_jumlah DECIMAL(12,2),
    IN p_status VARCHAR(20)
)
BEGIN
    INSERT INTO pembayaran (
        metode_pembayaran,
        tanggal_bayar,
        jumlah,
        status
    )
    VALUES (
        p_metode_pembayaran,
        p_tanggal_bayar,
        p_jumlah,
        p_status
    );
END $$

CREATE PROCEDURE ubah_pembayaran(
    IN p_id_pembayaran INT,
    IN p_metode_pembayaran VARCHAR(30),
    IN p_tanggal_bayar DATE,
    IN p_jumlah DECIMAL(12,2),
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE pembayaran
    SET
        metode_pembayaran = p_metode_pembayaran,
        tanggal_bayar = p_tanggal_bayar,
        jumlah = p_jumlah,
        status = p_status
    WHERE id_pembayaran = p_id_pembayaran;
END $$

CREATE PROCEDURE hapus_pembayaran(
    IN p_id_pembayaran INT
)
BEGIN
    DELETE FROM pembayaran
    WHERE id_pembayaran = p_id_pembayaran;
END $$

DELIMITER ;