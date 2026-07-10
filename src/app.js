// src/app.js - Composição da aplicação Express (middlewares + rotas).
// Não chama listen() — isso fica em server.js para permitir reaproveitar o
// app em testes futuros sem abrir um socket.
require("dotenv").config();

const express = require("express");
const app = express();

// garante que config/db conecta
require("./config/db");

const userRoutes = require("./routes/userRoutes");
const productRoutes = require("./routes/productRoutes");
const orderRoutes = require("./routes/orderRoutes");
const mountGraphQL = require("./routes/graphql");

app.use(express.json()); // Middleware para interpretar o corpo das requisições como JSON

// prefixo /api/users
app.use("/api/users", userRoutes);

// prefixo /api/products
app.use("/api/products", productRoutes);

// prefixo /api/orders
app.use("/api/orders", orderRoutes);

// >>> ENDPOINT /graphql
mountGraphQL(app);

module.exports = app;