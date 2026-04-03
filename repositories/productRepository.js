const db = require("../db");

async function findAllProducts({ page = 1, limit = 10 } = {}) {
  const offset = (page - 1) * limit;
  const result = await db.query(
    "SELECT * FROM produtos ORDER BY id ASC LIMIT $1 OFFSET $2",
    [limit, offset],
  );
  return result.rows;
}

async function findProductById(id) {
  const result = await db.query("SELECT * FROM produtos WHERE id = $1", [id]);
  return result.rows[0] || null;
}

async function findProductByNome(nome) {
  const result = await db.query(
    "SELECT * FROM produtos WHERE nome ILIKE $1 ORDER BY id ASC",
    [`%${nome}%`],
  );
  return result.rows;
}

async function createProduct({ nome, descricao, preco, estoque }) {
  const result = await db.query(
    "INSERT INTO produtos (nome, descricao, preco, estoque) VALUES ($1, $2, $3, $4) RETURNING *;",
    [nome, descricao, preco, estoque],
  );

  return result.rows[0];
}

async function updateProduct(id, { nome, descricao, preco, estoque }) {
  const query = `
    UPDATE produtos
      SET nome = COALESCE($1, nome),
      descricao = COALESCE($2, descricao),
      preco = COALESCE($3, preco),
      estoque = COALESCE($4, estoque)
    WHERE id = $5
  RETURNING *;
  `;

  const values = [
    nome || null,
    descricao || null,
    preco || null,
    estoque || null,
    id,
  ];

  const result = await db.query(query, values);
  return result.rows[0] || null;
}

async function deleteProduct(id) {
  const result = await db.query(
    "DELETE FROM produtos WHERE id = $1 RETURNING *;",
    [id],
  );

  return result.rows[0] || null;
}

module.exports = {
  findAllProducts,
  findProductById,
  findProductByNome,
  createProduct,
  updateProduct,
  deleteProduct,
};
