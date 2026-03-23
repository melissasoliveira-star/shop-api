const db = require("../db");

async function findAllUsers() {
  const result = await db.query("SELECT * FROM usuarios ORDER BY id ASC");
  return result.rows;
}

async function findUserById(id) {
  const result = await db.query("SELECT * FROM usuarios WHERE id = $1", [id]);
  return result.rows[0] || null;
}

async function findUserByEmail(email) {
  const result = await db.query("SELECT * FROM usuarios WHERE email = $1", [
    email,
  ]);
  return result.rows[0] || null;
}

async function createUser({ nome, email }) {
  const result = await db.query(
    "INSERT INTO usuarios (nome, email) VALUES ($1, $2) RETURNING *;",
    [nome, email],
  );
  return result.rows[0];
}

async function updateUser(id, { nome, email }) {
  const query = `
    UPDATE usuarios
       SET nome  = COALESCE($1, nome),
           email = COALESCE($2, email)
     WHERE id = $3
 RETURNING *;
  `;
  const values = [nome || null, email || null, id];
  const result = await db.query(query, values);
  return result.rows[0] || null;
}

async function deleteUser(id) {
  const result = await db.query(
    "DELETE FROM usuarios WHERE id = $1 RETURNING *;",
    [id],
  );
  return result.rows[0] || null;
}

module.exports = {
  findAllUsers,
  findUserById,
  findUserByEmail,
  createUser,
  updateUser,
  deleteUser,
};
