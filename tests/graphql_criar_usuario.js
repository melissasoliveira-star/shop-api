// Teste de carga: criacao de usuarios via GraphQL (mutation criarUsuario)
// Simula 5 usuarios virtuais por 20 segundos, cada um criando um usuario com e-mail unico
import http from "k6/http";
import { check } from "k6";
import { uuidv4 } from "https://jslib.k6.io/k6-utils/1.4.0/index.js";

export const options = {
  vus: 5,
  duration: "20s",
};

const BASE_URL = "http://localhost:3000/graphql";

const mutation = `
  mutation ($nome: String!, $email: String!) {
    criarUsuario(nome: $nome, email: $email) {
      id
      nome
      email
    }
  }
`;

export default function () {
  const id = uuidv4().substring(0, 8);
  const variables = {
    nome: `Usuario GQL ${id}`,
    email: `gql_${id}@teste.com`,
  };

  const payload = JSON.stringify({ query: mutation, variables });
  const params = { headers: { "Content-Type": "application/json" } };

  const res = http.post(BASE_URL, payload, params);
  const body = res.json();

  check(res, {
    "status 200": (r) => r.status === 200,
    "sem erros GraphQL": () => !body.errors,
    "usuario criado retornado": () =>
      body?.data?.criarUsuario?.email === variables.email,
  });
}
