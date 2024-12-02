require('dotenv').config();
const express = require('express');
const { sequelize } = require('./database');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');
const pistaRoutes = require('./routes/pistaRoutes');
const aeroportoRoutes = require('./routes/aeroportoRoutes');

const app = express();
app.use(express.json());

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
app.use('/pistas', pistaRoutes);
app.use('/aeroportos', aeroportoRoutes);

const PORT = process.env.PORT || 3000;

(async () => {
  try {
    await sequelize.authenticate();
    console.log('Conexão com o banco de dados estabelecida com sucesso.');
    await sequelize.sync({ alter: true });
    console.log('Modelos sincronizados com o banco de dados.');

    app.listen(PORT, () => {
      console.log(`Servidor rodando na porta ${PORT}`);
    });
  } catch (error) {
    console.error('Erro:', error);
  }
})();
