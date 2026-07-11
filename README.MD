# shop-api

API desenvolvida como artefato empírico do Trabalho de Conclusão de Curso de MBA em Engenharia de Software, com o objetivo de comparar as abordagens **REST** e **GraphQL** em termos de desempenho e experiência de desenvolvimento. A aplicação simula um sistema simplificado de cadastro de usuários, produtos e pedidos, implementado em **Node.js** com banco de dados **PostgreSQL**.

---

## Contexto acadêmico

Este repositório faz parte do estudo:

> **REST vs. GraphQL: Uma Comparação de Desempenho e Experiência do Desenvolvedor em uma Aplicação de Cadastro**
> <br>
> MBA em Engenharia de Software — 2025/2026
> <br>
> Orientadora: Jamile Raquel Regazzo

Ambas as abordagens foram implementadas na mesma aplicação, compartilhando o mesmo banco de dados, repositórios e lógica de negócio. Os testes de desempenho foram realizados com a ferramenta **k6**, medindo métricas como tempo de resposta (p50, p90, p95, p99), requisições por segundo e taxa de erros, em cenários equivalentes para REST e GraphQL.

---

## Tecnologias utilizadas

| Tecnologia       | Versão   | Finalidade                           |
| ---------------- | -------- | ------------------------------------ |
| Node.js          | ^24.13.1 | Runtime da aplicação                 |
| Express          | ^5.2.1   | Framework HTTP / REST                |
| graphql-http     | ^1.22.4  | Middleware GraphQL                   |
| graphql          | ^15.10.2 | Biblioteca GraphQL                   |
| ruru             | ^2.0.0   | UI de testes GraphQL (`/graphiql`)   |
| pg               | ^8.20.0  | Conexão com PostgreSQL               |
| dotenv           | ^17.4.0  | Variáveis de ambiente                |
| PostgreSQL       | 18       | Banco de dados relacional            |
| Docker / Compose | —        | Containerização e orquestração local |
| k6               | ^1.7.1   | Testes de carga e desempenho         |

---

## Estrutura do projeto

```
shop-api/
├── src/                          # Código-fonte da aplicação (organização MVC)
│   ├── server.js                 # Ponto de entrada — abre o servidor HTTP
│   ├── app.js                    # Composição do Express (middlewares + rotas)
│   │
│   ├── config/
│   │   └── db.js                 # Configuração da conexão com PostgreSQL
│   │
│   ├── routes/                   # Rotas REST (camada fina: URL -> controller)
│   │   ├── userRoutes.js
│   │   ├── productRoutes.js
│   │   ├── orderRoutes.js
│   │   └── graphql.js            # Monta o endpoint /graphql
│   │
│   ├── controllers/              # Controllers (validação, status HTTP, chama models)
│   │   ├── userController.js
│   │   ├── productController.js
│   │   └── orderController.js
│   │
│   ├── models/                  # Camada de acesso ao banco de dados (Model)
│   │   ├── userRepository.js
│   │   ├── productRepository.js
│   │   └── orderRepository.js
│   │
│   └── graphql/                  # Implementação GraphQL (coesa: schema + resolvers + loaders)
│       ├── schema.js             # Definição do schema (tipos, queries, mutations)
│       ├── resolvers.js          # Resolvers das queries
│       ├── mutations.js          # Resolvers das mutations
│       └── loaders.js            # DataLoaders (batch de consultas por requisição)
│
├── queries.sql                   # Script SQL para criação das tabelas e dados iniciais
├── docker-compose.yml
├── Dockerfile                    # Entrada: src/server.js
├── package.json
│
└── tests/                        # Scripts k6 de testes de carga
    ├── README.md
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

## Configuração

Há duas formas de rodar o projeto: com Docker (recomendado, mais rápido) ou de forma manual instalando Node.js e PostgreSQL diretamente na máquina.

### Opção 1: Com Docker (recomendado)

Pré-requisito: [Docker](https://www.docker.com/products/docker-desktop/) instalado.

1. Clone o repositório:

```bash
git clone https://github.com/melissasoliveira-star/shop-api.git
cd shop-api
```

2. Copie o arquivo de variáveis de ambiente de exemplo:

```bash
cp .env.example .env
```

3. Suba a aplicação:

```bash
docker compose up --build
```

Esse comando constrói a imagem da API, sobe um container PostgreSQL, popula o banco automaticamente com o script `queries.sql` na primeira execução, e inicia a aplicação.

A aplicação fica disponível em:

| Endpoint                         | Descrição                                    |
| -------------------------------- | -------------------------------------------- |
| `http://localhost:3000/api`      | API REST                                     |
| `http://localhost:3000/graphql`  | API GraphQL                                  |
| `http://localhost:3000/graphiql` | UI de testes GraphQL (ambiente não-produção) |

Para parar a aplicação:

```bash
docker compose down
```

Para parar e remover também os dados do banco (reinício limpo):

```bash
docker compose down -v
```

> **Nota para desenvolvimento:** este setup copia o código para dentro da imagem no momento do build. Alterações no código exigem rodar `docker compose up --build` novamente para serem refletidas. Para um fluxo de desenvolvimento com hot-reload, seria necessário adicionar volumes de bind mount não implementado neste projeto, já que o foco aqui é demonstração e reprodutibilidade dos testes de desempenho.

### Opção 2: Instalação manual

Pré-requisitos:

- [Node.js](https://nodejs.org/) (v18 ou superior recomendado)
- [PostgreSQL](https://www.postgresql.org/) (v14 ou superior)
- [k6](https://k6.io/docs/getting-started/installation/) (para execução dos testes de carga)

1. Clone o repositório e instale as dependências:

```bash
git clone https://github.com/melissasoliveira-star/shop-api.git
cd shop-api
npm install
```

2. Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```env
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_USER=seu_usuario
DB_PASSWORD=sua_senha
DB_NAME=nome_do_banco
DB_MAX=10
```

3. Crie o banco de dados e as tabelas:

```bash
psql -U seu_usuario -d nome_do_banco -f queries.sql
```

4. Execute a aplicação:

```bash
node src/server.js
```

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

### Executando contra a API em produção (Render)

Além de rodar localmente, os mesmos scripts podem ser executados contra a instância pública da API, sem precisar clonar o banco de dados ou subir nada localmente, tendo apenas o k6 instalado na sua máquina.

A API está publicada em:

```
https://shop-api-tldb.onrender.com
```

Para apontar qualquer teste para essa URL, passe-a pela flag `-e BASE_URL=`:

```bash
k6 run tests/rest_usuarios_list.js -e BASE_URL=https://shop-api-tldb.onrender.com
```

```bash
k6 run tests/graphql_usuarios_list.js -e BASE_URL=https://shop-api-tldb.onrender.com
```

O mesmo padrão se aplica a qualquer um dos 12 scripts da pasta `tests/`. Quando a flag `-e BASE_URL=` não é informada, os scripts utilizam `http://localhost:3000` por padrão, por isso a execução local (Opções 1 e 2 acima) continua funcionando sem alterações.

> **Nota:** por estar hospedada no plano gratuito do Render, a instância pode levar alguns segundos para responder à primeira requisição após um período de inatividade (cold start). Isso é esperado e pode impactar as métricas de tempo de resposta do primeiro usuário virtual em cada execução.

## Autora

**Melissa Oliveira**<br>
MBA em Engenharia de Software<br>
2025/2026
