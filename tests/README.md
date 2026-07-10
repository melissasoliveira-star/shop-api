# Testes de Desempenho — Scripts k6

Esta pasta contém os scripts de teste de carga utilizados para comparar o desempenho das implementações **REST** e **GraphQL** da shop-api. Os testes foram elaborados como parte do estudo experimental do TCC _"REST e GraphQL em aplicação de cadastro: avaliação de desempenho e experiência do desenvolvedor"_.

---

## Pré-requisitos

- [k6](https://k6.io/docs/get-started/installation/) v1.7.1 ou superior
- A aplicação em execução localmente na porta `3000` (`node src/server.js`)
- Banco de dados PostgreSQL populado (ver seção [Estado do banco](#estado-do-banco-de-dados))

---

## Ambiente de execução

Os testes foram executados no seguinte ambiente controlado:

| Componente              | Versão / Especificação |
| ----------------------- | ---------------------- |
| Sistema operacional     | Windows                |
| Memória RAM do servidor | 16 GB                  |
| Node.js                 | v24.13.1               |
| k6                      | v1.7.1                 |
| PostgreSQL              | v18.3.2                |
| express                 | v5.2.1                 |
| express-graphql         | v0.12.0                |
| graphql                 | v15.10.2               |
| pg                      | v8.20.0                |

As APIs REST e GraphQL foram executadas no mesmo servidor, compartilhando a mesma instância do banco de dados.

---

## Estado do banco de dados

Antes de executar os testes de **leitura** (listagem, filtro e detalhes de pedido), o banco deve estar populado com:

- **100 usuários** cadastrados
- **100 produtos** cadastrados
- Ao menos **1 pedido** com itens e usuário associado (usado nos testes de detalhes de pedido com `ORDER_ID = 1`)

Os testes de **criação** (POST / mutation) geram seus próprios registros com e-mails e nomes únicos via UUID, não dependendo de dados pré-existentes.

---

## Cenários e parâmetros de execução

### Cenário 1 — Listagem paginada

Retorna a primeira página (10 itens) de usuários ou produtos.

| Parâmetro               | Valor                                            |
| ----------------------- | ------------------------------------------------ |
| Usuários virtuais (VUs) | 10                                               |
| Duração                 | 30s                                              |
| Endpoint REST           | `GET /api/users?page=1&limit=10`                 |
| Endpoint REST           | `GET /api/products?page=1&limit=10`              |
| Endpoint GraphQL        | `POST /graphql` — query `usuarios` com paginação |
| Endpoint GraphQL        | `POST /graphql` — query `produtos` com paginação |

```bash
# REST
k6 run tests/rest_usuarios_list.js
k6 run tests/rest_produtos_list.js

# GraphQL
k6 run tests/graphql_usuarios_list.js
k6 run tests/graphql_produtos_list.js
```

---

### Cenário 2 — Detalhes de pedido (dados relacionais)

Retorna os dados de um pedido incluindo seus itens e o usuário associado. Envolve dados relacionais, sendo o cenário de maior diferença arquitetural entre as abordagens.

| Parâmetro               | Valor                                    |
| ----------------------- | ---------------------------------------- |
| Usuários virtuais (VUs) | 10                                       |
| Duração                 | 30s                                      |
| `ORDER_ID` fixo         | `1`                                      |
| Endpoint REST           | `GET /api/orders/1/details`              |
| Endpoint GraphQL        | `POST /graphql` — query `pedidoDetalhes` |

```bash
# REST
k6 run tests/rest_pedido_detalhes.js

# GraphQL
k6 run tests/graphql_pedido_detalhes.js
```

---

### Cenário 3 — Criação de registros

Cria novos usuários e produtos com payloads simples (3–4 campos). Cada iteração gera um e-mail/nome único via UUID para evitar violações de unicidade.

| Parâmetro               | Valor                                                      |
| ----------------------- | ---------------------------------------------------------- |
| Usuários virtuais (VUs) | 5                                                          |
| Duração                 | 20s                                                        |
| Endpoint REST           | `POST /api/users` / `POST /api/products`                   |
| Endpoint GraphQL        | `POST /graphql` — mutation `criarUsuario` / `criarProduto` |

```bash
# REST
k6 run tests/rest_criar_usuario.js
k6 run tests/rest_criar_produto.js

# GraphQL
k6 run tests/graphql_criar_usuario.js
k6 run tests/graphql_criar_produto.js
```

---

### Cenário 4 — Filtro por nome

Filtra usuários pelo nome `"Ana"` usando busca parcial com `ILIKE` no PostgreSQL.

| Parâmetro               | Valor                                       |
| ----------------------- | ------------------------------------------- |
| Usuários virtuais (VUs) | 10                                          |
| Duração                 | 30s                                         |
| Termo de busca fixo     | `"Ana"`                                     |
| Endpoint REST           | `GET /api/users?nome=Ana`                   |
| Endpoint GraphQL        | `POST /graphql` — query com filtro por nome |

> **Nota metodológica:** as latências neste cenário foram significativamente mais elevadas em ambas as abordagens (REST: 240 ms, GraphQL: 268 ms) em comparação com os demais cenários. Isso ocorre porque o volume de requisições processadas foi menor, e não porque o filtro seja inerentemente mais lento — as duas versões reutilizam a mesma cláusula `ILIKE` no repositório compartilhado.

```bash
# REST
k6 run tests/rest_filtro_usuario_nome.js

# GraphQL
k6 run tests/graphql_filtro_usuario_nome.js
```

---

## Métricas coletadas

Para cada script, o k6 reporta automaticamente ao final da execução:

| Métrica                        | Descrição                                          |
| ------------------------------ | -------------------------------------------------- |
| `http_req_duration` (avg, p95) | Latência média e percentil 95 do tempo de resposta |
| `http_reqs`                    | Total de requisições processadas no período        |
| `data_received`                | Volume total de dados recebidos (payload)          |
| `data_sent`                    | Volume total de dados enviados                     |
| `http_req_failed`              | Taxa de requisições com erro                       |

---

## Estrutura dos arquivos

```bash
tests/
├── rest_usuarios_list.js # Cenário 1 — listagem de usuários (REST)
├── rest_produtos_list.js # Cenário 1 — listagem de produtos (REST)
├── rest_pedido_detalhes.js # Cenário 2 — detalhes de pedido (REST)
├── rest_criar_usuario.js # Cenário 3 — criação de usuário (REST)
├── rest_criar_produto.js # Cenário 3 — criação de produto (REST)
├── rest_filtro_usuario_nome.js # Cenário 4 — filtro por nome (REST)
├── graphql_usuarios_list.js # Cenário 1 — listagem de usuários (GraphQL)
├── graphql_produtos_list.js # Cenário 1 — listagem de produtos (GraphQL)
├── graphql_pedido_detalhes.js # Cenário 2 — detalhes de pedido (GraphQL)
├── graphql_criar_usuario.js # Cenário 3 — criação de usuário (GraphQL)
├── graphql_criar_produto.js # Cenário 3 — criação de produto (GraphQL)
├── graphql_filtro_usuario_nome.js # Cenário 4 — filtro por nome (GraphQL)
└── README.md # Este arquivo
```
