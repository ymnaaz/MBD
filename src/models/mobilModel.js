const pool = require('../config/database');

class MobilModel {
    constructor(data = {}) {
        this.id_mobil = data.id_mobil;
        this.nomor_plat = data.nomor_plat;
        this.merk = data.merk;
        this.model = data.model;
        this.tahun_produksi = data.tahun_produksi;
        this.tarif_sewa_per_hari = data.tarif_sewa_per_hari;
        this.status = data.status;
        this.tanggal_ditambahkan = data.tanggal_ditambahkan;
    }

    // ambil semua mobil dari view
    static async getAll() {
        const [rows] = await pool.query('SELECT * FROM view_daftar_mobil');
        return rows.map(r => new MobilModel(r));
    }

    // ambil mobil berdasarkan id
    static async getById(id) {
        const [rows] = await pool.query(
            'SELECT * FROM view_daftar_mobil WHERE id_mobil = ?',
            [id]
        );
        return rows[0] ? new MobilModel(rows[0]) : null;
    }
}

module.exports = MobilModel;