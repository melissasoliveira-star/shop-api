// graphql/mutations.js
// Resolvers das mutations (operações de escrita: criar, atualizar, deletar).

const userRepo = require("../repositories/userRepository");
const productRepo = require("../repositories/productRepository");
const orderRepo = require("../repositories/orderRepository");

const mutations = {
  // ── Usuários ──────────────────────────────────────────────────────────────

  criarUsuario: async ({ nome, email }) => userRepo.createUser({ nome, email }),

  atualizarUsuario: async ({ id, nome, email }) =>
    userRepo.updateUser(id, { nome, email }),

  deletarUsuario: async ({ id }) => userRepo.deleteUser(id),

  // ── Produtos ──────────────────────────────────────────────────────────────

  criarProduto: async ({ nome, descricao, preco, estoque }) =>
    productRepo.createProduct({ nome, descricao, preco, estoque }),

  atualizarProduto: async ({ id, nome, descricao, preco, estoque }) =>
    productRepo.updateProduct(id, { nome, descricao, preco, estoque }),

  deletarProduto: async ({ id }) => productRepo.deleteProduct(id),

  // ── Pedidos ───────────────────────────────────────────────────────────────

  criarPedido: async ({ usuario_id, total, data_pedido }) =>
    orderRepo.createOrder({ usuario_id, total, data_pedido }),

  atualizarPedido: async ({ id, total, data_pedido }) =>
    orderRepo.updateOrder(id, { total, data_pedido }),

  deletarPedido: async ({ id }) => orderRepo.deleteOrder(id),
};

module.exports = mutations;
