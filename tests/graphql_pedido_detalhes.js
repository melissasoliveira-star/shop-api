// Teste de carga: detalhes de pedido via GraphQL (query pedidoDetalhes)
// Simula 10 usuários virtuais por 30 segundos buscando o pedido de ID fixo
// O mesmo ORDER_ID é usado no teste REST equivalente para comparação de desempenho
import http from "k6/http";
import { check } from "k6";

export const options = {
  vus: 10,
  duration: "30s",
};

const BASE_URL = "http://localhost:3000/graphql";
const ORDER_ID = 1; // mesmo ID usado no teste REST

const query = `
  query ($id: ID!) {
    pedidoDetalhes(id: $id) {
      id
      total
      data_pedido
      usuario {
        id
        nome
        email
      }
      itens {
        quantidade
        preco_unitario
        produto {
          id
          nome
        }
      }
    }
  }
`;

export default function () {
  const payload = JSON.stringify({
    query,
    variables: { id: ORDER_ID.toString() },
  });

  const params = { headers: { "Content-Type": "application/json" } };

  const res = http.post(BASE_URL, payload, params);

  check(res, {
    "status é 200": (r) => r.status === 200,
  });
}
