-- data pelanggan
INSERT INTO pelanggan
(nama, nomor_telepon, alamat, tanggal_dibuat)
VALUES
('Diva Anggraini', '081234567890', 'Balikpapan', '2026-09-07'),
('Alya Safira', '082345678901', 'Samarinda', '2026-09-07'),
('Rizky Pratama', '083456789012', 'Balikpapan', '2026-09-07'),
('Budi Santoso', '084567890123', 'Jakarta', '2026-09-08'),
('Citra Kirana', '085678901234', 'Bandung', '2026-09-08'),
('Dimas Anggara', '086789012345', 'Surabaya', '2026-09-09'),
('Eka Wijaya', '087890123456', 'Yogyakarta', '2026-09-09'),
('Fitri Handayani', '088901234567', 'Medan', '2026-09-10'),
('Gilang Ramadhan', '089012345678', 'Makassar', '2026-09-10'),
('Hana Pertiwi', '081223344556', 'Balikpapan', '2026-09-11');


-- data mobil
INSERT INTO mobil
(nomor_plat, merk, model, tahun_produksi, tarif_sewa_per_hari, status, tanggal_ditambahkan)
VALUES
('KT 1234 AB', 'Toyota', 'Avanza', 2023, 350000, 'tersedia', '2026-09-07'),
('KT 5678 CD', 'Honda', 'Brio', 2024, 300000, 'tersedia', '2026-09-07'),
('KT 9012 EF', 'Toyota', 'Innova', 2022, 500000, 'tersedia', '2026-09-07'),
('KT 3456 GH', 'Daihatsu', 'Xenia', 2023, 330000, 'tersedia', '2026-09-08'),
('KT 7890 IJ', 'Suzuki', 'Ertiga', 2024, 380000, 'tersedia', '2026-09-08'),
('KT 2345 KL', 'Mitsubishi', 'Xpander', 2023, 400000, 'tersedia', '2026-09-08'),
('KT 6789 MN', 'Honda', 'Mobilio', 2022, 320000, 'maintenance', '2026-09-09'),
('KT 1122 OP', 'Toyota', 'Fortuner', 2024, 800000, 'tersedia', '2026-09-09'),
('KT 3344 QR', 'Honda', 'CR-V', 2023, 750000, 'tersedia', '2026-09-09'),
('KT 5566 ST', 'Toyota', 'Alphard', 2024, 1200000, 'tersedia', '2026-09-10'),
('KT 7788 UV', 'Daihatsu', 'Terios', 2023, 450000, 'tersedia', '2026-09-10'),
('KT 9900 WX', 'Suzuki', 'Ignis', 2024, 310000, 'maintenance', '2026-09-11');


-- data pembayaran
INSERT INTO pembayaran
(metode_pembayaran, tanggal_bayar, jumlah, status)
VALUES
('Transfer', '2026-09-07', 700000, 'berhasil'),
('QRIS', '2026-09-07', 600000, 'berhasil'),
('Transfer', '2026-09-07', 1000000, 'berhasil'),
('Tunai', '2026-10-07', 1320000, 'berhasil'),
('Transfer', '2026-10-08', 1520000, 'berhasil'),
('QRIS', '2026-10-09', 1200000, 'berhasil'),
('Transfer', '2026-10-08', 1600000, 'berhasil'),
('Tunai', '2026-10-09', 2400000, 'berhasil'),
('QRIS', '2026-10-09', 1350000, 'pending'),
('Transfer', '2026-10-08', 760000, 'berhasil'),
('Tunai', '2026-10-08', 1200000, 'gagal'),
('QRIS', '2026-10-07', 950000, 'berhasil');


-- data peminjaman
INSERT INTO peminjaman
(id_pelanggan, id_mobil, id_pembayaran, tanggal_pinjam, tanggal_rencana_kembali, tanggal_pengembalian, status, total_biaya, keterlambatan_hari, denda, catatan, tanggal_dibuat)
VALUES
(1, 1, 1, '2026-09-07', '2026-09-09', '2026-09-09', 'dikembalikan', 700000, 0, 0, 'Mobil dikembalikan tepat waktu', '2026-09-07'),
(2, 2, 2, '2026-09-07', '2026-09-09', '2026-09-09', 'dikembalikan', 600000, 0, 0, 'Kondisi mobil bersih', '2026-09-07'),
(3, 3, 3, '2026-09-07', '2026-09-09', '2026-09-09', 'dikembalikan', 1000000, 0, 0, 'Perjalanan luar kota', '2026-09-07'),
(4, 4, 4, '2026-10-07', '2026-10-11', NULL, 'dipinjam', 1320000, 0, 0, 'Sewa 4 hari', '2026-10-07'),
(5, 5, 5, '2026-10-08', '2026-10-12', NULL, 'dipinjam', 1520000, 0, 0, 'Sewa 4 hari', '2026-10-08'),
(6, 6, 6, '2026-10-09', '2026-10-12', NULL, 'dipinjam', 1200000, 0, 0, 'Untuk acara keluarga', '2026-10-09'),
(7, 8, 7, '2026-10-08', '2026-10-10', NULL, 'dipinjam', 1600000, 0, 0, 'Sewa 2 hari', '2026-10-08'),
(8, 10, 8, '2026-10-09', '2026-10-11', NULL, 'dipinjam', 2400000, 0, 0, 'Untuk pernikahan', '2026-10-09'),
(9, 11, 9, '2026-10-09', '2026-10-12', NULL, 'dipinjam', 1350000, 0, 0, 'Menunggu pembayaran', '2026-10-09'),
(10, 9, 12, '2026-10-04', '2026-10-05', '2026-10-07', 'dikembalikan', 750000, 2, 750000, 'Terlambat mengembalikan mobil', '2026-10-04');


-- update status mobil yang sedang dipinjam
UPDATE mobil
SET status = 'dipinjam'
WHERE id_mobil IN (4, 5, 6, 8, 10, 11);