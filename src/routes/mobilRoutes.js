const express = require('express');
const router = express.Router();
const mobilController = require('../controllers/mobilController');

router.get('/', mobilController.getAll);
router.get('/:id', mobilController.getById);

module.exports = router;



// const express = require('express');
// const router = express.Router();

// const mobilController = require('../controllers/mobilController');

// // GET mobil tersedia
// router.get('/tersedia', mobilController.getAvailable);

// // GET semua mobil melalui View
// router.get('/', mobilController.getAll);

// // GET mobil berdasarkan ID melalui View
// router.get('/:id', mobilController.getById);

// // POST mobil melalui Procedure
// router.post('/', mobilController.create);

// // PUT mobil melalui Procedure
// router.put('/:id', mobilController.update);

// // DELETE mobil melalui Procedure
// router.delete('/:id', mobilController.remove);

// module.exports = router;
