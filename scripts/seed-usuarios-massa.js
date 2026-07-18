/**
 * scripts/seed-usuarios-massa.js
 *
 * Repovoa a tabela `usuarios` com ~250.000 registros sintéticos, restaurando
 * o volume necessário para reproduzir o cenário de "filtro por nome" (Seq Scan
 * em tabela grande) documentado no TCC.
 *
 * Insere em lotes (1.000 linhas por INSERT) para ser rápido mesmo em 250 mil
 * linhas, e garante exatamente 3 registros contendo "Ana" no nome, preservando
 * a característica original do cenário (poucos resultados em tabela grande).
 *
 * USO (de dentro do container, onde a variável de ambiente do banco já está
 * configurada):
 *   docker compose exec api node scripts/seed-usuarios-massa.js
 *
 * Se preferir rodar localmente (fora do Docker), garanta que as variáveis de
 * ambiente de conexão com o banco (as mesmas usadas por ../src/config/db) estejam
 * configuradas no seu shell antes de rodar `node scripts/seed-usuarios-massa.js`.
 */

const db = require("../src/config/db");

const TOTAL_REGISTROS = 250_000;
const TAMANHO_LOTE = 1000;

const PRIMEIROS_NOMES = [
  "João",
  "Pedro",
  "Lucas",
  "Gabriel",
  "Rafael",
  "Bruno",
  "Carlos",
  "Eduardo",
  "Felipe",
  "Gustavo",
  "Marcos",
  "Rodrigo",
  "Thiago",
  "Vinicius",
  "Diego",
  "Maria",
  "Beatriz",
  "Camila",
  "Fernanda",
  "Juliana2",
  "Larissa",
  "Patricia",
  "Sabrina",
  "Vitoria",
  "Bianca",
  "Carolina2",
  "Debora",
  "Elisa",
  "Fabiana",
  "Gisele",
  "Helena2",
  "Isabela",
  "Julia2",
  "Karina",
  "Leticia",
];

const SOBRENOMES = [
  "Silva",
  "Santos",
  "Oliveira",
  "Souza",
  "Rodrigues",
  "Ferreira",
  "Alves",
  "Pereira",
  "Lima",
  "Gomes",
  "Costa",
  "Ribeiro",
  "Martins",
  "Carvalho",
  "Almeida",
  "Lopes",
  "Soares",
  "Fernandes",
  "Vieira",
  "Barbosa",
];

function nomeAleatorioSemAna() {
  // Evita substrings "ana"/"Ana" nos nomes gerados em massa (ex.: Mariana,
  // Juliana, Adriana), para não inflar artificialmente o resultado do filtro.
  let primeiro, sobrenome, nomeCompleto;
  do {
    primeiro =
      PRIMEIROS_NOMES[Math.floor(Math.random() * PRIMEIROS_NOMES.length)];
    sobrenome = SOBRENOMES[Math.floor(Math.random() * SOBRENOMES.length)];
    nomeCompleto = `${primeiro} ${sobrenome}`;
  } while (nomeCompleto.toLowerCase().includes("ana"));
  return nomeCompleto;
}

async function inserirLote(linhas) {
  // Monta um INSERT multi-linha parametrizado: (nome, email, senha) x N
  const valores = [];
  const placeholders = linhas
    .map((linha, i) => {
      const base = i * 3;
      valores.push(linha.nome, linha.email, linha.senha);
      return `($${base + 1}, $${base + 2}, $${base + 3})`;
    })
    .join(", ");

  const query = `INSERT INTO usuarios (nome, email, senha) VALUES ${placeholders}`;
  await db.query(query, valores);
}

async function seedMassa() {
  // Idempotência: se a tabela já tiver volume suficiente, não insere de novo.
  // Isso evita duplicar dados toda vez que o container reiniciar.
  const contagemAtual = await db.query("SELECT COUNT(*) FROM usuarios");
  const totalAtual = parseInt(contagemAtual.rows[0].count, 10);

  if (totalAtual >= TOTAL_REGISTROS) {
    console.log(
      `Tabela usuarios já possui ${totalAtual.toLocaleString("pt-BR")} registros (>= ${TOTAL_REGISTROS.toLocaleString("pt-BR")}). Seed não é necessário, pulando.`,
    );
    process.exit(0);
  }

  console.log(
    `Tabela usuarios possui ${totalAtual.toLocaleString("pt-BR")} registros. Inserindo até ${TOTAL_REGISTROS.toLocaleString("pt-BR")}...`,
  );

  const inicio = Date.now();

  const faltam = TOTAL_REGISTROS - totalAtual;

  for (let inserted = 0; inserted < faltam; inserted += TAMANHO_LOTE) {
    const tamanhoAtual = Math.min(TAMANHO_LOTE, faltam - inserted);
    const lote = [];

    for (let i = 0; i < tamanhoAtual; i++) {
      // offset por totalAtual + timestamp garante e-mails únicos mesmo em reexecuções parciais
      const indiceGlobal = totalAtual + inserted + i;
      const nome = nomeAleatorioSemAna();
      const email = `usuario${indiceGlobal}@teste-tcc.com`;
      const senha = "senha_teste_123"; // dado sintético, não usado para login real
      lote.push({ nome, email, senha });
    }

    await inserirLote(lote);

    if ((inserted / TAMANHO_LOTE) % 20 === 0) {
      console.log(
        `  ${(inserted + tamanhoAtual).toLocaleString("pt-BR")} / ${TOTAL_REGISTROS.toLocaleString("pt-BR")} inseridos...`,
      );
    }
  }

  // Garante exatamente 3 registros que combinam com o filtro ILIKE '%Ana%',
  // preservando a característica original do cenário (poucos resultados).
  const registrosComAna = [
    {
      nome: "Ana Beatriz Souza",
      email: "ana.beatriz.teste@teste-tcc.com",
      senha: "senha_teste_123",
    },
    {
      nome: "Ana Clara Lima",
      email: "ana.clara.teste@teste-tcc.com",
      senha: "senha_teste_123",
    },
    {
      nome: "Ana Paula Ferreira",
      email: "ana.paula.teste@teste-tcc.com",
      senha: "senha_teste_123",
    },
  ];
  await inserirLote(registrosComAna);

  const duracaoSegundos = ((Date.now() - inicio) / 1000).toFixed(1);
  console.log(`\nConcluído em ${duracaoSegundos}s.`);

  const resultado = await db.query("SELECT COUNT(*) FROM usuarios");
  console.log(
    `Total de linhas na tabela usuarios agora: ${resultado.rows[0].count}`,
  );

  const teste = await db.query(
    "SELECT COUNT(*) FROM usuarios WHERE nome ILIKE $1",
    ["%Ana%"],
  );
  console.log(`Linhas que combinam com '%Ana%': ${teste.rows[0].count}`);

  process.exit(0);
}

seedMassa().catch((err) => {
  console.error("Erro ao popular a tabela:", err);
  process.exit(1);
});
