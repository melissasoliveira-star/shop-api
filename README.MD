# shop-api

API desenvolvida como artefato empírico do Trabalho de Conclusão de Curso de MBA em Engenharia de Software, com o objetivo de comparar as abordagens **REST** e **GraphQL** em termos de desempenho e experiência de desenvolvimento. A aplicação simula um sistema simplificado de cadastro de usuários, produtos e pedidos, implementado em **Node.js** com banco de dados **PostgreSQL**.

---

## Contexto acadêmico

Este repositório faz parte do estudo:

> **REST vs. GraphQL: Uma Comparação de Desempenho e Experiência do Desenvolvedor em uma Aplicação de Cadastro**
> <br>
> MBA em Engenharia de Software — 2025/2026
> <br>
> Orientador(a): Jamile Raquel Regazzo

Ambas as abordagens foram implementadas na mesma aplicação, compartilhando o mesmo banco de dados, repositórios e lógica de negócio. Os testes de desempenho foram realizados com a ferramenta **k6**, medindo métricas como tempo de resposta (p50, p90, p95, p99), requisições por segundo e taxa de erros, em cenários equivalentes para REST e GraphQL.

---

## Tecnologias utilizadas

| Tecnologia      | Versão   | Finalidade                   |
| --------------- | -------- | ---------------------------- |
| Node.js         | ^24.13.1 | Runtime da aplicação         |
| Express         | ^5.2.1   | Framework HTTP / REST        |
| express-graphql | ^0.12.0  | Middleware GraphQL           |
| graphql         | ^15.10.2 | Biblioteca GraphQL           |
| pg              | ^8.20.0  | Conexão com PostgreSQL       |
| dotenv          | ^17.4.0  | Variáveis de ambiente        |
| k6              | ^1.7.1   | Testes de carga e desempenho |

---

## Estrutura do projeto

```
shop-api/
├── index.js                  # Ponto de entrada — sobe REST e GraphQL no mesmo servidor
├── db.js                     # Configuração da conexão com PostgreSQL
├── queries.sql               # Script SQL para criação das tabelas e dados iniciais
├── package.json
│
├── routes/                   # Rotas REST
│   ├── userRoutes.js
│   ├── productRoutes.js
│   └── orderRoutes.js
│
├── repositories/             # Camada de acesso ao banco de dados (compartilhada)
│   ├── userRepository.js
│   ├── productRepository.js
│   └── orderRepository.js
│
├── graphql/                  # Implementação GraphQL
│   ├── schema.js             # Definição do schema (tipos, queries, mutations)
│   └── resolvers.js          # Resolvers das queries e mutations
│
└── tests/                    # Scripts k6 de testes de carga
    ├── rest_usuarios_list.js
    ├── rest_produtos_list.js
    ├── rest_pedido_detalhes.js
    ├── rest_filtro_usuario_nome.js
    ├── rest_criar_usuario.js
    ├── rest_criar_produto.js
    ├── graphql_usuarios_list.js
    ├── graphql_produtos_list.js
    ├── graphql_pedido_detalhes.js
    ├── graphql_filtro_usuario_nome.js
    ├── graphql_criar_usuario.js
    └── graphql_criar_produto.js
```

---

## Pré-requisitos

