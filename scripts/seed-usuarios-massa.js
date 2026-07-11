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
  console.log(
    `Inserindo ${TOTAL_REGISTROS.toLocaleString("pt-BR")} usuários em lotes de ${TAMANHO_LOTE}...`,
  );

  const inicio = Date.now();

  for (let inserted = 0; inserted < TOTAL_REGISTROS; inserted += TAMANHO_LOTE) {
    const tamanhoAtual = Math.min(TAMANHO_LOTE, TOTAL_REGISTROS - inserted);
    const lote = [];

    for (let i = 0; i < tamanhoAtual; i++) {
      const indiceGlobal = inserted + i;
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
