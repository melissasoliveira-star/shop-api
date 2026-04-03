// Importa o framework Express para criar o servidor HTTP
const express = require("express");
const app = express(); // Cria a instância da aplicação Express
const port = 3000; // Porta padrão em que o servidor irá escutar

// Importa o cliente PostgreSQL para conexão com o banco de dados
const { Pool } = require("pg");

// Middleware para interpretar requisições JSON no corpo (body)
app.use(express.json());

// Configuração de conexão com PostgreSQL
const db = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: Number(process.env.DB_PORT),
  max: Number(process.env.DB_MAX),
});

// Conecta ao banco e exibe status no console
db.connect()
  .then(() => console.log("Conectado ao PostgreSQL com sucesso!"))
  .catch((err) => console.error("Erro ao conectar ao banco:", err));

module.exports = db; // Exporta a instância do pool para uso em outros módulos
