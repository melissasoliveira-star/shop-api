# Exemplos de uso da API GraphQL

Este arquivo reúne exemplos de queries e mutations para facilitar os testes manuais da API GraphQL no GraphiQL.

Endpoint da API:

```text
http://localhost:3000/graphql
```

## 1. Listar usuários (página 1, 10 itens)

```graphql
query {
  usuarios(page: 1, limit: 10) {
    id
    nome
    email
  }
}
```

## 2. Buscar usuário por ID

```graphql
query {
  usuario(id: "1") {
    id
    nome
    email
  }
}
```

## 3. Listar produtos (página 1, 10 itens)

```graphql
query {
  produtos(page: 1, limit: 10) {
    id
    nome
    descricao
    preco
    estoque
  }
}
```

## 4. Buscar produto por ID

```graphql
query {
  produto(id: "1") {
    id
    nome
    descricao
    preco
    estoque
  }
}
```

## 5. Listar pedidos (página 1, 10 itens)

```graphql
query {
  pedidos(page: 1, limit: 10) {
    id
    usuario_id
    total
    data_pedido
  }
}
```

## 6. Buscar pedido por ID

```graphql
query {
  pedido(id: "1") {
    id
    usuario_id
    total
    data_pedido
  }
}
```

## 7. Buscar detalhes de pedido

```graphql
query {
  pedidoDetalhes(id: "1") {
    id
    total
    data_pedido
    usuario {
      id
      nome
      email
    }
    itens {
      id
      quantidade
      preco_unitario
      produto {
        id
        nome
      }
    }
  }
}
```

## 8. Buscar pedidos de um usuário

```graphql
query {
  pedidosPorUsuario(usuario_id: "1") {
    id
    total
    data_pedido
  }
}
```

ou

```graphql
query {
  usuarios(page: 3, limit: 10) {
    id
    nome
    email
    pedidos {
      id
      total
      data_pedido
    }
  }
}
```

## 9. Criar usuário

```graphql
mutation {
  criarUsuario(nome: "Usuário Teste", email: "usuario.teste@example.com") {
    id
    nome
    email
  }
}
```

## 10. Atualizar usuário

```graphql
mutation {
  atualizarUsuario(
    id: "1"
    nome: "Ana Silva Atualizada"
    email: "ana.atualizada@email.com"
  ) {
    id
    nome
    email
  }
}
```

## 11. Deletar usuário

```graphql
mutation {
  deletarUsuario(id: "1") {
    id
    nome
    email
  }
}
```

## 12. Criar produto

```graphql
mutation {
  criarProduto(
    nome: "Headset Gamer"
    descricao: "Headset com som surround e microfone"
    preco: 299.90
    estoque: 12
  ) {
    id
    nome
    descricao
    preco
    estoque
  }
}
```

## 13. Atualizar produto

```graphql
mutation {
  atualizarProduto(
    id: "1"
    nome: "Teclado Mecânico RGB Pro"
    descricao: "Versão atualizada do teclado"
    preco: 279.90
    estoque: 20
  ) {
    id
    nome
    descricao
    preco
    estoque
  }
}
```

## 14. Deletar produto

```graphql
mutation {
  deletarProduto(id: "1") {
    id
    nome
    preco
  }
}
```

## 15. Criar pedido

```graphql
mutation {
  criarPedido(
    usuario_id: "1"
    total: 370.50
    data_pedido: "2026-04-12 10:00:00"
  ) {
    id
    usuario_id
    total
    data_pedido
  }
}
```

## 16. Atualizar pedido

```graphql
mutation {
  atualizarPedido(id: "1", total: 450.00, data_pedido: "2026-04-12 15:30:00") {
    id
    total
    data_pedido
  }
}
```

## 17. Deletar pedido

```graphql
mutation {
  deletarPedido(id: "1") {
    id
    total
  }
}
```

## Observações

- Para testes manuais, recomenda-se começar pelas queries de leitura.
- As mutations de atualização e exclusão devem ser usadas com cuidado, pois alteram os dados do banco.
- Em testes de desempenho, os cenários equivalentes utilizados no k6 foram: listagem de usuários, listagem de produtos, detalhes de pedido, criação de usuário e criação de produto.
