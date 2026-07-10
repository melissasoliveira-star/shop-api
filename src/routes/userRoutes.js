// src/routes/userRoutes.js - Define as rotas HTTP para o recurso de usuários
// Camada fina: apenas mapeia URL -> método do controller.
const express = require("express");
const router = express.Router();
const c = require("../controllers/userController");

// GET /api/users?nome=João&email=x - Lista todos, ou filtra por nome e/ou email
router.get("/", c.list);

// GET /api/users/:id/orders - Pedido pelo ID do usuário (usuario_id)
router.get("/:id/orders", c.listOrdersByUser);

// GET /api/users/:id - Busca um usuário pelo ID
router.get("/:id", c.getById);

// POST /api/users - Cria um novo usuário
router.post("/", c.create);

// PUT /api/users/:id - Atualiza os dados de um usuário existente
router.put("/:id", c.update);

// DELETE /api/users/:id - Remove um usuário pelo ID
router.delete("/:id", c.remove);

module.exports = router;