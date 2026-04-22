// Teste de carga: criacao de produtos via GraphQL (mutation criarProduto)
// Simula 5 usuarios virtuais por 20 segundos, cada um criando um produto com nome unico
import http from "k6/http";
import { check } from "k6";
import { uuidv4 } from "https://jslib.k6.io/k6-utils/1.4.0/index.js";

export const options = {
  vus: 5,
  duration: "20s",
};

const BASE_URL = "http://localhost:3000/graphql";

const mutation = `
  mutation ($nome: String!, $descricao: String, $preco: Float!, $estoque: Int) {
    criarProduto(
      nome: $nome,
      descricao: $descricao,
      preco: $preco,
      estoque: $estoque
    ) {
      id
      nome
      descricao
      preco
      estoque
    }
  }
`;

export default function () {
  const id = uuidv4().substring(0, 8);

  const variables = {
    nome: `Produto GQL ${id}`,
    descricao: `Descricao do produto GQL ${id}`,
    preco: 199.9,
    estoque: 10,
  };

  const payload = JSON.stringify({
    query: mutation,
    variables,
  });

  const params = {
    headers: { "Content-Type": "application/json" },
  };

  const res = http.post(BASE_URL, payload, params);
  const body = res.json();

  check(res, {
    "status 200": (r) => r.status === 200,
    "sem erros GraphQL": () => !body.errors,
    "produto criado retornado": () =>
      body?.data?.criarProduto?.nome === variables.nome,
  });
}
