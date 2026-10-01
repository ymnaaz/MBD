INSERT INTO pelanggan
(nama, nomor_telepon, alamat, tanggal_dibuat)
VALUES
('Diva', '081234567890', 'Balikpapan', '2026-09-07'),
('Alya', '082345678901', 'Samarinda', '2026-09-07'),
('Rizky', '083456789012', 'Balikpapan', '2026-09-07');

INSERT INTO mobil
(nomor_plat, merk, model, tahun_produksi, tarif_sewa_per_hari, status, tanggal_ditambahkan)
VALUES
('KT 1234 AB', 'Toyota', 'Avanza', 2023, 350000, 'tersedia', '2026-09-07'),
('KT 5678 CD', 'Honda', 'Brio', 2024, 300000, 'tersedia', '2026-09-07'),
('KT 9012 EF', 'Toyota', 'Innova', 2022, 500000, 'tersedia', '2026-09-07');

INSERT INTO pembayaran
(metode_pembayaran, tanggal_bayar, jumlah, status)
VALUES
('Transfer', '2026-09-07', 700000, 'berhasil'),
('QRIS', '2026-09-07', 600000, 'berhasil'),
('Transfer', '2026-09-07', 1000000, 'berhasil');