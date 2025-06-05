--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: update_last_check_date(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_last_check_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Обновляем last_check_date в speakers
    UPDATE speakers
    SET last_check_date = NEW.test_date
    WHERE id = NEW.speaker_id;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_last_check_date() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    address text,
    volume_level numeric(6,2)
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locations_id_seq OWNER TO postgres;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: repair_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repair_logs (
    id integer NOT NULL,
    speaker_id integer NOT NULL,
    user_id integer NOT NULL,
    action character varying(20) NOT NULL,
    repair_date timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.repair_logs OWNER TO postgres;

--
-- Name: repair_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.repair_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.repair_logs_id_seq OWNER TO postgres;

--
-- Name: repair_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.repair_logs_id_seq OWNED BY public.repair_logs.id;


--
-- Name: sound_tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sound_tests (
    id integer NOT NULL,
    speaker_id integer,
    user_id integer,
    test_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    volume_level numeric(6,2) NOT NULL,
    test_result boolean NOT NULL,
    notes text
);


ALTER TABLE public.sound_tests OWNER TO postgres;

--
-- Name: sound_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sound_tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sound_tests_id_seq OWNER TO postgres;

--
-- Name: sound_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sound_tests_id_seq OWNED BY public.sound_tests.id;


--
-- Name: speaker_statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.speaker_statuses (
    id integer NOT NULL,
    status character varying(20) NOT NULL
);


ALTER TABLE public.speaker_statuses OWNER TO postgres;

--
-- Name: speaker_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.speaker_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.speaker_statuses_id_seq OWNER TO postgres;

--
-- Name: speaker_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.speaker_statuses_id_seq OWNED BY public.speaker_statuses.id;


--
-- Name: speakers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.speakers (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    location_id integer,
    serial_number character varying(100) NOT NULL,
    last_check_date timestamp without time zone,
    status integer DEFAULT 2,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    repair_status character varying(20),
    CONSTRAINT speakers_repair_status_check CHECK (((repair_status)::text = ANY ((ARRAY['сломан'::character varying, 'работает'::character varying])::text[])))
);


ALTER TABLE public.speakers OWNER TO postgres;

--
-- Name: speakers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.speakers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.speakers_id_seq OWNER TO postgres;

--
-- Name: speakers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.speakers_id_seq OWNED BY public.speakers.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id integer NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_roles_id_seq OWNER TO postgres;

--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role_id integer NOT NULL,
    created_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: repair_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repair_logs ALTER COLUMN id SET DEFAULT nextval('public.repair_logs_id_seq'::regclass);


--
-- Name: sound_tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sound_tests ALTER COLUMN id SET DEFAULT nextval('public.sound_tests_id_seq'::regclass);


--
-- Name: speaker_statuses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speaker_statuses ALTER COLUMN id SET DEFAULT nextval('public.speaker_statuses_id_seq'::regclass);


--
-- Name: speakers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speakers ALTER COLUMN id SET DEFAULT nextval('public.speakers_id_seq'::regclass);


--
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (id, name, description, address, volume_level) FROM stdin;
2	Парк	Городской парк для прогулок	Блюхера, 15	50.00
3	Магазин "Каскад"	Продуктовый магазин	Новосибирская, 18	45.00
4	НГТУ	Университет	Немировича-Данченко, 163	50.00
5	СГУГиТ	Университет	Плахотного, 12	60.00
1	Сцена	Сцена для проведения мероприятий	Ватутина, 12	67.00
\.


--
-- Data for Name: repair_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.repair_logs (id, speaker_id, user_id, action, repair_date) FROM stdin;
1	4	5	break	2025-06-05 00:09:24.018989
2	4	5	repair	2025-06-05 00:09:49.588314
3	5	5	break	2025-06-05 00:10:41.23786
4	5	5	repair	2025-06-05 00:11:09.017001
5	5	5	break	2025-06-05 00:20:48.931131
6	5	5	repair	2025-06-05 00:21:43.049263
7	4	5	break	2025-06-05 00:25:45.884716
8	4	5	repair	2025-06-05 19:21:06.581989
\.


--
-- Data for Name: sound_tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sound_tests (id, speaker_id, user_id, test_date, volume_level, test_result, notes) FROM stdin;
1	4	2	2025-05-24 15:16:03.112984	36.00	t	Тест пройден успешно
2	4	2	2025-05-24 15:18:52.820156	74.00	f	Превышен уровень громкости
4	4	2	2025-05-24 15:24:43.332323	93.00	f	Превышен уровень громкости
5	4	2	2025-05-24 15:46:25.654193	40.00	t	Тест пройден успешно
7	4	2	2025-05-24 15:54:18.679136	69.00	f	Превышен уровень громкости
9	4	2	2025-05-24 16:47:23.738881	88.00	f	Превышен уровень громкости
10	4	2	2025-05-24 22:17:37.547121	52.00	f	Превышен уровень громкости
12	5	2	2025-05-24 22:26:42.908757	41.00	t	Тест пройден успешно
13	4	2	2025-05-25 16:31:06.294208	54.00	f	Превышен уровень громкости
14	5	2	2025-05-25 16:35:35.943349	74.00	f	Превышен уровень громкости
15	4	5	2025-05-25 16:41:01.264903	72.00	f	Превышен уровень громкости
16	5	5	2025-05-25 16:46:32.021469	58.00	f	Превышен уровень громкости
17	6	5	2025-05-26 21:48:36.788808	59.00	t	Тест пройден успешно
18	6	5	2025-06-04 20:58:02.875759	99.00	t	Тест пройден успешно
19	6	5	2025-06-04 20:58:16.232854	87.00	t	Тест пройден успешно
20	4	5	2025-06-04 20:58:53.174241	75.00	f	Превышен уровень громкости
21	5	5	2025-06-04 21:00:09.786427	63.00	f	Превышен уровень громкости
22	4	5	2025-06-04 21:16:03.288279	83.00	f	Превышен уровень громкости
23	6	5	2025-06-04 21:16:50.129775	94.00	t	Тест пройден успешно
24	5	5	2025-06-04 21:39:57.336282	50.00	t	Тест пройден успешно
25	5	5	2025-06-04 21:40:10.775533	64.00	f	Превышен уровень громкости
26	4	5	2025-06-04 21:45:18.647895	57.00	f	Превышен уровень громкости
27	5	5	2025-06-04 21:46:24.968712	73.00	f	Превышен уровень громкости
28	5	5	2025-06-04 21:52:39.31772	62.00	f	Превышен уровень громкости
29	5	5	2025-06-04 21:53:58.548264	88.00	f	Превышен уровень громкости
30	5	5	2025-06-04 22:01:20.189526	81.00	f	Превышен уровень громкости
31	5	5	2025-06-04 22:02:49.190093	54.00	f	Превышен уровень громкости
32	4	5	2025-06-04 22:03:32.360576	43.00	t	Тест пройден успешно
33	4	5	2025-06-04 22:03:46.776642	90.00	f	Превышен уровень громкости
34	5	5	2025-06-04 22:33:38.949567	90.00	f	Превышен уровень громкости
35	5	5	2025-06-04 22:34:48.479761	46.00	t	Тест пройден успешно
36	5	5	2025-06-04 22:35:01.488144	51.00	f	Превышен уровень громкости
37	5	5	2025-06-05 00:01:22.465378	49.00	t	Тест пройден успешно
38	4	5	2025-06-05 00:09:12.124033	50.00	t	Тест пройден успешно
39	4	5	2025-06-05 00:09:24.061047	61.00	f	Превышен уровень громкости
40	5	5	2025-06-05 00:10:41.269403	86.00	f	Превышен уровень громкости
41	5	5	2025-06-05 00:20:48.962941	86.00	f	Превышен уровень громкости
42	4	5	2025-06-05 00:25:45.908143	68.00	f	Превышен уровень громкости
43	5	5	2025-06-05 19:19:14.235629	47.00	t	Тест пройден успешно
\.


--
-- Data for Name: speaker_statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.speaker_statuses (id, status) FROM stdin;
1	В работе
2	Отключен
\.


--
-- Data for Name: speakers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.speakers (id, name, location_id, serial_number, last_check_date, status, created_at, repair_status) FROM stdin;
6	SW-400A	1	KT500AB	2025-06-04 21:16:50.129775	1	2025-05-26 21:47:20.113552	\N
5	Logitech K12	4	K12XAB	2025-06-05 19:19:14.235629	2	2025-05-24 22:23:36.425735	работает
4	Genius X562	2	0562XAB	2025-06-05 00:25:45.908143	1	2025-05-23 22:36:06.077107	работает
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (id, name) FROM stdin;
1	user
2	operator
3	admin
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash, role_id, created_date) FROM stdin;
4	tester	tester@tester.ru	$2b$12$0XoomxUNCmCVrAS1ImpA/OnStfeavIZphELGZFYF.Bh3o4GS0JcV2	1	2025-05-24 17:14:43.069065
3	noname	noname@gmail.ru	$2b$12$ccAla6dx5I5GQBFqbffNl.He/o6cBo8.7.J6nPMVFeMPZD..88fna	2	2025-05-24 17:14:09.352406
5	ruslana	ruslana@gmail.com	$2b$12$58KsAXjMj3CMEpm1Xdb5COro1YcO3gboQhq9ffjVrmpbbGsRuveYm	3	2025-05-25 16:38:47.082826
6	misha	misha@gmail.com	$2b$12$hZn0.ZyS0OpT/sqi011tv.oArb4qUYm8jyjJNtOWKcZNh.h6J/7s2	3	2025-05-26 20:35:11.981718
7	test123	test@gmail.com	$2b$12$AI8vLNlABLnLs/E3JrDmTOvvF2HesZrDOseXuKFsUVV66qUt58BGW	1	2025-06-04 21:03:28.093765
2	andrey	andrey@yandex.ru	$2b$12$0GLO0I3lynWkTGStjuEct.RETfTcLpnlPePO.JNDF7du79wyckfoC	2	2025-05-22 22:58:55.814163
8	ostavte	stipendiy@gmail.ru	$2b$12$cy2ufFcLJckoZEZKFCUs.eDFPxYIVP6Ac09AicgCYW8af5dEQBUwC	2	2025-06-05 18:52:42.273971
\.


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locations_id_seq', 5, true);


--
-- Name: repair_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.repair_logs_id_seq', 8, true);


--
-- Name: sound_tests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sound_tests_id_seq', 43, true);


--
-- Name: speaker_statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.speaker_statuses_id_seq', 1, false);


--
-- Name: speakers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.speakers_id_seq', 7, true);


--
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_roles_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: repair_logs repair_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repair_logs
    ADD CONSTRAINT repair_logs_pkey PRIMARY KEY (id);


--
-- Name: sound_tests sound_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sound_tests
    ADD CONSTRAINT sound_tests_pkey PRIMARY KEY (id);


--
-- Name: speaker_statuses speaker_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speaker_statuses
    ADD CONSTRAINT speaker_statuses_pkey PRIMARY KEY (id);


--
-- Name: speaker_statuses speaker_statuses_status_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speaker_statuses
    ADD CONSTRAINT speaker_statuses_status_key UNIQUE (status);


--
-- Name: speakers speakers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speakers
    ADD CONSTRAINT speakers_pkey PRIMARY KEY (id);


--
-- Name: speakers speakers_serial_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speakers
    ADD CONSTRAINT speakers_serial_number_key UNIQUE (serial_number);


--
-- Name: user_roles user_roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_name_key UNIQUE (name);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: sound_tests trigger_update_last_check_date; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_last_check_date AFTER INSERT ON public.sound_tests FOR EACH ROW EXECUTE FUNCTION public.update_last_check_date();


--
-- Name: repair_logs repair_logs_speaker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repair_logs
    ADD CONSTRAINT repair_logs_speaker_id_fkey FOREIGN KEY (speaker_id) REFERENCES public.speakers(id);


--
-- Name: repair_logs repair_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repair_logs
    ADD CONSTRAINT repair_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: sound_tests sound_tests_speaker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sound_tests
    ADD CONSTRAINT sound_tests_speaker_id_fkey FOREIGN KEY (speaker_id) REFERENCES public.speakers(id) ON DELETE CASCADE;


--
-- Name: sound_tests sound_tests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sound_tests
    ADD CONSTRAINT sound_tests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: speakers speakers_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speakers
    ADD CONSTRAINT speakers_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- Name: speakers speakers_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speakers
    ADD CONSTRAINT speakers_status_fkey FOREIGN KEY (status) REFERENCES public.speaker_statuses(id) ON DELETE CASCADE;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.user_roles(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

