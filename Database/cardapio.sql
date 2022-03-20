--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

-- Started on 2022-03-19 21:24:23

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16739)
-- Name: config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.config (
    vl_entrega numeric(5,2)
);


ALTER TABLE public.config OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16773)
-- Name: pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido (
    id_pedido integer NOT NULL,
    id_usuario integer NOT NULL,
    dt_pedido timestamp without time zone,
    vl_subtotal numeric(9,2),
    vl_entrega numeric(5,2),
    vl_total numeric(9,2),
    status character(1)
);


ALTER TABLE public.pedido OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16772)
-- Name: pedido_id_pedido_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedido_id_pedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pedido_id_pedido_seq OWNER TO postgres;

--
-- TOC entry 3362 (class 0 OID 0)
-- Dependencies: 216
-- Name: pedido_id_pedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_id_pedido_seq OWNED BY public.pedido.id_pedido;


--
-- TOC entry 219 (class 1259 OID 16785)
-- Name: pedido_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido_item (
    id_item integer NOT NULL,
    id_pedido integer,
    id_produto integer,
    qtd numeric(9,3),
    vl_unitario numeric(9,2),
    vl_total numeric(9,2)
);


ALTER TABLE public.pedido_item OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16784)
-- Name: pedido_item_id_item_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedido_item_id_item_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pedido_item_id_item_seq OWNER TO postgres;

--
-- TOC entry 3363 (class 0 OID 0)
-- Dependencies: 218
-- Name: pedido_item_id_item_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_item_id_item_seq OWNED BY public.pedido_item.id_item;


--
-- TOC entry 215 (class 1259 OID 16759)
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto (
    id_produto integer NOT NULL,
    id_categoria integer NOT NULL,
    nome character varying(100),
    descricao character varying(1000),
    preco numeric(9,2),
    url_foto character varying(1000)
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16750)
-- Name: produto_categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto_categoria (
    id_categoria integer NOT NULL,
    descricao character varying(100),
    ordem numeric
);


ALTER TABLE public.produto_categoria OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16749)
-- Name: produto_categoria_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produto_categoria_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produto_categoria_id_categoria_seq OWNER TO postgres;

--
-- TOC entry 3364 (class 0 OID 0)
-- Dependencies: 212
-- Name: produto_categoria_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produto_categoria_id_categoria_seq OWNED BY public.produto_categoria.id_categoria;


--
-- TOC entry 214 (class 1259 OID 16758)
-- Name: produto_id_produto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produto_id_produto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produto_id_produto_seq OWNER TO postgres;

--
-- TOC entry 3365 (class 0 OID 0)
-- Dependencies: 214
-- Name: produto_id_produto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produto_id_produto_seq OWNED BY public.produto.id_produto;


--
-- TOC entry 211 (class 1259 OID 16743)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    nome character varying(100),
    email character varying(100),
    senha character varying(50),
    endereco character varying(100),
    bairro character varying(50),
    cidade character varying(50),
    uf character varying(2),
    cep character varying(10),
    dt_cadastro timestamp without time zone
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16742)
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_id_usuario_seq OWNER TO postgres;

--
-- TOC entry 3366 (class 0 OID 0)
-- Dependencies: 210
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;


--
-- TOC entry 3191 (class 2604 OID 16776)
-- Name: pedido id_pedido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido ALTER COLUMN id_pedido SET DEFAULT nextval('public.pedido_id_pedido_seq'::regclass);


--
-- TOC entry 3192 (class 2604 OID 16788)
-- Name: pedido_item id_item; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_item ALTER COLUMN id_item SET DEFAULT nextval('public.pedido_item_id_item_seq'::regclass);


--
-- TOC entry 3190 (class 2604 OID 16762)
-- Name: produto id_produto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto ALTER COLUMN id_produto SET DEFAULT nextval('public.produto_id_produto_seq'::regclass);


--
-- TOC entry 3189 (class 2604 OID 16753)
-- Name: produto_categoria id_categoria; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_categoria ALTER COLUMN id_categoria SET DEFAULT nextval('public.produto_categoria_id_categoria_seq'::regclass);


--
-- TOC entry 3188 (class 2604 OID 16746)
-- Name: usuario id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);


--
-- TOC entry 3346 (class 0 OID 16739)
-- Dependencies: 209
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config (vl_entrega) FROM stdin;
4.00
\.


--
-- TOC entry 3354 (class 0 OID 16773)
-- Dependencies: 217
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido (id_pedido, id_usuario, dt_pedido, vl_subtotal, vl_entrega, vl_total, status) FROM stdin;
3	1	2022-03-19 10:50:24.914384	85.60	4.00	89.60	A
4	1	2022-03-19 20:10:24.204391	33.90	4.00	37.90	A
\.


--
-- TOC entry 3356 (class 0 OID 16785)
-- Dependencies: 219
-- Data for Name: pedido_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido_item (id_item, id_pedido, id_produto, qtd, vl_unitario, vl_total) FROM stdin;
3	\N	\N	2.000	33.80	67.60
4	\N	\N	3.000	6.00	18.00
5	4	17	1.000	33.90	33.90
\.


