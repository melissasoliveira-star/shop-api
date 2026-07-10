// src/graphql/resolvers.js
// Resolvers das queries (operações de leitura).

const userRepo = require("../models/userRepository");
const productRepo = require("../models/productRepository");
const orderRepo = require("../models/orderRepository");

function hydratePedido(order, loaders) {
  if (!order) return null;

  return {
    ...order,
    usuario: () => loaders.userLoader.load(order.usuario_id),
    itens: () => loaders.itemsByPedidoLoader.load(order.id),
  };
}

const resolvers = {
  // ── Usuários ─────────────────────────────────────────────────────────────

  usuarios: async ({ page, limit }, context) => {
    const users = await userRepo.findAllUsers({
      page: page || 1,
      limit: limit || 10,
    });
    return users.map((u) => ({
      ...u,
      pedidos: async () =>
        ((await context.loaders.pedidosByUsuarioLoader.load(u.id)) ?? []).map(
          (p) => hydratePedido(p, context.loaders),
        ),
    }));
  },

  buscarUsuariosPorNome: async ({ nome }, context) => {
    const users = await userRepo.findUsersByNome(nome);
    return users.map((u) => ({
      ...u,
      pedidos: async () =>
        ((await context.loaders.pedidosByUsuarioLoader.load(u.id)) ?? []).map(
          (p) => hydratePedido(p, context.loaders),
        ),
    }));
  },

  usuario: async ({ id }, context) => {
    const u = await userRepo.findUserById(id);
    if (!u) return null;
    return {
      ...u,
      pedidos: async () =>
        ((await context.loaders.pedidosByUsuarioLoader.load(u.id)) ?? []).map(
          (p) => hydratePedido(p, context.loaders),
        ),
    };
  },

  // ── Produtos ──────────────────────────────────────────────────────────────

  produtos: async ({ page, limit }) =>
    productRepo.findAllProducts({ page: page || 1, limit: limit || 10 }),

  produto: async ({ id }) => productRepo.findProductById(id),

  buscarProdutosPorNome: async ({ nome }) =>
    productRepo.findProductByNome(nome),

  // ── Pedidos ───────────────────────────────────────────────────────────────

  pedidos: async ({ page, limit }, context) =>
    (
      await orderRepo.findAllOrders({ page: page || 1, limit: limit || 10 })
    ).map((p) => hydratePedido(p, context.loaders)),

  pedido: async ({ id }, context) =>
    hydratePedido(await orderRepo.findOrderById(id), context.loaders),

  pedidoDetalhes: async ({ id }) => {
    const details = await orderRepo.findOrderDetailsById(id);
    if (!details) return null;
    return {
      ...details,
      usuario: () => userRepo.findUserById(details.usuario_id),
    };
  },

  pedidosPorUsuario: async ({ usuario_id }, context) =>
    (await orderRepo.findOrderByUsuarioId(usuario_id)).map((p) =>
      hydratePedido(p, context.loaders),
    ),
};

module.exports = resolvers;