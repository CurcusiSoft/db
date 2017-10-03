--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.4
-- Dumped by pg_dump version 9.5.8

-- Started on 2017-10-03 14:12:30 BOT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12435)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2231 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 205 (class 1255 OID 80328)
-- Name: is_reset_medidor(character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION is_reset_medidor(p_imei character) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
  
DECLARE
p_capacidad INTEGER := 0;
p_promedio INTEGER := 0;
p_resultado BOOLEAN := false;
BEGIN

p_promedio = (SELECT AVG(consumo)
		FROM lecturacion
		WHERE imei = p_imei);

p_capacidad = ( SELECT capacidad
	FROM medidor
	WHERE imei = p_imei and estado ='Habilitado');
	
IF (p_promedio <> 0 and p_capacidad <> 0 ) THEN
	p_resultado = (p_promedio * 1.5) >= p_capacidad;
END IF;

RETURN p_resultado;
END;
$$;


ALTER FUNCTION public.is_reset_medidor(p_imei character) OWNER TO postgres;

--
-- TOC entry 206 (class 1255 OID 80361)
-- Name: sp_procesar_tarea(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_procesar_tarea(p_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
 BEGIN
UPDATE public.tarea
   SET state='Procesado', process=now()
 WHERE id = p_id;
END;       
   $$;


ALTER FUNCTION public.sp_procesar_tarea(p_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 182 (class 1259 OID 80211)
-- Name: categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE categoria (
    id integer NOT NULL,
    codigo character(5) NOT NULL,
    precio real NOT NULL
);


ALTER TABLE categoria OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 80209)
-- Name: categoria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE categoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categoria_id_seq OWNER TO postgres;

--
-- TOC entry 2232 (class 0 OID 0)
-- Dependencies: 181
-- Name: categoria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE categoria_id_seq OWNED BY categoria.id;


--
-- TOC entry 187 (class 1259 OID 80227)
-- Name: connections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE connections (
    id integer NOT NULL,
    uid integer NOT NULL,
    ip character(20) NOT NULL,
    address character(50) NOT NULL,
    hostname character(20) NOT NULL,
    date_time character(30)
);


ALTER TABLE connections OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 80230)
-- Name: connections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE connections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE connections_id_seq OWNER TO postgres;

--
-- TOC entry 2233 (class 0 OID 0)
-- Dependencies: 188
-- Name: connections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE connections_id_seq OWNED BY connections.id;


--
-- TOC entry 186 (class 1259 OID 80223)
-- Name: lecturacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE lecturacion (
    id integer NOT NULL,
    imei character(30) NOT NULL,
    consumo integer NOT NULL,
    date_time character(30)
);


ALTER TABLE lecturacion OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 80221)
-- Name: lecturacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE lecturacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE lecturacion_id_seq OWNER TO postgres;

--
-- TOC entry 2234 (class 0 OID 0)
-- Dependencies: 185
-- Name: lecturacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE lecturacion_id_seq OWNED BY lecturacion.id;


--
-- TOC entry 184 (class 1259 OID 80217)
-- Name: medidor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE medidor (
    id integer NOT NULL,
    imei character(30) NOT NULL,
    estado character(15) NOT NULL,
    capacidad integer NOT NULL,
    nro_celular character(15) NOT NULL
);


ALTER TABLE medidor OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 80215)
-- Name: medidor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE medidor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE medidor_id_seq OWNER TO postgres;

--
-- TOC entry 2235 (class 0 OID 0)
-- Dependencies: 183
-- Name: medidor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE medidor_id_seq OWNED BY medidor.id;


--
-- TOC entry 192 (class 1259 OID 80349)
-- Name: tarea; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tarea (
    id integer NOT NULL,
    date_time character(30) NOT NULL,
    imei character(30) NOT NULL,
    ussd integer NOT NULL,
    state character(20) DEFAULT 'Pendiente'::bpchar NOT NULL,
    process timestamp without time zone
);


ALTER TABLE tarea OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 80347)
-- Name: tarea_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tarea_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tarea_id_seq OWNER TO postgres;

--
-- TOC entry 2236 (class 0 OID 0)
-- Dependencies: 191
-- Name: tarea_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tarea_id_seq OWNED BY tarea.id;


--
-- TOC entry 189 (class 1259 OID 80236)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE transactions (
    id integer NOT NULL,
    uid integer NOT NULL,
    data character(100) NOT NULL,
    date_time character(30)
);


