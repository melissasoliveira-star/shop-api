// Teste de carga: busca de usuários por nome via REST (GET /api/users?nome=)
// Simula 10 usuários virtuais por 30 segundos filtrando pelo nome fixo "Ana"
import http from "k6/http";
import { check } from "k6";

export const options = {
  vus: 10,
  duration: "30s",
};

const BASE_URL = "http://localhost:3000";

export default function () {
  const res = http.get(`${BASE_URL}/api/users?nome=Ana`);

  check(res, {
    "status é 200": (r) => r.status === 200,
  });
}
