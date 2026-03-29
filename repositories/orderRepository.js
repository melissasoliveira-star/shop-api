const db = require("../db");

async function findAllOrders() {
  const result = await db.query("SELECT * FROM pedidos ORDER BY id ASC");
  return result.rows;
}

async function findOrderById(id) {
  const result = await db.query("SELECT * FROM pedidos WHERE id = $1", [id]);
  return result.rows[0] || null;
}

async function createOrder({ usuario_id, total, data_pedido }) {
  const result = await db.query(
    "INSERT INTO pedidos (usuario_id, total, data_pedido) VALUES ($1, $2, $3) RETURNING *;",
    [usuario_id, total, data_pedido],
  );

  return result.rows[0];
}

async function updateOrder(id, { total, data_pedido }) {
  const query = `
    UPDATE pedidos
      SET total = COALESCE($1, total),
      data_pedido = COALESCE($2, data_pedido)
    WHERE id = $3
  RETURNING *;
  `;

  const values = [total || null, data_pedido || null, id];

  const result = await db.query(query, values);
  return result.rows[0] || null;
}

async function deleteOrder(id) {
  const result = await db.query(
    "DELETE FROM pedidos WHERE id = $1 RETURNING *;",
    [id],
  );

  return result.rows[0] || null;
}

module.exports = {
  findAllOrders,
  findOrderById,
  createOrder,
  updateOrder,
  deleteOrder,
};
