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

-- ============================================================
-- INSERTS DE DADOS DE TESTE — 50 pedidos com itens
-- Rodar após os inserts iniciais do queries.sql
-- ============================================================

INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES
  (4, 2, 120.50, '2025-01-13 23:17:00'),
  (5, 2, 1270.40, '2025-12-13 23:57:00'),
  (6, 4, 361.50, '2025-04-30 16:38:00'),
  (7, 9, 3289.70, '2025-08-03 07:28:00'),
  (8, 5, 545.00, '2025-03-21 06:48:00'),
  (9, 6, 3199.70, '2026-03-10 11:38:00'),
  (10, 2, 1034.90, '2025-07-13 02:35:00'),
  (11, 2, 340.00, '2025-01-24 21:14:00'),
  (12, 5, 286.00, '2025-08-21 20:53:00'),
  (13, 5, 361.50, '2025-12-26 21:41:00'),
  (14, 4, 1140.90, '2025-03-25 14:24:00'),
  (15, 4, 165.50, '2026-02-25 01:51:00'),
  (16, 10, 90.00, '2026-03-25 22:20:00'),
  (17, 7, 2699.70, '2025-03-15 08:08:00'),
  (18, 10, 861.50, '2025-08-08 18:25:00'),
  (19, 2, 361.50, '2026-01-22 01:55:00'),
  (20, 3, 3690.70, '2026-02-10 21:27:00'),
  (21, 5, 2670.30, '2025-10-11 00:43:00'),
  (22, 5, 2699.70, '2025-08-11 05:29:00'),
  (23, 3, 1239.90, '2025-09-17 03:55:00'),
  (24, 9, 1799.80, '2026-02-03 16:58:00'),
  (25, 1, 870.50, '2025-02-27 11:56:00'),
  (26, 2, 120.50, '2025-02-13 23:31:00'),
  (27, 7, 2434.80, '2025-10-09 05:16:00'),
  (28, 6, 120.50, '2025-08-13 16:28:00'),
  (29, 2, 1770.40, '2025-06-23 00:37:00'),
  (30, 1, 899.90, '2025-04-28 02:57:00'),
  (31, 9, 2820.20, '2025-05-02 08:42:00'),
  (32, 10, 295.00, '2025-10-23 15:15:00'),
  (33, 7, 3449.70, '2025-07-01 13:26:00'),
  (34, 2, 295.00, '2025-02-01 12:46:00'),
  (35, 9, 1799.80, '2025-08-18 04:27:00'),
  (36, 4, 1194.90, '2026-03-24 02:28:00'),
  (37, 7, 545.00, '2025-09-06 15:13:00'),
  (38, 7, 545.00, '2025-05-16 14:18:00'),
  (39, 4, 1511.40, '2025-01-30 18:47:00'),
  (40, 3, 250.00, '2025-09-15 16:10:00'),
  (41, 2, 45.00, '2025-11-01 02:43:00'),
  (42, 10, 500.00, '2025-05-07 18:38:00'),
  (43, 10, 2161.30, '2025-10-17 16:20:00'),
  (44, 4, 1110.40, '2025-05-16 12:08:00'),
  (45, 10, 1965.30, '2025-10-16 03:04:00'),
  (46, 4, 2834.70, '2025-07-09 09:10:00'),
  (47, 1, 656.50, '2025-12-08 17:19:00'),
  (48, 9, 2955.20, '2025-03-21 08:18:00'),
  (49, 5, 750.00, '2025-09-16 15:16:00'),
  (50, 7, 899.90, '2026-03-01 08:02:00'),
  (51, 5, 1694.90, '2025-03-24 23:28:00'),
  (52, 3, 165.50, '2025-10-07 01:53:00'),
  (53, 5, 2820.20, '2025-07-06 01:57:00');

INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
  (4, 2, 1, 120.50),
  (5, 1, 1, 250.00),
  (5, 3, 1, 899.90),
  (5, 2, 1, 120.50),
  (6, 2, 3, 120.50),
  (7, 3, 3, 899.90),
  (7, 1, 2, 250.00),
  (7, 4, 2, 45.00),
  (8, 1, 2, 250.00),
  (8, 4, 1, 45.00),
  (9, 1, 2, 250.00),
  (9, 3, 3, 899.90),
  (10, 3, 1, 899.90),
  (10, 4, 3, 45.00),
  (11, 1, 1, 250.00),
  (11, 4, 2, 45.00),
  (12, 2, 2, 120.50),
  (12, 4, 1, 45.00),
  (13, 2, 3, 120.50),
  (14, 2, 2, 120.50),
  (14, 3, 1, 899.90),
  (15, 4, 1, 45.00),
  (15, 2, 1, 120.50),
  (16, 4, 2, 45.00),
  (17, 3, 3, 899.90),
  (18, 2, 3, 120.50),
  (18, 1, 2, 250.00),
  (19, 2, 3, 120.50),
  (20, 1, 3, 250.00),
  (20, 2, 2, 120.50),
  (20, 3, 3, 899.90),
  (21, 1, 3, 250.00),
  (21, 3, 2, 899.90),
  (21, 2, 1, 120.50),
  (22, 3, 3, 899.90),
  (23, 3, 1, 899.90),
  (23, 4, 2, 45.00),
  (23, 1, 1, 250.00),
  (24, 3, 2, 899.90),
  (25, 2, 1, 120.50),
  (25, 1, 3, 250.00),
  (26, 2, 1, 120.50),
  (27, 4, 3, 45.00),
  (27, 1, 2, 250.00),
  (27, 3, 2, 899.90),
  (28, 2, 1, 120.50),
  (29, 2, 1, 120.50),
  (29, 3, 1, 899.90),
  (29, 1, 3, 250.00),
  (30, 3, 1, 899.90),
  (31, 2, 1, 120.50),
  (31, 3, 3, 899.90),
  (32, 4, 1, 45.00),
  (32, 1, 1, 250.00),
  (33, 1, 3, 250.00),
  (33, 3, 3, 899.90),
  (34, 1, 1, 250.00),
  (34, 4, 1, 45.00),
  (35, 3, 2, 899.90),
  (36, 1, 1, 250.00),
  (36, 4, 1, 45.00),
  (36, 3, 1, 899.90),
  (37, 1, 2, 250.00),
  (37, 4, 1, 45.00),
  (38, 4, 1, 45.00),
  (38, 1, 2, 250.00),
  (39, 1, 1, 250.00),
  (39, 3, 1, 899.90),
  (39, 2, 3, 120.50),
  (40, 1, 1, 250.00),
  (41, 4, 1, 45.00),
  (42, 1, 2, 250.00),
  (43, 2, 3, 120.50),
  (43, 3, 2, 899.90),
  (44, 3, 1, 899.90),
  (44, 2, 1, 120.50),
  (44, 4, 2, 45.00),
  (45, 2, 1, 120.50),
  (45, 3, 2, 899.90),
  (45, 4, 1, 45.00),
  (46, 3, 3, 899.90),
  (46, 4, 3, 45.00),
  (47, 1, 1, 250.00),
  (47, 4, 1, 45.00),
  (47, 2, 3, 120.50),
  (48, 2, 1, 120.50),
  (48, 3, 3, 899.90),
  (48, 4, 3, 45.00),
  (49, 1, 3, 250.00),
  (50, 3, 1, 899.90),
  (51, 4, 1, 45.00),
  (51, 3, 1, 899.90),
  (51, 1, 3, 250.00),
  (52, 2, 1, 120.50),
  (52, 4, 1, 45.00),
  (53, 2, 1, 120.50),
  (53, 3, 3, 899.90);

-- Ajusta a sequência do SERIAL para continuar corretamente após os inserts
SELECT setval('pedidos_id_seq', (SELECT MAX(id) FROM pedidos));
SELECT setval('itens_pedido_id_seq', (SELECT MAX(id) FROM itens_pedido));
