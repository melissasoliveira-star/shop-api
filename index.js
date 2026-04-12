require("dotenv").config();

// index.js - Ponto de entrada da aplicação
const express = require("express"); // Importa o framework Express
const app = express(); // Cria a instância da aplicação
const port = Number(process.env.PORT) || 3000; // Define a porta em que a API irá rodar

// garante que o db.js conecta
require("./db");

const userRoutes = require("./routes/userRoutes"); // Importa as rotas de usuários
const productRoutes = require("./routes/productRoutes"); // Importa as rotas de produtos
const orderRoutes = require("./routes/orderRoutes"); // Importa as rotas de produtos

// >>> IMPORTA GRAPHQL
const { graphqlHTTP } = require("express-graphql");
const { schema, rootValue } = require("./graphql/schema");

app.use(express.json()); // Middleware para interpretar o corpo das requisições como JSON

// prefixo /api/users
app.use("/api/users", userRoutes);

// prefixo /api/products
app.use("/api/products", productRoutes);

// prefixo /api/orders
app.use("/api/orders", orderRoutes);

// >>> ENDPOINT /graphql
app.use(
  "/graphql",
  graphqlHTTP({
    schema,
    rootValue,
    graphiql: true, // habilita UI de testes em /graphql
  }),
);

// Inicia o servidor e exibe o endereço no console
app.listen(port, () => {
  console.log(`API rodando em http://localhost:${port}/api`);
  console.log(`API GraphQL rodando em http://localhost:${port}/graphql`);
});
