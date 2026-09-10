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

    userLoader: new DataLoader(async (userIds) =>
      userRepo.findUsersByIds(userIds),
    ),
  };
}

module.exports = { createLoaders };