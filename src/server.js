// src/server.js - Ponto de entrada da aplicação.
// Carrega variáveis de ambiente, importa o app Express e abre o servidor.
require("dotenv").config();

const app = require("./app");
const port = Number(process.env.PORT) || 3000;

app.listen(port, () => {
  console.log(`API rodando em http://localhost:${port}/api`);
  console.log(`API GraphQL rodando em http://localhost:${port}/graphql`);
});