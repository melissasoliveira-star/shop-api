// Importa o framework Express para criação das rotas
const express = require("express");

// Cria uma instância do roteador do Express para definir as rotas de produto
const router = express.Router();

// Importa o repositório de produtos, responsável pela comunicação com o banco de dados
const productRepo = require("../repositories/productRepository");

// GET /api/products
// Retorna a lista de todos os produtos cadastrados
router.get("/", async (req, res) => {
  try {
    const { nome } = req.query;
    let products;
    if (nome) {
      products = await productRepo.findProductByNome(nome);
    } else {
      const page = parseInt(req.query.page) || 1;
      const limit = Math.min(parseInt(req.query.limit) || 10, 100);

      products = await productRepo.findAllProducts({ page, limit });
    }

    return res.json(products);
  } catch (err) {
    console.error("Erro ao buscar produtos:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// GET /api/products/:id
// Retorna um produto específico pelo seu ID
// Responde com 404 se o produto não for encontrado
router.get("/:id", async (req, res) => {
  try {
    const product = await productRepo.findProductById(req.params.id);
    if (!product)
      return res.status(404).json({ message: "Produto não encontrado" });
    return res.json(product);
  } catch (err) {
    console.error("Erro ao buscar produto:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// POST /api/products/
// Cria um produto e retorna o produto criado para o usuário
// Responde com 500 se não puder criar
router.post("/", async (req, res) => {
  const { nome, preco, estoque } = req.body;
  const descricao = req.body.descricao || null;

  if (!nome || !preco || !estoque) {
    return res
      .status(400)
      .json({ error: "Nome, preço e estoque são obrigatórios." });
  }

  try {
    const product = await productRepo.createProduct({
      nome,
      descricao,
      preco,
      estoque,
    });
    return res.status(201).json(product);
  } catch (err) {
    console.error("Erro ao criar produto:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// PUT /api/products/:id
// Atualiza os dados de um produto existente pelo seu ID
// Apenas os campos enviados no corpo serão alterados (os demais mantêm o valor atual)
// Responde com 404 se o produto não for encontrado
router.put("/:id", async (req, res) => {
  const { nome, descricao, preco, estoque } = req.body;

  try {
    const product = await productRepo.updateProduct(req.params.id, {
      nome,
      descricao,
      preco,
      estoque,
    });

    if (!product)
      return res.status(404).json({ message: "Produto não encontrado" });

    return res.json(product);
  } catch (err) {
    console.error("Erro ao atualizar produto:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// DELETE /api/products/:id
// Remove um produto pelo seu ID
// Responde com 404 se o produto não for encontrado
// Responde com 400 se o produto possuir pedidos vinculados (violação de chave estrangeira)
router.delete("/:id", async (req, res) => {
  try {
    const deleted = await productRepo.deleteProduct(req.params.id);

    if (!deleted) {
      return res.status(404).json({ message: "Produto não encontrado" });
    }

    return res.json({ message: "Produto removido", dados: deleted });
  } catch (err) {
    if (err.code === "23503") {
      return res.status(400).json({
        message:
          "Não é possível apagar: este produto possui pedidos registrados.",
      });
    }
    console.error("Erro ao apagar produto:", err);
    res.status(500).send("Erro interno do servidor");
  }
});

// Exporta o roteador para ser utilizado na aplicação principal
module.exports = router;
