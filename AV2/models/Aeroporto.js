
const { DataTypes } = require('sequelize');
const { sequelize } = require('../database');

const Aeroporto = sequelize.define('Aeroporto', {
  codigo: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  nome: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  localizacao: {
    type: DataTypes.STRING,
    allowNull: false,
  },
}, {
  tableName: 'aeroportos',
  timestamps: false,
});

module.exports = Aeroporto;