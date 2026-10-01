-- =====================================================
-- VIEW: Menampilkan informasi lengkap peminjaman
-- =====================================================


CREATE VIEW view_peminjaman AS
SELECT
    p.id_peminjaman,
    pl.nama AS nama_pelanggan,
    m.nomor_plat,
    m.merk,
    m.model,
    p.tanggal_pinjam,
    p.tanggal_rencana_kembali,
    p.status AS status_peminjaman,
    p.total_biaya,
    p.keterlambatan_hari,
    p.denda,
    py.metode_pembayaran,
    py.status AS status_pembayaran
FROM peminjaman p
JOIN pelanggan pl
    ON p.id_pelanggan = pl.id_pelanggan
JOIN mobil m
    ON p.id_mobil = m.id_mobil
LEFT JOIN pembayaran py
    ON p.id_pembayaran = py.id_pembayaran;