const db = require('../config/database');
const PeminjamanModel = require('../models/PeminjamanModel');

// =====================================================
// GET SEMUA DATA PEMINJAMAN
// Menggunakan View, bukan SELECT langsung ke tabel
// =====================================================
const getAll = async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT *
            FROM view_peminjaman
        `);

        const data = rows.map(row => new PeminjamanModel(row));

        res.status(200).json({
            success: true,
            message: 'Data peminjaman berhasil diambil',
            data
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Gagal mengambil data peminjaman',
            error: error.message
        });
    }
};


// =====================================================
// GET PEMINJAMAN BERDASARKAN ID
// Tetap mengambil dari View
// =====================================================
const getById = async (req, res) => {
    try {
        const { id } = req.params;

        const [rows] = await db.query(`
            SELECT *
            FROM view_peminjaman
            WHERE id_peminjaman = ?
        `, [id]);

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Data peminjaman tidak ditemukan'
            });
        }

        const data = new PeminjamanModel(rows[0]);

        res.status(200).json({
            success: true,
            message: 'Data peminjaman berhasil ditemukan',
            data
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Gagal mengambil data peminjaman',
            error: error.message
        });
    }
};


// =====================================================
// MENAMBAHKAN PEMINJAMAN
// Menggunakan Procedure tambah_peminjaman
// Trigger berjalan otomatis di database
// =====================================================
const create = async (req, res) => {
    try {
        const {
            id_pelanggan,
            id_mobil,
            id_pembayaran,
            tanggal_pinjam,
            tanggal_kembali
        } = req.body;

        if (
            id_pelanggan === undefined ||
            id_mobil === undefined ||
            id_pembayaran === undefined ||
            !tanggal_pinjam ||
            !tanggal_kembali
        ) {
            return res.status(400).json({
                success: false,
                message: 'Data peminjaman belum lengkap'
            });
        }

        // Memanggil Procedure
        await db.query(`
            CALL tambah_peminjaman(?, ?, ?, ?, ?)
        `, [
            id_pelanggan,
            id_mobil,
            id_pembayaran,
            tanggal_pinjam,
            tanggal_kembali
        ]);

        // Mengambil hasil terbaru dari View
        const [rows] = await db.query(`
            SELECT *
            FROM view_peminjaman
            ORDER BY id_peminjaman DESC
            LIMIT 1
        `);

        const data = rows.length > 0
            ? new PeminjamanModel(rows[0])
            : null;

        res.status(201).json({
            success: true,
            message: 'Peminjaman berhasil ditambahkan',
            data
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Gagal menambahkan peminjaman',
            error: error.message
        });
    }
};


// =====================================================
// MENGHITUNG TOTAL SEWA
// Menggunakan Function hitung_total_sewa
// =====================================================
const calculateTotalSewa = async (req, res) => {
    try {
        const {
            id_mobil,
            tanggal_pinjam,
            tanggal_kembali
        } = req.query;

        if (!id_mobil || !tanggal_pinjam || !tanggal_kembali) {
            return res.status(400).json({
                success: false,
                message: 'id_mobil, tanggal_pinjam, dan tanggal_kembali wajib diisi'
            });
        }

        const [rows] = await db.query(`
            SELECT hitung_total_sewa(?, ?, ?) AS total_sewa
        `, [
            id_mobil,
            tanggal_pinjam,
            tanggal_kembali
        ]);

        res.status(200).json({
            success: true,
            message: 'Total sewa berhasil dihitung',
            data: rows[0]
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Gagal menghitung total sewa',
            error: error.message
        });
    }
};


// =====================================================
// MENGHITUNG DENDA
// Menggunakan Function hitung_denda
// =====================================================
const calculateDenda = async (req, res) => {
    try {
        const { keterlambatan_hari } = req.query;

        if (keterlambatan_hari === undefined) {
            return res.status(400).json({
                success: false,
                message: 'keterlambatan_hari wajib diisi'
            });
        }

        const [rows] = await db.query(`
            SELECT hitung_denda(?) AS total_denda
        `, [keterlambatan_hari]);

        res.status(200).json({
            success: true,
            message: 'Denda berhasil dihitung',
            data: rows[0]
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Gagal menghitung denda',
            error: error.message
        });
    }
};


// =====================================================
// EXPORT CONTROLLER
// =====================================================
module.exports = {
    getAll,
    getById,
    create,
    calculateTotalSewa,
    calculateDenda
};