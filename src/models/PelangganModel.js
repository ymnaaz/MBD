const pool = require('../config/database');

class PelangganModel {
    constructor(data = {}) {
        this.id_pelanggan = data.id_pelanggan;
        this.nama = data.nama;
        this.nomor_telepon = data.nomor_telepon;
        this.alamat = data.alamat;
        this.tanggal_dibuat = data.tanggal_dibuat;
    }

    // daftar pelanggan baru via procedure
    static async create({ nama, nomor_telepon, alamat }) {
        const [result] = await pool.query(
            'CALL sp_mendaftarkan_pelanggan(?, ?, ?)',
            [nama, nomor_telepon, alamat]
        );
        return result[0][0];  // { status: 'OK', message: '...' }
    }

    // lihat semua pelanggan
    static async getAll() {
        const [rows] = await pool.query('SELECT * FROM view_pelanggan');
        return rows.map(r => new PelangganModel(r));
    }

    static async getById(id) {
        const [rows] = await pool.query(
            'SELECT * FROM view_pelanggan WHERE id_pelanggan = ?',
            [id]
        );
        return rows[0] ? new PelangganModel(rows[0]) : null;
    }
}

module.exports = PelangganModel;








// class PelangganModel {
//     constructor(data = {}) {
//         this.id_pelanggan = data.id_pelanggan;
//         this.nama = data.nama;
//         this.nomor_telepon = data.nomor_telepon;
//         this.alamat = data.alamat;
//         this.tanggal_dibuat = data.tanggal_dibuat;
//     }
// }

// module.exports = PelangganModel; 