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

-- Dados de teste para as tabelas
-- Ordem de inserção respeita as chaves estrangeiras: usuarios -> produtos -> pedidos -> itens_pedido

-- NOTA: Os testes de listagem e filtro foram executados com base populada
-- com 100 usuários e 100 produtos, gerados via ferramenta de Inteligência Artificial
-- (Claude), utilizando nomes e descrições fictícias, e senhas hash simuladas para fins de teste.

-- 100 usuarios
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (1, 'Ana Silva', 'ana.silva001@exemplo.com', '$2b$12$hash.ficticio.usuario.001.somente.teste', CURRENT_TIMESTAMP - INTERVAL '100 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (2, 'Bruno Santos', 'bruno.santos002@exemplo.com', '$2b$12$hash.ficticio.usuario.002.somente.teste', CURRENT_TIMESTAMP - INTERVAL '99 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (3, 'Carla Oliveira', 'carla.oliveira003@exemplo.com', '$2b$12$hash.ficticio.usuario.003.somente.teste', CURRENT_TIMESTAMP - INTERVAL '98 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (4, 'Diego Souza', 'diego.souza004@exemplo.com', '$2b$12$hash.ficticio.usuario.004.somente.teste', CURRENT_TIMESTAMP - INTERVAL '97 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (5, 'Eduarda Pereira', 'eduarda.pereira005@exemplo.com', '$2b$12$hash.ficticio.usuario.005.somente.teste', CURRENT_TIMESTAMP - INTERVAL '96 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (6, 'Felipe Costa', 'felipe.costa006@exemplo.com', '$2b$12$hash.ficticio.usuario.006.somente.teste', CURRENT_TIMESTAMP - INTERVAL '95 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (7, 'Gabriela Almeida', 'gabriela.almeida007@exemplo.com', '$2b$12$hash.ficticio.usuario.007.somente.teste', CURRENT_TIMESTAMP - INTERVAL '94 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (8, 'Henrique Ferreira', 'henrique.ferreira008@exemplo.com', '$2b$12$hash.ficticio.usuario.008.somente.teste', CURRENT_TIMESTAMP - INTERVAL '93 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (9, 'Isabela Rodrigues', 'isabela.rodrigues009@exemplo.com', '$2b$12$hash.ficticio.usuario.009.somente.teste', CURRENT_TIMESTAMP - INTERVAL '92 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (10, 'Joao Gomes', 'joao.gomes010@exemplo.com', '$2b$12$hash.ficticio.usuario.010.somente.teste', CURRENT_TIMESTAMP - INTERVAL '91 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (11, 'Karen Martins', 'karen.martins011@exemplo.com', '$2b$12$hash.ficticio.usuario.011.somente.teste', CURRENT_TIMESTAMP - INTERVAL '90 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (12, 'Lucas Barbosa', 'lucas.barbosa012@exemplo.com', '$2b$12$hash.ficticio.usuario.012.somente.teste', CURRENT_TIMESTAMP - INTERVAL '89 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (13, 'Marina Ribeiro', 'marina.ribeiro013@exemplo.com', '$2b$12$hash.ficticio.usuario.013.somente.teste', CURRENT_TIMESTAMP - INTERVAL '88 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (14, 'Nicolas Carvalho', 'nicolas.carvalho014@exemplo.com', '$2b$12$hash.ficticio.usuario.014.somente.teste', CURRENT_TIMESTAMP - INTERVAL '87 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (15, 'Olivia Lima', 'olivia.lima015@exemplo.com', '$2b$12$hash.ficticio.usuario.015.somente.teste', CURRENT_TIMESTAMP - INTERVAL '86 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (16, 'Pedro Mendes', 'pedro.mendes016@exemplo.com', '$2b$12$hash.ficticio.usuario.016.somente.teste', CURRENT_TIMESTAMP - INTERVAL '85 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (17, 'Quiteria Nascimento', 'quiteria.nascimento017@exemplo.com', '$2b$12$hash.ficticio.usuario.017.somente.teste', CURRENT_TIMESTAMP - INTERVAL '84 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (18, 'Rafael Araujo', 'rafael.araujo018@exemplo.com', '$2b$12$hash.ficticio.usuario.018.somente.teste', CURRENT_TIMESTAMP - INTERVAL '83 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (19, 'Sofia Castro', 'sofia.castro019@exemplo.com', '$2b$12$hash.ficticio.usuario.019.somente.teste', CURRENT_TIMESTAMP - INTERVAL '82 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (20, 'Thiago Rocha', 'thiago.rocha020@exemplo.com', '$2b$12$hash.ficticio.usuario.020.somente.teste', CURRENT_TIMESTAMP - INTERVAL '81 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (21, 'Ursula Silva', 'ursula.silva021@exemplo.com', '$2b$12$hash.ficticio.usuario.021.somente.teste', CURRENT_TIMESTAMP - INTERVAL '80 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (22, 'Victor Santos', 'victor.santos022@exemplo.com', '$2b$12$hash.ficticio.usuario.022.somente.teste', CURRENT_TIMESTAMP - INTERVAL '79 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (23, 'Wendy Oliveira', 'wendy.oliveira023@exemplo.com', '$2b$12$hash.ficticio.usuario.023.somente.teste', CURRENT_TIMESTAMP - INTERVAL '78 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (24, 'Xavier Souza', 'xavier.souza024@exemplo.com', '$2b$12$hash.ficticio.usuario.024.somente.teste', CURRENT_TIMESTAMP - INTERVAL '77 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (25, 'Yasmin Pereira', 'yasmin.pereira025@exemplo.com', '$2b$12$hash.ficticio.usuario.025.somente.teste', CURRENT_TIMESTAMP - INTERVAL '76 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (26, 'Zeca Costa', 'zeca.costa026@exemplo.com', '$2b$12$hash.ficticio.usuario.026.somente.teste', CURRENT_TIMESTAMP - INTERVAL '75 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (27, 'Beatriz Almeida', 'beatriz.almeida027@exemplo.com', '$2b$12$hash.ficticio.usuario.027.somente.teste', CURRENT_TIMESTAMP - INTERVAL '74 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (28, 'Caio Ferreira', 'caio.ferreira028@exemplo.com', '$2b$12$hash.ficticio.usuario.028.somente.teste', CURRENT_TIMESTAMP - INTERVAL '73 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (29, 'Daniela Rodrigues', 'daniela.rodrigues029@exemplo.com', '$2b$12$hash.ficticio.usuario.029.somente.teste', CURRENT_TIMESTAMP - INTERVAL '72 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (30, 'Enzo Gomes', 'enzo.gomes030@exemplo.com', '$2b$12$hash.ficticio.usuario.030.somente.teste', CURRENT_TIMESTAMP - INTERVAL '71 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (31, 'Fernanda Martins', 'fernanda.martins031@exemplo.com', '$2b$12$hash.ficticio.usuario.031.somente.teste', CURRENT_TIMESTAMP - INTERVAL '70 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (32, 'Gustavo Barbosa', 'gustavo.barbosa032@exemplo.com', '$2b$12$hash.ficticio.usuario.032.somente.teste', CURRENT_TIMESTAMP - INTERVAL '69 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (33, 'Helena Ribeiro', 'helena.ribeiro033@exemplo.com', '$2b$12$hash.ficticio.usuario.033.somente.teste', CURRENT_TIMESTAMP - INTERVAL '68 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (34, 'Igor Carvalho', 'igor.carvalho034@exemplo.com', '$2b$12$hash.ficticio.usuario.034.somente.teste', CURRENT_TIMESTAMP - INTERVAL '67 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (35, 'Julia Lima', 'julia.lima035@exemplo.com', '$2b$12$hash.ficticio.usuario.035.somente.teste', CURRENT_TIMESTAMP - INTERVAL '66 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (36, 'Leonardo Mendes', 'leonardo.mendes036@exemplo.com', '$2b$12$hash.ficticio.usuario.036.somente.teste', CURRENT_TIMESTAMP - INTERVAL '65 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (37, 'Manuela Nascimento', 'manuela.nascimento037@exemplo.com', '$2b$12$hash.ficticio.usuario.037.somente.teste', CURRENT_TIMESTAMP - INTERVAL '64 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (38, 'Otavio Araujo', 'otavio.araujo038@exemplo.com', '$2b$12$hash.ficticio.usuario.038.somente.teste', CURRENT_TIMESTAMP - INTERVAL '63 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (39, 'Patricia Castro', 'patricia.castro039@exemplo.com', '$2b$12$hash.ficticio.usuario.039.somente.teste', CURRENT_TIMESTAMP - INTERVAL '62 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (40, 'Renato Rocha', 'renato.rocha040@exemplo.com', '$2b$12$hash.ficticio.usuario.040.somente.teste', CURRENT_TIMESTAMP - INTERVAL '61 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (41, 'Talita Silva', 'talita.silva041@exemplo.com', '$2b$12$hash.ficticio.usuario.041.somente.teste', CURRENT_TIMESTAMP - INTERVAL '60 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (42, 'Vinicius Santos', 'vinicius.santos042@exemplo.com', '$2b$12$hash.ficticio.usuario.042.somente.teste', CURRENT_TIMESTAMP - INTERVAL '59 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (43, 'Larissa Oliveira', 'larissa.oliveira043@exemplo.com', '$2b$12$hash.ficticio.usuario.043.somente.teste', CURRENT_TIMESTAMP - INTERVAL '58 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (44, 'Mateus Souza', 'mateus.souza044@exemplo.com', '$2b$12$hash.ficticio.usuario.044.somente.teste', CURRENT_TIMESTAMP - INTERVAL '57 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (45, 'Bianca Pereira', 'bianca.pereira045@exemplo.com', '$2b$12$hash.ficticio.usuario.045.somente.teste', CURRENT_TIMESTAMP - INTERVAL '56 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (46, 'Rodrigo Costa', 'rodrigo.costa046@exemplo.com', '$2b$12$hash.ficticio.usuario.046.somente.teste', CURRENT_TIMESTAMP - INTERVAL '55 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (47, 'Camila Almeida', 'camila.almeida047@exemplo.com', '$2b$12$hash.ficticio.usuario.047.somente.teste', CURRENT_TIMESTAMP - INTERVAL '54 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (48, 'Samuel Ferreira', 'samuel.ferreira048@exemplo.com', '$2b$12$hash.ficticio.usuario.048.somente.teste', CURRENT_TIMESTAMP - INTERVAL '53 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (49, 'Leticia Rodrigues', 'leticia.rodrigues049@exemplo.com', '$2b$12$hash.ficticio.usuario.049.somente.teste', CURRENT_TIMESTAMP - INTERVAL '52 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (50, 'Andre Gomes', 'andre.gomes050@exemplo.com', '$2b$12$hash.ficticio.usuario.050.somente.teste', CURRENT_TIMESTAMP - INTERVAL '51 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (51, 'Ana Martins', 'ana.martins051@exemplo.com', '$2b$12$hash.ficticio.usuario.051.somente.teste', CURRENT_TIMESTAMP - INTERVAL '50 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (52, 'Bruno Barbosa', 'bruno.barbosa052@exemplo.com', '$2b$12$hash.ficticio.usuario.052.somente.teste', CURRENT_TIMESTAMP - INTERVAL '49 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (53, 'Carla Ribeiro', 'carla.ribeiro053@exemplo.com', '$2b$12$hash.ficticio.usuario.053.somente.teste', CURRENT_TIMESTAMP - INTERVAL '48 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (54, 'Diego Carvalho', 'diego.carvalho054@exemplo.com', '$2b$12$hash.ficticio.usuario.054.somente.teste', CURRENT_TIMESTAMP - INTERVAL '47 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (55, 'Eduarda Lima', 'eduarda.lima055@exemplo.com', '$2b$12$hash.ficticio.usuario.055.somente.teste', CURRENT_TIMESTAMP - INTERVAL '46 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (56, 'Felipe Mendes', 'felipe.mendes056@exemplo.com', '$2b$12$hash.ficticio.usuario.056.somente.teste', CURRENT_TIMESTAMP - INTERVAL '45 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (57, 'Gabriela Nascimento', 'gabriela.nascimento057@exemplo.com', '$2b$12$hash.ficticio.usuario.057.somente.teste', CURRENT_TIMESTAMP - INTERVAL '44 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (58, 'Henrique Araujo', 'henrique.araujo058@exemplo.com', '$2b$12$hash.ficticio.usuario.058.somente.teste', CURRENT_TIMESTAMP - INTERVAL '43 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (59, 'Isabela Castro', 'isabela.castro059@exemplo.com', '$2b$12$hash.ficticio.usuario.059.somente.teste', CURRENT_TIMESTAMP - INTERVAL '42 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (60, 'Joao Rocha', 'joao.rocha060@exemplo.com', '$2b$12$hash.ficticio.usuario.060.somente.teste', CURRENT_TIMESTAMP - INTERVAL '41 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (61, 'Karen Silva', 'karen.silva061@exemplo.com', '$2b$12$hash.ficticio.usuario.061.somente.teste', CURRENT_TIMESTAMP - INTERVAL '40 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (62, 'Lucas Santos', 'lucas.santos062@exemplo.com', '$2b$12$hash.ficticio.usuario.062.somente.teste', CURRENT_TIMESTAMP - INTERVAL '39 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (63, 'Marina Oliveira', 'marina.oliveira063@exemplo.com', '$2b$12$hash.ficticio.usuario.063.somente.teste', CURRENT_TIMESTAMP - INTERVAL '38 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (64, 'Nicolas Souza', 'nicolas.souza064@exemplo.com', '$2b$12$hash.ficticio.usuario.064.somente.teste', CURRENT_TIMESTAMP - INTERVAL '37 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (65, 'Olivia Pereira', 'olivia.pereira065@exemplo.com', '$2b$12$hash.ficticio.usuario.065.somente.teste', CURRENT_TIMESTAMP - INTERVAL '36 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (66, 'Pedro Costa', 'pedro.costa066@exemplo.com', '$2b$12$hash.ficticio.usuario.066.somente.teste', CURRENT_TIMESTAMP - INTERVAL '35 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (67, 'Quiteria Almeida', 'quiteria.almeida067@exemplo.com', '$2b$12$hash.ficticio.usuario.067.somente.teste', CURRENT_TIMESTAMP - INTERVAL '34 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (68, 'Rafael Ferreira', 'rafael.ferreira068@exemplo.com', '$2b$12$hash.ficticio.usuario.068.somente.teste', CURRENT_TIMESTAMP - INTERVAL '33 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (69, 'Sofia Rodrigues', 'sofia.rodrigues069@exemplo.com', '$2b$12$hash.ficticio.usuario.069.somente.teste', CURRENT_TIMESTAMP - INTERVAL '32 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (70, 'Thiago Gomes', 'thiago.gomes070@exemplo.com', '$2b$12$hash.ficticio.usuario.070.somente.teste', CURRENT_TIMESTAMP - INTERVAL '31 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (71, 'Ursula Martins', 'ursula.martins071@exemplo.com', '$2b$12$hash.ficticio.usuario.071.somente.teste', CURRENT_TIMESTAMP - INTERVAL '30 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (72, 'Victor Barbosa', 'victor.barbosa072@exemplo.com', '$2b$12$hash.ficticio.usuario.072.somente.teste', CURRENT_TIMESTAMP - INTERVAL '29 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (73, 'Wendy Ribeiro', 'wendy.ribeiro073@exemplo.com', '$2b$12$hash.ficticio.usuario.073.somente.teste', CURRENT_TIMESTAMP - INTERVAL '28 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (74, 'Xavier Carvalho', 'xavier.carvalho074@exemplo.com', '$2b$12$hash.ficticio.usuario.074.somente.teste', CURRENT_TIMESTAMP - INTERVAL '27 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (75, 'Yasmin Lima', 'yasmin.lima075@exemplo.com', '$2b$12$hash.ficticio.usuario.075.somente.teste', CURRENT_TIMESTAMP - INTERVAL '26 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (76, 'Zeca Mendes', 'zeca.mendes076@exemplo.com', '$2b$12$hash.ficticio.usuario.076.somente.teste', CURRENT_TIMESTAMP - INTERVAL '25 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (77, 'Beatriz Nascimento', 'beatriz.nascimento077@exemplo.com', '$2b$12$hash.ficticio.usuario.077.somente.teste', CURRENT_TIMESTAMP - INTERVAL '24 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (78, 'Caio Araujo', 'caio.araujo078@exemplo.com', '$2b$12$hash.ficticio.usuario.078.somente.teste', CURRENT_TIMESTAMP - INTERVAL '23 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (79, 'Daniela Castro', 'daniela.castro079@exemplo.com', '$2b$12$hash.ficticio.usuario.079.somente.teste', CURRENT_TIMESTAMP - INTERVAL '22 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (80, 'Enzo Rocha', 'enzo.rocha080@exemplo.com', '$2b$12$hash.ficticio.usuario.080.somente.teste', CURRENT_TIMESTAMP - INTERVAL '21 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (81, 'Fernanda Silva', 'fernanda.silva081@exemplo.com', '$2b$12$hash.ficticio.usuario.081.somente.teste', CURRENT_TIMESTAMP - INTERVAL '20 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (82, 'Gustavo Santos', 'gustavo.santos082@exemplo.com', '$2b$12$hash.ficticio.usuario.082.somente.teste', CURRENT_TIMESTAMP - INTERVAL '19 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (83, 'Helena Oliveira', 'helena.oliveira083@exemplo.com', '$2b$12$hash.ficticio.usuario.083.somente.teste', CURRENT_TIMESTAMP - INTERVAL '18 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (84, 'Igor Souza', 'igor.souza084@exemplo.com', '$2b$12$hash.ficticio.usuario.084.somente.teste', CURRENT_TIMESTAMP - INTERVAL '17 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (85, 'Julia Pereira', 'julia.pereira085@exemplo.com', '$2b$12$hash.ficticio.usuario.085.somente.teste', CURRENT_TIMESTAMP - INTERVAL '16 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (86, 'Leonardo Costa', 'leonardo.costa086@exemplo.com', '$2b$12$hash.ficticio.usuario.086.somente.teste', CURRENT_TIMESTAMP - INTERVAL '15 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (87, 'Manuela Almeida', 'manuela.almeida087@exemplo.com', '$2b$12$hash.ficticio.usuario.087.somente.teste', CURRENT_TIMESTAMP - INTERVAL '14 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (88, 'Otavio Ferreira', 'otavio.ferreira088@exemplo.com', '$2b$12$hash.ficticio.usuario.088.somente.teste', CURRENT_TIMESTAMP - INTERVAL '13 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (89, 'Patricia Rodrigues', 'patricia.rodrigues089@exemplo.com', '$2b$12$hash.ficticio.usuario.089.somente.teste', CURRENT_TIMESTAMP - INTERVAL '12 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (90, 'Renato Gomes', 'renato.gomes090@exemplo.com', '$2b$12$hash.ficticio.usuario.090.somente.teste', CURRENT_TIMESTAMP - INTERVAL '11 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (91, 'Talita Martins', 'talita.martins091@exemplo.com', '$2b$12$hash.ficticio.usuario.091.somente.teste', CURRENT_TIMESTAMP - INTERVAL '10 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (92, 'Vinicius Barbosa', 'vinicius.barbosa092@exemplo.com', '$2b$12$hash.ficticio.usuario.092.somente.teste', CURRENT_TIMESTAMP - INTERVAL '9 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (93, 'Larissa Ribeiro', 'larissa.ribeiro093@exemplo.com', '$2b$12$hash.ficticio.usuario.093.somente.teste', CURRENT_TIMESTAMP - INTERVAL '8 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (94, 'Mateus Carvalho', 'mateus.carvalho094@exemplo.com', '$2b$12$hash.ficticio.usuario.094.somente.teste', CURRENT_TIMESTAMP - INTERVAL '7 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (95, 'Bianca Lima', 'bianca.lima095@exemplo.com', '$2b$12$hash.ficticio.usuario.095.somente.teste', CURRENT_TIMESTAMP - INTERVAL '6 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (96, 'Rodrigo Mendes', 'rodrigo.mendes096@exemplo.com', '$2b$12$hash.ficticio.usuario.096.somente.teste', CURRENT_TIMESTAMP - INTERVAL '5 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (97, 'Camila Nascimento', 'camila.nascimento097@exemplo.com', '$2b$12$hash.ficticio.usuario.097.somente.teste', CURRENT_TIMESTAMP - INTERVAL '4 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (98, 'Samuel Araujo', 'samuel.araujo098@exemplo.com', '$2b$12$hash.ficticio.usuario.098.somente.teste', CURRENT_TIMESTAMP - INTERVAL '3 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (99, 'Leticia Castro', 'leticia.castro099@exemplo.com', '$2b$12$hash.ficticio.usuario.099.somente.teste', CURRENT_TIMESTAMP - INTERVAL '2 days');
INSERT INTO usuarios (id, nome, email, senha, criado_em) VALUES (100, 'Andre Rocha', 'andre.rocha100@exemplo.com', '$2b$12$hash.ficticio.usuario.100.somente.teste', CURRENT_TIMESTAMP - INTERVAL '1 days');

-- 100 produtos
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (1, 'Notebook Pro 14 - Modelo 1', 'Notebook leve com tela de alta resolução e SSD rápido', 4899.90, 12, CURRENT_TIMESTAMP - INTERVAL '99 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (2, 'Mouse Sem Fio - Modelo 1', 'Mouse ergonômico com conexão USB e bateria de longa duração', 89.90, 19, CURRENT_TIMESTAMP - INTERVAL '98 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (3, 'Teclado Mecânico - Modelo 1', 'Teclado com switches táteis e iluminação ajustável', 329.90, 26, CURRENT_TIMESTAMP - INTERVAL '97 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (4, 'Monitor 27 Polegadas - Modelo 1', 'Monitor Full HD com bordas finas e suporte ajustável', 1199.00, 33, CURRENT_TIMESTAMP - INTERVAL '96 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (5, 'Cadeira Ergonômica - Modelo 1', 'Cadeira de escritório com apoio lombar e regulagem de altura', 899.90, 40, CURRENT_TIMESTAMP - INTERVAL '95 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (6, 'Headset Gamer - Modelo 1', 'Headset com microfone removível e som estéreo', 249.90, 47, CURRENT_TIMESTAMP - INTERVAL '94 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (7, 'Webcam Full HD - Modelo 1', 'Webcam com foco automático para reuniões e streaming', 219.90, 54, CURRENT_TIMESTAMP - INTERVAL '93 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (8, 'Hub USB-C - Modelo 1', 'Adaptador USB-C com HDMI, USB e leitor de cartão', 159.90, 61, CURRENT_TIMESTAMP - INTERVAL '92 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (9, 'SSD 1TB - Modelo 1', 'Unidade SSD NVMe de alta velocidade', 529.90, 68, CURRENT_TIMESTAMP - INTERVAL '91 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (10, 'Memória RAM 16GB - Modelo 1', 'Módulo DDR4 para upgrade de desempenho', 289.90, 75, CURRENT_TIMESTAMP - INTERVAL '90 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (11, 'Cabo HDMI - Modelo 1', 'Cabo HDMI 2.0 de 2 metros', 39.90, 82, CURRENT_TIMESTAMP - INTERVAL '89 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (12, 'Carregador USB-C - Modelo 1', 'Carregador rápido compacto com proteção contra sobrecarga', 119.90, 89, CURRENT_TIMESTAMP - INTERVAL '88 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (13, 'Suporte para Notebook - Modelo 1', 'Suporte dobrável com ajuste de altura', 99.90, 96, CURRENT_TIMESTAMP - INTERVAL '87 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (14, 'Mesa Digitalizadora - Modelo 1', 'Mesa compacta para desenho e edição', 399.90, 7, CURRENT_TIMESTAMP - INTERVAL '86 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (15, 'Impressora Multifuncional - Modelo 1', 'Impressora com scanner e conexão Wi-Fi', 749.90, 14, CURRENT_TIMESTAMP - INTERVAL '85 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (16, 'Roteador Wi-Fi - Modelo 1', 'Roteador dual-band para alta cobertura', 279.90, 21, CURRENT_TIMESTAMP - INTERVAL '84 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (17, 'Caixa de Som Bluetooth - Modelo 1', 'Caixa portátil com graves reforçados', 189.90, 28, CURRENT_TIMESTAMP - INTERVAL '83 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (18, 'Microfone USB - Modelo 1', 'Microfone condensador para chamadas e gravações', 349.90, 35, CURRENT_TIMESTAMP - INTERVAL '82 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (19, 'Ring Light - Modelo 1', 'Iluminação circular com tripé ajustável', 139.90, 42, CURRENT_TIMESTAMP - INTERVAL '81 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (20, 'Power Bank 20000mAh - Modelo 1', 'Bateria externa de alta capacidade', 179.90, 49, CURRENT_TIMESTAMP - INTERVAL '80 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (21, 'Notebook Pro 14 - Modelo 2', 'Notebook leve com tela de alta resolução e SSD rápido', 4917.40, 56, CURRENT_TIMESTAMP - INTERVAL '79 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (22, 'Mouse Sem Fio - Modelo 2', 'Mouse ergonômico com conexão USB e bateria de longa duração', 107.40, 63, CURRENT_TIMESTAMP - INTERVAL '78 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (23, 'Teclado Mecânico - Modelo 2', 'Teclado com switches táteis e iluminação ajustável', 347.40, 70, CURRENT_TIMESTAMP - INTERVAL '77 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (24, 'Monitor 27 Polegadas - Modelo 2', 'Monitor Full HD com bordas finas e suporte ajustável', 1216.50, 77, CURRENT_TIMESTAMP - INTERVAL '76 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (25, 'Cadeira Ergonômica - Modelo 2', 'Cadeira de escritório com apoio lombar e regulagem de altura', 917.40, 84, CURRENT_TIMESTAMP - INTERVAL '75 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (26, 'Headset Gamer - Modelo 2', 'Headset com microfone removível e som estéreo', 267.40, 91, CURRENT_TIMESTAMP - INTERVAL '74 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (27, 'Webcam Full HD - Modelo 2', 'Webcam com foco automático para reuniões e streaming', 237.40, 98, CURRENT_TIMESTAMP - INTERVAL '73 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (28, 'Hub USB-C - Modelo 2', 'Adaptador USB-C com HDMI, USB e leitor de cartão', 177.40, 9, CURRENT_TIMESTAMP - INTERVAL '72 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (29, 'SSD 1TB - Modelo 2', 'Unidade SSD NVMe de alta velocidade', 547.40, 16, CURRENT_TIMESTAMP - INTERVAL '71 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (30, 'Memória RAM 16GB - Modelo 2', 'Módulo DDR4 para upgrade de desempenho', 307.40, 23, CURRENT_TIMESTAMP - INTERVAL '70 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (31, 'Cabo HDMI - Modelo 2', 'Cabo HDMI 2.0 de 2 metros', 57.40, 30, CURRENT_TIMESTAMP - INTERVAL '69 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (32, 'Carregador USB-C - Modelo 2', 'Carregador rápido compacto com proteção contra sobrecarga', 137.40, 37, CURRENT_TIMESTAMP - INTERVAL '68 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (33, 'Suporte para Notebook - Modelo 2', 'Suporte dobrável com ajuste de altura', 117.40, 44, CURRENT_TIMESTAMP - INTERVAL '67 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (34, 'Mesa Digitalizadora - Modelo 2', 'Mesa compacta para desenho e edição', 417.40, 51, CURRENT_TIMESTAMP - INTERVAL '66 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (35, 'Impressora Multifuncional - Modelo 2', 'Impressora com scanner e conexão Wi-Fi', 767.40, 58, CURRENT_TIMESTAMP - INTERVAL '65 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (36, 'Roteador Wi-Fi - Modelo 2', 'Roteador dual-band para alta cobertura', 297.40, 65, CURRENT_TIMESTAMP - INTERVAL '64 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (37, 'Caixa de Som Bluetooth - Modelo 2', 'Caixa portátil com graves reforçados', 207.40, 72, CURRENT_TIMESTAMP - INTERVAL '63 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (38, 'Microfone USB - Modelo 2', 'Microfone condensador para chamadas e gravações', 367.40, 79, CURRENT_TIMESTAMP - INTERVAL '62 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (39, 'Ring Light - Modelo 2', 'Iluminação circular com tripé ajustável', 157.40, 86, CURRENT_TIMESTAMP - INTERVAL '61 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (40, 'Power Bank 20000mAh - Modelo 2', 'Bateria externa de alta capacidade', 197.40, 93, CURRENT_TIMESTAMP - INTERVAL '60 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (41, 'Notebook Pro 14 - Modelo 3', 'Notebook leve com tela de alta resolução e SSD rápido', 4934.90, 100, CURRENT_TIMESTAMP - INTERVAL '59 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (42, 'Mouse Sem Fio - Modelo 3', 'Mouse ergonômico com conexão USB e bateria de longa duração', 124.90, 11, CURRENT_TIMESTAMP - INTERVAL '58 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (43, 'Teclado Mecânico - Modelo 3', 'Teclado com switches táteis e iluminação ajustável', 364.90, 18, CURRENT_TIMESTAMP - INTERVAL '57 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (44, 'Monitor 27 Polegadas - Modelo 3', 'Monitor Full HD com bordas finas e suporte ajustável', 1234.00, 25, CURRENT_TIMESTAMP - INTERVAL '56 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (45, 'Cadeira Ergonômica - Modelo 3', 'Cadeira de escritório com apoio lombar e regulagem de altura', 934.90, 32, CURRENT_TIMESTAMP - INTERVAL '55 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (46, 'Headset Gamer - Modelo 3', 'Headset com microfone removível e som estéreo', 284.90, 39, CURRENT_TIMESTAMP - INTERVAL '54 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (47, 'Webcam Full HD - Modelo 3', 'Webcam com foco automático para reuniões e streaming', 254.90, 46, CURRENT_TIMESTAMP - INTERVAL '53 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (48, 'Hub USB-C - Modelo 3', 'Adaptador USB-C com HDMI, USB e leitor de cartão', 194.90, 53, CURRENT_TIMESTAMP - INTERVAL '52 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (49, 'SSD 1TB - Modelo 3', 'Unidade SSD NVMe de alta velocidade', 564.90, 60, CURRENT_TIMESTAMP - INTERVAL '51 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (50, 'Memória RAM 16GB - Modelo 3', 'Módulo DDR4 para upgrade de desempenho', 324.90, 67, CURRENT_TIMESTAMP - INTERVAL '50 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (51, 'Cabo HDMI - Modelo 3', 'Cabo HDMI 2.0 de 2 metros', 74.90, 74, CURRENT_TIMESTAMP - INTERVAL '49 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (52, 'Carregador USB-C - Modelo 3', 'Carregador rápido compacto com proteção contra sobrecarga', 154.90, 81, CURRENT_TIMESTAMP - INTERVAL '48 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (53, 'Suporte para Notebook - Modelo 3', 'Suporte dobrável com ajuste de altura', 134.90, 88, CURRENT_TIMESTAMP - INTERVAL '47 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (54, 'Mesa Digitalizadora - Modelo 3', 'Mesa compacta para desenho e edição', 434.90, 95, CURRENT_TIMESTAMP - INTERVAL '46 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (55, 'Impressora Multifuncional - Modelo 3', 'Impressora com scanner e conexão Wi-Fi', 784.90, 6, CURRENT_TIMESTAMP - INTERVAL '45 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (56, 'Roteador Wi-Fi - Modelo 3', 'Roteador dual-band para alta cobertura', 314.90, 13, CURRENT_TIMESTAMP - INTERVAL '44 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (57, 'Caixa de Som Bluetooth - Modelo 3', 'Caixa portátil com graves reforçados', 224.90, 20, CURRENT_TIMESTAMP - INTERVAL '43 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (58, 'Microfone USB - Modelo 3', 'Microfone condensador para chamadas e gravações', 384.90, 27, CURRENT_TIMESTAMP - INTERVAL '42 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (59, 'Ring Light - Modelo 3', 'Iluminação circular com tripé ajustável', 174.90, 34, CURRENT_TIMESTAMP - INTERVAL '41 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (60, 'Power Bank 20000mAh - Modelo 3', 'Bateria externa de alta capacidade', 214.90, 41, CURRENT_TIMESTAMP - INTERVAL '40 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (61, 'Notebook Pro 14 - Modelo 4', 'Notebook leve com tela de alta resolução e SSD rápido', 4952.40, 48, CURRENT_TIMESTAMP - INTERVAL '39 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (62, 'Mouse Sem Fio - Modelo 4', 'Mouse ergonômico com conexão USB e bateria de longa duração', 142.40, 55, CURRENT_TIMESTAMP - INTERVAL '38 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (63, 'Teclado Mecânico - Modelo 4', 'Teclado com switches táteis e iluminação ajustável', 382.40, 62, CURRENT_TIMESTAMP - INTERVAL '37 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (64, 'Monitor 27 Polegadas - Modelo 4', 'Monitor Full HD com bordas finas e suporte ajustável', 1251.50, 69, CURRENT_TIMESTAMP - INTERVAL '36 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (65, 'Cadeira Ergonômica - Modelo 4', 'Cadeira de escritório com apoio lombar e regulagem de altura', 952.40, 76, CURRENT_TIMESTAMP - INTERVAL '35 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (66, 'Headset Gamer - Modelo 4', 'Headset com microfone removível e som estéreo', 302.40, 83, CURRENT_TIMESTAMP - INTERVAL '34 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (67, 'Webcam Full HD - Modelo 4', 'Webcam com foco automático para reuniões e streaming', 272.40, 90, CURRENT_TIMESTAMP - INTERVAL '33 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (68, 'Hub USB-C - Modelo 4', 'Adaptador USB-C com HDMI, USB e leitor de cartão', 212.40, 97, CURRENT_TIMESTAMP - INTERVAL '32 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (69, 'SSD 1TB - Modelo 4', 'Unidade SSD NVMe de alta velocidade', 582.40, 8, CURRENT_TIMESTAMP - INTERVAL '31 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (70, 'Memória RAM 16GB - Modelo 4', 'Módulo DDR4 para upgrade de desempenho', 342.40, 15, CURRENT_TIMESTAMP - INTERVAL '30 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (71, 'Cabo HDMI - Modelo 4', 'Cabo HDMI 2.0 de 2 metros', 92.40, 22, CURRENT_TIMESTAMP - INTERVAL '29 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (72, 'Carregador USB-C - Modelo 4', 'Carregador rápido compacto com proteção contra sobrecarga', 172.40, 29, CURRENT_TIMESTAMP - INTERVAL '28 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (73, 'Suporte para Notebook - Modelo 4', 'Suporte dobrável com ajuste de altura', 152.40, 36, CURRENT_TIMESTAMP - INTERVAL '27 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (74, 'Mesa Digitalizadora - Modelo 4', 'Mesa compacta para desenho e edição', 452.40, 43, CURRENT_TIMESTAMP - INTERVAL '26 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (75, 'Impressora Multifuncional - Modelo 4', 'Impressora com scanner e conexão Wi-Fi', 802.40, 50, CURRENT_TIMESTAMP - INTERVAL '25 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (76, 'Roteador Wi-Fi - Modelo 4', 'Roteador dual-band para alta cobertura', 332.40, 57, CURRENT_TIMESTAMP - INTERVAL '24 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (77, 'Caixa de Som Bluetooth - Modelo 4', 'Caixa portátil com graves reforçados', 242.40, 64, CURRENT_TIMESTAMP - INTERVAL '23 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (78, 'Microfone USB - Modelo 4', 'Microfone condensador para chamadas e gravações', 402.40, 71, CURRENT_TIMESTAMP - INTERVAL '22 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (79, 'Ring Light - Modelo 4', 'Iluminação circular com tripé ajustável', 192.40, 78, CURRENT_TIMESTAMP - INTERVAL '21 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (80, 'Power Bank 20000mAh - Modelo 4', 'Bateria externa de alta capacidade', 232.40, 85, CURRENT_TIMESTAMP - INTERVAL '20 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (81, 'Notebook Pro 14 - Modelo 5', 'Notebook leve com tela de alta resolução e SSD rápido', 4969.90, 92, CURRENT_TIMESTAMP - INTERVAL '19 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (82, 'Mouse Sem Fio - Modelo 5', 'Mouse ergonômico com conexão USB e bateria de longa duração', 159.90, 99, CURRENT_TIMESTAMP - INTERVAL '18 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (83, 'Teclado Mecânico - Modelo 5', 'Teclado com switches táteis e iluminação ajustável', 399.90, 10, CURRENT_TIMESTAMP - INTERVAL '17 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (84, 'Monitor 27 Polegadas - Modelo 5', 'Monitor Full HD com bordas finas e suporte ajustável', 1269.00, 17, CURRENT_TIMESTAMP - INTERVAL '16 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (85, 'Cadeira Ergonômica - Modelo 5', 'Cadeira de escritório com apoio lombar e regulagem de altura', 969.90, 24, CURRENT_TIMESTAMP - INTERVAL '15 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (86, 'Headset Gamer - Modelo 5', 'Headset com microfone removível e som estéreo', 319.90, 31, CURRENT_TIMESTAMP - INTERVAL '14 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (87, 'Webcam Full HD - Modelo 5', 'Webcam com foco automático para reuniões e streaming', 289.90, 38, CURRENT_TIMESTAMP - INTERVAL '13 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (88, 'Hub USB-C - Modelo 5', 'Adaptador USB-C com HDMI, USB e leitor de cartão', 229.90, 45, CURRENT_TIMESTAMP - INTERVAL '12 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (89, 'SSD 1TB - Modelo 5', 'Unidade SSD NVMe de alta velocidade', 599.90, 52, CURRENT_TIMESTAMP - INTERVAL '11 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (90, 'Memória RAM 16GB - Modelo 5', 'Módulo DDR4 para upgrade de desempenho', 359.90, 59, CURRENT_TIMESTAMP - INTERVAL '10 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (91, 'Cabo HDMI - Modelo 5', 'Cabo HDMI 2.0 de 2 metros', 109.90, 66, CURRENT_TIMESTAMP - INTERVAL '9 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (92, 'Carregador USB-C - Modelo 5', 'Carregador rápido compacto com proteção contra sobrecarga', 189.90, 73, CURRENT_TIMESTAMP - INTERVAL '8 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (93, 'Suporte para Notebook - Modelo 5', 'Suporte dobrável com ajuste de altura', 169.90, 80, CURRENT_TIMESTAMP - INTERVAL '7 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (94, 'Mesa Digitalizadora - Modelo 5', 'Mesa compacta para desenho e edição', 469.90, 87, CURRENT_TIMESTAMP - INTERVAL '6 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (95, 'Impressora Multifuncional - Modelo 5', 'Impressora com scanner e conexão Wi-Fi', 819.90, 94, CURRENT_TIMESTAMP - INTERVAL '5 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (96, 'Roteador Wi-Fi - Modelo 5', 'Roteador dual-band para alta cobertura', 349.90, 5, CURRENT_TIMESTAMP - INTERVAL '4 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (97, 'Caixa de Som Bluetooth - Modelo 5', 'Caixa portátil com graves reforçados', 259.90, 12, CURRENT_TIMESTAMP - INTERVAL '3 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (98, 'Microfone USB - Modelo 5', 'Microfone condensador para chamadas e gravações', 419.90, 19, CURRENT_TIMESTAMP - INTERVAL '2 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (99, 'Ring Light - Modelo 5', 'Iluminação circular com tripé ajustável', 209.90, 26, CURRENT_TIMESTAMP - INTERVAL '1 days');
INSERT INTO produtos (id, nome, descricao, preco, estoque, criado_em) VALUES (100, 'Power Bank 20000mAh - Modelo 5', 'Bateria externa de alta capacidade', 249.90, 33, CURRENT_TIMESTAMP - INTERVAL '0 days');

-- 100 pedidos
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (1, 1, 179.80, CURRENT_TIMESTAMP - INTERVAL '99 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (2, 2, 2699.70, CURRENT_TIMESTAMP - INTERVAL '98 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (3, 3, 639.60, CURRENT_TIMESTAMP - INTERVAL '97 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (4, 4, 39.90, CURRENT_TIMESTAMP - INTERVAL '96 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (5, 5, 799.80, CURRENT_TIMESTAMP - INTERVAL '95 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (6, 6, 569.70, CURRENT_TIMESTAMP - INTERVAL '94 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (7, 7, 719.60, CURRENT_TIMESTAMP - INTERVAL '93 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (8, 8, 347.40, CURRENT_TIMESTAMP - INTERVAL '92 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (9, 9, 534.80, CURRENT_TIMESTAMP - INTERVAL '91 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (10, 10, 1642.20, CURRENT_TIMESTAMP - INTERVAL '90 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (11, 11, 549.60, CURRENT_TIMESTAMP - INTERVAL '89 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (12, 12, 767.40, CURRENT_TIMESTAMP - INTERVAL '88 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (13, 13, 734.80, CURRENT_TIMESTAMP - INTERVAL '87 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (14, 14, 14804.70, CURRENT_TIMESTAMP - INTERVAL '86 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (15, 15, 4936.00, CURRENT_TIMESTAMP - INTERVAL '85 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (16, 16, 254.90, CURRENT_TIMESTAMP - INTERVAL '84 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (17, 17, 649.80, CURRENT_TIMESTAMP - INTERVAL '83 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (18, 18, 404.70, CURRENT_TIMESTAMP - INTERVAL '82 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (19, 19, 1259.60, CURRENT_TIMESTAMP - INTERVAL '81 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (20, 20, 174.90, CURRENT_TIMESTAMP - INTERVAL '80 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (21, 21, 284.80, CURRENT_TIMESTAMP - INTERVAL '79 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (22, 22, 2857.20, CURRENT_TIMESTAMP - INTERVAL '78 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (23, 23, 849.60, CURRENT_TIMESTAMP - INTERVAL '77 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (24, 24, 92.40, CURRENT_TIMESTAMP - INTERVAL '76 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (25, 25, 904.80, CURRENT_TIMESTAMP - INTERVAL '75 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (26, 26, 727.20, CURRENT_TIMESTAMP - INTERVAL '74 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (27, 27, 929.60, CURRENT_TIMESTAMP - INTERVAL '73 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (28, 28, 399.90, CURRENT_TIMESTAMP - INTERVAL '72 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (29, 29, 639.80, CURRENT_TIMESTAMP - INTERVAL '71 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (30, 30, 1799.70, CURRENT_TIMESTAMP - INTERVAL '70 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (31, 31, 759.60, CURRENT_TIMESTAMP - INTERVAL '69 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (32, 32, 819.90, CURRENT_TIMESTAMP - INTERVAL '68 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (33, 33, 839.80, CURRENT_TIMESTAMP - INTERVAL '67 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (34, 34, 14699.70, CURRENT_TIMESTAMP - INTERVAL '66 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (35, 35, 4796.00, CURRENT_TIMESTAMP - INTERVAL '65 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (36, 36, 219.90, CURRENT_TIMESTAMP - INTERVAL '64 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (37, 37, 579.80, CURRENT_TIMESTAMP - INTERVAL '63 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (38, 38, 299.70, CURRENT_TIMESTAMP - INTERVAL '62 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (39, 39, 1119.60, CURRENT_TIMESTAMP - INTERVAL '61 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (40, 40, 139.90, CURRENT_TIMESTAMP - INTERVAL '60 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (41, 41, 214.80, CURRENT_TIMESTAMP - INTERVAL '59 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (42, 42, 2752.20, CURRENT_TIMESTAMP - INTERVAL '58 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (43, 43, 709.60, CURRENT_TIMESTAMP - INTERVAL '57 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (44, 44, 57.40, CURRENT_TIMESTAMP - INTERVAL '56 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (45, 45, 834.80, CURRENT_TIMESTAMP - INTERVAL '55 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (46, 46, 622.20, CURRENT_TIMESTAMP - INTERVAL '54 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (47, 47, 789.60, CURRENT_TIMESTAMP - INTERVAL '53 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (48, 48, 364.90, CURRENT_TIMESTAMP - INTERVAL '52 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (49, 49, 569.80, CURRENT_TIMESTAMP - INTERVAL '51 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (50, 50, 1694.70, CURRENT_TIMESTAMP - INTERVAL '50 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (51, 51, 619.60, CURRENT_TIMESTAMP - INTERVAL '49 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (52, 52, 784.90, CURRENT_TIMESTAMP - INTERVAL '48 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (53, 53, 769.80, CURRENT_TIMESTAMP - INTERVAL '47 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (54, 54, 14857.20, CURRENT_TIMESTAMP - INTERVAL '46 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (55, 55, 5006.00, CURRENT_TIMESTAMP - INTERVAL '45 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (56, 56, 272.40, CURRENT_TIMESTAMP - INTERVAL '44 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (57, 57, 684.80, CURRENT_TIMESTAMP - INTERVAL '43 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (58, 58, 457.20, CURRENT_TIMESTAMP - INTERVAL '42 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (59, 59, 1329.60, CURRENT_TIMESTAMP - INTERVAL '41 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (60, 60, 192.40, CURRENT_TIMESTAMP - INTERVAL '40 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (61, 61, 319.80, CURRENT_TIMESTAMP - INTERVAL '39 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (62, 62, 2909.70, CURRENT_TIMESTAMP - INTERVAL '38 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (63, 63, 919.60, CURRENT_TIMESTAMP - INTERVAL '37 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (64, 64, 109.90, CURRENT_TIMESTAMP - INTERVAL '36 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (65, 65, 939.80, CURRENT_TIMESTAMP - INTERVAL '35 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (66, 66, 779.70, CURRENT_TIMESTAMP - INTERVAL '34 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (67, 67, 999.60, CURRENT_TIMESTAMP - INTERVAL '33 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (68, 68, 329.90, CURRENT_TIMESTAMP - INTERVAL '32 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (69, 69, 499.80, CURRENT_TIMESTAMP - INTERVAL '31 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (70, 70, 1589.70, CURRENT_TIMESTAMP - INTERVAL '30 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (71, 71, 479.60, CURRENT_TIMESTAMP - INTERVAL '29 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (72, 72, 749.90, CURRENT_TIMESTAMP - INTERVAL '28 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (73, 73, 699.80, CURRENT_TIMESTAMP - INTERVAL '27 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (74, 74, 14752.20, CURRENT_TIMESTAMP - INTERVAL '26 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (75, 75, 4866.00, CURRENT_TIMESTAMP - INTERVAL '25 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (76, 76, 237.40, CURRENT_TIMESTAMP - INTERVAL '24 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (77, 77, 614.80, CURRENT_TIMESTAMP - INTERVAL '23 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (78, 78, 352.20, CURRENT_TIMESTAMP - INTERVAL '22 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (79, 79, 1189.60, CURRENT_TIMESTAMP - INTERVAL '21 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (80, 80, 157.40, CURRENT_TIMESTAMP - INTERVAL '20 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (81, 81, 249.80, CURRENT_TIMESTAMP - INTERVAL '19 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (82, 82, 2804.70, CURRENT_TIMESTAMP - INTERVAL '18 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (83, 83, 779.60, CURRENT_TIMESTAMP - INTERVAL '17 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (84, 84, 74.90, CURRENT_TIMESTAMP - INTERVAL '16 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (85, 85, 869.80, CURRENT_TIMESTAMP - INTERVAL '15 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (86, 86, 674.70, CURRENT_TIMESTAMP - INTERVAL '14 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (87, 87, 859.60, CURRENT_TIMESTAMP - INTERVAL '13 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (88, 88, 382.40, CURRENT_TIMESTAMP - INTERVAL '12 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (89, 89, 604.80, CURRENT_TIMESTAMP - INTERVAL '11 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (90, 90, 1747.20, CURRENT_TIMESTAMP - INTERVAL '10 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (91, 91, 689.60, CURRENT_TIMESTAMP - INTERVAL '9 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (92, 92, 802.40, CURRENT_TIMESTAMP - INTERVAL '8 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (93, 93, 804.80, CURRENT_TIMESTAMP - INTERVAL '7 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (94, 94, 14909.70, CURRENT_TIMESTAMP - INTERVAL '6 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (95, 95, 5076.00, CURRENT_TIMESTAMP - INTERVAL '5 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (96, 96, 289.90, CURRENT_TIMESTAMP - INTERVAL '4 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (97, 97, 719.80, CURRENT_TIMESTAMP - INTERVAL '3 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (98, 98, 509.70, CURRENT_TIMESTAMP - INTERVAL '2 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (99, 99, 1399.60, CURRENT_TIMESTAMP - INTERVAL '1 days');
INSERT INTO pedidos (id, usuario_id, total, data_pedido) VALUES (100, 100, 209.90, CURRENT_TIMESTAMP - INTERVAL '0 days');

-- 100 itens_pedido
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (1, 1, 2, 2, 89.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (2, 2, 5, 3, 899.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (3, 3, 8, 4, 159.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (4, 4, 11, 1, 39.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (5, 5, 14, 2, 399.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (6, 6, 17, 3, 189.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (7, 7, 20, 4, 179.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (8, 8, 23, 1, 347.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (9, 9, 26, 2, 267.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (10, 10, 29, 3, 547.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (11, 11, 32, 4, 137.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (12, 12, 35, 1, 767.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (13, 13, 38, 2, 367.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (14, 14, 41, 3, 4934.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (15, 15, 44, 4, 1234.00);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (16, 16, 47, 1, 254.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (17, 17, 50, 2, 324.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (18, 18, 53, 3, 134.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (19, 19, 56, 4, 314.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (20, 20, 59, 1, 174.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (21, 21, 62, 2, 142.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (22, 22, 65, 3, 952.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (23, 23, 68, 4, 212.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (24, 24, 71, 1, 92.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (25, 25, 74, 2, 452.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (26, 26, 77, 3, 242.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (27, 27, 80, 4, 232.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (28, 28, 83, 1, 399.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (29, 29, 86, 2, 319.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (30, 30, 89, 3, 599.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (31, 31, 92, 4, 189.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (32, 32, 95, 1, 819.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (33, 33, 98, 2, 419.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (34, 34, 1, 3, 4899.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (35, 35, 4, 4, 1199.00);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (36, 36, 7, 1, 219.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (37, 37, 10, 2, 289.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (38, 38, 13, 3, 99.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (39, 39, 16, 4, 279.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (40, 40, 19, 1, 139.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (41, 41, 22, 2, 107.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (42, 42, 25, 3, 917.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (43, 43, 28, 4, 177.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (44, 44, 31, 1, 57.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (45, 45, 34, 2, 417.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (46, 46, 37, 3, 207.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (47, 47, 40, 4, 197.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (48, 48, 43, 1, 364.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (49, 49, 46, 2, 284.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (50, 50, 49, 3, 564.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (51, 51, 52, 4, 154.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (52, 52, 55, 1, 784.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (53, 53, 58, 2, 384.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (54, 54, 61, 3, 4952.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (55, 55, 64, 4, 1251.50);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (56, 56, 67, 1, 272.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (57, 57, 70, 2, 342.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (58, 58, 73, 3, 152.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (59, 59, 76, 4, 332.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (60, 60, 79, 1, 192.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (61, 61, 82, 2, 159.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (62, 62, 85, 3, 969.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (63, 63, 88, 4, 229.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (64, 64, 91, 1, 109.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (65, 65, 94, 2, 469.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (66, 66, 97, 3, 259.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (67, 67, 100, 4, 249.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (68, 68, 3, 1, 329.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (69, 69, 6, 2, 249.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (70, 70, 9, 3, 529.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (71, 71, 12, 4, 119.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (72, 72, 15, 1, 749.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (73, 73, 18, 2, 349.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (74, 74, 21, 3, 4917.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (75, 75, 24, 4, 1216.50);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (76, 76, 27, 1, 237.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (77, 77, 30, 2, 307.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (78, 78, 33, 3, 117.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (79, 79, 36, 4, 297.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (80, 80, 39, 1, 157.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (81, 81, 42, 2, 124.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (82, 82, 45, 3, 934.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (83, 83, 48, 4, 194.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (84, 84, 51, 1, 74.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (85, 85, 54, 2, 434.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (86, 86, 57, 3, 224.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (87, 87, 60, 4, 214.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (88, 88, 63, 1, 382.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (89, 89, 66, 2, 302.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (90, 90, 69, 3, 582.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (91, 91, 72, 4, 172.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (92, 92, 75, 1, 802.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (93, 93, 78, 2, 402.40);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (94, 94, 81, 3, 4969.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (95, 95, 84, 4, 1269.00);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (96, 96, 87, 1, 289.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (97, 97, 90, 2, 359.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (98, 98, 93, 3, 169.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (99, 99, 96, 4, 349.90);
INSERT INTO itens_pedido (id, pedido_id, produto_id, quantidade, preco_unitario) VALUES (100, 100, 99, 1, 209.90);

-- Ajusta as sequências SERIAL para não conflitar com os IDs inseridos manualmente
SELECT setval(pg_get_serial_sequence('usuarios', 'id'), COALESCE(MAX(id), 1), true) FROM usuarios;
SELECT setval(pg_get_serial_sequence('produtos', 'id'), COALESCE(MAX(id), 1), true) FROM produtos;
SELECT setval(pg_get_serial_sequence('pedidos', 'id'), COALESCE(MAX(id), 1), true) FROM pedidos;
SELECT setval(pg_get_serial_sequence('itens_pedido', 'id'), COALESCE(MAX(id), 1), true) FROM itens_pedido;