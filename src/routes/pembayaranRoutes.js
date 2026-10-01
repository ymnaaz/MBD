const express = require('express');
const router = express.Router();

const pembayaranController = require('../controllers/pembayaranController');

// GET semua pembayaran melalui View
router.get('/', pembayaranController.getAll);

// GET pembayaran berdasarkan ID melalui View
router.get('/:id', pembayaranController.getById);

// POST pembayaran melalui Procedure
router.post('/', pembayaranController.create);

// PUT pembayaran melalui Procedure
router.put('/:id', pembayaranController.update);

// DELETE pembayaran melalui Procedure
router.delete('/:id', pembayaranController.remove);

module.exports = router;
