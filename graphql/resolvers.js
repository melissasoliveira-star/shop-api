// graphql/resolvers.js
// Resolvers das queries (operações de leitura).

const userRepo = require("../repositories/userRepository");
const productRepo = require("../repositories/productRepository");
const orderRepo = require("../repositories/orderRepository");

const resolvers = {
  // ── Usuários ─────────────────────────────────────────────────────────────

  usuarios: async ({ page, limit }) => {
    const users = await userRepo.findAllUsers({
      page: page || 1,
      limit: limit || 5,
    });
    return users.map((u) => ({
      ...u,
      pedidos: () => orderRepo.findOrderByUsuarioId(u.id),
    }));
  },

  buscarUsuariosPorNome: async ({ nome }) => {
    const users = await userRepo.findUsersByNome(nome);
    return users.map((u) => ({
      ...u,
      pedidos: () => orderRepo.findOrderByUsuarioId(u.id),
    }));
  },

  usuario: async ({ id }) => {
    const u = await userRepo.findUserById(id);
    if (!u) return null;
    return {
      ...u,
      pedidos: () => orderRepo.findOrderByUsuarioId(u.id),
    };
  },

  // ── Produtos ──────────────────────────────────────────────────────────────

  produtos: async ({ page, limit }) =>
    productRepo.findAllProducts({ page: page || 1, limit: limit || 10 }),

  produto: async ({ id }) => productRepo.findProductById(id),

  buscarProdutosPorNome: async ({ nome }) =>
    productRepo.findProductByNome(nome),

  // ── Pedidos ───────────────────────────────────────────────────────────────

  pedidos: async ({ page, limit }) =>
    orderRepo.findAllOrders({ page: page || 1, limit: limit || 10 }),

  pedido: async ({ id }) => orderRepo.findOrderById(id),

  pedidoDetalhes: async ({ id }) => {
    const details = await orderRepo.findOrderDetailsById(id);
    if (!details) return null;
    return {
      ...details,
      usuario: () => userRepo.findUserById(details.usuario_id),
    };
  },

  pedidosPorUsuario: async ({ usuario_id }) =>
    orderRepo.findOrderByUsuarioId(usuario_id),
};

module.exports = resolvers;
