// index.js - Ponto de entrada da aplicação
const express = require("express"); // Importa o framework Express
const app = express(); // Cria a instância da aplicação
const port = 3000; // Define a porta em que a API irá rodar

// garante que o db.js conecta
require("./db");

const userRoutes = require("./routes/userRoutes"); // Importa as rotas de usuários

app.use(express.json()); // Middleware para interpretar o corpo das requisições como JSON

// prefixo /api/users
app.use("/api/users", userRoutes);

// Inicia o servidor e exibe o endereço no console
app.listen(port, () => {
  console.log(`API rodando em http://localhost:${port}`);
});
