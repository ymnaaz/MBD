const express = require('express');
const router = express.Router();
const pelangganController = require('../controllers/pelangganController');

router.post('/', pelangganController.create);
router.get('/', pelangganController.getAll);
router.get('/:id', pelangganController.getById);

module.exports = router;


// const express = require('express');
// const router = express.Router();

// const pelangganController = require('../controllers/pelangganController');

// // GET semua pelanggan melalui View
// router.get('/', pelangganController.getAll);

// // GET pelanggan berdasarkan ID melalui View
// router.get('/:id', pelangganController.getById);

// // POST pelanggan melalui Procedure
// router.post('/', pelangganController.create);

// // PUT pelanggan melalui Procedure
// router.put('/:id', pelangganController.update);

// // DELETE pelanggan melalui Procedure
// router.delete('/:id', pelangganController.remove);

// module.exports = router;
