-- tabela de usuários --

CREATE TABLE usuarios (
    id          SERIAL                          PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    senha       VARCHAR(255) NOT NULL,
    criado_em   TIMESTAMP                       DEFAULT CURRENT_TIMESTAMP
);

-- tabela de produtos --

CREATE TABLE produtos (
    id          SERIAL                  PRIMARY KEY,
    nome        VARCHAR(250) NOT NULL,
    descricao   TEXT,
    preco       DECIMAL(10, 2) NOT NULL, -- Suporta até 99.999.999,99
    estoque     INT                     DEFAULT 0,
    criado_em   TIMESTAMP               DEFAULT CURRENT_TIMESTAMP
);

-- tabela de pedidos --

CREATE TABLE pedidos (
    id          SERIAL                      PRIMARY KEY,
    usuario_id  INT                         REFERENCES usuarios(id)     ON DELETE CASCADE,
    total       DECIMAL(10, 2) NOT NULL,
    data_pedido TIMESTAMP                   DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE itens_pedido (
    id              SERIAL                  PRIMARY KEY,
    pedido_id       INT NOT NULL,
    produto_id      INT NOT NULL,
    quantidade      INT NOT NULL            CHECK (quantidade > 0),
    preco_unitario  NUMERIC(10,2) NOT NULL  CHECK (preco_unitario >= 0),

    CONSTRAINT fk_itens_pedido_pedido
        FOREIGN KEY (pedido_id)
        REFERENCES pedidos(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_itens_pedido_produto
        FOREIGN KEY (produto_id)
        REFERENCES produtos(id),

    CONSTRAINT uq_pedido_produto
        UNIQUE (pedido_id, produto_id)
);

INSERT INTO usuarios (nome, email) VALUES 
('Ana Silva', 'ana.silva@email.com'),
('Bruno Oliveira', 'bruno.o@email.com'),
('Carla Souza', 'carla.souza@email.com');

INSERT INTO produtos (nome, descricao, preco, estoque) VALUES 
('Teclado Mecânico RGB', 'Teclado switch blue com iluminação personalizável', 250.00, 15),
('Mouse Gamer 16000 DPI', 'Mouse ergonômico com 6 botões programáveis', 120.50, 20),
('Monitor 24" Full HD', 'Monitor IPS com taxa de actualização de 75Hz', 899.90, 8),
('Tapete de Mouse XL', 'Superfície de baixa fricção para jogos', 45.00, 50);

INSERT INTO pedidos (usuario_id, total) VALUES 
(1, 370.50), -- Um pedido da Ana
(2, 899.90), -- Um pedido do Bruno
(1, 45.00);  -- Outro pedido da Ana

INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES 
-- Itens do Pedido 1 (Ana: Teclado + Mouse)
(1, 1, 1, 250.00),
(1, 2, 1, 120.50),

-- Itens do Pedido 2 (Bruno: Monitor)
(2, 3, 1, 899.90),

-- Itens do Pedido 3 (Ana: Tapete)
(3, 4, 1, 45.00);

INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES 
(1, 1, 1, 249.80),
(2, 3, 1, 899.90),
(3, 4, 1, 45.00);