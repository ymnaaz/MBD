const PeminjamanModel = require('../models/PeminjamanModel');

const peminjamanController = {
    // POST /api/peminjaman
    create: async (req, res) => {
        try {
            const { id_pelanggan, id_mobil, id_pembayaran, tanggal_pinjam, tanggal_kembali } = req.body;

            if (!id_pelanggan || !id_mobil || !tanggal_pinjam || !tanggal_kembali) {
                return res.status(400).json({
                    status: 'ERROR',
                    message: 'id_pelanggan, id_mobil, tanggal_pinjam, tanggal_kembali wajib diisi'
                });
            }

            const result = await PeminjamanModel.create({
                id_pelanggan,
                id_mobil,
                id_pembayaran: id_pembayaran || null,
                tanggal_pinjam,
                tanggal_kembali
            });

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

    // GET /api/peminjaman
    getAll: async (req, res) => {
        try {
            const data = await PeminjamanModel.getAll();
            res.json({ status: 'OK', total: data.length, data });
        } catch (err) {
            console.error(err);
            res.status(500).json({ status: 'ERROR', message: err.message });
        }
    },

    // GET /api/peminjaman/:id
    getById: async (req, res) => {
        try {
            const data = await PeminjamanModel.getById(req.params.id);
            if (!data) {
                return res.status(404).json({ status: 'ERROR', message: 'Peminjaman tidak ditemukan' });
            }
            res.json({ status: 'OK', data });
        } catch (err) {
            console.error(err);
            res.status(500).json({ status: 'ERROR', message: err.message });
        }
    },

    // PUT /api/peminjaman/:id/kembali
    kembalikan: async (req, res) => {
        try {
            const { id } = req.params;
            const { tanggal_pengembalian } = req.body;

            if (!tanggal_pengembalian) {
                return res.status(400).json({
                    status: 'ERROR',
                    message: 'tanggal_pengembalian wajib diisi'
                });
            }

            const result = await PeminjamanModel.kembalikan(id, tanggal_pengembalian);

            if (result.status === 'OK') {
                res.json(result);
            } else {
                res.status(400).json(result);
            }
        } catch (err) {
            console.error(err);
            res.status(500).json({ status: 'ERROR', message: err.message });
        }
    }
};

module.exports = peminjamanController;