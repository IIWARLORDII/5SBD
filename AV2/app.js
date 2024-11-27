require('dotenv').config();

const { Sequelize, DataTypes, Model } = require('sequelize');

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    dialect: process.env.DB_DIALECT,
  }
);

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

class Pista extends Model {
  static async criarPista(dados) {
    try {
      const pista = await Pista.create(dados);
      console.log(`Pista criada: ${pista.identificacao}`);
      return pista;
    } catch (error) {
      console.error('Erro ao criar pista:', error);
      throw error;
    }
  }

  static async listarPistas() {
    try {
      const pistas = await Pista.findAll({
        include: { model: Aeroporto, as: 'aeroporto' },
      });
      console.log('Pistas encontradas:');
      pistas.forEach(p => {
        console.log(`ID: ${p.identificacao}, Aeroporto: ${p.aeroporto.nome}, Comprimento: ${p.comprimento}, Largura: ${p.largura}, Status: ${p.status}`);
      });
      return pistas;
    } catch (error) {
      console.error('Erro ao listar pistas:', error);
      throw error;
    }
  }

  static async atualizarPista(identificacao, novosDados) {
    try {
      const pista = await Pista.findByPk(identificacao);
      if (!pista) {
        console.log(`Pista com identificação ${identificacao} não encontrada.`);
        return null;
      }
      await pista.update(novosDados);
      console.log(`Pista atualizada: ${pista.identificacao}`);
      return pista;
    } catch (error) {
      console.error('Erro ao atualizar pista:', error);
      throw error;
    }
  }

  static async deletarPista(identificacao) {
    try {
      const pista = await Pista.findByPk(identificacao);
      if (!pista) {
        console.log(`Pista com identificação ${identificacao} não encontrada.`);
        return null;
      }
      await pista.destroy();
      console.log(`Pista deletada: ${pista.identificacao}`);
      return pista;
    } catch (error) {
      console.error('Erro ao deletar pista:', error);
      throw error;
    }
  }
}

Pista.init({
  identificacao: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  comprimento: {
    type: DataTypes.FLOAT,
    allowNull: false,
  },
  largura: {
    type: DataTypes.FLOAT,
    allowNull: false,
  },
  status: {
    type: DataTypes.STRING,
    allowNull: false,
  },
}, {
  sequelize,
  tableName: 'pistas',
  timestamps: false,
});

Pista.belongsTo(Aeroporto, {
  foreignKey: {
    name: 'aeroportoCodigo',
    allowNull: false,
  },
  as: 'aeroporto',
});

Aeroporto.hasMany(Pista, {
  foreignKey: 'aeroportoCodigo',
  as: 'pistas',
});

// TESTE
(async () => {
  try {
    await sequelize.authenticate();
    console.log('Conexão com o banco de dados estabelecida com sucesso.');

    await sequelize.sync({ alter: true });
    console.log('Modelos sincronizados com o banco de dados.');

    // CREATE
    const novaPista = await Pista.criarPista({
      identificacao: 'P5-GRU',
      comprimento: 3800,
      largura: 45,
      status: 'Ativa',
      aeroportoCodigo: 'GRU',
    });

    // READ
    await Pista.listarPistas();

    // UPDATE
    await Pista.atualizarPista('P5-GRU', { status: 'Inativa' });

    // DELETE
    await Pista.deletarPista('P5-GRU');

  } catch (error) {
    console.error('Erro:', error);
  } finally {
    await sequelize.close();
    console.log('Conexão encerrada.');
  }
})();
