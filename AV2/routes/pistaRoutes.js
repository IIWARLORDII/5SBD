const express = require('express');
const router = express.Router();
const pistaController = require('../controllers/pistaController');

router.post('/', pistaController.createPista);
router.get('/', pistaController.getPistas);
router.get('/:id', pistaController.getPistaById);
router.put('/:id', pistaController.updatePista);
router.delete('/:id', pistaController.deletePista);

module.exports = router;