// index.js
const express = require("express");
const app = express();
const port = 3000;

// garante que o db.js conecta
require("./db");

const userRoutes = require("./routes/userRoutes");

app.use(express.json());

// prefixo /api/users
app.use("/api/users", userRoutes);

app.listen(port, () => {
  console.log(`API rodando em http://localhost:${port}`);
});
