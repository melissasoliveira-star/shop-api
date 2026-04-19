import http from "k6/http";
import { check } from "k6";

export const options = {
  vus: 10,
  duration: "30s",
};

const BASE_URL = "http://localhost:3000";
const ORDER_ID = 1;

export default function () {
  const res = http.get(`${BASE_URL}/api/orders/${ORDER_ID}/details`);

  check(res, {
    "status é 200": (r) => r.status === 200,
  });
}
