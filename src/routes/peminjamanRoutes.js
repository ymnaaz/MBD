const express = require('express');
const router = express.Router();
const peminjamanController = require('../controllers/peminjamanController');

router.post('/', peminjamanController.create);
router.get('/', peminjamanController.getAll);
router.get('/:id', peminjamanController.getById);
router.put('/:id/kembali', peminjamanController.kembalikan);

module.exports = router;