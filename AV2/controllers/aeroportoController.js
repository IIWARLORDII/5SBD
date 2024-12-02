const Aeroporto = require('../models/Aeroporto');

exports.createAeroporto = async (req, res) => {
  try {
    const aeroporto = await Aeroporto.create(req.body);
    res.status(201).json(aeroporto);
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
};

exports.getAeroportos = async (req, res) => {
  try {
    const aeroportos = await Aeroporto.findAll();
    res.status(200).json(aeroportos);
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
};

exports.updateAeroporto = async (req, res) => {
  try {
    const aeroporto = await Aeroporto.findByPk(req.params.id);
    if (aeroporto) {
      await aeroporto.update(req.body);
      res.status(200).json(aeroporto);
    } else {
      res.status(404).json({ mensagem: 'Aeroporto não encontrado' });
    }
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
};

exports.deleteAeroporto = async (req, res) => {
  try {
    const aeroporto = await Aeroporto.findByPk(req.params.id);
    if (aeroporto) {
      await aeroporto.destroy();
      res.status(200).json({ mensagem: 'Aeroporto deletado' });
    } else {
      res.status(404).json({ mensagem: 'Aeroporto não encontrado' });
    }
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
};