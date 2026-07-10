// src/routes/productRoutes.js - Define as rotas HTTP para o recurso de produtos
// Camada fina: apenas mapeia URL -> método do controller.
const express = require("express");
const router = express.Router();
const c = require("../controllers/productController");

// GET /api/products - Lista todos os produtos (ou filtra por nome)
router.get("/", c.list);

// GET /api/products/:id - Busca um produto pelo ID
router.get("/:id", c.getById);

// POST /api/products - Cria um produto
router.post("/", c.create);

// PUT /api/products/:id - Atualiza um produto existente
router.put("/:id", c.update);

// DELETE /api/products/:id - Remove um produto pelo ID
router.delete("/:id", c.remove);

module.exports = router;