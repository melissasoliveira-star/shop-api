// graphql/schema.js
// Define o schema GraphQL (tipos e campos) e os resolvers (rootValue) da API.

const { buildSchema } = require("graphql");

// Repositórios que encapsulam as queries ao banco de dados
const userRepo = require("../repositories/userRepository");
const productRepo = require("../repositories/productRepository");
const orderRepo = require("../repositories/orderRepository");

// ─── Type Definitions ────────────────────────────────────────────────────────
// O schema é definido em SDL (Schema Definition Language).
// Tipos com "!" são obrigatórios (non-nullable).

const schema = buildSchema(`
  # Representa um usuário cadastrado no sistema
  type Usuario {
    id: ID!
    nome: String!
    email: String!
    criado_em: String
    pedidos: [Pedido]       # Lista de pedidos feitos pelo usuário (resolvida lazily)
  }

  # Representa um produto disponível no catálogo
  type Produto {
    id: ID!
    nome: String!
    descricao: String
    preco: Float!
    estoque: Int
    criado_em: String
  }

  # Representa um item dentro de um pedido (produto + quantidade + preço na época)
  type ItemPedido {
    id: ID!
    produto_id: ID!
    quantidade: Int!
    preco_unitario: Float!
    produto: Produto        # Produto associado ao item (resolvido lazily)
  }

  # Representa um pedido feito por um usuário
  type Pedido {
    id: ID!
    usuario_id: ID!
    total: Float!
    data_pedido: String
    usuario: Usuario        # Usuário dono do pedido (resolvido lazily)
    itens: [ItemPedido]     # Itens que compõem o pedido
  }

  # ── Queries ──────────────────────────────────────────────────────────────
  # Operações de leitura. Parâmetros page/limit permitem paginação.

  type Query {
    # Usuários
    usuarios(page: Int, limit: Int): [Usuario]        # Lista paginada de usuários
    buscarUsuariosPorNome(nome: String!): [Usuario]   # Pesquisa usuários pelo nome (parcial)
    usuario(id: ID!): Usuario                         # Busca um usuário pelo ID

    # Produtos
    produtos(page: Int, limit: Int): [Produto]        # Lista paginada de produtos
    produto(id: ID!): Produto                         # Busca um produto pelo ID
    buscarProdutosPorNome(nome: String!): [Produto]   # Pesquisa produtos pelo nome (parcial)

    # Pedidos
    pedidos(page: Int, limit: Int): [Pedido]        # Lista paginada de pedidos
    pedido(id: ID!): Pedido                         # Busca um pedido pelo ID
    pedidoDetalhes(id: ID!): Pedido                 # Pedido com usuário e itens expandidos
    pedidosPorUsuario(usuario_id: ID!): [Pedido]    # Todos os pedidos de um usuário
  }

  # ── Mutations ─────────────────────────────────────────────────────────────
  # Operações de escrita (criar, atualizar, deletar).
  # Retornam o registro afetado após a operação.

  type Mutation {
    # Usuários
    criarUsuario(nome: String!, email: String!): Usuario
    atualizarUsuario(id: ID!, nome: String, email: String): Usuario
    deletarUsuario(id: ID!): Usuario

    # Produtos
    criarProduto(nome: String!, descricao: String, preco: Float!, estoque: Int): Produto
    atualizarProduto(id: ID!, nome: String, descricao: String, preco: Float, estoque: Int): Produto
    deletarProduto(id: ID!): Produto

    # Pedidos
    criarPedido(usuario_id: ID!, total: Float!, data_pedido: String): Pedido
    atualizarPedido(id: ID!, total: Float, data_pedido: String): Pedido
    deletarPedido(id: ID!): Pedido
  }
`);

// ─── Resolvers ────────────────────────────────────────────────────────────────
// rootValue mapeia cada campo de Query/Mutation para sua função resolutora.
// Campos de relacionamento (pedidos, usuario) são retornados como funções
// para que o GraphQL só os busque quando forem solicitados pelo cliente.

const rootValue = {
  // ── Queries: Usuários ────────────────────────────────────────────────────

  // Retorna lista paginada de usuários; cada um carrega pedidos lazily
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

  // Pesquisa usuários cujo nome contenha o termo informado (case-insensitive)
  buscarUsuariosPorNome: async ({ nome }) => {
    const users = await userRepo.findUsersByNome(nome);
    return users.map((u) => ({
      ...u,
      pedidos: () => orderRepo.findOrderByUsuarioId(u.id),
    }));
  },

  // Retorna um único usuário pelo ID, com pedidos carregados lazily
  usuario: async ({ id }) => {
    const u = await userRepo.findUserById(id);
    if (!u) return null;
    return {
      ...u,
      pedidos: () => orderRepo.findOrderByUsuarioId(u.id),
    };
  },

  // ── Queries: Produtos ────────────────────────────────────────────────────

  // Retorna lista paginada de produtos
  produtos: async ({ page, limit }) =>
    productRepo.findAllProducts({ page: page || 1, limit: limit || 10 }),

  // Retorna um único produto pelo ID
  produto: async ({ id }) => productRepo.findProductById(id),

  // Pesquisa produtos cujo nome contenha o termo informado (case-insensitive)
  buscarProdutosPorNome: async ({ nome }) =>
    productRepo.findProductByNome(nome),

  // ── Queries: Pedidos ─────────────────────────────────────────────────────

  // Retorna lista paginada de pedidos
  pedidos: async ({ page, limit }) =>
    orderRepo.findAllOrders({ page: page || 1, limit: limit || 10 }),

  // Retorna um único pedido pelo ID
  pedido: async ({ id }) => orderRepo.findOrderById(id),

  // Retorna pedido com detalhes completos: itens incluídos e usuário carregado lazily
  pedidoDetalhes: async ({ id }) => {
    const details = await orderRepo.findOrderDetailsById(id);
    if (!details) return null;
    return {
      ...details,
      usuario: () => userRepo.findUserById(details.usuario_id),
    };
  },

  // Retorna todos os pedidos de um usuário específico
  pedidosPorUsuario: async ({ usuario_id }) =>
    orderRepo.findOrderByUsuarioId(usuario_id),

  // ── Mutations: Usuários ───────────────────────────────────────────────────

  criarUsuario: async ({ nome, email }) => userRepo.createUser({ nome, email }),

  atualizarUsuario: async ({ id, nome, email }) =>
    userRepo.updateUser(id, { nome, email }),

  deletarUsuario: async ({ id }) => userRepo.deleteUser(id),

  // ── Mutations: Produtos ───────────────────────────────────────────────────

  criarProduto: async ({ nome, descricao, preco, estoque }) =>
    productRepo.createProduct({ nome, descricao, preco, estoque }),

  atualizarProduto: async ({ id, nome, descricao, preco, estoque }) =>
    productRepo.updateProduct(id, { nome, descricao, preco, estoque }),

  deletarProduto: async ({ id }) => productRepo.deleteProduct(id),

  // ── Mutations: Pedidos ────────────────────────────────────────────────────

  criarPedido: async ({ usuario_id, total, data_pedido }) =>
    orderRepo.createOrder({ usuario_id, total, data_pedido }),

  atualizarPedido: async ({ id, total, data_pedido }) =>
    orderRepo.updateOrder(id, { total, data_pedido }),

  deletarPedido: async ({ id }) => orderRepo.deleteOrder(id),
};

module.exports = { schema, rootValue };
