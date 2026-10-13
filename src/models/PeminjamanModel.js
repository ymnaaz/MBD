const pool = require('../config/database');

class PeminjamanModel {
    constructor(data = {}) {
        this.id_peminjaman = data.id_peminjaman;
        this.id_pelanggan = data.id_pelanggan;
        this.id_mobil = data.id_mobil;
        this.id_pembayaran = data.id_pembayaran;
        this.nama_pelanggan = data.nama_pelanggan;
        this.nomor_plat = data.nomor_plat;
        this.merk = data.merk;
        this.model = data.model;
        this.tanggal_pinjam = data.tanggal_pinjam;
        this.tanggal_rencana_kembali = data.tanggal_rencana_kembali;
        this.tanggal_pengembalian = data.tanggal_pengembalian;
        this.status_peminjaman = data.status_peminjaman;
        this.total_biaya = data.total_biaya;
        this.keterlambatan_hari = data.keterlambatan_hari;
        this.denda = data.denda;
        this.catatan = data.catatan;
        this.metode_pembayaran = data.metode_pembayaran;
        this.status_pembayaran = data.status_pembayaran;
    }

    // buat peminjaman baru via procedure
    static async create({ id_pelanggan, id_mobil, id_pembayaran, tanggal_pinjam, tanggal_kembali }) {
        const [result] = await pool.query(
            'CALL sp_tambah_peminjaman(?, ?, ?, ?, ?)',
            [id_pelanggan, id_mobil, id_pembayaran, tanggal_pinjam, tanggal_kembali]
        );
        return result[0][0];
    }

    // lihat semua peminjaman
    static async getAll() {
        const [rows] = await pool.query('SELECT * FROM view_peminjaman');
        return rows.map(r => new PeminjamanModel(r));
    }

    // lihat peminjaman by id
    static async getById(id) {
        const [rows] = await pool.query(
            'SELECT * FROM view_peminjaman WHERE id_peminjaman = ?',
            [id]
        );
        return rows[0] ? new PeminjamanModel(rows[0]) : null;
    }

    static async kembalikan(id_peminjaman, tanggal_pengembalian) {
    const [result] = await pool.query(
        'CALL sp_pengembalian_mobil(?, ?)',
        [id_peminjaman, tanggal_pengembalian]
    );
    return result[0][0];
    }
}

module.exports = PeminjamanModel;