const DataLoader = require("dataloader");
const userRepo = require("../repositories/userRepository");
const orderRepo = require("../repositories/orderRepository");

function createLoaders() {
  return {
    itemsByPedidoLoader: new DataLoader(async (pedidoIds) =>
      orderRepo.findItemsByPedidoIds(pedidoIds),
    ),

    pedidosByUsuarioLoader: new DataLoader(async (usuarioIds) =>
      orderRepo.findOrdersByUsuarioIds(usuarioIds),
    ),

    userLoader: new DataLoader(async (userIds) => {
      const users = await Promise.all(
        userIds.map((id) => userRepo.findUserById(id)),
      );
      return users;
    }),
  };
}

module.exports = { createLoaders };
