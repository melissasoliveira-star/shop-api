#!/bin/sh
set -e

echo "Verificando necessidade de popular a base de dados de teste..."
node scripts/seed-usuarios-massa.js

echo "Iniciando aplicação..."
exec node src/server.js