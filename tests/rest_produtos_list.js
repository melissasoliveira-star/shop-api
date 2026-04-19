// Teste de carga: listagem paginada de produtos via REST (GET /api/products?page=&limit=)
// Simula 10 usuários virtuais por 30 segundos buscando a primeira página com 10 itens
import http from "k6/http";
import { check } from "k6";

export const options = {
  vus: 10,
  duration: "30s",
};

const BASE_URL = "http://localhost:3000";

export default function () {
  const res = http.get(`${BASE_URL}/api/products?page=1&limit=10`);

  check(res, {
    "status é 200": (r) => r.status === 200,
  });
}
