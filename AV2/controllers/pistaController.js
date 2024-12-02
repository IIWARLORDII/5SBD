const Pista = require('../models/Pista');
const Aeroporto = require('../models/Aeroporto');

exports.createPista = async (req, res) => {
  try {
    const pista = await Pista.criarPista(req.body);
    res.status(201).json(pista);
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
};

exports.getPistas = async (req, res) => {
  try {
    const pistas = await Pista.listarPistas();
    res.status(200).json(pistas);
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
};

exports.getPistaById = async (req, res) => {
  try {
    const pista = await Pista.findByPk(req.params.id, {
      include: { model: Aeroporto, as: 'aeroporto' },
    });
    if (pista) {
      res.status(200).json(pista);
    } else {
      res.status(404).json({ mensagem: 'Pista não encontrada' });
    }
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
};

exports.updatePista = async (req, res) => {
  try {
    const pista = await Pista.atualizarPista(req.params.id, req.body);
    if (pista) {
      res.status(200).json(pista);
    } else {
      res.status(404).json({ mensagem: 'Pista não encontrada' });
    }
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
};

exports.deletePista = async (req, res) => {
  try {
    const pista = await Pista.deletarPista(req.params.id);
    if (pista) {
      res.status(200).json({ mensagem: 'Pista deletada' });
    } else {
      res.status(404).json({ mensagem: 'Pista não encontrada' });
    }
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
};