--
-- TOC entry 3352 (class 0 OID 16759)
-- Dependencies: 215
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto (id_produto, id_categoria, nome, descricao, preco, url_foto) FROM stdin;
15	1	X-Salada Picanha	Pão,hamburguer de picanha 150 g,queijo prato, alface, tomate, maionese hamburguinho.	33.80	https://jornada-dev2.s3.amazonaws.com/xsalada.jpg
16	1	Cheese Steak	Rosbife 120g, cheddar e cebola frita, servido no pão de queijo.	35.00	https://jornada-dev2.s3.amazonaws.com/xespaco_fama.jpg
17	1	X-Tudo	Pão, hambúrguer de carne angus, alface, tomate e queijo prato.	33.90	https://jornada-dev2.s3.amazonaws.com/xtudo.png
18	2	X-Egg	Pão, hambúrguer de carne angus, queijo prato e ovo.	24.90	https://jornada-dev2.s3.amazonaws.com/xegg.jpg
19	2	X-Bacon	Pão, hambúrguer de carne angus, queijo prato e bacon.	27.90	https://jornada-dev2.s3.amazonaws.com/xbacon.jpg
20	2	X-Filé Frango	Pão, filet de frango e queijo prato.	25.60	https://jornada-dev2.s3.amazonaws.com/x-frango-egg.png
21	2	X-Cebola Maionese	Pão, hambúrguer de 150g (angus), queijo prato, cebola frita e maionese artesanal.	28.90	https://jornada-dev2.s3.amazonaws.com/xcebola.png
22	3	Hot Dog Tradicional	Pão de Hot Dog, 1 Salsicha, Ketchup, Maionese, Mostarda e Batata Palha	14.50	https://jornada-dev2.s3.amazonaws.com/dog1.png
23	3	Hot Dog Soja	Salsicha de soja, requeijão, oregano, cheddar, vinagrete, milho, maionese, batata palha, pure e parmesão (vegetariano ou vegano)	28.00	https://jornada-dev2.s3.amazonaws.com/dog2.png
24	3	Hot Dogão	Quatro salsichas, requeijão, oregano, cheddar, vinagrete, milho, maionese, batata palha, pure e parmesão	31.00	https://jornada-dev2.s3.amazonaws.com/dog3.png
25	4	Coca-Cola Lata	Refrigerante Coca-Cola lata 350ml	6.00	https://jornada-dev2.s3.amazonaws.com/coca-cola.png
26	4	Água mineral	Água mineral 330ml	4.00	https://jornada-dev2.s3.amazonaws.com/agua.png
27	4	Schweppes	Schweppes citrus 350ml	6.00	https://jornada-dev2.s3.amazonaws.com/Schweppes.png
28	4	Sprite Lemon	Sprite Lemon fresh 500ml	8.90	https://jornada-dev2.s3.amazonaws.com/sprite.png
\.


--
-- TOC entry 3350 (class 0 OID 16750)
-- Dependencies: 213
-- Data for Name: produto_categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto_categoria (id_categoria, descricao, ordem) FROM stdin;
1	Ofertas	1
2	Burgers	2
3	Dogs	3
4	Bebidas	4
\.


--
-- TOC entry 3348 (class 0 OID 16743)
-- Dependencies: 211
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id_usuario, nome, email, senha, endereco, bairro, cidade, uf, cep, dt_cadastro) FROM stdin;
1	Heber Mazutti	heber@teste.com.br	123	Rua São Bento, 850	Centro	São Paulo	SP	02410-010	2022-03-18 22:05:09.109376
\.


--
-- TOC entry 3367 (class 0 OID 0)
-- Dependencies: 216
-- Name: pedido_id_pedido_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_id_pedido_seq', 4, true);


--
-- TOC entry 3368 (class 0 OID 0)
-- Dependencies: 218
-- Name: pedido_item_id_item_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_item_id_item_seq', 5, true);


--
-- TOC entry 3369 (class 0 OID 0)
-- Dependencies: 212
-- Name: produto_categoria_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_categoria_id_categoria_seq', 4, true);


--
-- TOC entry 3370 (class 0 OID 0)
-- Dependencies: 214
-- Name: produto_id_produto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_id_produto_seq', 28, true);


--
-- TOC entry 3371 (class 0 OID 0)
-- Dependencies: 210
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 1, true);


--
-- TOC entry 3202 (class 2606 OID 16790)
-- Name: pedido_item pedido_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_item
    ADD CONSTRAINT pedido_item_pkey PRIMARY KEY (id_item);


--
-- TOC entry 3200 (class 2606 OID 16778)
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (id_pedido);


--
-- TOC entry 3196 (class 2606 OID 16757)
-- Name: produto_categoria produto_categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_categoria
    ADD CONSTRAINT produto_categoria_pkey PRIMARY KEY (id_categoria);


--
-- TOC entry 3198 (class 2606 OID 16766)
-- Name: produto produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id_produto);


--
-- TOC entry 3194 (class 2606 OID 16748)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 3204 (class 2606 OID 16779)
-- Name: pedido pedido_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


--
-- TOC entry 3205 (class 2606 OID 16791)
-- Name: pedido_item pedido_item_id_pedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_item
    ADD CONSTRAINT pedido_item_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES public.pedido(id_pedido);


--
-- TOC entry 3206 (class 2606 OID 16796)
-- Name: pedido_item pedido_item_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_item
    ADD CONSTRAINT pedido_item_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produto(id_produto);


--
-- TOC entry 3203 (class 2606 OID 16767)
-- Name: produto produto_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.produto_categoria(id_categoria);


-- Completed on 2022-03-19 21:24:24

--
-- PostgreSQL database dump complete
--

