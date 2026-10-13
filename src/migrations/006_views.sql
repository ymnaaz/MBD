-- Menghapus View lama jika sudah ada
DROP VIEW IF EXISTS view_pengembalian;
DROP VIEW IF EXISTS view_peminjaman;
DROP VIEW IF EXISTS view_pelanggan;
DROP VIEW IF EXISTS view_daftar_mobil;


-- View daftar mobil
CREATE VIEW view_daftar_mobil AS
SELECT
    m.id_mobil,
    m.nomor_plat,
    m.merk,
    m.model,
    m.tahun_produksi,
    m.tarif_sewa_per_hari,
    m.status,
    m.tanggal_ditambahkan,
    CONCAT(
        m.merk, ' ', m.model,
        ' (', m.nomor_plat, ')'
    ) AS nama_lengkap
FROM mobil m;


-- View data pelanggan
CREATE VIEW view_pelanggan AS
SELECT
    id_pelanggan,
    nama,
    nomor_telepon,
    alamat,
    tanggal_dibuat
FROM pelanggan;


-- View informasi lengkap peminjaman
CREATE VIEW view_peminjaman AS
SELECT
    p.id_peminjaman,
    p.id_pelanggan,
    p.id_mobil,
    p.id_pembayaran,
    pl.nama AS nama_pelanggan,
    m.nomor_plat,
    m.merk,
    m.model,
    p.tanggal_pinjam,
    p.tanggal_rencana_kembali,
    p.tanggal_pengembalian,
    p.status AS status_peminjaman,
    p.tanggal_dibuat,
    p.total_biaya,
    p.keterlambatan_hari,
    p.denda,
    p.catatan,
    py.metode_pembayaran,
    py.status AS status_pembayaran
FROM peminjaman p
JOIN pelanggan pl
    ON p.id_pelanggan = pl.id_pelanggan
JOIN mobil m
    ON p.id_mobil = m.id_mobil
LEFT JOIN pembayaran py
    ON p.id_pembayaran = py.id_pembayaran;