ALTER TABLE transactions OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 80239)
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transactions_id_seq OWNER TO postgres;

--
-- TOC entry 2237 (class 0 OID 0)
-- Dependencies: 190
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- TOC entry 2091 (class 2604 OID 80214)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categoria ALTER COLUMN id SET DEFAULT nextval('categoria_id_seq'::regclass);


--
-- TOC entry 2094 (class 2604 OID 80232)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY connections ALTER COLUMN id SET DEFAULT nextval('connections_id_seq'::regclass);


--
-- TOC entry 2093 (class 2604 OID 80226)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lecturacion ALTER COLUMN id SET DEFAULT nextval('lecturacion_id_seq'::regclass);


--
-- TOC entry 2092 (class 2604 OID 80220)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY medidor ALTER COLUMN id SET DEFAULT nextval('medidor_id_seq'::regclass);


--
-- TOC entry 2096 (class 2604 OID 80352)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tarea ALTER COLUMN id SET DEFAULT nextval('tarea_id_seq'::regclass);


--
-- TOC entry 2095 (class 2604 OID 80241)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- TOC entry 2213 (class 0 OID 80211)
-- Dependencies: 182
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY categoria (id, codigo, precio) FROM stdin;
\.


--
-- TOC entry 2238 (class 0 OID 0)
-- Dependencies: 181
-- Name: categoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('categoria_id_seq', 1, false);


--
-- TOC entry 2218 (class 0 OID 80227)
-- Dependencies: 187
-- Data for Name: connections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY connections (id, uid, ip, address, hostname, date_time) FROM stdin;
202	45050	127.0.0.1           	localhost/127.0.0.1:45050                         	localhost           	2017-10-03 13:58:57.985       
203	45050	127.0.0.1           	localhost/127.0.0.1:45050                         	localhost           	2017-10-03 13:58:58.056       
204	45050	127.0.0.1           	localhost/127.0.0.1:45050                         	localhost           	2017-10-03 14:01:40.690       
205	45088	127.0.0.1           	localhost/127.0.0.1:45088                         	localhost           	2017-10-03 14:03:14.876       
206	45088	127.0.0.1           	localhost/127.0.0.1:45088                         	localhost           	2017-10-03 14:03:14.877       
207	45088	127.0.0.1           	localhost/127.0.0.1:45088                         	localhost           	2017-10-03 14:04:21.498       
208	45118	127.0.0.1           	localhost/127.0.0.1:45118                         	localhost           	2017-10-03 14:06:39.487       
209	45118	127.0.0.1           	localhost/127.0.0.1:45118                         	localhost           	2017-10-03 14:06:39.491       
210	45118	127.0.0.1           	localhost/127.0.0.1:45118                         	localhost           	2017-10-03 14:08:48.074       
\.


--
-- TOC entry 2239 (class 0 OID 0)
-- Dependencies: 188
-- Name: connections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('connections_id_seq', 210, true);


--
-- TOC entry 2217 (class 0 OID 80223)
-- Dependencies: 186
-- Data for Name: lecturacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY lecturacion (id, imei, consumo, date_time) FROM stdin;
39	261287                        	1259	2017-10-03 14:01:32.489       
40	261287                        	5520	2017-10-03 14:04:16.135       
41	261287                        	5500	2017-10-03 14:08:23.404       
\.


--
-- TOC entry 2240 (class 0 OID 0)
-- Dependencies: 185
-- Name: lecturacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('lecturacion_id_seq', 41, true);


--
-- TOC entry 2215 (class 0 OID 80217)
-- Dependencies: 184
-- Data for Name: medidor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY medidor (id, imei, estado, capacidad, nro_celular) FROM stdin;
1	261287                        	Habilitado     	13000	59178099568    
2	271287                        	Habilitado     	13000	78000123       
\.


--
-- TOC entry 2241 (class 0 OID 0)
-- Dependencies: 183
-- Name: medidor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('medidor_id_seq', 2, true);


--
-- TOC entry 2223 (class 0 OID 80349)
-- Dependencies: 192
-- Data for Name: tarea; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tarea (id, date_time, imei, ussd, state, process) FROM stdin;
5	2017-10-03 14:05              	261287                        	2	Procesado           	2017-10-03 14:07:05.456985
\.


--
-- TOC entry 2242 (class 0 OID 0)
-- Dependencies: 191
-- Name: tarea_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tarea_id_seq', 5, true);


