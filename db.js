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
  user: "postgres",   // Usuário do banco de dados
  host: "localhost",  // Endereço do servidor PostgreSQL
  database: "store",  // Nome do banco de dados
  password: "0509",   // Senha do usuário
  port: 5432,         // Porta padrão do PostgreSQL
  max: 10, // Máximo de 10 conexões simultâneas
});

// Conecta ao banco e exibe status no console
db.connect()
  .then(() => console.log("Conectado ao PostgreSQL com sucesso!"))
  .catch((err) => console.error("Erro ao conectar ao banco:", err));

module.exports = db; // Exporta a instância do pool para uso em outros módulos
