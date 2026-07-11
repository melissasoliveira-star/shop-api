// src/routes/graphql.js - Monta o endpoint GraphQL na aplicação.
// Recebe o app Express e registra o /graphql com o schema e o contexto de loaders.
const { createHandler } = require("graphql-http/lib/use/express");
const { ruruHTML } = require("ruru/server");
const { serveStatic } = require("ruru/static");
const { schema, rootValue } = require("../graphql/schema");
const { createLoaders } = require("../graphql/loaders");

module.exports = function mountGraphQL(app) {
  if (process.env.NODE_ENV !== "production") {
    // UI de testes (equivalente ao GraphiQL do express-graphql), disponível em /graphiql
    app.use(serveStatic("/ruru-static/")); // mount at root: middleware matches on the full req.url
    app.get("/graphiql", (req, res) => {
      res.type("html").send(ruruHTML({ endpoint: "/graphql", staticPath: "/ruru-static/" }));
    });
  }

  app.all(
    "/graphql",
    createHandler({
      schema,
      rootValue,
      context: () => ({ loaders: createLoaders() }), // novo a cada requisição
    }),
  );
};