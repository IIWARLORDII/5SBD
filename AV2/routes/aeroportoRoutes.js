
const express = require('express');
const router = express.Router();
const aeroportoController = require('../controllers/aeroportoController');

router.post('/', aeroportoController.createAeroporto);
router.get('/', aeroportoController.getAeroportos);
router.put('/:id', aeroportoController.updateAeroporto);
router.delete('/:id', aeroportoController.deleteAeroporto);

module.exports = router;