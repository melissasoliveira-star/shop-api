// Teste de carga: detalhes de pedido via GraphQL (query pedidoDetalhes)
// Simula 10 usuarios virtuais por 30 segundos buscando o pedido de ID fixo
// O mesmo ORDER_ID e usado no teste REST equivalente para comparacao de desempenho
import http from "k6/http";
import { check } from "k6";

export const options = {
  vus: 10,
  duration: "30s",
};

const BASE_URL = "http://localhost:3000/graphql";
const ORDER_ID = 1;

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
          preco
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
  const body = res.json();

  check(res, {
    "status 200": (r) => r.status === 200,
    "sem erros GraphQL": () => !body.errors,
    "pedido retornado em data": () => body?.data?.pedidoDetalhes?.id !== undefined,
    "usuario resolvido": () => body?.data?.pedidoDetalhes?.usuario?.id !== undefined,
    "itens retornados": () => Array.isArray(body?.data?.pedidoDetalhes?.itens),
    "produto contem preco": () => {
      const produto = body?.data?.pedidoDetalhes?.itens?.[0]?.produto;
      return produto === undefined || produto?.preco !== undefined;
    },
  });
}
