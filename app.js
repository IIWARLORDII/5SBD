const { Sequelize, DataTypes, Model } = require('sequelize');

// Configuração da conexão com o banco de dados
const sequelize = new Sequelize('5sbd_av2', 'root', '', {
  host: 'localhost',
  dialect: 'mysql',
});

// Definição do modelo Aeroporto
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

// Definição do modelo Pista
class Pista extends Model {
  // Método para criar uma nova pista
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

  // Método para listar todas as pistas
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

  // Método para atualizar uma pista
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

  // Método para deletar uma pista
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

// Relacionamento entre Pista e Aeroporto
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

// Função principal para testar os métodos
(async () => {
  try {
    // Conectar ao banco
    await sequelize.authenticate();
    console.log('Conexão com o banco de dados estabelecida com sucesso.');

    // Sincronizar os modelos (não altera aeroportos)
    await sequelize.sync({ alter: true });
    console.log('Modelos sincronizados com o banco de dados.');

    // Testando os métodos de Pista
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
    // Fechar conexão com o banco
    await sequelize.close();
    console.log('Conexão encerrada.');
  }
})();
