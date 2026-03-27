// routes/userRoutes.js - Define as rotas HTTP para o recurso de usuários
const express = require("express");
const router = express.Router(); // Cria um roteador isolado do Express
const userRepo = require("../repositories/userRepository"); // Importa o repositório de usuários

// GET /api/users - Lista todos os usuários
router.get("/", async (req, res) => {
  try {
    const users = await userRepo.findAllUsers(); // Busca todos os usuários no banco
    return res.json(users); // Retorna a lista em formato JSON
  } catch (err) {
    console.error("Erro ao buscar usuários:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// GET /api/users/:id - Busca um usuário pelo ID
router.get("/:id", async (req, res) => {
  try {
    const user = await userRepo.findUserById(req.params.id); // Usa o ID da URL
    if (!user)
      return res.status(404).json({ message: "Usuário não encontrado" }); // 404 se não existir
    return res.json(user);
  } catch (err) {
    console.error("Erro ao buscar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// GET /api/users/filter/:email - Busca um usuário pelo e-mail
router.get("/filter/:email", async (req, res) => {
  try {
    const user = await userRepo.findUserByEmail(req.params.email); // Usa o e-mail da URL
    if (!user)
      return res.status(404).json({ message: "Usuário não encontrado" }); // 404 se não existir
    return res.json(user);
  } catch (err) {
    console.error("Erro ao buscar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// POST /api/users - Cria um novo usuário
router.post("/", async (req, res) => {
  const { nome, email } = req.body; // Extrai os dados do corpo da requisição

  // Valida se os campos obrigatórios foram enviados
  if (!nome || !email) {
    return res.status(400).json({ error: "Nome e e-mail são obrigatórios." });
  }

  try {
    const user = await userRepo.createUser({ nome, email }); // Persiste o novo usuário
    return res.status(201).json(user); // 201 Created com os dados do usuário criado
  } catch (err) {
    if (err.code === "23505") {
      // Código PostgreSQL para violação de unicidade (e-mail duplicado)
      return res.status(409).json({ error: "Este e-mail já está registrado." });
    }
    console.error("Erro ao criar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// PUT /api/users/:id - Atualiza os dados de um usuário existente
router.put("/:id", async (req, res) => {
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
});

// DELETE /api/users/:id - Remove um usuário pelo ID
router.delete("/:id", async (req, res) => {
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
});

module.exports = router; // Exporta o roteador para uso no index.js
