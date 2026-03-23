// Importa o framework Express para criar o servidor HTTP
const express = require("express");
const app = express();
const port = 3000;

// Importa o cliente PostgreSQL para conexão com o banco de dados
const { Pool } = require("pg");

// Middleware para interpretar requisições JSON no corpo (body)
app.use(express.json());

// Configuração de conexão com PostgreSQL
const db = new Pool({
  user: "postgres",
  host: "localhost",
  database: "store",
  password: "0509",
  port: 5432,
  max: 10, // Máximo de 10 conexões simultâneas
});

// Conecta ao banco e exibe status no console
db.connect()
  .then(() => console.log("Conectado ao PostgreSQL com sucesso!"))
  .catch((err) => console.error("Erro ao conectar ao banco:", err));

module.exports = db;
