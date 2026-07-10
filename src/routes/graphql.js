// src/routes/graphql.js - Monta o endpoint GraphQL na aplicação.
// Recebe o app Express e registra o /graphql com o schema e o contexto de loaders.
const { graphqlHTTP } = require("express-graphql");
const { schema, rootValue } = require("../graphql/schema");
const { createLoaders } = require("../graphql/loaders");

module.exports = function mountGraphQL(app) {
  app.use(
    "/graphql",
    graphqlHTTP((req) => ({
      schema,
      rootValue,
      graphiql: process.env.NODE_ENV !== "production", // habilita UI de testes em /graphql
      context: { loaders: createLoaders() }, // novo a cada requisição
    })),
  );
};