--
-- TOC entry 2220 (class 0 OID 80236)
-- Dependencies: 189
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY transactions (id, uid, data, date_time) FROM stdin;
460	45050	CONNECT                                                                                             	2017-10-03 13:58:58.056       
461	45050	Read :  1 PULL_OPEN                                                                                 	2017-10-03 13:59:14.663       
462	45050	Write : {PUSH_IMEI}                                                                                 	2017-10-03 13:59:14.673       
463	45050	Read :  1 PULL_IMEI 4645                                                                            	2017-10-03 13:59:30.807       
464	45050	Write : {PUSH_LECTURACION}                                                                          	2017-10-03 13:59:31.551       
465	45050	Read :  1 PULL_IMEI 4645                                                                            	2017-10-03 13:59:42.734       
466	45050	Read :  1 PULL_OPEN                                                                                 	2017-10-03 14:00:30.616       
467	45050	Write : {PUSH_IMEI}                                                                                 	2017-10-03 14:00:30.621       
468	45050	Read :  1 PULL_IMEI 261287                                                                          	2017-10-03 14:00:52.210       
469	45050	Write : {PUSH_LECTURACION}                                                                          	2017-10-03 14:00:52.219       
470	45050	Read :  1 PULL_LECTURACION 1259                                                                     	2017-10-03 14:01:09.378       
471	45050	Write : {PUSH_CLOSE}                                                                                	2017-10-03 14:01:11.223       
472	45050	Read :  1 PULL_CLOSE 0                                                                              	2017-10-03 14:01:28.064       
473	45050	Write : {PUSH_CLOSE}                                                                                	2017-10-03 14:01:28.073       
474	45050	Read :  1 PULL_CLOSE 1                                                                              	2017-10-03 14:01:32.485       
475	45050	DISCONNECT OR SOCKET CLOSED                                                                         	2017-10-03 14:01:40.688       
476	45088	CONNECT                                                                                             	2017-10-03 14:03:14.877       
477	45088	Read :  2 PULL_OPEN                                                                                 	2017-10-03 14:03:19.775       
478	45088	Write : {PUSH_IMEI}                                                                                 	2017-10-03 14:03:19.784       
479	45088	Read :  2 PULL_IMEI 261287                                                                          	2017-10-03 14:03:33.826       
480	45088	Write : {PUSH_LECTURACION}                                                                          	2017-10-03 14:03:33.831       
481	45088	Read :  2 PULL_LECTURACION 5520                                                                     	2017-10-03 14:04:04.428       
482	45088	Write : {PUSH_CLOSE}                                                                                	2017-10-03 14:04:04.444       
483	45088	Read :  2 PULL_CLOSE 1                                                                              	2017-10-03 14:04:16.126       
484	45088	DISCONNECT OR SOCKET CLOSED                                                                         	2017-10-03 14:04:21.497       
485	45118	CONNECT                                                                                             	2017-10-03 14:06:39.491       
486	45118	Read :  1 PULL_OPEN                                                                                 	2017-10-03 14:06:44.290       
487	45118	Write : {PUSH_IMEI}                                                                                 	2017-10-03 14:06:44.297       
488	45118	Read :  1 PULL_IMEI 261287                                                                          	2017-10-03 14:07:04.164       
489	45118	Write : {PUSH_RESET}                                                                                	2017-10-03 14:07:04.173       
490	45118	Read :  2 PULL_OPEN                                                                                 	2017-10-03 14:07:25.722       
491	45118	Write : {PUSH_IMEI}                                                                                 	2017-10-03 14:07:25.727       
492	45118	Read :  2 PULL_IMEI 261287                                                                          	2017-10-03 14:07:42.390       
493	45118	Write : {PUSH_LECTURACION}                                                                          	2017-10-03 14:07:42.662       
494	45118	Read :  2 PULL_LECTURACION 5500                                                                     	2017-10-03 14:08:03.494       
495	45118	Write : {PUSH_CLOSE}                                                                                	2017-10-03 14:08:03.501       
496	45118	Read :  2 PULL_CLOSE 1                                                                              	2017-10-03 14:08:23.398       
497	45118	DISCONNECT OR SOCKET CLOSED                                                                         	2017-10-03 14:08:48.071       
\.


--
-- TOC entry 2243 (class 0 OID 0)
-- Dependencies: 190
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('transactions_id_seq', 497, true);


--
-- TOC entry 2230 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-10-03 14:12:31 BOT

--
-- PostgreSQL database dump complete
--

