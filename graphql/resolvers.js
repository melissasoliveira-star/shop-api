// graphql/resolvers.js
// Resolvers das queries (operações de leitura).

const userRepo = require("../repositories/userRepository");
const productRepo = require("../repositories/productRepository");
const orderRepo = require("../repositories/orderRepository");

function hydratePedido(order) {
  if (!order) return null;

  return {
    ...order,
    usuario: () => userRepo.findUserById(order.usuario_id),
    itens: () => orderRepo.findItemsByPedidoId(order.id),
  };
}

const resolvers = {
  // ── Usuários ─────────────────────────────────────────────────────────────

  usuarios: async ({ page, limit }) => {
    const users = await userRepo.findAllUsers({
      page: page || 1,
      limit: limit || 10,
    });
    return users.map((u) => ({
      ...u,
      pedidos: async () =>
        (await orderRepo.findOrderByUsuarioId(u.id) ?? []).map(hydratePedido),
    }));
  },

  buscarUsuariosPorNome: async ({ nome }) => {
    const users = await userRepo.findUsersByNome(nome);
    return users.map((u) => ({
      ...u,
      pedidos: async () =>
        (await orderRepo.findOrderByUsuarioId(u.id) ?? []).map(hydratePedido),
    }));
  },

  usuario: async ({ id }) => {
    const u = await userRepo.findUserById(id);
    if (!u) return null;
    return {
      ...u,
      pedidos: async () =>
        (await orderRepo.findOrderByUsuarioId(u.id) ?? []).map(hydratePedido),
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
    (await orderRepo.findAllOrders({ page: page || 1, limit: limit || 10 })).map(
      hydratePedido,
    ),

  pedido: async ({ id }) => hydratePedido(await orderRepo.findOrderById(id)),

  pedidoDetalhes: async ({ id }) => {
    const details = await orderRepo.findOrderDetailsById(id);
    if (!details) return null;
    return {
      ...details,
      usuario: () => userRepo.findUserById(details.usuario_id),
    };
  },

  pedidosPorUsuario: async ({ usuario_id }) =>
    (await orderRepo.findOrderByUsuarioId(usuario_id)).map(hydratePedido),
};

module.exports = resolvers;
