-- table pelanggan
CREATE TABLE pelanggan (
    id_pelanggan INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    nomor_telepon VARCHAR(20) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    tanggal_dibuat DATE NOT NULL DEFAULT (CURDATE())
);

-- table mobil
CREATE TABLE mobil (
    id_mobil INT AUTO_INCREMENT PRIMARY KEY,
    nomor_plat VARCHAR(15) NOT NULL UNIQUE,
    merk VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    tahun_produksi INT NOT NULL,
    tarif_sewa_per_hari DECIMAL(12,2) NOT NULL,
    status ENUM('tersedia', 'dipinjam', 'maintenance')
        NOT NULL DEFAULT 'tersedia', -- jika tdk diisi anggap tersedia
    tanggal_ditambahkan DATE NOT NULL DEFAULT (CURDATE())
);

-- table pembayaran
CREATE TABLE pembayaran (
    id_pembayaran INT AUTO_INCREMENT PRIMARY KEY,
    metode_pembayaran VARCHAR(30) NOT NULL,
    tanggal_bayar DATE NOT NULL,
    jumlah DECIMAL(12,2) NOT NULL,
    status ENUM('pending', 'berhasil', 'gagal')
        NOT NULL DEFAULT 'pending'
);

-- table peminjaman (transaksi utama)
CREATE TABLE peminjaman (
    id_peminjaman INT AUTO_INCREMENT PRIMARY KEY,
    id_pelanggan INT NOT NULL,
    id_mobil INT NOT NULL,
    id_pembayaran INT NULL,
    tanggal_pinjam DATE NOT NULL,
    tanggal_rencana_kembali DATE NOT NULL,
    tanggal_pengembalian DATE NULL,
    status ENUM('dipinjam', 'dikembalikan', 'dibatalkan')
        NOT NULL DEFAULT 'dipinjam',
    total_biaya DECIMAL(12,2) NOT NULL DEFAULT 0,
    keterlambatan_hari INT DEFAULT 0,
    denda DECIMAL(12,2) DEFAULT 0,
    catatan TEXT,
    tanggal_dibuat DATE NOT NULL DEFAULT (CURDATE()),

    CONSTRAINT fk_peminjaman_pelanggan
        FOREIGN KEY (id_pelanggan)
        REFERENCES pelanggan(id_pelanggan),

    CONSTRAINT fk_peminjaman_mobil
        FOREIGN KEY (id_mobil)
        REFERENCES mobil(id_mobil),

    CONSTRAINT fk_peminjaman_pembayaran
        FOREIGN KEY (id_pembayaran)
        REFERENCES pembayaran(id_pembayaran)
);