-- =====================================================
-- VIEW PELANGGAN
-- =====================================================

DROP VIEW IF EXISTS view_pelanggan;

CREATE VIEW view_pelanggan AS
SELECT
    id_pelanggan,
    nama,
    nomor_telepon,
    alamat,
    tanggal_dibuat
FROM pelanggan;


-- =====================================================
-- VIEW MOBIL
-- =====================================================

DROP VIEW IF EXISTS view_mobil;

CREATE VIEW view_mobil AS
SELECT
    id_mobil,
    nomor_plat,
    merk,
    model,
    tahun_produksi,
    tarif_sewa_per_hari,
    status,
    tanggal_ditambahkan
FROM mobil;


-- =====================================================
-- VIEW PEMBAYARAN
-- =====================================================

DROP VIEW IF EXISTS view_pembayaran;

CREATE VIEW view_pembayaran AS
SELECT
    id_pembayaran,
    metode_pembayaran,
    tanggal_bayar,
    jumlah,
    status
FROM pembayaran;