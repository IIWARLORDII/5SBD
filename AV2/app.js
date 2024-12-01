require('dotenv').config();
const { sequelize } = require('./database');
const Aeroporto = require('./models/Aeroporto');
const Pista = require('./models/Pista');

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

    // READ
    await Pista.listarPistas();

    // DELETE
    await Pista.deletarPista('P5-GRU');

  } catch (error) {
    console.error('Erro:', error);
  } finally {
    await sequelize.close();
    console.log('Conexão encerrada.');
  }
})();
