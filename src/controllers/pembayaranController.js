const db = require('../config/database');
const PembayaranModel = require('../models/PembayaranModel');

// GET semua pembayaran melalui View
const getAll = async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT *
            FROM view_pembayaran
        `);

        const data = rows.map(row => new PembayaranModel(row));

        res.status(200).json({
            success: true,
            message: 'Data pembayaran berhasil diambil',
            data
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Gagal mengambil data pembayaran',
            error: error.message
        });
    }
};

// GET pembayaran berdasarkan ID melalui View
const getById = async (req, res) => {
    try {
        const { id } = req.params;

        const [rows] = await db.query(`
            SELECT *
            FROM view_pembayaran
            WHERE id_pembayaran = ?
        `, [id]);

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Pembayaran tidak ditemukan'
            });
        }

        const data = new PembayaranModel(rows[0]);

        res.status(200).json({
            success: true,
            message: 'Data pembayaran berhasil ditemukan',
            data
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Gagal mengambil data pembayaran',
            error: error.message
        });
    }
};

// POST pembayaran menggunakan Procedure
const create = async (req, res) => {
    try {
        const {
            metode_pembayaran,
            tanggal_bayar,
            jumlah,
            status
        } = req.body;

        if (!metode_pembayaran || !tanggal_bayar || jumlah === undefined) {
            return res.status(400).json({
                success: false,
                message: 'Data pembayaran belum lengkap'
            });
        }

        await db.query(`
            CALL tambah_pembayaran(?, ?, ?, ?)
        `, [
            metode_pembayaran,
            tanggal_bayar,
            jumlah,
            status || 'menunggu'
        ]);

        res.status(201).json({
            success: true,
            message: 'Pembayaran berhasil ditambahkan'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Gagal menambahkan pembayaran',
            error: error.message
        });
    }
};

// PUT pembayaran menggunakan Procedure
const update = async (req, res) => {
    try {
        const { id } = req.params;

        const {
            metode_pembayaran,
            tanggal_bayar,
            jumlah,
            status
        } = req.body;

        if (!metode_pembayaran || !tanggal_bayar || jumlah === undefined || !status) {
            return res.status(400).json({
                success: false,
                message: 'Data pembayaran belum lengkap'
            });
        }

        await db.query(`
            CALL ubah_pembayaran(?, ?, ?, ?, ?)
        `, [
            id,
            metode_pembayaran,
            tanggal_bayar,
            jumlah,
            status
        ]);

        res.status(200).json({
            success: true,
            message: 'Pembayaran berhasil diubah'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Gagal mengubah pembayaran',
            error: error.message
        });
    }
};

// DELETE pembayaran menggunakan Procedure
const remove = async (req, res) => {
    try {
        const { id } = req.params;

        await db.query(`
            CALL hapus_pembayaran(?)
        `, [id]);

        res.status(200).json({
            success: true,
            message: 'Pembayaran berhasil dihapus'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Gagal menghapus pembayaran',
            error: error.message
        });
    }
};

// Export
module.exports = {
    getAll,
    getById,
    create,
    update,
    remove
};