- [Node.js](https://nodejs.org/) (v18 ou superior recomendado)
- [PostgreSQL](https://www.postgresql.org/) (v14 ou superior)
- [k6](https://k6.io/docs/getting-started/installation/) (para execução dos testes de carga)

---

## Configuração

### 1. Clone o repositório

```bash
git clone https://github.com/melissasoliveira-star/shop-api.git
cd shop-api
```

### 2. Instale as dependências

```bash
npm install
```

### 3. Configure as variáveis de ambiente

Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```env
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_USER=seu_usuario
DB_PASSWORD=sua_senha
DB_NAME=nome_do_banco
```

### 4. Crie o banco de dados e as tabelas

Execute o script SQL disponível na raiz do projeto:

```bash
psql -U seu_usuario -d nome_do_banco -f queries.sql
```

---

## Execução

```bash
node index.js
```

A aplicação sobe dois endpoints no mesmo servidor:

| Endpoint                        | Descrição                             |
| ------------------------------- | ------------------------------------- |
| `http://localhost:3000/api`     | API REST                              |
| `http://localhost:3000/graphql` | API GraphQL (com GraphiQL habilitado) |

O GraphiQL é uma interface interativa acessível via navegador em `http://localhost:3000/graphql`, útil para explorar o schema e executar queries manualmente.

---

## Endpoints REST

### Usuários — `/api/users`

| Método | Rota                      | Descrição                    |
| ------ | ------------------------- | ---------------------------- |
| GET    | `/api/users`              | Lista usuários com paginação |
| GET    | `/api/users/:id`          | Busca usuário por ID         |
| GET    | `/api/users/search?nome=` | Filtra usuários por nome     |
| POST   | `/api/users`              | Cria novo usuário            |

### Produtos — `/api/products`

| Método | Rota                         | Descrição                    |
| ------ | ---------------------------- | ---------------------------- |
| GET    | `/api/products`              | Lista produtos com paginação |
| GET    | `/api/products/:id`          | Busca produto por ID         |
| GET    | `/api/products/search?nome=` | Filtra produtos por nome     |
| POST   | `/api/products`              | Cria novo produto            |

### Pedidos — `/api/orders`

| Método | Rota                           | Descrição                                                  |
| ------ | ------------------------------ | ---------------------------------------------------------- |
| GET    | `/api/orders`                  | Lista pedidos com paginação                                |
| GET    | `/api/orders/:id`              | Busca pedido por ID                                        |
| GET    | `/api/orders/:id/details`      | Retorna detalhes completos do pedido (com itens e usuário) |
| GET    | `/api/orders/user/:usuario_id` | Lista pedidos de um usuário                                |
| POST   | `/api/orders`                  | Cria novo pedido                                           |

---

## Queries e Mutations GraphQL

A API GraphQL está disponível em `/graphql`. Todas as operações são realizadas via `POST` nesse endpoint, com corpo JSON contendo `query` e, quando necessário, `variables`.

### Queries disponíveis

```graphql
# Listar usuários (paginado)
usuarios(page: Int, limit: Int): [Usuario]

# Buscar usuário por ID
usuario(id: ID!): Usuario

# Filtrar usuários por nome
buscarUsuariosPorNome(nome: String!): [Usuario]

# Listar produtos (paginado)
produtos(page: Int, limit: Int): [Produto]

# Buscar produto por ID
produto(id: ID!): Produto

# Filtrar produtos por nome
buscarProdutosPorNome(nome: String!): [Produto]

# Listar pedidos (paginado)
pedidos(page: Int, limit: Int): [Pedido]

# Buscar pedido por ID
pedido(id: ID!): Pedido

# Detalhes completos de um pedido (com itens e usuário)
pedidoDetalhes(id: ID!): PedidoDetalhes

# Listar pedidos por usuário
pedidosPorUsuario(usuario_id: ID!): [Pedido]
```

### Mutations disponíveis

```graphql
# Criar usuário
criarUsuario(nome: String!, email: String!, telefone: String, cidade: String): Usuario

# Criar produto
criarProduto(nome: String!, descricao: String, preco: Float!, estoque: Int): Produto
```

---

## Testes de carga com k6

Os scripts de teste estão na pasta `tests/` e cobrem os mesmos cenários nas duas abordagens, permitindo comparação direta.

### Cenários testados

| Cenário                    | REST                          | GraphQL                          |
| -------------------------- | ----------------------------- | -------------------------------- |
| Listagem de usuários       | `rest_usuarios_list.js`       | `graphql_usuarios_list.js`       |
| Listagem de produtos       | `rest_produtos_list.js`       | `graphql_produtos_list.js`       |
| Detalhes de pedido         | `rest_pedido_detalhes.js`     | `graphql_pedido_detalhes.js`     |
| Filtro de usuário por nome | `rest_filtro_usuario_nome.js` | `graphql_filtro_usuario_nome.js` |
| Criação de usuário         | `rest_criar_usuario.js`       | `graphql_criar_usuario.js`       |
| Criação de produto         | `rest_criar_produto.js`       | `graphql_criar_produto.js`       |

### Executando um teste

```bash
k6 run tests/rest_usuarios_list.js
```

```bash
k6 run tests/graphql_usuarios_list.js
```

Os scripts utilizam a configuração padrão de `vus: 5` ou `vus: 10` e `duration: "20s"`, executando 5 ou 10 usuários virtuais simultâneos por 20 segundos. As métricas coletadas incluem tempo de resposta (p50, p90, p95, p99), requisições por segundo e taxa de erros.

## Autora

**Melissa Oliveira**<br>
MBA em Engenharia de Software<br>
2025/2026
