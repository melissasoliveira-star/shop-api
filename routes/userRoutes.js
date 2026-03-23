// routes/userRoutes.js
const express = require("express");
const router = express.Router();
const userRepo = require("../repositories/userRepository");

// GET /api/users
router.get("/", async (req, res) => {
  try {
    const users = await userRepo.findAllUsers();
    return res.json(users);
  } catch (err) {
    console.error("Erro ao buscar usuários:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// GET /api/users/:id
router.get("/:id", async (req, res) => {
  try {
    const user = await userRepo.findUserById(req.params.id);
    if (!user)
      return res.status(404).json({ message: "Usuário não encontrado" });
    return res.json(user);
  } catch (err) {
    console.error("Erro ao buscar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// GET /api/users/filter/:email
router.get("/filter/:email", async (req, res) => {
  try {
    const user = await userRepo.findUserByEmail(req.params.email);
    if (!user)
      return res.status(404).json({ message: "Usuário não encontrado" });
    return res.json(user);
  } catch (err) {
    console.error("Erro ao buscar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// POST /api/users
router.post("/", async (req, res) => {
  const { nome, email } = req.body;

  if (!nome || !email) {
    return res.status(400).json({ error: "Nome e e-mail são obrigatórios." });
  }

  try {
    const user = await userRepo.createUser({ nome, email });
    return res.status(201).json(user);
  } catch (err) {
    if (err.code === "23505") {
      return res.status(409).json({ error: "Este e-mail já está registrado." });
    }
    console.error("Erro ao criar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// PUT /api/users/:id
router.put("/:id", async (req, res) => {
  const { nome, email } = req.body;

  try {
    const user = await userRepo.updateUser(req.params.id, { nome, email });
    if (!user)
      return res.status(404).json({ message: "Usuário não encontrado" });
    return res.json(user);
  } catch (err) {
    console.error("Erro ao atualizar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// DELETE /api/users/:id
router.delete("/:id", async (req, res) => {
  try {
    const deleted = await userRepo.deleteUser(req.params.id);

    if (!deleted) {
      return res.status(404).json({ message: "Usuário não encontrado" });
    }

    return res.json({ message: "Usuário removido", dados: deleted });
  } catch (err) {
    if (err.code === "23503") {
      return res.status(400).json({
        message:
          "Não é possível apagar: este usuário possui pedidos registrados.",
      });
    }
    console.error("Erro ao apagar usuário:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

module.exports = router;
