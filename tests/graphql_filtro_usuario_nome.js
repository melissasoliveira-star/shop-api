import http from "k6/http";
import { check } from "k6";

export const options = {
  vus: 10,
  duration: "30s",
};

const BASE_URL = "http://localhost:3000/graphql";

const query = `
  query {
    buscarUsuariosPorNome(nome: "Ana") {
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
