const db = require("../db"); // Importa a conexão com o banco de dados

// Retorna todos os usuários ordenados por ID crescente
async function findAllUsers({ page = 1, limit = 10 } = {}) {
  const offset = (page - 1) * limit;
  const result = await db.query(
    "SELECT * FROM usuarios ORDER BY id ASC  LIMIT $1 OFFSET $2",
    [limit, offset],
  );
  return result.rows; // Retorna o array de usuários
}

// Retorna um único usuário pelo ID, ou null se não encontrado
async function findUserById(id) {
  const result = await db.query("SELECT * FROM usuarios WHERE id = $1", [id]);
  return result.rows[0] || null; // Retorna o primeiro resultado ou null
}

// Retorna um único usuário pelo e-mail, ou null se não encontrado
async function findUserByEmail(email) {
  const result = await db.query("SELECT * FROM usuarios WHERE email = $1", [
    email,
  ]);
  return result.rows[0] || null; // Retorna o primeiro resultado ou null
}

// Retorna usuários cujo nome contenha o termo buscado (case-insensitive)
async function findUsersByNome(nome) {
  const result = await db.query(
    "SELECT * FROM usuarios WHERE nome ILIKE $1 ORDER BY id ASC",
    [`%${nome}%`],
  );
  return result.rows;
}

// Insere um novo usuário no banco e retorna o registro criado
async function createUser({ nome, email }) {
  const result = await db.query(
    "INSERT INTO usuarios (nome, email) VALUES ($1, $2) RETURNING *;",
    [nome, email],
  );
  return result.rows[0]; // Retorna o usuário recém-criado
}

// Atualiza nome e/ou e-mail de um usuário existente; campos não enviados são mantidos
async function updateUser(id, { nome, email }) {
  const query = `
    UPDATE usuarios
       SET nome  = COALESCE($1, nome),
           email = COALESCE($2, email)
     WHERE id = $3
 RETURNING *;
  `;
  const values = [nome || null, email || null, id]; // Converte strings vazias para null
  const result = await db.query(query, values);
  return result.rows[0] || null; // Retorna o usuário atualizado ou null se não encontrado
}

// Remove um usuário pelo ID e retorna o registro excluído
async function deleteUser(id) {
  const result = await db.query(
    "DELETE FROM usuarios WHERE id = $1 RETURNING *;",
    [id],
  );
  return result.rows[0] || null; // Retorna o usuário removido ou null se não existia
}

// Exporta todas as funções do repositório
module.exports = {
  findAllUsers,
  findUsersByNome,
  findUserById,
  findUserByEmail,
  createUser,
  updateUser,
  deleteUser,
};
