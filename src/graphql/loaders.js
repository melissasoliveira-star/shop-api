// src/graphql/loaders.js
const DataLoader = require("dataloader");
const userRepo = require("../models/userRepository");
const orderRepo = require("../models/orderRepository");

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