// graphql/schema.js
// Define o schema GraphQL (SDL) e combina resolvers e mutations no rootValue.

const { buildSchema } = require("graphql");
const resolvers = require("./resolvers");
const mutations = require("./mutations");

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

const rootValue = { ...resolvers, ...mutations };

module.exports = { schema, rootValue };
