const db = require("../db");

async function findAllProducts() {
  const result = await db.query("SELECT * FROM produtos ORDER BY id ASC");
  return result.rows;
}

async function findProductById(id) {
  const result = await db.query("SELECT * FROM produtos WHERE id = $1", [id]);
  return result.rows[0] || null;
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
  createProduct,
  updateProduct,
  deleteProduct,
};
