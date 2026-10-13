const MobilModel = require('../models/mobilModel');

const mobilController = {
    getAll: async (req, res) => {
        try {
            const mobils = await MobilModel.getAll();
            res.json({
                status: 'OK',
                total: mobils.length,
                data: mobils
            });
        } catch (err) {
            console.error(err);
            res.status(500).json({ status: 'ERROR', message: err.message });
        }
    },

    getById: async (req, res) => {
        try {
            const mobil = await MobilModel.getById(req.params.id);
            if (!mobil) {
                return res.status(404).json({
                    status: 'ERROR',
                    message: 'Mobil tidak ditemukan'
                });
            }
            res.json({ status: 'OK', data: mobil });
        } catch (err) {
            console.error(err);
            res.status(500).json({ status: 'ERROR', message: err.message });
        }
    }
};

module.exports = mobilController;

















// const db = require('../config/database');
// const MobilModel = require('../models/MobilModel');

// // GET semua mobil melalui View
// const getAll = async (req, res) => {
//     try {
//         const [rows] = await db.query(`
//             SELECT *
//             FROM view_mobil
//         `);

//         const data = rows.map(row => new MobilModel(row));

//         res.status(200).json({
//             success: true,
//             message: 'Data mobil berhasil diambil',
//             data
//         });
//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             message: 'Gagal mengambil data mobil',
//             error: error.message
//         });
//     }
// };

// // GET mobil berdasarkan ID melalui View
// const getById = async (req, res) => {
//     try {
//         const { id } = req.params;

//         const [rows] = await db.query(`
//             SELECT *
//             FROM view_mobil
//             WHERE id_mobil = ?
//         `, [id]);

//         if (rows.length === 0) {
//             return res.status(404).json({
//                 success: false,
//                 message: 'Mobil tidak ditemukan'
//             });
//         }

//         const data = new MobilModel(rows[0]);

//         res.status(200).json({
//             success: true,
//             message: 'Data mobil berhasil ditemukan',
//             data
//         });
//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             message: 'Gagal mengambil data mobil',
//             error: error.message
//         });
//     }
// };

// // GET mobil tersedia melalui View
// const getAvailable = async (req, res) => {
//     try {
//         const [rows] = await db.query(`
//             SELECT *
//             FROM view_mobil
//             WHERE status = 'tersedia'
//         `);

//         const data = rows.map(row => new MobilModel(row));

//         res.status(200).json({
//             success: true,
//             message: 'Data mobil tersedia berhasil diambil',
//             data
//         });
//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             message: 'Gagal mengambil mobil tersedia',
//             error: error.message
//         });
//     }
// };

// // POST mobil menggunakan Procedure
// const create = async (req, res) => {
//     try {
//         const {
//             nomor_plat,
//             merk,
//             model,
//             tahun_produksi,
//             tarif_sewa_per_hari,
//             status,
//             tanggal_ditambahkan
//         } = req.body;

//         if (
//             !nomor_plat ||
//             !merk ||
//             !model ||
//             !tahun_produksi ||
//             !tarif_sewa_per_hari ||
//             !tanggal_ditambahkan
//         ) {
//             return res.status(400).json({
//                 success: false,
//                 message: 'Data mobil belum lengkap'
//             });
//         }

//         await db.query(`
//             CALL tambah_mobil(?, ?, ?, ?, ?, ?, ?)
//         `, [
//             nomor_plat,
//             merk,
//             model,
//             tahun_produksi,
//             tarif_sewa_per_hari,
//             status || 'tersedia',
//             tanggal_ditambahkan
//         ]);

//         res.status(201).json({
//             success: true,
//             message: 'Mobil berhasil ditambahkan'
//         });
//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             message: 'Gagal menambahkan mobil',
//             error: error.message
//         });
//     }
// };

// // PUT mobil menggunakan Procedure
// const update = async (req, res) => {
//     try {
//         const { id } = req.params;

//         const {
//             nomor_plat,
//             merk,
//             model,
//             tahun_produksi,
//             tarif_sewa_per_hari,
//             status
//         } = req.body;

//         if (
//             !nomor_plat ||
//             !merk ||
//             !model ||
//             !tahun_produksi ||
//             !tarif_sewa_per_hari ||
//             !status
//         ) {
//             return res.status(400).json({
//                 success: false,
//                 message: 'Data mobil belum lengkap'
//             });
//         }

//         await db.query(`
//             CALL ubah_mobil(?, ?, ?, ?, ?, ?, ?)
//         `, [
//             id,
//             nomor_plat,
//             merk,
//             model,
//             tahun_produksi,
//             tarif_sewa_per_hari,
//             status
//         ]);

//         res.status(200).json({
//             success: true,
//             message: 'Mobil berhasil diubah'
//         });
//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             message: 'Gagal mengubah mobil',
//             error: error.message
//         });
//     }
// };

// // DELETE mobil menggunakan Procedure
// const remove = async (req, res) => {
//     try {
//         const { id } = req.params;

//         await db.query(`
//             CALL hapus_mobil(?)
//         `, [id]);

//         res.status(200).json({
//             success: true,
//             message: 'Mobil berhasil dihapus'
//         });
//     } catch (error) {
//         res.status(500).json({
//             success: false,
//             message: 'Gagal menghapus mobil',
//             error: error.message
//         });
//     }
// };

// module.exports = {
//     getAll,
//     getById,
//     getAvailable,
//     create,
//     update,
//     remove
// };