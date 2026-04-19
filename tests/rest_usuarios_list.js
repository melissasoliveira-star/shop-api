import http from "k6/http";
import { check } from "k6";

export const options = {
  vus: 10,
  duration: "30s",
};

const BASE_URL = "http://localhost:3000";

export default function () {
  const res = http.get(`${BASE_URL}/api/users?page=1&limit=10`);

  check(res, {
    "status é 200": (r) => r.status === 200,
  });
}
