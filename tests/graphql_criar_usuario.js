// Teste de carga: criação de usuários via GraphQL (mutation criarUsuario)
// Simula 5 usuários virtuais por 20 segundos, cada um criando um usuário com e-mail único
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
  // Sufixo aleatório para garantir e-mails únicos em cada iteração
  const id = uuidv4().substring(0, 8);
  const variables = {
    nome: `Usuario GQL ${id}`,
    email: `gql_${id}@teste.com`,
  };

  const payload = JSON.stringify({ query: mutation, variables });
  const params = { headers: { "Content-Type": "application/json" } };

  const res = http.post(BASE_URL, payload, params);

  check(res, {
    "status 200": (r) => r.status === 200,
  });
}
