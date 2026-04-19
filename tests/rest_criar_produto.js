// Teste de carga: criação de produtos via REST (POST /api/products)
// Simula 5 usuários virtuais por 20 segundos, cada um criando um produto com nome único
import http from "k6/http";
import { check } from "k6";
import { uuidv4 } from "https://jslib.k6.io/k6-utils/1.4.0/index.js";

export const options = {
  vus: 5,
  duration: "20s",
};

const BASE_URL = "http://localhost:3000";

export default function () {
  // Sufixo aleatório para evitar conflitos de nome entre iterações
  const id = uuidv4().substring(0, 8);

  const payload = JSON.stringify({
    nome: `Produto REST ${id}`,
    descricao: `Descrição do produto REST ${id}`,
    preco: 199.9,
    estoque: 10,
  });

  const params = {
    headers: { "Content-Type": "application/json" },
  };

  const res = http.post(`${BASE_URL}/api/products`, payload, params);

  check(res, {
    "status 201": (r) => r.status === 201,
  });
}
