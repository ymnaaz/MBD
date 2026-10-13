const PelangganModel = require('../models/PelangganModel');

const pelangganController = {
    // POST /api/pelanggan
    create: async (req, res) => {
        try {
            const { nama, nomor_telepon, alamat } = req.body;

            if (!nama || !nomor_telepon || !alamat) {
                return res.status(400).json({
                    status: 'ERROR',
                    message: 'Nama, nomor telepon, dan alamat wajib diisi'
                });
            }

            const result = await PelangganModel.create({ nama, nomor_telepon, alamat });

            if (result.status === 'OK') {
                res.status(201).json(result);
            } else {
                res.status(400).json(result);
            }
        } catch (err) {
            console.error(err);
            res.status(500).json({ status: 'ERROR', message: err.message });
        }
    },

    // GET /api/pelanggan
    getAll: async (req, res) => {
        try {
            const pelanggans = await PelangganModel.getAll();
            res.json({ status: 'OK', total: pelanggans.length, data: pelanggans });
        } catch (err) {
            console.error(err);
            res.status(500).json({ status: 'ERROR', message: err.message });
        }
    },

    // GET /api/pelanggan/:id
    getById: async (req, res) => {
        try {
            const pelanggan = await PelangganModel.getById(req.params.id);
            if (!pelanggan) {
                return res.status(404).json({ status: 'ERROR', message: 'Pelanggan tidak ditemukan' });
            }
            res.json({ status: 'OK', data: pelanggan });
        } catch (err) {
            console.error(err);
            res.status(500).json({ status: 'ERROR', message: err.message });
        }
    }
};

module.exports = pelangganController;


// const db = require('../config/database');
// const PelangganModel = require('../models/PelangganModel');

// // GET semua pelanggan melalui View
// const getAll = async (req, res) => {
//     try {
//         const [rows] = await db.query(`
//             SELECT *
//             FROM view_pelanggan
//         `);

//         const data = rows.map(row => new PelangganModel(row));

//         res.status(200).json({
//             success: true,
//             message: 'Data pelanggan berhasil diambil',
//             data
//         });
//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             message: 'Gagal mengambil data pelanggan',
//             error: error.message
//         });
//     }
// };

// // GET pelanggan berdasarkan ID melalui View
// const getById = async (req, res) => {
//     try {
//         const { id } = req.params;

//         const [rows] = await db.query(`
//             SELECT *
//             FROM view_pelanggan
//             WHERE id_pelanggan = ?
//         `, [id]);

//         if (rows.length === 0) {
//             return res.status(404).json({
//                 success: false,
//                 message: 'Pelanggan tidak ditemukan'
//             });
//         }

//         const data = new PelangganModel(rows[0]);

//         res.status(200).json({
//             success: true,
//             message: 'Data pelanggan berhasil ditemukan',
//             data
//         });
//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             message: 'Gagal mengambil data pelanggan',
//             error: error.message
//         });
//     }
// };

// // POST pelanggan menggunakan Procedure
// const create = async (req, res) => {
//     try {
//         const {
//             nama,
//             nomor_telepon,
//             alamat,
//             tanggal_dibuat
//         } = req.body;

//         if (!nama || !nomor_telepon || !alamat || !tanggal_dibuat) {
//             return res.status(400).json({
//                 success: false,
//                 message: 'Data pelanggan belum lengkap'
//             });
//         }

//         await db.query(`
//             CALL tambah_pelanggan(?, ?, ?, ?)
//         `, [
//             nama,
//             nomor_telepon,
//             alamat,
//             tanggal_dibuat
//         ]);

//         res.status(201).json({
//             success: true,
//             message: 'Pelanggan berhasil ditambahkan'
//         });
//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             message: 'Gagal menambahkan pelanggan',
//             error: error.message
//         });
//     }
// };

// // PUT pelanggan menggunakan Procedure
// const update = async (req, res) => {
//     try {
//         const { id } = req.params;
//         const {
//             nama,
//             nomor_telepon,
//             alamat
//         } = req.body;

//         if (!nama || !nomor_telepon || !alamat) {
//             return res.status(400).json({
//                 success: false,
//                 message: 'Data pelanggan belum lengkap'
//             });
//         }

//         await db.query(`
//             CALL ubah_pelanggan(?, ?, ?, ?)
//         `, [
//             id,
//             nama,
//             nomor_telepon,
//             alamat
//         ]);

//         res.status(200).json({
//             success: true,
//             message: 'Pelanggan berhasil diubah'
//         });
//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             message: 'Gagal mengubah pelanggan',
//             error: error.message
//         });
//     }
// };

// // DELETE pelanggan menggunakan Procedure
// const remove = async (req, res) => {
//     try {
//         const { id } = req.params;

//         await db.query(`
//             CALL hapus_pelanggan(?)
//         `, [id]);

//         res.status(200).json({
//             success: true,
//             message: 'Pelanggan berhasil dihapus'
//         });
//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             message: 'Gagal menghapus pelanggan',
//             error: error.message
//         });
//     }
// };

// module.exports = {
//     getAll,
//     getById,
//     create,
//     update,
//     remove
// };