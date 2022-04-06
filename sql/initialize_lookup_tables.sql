--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: toon_classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('toon_classes', 'id'), 9, true);


--
-- Data for Name: toon_classes; Type: TABLE DATA; Schema: public; Owner: mdg
--

INSERT INTO toon_classes (id, name) VALUES (1, 'Shaman');
INSERT INTO toon_classes (id, name) VALUES (2, 'Priest');
INSERT INTO toon_classes (id, name) VALUES (3, 'Warlock');
INSERT INTO toon_classes (id, name) VALUES (4, 'Warrior');
INSERT INTO toon_classes (id, name) VALUES (5, 'Rogue');
INSERT INTO toon_classes (id, name) VALUES (6, 'Hunter');
INSERT INTO toon_classes (id, name) VALUES (7, 'Mage');
INSERT INTO toon_classes (id, name) VALUES (8, 'Druid');
INSERT INTO toon_classes (id, name) VALUES (9, 'Unknown');


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: dungeon_loot_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('dungeon_loot_types', 'id'), 2, true);


--
-- Data for Name: dungeon_loot_types; Type: TABLE DATA; Schema: public; Owner: mdg
--

INSERT INTO dungeon_loot_types (id, name, shortdesc) VALUES (1, 'Assigned DKP Value', 'STATIC');
INSERT INTO dungeon_loot_types (id, name, shortdesc) VALUES (2, 'Kill-Based DKP', 'KILLBASED');


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: toon_ranks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('toon_ranks', 'id'), 4, true);


--
-- Data for Name: toon_ranks; Type: TABLE DATA; Schema: public; Owner: mdg
--

INSERT INTO toon_ranks (id, name) VALUES (1, 'New Raider');
INSERT INTO toon_ranks (id, name) VALUES (2, 'Tier-1 Raider');
INSERT INTO toon_ranks (id, name) VALUES (3, 'Tier-1 Veteran');
INSERT INTO toon_ranks (id, name) VALUES (4, 'Boddhisatva');
INSERT INTO toon_ranks (id, name) VALUES (5, 'Roshi');


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;


--
-- Data for Name: toons; Type: TABLE DATA; Schema: public; Owner: mdg
--

INSERT INTO toons (id, name, class_id, rank_id) VALUES (-1, '*** BANK ***', 9, 1);


--
-- PostgreSQL database dump complete
--

