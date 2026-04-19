// Teste de carga: listagem paginada de usuários via GraphQL (query usuarios)
// Simula 10 usuários virtuais por 30 segundos buscando a primeira página com 10 itens
import http from "k6/http";
import { check } from "k6";

export const options = {
  vus: 10,
  duration: "30s",
};

const BASE_URL = "http://localhost:3000/graphql";

const query = `
  query {
    usuarios(page: 1, limit: 10) {
      id
      nome
      email
    }
  }
`;

export default function () {
  const payload = JSON.stringify({ query });
  const params = { headers: { "Content-Type": "application/json" } };

  const res = http.post(BASE_URL, payload, params);

  check(res, {
    "status é 200": (r) => r.status === 200,
  });
}
