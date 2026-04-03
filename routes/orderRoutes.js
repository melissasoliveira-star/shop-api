// Importa o framework Express para criação das rotas
const express = require("express");

// Cria uma instância do roteador do Express para definir as rotas de pedido
const router = express.Router();

// Importa o repositório de pedidos, responsável pela comunicação com o banco de dados
const orderRepo = require("../repositories/orderRepository");

// GET /api/orders
// Retorna a lista de todos os pedidos cadastrados
router.get("/", async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 5;

    const orders = await orderRepo.findAllOrders({ page, limit });
    return res.json(orders);
  } catch (err) {
    console.error("Erro ao buscar pedidos:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// GET /api/orders/user/:id
// Retorna um pedido pelo ID do usuário (usuario_id)
// Responde com 404 se o pedido não for encontrado
router.get("/user/:id", async (req, res) => {
  try {
    const order = await orderRepo.findOrderByUsuarioId(req.params.id);
    if (!order)
      return res.status(404).json({ message: "Pedido não encontrado" });
    return res.json(order);
  } catch (err) {
    console.error("Erro ao buscar pedido:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

router.get("/:id/details", async (req, res) => {
  try {
    const orderDetails = await orderRepo.findOrderDetailsById(req.params.id);

    if (!orderDetails) {
      return res.status(404).json({ message: "Pedido não encontrado" });
    }

    return res.json(orderDetails);
  } catch (err) {
    console.error("Erro ao buscar detalhes do pedido:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// GET /api/orders/:id
// Retorna um pedido específico pelo seu ID
// Responde com 404 se o pedido não for encontrado
router.get("/:id", async (req, res) => {
  try {
    const order = await orderRepo.findOrderById(req.params.id);
    if (!order)
      return res.status(404).json({ message: "Pedido não encontrado" });
    return res.json(order);
  } catch (err) {
    console.error("Erro ao buscar pedido:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// POST /api/orders/
// Cria um pedido e retorna o pedido criado para o usuário
// Responde com 500 se não puder criar
router.post("/", async (req, res) => {
  const { usuario_id, total, data_pedido } = req.body;

  if (!usuario_id || !total || !data_pedido) {
    return res.status(400).json({
      error: "Id do usuário, valor do pedido e data são obrigatórios.",
    });
  }

  try {
    const order = await orderRepo.createOrder({
      usuario_id,
      total,
      data_pedido,
    });
    return res.status(201).json(order);
  } catch (err) {
    console.error("Erro ao criar pedido:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// PUT /api/orders/:id
// Atualiza os dados de um pedido existente pelo seu ID
// Apenas os campos enviados no corpo serão alterados (os demais mantêm o valor atual)
// Responde com 404 se o pedido não for encontrado
router.put("/:id", async (req, res) => {
  const { total, data_pedido } = req.body;

  try {
    const order = await orderRepo.updateOrder(req.params.id, {
      total,
      data_pedido,
    });

    if (!order)
      return res.status(404).json({ message: "Pedido não encontrado" });

    return res.json(order);
  } catch (err) {
    console.error("Erro ao atualizar pedido:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// DELETE /api/orders/:id
// Remove um pedido pelo seu ID
// Responde com 404 se o pedido não for encontrado
// Responde com 400 se o pedido possuir itens vinculados (violação de chave estrangeira)
router.delete("/:id", async (req, res) => {
  try {
    const deleted = await orderRepo.deleteOrder(req.params.id);

    if (!deleted) {
      return res.status(404).json({ message: "Pedido não encontrado" });
    }

    return res.json({ message: "Pedido removido", dados: deleted });
  } catch (err) {
    if (err.code === "23503") {
      return res.status(400).json({
        message: "Não é possível apagar: este pedido possui pedidos vínculos.",
      });
    }
    console.error("Erro ao apagar pedido:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// Exporta o roteador para ser utilizado na aplicação principal
module.exports = router;
