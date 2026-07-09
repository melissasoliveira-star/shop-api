const db = require("../db");

async function findAllOrders({ page = 1, limit = 10 } = {}) {
  const offset = (page - 1) * limit;
  const result = await db.query(
    "SELECT * FROM pedidos ORDER BY id ASC LIMIT $1 OFFSET $2",
    [limit, offset],
  );
  return result.rows;
}

async function findOrderById(id) {
  const result = await db.query("SELECT * FROM pedidos WHERE id = $1", [id]);
  return result.rows[0] || null;
}

async function findOrderByUsuarioId(id) {
  const result = await db.query("SELECT * FROM pedidos WHERE usuario_id = $1", [
    id,
  ]);

  return result.rows || [];
}

// Usada apenas para busca pontual (não otimizada para N chamadas em paralelo).
async function findItemsByPedidoId(id) {
  const query = `
    SELECT
      i.id,
      i.produto_id,
      i.quantidade,
      i.preco_unitario,
      pr.nome,
      pr.descricao,
      pr.preco,
      pr.estoque,
      pr.criado_em
    FROM itens_pedido i
    LEFT JOIN produtos pr ON pr.id = i.produto_id
    WHERE i.pedido_id = $1
    ORDER BY i.id ASC;
  `;

  const result = await db.query(query, [id]);

  return result.rows.map((row) => ({
    id: row.id,
    produto_id: row.produto_id,
    quantidade: row.quantidade,
    preco_unitario: row.preco_unitario,
    produto: row.produto_id
      ? {
          id: row.produto_id,
          nome: row.nome,
          descricao: row.descricao,
          preco: row.preco,
          estoque: row.estoque,
          criado_em: row.criado_em,
        }
      : null,
  }));
}

// Usada pela rota REST /api/orders/:id/details E pelo resolver GraphQL pedidoDetalhes.
// A partir desta versão, também traz os dados do usuário no mesmo JOIN (nome e email),
// para que REST e GraphQL devolvam exatamente o mesmo payload nesse cenário de comparação.
// O resolver GraphQL, propositalmente, ignora o campo "usuario" retornado aqui e faz sua
// própria busca separada via userRepo.findUserById — preservando o padrão natural de
// resolução por campo do GraphQL, que é o que este estudo quer medir.
async function findOrderDetailsById(id) {
  const query = `
    SELECT
      p.id AS pedido_id,
      p.usuario_id,
      p.total,
      p.data_pedido,
      u.nome AS usuario_nome,
      u.email AS usuario_email,
      i.id AS item_id,
      i.produto_id,
      i.quantidade,
      i.preco_unitario,
      pr.nome AS produto_nome,
      pr.descricao AS produto_descricao,
      pr.preco AS produto_preco_atual,
      pr.estoque AS produto_estoque
    FROM pedidos p
    LEFT JOIN usuarios u ON u.id = p.usuario_id
    LEFT JOIN itens_pedido i ON i.pedido_id = p.id
    LEFT JOIN produtos pr ON pr.id = i.produto_id
    WHERE p.id = $1
    ORDER BY i.id ASC;
  `;

  const result = await db.query(query, [id]);

  if (result.rows.length === 0) {
    return null;
  }

  const firstRow = result.rows[0];

  return {
    id: firstRow.pedido_id,
    usuario_id: firstRow.usuario_id,
    total: firstRow.total,
    data_pedido: firstRow.data_pedido,
    usuario: {
      id: firstRow.usuario_id,
      nome: firstRow.usuario_nome,
      email: firstRow.usuario_email,
    },
    itens: result.rows
      .filter((row) => row.item_id !== null)
      .map((row) => ({
        id: row.item_id,
        produto_id: row.produto_id,
        quantidade: row.quantidade,
        preco_unitario: row.preco_unitario,
        produto: {
          id: row.produto_id,
          nome: row.produto_nome,
          descricao: row.produto_descricao,
          preco: row.produto_preco_atual,
          estoque: row.produto_estoque,
        },
      })),
  };
}

// Usada pelo DataLoader (itemsByPedidoLoader) para agrupar buscas de múltiplos pedidos em uma única query.
async function findItemsByPedidoIds(pedidoIds) {
  const query = `
    SELECT
      i.pedido_id,
      i.id,
      i.produto_id,
      i.quantidade,
      i.preco_unitario,
      pr.nome,
      pr.descricao,
      pr.preco,
      pr.estoque,
      pr.criado_em
    FROM itens_pedido i
    LEFT JOIN produtos pr ON pr.id = i.produto_id
    WHERE i.pedido_id = ANY($1)
    ORDER BY i.id ASC;
  `;

  const result = await db.query(query, [pedidoIds]);

  const itemsByPedidoId = new Map();
  for (const row of result.rows) {
    const item = {
      id: row.id,
      produto_id: row.produto_id,
      quantidade: row.quantidade,
      preco_unitario: row.preco_unitario,
      produto: row.produto_id
        ? {
            id: row.produto_id,
            nome: row.nome,
            descricao: row.descricao,
            preco: row.preco,
            estoque: row.estoque,
            criado_em: row.criado_em,
          }
        : null,
    };
    if (!itemsByPedidoId.has(row.pedido_id))
      itemsByPedidoId.set(row.pedido_id, []);
    itemsByPedidoId.get(row.pedido_id).push(item);
  }

  // DataLoader exige retorno na mesma ordem/tamanho do array de entrada
  return pedidoIds.map((id) => itemsByPedidoId.get(id) || []);
}

// Usada pelo DataLoader (pedidosByUsuarioLoader) para agrupar buscas de múltiplos usuários em uma única query.
async function findOrdersByUsuarioIds(usuarioIds) {
  const result = await db.query(
    "SELECT * FROM pedidos WHERE usuario_id = ANY($1) ORDER BY id ASC",
    [usuarioIds],
  );

  const ordersByUsuarioId = new Map();
  for (const row of result.rows) {
    if (!ordersByUsuarioId.has(row.usuario_id)) {
      ordersByUsuarioId.set(row.usuario_id, []);
    }
    ordersByUsuarioId.get(row.usuario_id).push(row);
  }

  // mesma regra do findItemsByPedidoIds: retorno na ordem/tamanho do array de entrada
  return usuarioIds.map((id) => ordersByUsuarioId.get(id) || []);
}

async function createOrder({ usuario_id, total, data_pedido }) {
  const result = await db.query(
    "INSERT INTO pedidos (usuario_id, total, data_pedido) VALUES ($1, $2, $3) RETURNING *;",
    [usuario_id, total, data_pedido],
  );

  return result.rows[0];
}

async function updateOrder(id, { total, data_pedido }) {
  const query = `
    UPDATE pedidos
      SET total = COALESCE($1, total),
      data_pedido = COALESCE($2, data_pedido)
    WHERE id = $3
  RETURNING *;
  `;

  const values = [total || null, data_pedido || null, id];

  const result = await db.query(query, values);
  return result.rows[0] || null;
}

async function deleteOrder(id) {
  const result = await db.query(
    "DELETE FROM pedidos WHERE id = $1 RETURNING *;",
    [id],
  );

  return result.rows[0] || null;
}

module.exports = {
  findAllOrders,
  findOrderById,
  findOrderByUsuarioId,
  findItemsByPedidoId,
  findItemsByPedidoIds,
  findOrderDetailsById,
  findOrdersByUsuarioIds,
  createOrder,
  updateOrder,
  deleteOrder,
};
