const express = require('express');
const router = express.Router();

const peminjamanController = require('../controllers/peminjamanController');

// FUNCTION: hitung total sewa
router.get('/hitung-sewa', peminjamanController.calculateTotalSewa);

// FUNCTION: hitung denda
router.get('/hitung-denda', peminjamanController.calculateDenda);

// VIEW: semua data peminjaman
router.get('/', peminjamanController.getAll);

// VIEW: peminjaman berdasarkan ID
router.get('/:id', peminjamanController.getById);

// PROCEDURE: tambah peminjaman
// TRIGGER akan berjalan otomatis di database
router.post('/', peminjamanController.create);

module.exports = router;