// src/routes/orderRoutes.js - Define as rotas HTTP para o recurso de pedidos
// Camada fina: apenas mapeia URL -> método do controller.
const express = require("express");
const router = express.Router();
const c = require("../controllers/orderController");

// GET /api/orders - Lista todos os pedidos
router.get("/", c.list);

// GET /api/orders/user/:id - Pedido pelo ID do usuário (usuario_id)
router.get("/user/:id", c.getByUsuarioId);

// GET /api/orders/:id/details - Detalhes do pedido (usuário + itens expandidos)
router.get("/:id/details", c.getDetails);

// GET /api/orders/:id - Busca um pedido pelo ID
router.get("/:id", c.getById);

// POST /api/orders - Cria um pedido
router.post("/", c.create);

// PUT /api/orders/:id - Atualiza um pedido existente
router.put("/:id", c.update);

// DELETE /api/orders/:id - Remove um pedido pelo ID
router.delete("/:id", c.remove);

module.exports = router;