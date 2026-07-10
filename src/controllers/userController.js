// src/controllers/userController.js
// Controller do recurso de usuários.
// Recebe req/res, valida entradas, chama o model e traduz erros do Postgres em
// status HTTP apropriados. Nenhuma regra de SQL vive aqui.

const userRepo = require("../models/userRepository");
const orderRepo = require("../models/orderRepository");

// GET /api/users?nome=João&email=x
// Lista todos, ou filtra por nome e/ou email se informados
exports.list = async (req, res) => {
  try {
    const { nome, email } = req.query;
    let users;
    if (nome) {
      users = await userRepo.findUsersByNome(nome);
    } else if (email) {
      users = await userRepo.findUserByEmail(email);
      users = users ? [users] : [];
    } else {
      const page = parseInt(req.query.page) || 1;
      const limit = Math.min(parseInt(req.query.limit) || 10, 100);

      users = await userRepo.findAllUsers({ page, limit });
    }
    return res.json(users);
  } catch (err) {
    console.error("Erro ao buscar usuários:", err);
    res.status(500).send("Erro interno do servidor");
  }
};

// GET /api/users/:id/orders
// Retorna um pedido pelo ID do usuário (usuario_id)
// Responde com 404 se o pedido não for encontrado
exports.listOrdersByUser = async (req, res) => {
  try {
    const order = await orderRepo.findOrderByUsuarioId(req.params.id);
    if (!order)
      return res.status(404).json({ message: "Pedido não encontrado" });
    return res.json(order);
  } catch (err) {
    console.error("Erro ao buscar pedido:", err);
    res.status(500).send("Erro interno do servidor");
  }
};

// GET /api/users/:id - Busca um usuário pelo ID
exports.getById = async (req, res) => {
  try {
    const user = await userRepo.findUserById(req.params.id); // Usa o ID da URL
    if (!user)
      return res.status(404).json({ message: "Usuário não encontrado" }); // 404 se não existir
    return res.json(user);
  } catch (err) {
    console.error("Erro ao buscar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
};

// POST /api/users - Cria um novo usuário
exports.create = async (req, res) => {
  const { nome, email, senha } = req.body; // Extrai os dados do corpo da requisição

  // Valida se os campos obrigatórios foram enviados
  if (!nome || !email || !senha) {
    return res.status(400).json({ error: "Nome e e-mail são obrigatórios." });
  }

  try {
    const user = await userRepo.createUser({ nome, email, senha }); // Persiste o novo usuário
    return res.status(201).json(user); // 201 Created com os dados do usuário criado
  } catch (err) {
    if (err.code === "23505") {
      // Código PostgreSQL para violação de unicidade (e-mail duplicado)
      return res.status(409).json({ error: "Este e-mail já está registrado." });
    }
    console.error("Erro ao criar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
};

// PUT /api/users/:id - Atualiza os dados de um usuário existente
exports.update = async (req, res) => {
  const { nome, email } = req.body; // Extrai os campos a atualizar do corpo da requisição

  try {
    const user = await userRepo.updateUser(req.params.id, { nome, email }); // Atualiza no banco
    if (!user)
      return res.status(404).json({ message: "Usuário não encontrado" }); // 404 se não existir
    return res.json(user); // Retorna o usuário com os dados atualizados
  } catch (err) {
    console.error("Erro ao atualizar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
};

// DELETE /api/users/:id - Remove um usuário pelo ID
exports.remove = async (req, res) => {
  try {
    const deleted = await userRepo.deleteUser(req.params.id); // Tenta remover o usuário

    if (!deleted) {
      return res.status(404).json({ message: "Usuário não encontrado" }); // 404 se não existir
    }

    return res.json({ message: "Usuário removido", dados: deleted }); // Retorna os dados do removido
  } catch (err) {
    if (err.code === "23503") {
      // Código PostgreSQL para violação de chave estrangeira (usuário com pedidos)
      return res.status(400).json({
        message:
          "Não é possível apagar: este usuário possui pedidos registrados.",
      });
    }
    console.error("Erro ao apagar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
};