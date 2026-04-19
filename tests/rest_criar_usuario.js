import http from "k6/http";
import { check } from "k6";
import { uuidv4 } from "https://jslib.k6.io/k6-utils/1.4.0/index.js";

export const options = {
  vus: 5,
  duration: "20s",
};

const BASE_URL = "http://localhost:3000";

export default function () {
  const id = uuidv4().substring(0, 8);
  const payload = JSON.stringify({
    nome: `Usuario REST ${id}`,
    email: `rest_${id}@teste.com`,
  });

  const params = { headers: { "Content-Type": "application/json" } };

  const res = http.post(`${BASE_URL}/api/users`, payload, params);

  check(res, {
    "status 201": (r) => r.status === 201,
  });
}
