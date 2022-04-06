--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pgsql
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE attendance (
    raid_id integer NOT NULL,
    toon_id integer NOT NULL,
    first_join timestamp(0) without time zone,
    last_leave timestamp(0) without time zone
);


ALTER TABLE public.attendance OWNER TO mdg;

--
-- Name: dkp_adjustments; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE dkp_adjustments (
    id serial NOT NULL,
    toon_id integer NOT NULL,
    value integer DEFAULT 0 NOT NULL,
    adj_date date DEFAULT now() NOT NULL,
    reason text,
    item_value integer DEFAULT 0 NOT NULL,
    ct_value interval DEFAULT '00:00:00'::interval NOT NULL
);


ALTER TABLE public.dkp_adjustments OWNER TO mdg;

--
-- Name: dkp_adjustments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('dkp_adjustments', 'id'), 281, true);


--
-- Name: dungeon_bosses; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE dungeon_bosses (
    id serial NOT NULL,
    dungeon_id integer NOT NULL,
    name text NOT NULL,
    value integer NOT NULL
);


ALTER TABLE public.dungeon_bosses OWNER TO mdg;

--
-- Name: dungeon_bosses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('dungeon_bosses', 'id'), 1, false);


--
-- Name: dungeon_loot_types; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE dungeon_loot_types (
    id serial NOT NULL,
    name text NOT NULL,
    shortdesc text NOT NULL
);


ALTER TABLE public.dungeon_loot_types OWNER TO mdg;

--
-- Name: dungeon_loot_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('dungeon_loot_types', 'id'), 2, true);


--
-- Name: dungeons; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE dungeons (
    id serial NOT NULL,
    loot_type integer NOT NULL,
    value integer,
    name text NOT NULL,
    content_tier integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.dungeons OWNER TO mdg;

--
-- Name: dungeons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('dungeons', 'id'), 7, true);


--
-- Name: items; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE items (
    id serial NOT NULL,
    name text NOT NULL,
    value integer NOT NULL,
    bank_inventory integer DEFAULT 0 NOT NULL,
    dungeon_id integer
);


ALTER TABLE public.items OWNER TO mdg;

--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('items', 'id'), 365, true);


--
-- Name: loot; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE loot (
    id serial NOT NULL,
    raid_id integer NOT NULL,
    toon_id integer NOT NULL,
    item_id integer NOT NULL,
    value integer NOT NULL
);


ALTER TABLE public.loot OWNER TO mdg;

--
-- Name: loot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('loot', 'id'), 1998, true);


--
-- Name: raids; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE raids (
    id serial NOT NULL,
    dungeon_id integer NOT NULL,
    raid_date date DEFAULT now() NOT NULL,
    note text,
    value integer,
    start_tstamp timestamp(0) without time zone,
    stop_tstamp timestamp(0) without time zone
);


ALTER TABLE public.raids OWNER TO mdg;

--
-- Name: toons; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE toons (
    id serial NOT NULL,
    name text NOT NULL,
    class_id integer NOT NULL,
    rank_id integer DEFAULT 1 NOT NULL,
    "password" text,
    last_challenge text,
    alt boolean DEFAULT false
);


ALTER TABLE public.toons OWNER TO mdg;

--
-- Name: view_loot; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_loot AS
    SELECT l.id, l.raid_id, d.name AS dungeon, r.raid_date, l.toon_id, t.name AS toon_name, l.item_id, i.name AS item_name, i.value AS default_value, l.value FROM loot l, toons t, items i, raids r, dungeons d WHERE ((((l.toon_id = t.id) AND (l.item_id = i.id)) AND (l.raid_id = r.id)) AND (r.dungeon_id = d.id));


ALTER TABLE public.view_loot OWNER TO mdg;

--
-- Name: mdgtemp; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW mdgtemp AS
    SELECT view_loot.raid_id, view_loot.dungeon, view_loot.raid_date, (sum(view_loot.value) / 40) AS raid_value FROM view_loot GROUP BY view_loot.raid_id, view_loot.dungeon, view_loot.raid_date ORDER BY view_loot.raid_date DESC;


ALTER TABLE public.mdgtemp OWNER TO mdg;

--
-- Name: raid_kills; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE raid_kills (
    id serial NOT NULL,
    raid_id integer NOT NULL,
    boss_id integer NOT NULL,
    value integer NOT NULL
);


ALTER TABLE public.raid_kills OWNER TO mdg;

--
-- Name: raid_kills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('raid_kills', 'id'), 1, false);


--
-- Name: raids_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('raids', 'id'), 321, true);


--
-- Name: toon_classes; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE toon_classes (
    id serial NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.toon_classes OWNER TO mdg;

--
-- Name: toon_classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('toon_classes', 'id'), 9, true);


--
-- Name: toon_ranks; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE toon_ranks (
    id serial NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.toon_ranks OWNER TO mdg;

--
-- Name: toon_ranks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('toon_ranks', 'id'), 5, true);


--
-- Name: toons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('toons', 'id'), 385, true);


--
-- Name: users; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE users (
    id serial NOT NULL,
    name text NOT NULL,
    email text,
    "password" text,
    "admin" integer DEFAULT 100 NOT NULL
);


ALTER TABLE public.users OWNER TO mdg;

--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('users', 'id'), 7, true);


--
-- Name: view_agg_adjustments; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_agg_adjustments AS
    SELECT dkp_adjustments.toon_id, sum(dkp_adjustments.value) AS dkp_adjustment, sum(dkp_adjustments.item_value) AS item_adjustment, sum(dkp_adjustments.ct_value) AS ct_adjustment FROM dkp_adjustments GROUP BY dkp_adjustments.toon_id;


ALTER TABLE public.view_agg_adjustments OWNER TO mdg;

--
-- Name: view_agg_adjustments_curr_ct; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_agg_adjustments_curr_ct AS
    SELECT dkp_adjustments.toon_id, sum(dkp_adjustments.ct_value) AS curr_ct_adj FROM dkp_adjustments WHERE (dkp_adjustments.adj_date >= (now() - '2 mons'::interval)) GROUP BY dkp_adjustments.toon_id;


ALTER TABLE public.view_agg_adjustments_curr_ct OWNER TO mdg;

--
-- Name: view_attendance; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_attendance AS
    SELECT a.raid_id, d.name AS dungeon, r.raid_date, r.value, (r.stop_tstamp - r.start_tstamp) AS raid_length, a.toon_id, t.name, a.first_join, a.last_leave, (a.last_leave - a.first_join) AS clock_time, ((r.value)::double precision * (date_part('epoch'::text, (a.last_leave - a.first_join)) / date_part('epoch'::text, (r.stop_tstamp - r.start_tstamp)))) AS earned_dkp FROM attendance a, toons t, raids r, dungeons d WHERE (((a.toon_id = t.id) AND (a.raid_id = r.id)) AND (r.dungeon_id = d.id));


ALTER TABLE public.view_attendance OWNER TO mdg;

--
-- Name: view_agg_attendance; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_agg_attendance AS
    SELECT va.toon_id, count(va.toon_id) AS raid_count, sum(va.earned_dkp) AS earned_dkp, sum(va.clock_time) AS all_clock_time FROM view_attendance va GROUP BY va.toon_id;


ALTER TABLE public.view_agg_attendance OWNER TO mdg;

--
-- Name: view_agg_attendance_curr_ct; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_agg_attendance_curr_ct AS
    SELECT va.toon_id, COALESCE(sum(va.clock_time), '00:00:00'::interval) AS current_clock_time FROM view_attendance va, raids r WHERE ((r.id = va.raid_id) AND (r.raid_date >= (now() - '2 mons'::interval))) GROUP BY va.toon_id;


ALTER TABLE public.view_agg_attendance_curr_ct OWNER TO mdg;

--
-- Name: view_agg_loot; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_agg_loot AS
    SELECT loot.toon_id, COALESCE(count(loot.item_id), (0)::bigint) AS item_count, COALESCE(sum(loot.value), (0)::bigint) AS spent_dkp FROM loot GROUP BY loot.toon_id;


ALTER TABLE public.view_agg_loot OWNER TO mdg;

--
-- Name: view_raids; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_raids AS
    SELECT r.id, d.name AS dungeon, d.content_tier, d.id AS dungeon_id, r.raid_date, r.value, dlt.shortdesc AS dkp_type, r.start_tstamp AS raid_start, r.stop_tstamp AS raid_stop, COALESCE((r.stop_tstamp - r.start_tstamp), '00:00:00'::interval) AS raid_length FROM raids r, dungeons d, dungeon_loot_types dlt WHERE ((r.dungeon_id = d.id) AND (d.loot_type = dlt.id));


ALTER TABLE public.view_raids OWNER TO mdg;

--
-- Name: view_toons; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_toons AS
    SELECT t.id, t.name, tc.name AS "class", t.rank_id, tr.name AS rank FROM ((toons t JOIN toon_classes tc ON ((t.class_id = tc.id))) JOIN toon_ranks tr ON ((t.rank_id = tr.id))) WHERE (t.id > 0);


ALTER TABLE public.view_toons OWNER TO mdg;

--
-- Name: waitlist_requests; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE waitlist_requests (
    id serial NOT NULL,
    toon_id integer NOT NULL,
    raid_id integer NOT NULL,
    first_request timestamp(0) without time zone DEFAULT now() NOT NULL,
    last_expire timestamp(0) without time zone,
    approved boolean DEFAULT false NOT NULL
);


ALTER TABLE public.waitlist_requests OWNER TO mdg;

--
-- Name: view_waitlist; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_waitlist AS
    SELECT wr.id, wr.toon_id, vt.name AS toon, vt."class", wr.raid_id, vr.dungeon, vr.raid_date, wr.first_request, wr.last_expire, (wr.last_expire - wr.first_request) AS clock_time, wr.approved FROM waitlist_requests wr, view_toons vt, view_raids vr WHERE ((wr.toon_id = vt.id) AND (wr.raid_id = vr.id));


ALTER TABLE public.view_waitlist OWNER TO mdg;

--
-- Name: view_waitlist_curr_ct; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_waitlist_curr_ct AS
    SELECT view_waitlist.toon_id, sum(view_waitlist.clock_time) AS current_clock_time FROM view_waitlist WHERE ((view_waitlist.raid_date >= (now() - '2 mons'::interval)) AND (view_waitlist.approved = true)) GROUP BY view_waitlist.toon_id;


ALTER TABLE public.view_waitlist_curr_ct OWNER TO mdg;

--
-- Name: view_agg_summary; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_agg_summary AS
    SELECT t.id, t.name, tc.name AS "class", t.rank_id, t.alt, tr.name AS rank, COALESCE(vt.raid_count, (0)::bigint) AS raid_count, ((COALESCE(vattcc.current_clock_time, '00:00:00'::interval) + COALESCE(vadjcc.curr_ct_adj, '00:00:00'::interval)) + COALESCE(vwcc.current_clock_time, '00:00:00'::interval)) AS current_clock_time, COALESCE(vt.earned_dkp, ((0)::bigint)::double precision) AS earned_dkp, COALESCE(vd.dkp_adjustment, (0)::bigint) AS dkp_adjustment, (COALESCE(vt.earned_dkp, ((0)::bigint)::double precision) + (COALESCE(vd.dkp_adjustment, (0)::bigint))::double precision) AS adjusted_dkp, COALESCE(vl.spent_dkp, (0)::bigint) AS spent_dkp, ((COALESCE(vt.earned_dkp, ((0)::bigint)::double precision) + (COALESCE(vd.dkp_adjustment, (0)::bigint))::double precision) - (COALESCE(vl.spent_dkp, (0)::bigint))::double precision) AS available_dkp, ((COALESCE(vl.item_count, (0)::bigint) + 1) + COALESCE(vd.item_adjustment, (0)::bigint)) AS divisor, ((COALESCE(vt.earned_dkp, ((0)::bigint)::double precision) + (COALESCE(vd.dkp_adjustment, (0)::bigint))::double precision) / (((COALESCE(vl.item_count, (0)::bigint) + 1) + COALESCE(vd.item_adjustment, (0)::bigint)))::double precision) AS q, ((COALESCE(vt.earned_dkp, ((0)::bigint)::double precision) + (COALESCE(vd.dkp_adjustment, (0)::bigint))::double precision) / (((COALESCE(vl.item_count, (0)::bigint) + 2) + COALESCE(vd.item_adjustment, (0)::bigint)))::double precision) AS q1, ((COALESCE(vt.earned_dkp, ((0)::bigint)::double precision) + (COALESCE(vd.dkp_adjustment, (0)::bigint))::double precision) / (((COALESCE(vl.item_count, (0)::bigint) + 3) + COALESCE(vd.item_adjustment, (0)::bigint)))::double precision) AS q2 FROM ((((((((toons t LEFT JOIN view_agg_attendance vt ON ((t.id = vt.toon_id))) LEFT JOIN view_agg_attendance_curr_ct vattcc ON ((t.id = vattcc.toon_id))) LEFT JOIN view_waitlist_curr_ct vwcc ON ((t.id = vwcc.toon_id))) LEFT JOIN view_agg_adjustments vd ON ((t.id = vd.toon_id))) LEFT JOIN view_agg_adjustments_curr_ct vadjcc ON ((t.id = vadjcc.toon_id))) LEFT JOIN toon_classes tc ON ((t.class_id = tc.id))) LEFT JOIN toon_ranks tr ON ((t.rank_id = tr.id))) LEFT JOIN view_agg_loot vl ON ((t.id = vl.toon_id))) WHERE (t.id > 0);


ALTER TABLE public.view_agg_summary OWNER TO mdg;

--
-- Name: view_agg_waitlist; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_agg_waitlist AS
    SELECT vw.toon_id, sum(vw.clock_time) AS all_clock_time FROM view_waitlist vw GROUP BY vw.toon_id;


ALTER TABLE public.view_agg_waitlist OWNER TO mdg;

--
-- Name: view_ct_summary; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_ct_summary AS
    SELECT t.id, COALESCE(vaa.all_clock_time, '00:00:00'::interval) AS all_raid, COALESCE(vaacc.current_clock_time, '00:00:00'::interval) AS curr_raid, (COALESCE(vaa.all_clock_time, '00:00:00'::interval) - COALESCE(vaacc.current_clock_time, '00:00:00'::interval)) AS exp_raid, COALESCE(vaw.all_clock_time, '00:00:00'::interval) AS all_waitlist, COALESCE(vwcc.current_clock_time, '00:00:00'::interval) AS curr_waitlist, (COALESCE(vaw.all_clock_time, '00:00:00'::interval) - COALESCE(vwcc.current_clock_time, '00:00:00'::interval)) AS exp_waitlist, COALESCE(vaadj.ct_adjustment, '00:00:00'::interval) AS all_adjust, COALESCE(vaadjcc.curr_ct_adj, '00:00:00'::interval) AS curr_adjust, (COALESCE(vaadj.ct_adjustment, '00:00:00'::interval) - COALESCE(vaadjcc.curr_ct_adj, '00:00:00'::interval)) AS exp_adjust FROM ((((((toons t LEFT JOIN view_agg_attendance vaa ON ((t.id = vaa.toon_id))) LEFT JOIN view_agg_attendance_curr_ct vaacc USING (toon_id)) LEFT JOIN view_agg_waitlist vaw USING (toon_id)) LEFT JOIN view_waitlist_curr_ct vwcc USING (toon_id)) LEFT JOIN view_agg_adjustments vaadj USING (toon_id)) LEFT JOIN view_agg_adjustments_curr_ct vaadjcc USING (toon_id));


ALTER TABLE public.view_ct_summary OWNER TO mdg;

--
-- Name: view_dkphist_earned; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_dkphist_earned AS
    SELECT date_part('year'::text, view_attendance.raid_date) AS raid_year, date_part('month'::text, view_attendance.raid_date) AS raid_month, view_attendance.dungeon, view_attendance.toon_id, (sum(view_attendance.earned_dkp))::real AS earned_dkp FROM view_attendance GROUP BY date_part('year'::text, view_attendance.raid_date), date_part('month'::text, view_attendance.raid_date), view_attendance.dungeon, view_attendance.toon_id ORDER BY date_part('year'::text, view_attendance.raid_date) DESC, date_part('month'::text, view_attendance.raid_date) DESC;


ALTER TABLE public.view_dkphist_earned OWNER TO mdg;

--
-- Name: view_dkphist_earned_byclass; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_dkphist_earned_byclass AS
    SELECT vde.raid_year, vde.raid_month, tc.name, sum(vde.earned_dkp) AS earned_dkp FROM toon_classes tc, toons t, view_dkphist_earned vde WHERE (((vde.toon_id = t.id) AND (t.class_id = tc.id)) AND (tc.name <> 'Unknown'::text)) GROUP BY vde.raid_year, vde.raid_month, tc.name;


ALTER TABLE public.view_dkphist_earned_byclass OWNER TO mdg;

--
-- Name: view_dkphist_spent; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_dkphist_spent AS
    SELECT date_part('year'::text, view_loot.raid_date) AS raid_year, date_part('month'::text, view_loot.raid_date) AS raid_month, view_loot.dungeon, view_loot.toon_id, (sum(view_loot.value))::real AS spent_dkp FROM view_loot WHERE (view_loot.toon_id > 0) GROUP BY date_part('year'::text, view_loot.raid_date), date_part('month'::text, view_loot.raid_date), view_loot.dungeon, view_loot.toon_id ORDER BY date_part('year'::text, view_loot.raid_date) DESC, date_part('month'::text, view_loot.raid_date) DESC;


ALTER TABLE public.view_dkphist_spent OWNER TO mdg;

--
-- Name: view_dkphist_spent_byclass; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_dkphist_spent_byclass AS
    SELECT vds.raid_year, vds.raid_month, tc.name, sum(vds.spent_dkp) AS spent_dkp FROM toon_classes tc, toons t, view_dkphist_spent vds WHERE (((vds.toon_id = t.id) AND (t.class_id = tc.id)) AND (tc.name <> 'Unknown'::text)) GROUP BY vds.raid_year, vds.raid_month, tc.name;


ALTER TABLE public.view_dkphist_spent_byclass OWNER TO mdg;

--
-- Name: view_dkphist_summary; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_dkphist_summary AS
    SELECT vde.raid_year, vde.raid_month, COALESCE(vde.dungeon, vds.dungeon) AS dungeon, vde.toon_id, vde.earned_dkp, COALESCE(vds.spent_dkp, (0)::real) AS spent_dkp FROM (view_dkphist_earned vde LEFT JOIN view_dkphist_spent vds ON (((((vde.raid_year = vds.raid_year) AND (vde.raid_month = vds.raid_month)) AND (vde.dungeon = vds.dungeon)) AND (vde.toon_id = vds.toon_id))));


ALTER TABLE public.view_dkphist_summary OWNER TO mdg;

--
-- Name: view_dkphist_summary_byclass; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_dkphist_summary_byclass AS
    SELECT vde.raid_year, vde.raid_month, vde.name, vde.earned_dkp, vds.spent_dkp FROM (view_dkphist_earned_byclass vde LEFT JOIN view_dkphist_spent_byclass vds ON ((((vde.raid_year = vds.raid_year) AND (vde.raid_month = vds.raid_month)) AND (vde.name = vds.name)))) ORDER BY vde.raid_year DESC, vde.raid_month DESC, vde.name;


ALTER TABLE public.view_dkphist_summary_byclass OWNER TO mdg;

--
-- Name: view_dungeons; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_dungeons AS
    SELECT d.id, d.name, dt.name AS "type", d.value, dt.shortdesc, d.content_tier FROM dungeons d, dungeon_loot_types dt WHERE (d.loot_type = dt.id);


ALTER TABLE public.view_dungeons OWNER TO mdg;

--
-- Name: view_items; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_items AS
    SELECT i.id, i.name, i.value, i.bank_inventory, i.dungeon_id, d.name AS dungeon_name FROM (items i LEFT JOIN dungeons d ON ((i.dungeon_id = d.id)));


ALTER TABLE public.view_items OWNER TO mdg;

--
-- Name: waitlist_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mdg
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('waitlist_requests', 'id'), 2117, true);


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY attendance (raid_id, toon_id, first_join, last_leave) FROM stdin;
8	1	2006-03-07 22:18:06	2006-03-07 23:39:00
8	2	2006-03-07 21:00:00	2006-03-07 22:46:08
8	14	2006-03-07 21:00:00	2006-03-07 23:39:00
8	15	2006-03-07 21:52:16	2006-03-07 23:39:00
8	19	2006-03-07 21:00:00	2006-03-07 23:39:00
9	30	2006-03-18 11:07:50	2006-03-18 15:20:39
9	35	2006-03-18 11:07:50	2006-03-18 15:20:39
9	41	2006-03-18 11:38:00	2006-03-18 15:20:39
8	87	2006-03-07 21:00:00	2006-03-07 23:39:00
8	88	2006-03-07 21:00:00	2006-03-07 23:39:00
8	32	2006-03-07 21:00:00	2006-03-07 23:39:00
8	34	2006-03-07 21:00:00	2006-03-07 21:21:34
8	35	2006-03-07 21:00:00	2006-03-07 23:39:00
8	39	2006-03-07 21:00:00	2006-03-07 23:39:00
8	41	2006-03-07 21:00:00	2006-03-07 23:39:00
8	42	2006-03-07 21:00:00	2006-03-07 23:39:00
8	46	2006-03-07 21:00:00	2006-03-07 23:39:00
8	48	2006-03-07 21:00:00	2006-03-07 23:39:00
8	49	2006-03-07 21:24:41	2006-03-07 23:39:00
8	67	2006-03-07 21:00:00	2006-03-07 22:17:59
8	51	2006-03-07 21:00:00	2006-03-07 23:39:00
8	52	2006-03-07 21:00:00	2006-03-07 23:39:00
8	89	2006-03-07 21:00:00	2006-03-07 21:51:48
8	63	2006-03-07 21:00:00	2006-03-07 23:39:00
8	55	2006-03-07 21:00:00	2006-03-07 23:39:00
8	57	2006-03-07 21:00:00	2006-03-07 23:39:00
8	59	2006-03-07 22:46:04	2006-03-07 23:39:00
7	27	2006-03-17 00:32:20	2006-03-17 00:32:24
7	42	2006-03-17 00:32:20	2006-03-17 00:32:24
7	48	2006-03-17 00:32:20	2006-03-17 00:32:24
7	67	2006-03-17 00:32:20	2006-03-17 00:32:24
7	40	2006-03-17 00:32:20	2006-03-17 00:32:24
7	43	2006-03-17 00:32:20	2006-03-17 00:32:24
7	29	2006-03-17 00:32:20	2006-03-17 00:32:24
7	35	2006-03-17 00:32:20	2006-03-17 00:32:24
7	41	2006-03-17 00:32:20	2006-03-17 00:32:24
7	36	2006-03-17 00:32:20	2006-03-17 00:32:24
7	4	2006-03-17 00:32:20	2006-03-17 00:32:24
7	60	2006-03-17 00:32:20	2006-03-17 00:32:24
7	28	2006-03-17 00:32:20	2006-03-17 00:32:24
7	76	2006-03-17 00:32:20	2006-03-17 00:32:24
7	32	2006-03-17 00:32:20	2006-03-17 00:32:24
7	21	2006-03-17 00:32:20	2006-03-17 00:32:24
7	47	2006-03-17 00:32:20	2006-03-17 00:32:24
7	1	2006-03-17 00:32:20	2006-03-17 00:32:24
7	50	2006-03-17 00:32:20	2006-03-17 00:32:24
7	61	2006-03-17 00:32:20	2006-03-17 00:32:24
15	2	2006-03-08 21:00:00	2006-03-08 22:06:34
7	54	2006-03-17 00:32:20	2006-03-17 00:32:24
15	8	2006-03-08 21:00:00	2006-03-08 23:30:00
15	65	2006-03-08 21:00:00	2006-03-08 23:30:00
15	90	2006-03-08 21:00:00	2006-03-08 23:30:00
15	13	2006-03-08 21:00:00	2006-03-08 23:30:00
15	14	2006-03-08 21:00:00	2006-03-08 23:00:32
15	21	2006-03-08 22:29:19	2006-03-08 23:30:00
15	22	2006-03-08 21:00:00	2006-03-08 23:30:00
15	25	2006-03-08 21:00:00	2006-03-08 23:30:00
15	87	2006-03-08 21:00:00	2006-03-08 22:37:59
15	28	2006-03-08 21:01:45	2006-03-08 23:30:00
15	30	2006-03-08 21:00:00	2006-03-08 22:50:39
15	34	2006-03-08 21:00:00	2006-03-08 23:30:00
15	35	2006-03-08 21:00:00	2006-03-08 23:30:00
15	36	2006-03-08 21:00:00	2006-03-08 23:30:00
15	39	2006-03-08 21:29:21	2006-03-08 23:01:57
15	42	2006-03-08 21:00:00	2006-03-08 23:22:03
15	62	2006-03-08 22:30:44	2006-03-08 23:30:00
15	44	2006-03-08 21:33:29	2006-03-08 23:21:35
15	45	2006-03-08 21:00:00	2006-03-08 23:30:00
15	49	2006-03-08 21:06:23	2006-03-08 23:30:00
9	1	2006-03-18 11:07:50	2006-03-18 15:20:39
9	2	2006-03-18 11:07:50	2006-03-18 15:20:39
9	5	2006-03-18 11:07:50	2006-03-18 15:20:39
9	11	2006-03-18 11:07:50	2006-03-18 15:20:39
9	20	2006-03-18 11:07:50	2006-03-18 15:20:39
9	21	2006-03-18 11:07:50	2006-03-18 15:20:39
9	32	2006-03-18 11:07:50	2006-03-18 15:20:39
9	39	2006-03-18 11:07:50	2006-03-18 15:20:39
9	47	2006-03-18 11:07:50	2006-03-18 15:20:39
9	54	2006-03-18 11:07:50	2006-03-18 15:20:39
9	71	2006-03-18 14:29:26	2006-03-18 15:20:39
15	67	2006-03-08 21:00:00	2006-03-08 23:17:54
15	52	2006-03-08 21:00:00	2006-03-08 23:30:00
15	77	2006-03-08 21:02:09	2006-03-08 22:06:37
7	51	2006-03-17 00:32:20	2006-03-17 00:32:24
15	75	2006-03-08 21:00:00	2006-03-08 22:06:32
15	91	2006-03-08 21:00:00	2006-03-08 22:50:41
15	92	2006-03-08 22:45:12	2006-03-08 23:30:00
15	93	2006-03-08 21:40:51	2006-03-08 23:30:00
15	54	2006-03-08 21:00:00	2006-03-08 23:21:58
15	55	2006-03-08 21:00:00	2006-03-08 23:30:00
15	57	2006-03-08 21:00:00	2006-03-08 23:30:00
1	22	2006-03-12 19:40:17	2006-03-13 00:44:22
9	70	2006-03-18 11:07:50	2006-03-18 14:29:15
9	25	2006-03-18 11:07:50	2006-03-18 15:20:39
9	36	2006-03-18 11:07:50	2006-03-18 15:20:39
9	44	2006-03-18 11:07:50	2006-03-18 15:20:39
9	48	2006-03-18 11:07:50	2006-03-18 15:20:39
9	51	2006-03-18 11:07:50	2006-03-18 15:20:39
9	80	2006-03-18 11:07:50	2006-03-18 15:20:39
1	1	2006-03-12 19:30:00	2006-03-13 00:44:22
1	2	2006-03-12 19:30:00	2006-03-13 00:44:22
1	4	2006-03-12 20:04:47	2006-03-13 00:44:22
1	5	2006-03-12 19:30:00	2006-03-13 00:44:22
1	7	2006-03-12 19:30:00	2006-03-12 23:54:19
1	65	2006-03-12 23:54:50	2006-03-13 00:44:22
1	11	2006-03-12 19:30:00	2006-03-13 00:44:22
1	13	2006-03-12 19:30:00	2006-03-13 00:44:22
4	19	2006-03-26 19:47:53	2006-03-27 01:00:52
4	25	2006-03-26 19:47:53	2006-03-27 01:00:52
4	103	2006-03-26 19:47:53	2006-03-27 01:00:52
4	51	2006-03-26 19:47:53	2006-03-27 01:00:03
14	1	2006-03-22 21:00:00	2006-03-22 23:59:00
14	14	2006-03-22 21:00:00	2006-03-22 23:59:00
14	19	2006-03-22 23:17:39	2006-03-22 23:20:07
14	21	2006-03-22 21:00:00	2006-03-22 23:59:00
14	23	2006-03-22 21:00:00	2006-03-22 23:08:35
14	25	2006-03-22 21:00:00	2006-03-22 23:59:00
14	83	2006-03-22 21:00:00	2006-03-22 23:16:47
14	27	2006-03-22 21:00:00	2006-03-22 23:59:00
14	30	2006-03-22 21:00:00	2006-03-22 23:38:22
14	33	2006-03-22 21:00:00	2006-03-22 23:43:32
14	35	2006-03-22 21:00:00	2006-03-22 23:59:00
14	36	2006-03-22 21:00:00	2006-03-22 23:59:00
14	84	2006-03-22 23:22:14	2006-03-22 23:59:00
14	38	2006-03-22 21:00:00	2006-03-22 23:59:00
14	41	2006-03-22 23:09:01	2006-03-22 23:40:56
14	43	2006-03-22 21:00:00	2006-03-22 23:59:00
14	46	2006-03-22 21:00:00	2006-03-22 23:59:00
14	67	2006-03-22 21:00:00	2006-03-22 23:59:00
14	51	2006-03-22 21:00:00	2006-03-22 23:59:00
14	52	2006-03-22 21:00:00	2006-03-22 23:59:00
14	77	2006-03-22 23:42:41	2006-03-22 23:59:00
14	54	2006-03-22 21:00:00	2006-03-22 23:59:00
14	85	2006-03-22 23:43:58	2006-03-22 23:59:00
14	57	2006-03-22 21:00:00	2006-03-22 23:59:00
14	60	2006-03-22 21:00:00	2006-03-22 23:48:05
16	80	2006-03-11 11:00:00	2006-03-11 14:47:46
16	2	2006-03-11 11:00:00	2006-03-11 14:44:21
16	5	2006-03-11 11:00:00	2006-03-11 15:00:00
16	94	2006-03-11 11:00:00	2006-03-11 15:00:00
16	95	2006-03-11 11:00:00	2006-03-11 15:00:00
16	16	2006-03-11 11:00:00	2006-03-11 11:41:39
16	19	2006-03-11 13:44:34	2006-03-11 14:44:02
16	25	2006-03-11 11:00:00	2006-03-11 11:01:41
16	30	2006-03-11 11:00:00	2006-03-11 14:43:08
16	32	2006-03-11 11:00:00	2006-03-11 14:45:57
16	35	2006-03-11 11:00:00	2006-03-11 15:00:00
16	36	2006-03-11 11:00:00	2006-03-11 15:00:00
16	38	2006-03-11 11:44:29	2006-03-11 14:42:42
16	39	2006-03-11 11:00:00	2006-03-11 14:33:25
16	70	2006-03-11 11:00:00	2006-03-11 15:00:00
16	41	2006-03-11 11:00:00	2006-03-11 15:00:00
16	44	2006-03-11 11:00:00	2006-03-11 15:00:00
16	47	2006-03-11 11:00:00	2006-03-11 13:41:35
16	48	2006-03-11 11:00:00	2006-03-11 15:00:00
16	49	2006-03-11 13:46:35	2006-03-11 15:00:00
16	51	2006-03-11 11:01:48	2006-03-11 15:00:00
16	92	2006-03-11 11:00:00	2006-03-11 15:00:00
16	54	2006-03-11 11:00:00	2006-03-11 15:00:00
16	55	2006-03-11 11:00:00	2006-03-11 13:44:55
1	14	2006-03-12 19:30:00	2006-03-13 00:44:22
1	15	2006-03-12 19:57:38	2006-03-13 00:44:22
1	16	2006-03-12 19:30:00	2006-03-13 00:44:22
1	19	2006-03-12 19:30:00	2006-03-13 00:44:22
1	25	2006-03-12 19:36:25	2006-03-13 00:44:22
1	27	2006-03-12 19:30:00	2006-03-13 00:44:22
1	28	2006-03-12 19:30:00	2006-03-13 00:44:22
1	30	2006-03-12 19:30:00	2006-03-13 00:44:22
1	32	2006-03-12 19:30:00	2006-03-13 00:44:22
1	35	2006-03-12 19:30:00	2006-03-13 00:44:22
1	36	2006-03-12 19:30:00	2006-03-13 00:44:22
1	38	2006-03-12 19:30:00	2006-03-13 00:44:22
1	39	2006-03-12 19:30:00	2006-03-12 23:23:21
1	40	2006-03-12 19:30:00	2006-03-13 00:44:22
1	41	2006-03-12 19:30:00	2006-03-13 00:44:22
1	42	2006-03-12 19:30:00	2006-03-13 00:44:22
1	43	2006-03-12 19:30:00	2006-03-13 00:44:22
1	71	2006-03-12 19:35:04	2006-03-13 00:44:22
1	45	2006-03-12 19:30:00	2006-03-13 00:44:22
1	46	2006-03-12 19:30:00	2006-03-13 00:44:22
1	47	2006-03-12 19:30:00	2006-03-13 00:44:22
1	48	2006-03-12 19:30:00	2006-03-13 00:44:22
1	49	2006-03-12 19:30:00	2006-03-13 00:44:22
1	67	2006-03-12 19:31:38	2006-03-13 00:44:22
1	51	2006-03-12 19:30:00	2006-03-13 00:44:22
1	52	2006-03-12 19:30:58	2006-03-13 00:44:22
1	53	2006-03-12 19:30:00	2006-03-13 00:44:22
1	61	2006-03-12 23:23:26	2006-03-13 00:44:22
1	73	2006-03-12 19:33:44	2006-03-13 00:40:02
1	55	2006-03-12 19:30:00	2006-03-13 00:44:22
1	58	2006-03-12 19:30:00	2006-03-13 00:44:22
1	57	2006-03-12 19:30:00	2006-03-13 00:44:22
1	59	2006-03-12 19:30:00	2006-03-13 00:44:22
1	60	2006-03-12 19:30:00	2006-03-13 00:44:22
2	1	2006-03-13 21:00:00	2006-03-13 23:18:47
2	2	2006-03-13 21:00:00	2006-03-13 23:18:40
2	4	2006-03-13 21:00:00	2006-03-13 23:18:47
2	5	2006-03-13 21:00:00	2006-03-13 23:16:56
2	7	2006-03-13 21:00:00	2006-03-13 23:18:47
2	65	2006-03-13 21:31:07	2006-03-13 23:16:52
2	11	2006-03-13 21:00:00	2006-03-13 23:18:47
2	13	2006-03-13 21:00:00	2006-03-13 23:18:47
2	14	2006-03-13 21:00:00	2006-03-13 23:17:05
2	15	2006-03-13 21:00:00	2006-03-13 23:18:47
2	16	2006-03-13 21:00:00	2006-03-13 23:18:47
2	19	2006-03-13 21:00:00	2006-03-13 23:18:47
2	21	2006-03-13 21:00:00	2006-03-13 23:18:47
2	25	2006-03-13 21:00:00	2006-03-13 23:18:47
2	27	2006-03-13 21:00:00	2006-03-13 23:18:47
2	28	2006-03-13 21:00:00	2006-03-13 23:18:47
2	29	2006-03-13 21:00:00	2006-03-13 23:18:47
2	30	2006-03-13 21:00:00	2006-03-13 23:18:47
2	32	2006-03-13 21:00:00	2006-03-13 23:18:47
2	35	2006-03-13 21:00:00	2006-03-13 23:18:47
2	36	2006-03-13 21:00:00	2006-03-13 23:18:47
2	37	2006-03-13 21:00:00	2006-03-13 23:16:49
2	38	2006-03-13 21:00:00	2006-03-13 23:18:47
2	39	2006-03-13 21:00:00	2006-03-13 23:18:47
2	40	2006-03-13 21:00:00	2006-03-13 23:18:47
2	41	2006-03-13 21:00:00	2006-03-13 23:18:47
2	42	2006-03-13 21:00:00	2006-03-13 23:18:47
2	43	2006-03-13 21:00:00	2006-03-13 23:18:47
2	46	2006-03-13 21:00:00	2006-03-13 23:18:09
2	47	2006-03-13 21:00:00	2006-03-13 23:18:47
2	48	2006-03-13 21:00:00	2006-03-13 23:18:47
2	49	2006-03-13 21:00:00	2006-03-13 23:18:47
2	50	2006-03-13 21:00:00	2006-03-13 23:18:47
2	67	2006-03-13 21:00:00	2006-03-13 23:18:47
2	51	2006-03-13 21:00:00	2006-03-13 23:18:47
2	52	2006-03-13 21:00:00	2006-03-13 23:18:47
2	72	2006-03-13 23:18:22	2006-03-13 23:18:47
2	53	2006-03-13 21:00:00	2006-03-13 23:18:47
2	61	2006-03-13 21:00:00	2006-03-13 23:18:47
2	55	2006-03-13 21:00:00	2006-03-13 23:18:47
2	58	2006-03-13 21:00:00	2006-03-13 23:18:47
2	57	2006-03-13 21:00:00	2006-03-13 23:18:47
2	60	2006-03-13 22:29:05	2006-03-13 23:18:47
3	1	2006-03-13 23:20:00	2006-03-13 23:45:00
3	2	2006-03-13 23:20:00	2006-03-13 23:45:00
3	4	2006-03-13 23:20:00	2006-03-13 23:45:00
3	7	2006-03-13 23:20:00	2006-03-13 23:45:00
3	11	2006-03-13 23:20:00	2006-03-13 23:45:00
3	13	2006-03-13 23:20:00	2006-03-13 23:45:00
3	15	2006-03-13 23:20:00	2006-03-13 23:45:00
3	16	2006-03-13 23:20:00	2006-03-13 23:45:00
3	19	2006-03-13 23:20:00	2006-03-13 23:45:00
3	21	2006-03-13 23:20:00	2006-03-13 23:45:00
3	25	2006-03-13 23:20:00	2006-03-13 23:45:00
3	27	2006-03-13 23:20:00	2006-03-13 23:45:00
3	28	2006-03-13 23:20:00	2006-03-13 23:45:00
3	29	2006-03-13 23:20:00	2006-03-13 23:45:00
3	30	2006-03-13 23:20:00	2006-03-13 23:45:00
3	32	2006-03-13 23:20:00	2006-03-13 23:45:00
3	35	2006-03-13 23:20:00	2006-03-13 23:45:00
3	36	2006-03-13 23:20:00	2006-03-13 23:45:00
3	38	2006-03-13 23:20:00	2006-03-13 23:45:00
3	39	2006-03-13 23:22:36	2006-03-13 23:45:00
3	40	2006-03-13 23:20:00	2006-03-13 23:45:00
3	41	2006-03-13 23:20:00	2006-03-13 23:45:00
3	42	2006-03-13 23:20:00	2006-03-13 23:45:00
3	43	2006-03-13 23:20:00	2006-03-13 23:45:00
3	47	2006-03-13 23:20:00	2006-03-13 23:45:00
3	48	2006-03-13 23:20:00	2006-03-13 23:45:00
3	49	2006-03-13 23:20:00	2006-03-13 23:45:00
3	50	2006-03-13 23:20:00	2006-03-13 23:45:00
3	67	2006-03-13 23:20:00	2006-03-13 23:45:00
3	51	2006-03-13 23:20:00	2006-03-13 23:45:00
3	52	2006-03-13 23:20:00	2006-03-13 23:45:00
3	72	2006-03-13 23:20:00	2006-03-13 23:45:00
3	53	2006-03-13 23:20:00	2006-03-13 23:45:00
3	61	2006-03-13 23:20:00	2006-03-13 23:45:00
3	55	2006-03-13 23:20:00	2006-03-13 23:45:00
3	58	2006-03-13 23:20:00	2006-03-13 23:45:00
3	57	2006-03-13 23:20:00	2006-03-13 23:45:00
3	60	2006-03-13 23:20:00	2006-03-13 23:45:00
5	1	2006-03-14 21:00:00	2006-03-14 23:57:01
5	4	2006-03-14 21:00:00	2006-03-14 23:57:01
5	5	2006-03-14 21:00:00	2006-03-14 23:57:01
5	7	2006-03-14 21:00:00	2006-03-14 23:57:01
5	65	2006-03-14 21:00:00	2006-03-14 23:57:01
5	11	2006-03-14 21:00:00	2006-03-14 23:34:30
5	14	2006-03-14 21:07:46	2006-03-14 22:46:01
5	15	2006-03-14 21:00:00	2006-03-14 23:57:01
5	16	2006-03-14 21:00:00	2006-03-14 23:57:01
5	25	2006-03-14 21:00:00	2006-03-14 23:57:01
5	27	2006-03-14 21:00:00	2006-03-14 23:57:01
5	28	2006-03-14 21:00:00	2006-03-14 23:57:01
5	29	2006-03-14 22:23:17	2006-03-14 23:57:01
5	30	2006-03-14 21:00:00	2006-03-14 23:57:01
5	32	2006-03-14 21:00:00	2006-03-14 23:57:01
5	35	2006-03-14 21:00:00	2006-03-14 23:57:01
5	36	2006-03-14 21:00:00	2006-03-14 23:57:01
5	38	2006-03-14 21:00:00	2006-03-14 23:57:01
5	39	2006-03-14 21:00:00	2006-03-14 23:13:26
5	40	2006-03-14 21:00:00	2006-03-14 23:56:17
5	41	2006-03-14 21:00:00	2006-03-14 23:57:01
5	42	2006-03-14 21:00:00	2006-03-14 23:57:01
5	43	2006-03-14 21:00:00	2006-03-14 23:57:01
5	45	2006-03-14 21:00:00	2006-03-14 23:57:01
5	46	2006-03-14 21:00:00	2006-03-14 23:57:01
5	47	2006-03-14 21:00:00	2006-03-14 23:57:01
5	48	2006-03-14 21:00:00	2006-03-14 23:57:01
5	49	2006-03-14 21:00:00	2006-03-14 23:32:11
5	50	2006-03-14 21:00:00	2006-03-14 23:57:01
5	67	2006-03-14 21:00:00	2006-03-14 23:57:01
5	51	2006-03-14 21:00:00	2006-03-14 23:57:01
5	78	2006-03-14 22:13:25	2006-03-14 23:57:01
5	52	2006-03-14 21:00:00	2006-03-14 23:57:01
5	53	2006-03-14 23:05:27	2006-03-14 23:57:01
5	77	2006-03-14 21:16:01	2006-03-14 23:26:30
5	75	2006-03-14 21:17:37	2006-03-14 23:57:01
5	76	2006-03-14 21:02:28	2006-03-14 22:17:02
5	55	2006-03-14 21:00:00	2006-03-14 23:57:01
5	58	2006-03-14 21:00:00	2006-03-14 23:51:44
5	57	2006-03-14 21:00:00	2006-03-14 23:57:01
5	60	2006-03-14 21:00:00	2006-03-14 23:57:01
6	75	2006-03-15 21:04:12	2006-03-16 00:50:23
6	17	2006-03-15 21:04:12	2006-03-16 00:50:23
6	21	2006-03-15 21:04:12	2006-03-16 00:50:23
6	1	2006-03-15 21:04:12	2006-03-16 00:50:23
6	4	2006-03-15 21:04:12	2006-03-16 00:50:23
6	16	2006-03-15 21:04:12	2006-03-16 00:50:23
6	18	2006-03-15 22:00:22	2006-03-16 00:50:23
6	27	2006-03-15 21:04:12	2006-03-16 00:50:23
6	28	2006-03-15 21:33:49	2006-03-16 00:50:23
6	29	2006-03-15 21:04:12	2006-03-15 21:55:58
6	30	2006-03-15 21:04:12	2006-03-16 00:50:23
6	32	2006-03-15 21:04:12	2006-03-16 00:50:23
6	35	2006-03-15 21:04:12	2006-03-16 00:50:23
6	40	2006-03-15 21:04:12	2006-03-16 00:50:23
6	41	2006-03-15 21:04:12	2006-03-16 00:50:23
6	42	2006-03-15 21:04:12	2006-03-16 00:50:23
6	43	2006-03-15 21:04:12	2006-03-16 00:50:23
6	45	2006-03-15 21:04:12	2006-03-16 00:50:23
6	47	2006-03-15 21:04:12	2006-03-16 00:50:23
6	48	2006-03-15 21:04:12	2006-03-16 00:50:23
6	50	2006-03-15 21:04:12	2006-03-16 00:50:23
6	67	2006-03-15 21:04:12	2006-03-16 00:50:23
6	51	2006-03-15 21:04:12	2006-03-16 00:50:23
6	61	2006-03-15 21:04:12	2006-03-15 22:10:39
6	54	2006-03-15 22:11:23	2006-03-16 00:50:23
6	76	2006-03-15 21:04:12	2006-03-15 21:33:35
6	60	2006-03-15 21:04:12	2006-03-16 00:50:23
10	47	2006-03-20 01:52:24	2006-03-20 01:52:29
10	1	2006-03-19 19:30:00	2006-03-20 01:52:29
10	2	2006-03-19 19:30:00	2006-03-20 01:41:35
10	4	2006-03-19 19:30:00	2006-03-20 01:52:29
10	5	2006-03-19 19:30:00	2006-03-20 01:42:27
10	7	2006-03-19 19:30:00	2006-03-20 01:42:08
10	11	2006-03-19 19:30:00	2006-03-20 01:41:57
10	13	2006-03-19 19:30:00	2006-03-20 01:41:04
10	14	2006-03-19 19:30:00	2006-03-20 01:52:29
10	15	2006-03-19 19:30:00	2006-03-20 01:52:29
10	16	2006-03-19 19:30:00	2006-03-20 01:52:29
10	19	2006-03-19 19:30:00	2006-03-20 01:42:10
10	21	2006-03-19 19:30:00	2006-03-20 01:42:08
10	25	2006-03-19 19:30:00	2006-03-20 01:41:12
10	27	2006-03-19 20:32:15	2006-03-20 01:42:02
10	28	2006-03-19 19:30:00	2006-03-20 01:52:29
10	30	2006-03-19 19:30:00	2006-03-20 01:52:29
10	32	2006-03-19 19:30:00	2006-03-20 01:42:15
10	82	2006-03-20 00:57:58	2006-03-20 01:52:29
10	35	2006-03-19 19:30:00	2006-03-20 01:52:29
10	36	2006-03-19 19:30:00	2006-03-20 01:41:57
10	39	2006-03-19 19:30:00	2006-03-20 01:41:03
10	40	2006-03-19 19:30:00	2006-03-19 22:45:48
10	81	2006-03-19 22:51:04	2006-03-20 01:42:19
10	41	2006-03-19 19:30:00	2006-03-20 01:52:29
10	42	2006-03-19 19:30:00	2006-03-20 01:42:03
10	43	2006-03-19 19:30:00	2006-03-20 01:52:29
10	71	2006-03-19 19:30:00	2006-03-20 01:52:29
10	45	2006-03-19 19:30:00	2006-03-20 01:52:29
10	48	2006-03-19 19:30:00	2006-03-20 01:52:29
10	49	2006-03-19 19:30:00	2006-03-20 01:52:29
10	50	2006-03-19 19:30:00	2006-03-20 01:52:29
10	67	2006-03-19 19:30:00	2006-03-20 01:52:29
10	51	2006-03-19 19:30:00	2006-03-20 01:42:03
10	52	2006-03-19 19:30:00	2006-03-20 01:52:29
10	72	2006-03-19 19:30:00	2006-03-20 01:52:29
10	53	2006-03-19 19:40:19	2006-03-20 01:41:03
10	54	2006-03-19 19:30:00	2006-03-20 01:42:38
10	76	2006-03-19 19:30:00	2006-03-20 00:57:13
10	58	2006-03-19 19:30:00	2006-03-20 01:41:10
10	57	2006-03-19 19:30:00	2006-03-20 01:52:29
10	59	2006-03-19 19:30:00	2006-03-20 01:42:03
10	60	2006-03-19 19:30:00	2006-03-20 01:52:29
13	1	2006-03-21 21:00:00	2006-03-22 01:00:00
13	4	2006-03-21 21:00:00	2006-03-22 00:42:45
13	5	2006-03-21 21:00:00	2006-03-22 01:00:00
13	7	2006-03-21 21:00:00	2006-03-22 01:00:00
13	65	2006-03-21 21:01:06	2006-03-22 01:00:00
13	11	2006-03-21 22:34:59	2006-03-22 00:42:11
13	13	2006-03-21 21:00:00	2006-03-22 01:00:00
13	14	2006-03-21 21:00:00	2006-03-21 21:58:55
13	19	2006-03-21 21:00:00	2006-03-22 01:00:00
13	96	2006-03-21 21:55:15	2006-03-22 01:00:00
13	23	2006-03-21 21:00:00	2006-03-22 01:00:00
13	25	2006-03-21 22:06:36	2006-03-22 01:00:00
13	26	2006-03-21 22:32:15	2006-03-22 01:00:00
13	27	2006-03-21 21:52:39	2006-03-22 01:00:00
13	28	2006-03-21 21:00:00	2006-03-22 01:00:00
13	29	2006-03-21 21:00:00	2006-03-22 01:00:00
13	30	2006-03-21 21:00:00	2006-03-22 01:00:00
13	31	2006-03-21 21:00:00	2006-03-22 00:42:51
13	32	2006-03-21 21:00:00	2006-03-22 00:42:06
13	35	2006-03-21 21:00:00	2006-03-22 01:00:00
13	36	2006-03-21 21:00:00	2006-03-22 01:00:00
13	39	2006-03-21 21:00:00	2006-03-21 22:57:48
13	40	2006-03-21 21:00:16	2006-03-21 23:09:47
13	41	2006-03-21 21:00:00	2006-03-22 01:00:00
13	42	2006-03-21 21:00:00	2006-03-22 00:43:15
13	43	2006-03-21 21:59:38	2006-03-22 01:00:00
13	44	2006-03-21 21:00:00	2006-03-22 01:00:00
13	45	2006-03-21 21:00:00	2006-03-22 01:00:00
13	46	2006-03-21 21:00:00	2006-03-22 01:00:00
13	49	2006-03-21 21:48:02	2006-03-22 01:00:00
13	50	2006-03-21 21:00:00	2006-03-22 01:00:00
13	67	2006-03-21 21:00:00	2006-03-22 01:00:00
13	51	2006-03-21 21:00:00	2006-03-22 00:43:22
13	78	2006-03-21 21:00:00	2006-03-22 00:43:35
13	52	2006-03-21 21:00:00	2006-03-22 01:00:00
13	76	2006-03-21 21:00:00	2006-03-22 01:00:00
13	55	2006-03-21 21:00:00	2006-03-22 01:00:00
13	58	2006-03-21 21:00:00	2006-03-22 01:00:00
13	85	2006-03-21 22:29:18	2006-03-22 01:00:00
13	57	2006-03-21 21:00:00	2006-03-22 00:21:38
13	60	2006-03-21 21:00:00	2006-03-22 01:00:00
17	97	2006-03-23 21:00:00	2006-03-23 23:15:00
17	5	2006-03-23 21:00:00	2006-03-23 23:15:00
17	16	2006-03-23 21:00:00	2006-03-23 23:14:33
17	23	2006-03-23 21:00:00	2006-03-23 21:44:15
17	26	2006-03-23 21:00:00	2006-03-23 23:12:16
17	27	2006-03-23 21:00:00	2006-03-23 23:15:00
17	28	2006-03-23 21:01:00	2006-03-23 23:15:00
17	98	2006-03-23 21:00:00	2006-03-23 23:15:00
17	30	2006-03-23 21:00:00	2006-03-23 23:15:00
17	31	2006-03-23 21:45:23	2006-03-23 23:15:00
17	33	2006-03-23 21:00:00	2006-03-23 23:15:00
17	36	2006-03-23 21:00:00	2006-03-23 23:15:00
17	39	2006-03-23 21:00:00	2006-03-23 23:15:00
17	40	2006-03-23 21:00:00	2006-03-23 23:15:00
17	41	2006-03-23 21:00:00	2006-03-23 23:15:00
17	43	2006-03-23 21:00:00	2006-03-23 22:21:31
17	45	2006-03-23 21:00:00	2006-03-23 23:15:00
17	50	2006-03-23 21:00:00	2006-03-23 23:15:00
17	99	2006-03-23 22:21:05	2006-03-23 23:15:00
17	100	2006-03-23 22:21:17	2006-03-23 23:15:00
17	51	2006-03-23 21:00:00	2006-03-23 23:15:00
17	61	2006-03-23 21:00:00	2006-03-23 23:15:00
17	54	2006-03-23 21:00:00	2006-03-23 22:18:02
4	1	2006-03-26 19:47:53	2006-03-27 01:00:52
4	2	2006-03-26 19:47:53	2006-03-27 01:00:52
4	97	2006-03-26 21:08:07	2006-03-27 00:59:18
4	4	2006-03-26 19:47:53	2006-03-27 01:00:04
4	5	2006-03-26 19:47:53	2006-03-27 01:00:52
4	7	2006-03-26 19:47:53	2006-03-27 00:59:20
18	1	2006-03-25 10:58:05	2006-03-25 16:22:08
18	97	2006-03-25 10:58:05	2006-03-25 16:22:08
18	5	2006-03-25 10:58:05	2006-03-25 16:22:08
18	6	2006-03-25 15:41:32	2006-03-25 16:22:08
18	102	2006-03-25 10:58:05	2006-03-25 14:41:01
18	16	2006-03-25 10:58:05	2006-03-25 16:22:08
18	21	2006-03-25 10:58:05	2006-03-25 14:35:29
18	23	2006-03-25 10:58:05	2006-03-25 15:34:40
18	25	2006-03-25 10:58:05	2006-03-25 16:22:08
18	30	2006-03-25 10:58:05	2006-03-25 16:22:08
18	32	2006-03-25 10:58:05	2006-03-25 16:22:08
18	35	2006-03-25 10:58:05	2006-03-25 16:22:08
18	36	2006-03-25 10:58:05	2006-03-25 16:22:08
18	38	2006-03-25 14:40:51	2006-03-25 16:22:08
18	39	2006-03-25 10:58:05	2006-03-25 14:48:33
18	70	2006-03-25 10:58:05	2006-03-25 16:22:08
18	81	2006-03-25 10:58:05	2006-03-25 15:35:48
18	41	2006-03-25 14:35:38	2006-03-25 16:22:08
18	62	2006-03-25 15:35:19	2006-03-25 16:22:08
18	44	2006-03-25 10:58:05	2006-03-25 16:22:08
18	48	2006-03-25 10:58:05	2006-03-25 16:22:08
18	49	2006-03-25 10:58:05	2006-03-25 16:22:08
18	103	2006-03-25 14:49:57	2006-03-25 16:22:08
18	61	2006-03-25 10:58:05	2006-03-25 16:22:08
18	54	2006-03-25 10:58:05	2006-03-25 16:22:08
11	1	2006-03-20 21:00:00	2006-03-20 22:00:00
11	4	2006-03-20 21:00:00	2006-03-20 21:59:59
11	5	2006-03-20 21:00:00	2006-03-20 21:58:11
11	7	2006-03-20 21:00:00	2006-03-20 21:57:19
11	65	2006-03-20 21:00:00	2006-03-20 21:57:47
11	11	2006-03-20 21:00:00	2006-03-20 22:00:00
11	13	2006-03-20 21:00:00	2006-03-20 21:55:17
11	14	2006-03-20 21:00:00	2006-03-20 21:57:27
11	15	2006-03-20 21:00:00	2006-03-20 21:59:45
11	18	2006-03-20 21:00:00	2006-03-20 21:58:04
11	19	2006-03-20 21:00:00	2006-03-20 21:57:02
11	23	2006-03-20 21:00:00	2006-03-20 21:58:26
11	25	2006-03-20 21:00:00	2006-03-20 22:00:00
11	27	2006-03-20 21:00:00	2006-03-20 21:57:05
11	28	2006-03-20 21:00:00	2006-03-20 21:59:18
11	30	2006-03-20 21:00:00	2006-03-20 22:00:00
11	32	2006-03-20 21:00:00	2006-03-20 22:00:00
11	35	2006-03-20 21:00:00	2006-03-20 22:00:00
11	38	2006-03-20 21:00:00	2006-03-20 21:57:29
11	104	2006-03-20 21:00:00	2006-03-20 21:59:05
11	40	2006-03-20 21:00:00	2006-03-20 22:00:00
11	81	2006-03-20 21:00:00	2006-03-20 22:00:00
11	41	2006-03-20 21:00:00	2006-03-20 22:00:00
11	42	2006-03-20 21:00:00	2006-03-20 21:56:53
11	43	2006-03-20 21:00:00	2006-03-20 21:59:50
11	62	2006-03-20 21:00:00	2006-03-20 22:00:00
11	45	2006-03-20 21:00:00	2006-03-20 21:40:26
11	47	2006-03-20 21:00:00	2006-03-20 21:57:10
11	105	2006-03-20 21:00:00	2006-03-20 22:00:00
11	49	2006-03-20 21:00:00	2006-03-20 21:58:27
11	67	2006-03-20 21:00:00	2006-03-20 21:57:02
11	51	2006-03-20 21:00:00	2006-03-20 21:59:25
11	52	2006-03-20 21:00:00	2006-03-20 22:00:00
11	72	2006-03-20 21:00:00	2006-03-20 21:57:09
11	53	2006-03-20 21:00:00	2006-03-20 22:00:00
11	61	2006-03-20 21:00:00	2006-03-20 21:57:14
11	55	2006-03-20 21:00:00	2006-03-20 22:00:00
11	58	2006-03-20 21:00:00	2006-03-20 21:59:12
11	57	2006-03-20 21:00:00	2006-03-20 21:55:37
11	60	2006-03-20 21:00:00	2006-03-20 21:56:32
4	13	2006-03-26 20:15:52	2006-03-26 20:54:03
4	14	2006-03-26 19:47:53	2006-03-27 01:00:04
4	15	2006-03-26 19:47:53	2006-03-27 00:59:27
4	16	2006-03-26 19:47:53	2006-03-27 01:00:52
4	27	2006-03-26 19:47:53	2006-03-27 00:59:24
4	28	2006-03-26 19:47:53	2006-03-27 01:00:52
4	30	2006-03-26 19:47:53	2006-03-27 01:00:52
4	32	2006-03-26 19:47:53	2006-03-27 01:00:52
4	33	2006-03-26 19:47:53	2006-03-27 01:00:52
4	82	2006-03-26 19:47:53	2006-03-27 01:00:52
4	35	2006-03-26 19:47:53	2006-03-27 00:59:12
4	36	2006-03-26 19:47:53	2006-03-27 00:59:38
4	37	2006-03-26 19:47:53	2006-03-27 01:00:52
4	38	2006-03-26 19:47:53	2006-03-27 01:00:52
4	39	2006-03-26 19:47:53	2006-03-26 23:58:36
4	40	2006-03-26 21:04:31	2006-03-27 01:00:52
4	81	2006-03-26 19:47:53	2006-03-27 01:00:52
4	41	2006-03-26 19:47:53	2006-03-26 21:04:22
4	42	2006-03-26 19:47:53	2006-03-27 00:59:16
4	62	2006-03-26 19:47:53	2006-03-27 01:00:04
4	45	2006-03-26 19:47:53	2006-03-27 01:00:52
4	106	2006-03-26 19:47:53	2006-03-27 01:00:52
4	48	2006-03-26 19:47:53	2006-03-27 01:00:02
4	49	2006-03-26 19:47:53	2006-03-27 01:00:52
4	50	2006-03-26 19:47:53	2006-03-27 01:00:52
4	67	2006-03-26 19:47:53	2006-03-27 01:00:52
4	72	2006-03-26 19:47:53	2006-03-27 01:00:04
4	61	2006-03-27 00:12:01	2006-03-27 01:00:52
4	75	2006-03-26 19:47:53	2006-03-27 01:00:03
4	91	2006-03-26 19:47:53	2006-03-27 01:00:52
22	1	2006-03-29 21:45:00	2006-03-29 23:40:00
4	107	2006-03-26 19:47:53	2006-03-27 01:00:52
4	58	2006-03-26 19:47:53	2006-03-27 01:00:52
4	60	2006-03-26 19:47:53	2006-03-27 01:00:52
22	97	2006-03-29 21:45:00	2006-03-29 22:52:57
22	5	2006-03-29 21:45:00	2006-03-29 23:40:00
22	6	2006-03-29 21:45:00	2006-03-29 23:39:54
22	13	2006-03-29 21:45:00	2006-03-29 23:40:00
22	14	2006-03-29 21:45:00	2006-03-29 22:52:59
22	15	2006-03-29 21:45:00	2006-03-29 23:40:00
22	96	2006-03-29 21:59:11	2006-03-29 23:40:00
22	23	2006-03-29 21:45:18	2006-03-29 23:40:00
22	25	2006-03-29 21:45:00	2006-03-29 23:40:00
22	27	2006-03-29 21:45:00	2006-03-29 23:40:00
22	28	2006-03-29 22:26:34	2006-03-29 23:40:00
22	98	2006-03-29 21:45:00	2006-03-29 23:40:00
22	29	2006-03-29 21:45:00	2006-03-29 23:40:00
22	32	2006-03-29 21:45:00	2006-03-29 23:40:00
22	35	2006-03-29 21:45:00	2006-03-29 23:40:00
22	36	2006-03-29 21:45:00	2006-03-29 23:40:00
22	38	2006-03-29 21:45:00	2006-03-29 23:40:00
22	111	2006-03-29 21:45:00	2006-03-29 23:40:00
22	39	2006-03-29 21:45:00	2006-03-29 23:10:31
22	40	2006-03-29 21:45:00	2006-03-29 23:40:00
22	41	2006-03-29 21:45:00	2006-03-29 23:40:00
22	45	2006-03-29 21:45:00	2006-03-29 23:40:00
22	46	2006-03-29 21:45:00	2006-03-29 23:40:00
22	100	2006-03-29 21:45:00	2006-03-29 23:40:00
22	51	2006-03-29 21:45:00	2006-03-29 23:40:00
22	52	2006-03-29 21:45:00	2006-03-29 23:40:00
22	72	2006-03-29 23:00:41	2006-03-29 23:40:00
22	61	2006-03-29 21:45:00	2006-03-29 23:39:19
22	75	2006-03-29 21:45:00	2006-03-29 23:40:00
22	91	2006-03-29 22:10:12	2006-03-29 23:40:00
22	54	2006-03-29 21:45:00	2006-03-29 23:40:00
22	89	2006-03-29 21:45:00	2006-03-29 23:40:00
22	55	2006-03-29 21:45:00	2006-03-29 23:40:00
22	58	2006-03-29 21:45:00	2006-03-29 23:40:00
22	57	2006-03-29 21:45:00	2006-03-29 23:40:00
22	60	2006-03-29 21:45:00	2006-03-29 23:40:00
25	39	2006-04-02 19:30:00	2006-04-02 23:22:03
25	40	2006-04-02 19:30:00	2006-04-02 23:07:18
25	61	2006-04-02 20:02:57	2006-04-02 23:27:18
25	75	2006-04-02 19:30:00	2006-04-02 23:48:38
25	1	2006-04-02 20:00:53	2006-04-03 00:15:00
25	2	2006-04-02 19:30:00	2006-04-03 00:15:00
25	97	2006-04-02 19:30:00	2006-04-03 00:15:00
25	4	2006-04-02 19:30:00	2006-04-03 00:15:00
25	5	2006-04-02 19:30:00	2006-04-03 00:15:00
25	7	2006-04-02 19:30:00	2006-04-03 00:15:00
25	14	2006-04-02 19:30:00	2006-04-03 00:15:00
25	15	2006-04-02 19:30:00	2006-04-03 00:15:00
25	16	2006-04-02 23:22:24	2006-04-03 00:15:00
25	19	2006-04-02 19:30:00	2006-04-03 00:15:00
25	21	2006-04-02 19:30:00	2006-04-03 00:15:00
25	24	2006-04-02 19:30:00	2006-04-03 00:15:00
25	25	2006-04-02 19:30:00	2006-04-03 00:15:00
25	83	2006-04-02 19:30:00	2006-04-03 00:15:00
25	27	2006-04-02 19:57:59	2006-04-03 00:15:00
25	28	2006-04-02 19:30:00	2006-04-03 00:15:00
25	30	2006-04-02 19:30:00	2006-04-03 00:15:00
25	32	2006-04-02 19:30:00	2006-04-03 00:15:00
25	82	2006-04-02 23:48:45	2006-04-03 00:15:00
25	35	2006-04-02 19:30:00	2006-04-03 00:15:00
25	36	2006-04-02 19:30:00	2006-04-03 00:15:00
25	38	2006-04-02 19:30:00	2006-04-03 00:15:00
25	81	2006-04-02 19:30:00	2006-04-03 00:15:00
25	42	2006-04-02 19:30:00	2006-04-03 00:15:00
25	43	2006-04-02 19:30:00	2006-04-03 00:15:00
19	1	2006-03-27 21:00:44	2006-03-27 23:07:06
19	97	2006-03-27 21:00:44	2006-03-27 23:07:06
19	4	2006-03-27 21:00:44	2006-03-27 23:07:06
19	5	2006-03-27 21:00:44	2006-03-27 23:07:06
19	7	2006-03-27 21:00:44	2006-03-27 23:07:06
19	11	2006-03-27 21:00:44	2006-03-27 23:07:06
19	13	2006-03-27 21:00:44	2006-03-27 23:07:06
19	14	2006-03-27 21:00:44	2006-03-27 23:07:06
19	15	2006-03-27 21:00:44	2006-03-27 23:07:06
19	16	2006-03-27 21:00:44	2006-03-27 23:07:06
19	19	2006-03-27 21:00:44	2006-03-27 23:07:06
19	21	2006-03-27 21:00:44	2006-03-27 23:07:06
19	23	2006-03-27 21:00:44	2006-03-27 23:07:06
19	25	2006-03-27 21:00:44	2006-03-27 23:07:06
19	27	2006-03-27 21:00:44	2006-03-27 23:07:06
19	28	2006-03-27 21:00:44	2006-03-27 23:07:06
19	29	2006-03-27 21:00:44	2006-03-27 23:07:06
19	30	2006-03-27 21:00:44	2006-03-27 23:07:06
19	32	2006-03-27 21:00:44	2006-03-27 23:07:06
19	33	2006-03-27 21:00:44	2006-03-27 23:07:06
19	35	2006-03-27 21:00:44	2006-03-27 23:07:06
19	36	2006-03-27 21:00:44	2006-03-27 23:07:06
19	38	2006-03-27 21:00:44	2006-03-27 23:07:06
19	40	2006-03-27 21:00:44	2006-03-27 23:07:06
19	81	2006-03-27 22:47:36	2006-03-27 23:07:06
19	41	2006-03-27 21:00:44	2006-03-27 23:07:06
19	42	2006-03-27 21:00:44	2006-03-27 23:07:06
19	43	2006-03-27 21:00:44	2006-03-27 23:07:06
19	45	2006-03-27 21:00:44	2006-03-27 23:07:06
19	46	2006-03-27 21:00:44	2006-03-27 23:07:06
19	106	2006-03-27 21:04:05	2006-03-27 23:06:54
19	48	2006-03-27 21:00:44	2006-03-27 23:07:06
19	50	2006-03-27 21:00:44	2006-03-27 23:07:06
19	67	2006-03-27 21:00:44	2006-03-27 23:07:06
19	103	2006-03-27 21:00:44	2006-03-27 23:07:06
19	51	2006-03-27 21:00:44	2006-03-27 23:07:06
23	1	2006-04-01 11:00:00	2006-04-01 15:00:00
19	52	2006-03-27 21:00:44	2006-03-27 23:07:06
19	61	2006-03-27 21:00:44	2006-03-27 23:07:06
19	75	2006-03-27 21:00:44	2006-03-27 23:07:06
19	109	2006-03-27 21:00:44	2006-03-27 22:47:31
19	107	2006-03-27 21:00:44	2006-03-27 23:07:06
19	58	2006-03-27 21:00:44	2006-03-27 23:07:06
19	60	2006-03-27 21:07:45	2006-03-27 23:07:06
23	80	2006-04-01 11:00:00	2006-04-01 14:16:44
23	6	2006-04-01 11:00:00	2006-04-01 15:00:00
23	20	2006-04-01 11:04:30	2006-04-01 11:12:29
23	25	2006-04-01 13:45:32	2006-04-01 15:00:00
23	26	2006-04-01 11:00:00	2006-04-01 14:16:15
23	29	2006-04-01 14:21:22	2006-04-01 15:00:00
23	30	2006-04-01 11:00:00	2006-04-01 15:00:00
23	32	2006-04-01 11:00:00	2006-04-01 15:00:00
23	35	2006-04-01 11:00:00	2006-04-01 15:00:00
23	36	2006-04-01 11:00:00	2006-04-01 15:00:00
23	38	2006-04-01 12:47:31	2006-04-01 15:00:00
23	39	2006-04-01 11:00:00	2006-04-01 14:45:01
23	40	2006-04-01 11:00:00	2006-04-01 15:00:00
23	70	2006-04-01 11:00:00	2006-04-01 15:00:00
23	81	2006-04-01 11:00:00	2006-04-01 15:00:00
23	41	2006-04-01 11:00:00	2006-04-01 15:00:00
23	44	2006-04-01 11:00:00	2006-04-01 13:43:26
23	48	2006-04-01 11:00:00	2006-04-01 15:00:00
23	100	2006-04-01 14:45:38	2006-04-01 15:00:00
23	103	2006-04-01 11:00:00	2006-04-01 15:00:00
23	112	2006-04-01 11:00:00	2006-04-01 15:00:00
23	51	2006-04-01 11:12:37	2006-04-01 15:00:00
23	61	2006-04-01 11:00:00	2006-04-01 15:00:00
23	54	2006-04-01 11:00:00	2006-04-01 15:00:00
23	58	2006-04-01 11:04:20	2006-04-01 15:00:00
25	71	2006-04-02 19:30:00	2006-04-03 00:15:00
25	62	2006-04-02 19:55:58	2006-04-03 00:15:00
25	45	2006-04-02 19:30:00	2006-04-03 00:15:00
25	106	2006-04-02 19:30:00	2006-04-03 00:15:00
25	48	2006-04-02 19:30:00	2006-04-03 00:15:00
25	49	2006-04-02 19:30:00	2006-04-03 00:15:00
25	50	2006-04-02 23:28:23	2006-04-03 00:15:00
25	67	2006-04-02 19:30:00	2006-04-03 00:15:00
25	103	2006-04-02 19:30:00	2006-04-03 00:15:00
25	51	2006-04-02 19:30:00	2006-04-03 00:15:00
25	52	2006-04-02 19:30:00	2006-04-03 00:15:00
25	72	2006-04-02 19:30:00	2006-04-03 00:15:00
25	55	2006-04-02 19:30:00	2006-04-03 00:15:00
25	58	2006-04-02 19:30:00	2006-04-03 00:15:00
25	60	2006-04-02 19:30:00	2006-04-03 00:15:00
20	1	2006-03-27 23:32:24	2006-03-28 00:07:38
20	97	2006-03-27 23:32:24	2006-03-28 00:07:38
20	4	2006-03-27 23:32:24	2006-03-28 00:07:38
20	5	2006-03-27 23:32:24	2006-03-28 00:07:38
20	7	2006-03-27 23:32:24	2006-03-28 00:07:38
20	13	2006-03-27 23:32:24	2006-03-28 00:07:38
20	14	2006-03-27 23:32:24	2006-03-28 00:07:38
20	15	2006-03-27 23:32:24	2006-03-28 00:07:38
20	16	2006-03-27 23:32:24	2006-03-28 00:07:38
20	19	2006-03-27 23:32:24	2006-03-28 00:07:38
20	21	2006-03-27 23:32:24	2006-03-28 00:07:38
20	96	2006-03-27 23:32:24	2006-03-28 00:07:38
20	23	2006-03-27 23:32:24	2006-03-28 00:07:38
20	25	2006-03-27 23:32:24	2006-03-28 00:07:38
20	27	2006-03-27 23:32:24	2006-03-28 00:07:38
20	28	2006-03-27 23:32:24	2006-03-28 00:07:38
20	29	2006-03-27 23:32:24	2006-03-28 00:07:38
20	30	2006-03-27 23:32:24	2006-03-28 00:07:38
20	32	2006-03-27 23:32:24	2006-03-28 00:07:38
20	33	2006-03-27 23:32:24	2006-03-28 00:07:38
20	35	2006-03-27 23:32:24	2006-03-28 00:07:38
20	36	2006-03-27 23:32:24	2006-03-28 00:07:38
20	38	2006-03-27 23:32:24	2006-03-28 00:07:38
20	40	2006-03-27 23:32:24	2006-03-28 00:07:38
20	81	2006-03-27 23:32:24	2006-03-28 00:07:38
20	41	2006-03-27 23:32:24	2006-03-28 00:07:38
20	42	2006-03-27 23:32:24	2006-03-28 00:07:38
20	43	2006-03-27 23:32:24	2006-03-28 00:07:38
20	62	2006-03-27 23:32:24	2006-03-28 00:07:38
20	45	2006-03-27 23:32:24	2006-03-28 00:07:38
20	48	2006-03-27 23:32:24	2006-03-28 00:07:38
20	105	2006-03-27 23:32:24	2006-03-28 00:07:38
20	50	2006-03-27 23:32:24	2006-03-28 00:07:38
20	67	2006-03-27 23:32:24	2006-03-28 00:07:38
20	51	2006-03-27 23:32:24	2006-03-28 00:07:38
20	52	2006-03-27 23:32:24	2006-03-28 00:07:38
20	72	2006-03-27 23:32:24	2006-03-28 00:07:38
20	61	2006-03-27 23:32:24	2006-03-28 00:07:38
20	107	2006-03-27 23:32:24	2006-03-28 00:07:38
20	58	2006-03-27 23:32:24	2006-03-28 00:07:38
20	60	2006-03-27 23:32:24	2006-03-28 00:07:38
24	1	2006-04-01 19:33:32	2006-04-01 20:30:00
24	2	2006-04-01 19:00:00	2006-04-01 20:30:00
24	97	2006-04-01 19:00:00	2006-04-01 20:30:00
24	6	2006-04-01 19:00:00	2006-04-01 20:30:00
24	7	2006-04-01 19:07:35	2006-04-01 20:30:00
24	102	2006-04-01 19:00:00	2006-04-01 20:30:00
24	65	2006-04-01 19:00:00	2006-04-01 20:30:00
24	14	2006-04-01 19:00:00	2006-04-01 20:30:00
24	16	2006-04-01 19:34:13	2006-04-01 20:30:00
24	25	2006-04-01 19:00:00	2006-04-01 20:30:00
24	26	2006-04-01 19:00:00	2006-04-01 20:30:00
24	27	2006-04-01 20:03:06	2006-04-01 20:30:00
24	98	2006-04-01 19:00:00	2006-04-01 20:30:00
24	33	2006-04-01 19:00:00	2006-04-01 20:28:58
24	35	2006-04-01 19:00:00	2006-04-01 20:30:00
24	36	2006-04-01 19:00:00	2006-04-01 20:30:00
24	38	2006-04-01 19:00:00	2006-04-01 20:30:00
24	113	2006-04-01 19:00:00	2006-04-01 20:30:00
24	106	2006-04-01 19:21:53	2006-04-01 20:30:00
24	48	2006-04-01 19:00:00	2006-04-01 20:30:00
24	49	2006-04-01 19:00:00	2006-04-01 20:30:00
24	67	2006-04-01 19:00:00	2006-04-01 20:30:00
24	100	2006-04-01 19:00:00	2006-04-01 20:30:00
24	114	2006-04-01 19:00:00	2006-04-01 20:30:00
24	103	2006-04-01 19:00:00	2006-04-01 20:30:00
24	51	2006-04-01 19:00:00	2006-04-01 20:30:00
24	52	2006-04-01 19:00:00	2006-04-01 20:30:00
24	115	2006-04-01 19:00:00	2006-04-01 20:30:00
24	116	2006-04-01 19:00:00	2006-04-01 20:30:00
24	91	2006-04-01 19:00:00	2006-04-01 20:30:00
24	117	2006-04-01 19:00:00	2006-04-01 20:30:00
24	89	2006-04-01 19:00:00	2006-04-01 20:30:00
24	118	2006-04-01 19:00:00	2006-04-01 19:57:33
24	55	2006-04-01 19:00:00	2006-04-01 20:30:00
24	58	2006-04-01 19:00:00	2006-04-01 20:30:00
24	66	2006-04-01 19:00:00	2006-04-01 20:30:00
24	60	2006-04-01 19:00:00	2006-04-01 20:30:00
21	1	2006-04-03 21:00:00	2006-04-03 23:00:00
21	2	2006-04-03 21:00:00	2006-04-03 23:00:00
21	97	2006-04-03 21:48:10	2006-04-03 23:00:00
21	4	2006-04-03 21:00:00	2006-04-03 23:00:00
21	5	2006-04-03 21:00:00	2006-04-03 23:00:00
21	7	2006-04-03 21:10:40	2006-04-03 23:00:00
21	14	2006-04-03 21:00:00	2006-04-03 23:00:00
21	15	2006-04-03 21:00:00	2006-04-03 23:00:00
21	17	2006-04-03 21:19:35	2006-04-03 23:00:00
21	19	2006-04-03 21:00:00	2006-04-03 23:00:00
21	21	2006-04-03 21:00:00	2006-04-03 23:00:00
21	96	2006-04-03 21:00:00	2006-04-03 23:00:00
21	23	2006-04-03 21:00:00	2006-04-03 23:00:00
21	25	2006-04-03 21:00:00	2006-04-03 23:00:00
21	26	2006-04-03 21:00:00	2006-04-03 22:33:02
21	27	2006-04-03 21:00:00	2006-04-03 23:00:00
21	28	2006-04-03 22:05:53	2006-04-03 22:09:52
21	29	2006-04-03 21:00:00	2006-04-03 23:00:00
21	30	2006-04-03 21:00:00	2006-04-03 23:00:00
21	33	2006-04-03 21:00:00	2006-04-03 23:00:00
21	119	2006-04-03 21:00:00	2006-04-03 23:00:00
21	35	2006-04-03 21:00:00	2006-04-03 23:00:00
21	36	2006-04-03 21:00:00	2006-04-03 23:00:00
21	38	2006-04-03 21:00:00	2006-04-03 23:00:00
21	39	2006-04-03 21:29:31	2006-04-03 23:00:00
21	40	2006-04-03 21:00:00	2006-04-03 23:00:00
21	41	2006-04-03 21:00:00	2006-04-03 23:00:00
21	42	2006-04-03 21:00:00	2006-04-03 23:00:00
21	43	2006-04-03 21:00:00	2006-04-03 23:00:00
21	45	2006-04-03 21:00:00	2006-04-03 23:00:00
21	46	2006-04-03 21:00:00	2006-04-03 23:00:00
21	49	2006-04-03 21:28:35	2006-04-03 23:00:00
21	50	2006-04-03 21:00:00	2006-04-03 23:00:00
21	100	2006-04-03 21:00:00	2006-04-03 21:24:44
21	51	2006-04-03 21:00:00	2006-04-03 23:00:00
21	52	2006-04-03 21:00:00	2006-04-03 23:00:00
21	53	2006-04-03 22:14:48	2006-04-03 23:00:00
21	61	2006-04-03 21:00:00	2006-04-03 21:24:39
21	76	2006-04-03 21:00:00	2006-04-03 22:03:13
21	58	2006-04-03 21:00:00	2006-04-03 21:24:41
21	56	2006-04-03 22:10:36	2006-04-03 23:00:00
21	60	2006-04-03 21:00:00	2006-04-03 23:00:00
26	1	2006-04-03 23:30:00	2006-04-04 00:57:32
26	2	2006-04-03 23:30:00	2006-04-04 01:00:00
26	97	2006-04-03 23:30:00	2006-04-04 01:00:00
26	4	2006-04-03 23:30:00	2006-04-04 01:00:00
26	5	2006-04-03 23:30:00	2006-04-04 01:00:00
26	7	2006-04-03 23:30:00	2006-04-04 00:59:43
26	65	2006-04-03 23:30:00	2006-04-04 01:00:00
26	14	2006-04-03 23:30:00	2006-04-04 00:58:51
26	15	2006-04-03 23:30:00	2006-04-04 01:00:00
26	16	2006-04-03 23:30:00	2006-04-04 01:00:00
26	21	2006-04-03 23:30:00	2006-04-04 01:00:00
26	96	2006-04-03 23:30:00	2006-04-04 01:00:00
26	25	2006-04-03 23:30:00	2006-04-04 01:00:00
26	27	2006-04-03 23:30:00	2006-04-04 01:00:00
26	28	2006-04-03 23:30:00	2006-04-04 01:00:00
26	30	2006-04-03 23:30:00	2006-04-04 01:00:00
26	33	2006-04-03 23:30:00	2006-04-04 01:00:00
26	35	2006-04-03 23:30:00	2006-04-04 01:00:00
26	36	2006-04-03 23:30:00	2006-04-04 01:00:00
26	84	2006-04-03 23:30:00	2006-04-04 01:00:00
26	38	2006-04-03 23:30:00	2006-04-04 01:00:00
26	39	2006-04-03 23:30:00	2006-04-04 00:08:47
26	40	2006-04-03 23:30:00	2006-04-04 01:00:00
26	81	2006-04-03 23:30:00	2006-04-04 01:00:00
26	41	2006-04-03 23:30:00	2006-04-04 01:00:00
26	42	2006-04-03 23:30:00	2006-04-04 00:59:09
26	43	2006-04-03 23:30:00	2006-04-04 01:00:00
26	62	2006-04-03 23:30:00	2006-04-04 01:00:00
26	45	2006-04-03 23:30:00	2006-04-04 01:00:00
26	49	2006-04-03 23:30:00	2006-04-04 01:00:00
26	50	2006-04-03 23:30:00	2006-04-04 01:00:00
26	51	2006-04-03 23:30:00	2006-04-04 01:00:00
26	52	2006-04-03 23:30:00	2006-04-04 01:00:00
26	72	2006-04-03 23:30:00	2006-04-04 01:00:00
26	53	2006-04-03 23:30:00	2006-04-04 01:00:00
26	61	2006-04-03 23:30:00	2006-04-04 01:00:00
26	60	2006-04-03 23:30:00	2006-04-04 01:00:00
28	1	2006-04-04 21:00:00	2006-04-04 22:10:42
28	2	2006-04-04 21:00:00	2006-04-04 22:10:42
28	5	2006-04-04 21:00:00	2006-04-04 22:10:42
28	7	2006-04-04 21:09:06	2006-04-04 22:10:42
28	65	2006-04-04 21:00:00	2006-04-04 22:10:42
28	14	2006-04-04 21:00:00	2006-04-04 22:10:42
28	96	2006-04-04 21:00:00	2006-04-04 22:10:42
28	25	2006-04-04 21:01:53	2006-04-04 22:10:42
28	27	2006-04-04 21:00:00	2006-04-04 22:10:42
28	28	2006-04-04 21:00:00	2006-04-04 22:10:42
28	30	2006-04-04 21:00:00	2006-04-04 22:10:42
28	32	2006-04-04 21:00:00	2006-04-04 22:10:42
28	33	2006-04-04 21:00:00	2006-04-04 22:10:42
28	35	2006-04-04 21:00:00	2006-04-04 22:10:42
28	36	2006-04-04 21:00:00	2006-04-04 22:10:42
28	38	2006-04-04 21:00:00	2006-04-04 22:10:42
28	39	2006-04-04 21:00:00	2006-04-04 22:10:42
28	40	2006-04-04 21:00:00	2006-04-04 22:10:42
28	81	2006-04-04 21:00:00	2006-04-04 22:10:42
28	41	2006-04-04 21:00:00	2006-04-04 22:10:42
28	42	2006-04-04 21:41:58	2006-04-04 22:10:42
28	43	2006-04-04 21:00:00	2006-04-04 22:10:42
28	62	2006-04-04 21:00:00	2006-04-04 22:10:42
28	44	2006-04-04 21:00:00	2006-04-04 22:10:42
28	45	2006-04-04 21:06:26	2006-04-04 22:10:42
28	48	2006-04-04 21:00:00	2006-04-04 22:10:42
28	49	2006-04-04 21:15:54	2006-04-04 22:10:42
28	50	2006-04-04 21:00:00	2006-04-04 22:10:42
28	51	2006-04-04 21:14:05	2006-04-04 22:10:42
28	53	2006-04-04 21:00:00	2006-04-04 22:10:42
28	61	2006-04-04 21:00:00	2006-04-04 21:51:41
28	76	2006-04-04 21:00:00	2006-04-04 22:10:42
28	58	2006-04-04 21:00:00	2006-04-04 22:10:42
28	60	2006-04-04 21:00:00	2006-04-04 22:10:42
29	1	2006-04-05 21:30:00	2006-04-06 00:00:00
29	2	2006-04-05 21:30:00	2006-04-05 23:09:26
29	6	2006-04-05 21:30:00	2006-04-06 00:00:00
29	96	2006-04-05 21:30:00	2006-04-06 00:00:00
29	24	2006-04-05 21:30:00	2006-04-06 00:00:00
29	27	2006-04-05 21:30:00	2006-04-06 00:00:00
29	28	2006-04-05 21:30:00	2006-04-06 00:00:00
29	30	2006-04-05 21:30:00	2006-04-06 00:00:00
29	32	2006-04-05 21:30:00	2006-04-06 00:00:00
29	35	2006-04-05 21:30:00	2006-04-06 00:00:00
29	120	2006-04-05 21:30:00	2006-04-06 00:00:00
29	40	2006-04-05 22:08:13	2006-04-06 00:00:00
29	121	2006-04-05 21:30:00	2006-04-05 23:34:43
29	41	2006-04-05 21:30:00	2006-04-06 00:00:00
29	45	2006-04-05 21:30:00	2006-04-06 00:00:00
29	49	2006-04-05 23:21:01	2006-04-06 00:00:00
29	51	2006-04-05 21:30:00	2006-04-06 00:00:00
29	61	2006-04-05 21:30:00	2006-04-06 00:00:00
29	54	2006-04-05 21:30:00	2006-04-06 00:00:00
29	76	2006-04-05 21:30:00	2006-04-05 23:53:10
29	58	2006-04-05 21:30:00	2006-04-06 00:00:00
31	80	2006-04-08 11:00:00	2006-04-08 15:00:00
31	97	2006-04-08 11:00:00	2006-04-08 13:37:18
31	5	2006-04-08 11:00:00	2006-04-08 15:00:00
31	6	2006-04-08 11:00:00	2006-04-08 14:23:50
31	25	2006-04-08 11:00:00	2006-04-08 15:00:00
31	98	2006-04-08 11:00:00	2006-04-08 15:00:00
31	30	2006-04-08 11:00:00	2006-04-08 15:00:00
31	35	2006-04-08 11:00:00	2006-04-08 15:00:00
31	36	2006-04-08 11:00:00	2006-04-08 15:00:00
31	39	2006-04-08 11:00:00	2006-04-08 14:36:53
31	70	2006-04-08 11:00:00	2006-04-08 15:00:00
31	41	2006-04-08 11:00:00	2006-04-08 15:00:00
31	71	2006-04-08 11:00:00	2006-04-08 15:00:00
31	44	2006-04-08 11:00:00	2006-04-08 15:00:00
31	48	2006-04-08 11:00:00	2006-04-08 13:50:44
31	49	2006-04-08 13:48:11	2006-04-08 15:00:00
31	67	2006-04-08 13:40:06	2006-04-08 15:00:00
31	100	2006-04-08 11:00:00	2006-04-08 15:00:00
31	51	2006-04-08 11:00:00	2006-04-08 15:00:00
31	61	2006-04-08 11:00:00	2006-04-08 15:00:00
31	54	2006-04-08 11:00:00	2006-04-08 15:00:00
31	55	2006-04-08 11:00:00	2006-04-08 15:00:00
32	1	2006-04-08 19:00:00	2006-04-08 20:45:00
32	15	2006-04-08 19:00:00	2006-04-08 20:45:00
32	123	2006-04-08 19:00:00	2006-04-08 20:45:00
32	19	2006-04-08 19:00:00	2006-04-08 20:45:00
32	21	2006-04-08 19:45:38	2006-04-08 20:45:00
32	96	2006-04-08 19:00:00	2006-04-08 20:45:00
32	24	2006-04-08 19:00:00	2006-04-08 20:45:00
32	25	2006-04-08 19:00:00	2006-04-08 20:45:00
32	83	2006-04-08 19:00:00	2006-04-08 20:45:00
32	26	2006-04-08 19:00:00	2006-04-08 20:45:00
32	27	2006-04-08 19:00:00	2006-04-08 20:45:00
32	98	2006-04-08 19:04:53	2006-04-08 20:45:00
32	33	2006-04-08 19:00:00	2006-04-08 20:45:00
32	35	2006-04-08 19:00:00	2006-04-08 20:45:00
32	36	2006-04-08 19:00:00	2006-04-08 20:45:00
32	38	2006-04-08 19:00:00	2006-04-08 20:45:00
32	124	2006-04-08 19:00:00	2006-04-08 20:45:00
32	121	2006-04-08 19:00:00	2006-04-08 20:45:00
32	43	2006-04-08 19:00:00	2006-04-08 20:45:00
32	71	2006-04-08 19:00:00	2006-04-08 20:45:00
32	44	2006-04-08 19:00:00	2006-04-08 20:45:00
32	48	2006-04-08 19:16:41	2006-04-08 20:45:00
32	49	2006-04-08 19:00:00	2006-04-08 20:45:00
32	50	2006-04-08 19:31:47	2006-04-08 20:45:00
32	67	2006-04-08 19:00:00	2006-04-08 20:45:00
32	100	2006-04-08 19:00:00	2006-04-08 20:45:00
32	72	2006-04-08 19:00:00	2006-04-08 20:45:00
32	116	2006-04-08 19:00:00	2006-04-08 20:45:00
32	61	2006-04-08 19:00:00	2006-04-08 20:45:00
32	107	2006-04-08 19:00:00	2006-04-08 20:45:00
32	125	2006-04-08 19:00:00	2006-04-08 20:45:00
32	89	2006-04-08 19:00:00	2006-04-08 20:45:00
32	58	2006-04-08 19:00:00	2006-04-08 20:45:00
32	85	2006-04-08 19:00:00	2006-04-08 20:45:00
32	60	2006-04-08 19:00:00	2006-04-08 20:45:00
33	4	2006-04-06 23:58:16	2006-04-07 01:00:00
33	123	2006-04-06 23:58:16	2006-04-07 01:00:00
33	26	2006-04-06 23:58:16	2006-04-07 00:27:12
33	27	2006-04-06 23:58:16	2006-04-07 01:00:00
33	28	2006-04-06 23:58:16	2006-04-07 01:00:00
33	33	2006-04-06 23:58:16	2006-04-07 01:00:00
33	35	2006-04-06 23:58:16	2006-04-07 01:00:00
33	36	2006-04-06 23:58:16	2006-04-07 01:00:00
33	40	2006-04-06 23:58:16	2006-04-07 01:00:00
33	121	2006-04-06 23:58:16	2006-04-07 01:00:00
33	41	2006-04-06 23:58:16	2006-04-07 01:00:00
33	113	2006-04-06 23:58:16	2006-04-07 01:00:00
33	62	2006-04-06 23:58:16	2006-04-07 00:58:38
33	45	2006-04-06 23:58:16	2006-04-07 01:00:00
33	48	2006-04-06 23:58:16	2006-04-07 01:00:00
33	49	2006-04-06 23:58:16	2006-04-07 01:00:00
33	50	2006-04-06 23:58:16	2006-04-07 01:00:00
33	51	2006-04-06 23:58:16	2006-04-07 00:59:23
33	54	2006-04-06 23:58:16	2006-04-07 00:59:15
33	76	2006-04-06 23:58:16	2006-04-07 00:58:36
35	1	2006-04-10 21:15:00	2006-04-10 23:00:00
27	1	2006-04-09 23:12:30	2006-04-10 00:15:00
27	2	2006-04-09 19:30:00	2006-04-10 00:15:00
27	97	2006-04-09 19:30:00	2006-04-10 00:15:00
27	4	2006-04-09 19:30:00	2006-04-10 00:15:00
27	5	2006-04-09 19:30:00	2006-04-10 00:15:00
27	7	2006-04-09 19:30:00	2006-04-10 00:15:00
27	14	2006-04-09 19:30:00	2006-04-10 00:15:00
27	15	2006-04-09 19:30:00	2006-04-10 00:15:00
27	16	2006-04-09 19:30:00	2006-04-10 00:15:00
27	19	2006-04-09 19:30:00	2006-04-10 00:15:00
27	96	2006-04-09 19:30:00	2006-04-10 00:15:00
27	23	2006-04-09 21:50:33	2006-04-10 00:15:00
27	24	2006-04-09 19:30:00	2006-04-10 00:15:00
27	25	2006-04-09 19:30:00	2006-04-10 00:15:00
27	83	2006-04-09 19:30:00	2006-04-10 00:15:00
27	26	2006-04-09 19:30:00	2006-04-10 00:15:00
27	27	2006-04-09 19:30:00	2006-04-10 00:15:00
27	28	2006-04-09 19:30:00	2006-04-10 00:15:00
27	30	2006-04-09 19:30:00	2006-04-10 00:15:00
27	33	2006-04-09 19:30:00	2006-04-10 00:15:00
27	119	2006-04-09 19:30:00	2006-04-10 00:15:00
27	35	2006-04-09 19:30:00	2006-04-10 00:15:00
27	36	2006-04-09 19:30:00	2006-04-10 00:15:00
27	38	2006-04-09 19:30:00	2006-04-10 00:15:00
27	39	2006-04-09 19:30:00	2006-04-09 23:11:21
27	40	2006-04-09 19:30:00	2006-04-09 23:17:42
27	124	2006-04-09 23:24:34	2006-04-10 00:15:00
27	81	2006-04-09 19:30:00	2006-04-10 00:15:00
27	41	2006-04-09 19:30:00	2006-04-10 00:15:00
27	43	2006-04-09 19:30:00	2006-04-09 22:45:48
27	71	2006-04-09 19:30:00	2006-04-10 00:15:00
27	62	2006-04-09 19:30:00	2006-04-10 00:15:00
27	45	2006-04-09 19:30:00	2006-04-10 00:15:00
27	46	2006-04-09 22:48:49	2006-04-10 00:15:00
27	48	2006-04-09 19:30:00	2006-04-10 00:15:00
27	49	2006-04-09 19:30:00	2006-04-10 00:15:00
27	50	2006-04-09 19:41:19	2006-04-10 00:15:00
27	67	2006-04-09 19:30:00	2006-04-10 00:15:00
27	100	2006-04-09 19:30:00	2006-04-09 23:11:38
27	51	2006-04-09 19:30:00	2006-04-10 00:15:00
27	107	2006-04-09 19:30:00	2006-04-10 00:15:00
27	76	2006-04-09 19:30:00	2006-04-09 21:43:48
27	58	2006-04-09 19:30:00	2006-04-10 00:15:00
27	59	2006-04-09 23:13:33	2006-04-10 00:15:00
27	60	2006-04-09 19:30:00	2006-04-10 00:15:00
35	2	2006-04-10 21:15:00	2006-04-10 21:59:39
35	4	2006-04-10 21:15:00	2006-04-10 23:00:00
35	5	2006-04-10 21:15:00	2006-04-10 23:00:00
35	7	2006-04-10 21:15:00	2006-04-10 23:00:00
35	14	2006-04-10 21:15:00	2006-04-10 23:00:00
35	16	2006-04-10 21:15:00	2006-04-10 23:00:00
35	126	2006-04-10 21:15:00	2006-04-10 23:00:00
35	19	2006-04-10 21:15:00	2006-04-10 23:00:00
35	21	2006-04-10 21:15:00	2006-04-10 23:00:00
35	96	2006-04-10 21:15:00	2006-04-10 23:00:00
35	23	2006-04-10 21:22:49	2006-04-10 23:00:00
35	127	2006-04-10 21:15:00	2006-04-10 23:00:00
35	25	2006-04-10 21:15:00	2006-04-10 23:00:00
35	27	2006-04-10 21:15:00	2006-04-10 23:00:00
35	28	2006-04-10 21:15:00	2006-04-10 23:00:00
35	29	2006-04-10 21:15:00	2006-04-10 23:00:00
35	30	2006-04-10 21:15:00	2006-04-10 23:00:00
35	32	2006-04-10 21:15:00	2006-04-10 23:00:00
35	35	2006-04-10 21:15:00	2006-04-10 23:00:00
35	36	2006-04-10 21:15:00	2006-04-10 23:00:00
35	128	2006-04-10 21:15:00	2006-04-10 23:00:00
35	38	2006-04-10 21:15:00	2006-04-10 23:00:00
35	111	2006-04-10 21:15:00	2006-04-10 22:59:45
35	39	2006-04-10 21:15:00	2006-04-10 22:59:56
35	40	2006-04-10 21:15:00	2006-04-10 23:00:00
35	124	2006-04-10 21:15:00	2006-04-10 23:00:00
35	81	2006-04-10 21:15:00	2006-04-10 23:00:00
35	121	2006-04-10 21:15:00	2006-04-10 23:00:00
35	42	2006-04-10 21:15:00	2006-04-10 23:00:00
35	43	2006-04-10 21:15:00	2006-04-10 23:00:00
35	71	2006-04-10 21:15:00	2006-04-10 23:00:00
35	129	2006-04-10 21:15:00	2006-04-10 23:00:00
35	46	2006-04-10 21:15:00	2006-04-10 23:00:00
35	48	2006-04-10 21:15:00	2006-04-10 23:00:00
35	49	2006-04-10 22:03:24	2006-04-10 23:00:00
35	67	2006-04-10 21:15:00	2006-04-10 23:00:00
35	100	2006-04-10 21:15:00	2006-04-10 23:00:00
35	103	2006-04-10 21:15:00	2006-04-10 23:00:00
35	51	2006-04-10 21:15:00	2006-04-10 23:00:00
35	130	2006-04-10 21:22:06	2006-04-10 23:00:00
35	75	2006-04-10 21:15:00	2006-04-10 22:21:30
35	76	2006-04-10 21:15:00	2006-04-10 23:00:00
35	55	2006-04-10 21:15:00	2006-04-10 23:00:00
35	58	2006-04-10 21:15:00	2006-04-10 23:00:00
35	59	2006-04-10 22:24:54	2006-04-10 23:00:00
35	60	2006-04-10 21:15:00	2006-04-10 23:00:00
36	1	2006-04-11 21:00:00	2006-04-11 22:30:00
36	5	2006-04-11 21:00:00	2006-04-11 22:30:00
36	7	2006-04-11 21:05:59	2006-04-11 22:30:00
36	102	2006-04-11 21:00:00	2006-04-11 22:30:00
36	123	2006-04-11 21:00:00	2006-04-11 22:30:00
36	21	2006-04-11 21:00:00	2006-04-11 22:30:00
36	96	2006-04-11 21:00:00	2006-04-11 22:30:00
36	23	2006-04-11 21:00:00	2006-04-11 22:30:00
36	24	2006-04-11 21:16:40	2006-04-11 22:30:00
36	26	2006-04-11 21:06:41	2006-04-11 22:30:00
36	27	2006-04-11 21:00:00	2006-04-11 22:30:00
36	98	2006-04-11 21:00:00	2006-04-11 22:30:00
36	30	2006-04-11 21:00:00	2006-04-11 22:30:00
36	32	2006-04-11 21:00:00	2006-04-11 22:30:00
36	35	2006-04-11 21:00:00	2006-04-11 22:30:00
36	36	2006-04-11 21:00:00	2006-04-11 22:30:00
36	38	2006-04-11 21:00:00	2006-04-11 22:30:00
36	39	2006-04-11 21:00:00	2006-04-11 22:30:00
36	40	2006-04-11 21:00:00	2006-04-11 22:30:00
36	124	2006-04-11 21:00:00	2006-04-11 22:30:00
36	121	2006-04-11 21:00:00	2006-04-11 22:30:00
36	43	2006-04-11 21:00:00	2006-04-11 22:30:00
36	71	2006-04-11 21:00:00	2006-04-11 22:30:00
36	45	2006-04-11 21:00:00	2006-04-11 22:30:00
36	131	2006-04-11 21:00:00	2006-04-11 21:27:04
36	106	2006-04-11 21:36:12	2006-04-11 22:30:00
36	49	2006-04-11 21:39:04	2006-04-11 22:30:00
36	50	2006-04-11 21:00:00	2006-04-11 22:30:00
36	100	2006-04-11 21:00:00	2006-04-11 22:30:00
36	103	2006-04-11 21:00:00	2006-04-11 22:30:00
36	51	2006-04-11 21:00:00	2006-04-11 22:30:00
36	132	2006-04-11 21:00:00	2006-04-11 22:30:00
36	116	2006-04-11 21:00:00	2006-04-11 22:30:00
36	91	2006-04-11 21:00:00	2006-04-11 22:30:00
36	117	2006-04-11 21:00:00	2006-04-11 22:30:00
36	89	2006-04-11 21:00:00	2006-04-11 22:30:00
36	76	2006-04-11 21:00:00	2006-04-11 22:30:00
36	55	2006-04-11 21:00:00	2006-04-11 22:30:00
36	58	2006-04-11 21:00:00	2006-04-11 22:30:00
36	85	2006-04-11 21:00:00	2006-04-11 22:30:00
36	56	2006-04-11 21:00:00	2006-04-11 22:30:00
36	59	2006-04-11 21:00:00	2006-04-11 22:30:00
36	60	2006-04-11 21:00:00	2006-04-11 22:30:00
37	1	2006-04-12 23:29:52	2006-04-13 00:00:00
37	5	2006-04-12 21:34:19	2006-04-13 00:00:00
37	6	2006-04-12 21:30:00	2006-04-13 00:00:00
37	7	2006-04-12 21:39:55	2006-04-13 00:00:00
37	65	2006-04-12 22:35:33	2006-04-12 23:35:43
37	14	2006-04-12 21:30:00	2006-04-13 00:00:00
37	123	2006-04-12 21:30:00	2006-04-13 00:00:00
37	23	2006-04-12 21:30:00	2006-04-13 00:00:00
37	127	2006-04-12 21:30:00	2006-04-13 00:00:00
37	24	2006-04-12 21:30:00	2006-04-13 00:00:00
37	25	2006-04-12 21:30:00	2006-04-13 00:00:00
37	27	2006-04-12 21:30:00	2006-04-13 00:00:00
37	28	2006-04-12 21:49:57	2006-04-13 00:00:00
37	30	2006-04-12 21:30:00	2006-04-13 00:00:00
37	32	2006-04-12 21:30:00	2006-04-13 00:00:00
37	133	2006-04-12 21:30:00	2006-04-13 00:00:00
37	35	2006-04-12 21:30:00	2006-04-13 00:00:00
37	36	2006-04-12 21:30:00	2006-04-13 00:00:00
37	38	2006-04-12 21:35:52	2006-04-13 00:00:00
37	39	2006-04-12 21:30:00	2006-04-12 23:33:59
37	40	2006-04-12 21:30:00	2006-04-13 00:00:00
37	121	2006-04-12 21:30:00	2006-04-13 00:00:00
37	41	2006-04-12 21:53:33	2006-04-13 00:00:00
37	42	2006-04-12 22:04:46	2006-04-13 00:00:00
37	43	2006-04-12 21:30:00	2006-04-13 00:00:00
37	62	2006-04-12 21:30:00	2006-04-13 00:00:00
37	44	2006-04-12 21:30:00	2006-04-13 00:00:00
37	45	2006-04-12 21:30:00	2006-04-13 00:00:00
37	46	2006-04-12 21:33:51	2006-04-13 00:00:00
37	49	2006-04-12 22:34:43	2006-04-13 00:00:00
37	50	2006-04-12 22:27:41	2006-04-13 00:00:00
37	112	2006-04-12 21:30:00	2006-04-13 00:00:00
37	51	2006-04-12 21:30:00	2006-04-13 00:00:00
37	72	2006-04-12 21:30:00	2006-04-13 00:00:00
37	77	2006-04-12 22:28:57	2006-04-12 23:41:00
37	109	2006-04-12 21:34:21	2006-04-13 00:00:00
37	54	2006-04-12 21:30:00	2006-04-13 00:00:00
37	63	2006-04-12 21:30:00	2006-04-13 00:00:00
37	58	2006-04-12 21:30:00	2006-04-13 00:00:00
37	60	2006-04-12 21:30:00	2006-04-13 00:00:00
38	80	2006-04-15 11:00:00	2006-04-15 15:30:00
38	5	2006-04-15 11:11:20	2006-04-15 15:30:00
38	102	2006-04-15 11:00:00	2006-04-15 15:30:00
38	16	2006-04-15 11:00:00	2006-04-15 13:56:15
38	25	2006-04-15 11:06:46	2006-04-15 15:30:00
38	30	2006-04-15 11:00:00	2006-04-15 15:30:00
38	36	2006-04-15 11:00:00	2006-04-15 15:30:00
38	38	2006-04-15 11:00:00	2006-04-15 15:30:00
38	39	2006-04-15 11:00:00	2006-04-15 14:03:50
38	70	2006-04-15 11:00:00	2006-04-15 15:30:00
38	124	2006-04-15 11:00:00	2006-04-15 15:30:00
38	41	2006-04-15 11:00:00	2006-04-15 15:30:00
38	71	2006-04-15 13:56:28	2006-04-15 15:30:00
38	44	2006-04-15 11:00:00	2006-04-15 15:30:00
38	48	2006-04-15 11:00:00	2006-04-15 15:30:00
38	49	2006-04-15 11:00:00	2006-04-15 15:30:00
38	99	2006-04-15 11:34:23	2006-04-15 15:30:00
38	100	2006-04-15 11:00:00	2006-04-15 15:30:00
38	54	2006-04-15 11:00:00	2006-04-15 15:30:00
38	134	2006-04-15 14:29:56	2006-04-15 15:30:00
38	66	2006-04-15 11:51:10	2006-04-15 15:30:00
41	1	2006-04-17 21:55:40	2006-04-18 00:15:28
41	97	2006-04-17 21:55:40	2006-04-18 00:15:28
41	4	2006-04-17 21:55:40	2006-04-18 00:15:28
41	5	2006-04-17 21:55:40	2006-04-18 00:15:28
41	8	2006-04-17 21:55:40	2006-04-18 00:15:28
41	14	2006-04-17 21:55:40	2006-04-18 00:15:28
41	15	2006-04-17 21:55:40	2006-04-18 00:15:28
41	16	2006-04-17 21:55:40	2006-04-18 00:15:28
41	19	2006-04-17 21:55:40	2006-04-18 00:15:28
41	21	2006-04-17 21:55:40	2006-04-18 00:15:28
34	1	2006-04-16 20:00:00	2006-04-17 00:15:00
34	2	2006-04-16 20:00:00	2006-04-17 00:15:00
34	97	2006-04-16 20:00:00	2006-04-17 00:15:00
34	3	2006-04-16 20:00:00	2006-04-16 23:27:45
34	4	2006-04-16 20:00:00	2006-04-17 00:15:00
34	5	2006-04-16 20:00:00	2006-04-17 00:15:00
34	7	2006-04-16 23:28:09	2006-04-17 00:15:00
34	135	2006-04-16 20:02:15	2006-04-16 21:53:13
34	8	2006-04-16 20:00:00	2006-04-17 00:15:00
34	14	2006-04-16 20:00:00	2006-04-17 00:15:00
34	15	2006-04-16 20:00:00	2006-04-17 00:15:00
34	16	2006-04-16 20:00:00	2006-04-17 00:15:00
34	123	2006-04-16 22:07:55	2006-04-17 00:15:00
34	19	2006-04-16 20:00:00	2006-04-17 00:15:00
34	23	2006-04-16 20:00:00	2006-04-17 00:15:00
34	24	2006-04-16 20:00:00	2006-04-17 00:15:00
34	25	2006-04-16 20:00:00	2006-04-17 00:15:00
34	28	2006-04-16 20:00:00	2006-04-17 00:15:00
34	30	2006-04-16 20:00:00	2006-04-17 00:15:00
34	31	2006-04-16 20:00:00	2006-04-17 00:15:00
34	32	2006-04-16 20:16:47	2006-04-17 00:15:00
34	82	2006-04-16 20:19:39	2006-04-17 00:15:00
34	136	2006-04-16 20:02:34	2006-04-16 21:52:46
34	35	2006-04-16 23:29:24	2006-04-17 00:15:00
34	137	2006-04-16 20:00:00	2006-04-16 23:19:25
34	39	2006-04-16 20:00:00	2006-04-17 00:15:00
34	40	2006-04-16 20:00:00	2006-04-16 23:29:24
34	124	2006-04-16 20:00:00	2006-04-17 00:15:00
34	138	2006-04-16 20:10:00	2006-04-17 00:15:00
34	121	2006-04-16 20:00:00	2006-04-17 00:15:00
34	41	2006-04-16 20:00:00	2006-04-17 00:15:00
34	42	2006-04-16 22:50:03	2006-04-17 00:15:00
34	43	2006-04-16 22:06:02	2006-04-17 00:15:00
34	71	2006-04-16 20:00:00	2006-04-17 00:15:00
34	46	2006-04-16 20:00:00	2006-04-17 00:15:00
34	106	2006-04-16 20:00:00	2006-04-17 00:15:00
34	48	2006-04-16 20:00:00	2006-04-17 00:15:00
34	50	2006-04-16 20:12:33	2006-04-17 00:15:00
34	103	2006-04-16 20:00:00	2006-04-17 00:15:00
34	51	2006-04-16 20:00:00	2006-04-17 00:15:00
34	61	2006-04-16 20:00:00	2006-04-17 00:15:00
34	109	2006-04-16 20:00:00	2006-04-16 22:44:01
34	54	2006-04-16 21:41:47	2006-04-17 00:15:00
34	58	2006-04-16 20:00:00	2006-04-17 00:15:00
34	139	2006-04-16 20:00:00	2006-04-17 00:15:00
34	60	2006-04-16 20:00:00	2006-04-17 00:15:00
40	1	2006-04-17 21:00:00	2006-04-17 21:30:00
40	4	2006-04-17 21:00:00	2006-04-17 21:30:00
40	5	2006-04-17 21:00:00	2006-04-17 21:30:00
40	8	2006-04-17 21:00:00	2006-04-17 21:30:00
40	14	2006-04-17 21:00:00	2006-04-17 21:30:00
40	15	2006-04-17 21:00:00	2006-04-17 21:30:00
40	16	2006-04-17 21:00:00	2006-04-17 21:30:00
40	19	2006-04-17 21:00:00	2006-04-17 21:30:00
40	21	2006-04-17 21:00:00	2006-04-17 21:30:00
40	96	2006-04-17 21:00:00	2006-04-17 21:30:00
40	24	2006-04-17 21:00:00	2006-04-17 21:30:00
40	25	2006-04-17 21:00:00	2006-04-17 21:30:00
40	27	2006-04-17 21:00:00	2006-04-17 21:30:00
40	28	2006-04-17 21:00:00	2006-04-17 21:30:00
40	30	2006-04-17 21:00:00	2006-04-17 21:30:00
40	32	2006-04-17 21:00:00	2006-04-17 21:30:00
40	82	2006-04-17 21:00:00	2006-04-17 21:30:00
40	35	2006-04-17 21:00:00	2006-04-17 21:30:00
40	36	2006-04-17 21:00:00	2006-04-17 21:30:00
40	38	2006-04-17 21:00:00	2006-04-17 21:30:00
40	39	2006-04-17 21:00:00	2006-04-17 21:30:00
40	40	2006-04-17 21:00:00	2006-04-17 21:30:00
40	124	2006-04-17 21:00:00	2006-04-17 21:30:00
40	81	2006-04-17 21:00:00	2006-04-17 21:30:00
40	121	2006-04-17 21:00:00	2006-04-17 21:30:00
40	42	2006-04-17 21:00:00	2006-04-17 21:30:00
40	71	2006-04-17 21:00:00	2006-04-17 21:30:00
40	62	2006-04-17 21:00:00	2006-04-17 21:30:00
40	44	2006-04-17 21:00:00	2006-04-17 21:30:00
40	45	2006-04-17 21:00:00	2006-04-17 21:30:00
40	46	2006-04-17 21:00:00	2006-04-17 21:30:00
40	48	2006-04-17 21:00:00	2006-04-17 21:30:00
40	50	2006-04-17 21:00:00	2006-04-17 21:30:00
40	67	2006-04-17 21:00:00	2006-04-17 21:30:00
40	103	2006-04-17 21:00:00	2006-04-17 21:30:00
40	51	2006-04-17 21:00:00	2006-04-17 21:30:00
40	52	2006-04-17 21:00:00	2006-04-17 21:30:00
40	61	2006-04-17 21:00:00	2006-04-17 21:30:00
40	76	2006-04-17 21:00:00	2006-04-17 21:30:00
40	63	2006-04-17 21:00:00	2006-04-17 21:30:00
40	55	2006-04-17 21:00:00	2006-04-17 21:30:00
40	58	2006-04-17 21:00:00	2006-04-17 21:30:00
40	56	2006-04-17 21:00:00	2006-04-17 21:30:00
40	60	2006-04-17 21:00:00	2006-04-17 21:30:00
41	96	2006-04-17 21:55:40	2006-04-18 00:15:28
41	25	2006-04-17 21:55:40	2006-04-18 00:15:28
41	27	2006-04-17 21:55:40	2006-04-18 00:15:28
41	28	2006-04-17 21:55:40	2006-04-18 00:15:28
41	30	2006-04-17 21:55:40	2006-04-18 00:15:28
41	32	2006-04-17 21:55:40	2006-04-18 00:15:28
41	82	2006-04-17 21:55:40	2006-04-18 00:15:28
41	35	2006-04-17 21:55:40	2006-04-18 00:15:28
41	36	2006-04-17 21:55:40	2006-04-18 00:15:28
41	38	2006-04-17 21:55:40	2006-04-18 00:15:28
41	39	2006-04-17 21:55:40	2006-04-18 00:15:28
41	40	2006-04-17 21:55:40	2006-04-18 00:15:28
41	124	2006-04-17 21:55:40	2006-04-18 00:15:28
41	81	2006-04-17 21:55:40	2006-04-18 00:15:28
41	121	2006-04-17 21:55:40	2006-04-18 00:15:28
41	42	2006-04-17 21:55:40	2006-04-18 00:15:28
41	71	2006-04-17 21:55:40	2006-04-18 00:15:28
41	62	2006-04-17 21:55:40	2006-04-18 00:15:28
41	44	2006-04-17 21:55:40	2006-04-18 00:15:28
41	45	2006-04-17 21:55:40	2006-04-18 00:15:28
41	48	2006-04-17 21:55:40	2006-04-18 00:15:28
41	49	2006-04-17 21:55:40	2006-04-18 00:15:28
41	50	2006-04-17 21:55:40	2006-04-18 00:15:28
41	103	2006-04-17 21:55:40	2006-04-18 00:15:28
41	51	2006-04-17 21:55:40	2006-04-18 00:15:28
41	52	2006-04-17 21:55:40	2006-04-18 00:15:28
41	61	2006-04-17 21:55:40	2006-04-18 00:15:28
41	76	2006-04-17 21:55:40	2006-04-18 00:15:28
41	58	2006-04-17 21:55:40	2006-04-18 00:15:28
41	60	2006-04-17 21:55:40	2006-04-18 00:15:28
42	1	2006-04-18 21:00:00	2006-04-18 23:45:00
42	97	2006-04-18 21:00:00	2006-04-18 23:34:18
42	4	2006-04-18 21:00:00	2006-04-18 23:45:00
42	5	2006-04-18 21:00:00	2006-04-18 23:45:00
42	8	2006-04-18 21:00:00	2006-04-18 23:45:00
42	25	2006-04-18 22:04:08	2006-04-18 23:45:00
42	27	2006-04-18 21:00:00	2006-04-18 23:45:00
42	28	2006-04-18 21:00:00	2006-04-18 23:45:00
42	98	2006-04-18 23:15:54	2006-04-18 23:45:00
42	30	2006-04-18 21:00:00	2006-04-18 23:45:00
42	32	2006-04-18 21:00:00	2006-04-18 23:45:00
42	35	2006-04-18 21:00:00	2006-04-18 23:45:00
42	36	2006-04-18 21:00:00	2006-04-18 23:45:00
42	39	2006-04-18 21:51:59	2006-04-18 23:45:00
42	81	2006-04-18 21:24:17	2006-04-18 23:40:43
42	41	2006-04-18 21:00:00	2006-04-18 23:45:00
42	44	2006-04-18 21:00:00	2006-04-18 23:45:00
42	45	2006-04-18 21:00:00	2006-04-18 23:45:00
42	103	2006-04-18 21:00:00	2006-04-18 23:45:00
42	51	2006-04-18 21:00:00	2006-04-18 23:45:00
42	140	2006-04-18 21:00:00	2006-04-18 22:03:59
42	61	2006-04-18 21:00:00	2006-04-18 23:43:14
42	76	2006-04-18 21:00:00	2006-04-18 23:09:29
46	80	2006-04-22 11:00:00	2006-04-22 15:00:00
46	97	2006-04-22 11:00:00	2006-04-22 15:00:00
46	6	2006-04-22 11:00:00	2006-04-22 15:00:00
46	25	2006-04-22 11:00:00	2006-04-22 15:00:00
46	30	2006-04-22 11:00:00	2006-04-22 15:00:00
46	32	2006-04-22 11:00:00	2006-04-22 15:00:00
46	35	2006-04-22 11:00:00	2006-04-22 15:00:00
46	36	2006-04-22 11:00:00	2006-04-22 15:00:00
46	38	2006-04-22 11:03:52	2006-04-22 15:00:00
46	39	2006-04-22 11:00:00	2006-04-22 14:47:01
46	124	2006-04-22 11:00:00	2006-04-22 15:00:00
46	81	2006-04-22 14:16:16	2006-04-22 15:00:00
46	41	2006-04-22 11:00:00	2006-04-22 15:00:00
44	4	2006-04-19 23:30:06	2006-04-20 00:18:43
44	6	2006-04-19 21:00:00	2006-04-19 23:52:55
44	8	2006-04-19 21:00:00	2006-04-20 00:18:43
44	25	2006-04-19 21:00:00	2006-04-20 00:18:43
44	27	2006-04-19 21:00:00	2006-04-20 00:18:43
44	28	2006-04-19 21:00:00	2006-04-20 00:18:40
43	1	2006-04-19 00:00:00	2006-04-19 01:00:00
43	4	2006-04-19 00:00:00	2006-04-19 01:00:00
43	6	2006-04-19 00:00:00	2006-04-19 01:00:00
43	8	2006-04-19 00:00:00	2006-04-19 01:00:00
43	25	2006-04-19 00:00:00	2006-04-19 01:00:00
43	27	2006-04-19 00:00:00	2006-04-19 01:00:00
43	28	2006-04-19 00:00:00	2006-04-19 01:00:00
43	98	2006-04-19 00:00:00	2006-04-19 01:00:00
43	30	2006-04-19 00:00:00	2006-04-19 01:00:00
43	31	2006-04-19 00:00:00	2006-04-19 01:00:00
43	35	2006-04-19 00:00:00	2006-04-19 01:00:00
43	39	2006-04-19 00:00:00	2006-04-19 01:00:00
43	41	2006-04-19 00:00:00	2006-04-19 01:00:00
43	44	2006-04-19 00:00:00	2006-04-19 01:00:00
43	45	2006-04-19 00:00:00	2006-04-19 01:00:00
43	103	2006-04-19 00:00:00	2006-04-19 01:00:00
43	51	2006-04-19 00:00:00	2006-04-19 01:00:00
43	107	2006-04-19 00:00:00	2006-04-19 01:00:00
43	134	2006-04-19 00:00:00	2006-04-19 01:00:00
43	141	2006-04-19 00:00:00	2006-04-19 01:00:00
44	30	2006-04-19 21:00:00	2006-04-20 00:18:43
44	31	2006-04-19 23:55:19	2006-04-20 00:18:43
44	32	2006-04-19 21:00:00	2006-04-20 00:18:43
44	82	2006-04-20 00:00:46	2006-04-20 00:18:43
44	35	2006-04-19 21:00:00	2006-04-19 21:31:43
44	40	2006-04-19 22:43:59	2006-04-20 00:18:43
44	121	2006-04-19 21:00:00	2006-04-20 00:17:03
44	41	2006-04-19 21:09:49	2006-04-20 00:18:43
44	42	2006-04-19 21:03:43	2006-04-19 22:38:43
44	45	2006-04-19 21:00:00	2006-04-20 00:18:43
44	142	2006-04-19 22:17:18	2006-04-20 00:18:40
44	46	2006-04-19 21:00:00	2006-04-20 00:17:37
44	49	2006-04-19 23:28:25	2006-04-20 00:18:43
44	50	2006-04-19 21:00:00	2006-04-20 00:18:43
44	100	2006-04-19 21:00:00	2006-04-19 23:51:53
44	51	2006-04-19 21:00:00	2006-04-20 00:18:43
44	116	2006-04-19 21:00:00	2006-04-20 00:18:41
44	61	2006-04-19 21:00:00	2006-04-19 23:27:10
44	117	2006-04-19 21:00:00	2006-04-20 00:18:43
44	141	2006-04-19 21:00:00	2006-04-19 23:27:09
44	57	2006-04-19 21:00:00	2006-04-19 22:18:10
44	60	2006-04-19 21:34:07	2006-04-20 00:18:43
46	48	2006-04-22 11:00:00	2006-04-22 15:00:00
46	100	2006-04-22 11:00:00	2006-04-22 14:19:03
46	103	2006-04-22 11:00:00	2006-04-22 15:00:00
46	51	2006-04-22 11:00:00	2006-04-22 15:00:00
46	61	2006-04-22 11:00:00	2006-04-22 15:00:00
46	54	2006-04-22 11:00:00	2006-04-22 15:00:00
46	55	2006-04-22 11:00:00	2006-04-22 15:00:00
39	2	2006-04-23 19:30:00	2006-04-23 23:15:00
39	97	2006-04-23 19:30:00	2006-04-23 23:15:00
39	4	2006-04-23 19:30:00	2006-04-23 23:15:00
39	6	2006-04-23 19:30:00	2006-04-23 22:23:23
39	7	2006-04-23 19:30:00	2006-04-23 23:15:00
39	8	2006-04-23 19:30:00	2006-04-23 23:15:00
39	14	2006-04-23 19:30:00	2006-04-23 23:15:00
39	15	2006-04-23 19:30:00	2006-04-23 23:15:00
39	16	2006-04-23 22:23:52	2006-04-23 23:15:00
39	19	2006-04-23 19:30:00	2006-04-23 23:15:00
39	21	2006-04-23 19:30:00	2006-04-23 23:15:00
39	96	2006-04-23 19:30:00	2006-04-23 23:15:00
39	24	2006-04-23 19:30:00	2006-04-23 23:15:00
39	25	2006-04-23 19:30:00	2006-04-23 23:15:00
39	27	2006-04-23 19:30:00	2006-04-23 23:15:00
39	28	2006-04-23 19:38:49	2006-04-23 23:15:00
39	30	2006-04-23 19:30:00	2006-04-23 23:15:00
39	35	2006-04-23 19:30:00	2006-04-23 23:15:00
39	36	2006-04-23 19:30:00	2006-04-23 23:15:00
39	39	2006-04-23 19:30:00	2006-04-23 23:15:00
39	40	2006-04-23 19:30:00	2006-04-23 22:15:05
39	121	2006-04-23 19:30:00	2006-04-23 23:15:00
39	42	2006-04-23 22:22:20	2006-04-23 23:15:00
39	43	2006-04-23 19:30:00	2006-04-23 23:15:00
39	71	2006-04-23 19:30:00	2006-04-23 23:15:00
39	62	2006-04-23 19:30:00	2006-04-23 23:15:00
39	45	2006-04-23 19:30:00	2006-04-23 23:15:00
39	46	2006-04-23 19:30:00	2006-04-23 23:15:00
39	106	2006-04-23 19:30:00	2006-04-23 23:15:00
39	48	2006-04-23 19:30:00	2006-04-23 23:15:00
39	49	2006-04-23 19:30:00	2006-04-23 23:15:00
39	50	2006-04-23 19:30:00	2006-04-23 23:15:00
39	67	2006-04-23 19:30:00	2006-04-23 23:15:00
39	103	2006-04-23 19:30:00	2006-04-23 23:15:00
39	51	2006-04-23 19:30:00	2006-04-23 23:15:00
39	52	2006-04-23 19:36:38	2006-04-23 23:15:00
39	61	2006-04-23 19:30:00	2006-04-23 23:15:00
39	54	2006-04-23 19:30:00	2006-04-23 23:15:00
39	55	2006-04-23 19:30:00	2006-04-23 23:15:00
39	58	2006-04-23 19:30:00	2006-04-23 23:15:00
39	57	2006-04-23 19:30:00	2006-04-23 23:15:00
39	59	2006-04-23 19:30:00	2006-04-23 23:15:00
39	60	2006-04-23 19:30:00	2006-04-23 23:15:00
48	97	2006-04-22 19:00:00	2006-04-22 20:14:00
48	143	2006-04-22 19:00:00	2006-04-22 20:14:00
48	5	2006-04-22 19:00:00	2006-04-22 20:14:00
48	6	2006-04-22 19:00:00	2006-04-22 20:14:00
48	90	2006-04-22 19:00:00	2006-04-22 20:14:00
48	14	2006-04-22 19:00:00	2006-04-22 20:14:00
48	19	2006-04-22 19:00:00	2006-04-22 20:14:00
48	96	2006-04-22 19:00:00	2006-04-22 20:13:35
48	24	2006-04-22 19:00:00	2006-04-22 20:14:00
48	25	2006-04-22 19:00:00	2006-04-22 20:14:00
48	27	2006-04-22 19:06:55	2006-04-22 20:12:53
48	98	2006-04-22 19:00:00	2006-04-22 20:14:00
48	32	2006-04-22 19:00:00	2006-04-22 20:14:00
48	133	2006-04-22 19:00:00	2006-04-22 20:14:00
48	35	2006-04-22 19:00:00	2006-04-22 20:14:00
48	38	2006-04-22 19:00:00	2006-04-22 20:13:52
48	40	2006-04-22 19:00:00	2006-04-22 20:14:00
48	124	2006-04-22 19:00:00	2006-04-22 20:14:00
48	121	2006-04-22 19:00:00	2006-04-22 20:14:00
48	41	2006-04-22 19:00:00	2006-04-22 20:14:00
48	42	2006-04-22 19:00:00	2006-04-22 20:13:52
48	71	2006-04-22 19:00:00	2006-04-22 20:14:00
48	106	2006-04-22 19:00:00	2006-04-22 20:14:00
48	144	2006-04-22 19:00:00	2006-04-22 20:13:50
48	49	2006-04-22 19:00:00	2006-04-22 20:14:00
48	50	2006-04-22 19:00:00	2006-04-22 20:14:00
48	67	2006-04-22 19:00:00	2006-04-22 20:13:34
48	100	2006-04-22 19:00:00	2006-04-22 20:14:00
48	103	2006-04-22 19:00:00	2006-04-22 20:13:38
48	52	2006-04-22 19:00:00	2006-04-22 20:14:00
48	61	2006-04-22 19:00:00	2006-04-22 20:14:00
48	107	2006-04-22 19:00:00	2006-04-22 20:14:00
48	141	2006-04-22 19:00:00	2006-04-22 20:14:00
48	63	2006-04-22 19:30:32	2006-04-22 20:13:19
48	55	2006-04-22 19:00:00	2006-04-22 20:14:00
48	58	2006-04-22 19:00:00	2006-04-22 20:14:00
48	85	2006-04-22 19:00:55	2006-04-22 20:13:49
48	57	2006-04-22 19:00:00	2006-04-22 19:30:22
48	66	2006-04-22 19:00:00	2006-04-22 20:14:00
48	59	2006-04-22 19:02:53	2006-04-22 20:14:00
48	60	2006-04-22 19:00:00	2006-04-22 20:14:00
49	1	2006-04-24 21:30:00	2006-04-24 22:15:00
49	2	2006-04-24 21:30:00	2006-04-24 22:15:00
49	5	2006-04-24 21:30:00	2006-04-24 22:15:00
49	6	2006-04-24 21:30:00	2006-04-24 22:15:00
49	8	2006-04-24 21:30:00	2006-04-24 22:15:00
49	13	2006-04-24 21:30:00	2006-04-24 22:15:00
49	15	2006-04-24 21:30:00	2006-04-24 22:15:00
49	19	2006-04-24 21:30:00	2006-04-24 22:15:00
49	21	2006-04-24 21:30:00	2006-04-24 22:15:00
49	96	2006-04-24 21:30:00	2006-04-24 22:15:00
49	24	2006-04-24 21:30:00	2006-04-24 22:15:00
49	25	2006-04-24 21:30:00	2006-04-24 22:15:00
49	27	2006-04-24 21:30:00	2006-04-24 22:15:00
49	30	2006-04-24 21:30:00	2006-04-24 22:15:00
49	32	2006-04-24 21:30:00	2006-04-24 22:15:00
49	133	2006-04-24 21:42:10	2006-04-24 22:15:00
49	82	2006-04-24 21:30:00	2006-04-24 22:15:00
49	38	2006-04-24 21:30:00	2006-04-24 22:15:00
49	81	2006-04-24 21:30:00	2006-04-24 22:15:00
49	121	2006-04-24 21:30:00	2006-04-24 22:15:00
49	42	2006-04-24 21:30:00	2006-04-24 22:15:00
49	43	2006-04-24 21:30:00	2006-04-24 22:15:00
49	45	2006-04-24 21:30:00	2006-04-24 22:15:00
49	46	2006-04-24 21:30:00	2006-04-24 22:15:00
49	106	2006-04-24 21:30:00	2006-04-24 22:15:00
49	49	2006-04-24 21:30:00	2006-04-24 22:15:00
49	67	2006-04-24 21:30:00	2006-04-24 22:15:00
49	116	2006-04-24 21:30:00	2006-04-24 22:15:00
49	145	2006-04-24 21:30:00	2006-04-24 21:39:46
49	109	2006-04-24 21:30:00	2006-04-24 22:15:00
49	54	2006-04-24 21:30:00	2006-04-24 22:15:00
49	76	2006-04-24 21:30:00	2006-04-24 22:15:00
49	55	2006-04-24 21:30:00	2006-04-24 22:15:00
49	58	2006-04-24 21:30:00	2006-04-24 22:15:00
49	56	2006-04-24 21:30:00	2006-04-24 22:15:00
49	139	2006-04-24 21:30:00	2006-04-24 22:15:00
49	60	2006-04-24 21:30:00	2006-04-24 22:15:00
72	1	2006-05-12 20:30:00	2006-05-12 23:45:00
72	8	2006-05-12 20:30:00	2006-05-12 23:45:00
72	14	2006-05-12 20:30:00	2006-05-12 23:45:00
72	24	2006-05-12 20:30:00	2006-05-12 22:50:50
72	25	2006-05-12 20:30:00	2006-05-12 23:45:00
72	64	2006-05-12 20:30:00	2006-05-12 23:45:00
72	32	2006-05-12 20:30:00	2006-05-12 23:45:00
72	82	2006-05-12 20:30:00	2006-05-12 23:45:00
72	154	2006-05-12 20:30:00	2006-05-12 23:45:00
72	35	2006-05-12 20:30:13	2006-05-12 23:45:00
72	38	2006-05-12 22:53:17	2006-05-12 23:45:00
72	155	2006-05-12 20:30:00	2006-05-12 23:45:00
72	39	2006-05-12 20:30:00	2006-05-12 22:50:45
72	42	2006-05-12 20:30:00	2006-05-12 23:45:00
72	48	2006-05-12 20:30:00	2006-05-12 23:45:00
72	100	2006-05-12 22:54:36	2006-05-12 23:45:00
72	61	2006-05-12 22:53:03	2006-05-12 23:45:00
72	89	2006-05-12 20:30:00	2006-05-12 23:45:00
72	141	2006-05-12 20:30:00	2006-05-12 23:45:00
72	63	2006-05-12 20:30:00	2006-05-12 23:45:00
72	58	2006-05-12 20:30:00	2006-05-12 23:45:00
72	57	2006-05-12 20:30:00	2006-05-12 23:45:00
72	56	2006-05-12 20:30:00	2006-05-12 23:45:00
72	60	2006-05-12 20:32:39	2006-05-12 21:05:19
81	1	2006-05-22 19:30:00	2006-05-22 20:44:00
81	5	2006-05-22 19:30:00	2006-05-22 20:44:00
81	6	2006-05-22 19:30:00	2006-05-22 20:44:00
81	14	2006-05-22 19:30:00	2006-05-22 20:44:00
81	15	2006-05-22 19:30:00	2006-05-22 20:44:00
81	16	2006-05-22 19:42:09	2006-05-22 20:44:00
81	19	2006-05-22 19:30:00	2006-05-22 20:44:00
81	21	2006-05-22 19:30:00	2006-05-22 20:44:00
81	96	2006-05-22 19:34:31	2006-05-22 20:44:00
81	27	2006-05-22 19:30:00	2006-05-22 20:44:00
81	28	2006-05-22 19:30:00	2006-05-22 20:44:00
50	1	2006-04-25 21:00:00	2006-04-26 00:24:12
50	2	2006-04-25 21:00:00	2006-04-25 22:08:03
50	97	2006-04-25 21:00:00	2006-04-26 00:22:57
50	4	2006-04-25 21:00:00	2006-04-26 00:24:12
50	5	2006-04-25 21:00:00	2006-04-26 00:24:12
50	6	2006-04-25 21:00:00	2006-04-26 00:21:17
50	14	2006-04-25 21:00:00	2006-04-26 00:18:33
50	15	2006-04-25 21:00:00	2006-04-26 00:24:12
50	19	2006-04-25 22:06:58	2006-04-26 00:24:12
50	21	2006-04-25 23:18:28	2006-04-26 00:21:15
50	96	2006-04-25 21:26:52	2006-04-26 00:24:12
50	24	2006-04-25 21:00:00	2006-04-25 23:52:40
50	25	2006-04-25 21:00:00	2006-04-26 00:24:12
50	27	2006-04-25 21:00:00	2006-04-26 00:24:12
50	28	2006-04-25 21:00:00	2006-04-26 00:22:42
50	29	2006-04-25 21:00:00	2006-04-26 00:24:12
50	30	2006-04-25 21:00:00	2006-04-26 00:24:12
50	32	2006-04-25 21:22:50	2006-04-26 00:24:12
50	136	2006-04-25 21:36:37	2006-04-26 00:24:12
50	35	2006-04-25 21:00:00	2006-04-26 00:24:12
50	36	2006-04-25 21:00:00	2006-04-26 00:22:05
50	39	2006-04-25 21:00:00	2006-04-25 23:18:20
50	40	2006-04-25 21:00:00	2006-04-25 23:06:01
50	121	2006-04-25 22:41:17	2006-04-25 23:28:52
50	41	2006-04-25 21:00:00	2006-04-26 00:24:12
50	42	2006-04-25 21:00:00	2006-04-26 00:21:16
50	43	2006-04-25 21:00:00	2006-04-26 00:24:12
50	71	2006-04-25 21:00:00	2006-04-26 00:21:15
50	62	2006-04-25 21:00:00	2006-04-26 00:24:12
50	45	2006-04-25 21:00:00	2006-04-26 00:24:12
50	46	2006-04-25 21:00:00	2006-04-26 00:24:12
50	106	2006-04-25 21:00:00	2006-04-26 00:24:12
50	48	2006-04-25 23:29:13	2006-04-26 00:24:12
50	49	2006-04-25 21:11:16	2006-04-26 00:24:12
50	50	2006-04-25 21:00:00	2006-04-26 00:24:12
50	67	2006-04-25 21:00:00	2006-04-25 22:38:02
50	100	2006-04-25 22:26:31	2006-04-26 00:23:01
50	103	2006-04-25 21:00:00	2006-04-26 00:21:15
50	51	2006-04-25 21:00:00	2006-04-26 00:21:21
50	52	2006-04-25 21:00:00	2006-04-26 00:24:12
50	61	2006-04-25 21:00:00	2006-04-26 00:20:32
50	76	2006-04-25 21:00:00	2006-04-26 00:21:27
50	58	2006-04-25 21:00:00	2006-04-26 00:24:12
50	57	2006-04-25 21:00:00	2006-04-26 00:22:53
50	59	2006-04-25 22:09:02	2006-04-26 00:21:25
50	60	2006-04-25 21:19:52	2006-04-26 00:22:37
52	1	2006-04-26 21:00:00	2006-04-27 00:30:00
52	2	2006-04-26 21:00:00	2006-04-27 00:30:00
52	97	2006-04-26 21:00:00	2006-04-27 00:30:00
52	5	2006-04-26 21:00:00	2006-04-27 00:30:00
52	6	2006-04-26 21:08:52	2006-04-27 00:30:00
52	14	2006-04-26 21:00:00	2006-04-27 00:30:00
52	27	2006-04-26 21:00:00	2006-04-27 00:30:00
52	28	2006-04-26 21:00:00	2006-04-27 00:30:00
52	29	2006-04-26 21:00:00	2006-04-27 00:30:00
52	30	2006-04-26 21:00:00	2006-04-26 22:31:07
52	32	2006-04-26 21:00:00	2006-04-27 00:30:00
52	82	2006-04-26 21:45:42	2006-04-27 00:30:00
52	35	2006-04-26 21:00:00	2006-04-27 00:30:00
52	40	2006-04-26 21:00:00	2006-04-27 00:30:00
52	41	2006-04-26 21:00:00	2006-04-27 00:30:00
52	43	2006-04-26 21:08:50	2006-04-27 00:30:00
52	46	2006-04-26 21:00:00	2006-04-27 00:30:00
52	100	2006-04-26 21:00:00	2006-04-27 00:30:00
52	51	2006-04-26 21:00:00	2006-04-27 00:30:00
52	109	2006-04-26 21:00:00	2006-04-27 00:30:00
52	107	2006-04-26 21:00:00	2006-04-27 00:30:00
53	1	2006-04-27 22:57:56	2006-04-28 00:20:00
53	15	2006-04-27 22:57:56	2006-04-28 00:20:00
53	25	2006-04-27 22:57:56	2006-04-28 00:20:00
53	27	2006-04-27 22:57:56	2006-04-28 00:20:00
53	28	2006-04-27 22:57:56	2006-04-28 00:20:00
53	32	2006-04-27 22:57:56	2006-04-27 23:37:15
53	133	2006-04-27 23:32:01	2006-04-28 00:20:00
53	82	2006-04-27 22:57:56	2006-04-28 00:20:00
53	35	2006-04-27 22:57:56	2006-04-28 00:20:00
53	84	2006-04-27 22:57:56	2006-04-28 00:20:00
53	39	2006-04-27 22:57:56	2006-04-28 00:20:00
53	41	2006-04-27 22:57:56	2006-04-28 00:20:00
53	43	2006-04-27 22:57:56	2006-04-28 00:20:00
53	62	2006-04-27 22:57:56	2006-04-28 00:20:00
53	48	2006-04-27 22:57:56	2006-04-27 23:28:56
53	144	2006-04-27 22:57:56	2006-04-28 00:20:00
53	99	2006-04-27 22:57:56	2006-04-28 00:20:00
53	51	2006-04-27 22:57:56	2006-04-28 00:20:00
53	116	2006-04-27 23:39:17	2006-04-28 00:20:00
53	61	2006-04-27 22:57:56	2006-04-28 00:18:09
53	109	2006-04-27 22:57:56	2006-04-28 00:20:00
53	117	2006-04-28 00:13:01	2006-04-28 00:20:00
53	76	2006-04-27 22:57:56	2006-04-28 00:20:00
54	1	2006-04-28 21:46:07	2006-04-29 00:52:00
54	97	2006-04-28 21:46:07	2006-04-29 00:52:00
54	5	2006-04-28 21:46:07	2006-04-29 00:52:00
54	6	2006-04-28 21:46:07	2006-04-28 23:59:03
54	8	2006-04-28 21:46:07	2006-04-29 00:52:00
54	19	2006-04-29 00:29:24	2006-04-29 00:52:00
54	24	2006-04-28 21:46:07	2006-04-28 23:27:43
54	25	2006-04-28 21:46:07	2006-04-29 00:52:00
54	26	2006-04-28 22:19:00	2006-04-29 00:11:31
54	27	2006-04-28 21:46:07	2006-04-29 00:52:00
54	31	2006-04-28 21:46:07	2006-04-29 00:50:31
54	136	2006-04-28 21:46:07	2006-04-29 00:52:00
54	35	2006-04-28 21:46:07	2006-04-29 00:52:00
54	39	2006-04-28 21:46:07	2006-04-29 00:52:00
54	41	2006-04-28 21:46:07	2006-04-29 00:52:00
54	45	2006-04-28 21:46:07	2006-04-29 00:52:00
54	100	2006-04-28 21:46:07	2006-04-29 00:52:00
54	103	2006-04-28 21:46:07	2006-04-29 00:52:00
54	116	2006-04-28 21:46:07	2006-04-29 00:52:00
54	61	2006-04-29 00:21:38	2006-04-29 00:52:00
54	117	2006-04-29 00:11:25	2006-04-29 00:11:25
54	141	2006-04-28 21:46:07	2006-04-29 00:52:00
54	55	2006-04-28 22:02:30	2006-04-29 00:52:00
54	147	2006-04-28 23:29:23	2006-04-29 00:52:00
54	60	2006-04-28 21:46:07	2006-04-28 22:18:52
55	1	2006-04-29 11:00:00	2006-04-29 14:40:00
55	97	2006-04-29 11:00:00	2006-04-29 14:40:00
55	4	2006-04-29 11:00:00	2006-04-29 14:40:00
55	5	2006-04-29 11:00:00	2006-04-29 14:39:04
55	8	2006-04-29 11:00:00	2006-04-29 14:37:35
55	25	2006-04-29 11:00:00	2006-04-29 14:36:01
55	32	2006-04-29 11:00:00	2006-04-29 14:38:36
55	136	2006-04-29 14:06:25	2006-04-29 14:38:56
55	35	2006-04-29 11:00:00	2006-04-29 14:40:00
55	39	2006-04-29 11:00:00	2006-04-29 14:38:58
55	81	2006-04-29 11:00:00	2006-04-29 14:40:00
55	48	2006-04-29 11:00:00	2006-04-29 14:39:50
55	100	2006-04-29 11:00:00	2006-04-29 14:39:02
55	114	2006-04-29 11:00:00	2006-04-29 14:07:11
55	103	2006-04-29 11:00:00	2006-04-29 14:35:46
55	51	2006-04-29 11:00:00	2006-04-29 14:35:20
55	148	2006-04-29 11:16:30	2006-04-29 14:40:00
55	61	2006-04-29 11:00:00	2006-04-29 14:40:00
55	91	2006-04-29 11:00:00	2006-04-29 14:38:55
55	117	2006-04-29 13:58:17	2006-04-29 14:40:00
55	54	2006-04-29 11:00:00	2006-04-29 14:35:30
56	97	2006-04-29 19:00:00	2006-04-29 20:17:00
56	4	2006-04-29 19:04:54	2006-04-29 20:17:00
56	5	2006-04-29 19:00:00	2006-04-29 20:17:00
56	6	2006-04-29 19:00:00	2006-04-29 20:16:57
56	8	2006-04-29 19:00:00	2006-04-29 20:17:00
56	149	2006-04-29 19:00:00	2006-04-29 20:17:00
56	14	2006-04-29 19:36:45	2006-04-29 20:17:00
56	15	2006-04-29 19:00:00	2006-04-29 20:17:00
56	123	2006-04-29 19:00:00	2006-04-29 20:17:00
56	19	2006-04-29 19:00:00	2006-04-29 20:17:00
56	96	2006-04-29 19:32:31	2006-04-29 20:17:00
56	24	2006-04-29 19:00:00	2006-04-29 20:17:00
56	25	2006-04-29 19:00:00	2006-04-29 20:17:00
56	26	2006-04-29 19:00:00	2006-04-29 20:16:31
56	27	2006-04-29 19:00:00	2006-04-29 20:16:53
56	98	2006-04-29 19:00:00	2006-04-29 20:17:00
56	31	2006-04-29 19:00:00	2006-04-29 20:17:00
56	32	2006-04-29 19:00:00	2006-04-29 20:17:00
56	136	2006-04-29 19:00:00	2006-04-29 20:17:00
56	35	2006-04-29 19:00:00	2006-04-29 20:17:00
56	150	2006-04-29 19:00:00	2006-04-29 20:17:00
56	121	2006-04-29 19:00:00	2006-04-29 20:17:00
56	42	2006-04-29 19:00:00	2006-04-29 20:17:00
56	142	2006-04-29 19:00:00	2006-04-29 20:17:00
56	49	2006-04-29 19:00:00	2006-04-29 20:17:00
56	67	2006-04-29 19:00:00	2006-04-29 20:17:00
56	100	2006-04-29 19:00:00	2006-04-29 20:17:00
56	103	2006-04-29 19:00:00	2006-04-29 20:17:00
56	51	2006-04-29 19:00:00	2006-04-29 20:17:00
56	151	2006-04-29 19:00:00	2006-04-29 19:01:42
56	61	2006-04-29 19:00:00	2006-04-29 20:17:00
56	152	2006-04-29 19:00:00	2006-04-29 20:17:00
56	89	2006-04-29 19:00:00	2006-04-29 20:17:00
56	76	2006-04-29 19:00:00	2006-04-29 20:17:00
56	141	2006-04-29 19:00:00	2006-04-29 20:17:00
56	55	2006-04-29 19:00:00	2006-04-29 20:17:00
56	58	2006-04-29 19:00:00	2006-04-29 20:17:00
56	153	2006-04-29 19:00:00	2006-04-29 20:17:00
56	56	2006-04-29 19:00:00	2006-04-29 20:17:00
56	59	2006-04-29 19:00:00	2006-04-29 20:17:00
56	60	2006-04-29 19:00:00	2006-04-29 20:17:00
47	1	2006-04-30 22:27:53	2006-05-01 00:40:00
47	4	2006-04-30 19:30:00	2006-05-01 00:40:00
47	5	2006-05-01 00:04:22	2006-05-01 00:40:00
47	6	2006-04-30 19:30:00	2006-05-01 00:40:00
47	7	2006-04-30 19:30:00	2006-05-01 00:40:00
47	14	2006-04-30 19:30:00	2006-05-01 00:40:00
47	15	2006-04-30 19:30:00	2006-05-01 00:40:00
47	16	2006-04-30 19:30:00	2006-05-01 00:40:00
47	19	2006-04-30 19:30:00	2006-05-01 00:40:00
47	21	2006-04-30 19:30:00	2006-05-01 00:40:00
47	96	2006-04-30 19:30:00	2006-05-01 00:40:00
47	23	2006-04-30 19:33:48	2006-05-01 00:04:09
47	24	2006-04-30 19:30:00	2006-05-01 00:40:00
47	25	2006-04-30 19:30:00	2006-05-01 00:40:00
47	27	2006-04-30 19:30:00	2006-05-01 00:40:00
47	28	2006-04-30 19:30:00	2006-05-01 00:40:00
47	30	2006-04-30 19:30:00	2006-05-01 00:40:00
47	31	2006-04-30 20:26:52	2006-05-01 00:40:00
47	32	2006-04-30 23:56:07	2006-05-01 00:40:00
47	82	2006-04-30 19:30:00	2006-05-01 00:39:37
47	146	2006-04-30 19:30:00	2006-05-01 00:40:00
47	35	2006-04-30 19:30:00	2006-05-01 00:40:00
47	150	2006-04-30 19:30:00	2006-05-01 00:40:00
47	38	2006-04-30 19:30:00	2006-05-01 00:40:00
47	39	2006-04-30 19:30:00	2006-05-01 00:00:37
47	40	2006-04-30 19:30:00	2006-05-01 00:40:00
47	81	2006-04-30 19:30:00	2006-05-01 00:40:00
47	121	2006-05-01 00:00:21	2006-05-01 00:40:00
47	62	2006-04-30 19:30:00	2006-05-01 00:40:00
47	44	2006-04-30 19:30:00	2006-04-30 23:56:01
47	45	2006-04-30 19:30:00	2006-05-01 00:40:00
47	106	2006-04-30 19:30:00	2006-05-01 00:40:00
47	48	2006-04-30 19:30:00	2006-05-01 00:40:00
47	144	2006-04-30 19:30:00	2006-05-01 00:05:21
47	49	2006-04-30 19:30:00	2006-05-01 00:40:00
47	50	2006-04-30 20:04:54	2006-04-30 20:26:44
47	67	2006-04-30 19:30:00	2006-05-01 00:40:00
47	103	2006-04-30 19:30:00	2006-05-01 00:39:04
47	51	2006-04-30 19:30:00	2006-05-01 00:40:00
47	52	2006-04-30 19:30:00	2006-05-01 00:40:00
47	116	2006-04-30 19:30:00	2006-05-01 00:40:00
47	61	2006-04-30 19:30:00	2006-05-01 00:00:10
47	54	2006-04-30 19:30:00	2006-05-01 00:39:56
47	58	2006-04-30 19:30:00	2006-05-01 00:40:00
47	57	2006-04-30 19:30:00	2006-05-01 00:40:00
47	59	2006-04-30 19:30:00	2006-05-01 00:40:00
47	60	2006-04-30 23:15:43	2006-05-01 00:39:52
57	1	2006-05-01 21:00:00	2006-05-02 00:40:00
57	2	2006-05-01 21:00:00	2006-05-01 22:18:53
57	97	2006-05-01 21:00:00	2006-05-02 00:40:00
57	4	2006-05-01 21:00:00	2006-05-02 00:40:00
57	5	2006-05-01 21:00:00	2006-05-02 00:40:00
57	6	2006-05-01 21:00:00	2006-05-02 00:40:00
57	7	2006-05-01 23:25:17	2006-05-02 00:40:00
57	135	2006-05-02 00:29:35	2006-05-02 00:40:00
57	8	2006-05-01 21:00:00	2006-05-02 00:40:00
57	14	2006-05-01 21:00:00	2006-05-02 00:23:16
57	15	2006-05-01 21:00:00	2006-05-02 00:40:00
57	18	2006-05-01 21:00:00	2006-05-02 00:40:00
57	19	2006-05-01 21:00:00	2006-05-02 00:40:00
57	23	2006-05-01 21:00:00	2006-05-01 23:23:50
57	24	2006-05-01 21:00:00	2006-05-02 00:21:21
57	25	2006-05-01 21:00:00	2006-05-02 00:40:00
57	27	2006-05-01 21:00:00	2006-05-02 00:40:00
57	28	2006-05-01 21:00:00	2006-05-02 00:40:00
57	29	2006-05-01 22:48:18	2006-05-02 00:40:00
57	30	2006-05-01 21:00:00	2006-05-02 00:40:00
57	31	2006-05-02 00:26:23	2006-05-02 00:40:00
57	32	2006-05-01 21:00:00	2006-05-02 00:40:00
57	136	2006-05-02 00:23:00	2006-05-02 00:40:00
57	35	2006-05-01 21:00:00	2006-05-02 00:40:00
57	36	2006-05-01 21:00:00	2006-05-02 00:40:00
57	39	2006-05-01 21:23:12	2006-05-01 23:00:46
57	40	2006-05-01 21:00:00	2006-05-02 00:40:00
57	121	2006-05-01 21:00:00	2006-05-02 00:40:00
57	41	2006-05-01 21:00:00	2006-05-02 00:40:00
57	42	2006-05-01 21:00:00	2006-05-02 00:40:00
57	43	2006-05-01 21:00:00	2006-05-02 00:40:00
57	62	2006-05-01 21:00:00	2006-05-01 22:48:12
57	45	2006-05-01 21:00:00	2006-05-02 00:40:00
57	46	2006-05-01 21:00:00	2006-05-02 00:40:00
57	106	2006-05-01 21:00:00	2006-05-02 00:40:00
57	48	2006-05-01 21:00:00	2006-05-02 00:40:00
57	50	2006-05-01 21:00:00	2006-05-02 00:40:00
57	67	2006-05-01 21:00:00	2006-05-02 00:40:00
57	100	2006-05-01 23:08:52	2006-05-01 23:35:56
57	103	2006-05-01 21:00:00	2006-05-02 00:40:00
57	51	2006-05-01 21:00:00	2006-05-02 00:40:00
57	52	2006-05-01 21:00:00	2006-05-02 00:40:00
57	61	2006-05-01 21:00:00	2006-05-01 21:22:57
57	54	2006-05-01 23:38:15	2006-05-02 00:40:00
57	76	2006-05-01 21:00:00	2006-05-02 00:29:29
57	58	2006-05-01 21:00:00	2006-05-02 00:40:00
57	57	2006-05-01 21:00:00	2006-05-02 00:40:00
57	59	2006-05-01 22:19:06	2006-05-02 00:40:00
57	60	2006-05-01 21:00:00	2006-05-02 00:40:00
58	1	2006-05-02 21:00:00	2006-05-03 00:40:00
58	2	2006-05-02 21:00:00	2006-05-03 00:40:00
58	4	2006-05-02 21:00:00	2006-05-03 00:40:00
58	5	2006-05-02 22:05:53	2006-05-03 00:40:00
58	6	2006-05-02 22:30:46	2006-05-03 00:40:00
58	135	2006-05-02 21:00:00	2006-05-03 00:40:00
58	8	2006-05-02 21:00:00	2006-05-02 23:52:08
58	14	2006-05-02 21:00:00	2006-05-03 00:40:00
58	15	2006-05-02 21:00:00	2006-05-03 00:40:00
58	19	2006-05-02 21:00:00	2006-05-03 00:40:00
58	21	2006-05-02 21:00:00	2006-05-03 00:40:00
58	96	2006-05-02 21:00:00	2006-05-03 00:40:00
58	24	2006-05-02 22:30:09	2006-05-02 23:54:58
58	25	2006-05-02 21:00:00	2006-05-03 00:40:00
58	27	2006-05-02 21:00:00	2006-05-03 00:40:00
58	28	2006-05-02 21:00:00	2006-05-03 00:40:00
58	29	2006-05-02 21:00:00	2006-05-03 00:40:00
58	30	2006-05-02 21:00:00	2006-05-03 00:40:00
58	32	2006-05-02 21:00:00	2006-05-03 00:40:00
58	33	2006-05-02 23:00:56	2006-05-03 00:40:00
58	35	2006-05-02 21:00:00	2006-05-03 00:40:00
58	36	2006-05-02 21:00:00	2006-05-03 00:40:00
58	39	2006-05-02 21:00:00	2006-05-02 23:00:49
58	40	2006-05-02 21:00:00	2006-05-02 22:04:50
58	81	2006-05-02 21:00:00	2006-05-02 22:29:40
58	121	2006-05-02 21:00:00	2006-05-03 00:40:00
58	41	2006-05-02 21:00:00	2006-05-03 00:40:00
58	42	2006-05-02 21:00:00	2006-05-03 00:40:00
58	43	2006-05-02 21:00:00	2006-05-03 00:40:00
58	45	2006-05-02 21:00:00	2006-05-03 00:40:00
58	46	2006-05-02 21:00:00	2006-05-03 00:40:00
58	106	2006-05-02 21:00:00	2006-05-03 00:40:00
58	48	2006-05-02 21:00:00	2006-05-03 00:40:00
58	49	2006-05-02 23:54:57	2006-05-03 00:40:00
58	50	2006-05-02 21:00:00	2006-05-03 00:40:00
58	67	2006-05-02 21:00:00	2006-05-02 23:54:46
58	100	2006-05-02 21:00:00	2006-05-03 00:25:00
58	103	2006-05-02 21:00:00	2006-05-03 00:40:00
58	51	2006-05-02 21:00:00	2006-05-03 00:40:00
58	52	2006-05-02 21:00:00	2006-05-03 00:40:00
58	117	2006-05-02 21:47:34	2006-05-03 00:40:00
58	141	2006-05-02 21:00:00	2006-05-03 00:40:00
58	55	2006-05-02 21:00:00	2006-05-02 22:26:10
58	58	2006-05-02 21:00:00	2006-05-03 00:40:00
58	57	2006-05-02 21:00:00	2006-05-03 00:40:00
58	59	2006-05-02 21:00:00	2006-05-03 00:40:00
58	60	2006-05-02 21:00:00	2006-05-03 00:40:00
59	1	2006-05-03 21:00:00	2006-05-03 21:30:00
59	97	2006-05-03 21:00:00	2006-05-03 21:30:00
59	4	2006-05-03 21:00:00	2006-05-03 21:30:00
59	5	2006-05-03 21:00:00	2006-05-03 21:30:00
59	6	2006-05-03 21:00:00	2006-05-03 21:30:00
59	8	2006-05-03 21:00:00	2006-05-03 21:30:00
59	90	2006-05-03 21:00:00	2006-05-03 21:30:00
59	13	2006-05-03 21:00:00	2006-05-03 21:30:00
59	14	2006-05-03 21:00:00	2006-05-03 21:30:00
59	15	2006-05-03 21:00:00	2006-05-03 21:30:00
59	19	2006-05-03 21:00:00	2006-05-03 21:30:00
59	21	2006-05-03 21:00:00	2006-05-03 21:30:00
59	96	2006-05-03 21:00:00	2006-05-03 21:30:00
59	24	2006-05-03 21:00:00	2006-05-03 21:30:00
59	25	2006-05-03 21:00:00	2006-05-03 21:30:00
59	26	2006-05-03 21:00:00	2006-05-03 21:30:00
59	27	2006-05-03 21:00:00	2006-05-03 21:30:00
59	28	2006-05-03 21:00:00	2006-05-03 21:30:00
59	98	2006-05-03 21:00:00	2006-05-03 21:30:00
59	29	2006-05-03 21:00:00	2006-05-03 21:30:00
59	30	2006-05-03 21:00:00	2006-05-03 21:30:00
59	31	2006-05-03 21:00:00	2006-05-03 21:30:00
59	32	2006-05-03 21:00:00	2006-05-03 21:30:00
59	33	2006-05-03 21:00:00	2006-05-03 21:30:00
59	82	2006-05-03 21:00:00	2006-05-03 21:30:00
59	136	2006-05-03 21:00:00	2006-05-03 21:30:00
59	35	2006-05-03 21:00:00	2006-05-03 21:30:00
59	38	2006-05-03 21:00:00	2006-05-03 21:30:00
59	39	2006-05-03 21:00:00	2006-05-03 21:30:00
59	40	2006-05-03 21:00:00	2006-05-03 21:30:00
59	81	2006-05-03 21:00:00	2006-05-03 21:30:00
59	41	2006-05-03 21:00:00	2006-05-03 21:30:00
59	42	2006-05-03 21:00:00	2006-05-03 21:30:00
59	43	2006-05-03 21:00:00	2006-05-03 21:30:00
59	44	2006-05-03 21:00:00	2006-05-03 21:30:00
59	45	2006-05-03 21:00:00	2006-05-03 21:30:00
59	46	2006-05-03 21:00:00	2006-05-03 21:30:00
59	106	2006-05-03 21:00:00	2006-05-03 21:30:00
59	48	2006-05-03 21:00:00	2006-05-03 21:30:00
59	50	2006-05-03 21:00:00	2006-05-03 21:30:00
59	67	2006-05-03 21:00:00	2006-05-03 21:30:00
59	103	2006-05-03 21:00:00	2006-05-03 21:30:00
59	51	2006-05-03 21:00:00	2006-05-03 21:30:00
59	52	2006-05-03 21:00:00	2006-05-03 21:30:00
59	61	2006-05-03 21:00:00	2006-05-03 21:30:00
59	76	2006-05-03 21:00:00	2006-05-03 21:30:00
59	63	2006-05-03 21:00:00	2006-05-03 21:29:03
59	55	2006-05-03 21:00:00	2006-05-03 21:30:00
59	58	2006-05-03 21:00:00	2006-05-03 21:30:00
59	57	2006-05-03 21:00:00	2006-05-03 21:30:00
59	60	2006-05-03 21:00:00	2006-05-03 21:30:00
60	1	2006-05-03 21:30:00	2006-05-04 00:12:00
60	97	2006-05-03 21:45:16	2006-05-03 23:25:43
60	4	2006-05-03 23:18:48	2006-05-04 00:12:00
60	5	2006-05-03 21:30:00	2006-05-04 00:12:00
60	6	2006-05-03 21:30:00	2006-05-04 00:12:00
60	8	2006-05-03 21:30:00	2006-05-04 00:12:00
60	90	2006-05-03 21:30:00	2006-05-03 21:32:01
60	13	2006-05-03 21:42:28	2006-05-04 00:08:44
60	14	2006-05-03 21:30:00	2006-05-04 00:09:05
60	15	2006-05-03 21:30:00	2006-05-04 00:12:00
60	19	2006-05-03 21:30:00	2006-05-04 00:12:00
60	21	2006-05-03 21:30:00	2006-05-04 00:12:00
60	96	2006-05-03 21:30:00	2006-05-04 00:12:00
60	24	2006-05-03 21:30:00	2006-05-03 23:16:32
60	25	2006-05-03 21:31:10	2006-05-04 00:12:00
60	26	2006-05-03 21:30:00	2006-05-03 21:34:42
60	27	2006-05-03 21:30:00	2006-05-04 00:12:00
60	28	2006-05-03 21:30:00	2006-05-04 00:12:00
60	98	2006-05-03 21:30:00	2006-05-03 21:30:27
60	29	2006-05-03 21:31:18	2006-05-04 00:12:00
60	30	2006-05-03 21:30:00	2006-05-04 00:12:00
60	31	2006-05-03 21:30:00	2006-05-04 00:12:00
60	32	2006-05-03 21:30:00	2006-05-04 00:12:00
60	33	2006-05-03 21:30:00	2006-05-04 00:12:00
60	82	2006-05-03 21:30:00	2006-05-03 21:30:55
60	136	2006-05-03 21:38:14	2006-05-04 00:12:00
60	35	2006-05-03 21:30:00	2006-05-04 00:12:00
60	38	2006-05-03 21:30:36	2006-05-04 00:12:00
60	39	2006-05-03 21:30:00	2006-05-03 21:30:29
60	40	2006-05-03 21:30:00	2006-05-04 00:12:00
60	81	2006-05-03 21:30:00	2006-05-04 00:12:00
60	41	2006-05-03 21:44:13	2006-05-04 00:12:00
60	42	2006-05-03 21:30:00	2006-05-04 00:12:00
60	43	2006-05-03 21:30:00	2006-05-04 00:12:00
60	44	2006-05-03 21:30:00	2006-05-03 21:31:17
60	45	2006-05-03 21:30:00	2006-05-04 00:12:00
60	46	2006-05-03 21:30:00	2006-05-04 00:12:00
60	106	2006-05-03 21:30:00	2006-05-04 00:12:00
60	48	2006-05-03 21:33:44	2006-05-04 00:12:00
60	50	2006-05-03 23:18:35	2006-05-04 00:12:00
60	67	2006-05-03 21:30:00	2006-05-03 22:59:49
60	103	2006-05-03 21:30:00	2006-05-04 00:09:34
60	51	2006-05-03 21:30:00	2006-05-04 00:12:00
60	52	2006-05-03 21:30:00	2006-05-04 00:12:00
60	61	2006-05-03 21:30:00	2006-05-03 23:17:37
60	76	2006-05-03 21:30:00	2006-05-04 00:12:00
60	63	2006-05-03 21:30:00	2006-05-04 00:12:00
60	55	2006-05-03 21:30:00	2006-05-03 23:06:59
60	58	2006-05-03 21:30:18	2006-05-04 00:12:00
60	57	2006-05-03 21:30:00	2006-05-04 00:12:00
60	60	2006-05-03 21:30:00	2006-05-04 00:12:00
66	4	2006-05-07 23:26:21	2006-05-08 00:14:00
66	5	2006-05-07 23:26:21	2006-05-07 23:26:42
66	6	2006-05-07 23:26:21	2006-05-08 00:14:00
66	7	2006-05-07 23:26:21	2006-05-08 00:14:00
66	8	2006-05-07 23:26:21	2006-05-08 00:14:00
66	15	2006-05-07 23:26:21	2006-05-08 00:14:00
66	16	2006-05-07 23:26:21	2006-05-08 00:14:00
66	19	2006-05-07 23:26:21	2006-05-08 00:14:00
66	21	2006-05-07 23:26:21	2006-05-08 00:14:00
66	96	2006-05-07 23:26:21	2006-05-08 00:14:00
66	24	2006-05-07 23:26:21	2006-05-08 00:14:00
66	25	2006-05-07 23:26:21	2006-05-08 00:14:00
66	27	2006-05-07 23:26:21	2006-05-08 00:14:00
66	29	2006-05-07 23:26:21	2006-05-07 23:27:39
66	30	2006-05-07 23:26:21	2006-05-08 00:14:00
66	31	2006-05-07 23:26:21	2006-05-08 00:14:00
66	32	2006-05-07 23:26:21	2006-05-08 00:14:00
66	33	2006-05-07 23:26:21	2006-05-08 00:14:00
66	35	2006-05-07 23:26:21	2006-05-08 00:14:00
66	36	2006-05-07 23:26:21	2006-05-08 00:14:00
66	39	2006-05-07 23:26:21	2006-05-08 00:12:29
66	42	2006-05-07 23:26:21	2006-05-08 00:14:00
66	43	2006-05-07 23:26:49	2006-05-08 00:14:00
66	44	2006-05-07 23:26:21	2006-05-08 00:14:00
66	45	2006-05-07 23:26:21	2006-05-08 00:14:00
66	46	2006-05-07 23:26:21	2006-05-08 00:14:00
66	106	2006-05-07 23:26:21	2006-05-08 00:14:00
66	105	2006-05-07 23:29:21	2006-05-08 00:14:00
66	49	2006-05-07 23:26:21	2006-05-08 00:14:00
66	50	2006-05-07 23:26:21	2006-05-08 00:14:00
66	100	2006-05-07 23:26:21	2006-05-08 00:14:00
66	103	2006-05-07 23:26:21	2006-05-08 00:13:53
66	51	2006-05-07 23:26:21	2006-05-08 00:14:00
66	52	2006-05-07 23:26:21	2006-05-08 00:14:00
66	53	2006-05-07 23:28:40	2006-05-08 00:14:00
66	107	2006-05-07 23:40:17	2006-05-08 00:14:00
66	54	2006-05-07 23:26:21	2006-05-08 00:14:00
66	76	2006-05-07 23:26:21	2006-05-08 00:14:00
66	58	2006-05-07 23:26:21	2006-05-08 00:14:00
66	57	2006-05-07 23:26:21	2006-05-08 00:14:00
61	1	2006-05-05 21:00:00	2006-05-05 23:30:00
61	8	2006-05-05 21:00:00	2006-05-05 23:30:00
61	14	2006-05-05 21:00:00	2006-05-05 23:27:26
61	23	2006-05-05 21:32:39	2006-05-05 22:42:50
61	25	2006-05-05 21:00:00	2006-05-05 23:30:00
61	64	2006-05-05 21:00:00	2006-05-05 23:30:00
61	27	2006-05-05 22:42:48	2006-05-05 23:30:00
61	31	2006-05-05 21:00:00	2006-05-05 23:30:00
61	119	2006-05-05 21:00:00	2006-05-05 23:30:00
61	154	2006-05-05 21:00:00	2006-05-05 23:30:00
61	35	2006-05-05 21:00:00	2006-05-05 23:30:00
61	38	2006-05-05 21:00:00	2006-05-05 23:30:00
61	39	2006-05-05 22:36:02	2006-05-05 23:30:00
61	42	2006-05-05 21:00:00	2006-05-05 23:24:59
61	44	2006-05-05 21:00:00	2006-05-05 23:30:00
61	48	2006-05-05 21:00:00	2006-05-05 23:30:00
61	100	2006-05-05 21:00:00	2006-05-05 23:30:00
61	116	2006-05-05 21:00:00	2006-05-05 23:25:15
61	61	2006-05-05 21:00:00	2006-05-05 22:30:44
61	89	2006-05-05 21:00:00	2006-05-05 23:30:00
61	63	2006-05-05 21:00:00	2006-05-05 23:30:00
61	57	2006-05-05 21:00:00	2006-05-05 23:30:00
61	60	2006-05-05 21:00:00	2006-05-05 21:30:42
62	1	2006-05-06 11:00:00	2006-05-06 14:50:00
62	4	2006-05-06 11:39:00	2006-05-06 14:50:00
62	5	2006-05-06 11:00:00	2006-05-06 14:50:00
62	8	2006-05-06 11:00:00	2006-05-06 14:50:00
62	24	2006-05-06 11:00:00	2006-05-06 14:28:53
62	25	2006-05-06 11:00:00	2006-05-06 14:50:00
62	30	2006-05-06 11:00:00	2006-05-06 14:45:34
62	32	2006-05-06 11:00:00	2006-05-06 14:50:00
62	136	2006-05-06 11:00:00	2006-05-06 14:50:00
62	35	2006-05-06 11:00:00	2006-05-06 14:50:00
62	38	2006-05-06 11:00:00	2006-05-06 14:50:00
62	39	2006-05-06 11:00:00	2006-05-06 14:24:45
62	40	2006-05-06 11:00:00	2006-05-06 11:38:41
62	41	2006-05-06 11:00:00	2006-05-06 14:50:00
62	44	2006-05-06 11:00:00	2006-05-06 14:50:00
62	48	2006-05-06 11:00:00	2006-05-06 14:50:00
62	144	2006-05-06 11:00:00	2006-05-06 14:50:00
62	100	2006-05-06 11:00:00	2006-05-06 14:50:00
62	51	2006-05-06 11:00:00	2006-05-06 14:50:00
62	61	2006-05-06 11:00:00	2006-05-06 14:50:00
62	54	2006-05-06 11:00:00	2006-05-06 14:47:36
63	2	2006-05-06 19:00:00	2006-05-06 20:00:00
63	97	2006-05-06 19:00:00	2006-05-06 20:00:00
63	5	2006-05-06 19:00:00	2006-05-06 20:00:00
63	6	2006-05-06 19:00:00	2006-05-06 20:00:00
63	8	2006-05-06 19:00:00	2006-05-06 20:00:00
63	21	2006-05-06 19:00:00	2006-05-06 20:00:00
63	96	2006-05-06 19:21:47	2006-05-06 20:00:00
63	24	2006-05-06 19:00:00	2006-05-06 20:00:00
63	25	2006-05-06 19:00:00	2006-05-06 20:00:00
63	64	2006-05-06 19:00:00	2006-05-06 20:00:00
63	27	2006-05-06 19:13:11	2006-05-06 20:00:00
63	98	2006-05-06 19:00:00	2006-05-06 20:00:00
63	32	2006-05-06 19:00:00	2006-05-06 20:00:00
63	33	2006-05-06 19:00:00	2006-05-06 20:00:00
63	154	2006-05-06 19:00:00	2006-05-06 20:00:00
63	136	2006-05-06 19:00:00	2006-05-06 20:00:00
63	35	2006-05-06 19:00:00	2006-05-06 20:00:00
63	155	2006-05-06 19:00:00	2006-05-06 20:00:00
63	120	2006-05-06 19:02:49	2006-05-06 20:00:00
63	41	2006-05-06 19:00:00	2006-05-06 20:00:00
63	42	2006-05-06 19:00:00	2006-05-06 20:00:00
63	45	2006-05-06 19:00:00	2006-05-06 20:00:00
63	106	2006-05-06 19:00:00	2006-05-06 20:00:00
63	48	2006-05-06 19:00:00	2006-05-06 20:00:00
63	144	2006-05-06 19:00:00	2006-05-06 20:00:00
63	49	2006-05-06 19:00:00	2006-05-06 20:00:00
63	67	2006-05-06 19:00:00	2006-05-06 19:21:02
63	51	2006-05-06 19:00:00	2006-05-06 20:00:00
63	115	2006-05-06 19:00:00	2006-05-06 20:00:00
63	61	2006-05-06 19:00:00	2006-05-06 20:00:00
63	152	2006-05-06 19:00:00	2006-05-06 20:00:00
63	89	2006-05-06 19:12:18	2006-05-06 20:00:00
63	118	2006-05-06 19:32:55	2006-05-06 20:00:00
63	58	2006-05-06 19:00:00	2006-05-06 20:00:00
63	57	2006-05-06 19:00:00	2006-05-06 20:00:00
63	56	2006-05-06 19:00:00	2006-05-06 20:00:00
63	59	2006-05-06 19:00:00	2006-05-06 20:00:00
63	60	2006-05-06 19:00:00	2006-05-06 20:00:00
64	4	2006-05-07 19:39:00	2006-05-07 23:23:00
64	5	2006-05-07 19:39:00	2006-05-07 23:23:00
64	6	2006-05-07 19:39:00	2006-05-07 23:23:00
64	7	2006-05-07 19:39:00	2006-05-07 23:23:00
64	8	2006-05-07 19:39:00	2006-05-07 23:23:00
64	15	2006-05-07 19:39:00	2006-05-07 23:23:00
64	16	2006-05-07 19:39:00	2006-05-07 23:23:00
64	19	2006-05-07 19:39:00	2006-05-07 23:23:00
64	21	2006-05-07 19:39:00	2006-05-07 23:23:00
64	96	2006-05-07 19:39:00	2006-05-07 23:23:00
64	24	2006-05-07 19:39:00	2006-05-07 23:23:00
64	25	2006-05-07 19:39:00	2006-05-07 23:23:00
64	27	2006-05-07 19:39:00	2006-05-07 23:23:00
64	29	2006-05-07 22:23:52	2006-05-07 23:23:00
64	30	2006-05-07 19:39:00	2006-05-07 23:23:00
64	31	2006-05-07 19:39:00	2006-05-07 23:23:00
64	32	2006-05-07 19:39:00	2006-05-07 23:23:00
64	33	2006-05-07 19:39:00	2006-05-07 23:23:00
64	136	2006-05-07 19:39:00	2006-05-07 22:19:58
64	35	2006-05-07 19:39:00	2006-05-07 23:23:00
64	36	2006-05-07 19:39:00	2006-05-07 23:23:00
64	38	2006-05-07 19:39:00	2006-05-07 23:22:16
64	39	2006-05-07 19:39:00	2006-05-07 23:23:00
64	41	2006-05-07 19:39:00	2006-05-07 23:23:00
64	42	2006-05-07 21:44:06	2006-05-07 23:23:00
64	43	2006-05-07 19:39:00	2006-05-07 23:04:06
64	62	2006-05-07 19:39:00	2006-05-07 22:21:56
64	44	2006-05-07 19:39:00	2006-05-07 23:23:00
64	45	2006-05-07 19:39:00	2006-05-07 23:23:00
64	46	2006-05-07 19:39:00	2006-05-07 23:23:00
64	106	2006-05-07 19:39:00	2006-05-07 23:23:00
64	48	2006-05-07 19:39:00	2006-05-07 23:23:00
64	49	2006-05-07 19:39:00	2006-05-07 23:23:00
64	50	2006-05-07 19:39:00	2006-05-07 23:23:00
64	100	2006-05-07 19:39:00	2006-05-07 23:23:00
64	103	2006-05-07 21:28:20	2006-05-07 23:23:00
64	51	2006-05-07 19:39:00	2006-05-07 23:23:00
64	52	2006-05-07 19:39:00	2006-05-07 23:23:00
64	61	2006-05-07 19:39:00	2006-05-07 21:11:22
64	54	2006-05-07 19:39:00	2006-05-07 23:23:00
64	76	2006-05-07 19:39:00	2006-05-07 23:23:00
64	63	2006-05-07 19:39:00	2006-05-07 21:43:36
64	58	2006-05-07 19:39:00	2006-05-07 23:23:00
64	57	2006-05-07 19:39:00	2006-05-07 23:23:00
64	56	2006-05-07 19:39:00	2006-05-07 23:23:00
64	59	2006-05-07 19:39:00	2006-05-07 23:23:00
64	60	2006-05-07 22:20:12	2006-05-07 23:23:00
66	56	2006-05-07 23:26:21	2006-05-08 00:14:00
66	59	2006-05-07 23:26:21	2006-05-07 23:39:30
66	60	2006-05-07 23:26:21	2006-05-08 00:14:00
65	1	2006-05-08 21:00:00	2006-05-09 00:05:00
65	97	2006-05-08 21:00:00	2006-05-08 22:56:10
65	4	2006-05-08 21:00:00	2006-05-09 00:05:00
65	5	2006-05-08 21:00:00	2006-05-09 00:05:00
65	8	2006-05-08 21:00:00	2006-05-09 00:05:00
65	14	2006-05-08 21:00:00	2006-05-08 23:10:43
65	15	2006-05-08 21:00:00	2006-05-09 00:05:00
65	16	2006-05-08 23:13:26	2006-05-09 00:05:00
65	19	2006-05-08 21:00:00	2006-05-09 00:05:00
65	21	2006-05-08 21:00:00	2006-05-09 00:05:00
65	96	2006-05-08 21:00:00	2006-05-09 00:05:00
65	24	2006-05-08 21:00:00	2006-05-09 00:05:00
65	25	2006-05-08 21:00:00	2006-05-09 00:05:00
65	27	2006-05-08 21:00:00	2006-05-09 00:05:00
65	28	2006-05-08 21:00:00	2006-05-09 00:05:00
65	29	2006-05-08 21:00:00	2006-05-09 00:05:00
65	30	2006-05-08 21:00:00	2006-05-09 00:05:00
65	31	2006-05-08 21:00:00	2006-05-09 00:05:00
65	32	2006-05-08 21:00:00	2006-05-09 00:05:00
65	33	2006-05-08 21:00:00	2006-05-09 00:05:00
65	35	2006-05-08 21:00:00	2006-05-09 00:05:00
65	36	2006-05-08 21:00:00	2006-05-09 00:05:00
65	38	2006-05-08 21:00:00	2006-05-09 00:05:00
65	40	2006-05-08 21:00:00	2006-05-09 00:05:00
65	41	2006-05-08 21:00:00	2006-05-09 00:05:00
65	42	2006-05-08 21:00:00	2006-05-09 00:05:00
65	43	2006-05-08 21:00:00	2006-05-09 00:05:00
65	45	2006-05-08 21:00:00	2006-05-09 00:05:00
65	46	2006-05-08 21:00:00	2006-05-09 00:05:00
65	106	2006-05-08 21:00:00	2006-05-09 00:05:00
65	48	2006-05-08 21:00:00	2006-05-09 00:05:00
65	49	2006-05-08 21:00:00	2006-05-09 00:05:00
65	50	2006-05-08 21:00:00	2006-05-09 00:05:00
65	103	2006-05-08 21:00:00	2006-05-09 00:05:00
65	51	2006-05-08 21:00:00	2006-05-09 00:05:00
65	52	2006-05-08 21:00:00	2006-05-09 00:05:00
65	53	2006-05-08 22:56:51	2006-05-09 00:05:00
65	54	2006-05-08 21:00:00	2006-05-09 00:05:00
65	76	2006-05-08 21:00:00	2006-05-09 00:05:00
65	55	2006-05-08 21:00:00	2006-05-09 00:05:00
65	58	2006-05-08 21:00:00	2006-05-09 00:05:00
65	57	2006-05-08 21:00:00	2006-05-09 00:05:00
65	60	2006-05-08 21:00:00	2006-05-09 00:05:00
67	1	2006-05-09 21:00:00	2006-05-09 23:45:00
67	4	2006-05-09 21:00:00	2006-05-09 23:45:00
67	5	2006-05-09 21:00:00	2006-05-09 23:45:00
67	6	2006-05-09 21:00:00	2006-05-09 23:45:00
67	135	2006-05-09 21:00:00	2006-05-09 23:45:00
67	8	2006-05-09 21:00:00	2006-05-09 23:45:00
67	14	2006-05-09 21:00:00	2006-05-09 23:45:00
67	15	2006-05-09 21:00:00	2006-05-09 23:45:00
67	21	2006-05-09 21:00:00	2006-05-09 23:45:00
67	96	2006-05-09 21:00:00	2006-05-09 23:45:00
67	25	2006-05-09 21:00:00	2006-05-09 23:45:00
67	27	2006-05-09 21:00:00	2006-05-09 23:45:00
67	29	2006-05-09 21:00:00	2006-05-09 23:45:00
67	30	2006-05-09 21:00:00	2006-05-09 23:45:00
67	31	2006-05-09 21:00:00	2006-05-09 23:45:00
67	32	2006-05-09 21:00:00	2006-05-09 23:45:00
67	33	2006-05-09 21:00:00	2006-05-09 23:45:00
67	35	2006-05-09 21:00:00	2006-05-09 23:45:00
67	36	2006-05-09 21:00:00	2006-05-09 23:45:00
67	38	2006-05-09 21:00:00	2006-05-09 23:45:00
67	39	2006-05-09 21:00:00	2006-05-09 23:45:00
67	40	2006-05-09 21:00:00	2006-05-09 23:45:00
67	41	2006-05-09 21:00:00	2006-05-09 23:45:00
67	42	2006-05-09 21:00:00	2006-05-09 23:45:00
67	43	2006-05-09 21:00:00	2006-05-09 23:45:00
67	45	2006-05-09 21:00:00	2006-05-09 23:45:00
67	46	2006-05-09 21:00:00	2006-05-09 23:45:00
67	106	2006-05-09 22:06:32	2006-05-09 23:45:00
67	48	2006-05-09 21:00:00	2006-05-09 23:45:00
67	49	2006-05-09 21:00:00	2006-05-09 23:45:00
67	50	2006-05-09 21:00:00	2006-05-09 23:45:00
67	100	2006-05-09 21:00:00	2006-05-09 23:45:00
67	103	2006-05-09 21:00:00	2006-05-09 23:45:00
67	51	2006-05-09 21:00:00	2006-05-09 23:45:00
67	52	2006-05-09 21:00:00	2006-05-09 22:06:26
67	61	2006-05-09 21:00:00	2006-05-09 23:45:00
67	141	2006-05-09 21:27:29	2006-05-09 23:45:00
67	55	2006-05-09 21:00:00	2006-05-09 23:45:00
67	58	2006-05-09 21:00:00	2006-05-09 23:45:00
67	57	2006-05-09 21:00:00	2006-05-09 23:45:00
67	59	2006-05-09 21:07:44	2006-05-09 21:26:33
67	60	2006-05-09 21:00:00	2006-05-09 23:45:00
68	1	2006-05-10 19:31:29	2006-05-10 21:20:00
68	6	2006-05-10 19:37:26	2006-05-10 21:20:00
68	156	2006-05-10 19:45:30	2006-05-10 21:20:00
68	102	2006-05-10 19:56:38	2006-05-10 21:20:00
68	8	2006-05-10 19:45:32	2006-05-10 21:20:00
68	90	2006-05-10 19:40:56	2006-05-10 21:20:00
68	14	2006-05-10 19:37:20	2006-05-10 21:20:00
68	15	2006-05-10 19:32:41	2006-05-10 21:20:00
68	21	2006-05-10 20:07:09	2006-05-10 21:20:00
68	96	2006-05-10 19:48:22	2006-05-10 21:20:00
68	157	2006-05-10 19:37:43	2006-05-10 21:20:00
68	24	2006-05-10 19:37:10	2006-05-10 21:20:00
68	25	2006-05-10 19:35:18	2006-05-10 21:20:00
68	26	2006-05-10 20:01:02	2006-05-10 21:17:53
68	27	2006-05-10 19:31:29	2006-05-10 21:20:00
68	28	2006-05-10 19:31:29	2006-05-10 19:54:24
68	98	2006-05-10 19:44:00	2006-05-10 21:18:41
68	30	2006-05-10 19:38:03	2006-05-10 21:20:00
68	32	2006-05-10 19:31:29	2006-05-10 21:20:00
68	33	2006-05-10 19:31:29	2006-05-10 21:20:00
68	82	2006-05-10 19:37:00	2006-05-10 21:20:00
68	136	2006-05-10 19:50:13	2006-05-10 21:20:00
68	35	2006-05-10 19:31:29	2006-05-10 21:20:00
68	36	2006-05-10 19:35:49	2006-05-10 21:20:00
68	38	2006-05-10 19:45:17	2006-05-10 21:20:00
68	39	2006-05-10 19:39:50	2006-05-10 21:20:00
68	42	2006-05-10 20:08:25	2006-05-10 21:20:00
68	43	2006-05-10 19:40:25	2006-05-10 21:20:00
68	46	2006-05-10 19:33:48	2006-05-10 21:20:00
68	106	2006-05-10 19:56:04	2006-05-10 21:20:00
68	50	2006-05-10 20:37:59	2006-05-10 21:20:00
68	100	2006-05-10 19:40:05	2006-05-10 21:20:00
68	51	2006-05-10 19:39:39	2006-05-10 21:20:00
68	116	2006-05-10 19:34:40	2006-05-10 21:20:00
68	61	2006-05-10 19:39:55	2006-05-10 21:19:04
68	107	2006-05-10 19:40:48	2006-05-10 21:20:00
68	76	2006-05-10 19:31:29	2006-05-10 20:41:05
68	58	2006-05-10 19:39:25	2006-05-10 21:20:00
68	57	2006-05-10 19:38:24	2006-05-10 21:20:00
68	56	2006-05-10 19:54:22	2006-05-10 21:20:00
68	60	2006-05-10 19:39:46	2006-05-10 21:20:00
70	1	2006-05-11 18:56:48	2006-05-11 22:04:43
70	5	2006-05-11 18:56:48	2006-05-11 22:10:40
70	6	2006-05-11 18:56:48	2006-05-11 22:10:40
70	8	2006-05-11 18:56:48	2006-05-11 22:10:40
70	16	2006-05-11 18:56:48	2006-05-11 22:10:40
70	19	2006-05-11 19:12:18	2006-05-11 22:10:40
70	24	2006-05-11 19:14:10	2006-05-11 22:10:40
70	26	2006-05-11 18:56:48	2006-05-11 22:10:40
70	27	2006-05-11 18:56:48	2006-05-11 22:10:40
70	28	2006-05-11 18:57:02	2006-05-11 22:10:40
70	32	2006-05-11 18:56:48	2006-05-11 22:10:40
70	33	2006-05-11 18:56:48	2006-05-11 22:10:40
70	82	2006-05-11 18:56:48	2006-05-11 22:10:40
70	136	2006-05-11 18:56:48	2006-05-11 20:35:58
70	35	2006-05-11 18:56:48	2006-05-11 21:27:22
70	41	2006-05-11 18:56:48	2006-05-11 22:10:40
70	62	2006-05-11 20:38:39	2006-05-11 22:10:40
70	48	2006-05-11 18:56:48	2006-05-11 22:10:40
70	49	2006-05-11 20:37:57	2006-05-11 22:10:40
70	51	2006-05-11 18:56:48	2006-05-11 22:10:40
70	89	2006-05-11 19:13:34	2006-05-11 22:10:40
70	58	2006-05-11 18:56:48	2006-05-11 22:10:40
71	2	2006-05-13 11:00:00	2006-05-13 15:48:32
71	4	2006-05-13 11:00:00	2006-05-13 15:38:10
71	5	2006-05-13 15:38:16	2006-05-13 17:15:00
71	8	2006-05-13 11:00:00	2006-05-13 17:15:00
71	16	2006-05-13 11:00:00	2006-05-13 17:15:00
71	157	2006-05-13 11:00:00	2006-05-13 11:21:18
71	25	2006-05-13 11:00:00	2006-05-13 17:15:00
71	26	2006-05-13 11:00:00	2006-05-13 17:15:00
71	27	2006-05-13 15:35:54	2006-05-13 17:15:00
71	30	2006-05-13 11:00:00	2006-05-13 17:15:00
71	32	2006-05-13 11:00:00	2006-05-13 15:39:41
71	136	2006-05-13 11:24:19	2006-05-13 17:15:00
71	35	2006-05-13 11:00:00	2006-05-13 17:15:00
71	36	2006-05-13 11:00:00	2006-05-13 17:15:00
71	38	2006-05-13 15:47:36	2006-05-13 17:15:00
71	120	2006-05-13 11:00:00	2006-05-13 15:34:55
71	40	2006-05-13 11:00:00	2006-05-13 17:15:00
51	2	2006-04-23 20:00:00	2006-04-23 23:00:00
51	97	2006-04-23 20:00:00	2006-04-23 23:00:00
51	4	2006-04-23 20:00:00	2006-04-23 23:00:00
51	6	2006-04-23 20:00:00	2006-04-23 22:23:23
51	7	2006-04-23 20:00:00	2006-04-23 23:00:00
51	8	2006-04-23 20:00:00	2006-04-23 23:00:00
51	14	2006-04-23 20:00:00	2006-04-23 23:00:00
51	15	2006-04-23 20:00:00	2006-04-23 23:00:00
51	16	2006-04-23 22:23:52	2006-04-23 23:00:00
51	19	2006-04-23 20:00:00	2006-04-23 23:00:00
51	21	2006-04-23 20:00:00	2006-04-23 23:00:00
51	96	2006-04-23 20:00:00	2006-04-23 23:00:00
51	24	2006-04-23 20:00:00	2006-04-23 23:00:00
51	25	2006-04-23 20:00:00	2006-04-23 23:00:00
51	27	2006-04-23 20:00:00	2006-04-23 23:00:00
51	28	2006-04-23 20:00:00	2006-04-23 23:00:00
51	30	2006-04-23 20:00:00	2006-04-23 23:00:00
51	35	2006-04-23 20:00:00	2006-04-23 23:00:00
51	36	2006-04-23 20:00:00	2006-04-23 23:00:00
51	39	2006-04-23 20:00:00	2006-04-23 23:00:00
51	40	2006-04-23 20:00:00	2006-04-23 22:15:05
51	121	2006-04-23 20:00:00	2006-04-23 23:00:00
51	42	2006-04-23 22:22:20	2006-04-23 23:00:00
51	43	2006-04-23 20:00:00	2006-04-23 23:00:00
51	71	2006-04-23 20:00:00	2006-04-23 23:00:00
51	62	2006-04-23 20:00:00	2006-04-23 23:00:00
51	45	2006-04-23 20:00:00	2006-04-23 23:00:00
51	46	2006-04-23 20:00:00	2006-04-23 23:00:00
51	106	2006-04-23 20:00:00	2006-04-23 23:00:00
51	48	2006-04-23 20:00:00	2006-04-23 23:00:00
51	49	2006-04-23 20:00:00	2006-04-23 23:00:00
51	50	2006-04-23 20:00:00	2006-04-23 23:00:00
51	67	2006-04-23 20:00:00	2006-04-23 23:00:00
51	103	2006-04-23 20:00:00	2006-04-23 23:00:00
51	51	2006-04-23 20:00:00	2006-04-23 23:00:00
51	52	2006-04-23 20:00:00	2006-04-23 23:00:00
51	61	2006-04-23 20:00:00	2006-04-23 23:00:00
51	54	2006-04-23 20:00:00	2006-04-23 23:00:00
51	55	2006-04-23 20:00:00	2006-04-23 23:00:00
51	58	2006-04-23 20:00:00	2006-04-23 23:00:00
51	57	2006-04-23 20:00:00	2006-04-23 23:00:00
51	59	2006-04-23 20:00:00	2006-04-23 23:00:00
51	60	2006-04-23 20:00:00	2006-04-23 23:00:00
51	82	2006-04-23 20:00:00	2006-04-23 23:00:00
51	124	2006-04-23 20:00:00	2006-04-23 23:00:00
51	90	2006-04-23 20:00:00	2006-04-23 23:00:00
51	32	2006-04-23 20:00:00	2006-04-23 23:00:00
51	1	2006-04-23 20:00:00	2006-04-23 23:00:00
71	41	2006-05-13 11:00:00	2006-05-13 16:32:09
71	44	2006-05-13 11:00:00	2006-05-13 17:15:00
71	48	2006-05-13 11:00:00	2006-05-13 17:15:00
71	100	2006-05-13 15:02:14	2006-05-13 17:15:00
71	103	2006-05-13 16:29:19	2006-05-13 17:15:00
71	51	2006-05-13 11:00:00	2006-05-13 17:15:00
71	115	2006-05-13 11:00:00	2006-05-13 17:15:00
71	61	2006-05-13 11:00:00	2006-05-13 15:05:25
71	54	2006-05-13 11:00:00	2006-05-13 17:15:00
71	58	2006-05-13 15:05:52	2006-05-13 17:15:00
71	57	2006-05-13 11:00:00	2006-05-13 17:15:00
81	31	2006-05-22 19:30:00	2006-05-22 20:44:00
81	164	2006-05-22 20:01:01	2006-05-22 20:44:00
81	32	2006-05-22 19:30:00	2006-05-22 20:44:00
81	33	2006-05-22 19:30:00	2006-05-22 20:44:00
81	82	2006-05-22 19:32:22	2006-05-22 20:44:00
81	136	2006-05-22 19:32:16	2006-05-22 20:44:00
81	35	2006-05-22 19:30:00	2006-05-22 20:44:00
81	36	2006-05-22 19:30:00	2006-05-22 20:44:00
81	81	2006-05-22 19:30:00	2006-05-22 20:44:00
81	41	2006-05-22 19:30:00	2006-05-22 20:44:00
81	42	2006-05-22 19:34:12	2006-05-22 20:44:00
81	43	2006-05-22 19:30:00	2006-05-22 20:44:00
81	62	2006-05-22 20:02:11	2006-05-22 20:44:00
81	44	2006-05-22 19:58:00	2006-05-22 20:44:00
81	45	2006-05-22 19:30:00	2006-05-22 20:44:00
81	48	2006-05-22 19:30:00	2006-05-22 20:44:00
81	51	2006-05-22 19:30:00	2006-05-22 20:44:00
81	52	2006-05-22 19:30:00	2006-05-22 20:44:00
81	116	2006-05-22 19:42:52	2006-05-22 20:44:00
81	54	2006-05-22 19:30:00	2006-05-22 20:44:00
81	55	2006-05-22 19:30:00	2006-05-22 20:44:00
81	58	2006-05-22 19:30:00	2006-05-22 20:44:00
81	57	2006-05-22 19:30:00	2006-05-22 20:44:00
81	59	2006-05-22 19:44:49	2006-05-22 20:44:00
81	60	2006-05-22 19:30:00	2006-05-22 20:44:00
31	157	2006-04-08 14:38:29	2006-04-08 15:00:00
32	157	2006-04-08 20:18:46	2006-04-08 20:45:00
35	157	2006-04-10 21:15:00	2006-04-10 23:00:00
38	157	2006-04-15 11:00:00	2006-04-15 15:30:00
73	2	2006-05-13 19:04:03	2006-05-13 20:00:00
73	97	2006-05-13 19:03:06	2006-05-13 20:00:00
73	5	2006-05-13 19:03:06	2006-05-13 20:00:00
73	6	2006-05-13 19:03:06	2006-05-13 20:00:00
73	8	2006-05-13 19:03:06	2006-05-13 20:00:00
73	14	2006-05-13 19:03:06	2006-05-13 20:00:00
73	15	2006-05-13 19:03:06	2006-05-13 20:00:00
73	19	2006-05-13 19:03:06	2006-05-13 20:00:00
73	96	2006-05-13 19:03:06	2006-05-13 20:00:00
73	157	2006-05-13 19:03:06	2006-05-13 20:00:00
73	24	2006-05-13 19:03:06	2006-05-13 20:00:00
73	26	2006-05-13 19:03:06	2006-05-13 20:00:00
73	64	2006-05-13 19:03:06	2006-05-13 20:00:00
73	27	2006-05-13 19:03:06	2006-05-13 20:00:00
73	31	2006-05-13 19:03:06	2006-05-13 20:00:00
73	154	2006-05-13 19:03:06	2006-05-13 20:00:00
73	136	2006-05-13 19:03:06	2006-05-13 20:00:00
73	35	2006-05-13 19:03:06	2006-05-13 20:00:00
73	158	2006-05-13 19:03:06	2006-05-13 20:00:00
73	155	2006-05-13 19:03:06	2006-05-13 20:00:00
73	40	2006-05-13 19:03:06	2006-05-13 20:00:00
73	41	2006-05-13 19:03:06	2006-05-13 20:00:00
73	42	2006-05-13 19:04:44	2006-05-13 20:00:00
73	46	2006-05-13 19:06:03	2006-05-13 20:00:00
73	48	2006-05-13 19:03:06	2006-05-13 20:00:00
73	159	2006-05-13 19:03:06	2006-05-13 20:00:00
73	144	2006-05-13 19:03:06	2006-05-13 20:00:00
73	49	2006-05-13 19:03:06	2006-05-13 20:00:00
73	100	2006-05-13 19:03:06	2006-05-13 20:00:00
73	103	2006-05-13 19:03:06	2006-05-13 20:00:00
73	52	2006-05-13 19:03:06	2006-05-13 20:00:00
73	115	2006-05-13 19:03:06	2006-05-13 20:00:00
73	116	2006-05-13 19:03:06	2006-05-13 20:00:00
73	107	2006-05-13 19:03:06	2006-05-13 20:00:00
73	160	2006-05-13 19:03:06	2006-05-13 20:00:00
73	89	2006-05-13 19:03:06	2006-05-13 20:00:00
73	58	2006-05-13 19:03:06	2006-05-13 20:00:00
73	56	2006-05-13 19:03:06	2006-05-13 20:00:00
73	59	2006-05-13 19:03:06	2006-05-13 20:00:00
73	60	2006-05-13 19:03:06	2006-05-13 20:00:00
76	1	2006-05-17 21:00:00	2006-05-18 00:00:00
76	2	2006-05-17 21:00:00	2006-05-17 23:17:02
76	97	2006-05-17 21:00:00	2006-05-18 00:00:00
76	5	2006-05-17 21:00:00	2006-05-18 00:00:00
76	6	2006-05-17 21:00:00	2006-05-18 00:00:00
76	156	2006-05-17 21:02:00	2006-05-17 23:29:01
76	135	2006-05-17 23:35:25	2006-05-18 00:00:00
76	102	2006-05-17 21:02:23	2006-05-18 00:00:00
76	8	2006-05-17 21:00:00	2006-05-18 00:00:00
76	90	2006-05-17 21:00:24	2006-05-18 00:00:00
76	15	2006-05-17 21:00:00	2006-05-18 00:00:00
76	16	2006-05-17 23:33:58	2006-05-18 00:00:00
76	123	2006-05-17 21:01:17	2006-05-17 23:16:08
76	96	2006-05-17 21:00:00	2006-05-18 00:00:00
76	157	2006-05-17 21:10:40	2006-05-17 23:17:07
76	161	2006-05-17 21:00:00	2006-05-17 23:13:23
76	27	2006-05-17 21:00:00	2006-05-18 00:00:00
76	28	2006-05-17 21:00:00	2006-05-18 00:00:00
76	98	2006-05-17 21:00:00	2006-05-18 00:00:00
76	30	2006-05-17 21:00:00	2006-05-18 00:00:00
76	32	2006-05-17 21:00:00	2006-05-18 00:00:00
76	33	2006-05-17 21:00:00	2006-05-18 00:00:00
76	82	2006-05-17 21:00:00	2006-05-18 00:00:00
76	136	2006-05-17 21:00:00	2006-05-18 00:00:00
76	35	2006-05-17 21:00:00	2006-05-18 00:00:00
76	39	2006-05-17 21:15:21	2006-05-17 23:17:05
76	40	2006-05-17 21:00:00	2006-05-18 00:00:00
76	41	2006-05-17 21:00:00	2006-05-18 00:00:00
76	43	2006-05-17 21:00:00	2006-05-18 00:00:00
76	106	2006-05-17 21:00:00	2006-05-18 00:00:00
76	162	2006-05-17 21:00:00	2006-05-17 23:15:45
76	48	2006-05-17 21:00:00	2006-05-17 21:00:31
76	144	2006-05-17 21:00:00	2006-05-18 00:00:00
76	49	2006-05-17 23:16:09	2006-05-18 00:00:00
76	50	2006-05-17 21:00:00	2006-05-18 00:00:00
76	100	2006-05-17 21:00:00	2006-05-18 00:00:00
76	103	2006-05-17 21:00:00	2006-05-18 00:00:00
76	51	2006-05-17 21:00:00	2006-05-18 00:00:00
76	116	2006-05-17 21:00:00	2006-05-18 00:00:00
76	61	2006-05-17 21:00:00	2006-05-18 00:00:00
76	107	2006-05-17 21:00:00	2006-05-18 00:00:00
76	76	2006-05-17 21:00:00	2006-05-18 00:00:00
76	141	2006-05-17 21:00:00	2006-05-17 23:13:41
76	55	2006-05-17 21:00:00	2006-05-18 00:00:00
76	60	2006-05-17 21:00:00	2006-05-18 00:00:00
84	1	2006-05-22 20:45:12	2006-05-22 22:22:03
84	5	2006-05-22 20:45:12	2006-05-22 22:22:03
84	6	2006-05-22 20:45:12	2006-05-22 22:22:03
84	14	2006-05-22 20:45:12	2006-05-22 22:22:03
84	15	2006-05-22 20:45:12	2006-05-22 22:22:03
84	16	2006-05-22 20:45:12	2006-05-22 22:22:03
84	19	2006-05-22 20:45:12	2006-05-22 22:22:03
84	21	2006-05-22 20:45:12	2006-05-22 22:22:03
84	96	2006-05-22 20:45:12	2006-05-22 22:22:03
84	27	2006-05-22 20:45:12	2006-05-22 22:22:03
84	28	2006-05-22 20:45:12	2006-05-22 22:22:03
84	31	2006-05-22 20:45:12	2006-05-22 22:22:03
84	164	2006-05-22 20:45:12	2006-05-22 22:22:03
84	32	2006-05-22 20:45:12	2006-05-22 22:22:03
84	33	2006-05-22 20:45:12	2006-05-22 22:22:03
84	82	2006-05-22 20:45:12	2006-05-22 22:22:03
84	136	2006-05-22 20:45:12	2006-05-22 22:22:03
84	35	2006-05-22 20:45:12	2006-05-22 22:22:03
84	36	2006-05-22 20:45:12	2006-05-22 22:22:03
84	39	2006-05-22 20:45:12	2006-05-22 22:22:03
84	81	2006-05-22 20:45:12	2006-05-22 20:45:29
84	41	2006-05-22 20:45:12	2006-05-22 22:22:03
84	42	2006-05-22 20:45:12	2006-05-22 20:55:42
84	43	2006-05-22 20:45:12	2006-05-22 22:22:03
84	62	2006-05-22 20:45:12	2006-05-22 22:22:03
84	44	2006-05-22 20:45:12	2006-05-22 20:45:48
84	45	2006-05-22 20:45:12	2006-05-22 22:22:03
84	142	2006-05-22 21:00:22	2006-05-22 22:22:03
84	48	2006-05-22 20:45:12	2006-05-22 22:22:03
84	49	2006-05-22 20:45:12	2006-05-22 22:22:03
84	51	2006-05-22 20:45:12	2006-05-22 22:22:03
84	52	2006-05-22 20:45:12	2006-05-22 22:22:03
84	116	2006-05-22 20:45:12	2006-05-22 22:22:03
84	160	2006-05-22 20:50:45	2006-05-22 22:22:03
84	54	2006-05-22 20:45:12	2006-05-22 22:22:03
84	125	2006-05-22 21:36:48	2006-05-22 22:22:03
84	76	2006-05-22 20:48:56	2006-05-22 22:22:03
84	55	2006-05-22 20:45:12	2006-05-22 22:22:03
84	58	2006-05-22 20:45:12	2006-05-22 22:22:03
84	57	2006-05-22 20:45:12	2006-05-22 22:22:03
84	59	2006-05-22 20:45:12	2006-05-22 22:21:35
84	166	2006-05-22 20:56:54	2006-05-22 22:22:03
84	60	2006-05-22 20:45:12	2006-05-22 22:22:03
46	157	2006-04-22 11:00:00	2006-04-22 15:00:00
55	157	2006-04-29 11:00:00	2006-04-29 14:40:00
59	157	2006-05-03 21:00:00	2006-05-03 21:30:00
60	157	2006-05-03 23:10:05	2006-05-04 00:12:00
63	157	2006-05-06 19:00:00	2006-05-06 20:00:00
77	1	2006-05-18 19:00:00	2006-05-18 23:20:32
77	97	2006-05-18 19:00:00	2006-05-18 23:20:32
77	4	2006-05-18 19:00:00	2006-05-18 23:20:32
77	5	2006-05-18 19:00:00	2006-05-18 23:20:32
77	6	2006-05-18 19:14:35	2006-05-18 21:01:25
77	15	2006-05-18 19:54:43	2006-05-18 23:20:32
77	16	2006-05-18 19:00:00	2006-05-18 23:20:32
77	26	2006-05-18 19:00:00	2006-05-18 23:20:32
77	27	2006-05-18 19:00:00	2006-05-18 23:20:32
77	30	2006-05-18 19:00:00	2006-05-18 23:20:32
77	31	2006-05-18 21:02:24	2006-05-18 22:45:07
77	32	2006-05-18 19:00:00	2006-05-18 23:20:32
77	33	2006-05-18 19:00:00	2006-05-18 23:20:32
77	136	2006-05-18 19:00:00	2006-05-18 23:20:32
77	35	2006-05-18 19:00:00	2006-05-18 23:20:32
77	41	2006-05-18 19:00:00	2006-05-18 23:20:32
77	43	2006-05-18 19:00:00	2006-05-18 23:20:32
77	62	2006-05-18 21:03:10	2006-05-18 23:20:32
77	45	2006-05-18 19:00:00	2006-05-18 23:20:32
77	48	2006-05-18 19:00:00	2006-05-18 23:20:32
77	51	2006-05-18 19:01:47	2006-05-18 21:00:28
77	61	2006-05-18 19:00:00	2006-05-18 19:49:19
77	163	2006-05-18 19:00:00	2006-05-18 19:54:14
77	60	2006-05-18 19:51:40	2006-05-18 23:20:32
89	6	2006-05-28 00:00:00	2006-05-28 01:15:00
89	135	2006-05-28 00:00:00	2006-05-28 01:15:00
89	57	2006-05-28 00:00:00	2006-05-28 01:15:00
89	107	2006-05-28 00:00:00	2006-05-28 01:15:00
89	31	2006-05-28 00:00:00	2006-05-28 01:15:00
89	2	2006-05-28 00:00:00	2006-05-28 01:15:00
89	33	2006-05-28 00:00:00	2006-05-28 01:15:00
89	100	2006-05-28 00:00:00	2006-05-28 01:15:00
83	1	2006-05-23 20:00:00	2006-05-23 23:14:02
83	2	2006-05-23 20:00:00	2006-05-23 21:52:44
83	4	2006-05-23 20:00:00	2006-05-23 23:14:02
83	5	2006-05-23 20:00:00	2006-05-23 23:14:02
83	6	2006-05-23 20:00:00	2006-05-23 23:14:02
83	7	2006-05-23 20:00:00	2006-05-23 23:14:02
83	135	2006-05-23 20:00:00	2006-05-23 23:14:02
83	14	2006-05-23 20:00:00	2006-05-23 23:14:02
83	15	2006-05-23 20:00:00	2006-05-23 23:14:02
83	16	2006-05-23 21:53:32	2006-05-23 23:14:02
83	19	2006-05-23 20:00:00	2006-05-23 23:14:02
83	21	2006-05-23 20:00:00	2006-05-23 23:14:02
83	96	2006-05-23 20:00:00	2006-05-23 23:14:02
83	23	2006-05-23 20:00:00	2006-05-23 23:14:02
83	24	2006-05-23 20:00:00	2006-05-23 20:57:29
83	27	2006-05-23 20:00:00	2006-05-23 23:14:02
83	28	2006-05-23 20:00:00	2006-05-23 23:14:02
83	29	2006-05-23 20:58:32	2006-05-23 23:14:02
83	31	2006-05-23 20:00:00	2006-05-23 20:34:48
83	32	2006-05-23 20:00:00	2006-05-23 23:14:02
83	33	2006-05-23 20:00:00	2006-05-23 23:14:02
83	136	2006-05-23 20:00:00	2006-05-23 23:14:02
83	35	2006-05-23 20:00:00	2006-05-23 23:14:02
83	36	2006-05-23 20:00:00	2006-05-23 23:14:02
83	38	2006-05-23 21:02:11	2006-05-23 23:14:02
83	39	2006-05-23 20:00:00	2006-05-23 23:14:02
83	40	2006-05-23 20:00:00	2006-05-23 20:58:33
83	81	2006-05-23 20:00:00	2006-05-23 23:14:02
83	41	2006-05-23 20:00:00	2006-05-23 23:14:02
83	42	2006-05-23 20:00:00	2006-05-23 23:14:02
83	45	2006-05-23 20:00:00	2006-05-23 23:14:02
83	48	2006-05-23 20:00:00	2006-05-23 23:14:02
83	49	2006-05-23 20:38:18	2006-05-23 23:14:02
83	50	2006-05-23 20:05:18	2006-05-23 23:14:02
83	100	2006-05-23 20:00:00	2006-05-23 22:53:56
83	103	2006-05-23 20:00:00	2006-05-23 23:14:02
83	51	2006-05-23 20:00:00	2006-05-23 23:14:02
83	52	2006-05-23 20:00:00	2006-05-23 23:14:02
83	116	2006-05-23 20:00:00	2006-05-23 23:14:02
83	141	2006-05-23 20:00:00	2006-05-23 23:14:02
83	55	2006-05-23 20:00:00	2006-05-23 23:14:02
83	58	2006-05-23 20:00:00	2006-05-23 23:14:02
83	57	2006-05-23 20:00:00	2006-05-23 23:14:02
83	60	2006-05-23 20:00:00	2006-05-23 23:14:02
78	1	2006-05-20 14:01:20	2006-05-20 16:31:11
78	97	2006-05-20 15:46:48	2006-05-20 16:31:11
78	5	2006-05-20 14:01:20	2006-05-20 16:31:11
78	6	2006-05-20 14:01:20	2006-05-20 16:30:19
78	135	2006-05-20 14:01:20	2006-05-20 16:31:11
78	8	2006-05-20 14:01:20	2006-05-20 16:29:51
78	21	2006-05-20 14:02:07	2006-05-20 16:31:11
78	164	2006-05-20 14:01:20	2006-05-20 16:31:11
78	32	2006-05-20 14:01:20	2006-05-20 16:31:11
78	35	2006-05-20 14:01:20	2006-05-20 16:31:11
78	36	2006-05-20 14:01:20	2006-05-20 16:31:03
78	38	2006-05-20 14:01:20	2006-05-20 16:31:11
78	41	2006-05-20 14:01:20	2006-05-20 16:31:11
78	142	2006-05-20 14:01:20	2006-05-20 16:31:06
78	48	2006-05-20 14:01:20	2006-05-20 16:31:11
78	100	2006-05-20 14:01:20	2006-05-20 16:31:11
78	51	2006-05-20 14:01:20	2006-05-20 15:47:33
78	115	2006-05-20 14:01:20	2006-05-20 16:31:11
78	109	2006-05-20 14:01:20	2006-05-20 16:30:16
78	54	2006-05-20 14:01:20	2006-05-20 16:31:11
78	60	2006-05-20 14:01:20	2006-05-20 16:31:11
89	15	2006-05-28 00:00:00	2006-05-28 01:15:00
89	8	2006-05-28 00:00:00	2006-05-28 01:15:00
89	45	2006-05-28 00:00:00	2006-05-28 01:15:00
89	116	2006-05-28 00:00:00	2006-05-28 01:15:00
89	160	2006-05-28 00:00:00	2006-05-28 01:15:00
89	51	2006-05-28 00:00:00	2006-05-28 01:15:00
89	19	2006-05-28 00:00:00	2006-05-28 01:15:00
89	52	2006-05-28 00:00:00	2006-05-28 01:15:00
89	41	2006-05-28 00:00:00	2006-05-28 01:15:00
89	109	2006-05-28 00:00:00	2006-05-28 01:15:00
89	96	2006-05-28 00:00:00	2006-05-28 01:15:00
89	136	2006-05-28 00:00:00	2006-05-28 01:15:00
79	1	2006-05-20 10:00:00	2006-05-20 12:45:53
79	2	2006-05-20 10:00:00	2006-05-20 12:45:53
79	4	2006-05-20 10:00:00	2006-05-20 12:39:48
79	5	2006-05-20 10:00:00	2006-05-20 12:45:53
79	135	2006-05-20 10:00:00	2006-05-20 12:45:53
79	8	2006-05-20 10:00:00	2006-05-20 12:45:53
79	32	2006-05-20 10:00:00	2006-05-20 12:45:53
79	35	2006-05-20 10:00:00	2006-05-20 12:42:13
79	36	2006-05-20 10:00:00	2006-05-20 12:45:53
79	39	2006-05-20 10:00:00	2006-05-20 12:45:53
79	81	2006-05-20 10:00:00	2006-05-20 12:45:53
79	41	2006-05-20 10:00:00	2006-05-20 12:45:53
79	44	2006-05-20 10:00:00	2006-05-20 12:45:53
79	142	2006-05-20 10:49:04	2006-05-20 12:45:53
79	48	2006-05-20 10:00:00	2006-05-20 12:45:53
79	51	2006-05-20 10:00:00	2006-05-20 12:43:14
79	115	2006-05-20 10:00:00	2006-05-20 10:29:32
79	61	2006-05-20 10:00:00	2006-05-20 12:39:52
79	160	2006-05-20 10:13:24	2006-05-20 12:41:48
79	117	2006-05-20 12:45:48	2006-05-20 12:45:53
79	54	2006-05-20 10:00:00	2006-05-20 12:45:53
85	2	2006-05-26 21:00:00	2006-05-26 23:09:31
85	6	2006-05-26 23:44:56	2006-05-27 00:00:00
85	8	2006-05-26 21:00:00	2006-05-27 00:00:00
85	14	2006-05-26 21:00:00	2006-05-26 23:40:09
85	16	2006-05-26 21:00:00	2006-05-27 00:00:00
85	27	2006-05-26 21:00:00	2006-05-27 00:00:00
85	28	2006-05-26 21:00:00	2006-05-27 00:00:00
85	30	2006-05-26 21:00:00	2006-05-27 00:00:00
85	164	2006-05-26 21:00:00	2006-05-27 00:00:00
85	33	2006-05-26 21:00:00	2006-05-27 00:00:00
85	136	2006-05-26 21:00:00	2006-05-27 00:00:00
85	36	2006-05-26 21:00:00	2006-05-27 00:00:00
85	39	2006-05-26 23:14:04	2006-05-27 00:00:00
85	129	2006-05-26 21:00:00	2006-05-27 00:00:00
85	44	2006-05-26 21:00:00	2006-05-27 00:00:00
85	48	2006-05-26 21:00:00	2006-05-27 00:00:00
85	100	2006-05-26 21:00:00	2006-05-27 00:00:00
85	51	2006-05-26 21:00:00	2006-05-27 00:00:00
85	115	2006-05-26 21:00:00	2006-05-27 00:00:00
85	109	2006-05-26 21:00:00	2006-05-27 00:00:00
85	107	2006-05-26 21:00:00	2006-05-27 00:00:00
85	167	2006-05-26 21:00:00	2006-05-27 00:00:00
75	1	2006-05-15 20:00:00	2006-05-15 23:30:00
75	2	2006-05-15 20:00:00	2006-05-15 23:30:00
75	97	2006-05-15 20:00:00	2006-05-15 23:30:00
75	4	2006-05-15 20:00:00	2006-05-15 23:30:00
75	5	2006-05-15 20:00:00	2006-05-15 23:30:00
75	6	2006-05-15 20:00:00	2006-05-15 23:30:00
75	135	2006-05-15 20:00:00	2006-05-15 23:30:00
75	8	2006-05-15 20:00:00	2006-05-15 23:30:00
75	14	2006-05-15 20:00:00	2006-05-15 23:30:00
75	15	2006-05-15 20:00:00	2006-05-15 23:30:00
75	16	2006-05-15 20:00:00	2006-05-15 23:30:00
75	19	2006-05-15 20:00:00	2006-05-15 23:30:00
75	96	2006-05-15 20:00:00	2006-05-15 23:30:00
75	23	2006-05-15 20:00:00	2006-05-15 23:30:00
75	24	2006-05-15 20:00:00	2006-05-15 23:30:00
75	161	2006-05-15 20:00:00	2006-05-15 23:30:00
75	26	2006-05-15 20:00:00	2006-05-15 23:30:00
75	27	2006-05-15 20:00:00	2006-05-15 23:30:00
75	28	2006-05-15 20:00:00	2006-05-15 23:30:00
75	29	2006-05-15 20:00:00	2006-05-15 23:30:00
75	30	2006-05-15 20:00:00	2006-05-15 23:30:00
75	31	2006-05-15 20:00:00	2006-05-15 23:30:00
75	32	2006-05-15 20:00:00	2006-05-15 23:30:00
75	33	2006-05-15 20:00:00	2006-05-15 23:30:00
75	136	2006-05-15 20:00:00	2006-05-15 23:30:00
75	35	2006-05-15 20:00:00	2006-05-15 23:30:00
75	36	2006-05-15 20:00:00	2006-05-15 23:30:00
75	39	2006-05-15 20:00:00	2006-05-15 23:30:00
75	81	2006-05-15 20:00:00	2006-05-15 23:30:00
75	41	2006-05-15 20:00:00	2006-05-15 23:30:00
75	42	2006-05-15 20:00:00	2006-05-15 23:30:00
75	43	2006-05-15 20:00:00	2006-05-15 23:30:00
75	45	2006-05-15 20:00:00	2006-05-15 23:30:00
75	106	2006-05-15 20:00:00	2006-05-15 23:30:00
75	48	2006-05-15 20:00:00	2006-05-15 23:30:00
75	67	2006-05-15 20:00:00	2006-05-15 23:30:00
75	100	2006-05-15 20:00:00	2006-05-15 23:30:00
75	51	2006-05-15 20:00:00	2006-05-15 23:30:00
75	52	2006-05-15 20:00:00	2006-05-15 23:30:00
75	116	2006-05-15 20:00:00	2006-05-15 23:30:00
75	61	2006-05-15 20:00:00	2006-05-15 23:30:00
75	107	2006-05-15 20:00:00	2006-05-15 23:30:00
75	55	2006-05-15 20:00:00	2006-05-15 23:30:00
75	58	2006-05-15 20:00:00	2006-05-15 23:30:00
75	57	2006-05-15 20:00:00	2006-05-15 23:30:00
75	59	2006-05-15 20:00:00	2006-05-15 23:30:00
75	60	2006-05-15 20:00:00	2006-05-15 23:30:00
74	2	2006-05-14 19:30:00	2006-05-14 23:15:00
74	97	2006-05-14 19:30:00	2006-05-14 23:15:00
74	4	2006-05-14 19:30:00	2006-05-14 23:15:00
74	6	2006-05-14 19:30:00	2006-05-14 23:15:00
74	7	2006-05-14 19:30:00	2006-05-14 23:15:00
74	8	2006-05-14 19:30:00	2006-05-14 23:15:00
74	14	2006-05-14 19:30:00	2006-05-14 23:15:00
74	15	2006-05-14 19:30:00	2006-05-14 23:15:00
74	16	2006-05-14 19:30:00	2006-05-14 23:15:00
74	19	2006-05-14 19:30:00	2006-05-14 23:15:00
74	96	2006-05-14 19:30:00	2006-05-14 23:15:00
74	24	2006-05-14 19:30:00	2006-05-14 23:15:00
74	26	2006-05-14 19:30:00	2006-05-14 22:10:15
74	27	2006-05-14 19:30:00	2006-05-14 23:15:00
74	28	2006-05-14 19:30:00	2006-05-14 23:15:00
74	29	2006-05-14 22:25:53	2006-05-14 23:15:00
74	31	2006-05-14 22:43:39	2006-05-14 23:15:00
74	33	2006-05-14 19:30:00	2006-05-14 23:15:00
74	35	2006-05-14 19:30:00	2006-05-14 23:15:00
74	36	2006-05-14 19:31:20	2006-05-14 23:15:00
74	39	2006-05-14 19:30:00	2006-05-14 23:15:00
74	81	2006-05-14 19:30:00	2006-05-14 23:15:00
74	42	2006-05-14 22:00:28	2006-05-14 23:15:00
74	43	2006-05-14 19:30:00	2006-05-14 23:15:00
74	62	2006-05-14 19:30:00	2006-05-14 22:23:37
74	129	2006-05-14 19:30:00	2006-05-14 22:31:20
74	44	2006-05-14 19:30:00	2006-05-14 23:15:00
74	45	2006-05-14 19:30:00	2006-05-14 23:15:00
74	106	2006-05-14 19:30:00	2006-05-14 23:15:00
74	48	2006-05-14 19:30:00	2006-05-14 23:15:00
74	144	2006-05-14 19:30:00	2006-05-14 23:15:00
74	49	2006-05-14 19:30:00	2006-05-14 23:15:00
74	50	2006-05-14 19:48:40	2006-05-14 23:15:00
74	67	2006-05-14 19:30:00	2006-05-14 23:15:00
74	100	2006-05-14 19:30:00	2006-05-14 23:15:00
74	103	2006-05-14 19:30:00	2006-05-14 23:15:00
74	51	2006-05-14 22:34:30	2006-05-14 23:15:00
74	52	2006-05-14 19:30:00	2006-05-14 23:15:00
74	115	2006-05-14 19:30:00	2006-05-14 23:15:00
74	89	2006-05-14 19:30:00	2006-05-14 23:15:00
74	76	2006-05-14 19:30:00	2006-05-14 22:42:38
74	141	2006-05-14 19:30:00	2006-05-14 23:15:00
74	63	2006-05-14 19:30:00	2006-05-14 21:59:24
74	58	2006-05-14 19:30:00	2006-05-14 23:15:00
74	57	2006-05-14 19:30:00	2006-05-14 23:15:00
74	59	2006-05-14 19:30:00	2006-05-14 23:15:00
74	60	2006-05-14 19:30:00	2006-05-14 23:15:00
82	1	2006-05-20 18:10:40	2006-05-20 19:30:17
82	2	2006-05-20 18:00:19	2006-05-20 19:30:17
82	97	2006-05-20 18:00:00	2006-05-20 19:30:17
82	5	2006-05-20 18:00:00	2006-05-20 19:21:07
82	6	2006-05-20 18:00:00	2006-05-20 19:22:36
82	135	2006-05-20 18:02:40	2006-05-20 19:30:17
82	102	2006-05-20 18:00:00	2006-05-20 19:30:17
82	8	2006-05-20 18:00:00	2006-05-20 19:22:55
82	14	2006-05-20 18:00:00	2006-05-20 19:22:27
82	23	2006-05-20 18:10:03	2006-05-20 19:30:17
82	157	2006-05-20 18:00:00	2006-05-20 19:30:17
82	27	2006-05-20 18:00:00	2006-05-20 19:19:42
82	98	2006-05-20 18:00:00	2006-05-20 19:21:00
82	32	2006-05-20 18:00:00	2006-05-20 19:30:17
82	154	2006-05-20 18:59:54	2006-05-20 19:30:17
82	35	2006-05-20 18:00:00	2006-05-20 19:30:17
82	155	2006-05-20 18:00:00	2006-05-20 19:30:17
82	120	2006-05-20 18:00:00	2006-05-20 18:04:29
82	44	2006-05-20 18:00:00	2006-05-20 19:30:17
82	48	2006-05-20 18:00:00	2006-05-20 19:23:16
82	159	2006-05-20 18:00:00	2006-05-20 19:30:17
82	144	2006-05-20 18:00:00	2006-05-20 19:23:14
82	67	2006-05-20 18:05:23	2006-05-20 19:30:17
82	100	2006-05-20 18:00:00	2006-05-20 19:30:17
82	103	2006-05-20 18:00:00	2006-05-20 19:22:39
82	165	2006-05-20 18:00:00	2006-05-20 19:30:17
82	115	2006-05-20 18:00:00	2006-05-20 19:23:09
82	109	2006-05-20 18:12:50	2006-05-20 19:30:17
82	160	2006-05-20 18:10:39	2006-05-20 19:30:17
82	141	2006-05-20 18:21:47	2006-05-20 19:30:17
82	85	2006-05-20 18:00:00	2006-05-20 18:12:07
82	59	2006-05-20 18:00:00	2006-05-20 19:30:17
82	60	2006-05-20 18:00:00	2006-05-20 19:30:17
80	2	2006-05-21 19:30:00	2006-05-21 23:34:04
80	97	2006-05-21 19:30:00	2006-05-21 22:02:30
80	4	2006-05-21 19:34:59	2006-05-21 23:34:04
80	5	2006-05-21 19:30:00	2006-05-21 23:34:04
80	6	2006-05-21 19:30:00	2006-05-21 23:34:04
80	135	2006-05-21 19:30:00	2006-05-21 23:34:04
80	8	2006-05-21 21:20:21	2006-05-21 23:34:04
80	14	2006-05-21 19:30:00	2006-05-21 23:34:04
80	21	2006-05-21 19:30:00	2006-05-21 23:34:04
80	161	2006-05-21 19:30:00	2006-05-21 21:20:13
80	27	2006-05-21 19:30:00	2006-05-21 23:33:48
80	28	2006-05-21 19:30:00	2006-05-21 23:34:04
80	98	2006-05-21 19:30:00	2006-05-21 22:42:10
80	29	2006-05-21 22:16:48	2006-05-21 23:34:04
80	31	2006-05-21 19:30:00	2006-05-21 23:34:04
80	82	2006-05-21 19:30:00	2006-05-21 23:34:04
80	35	2006-05-21 19:30:00	2006-05-21 23:34:04
80	39	2006-05-21 19:30:00	2006-05-21 23:34:04
80	81	2006-05-21 19:30:00	2006-05-21 21:14:41
80	42	2006-05-21 22:40:54	2006-05-21 23:34:04
80	43	2006-05-21 21:43:25	2006-05-21 23:34:04
80	44	2006-05-21 19:30:00	2006-05-21 23:34:04
80	45	2006-05-21 19:48:22	2006-05-21 23:34:04
80	142	2006-05-21 19:30:00	2006-05-21 23:34:04
80	106	2006-05-21 19:30:00	2006-05-21 23:34:04
80	48	2006-05-21 19:30:00	2006-05-21 23:34:04
80	49	2006-05-21 19:30:00	2006-05-21 23:34:04
80	50	2006-05-21 19:30:00	2006-05-21 23:34:04
80	67	2006-05-21 19:30:00	2006-05-21 23:34:04
80	100	2006-05-21 19:30:00	2006-05-21 23:34:04
80	103	2006-05-21 19:30:00	2006-05-21 23:34:04
80	51	2006-05-21 19:30:00	2006-05-21 23:34:04
80	52	2006-05-21 19:30:00	2006-05-21 23:34:04
80	115	2006-05-21 21:14:54	2006-05-21 23:34:04
80	116	2006-05-21 19:30:00	2006-05-21 23:34:04
80	61	2006-05-21 19:30:00	2006-05-21 21:42:26
80	107	2006-05-21 19:30:00	2006-05-21 23:34:04
80	54	2006-05-21 19:30:00	2006-05-21 23:34:04
80	89	2006-05-21 19:30:00	2006-05-21 23:34:04
80	76	2006-05-21 21:51:30	2006-05-21 23:34:04
80	141	2006-05-21 19:30:00	2006-05-21 23:34:04
80	63	2006-05-21 19:30:00	2006-05-21 22:40:48
80	58	2006-05-21 19:30:00	2006-05-21 23:34:04
80	57	2006-05-21 19:30:00	2006-05-21 23:34:04
80	59	2006-05-21 19:30:00	2006-05-21 23:34:04
80	60	2006-05-21 19:30:00	2006-05-21 23:34:04
88	1	2006-05-29 20:00:00	2006-05-29 23:50:00
88	2	2006-05-29 20:00:00	2006-05-29 20:07:56
88	97	2006-05-29 20:00:00	2006-05-29 23:50:00
88	4	2006-05-29 20:00:00	2006-05-29 23:50:00
88	5	2006-05-29 20:00:00	2006-05-29 23:50:00
88	8	2006-05-29 20:00:00	2006-05-29 23:50:00
88	175	2006-05-29 20:24:02	2006-05-29 23:50:00
88	15	2006-05-29 20:00:00	2006-05-29 23:50:00
88	96	2006-05-29 20:00:00	2006-05-29 23:50:00
88	157	2006-05-29 20:00:00	2006-05-29 23:50:00
88	27	2006-05-29 20:00:00	2006-05-29 23:50:00
88	28	2006-05-29 20:00:00	2006-05-29 23:50:00
88	29	2006-05-29 20:00:00	2006-05-29 23:50:00
88	30	2006-05-29 20:30:05	2006-05-29 23:50:00
88	31	2006-05-29 20:00:00	2006-05-29 23:10:55
88	32	2006-05-29 20:00:00	2006-05-29 23:50:00
88	33	2006-05-29 20:00:00	2006-05-29 22:44:13
88	82	2006-05-29 20:07:05	2006-05-29 23:50:00
88	136	2006-05-29 20:00:00	2006-05-29 23:50:00
88	35	2006-05-29 20:00:00	2006-05-29 23:50:00
88	38	2006-05-29 20:00:00	2006-05-29 23:50:00
88	155	2006-05-29 20:22:48	2006-05-29 23:50:00
88	39	2006-05-29 20:23:21	2006-05-29 23:50:00
88	40	2006-05-29 20:00:00	2006-05-29 23:50:00
88	42	2006-05-29 20:00:00	2006-05-29 20:14:27
88	43	2006-05-29 20:00:00	2006-05-29 23:50:00
88	45	2006-05-29 20:00:00	2006-05-29 23:50:00
88	142	2006-05-29 20:00:00	2006-05-29 23:50:00
88	48	2006-05-29 20:00:00	2006-05-29 23:50:00
88	100	2006-05-29 20:00:00	2006-05-29 23:50:00
88	51	2006-05-29 20:00:00	2006-05-29 23:50:00
88	52	2006-05-29 20:00:00	2006-05-29 23:50:00
88	116	2006-05-29 20:19:19	2006-05-29 23:50:00
88	171	2006-05-29 20:25:57	2006-05-29 23:50:00
88	160	2006-05-29 20:19:06	2006-05-29 23:50:00
88	76	2006-05-29 20:00:00	2006-05-29 23:50:00
88	55	2006-05-29 20:22:44	2006-05-29 23:50:00
88	58	2006-05-29 20:00:00	2006-05-29 23:50:00
88	57	2006-05-29 20:00:00	2006-05-29 23:50:00
88	59	2006-05-29 20:00:00	2006-05-29 23:50:00
88	166	2006-05-29 20:16:02	2006-05-29 23:50:00
88	60	2006-05-29 20:13:38	2006-05-29 22:35:10
90	1	2006-05-30 21:00:00	2006-05-31 01:00:00
90	2	2006-05-30 21:00:00	2006-05-31 01:00:00
90	97	2006-05-30 21:00:00	2006-05-30 23:39:31
90	4	2006-05-30 21:00:00	2006-05-31 01:00:00
90	5	2006-05-30 21:00:00	2006-05-31 01:00:00
90	6	2006-05-30 21:00:00	2006-05-31 01:00:00
90	135	2006-05-30 21:00:00	2006-05-31 01:00:00
90	8	2006-05-30 21:00:00	2006-05-30 23:42:11
90	14	2006-05-30 21:00:00	2006-05-31 00:08:11
90	15	2006-05-30 23:24:50	2006-05-31 01:00:00
90	16	2006-05-30 21:00:00	2006-05-31 00:25:42
90	19	2006-05-30 21:00:00	2006-05-31 01:00:00
90	21	2006-05-30 21:00:00	2006-05-31 01:00:00
90	96	2006-05-30 21:00:00	2006-05-31 01:00:00
90	23	2006-05-30 21:00:00	2006-05-31 01:00:00
90	26	2006-05-30 21:00:00	2006-05-31 01:00:00
90	27	2006-05-30 21:00:00	2006-05-31 01:00:00
90	28	2006-05-30 21:00:00	2006-05-31 01:00:00
90	29	2006-05-30 21:00:00	2006-05-31 01:00:00
90	30	2006-05-30 21:00:00	2006-05-31 01:00:00
90	31	2006-05-30 21:00:00	2006-05-31 01:00:00
90	32	2006-05-30 21:00:00	2006-05-31 01:00:00
90	154	2006-05-31 00:10:37	2006-05-31 01:00:00
90	136	2006-05-30 21:00:00	2006-05-31 01:00:00
90	35	2006-05-30 21:00:00	2006-05-31 01:00:00
90	36	2006-05-30 21:00:00	2006-05-31 01:00:00
90	38	2006-05-30 21:00:00	2006-05-31 01:00:00
90	39	2006-05-30 21:00:00	2006-05-30 23:24:44
91	27	2006-05-30 20:37:32	2006-05-30 20:37:33
91	116	2006-05-30 20:37:32	2006-05-30 20:37:33
91	56	2006-05-30 20:37:32	2006-05-30 20:37:33
91	102	2006-05-30 20:37:32	2006-05-30 20:37:33
91	51	2006-05-30 20:37:32	2006-05-30 20:37:33
91	19	2006-05-30 20:37:32	2006-05-30 20:37:33
91	115	2006-05-30 20:37:32	2006-05-30 20:37:33
91	16	2006-05-30 20:37:32	2006-05-30 20:37:33
91	44	2006-05-30 20:37:32	2006-05-30 20:37:33
91	157	2006-05-30 20:37:32	2006-05-30 20:37:33
91	135	2006-05-30 20:37:32	2006-05-30 20:37:33
91	30	2006-05-30 20:37:32	2006-05-30 20:37:33
91	76	2006-05-30 20:37:32	2006-05-30 20:37:33
91	107	2006-05-30 20:37:32	2006-05-30 20:37:33
91	155	2006-05-30 20:37:32	2006-05-30 20:37:33
91	97	2006-05-30 20:37:32	2006-05-30 20:37:33
91	49	2006-05-30 20:37:32	2006-05-30 20:37:33
91	21	2006-05-30 20:37:32	2006-05-30 20:37:33
91	31	2006-05-30 20:37:32	2006-05-30 20:37:33
91	39	2006-05-30 20:37:32	2006-05-30 20:37:33
91	2	2006-05-30 20:37:32	2006-05-30 20:37:33
91	33	2006-05-30 20:37:32	2006-05-30 20:37:33
91	100	2006-05-30 20:37:32	2006-05-30 20:37:33
91	154	2006-05-30 20:37:32	2006-05-30 20:37:33
91	15	2006-05-30 20:37:32	2006-05-30 20:37:33
91	96	2006-05-30 20:37:32	2006-05-30 20:37:33
91	98	2006-05-30 20:37:32	2006-05-30 20:37:33
91	12	2006-05-30 20:37:32	2006-05-30 20:37:33
91	136	2006-05-30 20:37:32	2006-05-30 20:37:33
91	150	2006-05-30 20:37:32	2006-05-30 20:37:33
91	133	2006-05-30 20:37:32	2006-05-30 20:37:33
91	171	2006-05-30 20:37:32	2006-05-30 20:37:33
91	173	2006-05-30 20:37:32	2006-05-30 20:37:33
91	172	2006-05-30 20:37:32	2006-05-30 20:37:33
91	174	2006-05-30 20:37:32	2006-05-30 20:37:33
91	169	2006-05-30 20:37:32	2006-05-30 20:37:33
91	170	2006-05-30 20:37:32	2006-05-30 20:37:33
91	48	2006-05-30 20:37:32	2006-05-30 20:37:33
90	40	2006-05-30 21:00:00	2006-05-31 01:00:00
90	176	2006-05-30 23:43:01	2006-05-31 01:00:00
90	42	2006-05-30 21:00:00	2006-05-31 01:00:00
90	43	2006-05-30 21:00:00	2006-05-31 01:00:00
90	45	2006-05-30 23:40:01	2006-05-31 01:00:00
90	46	2006-05-30 21:00:00	2006-05-31 01:00:00
90	48	2006-05-30 21:00:00	2006-05-31 01:00:00
90	100	2006-05-30 21:00:00	2006-05-31 00:24:03
90	51	2006-05-30 21:00:00	2006-05-31 01:00:00
90	116	2006-05-30 21:00:00	2006-05-31 01:00:00
90	61	2006-05-30 21:00:00	2006-05-31 01:00:00
90	171	2006-05-30 21:00:00	2006-05-31 00:08:22
90	160	2006-05-31 00:08:28	2006-05-31 01:00:00
90	55	2006-05-30 21:00:00	2006-05-31 01:00:00
90	58	2006-05-30 21:00:00	2006-05-31 01:00:00
90	59	2006-05-30 21:00:00	2006-05-31 01:00:00
90	60	2006-05-30 21:00:00	2006-05-31 01:00:00
95	1	2006-05-31 19:30:00	2006-05-31 22:40:00
95	2	2006-05-31 19:30:00	2006-05-31 22:40:00
95	6	2006-05-31 19:30:00	2006-05-31 22:40:00
95	156	2006-05-31 20:30:59	2006-05-31 22:40:00
95	189	2006-05-31 19:30:00	2006-05-31 22:01:35
95	15	2006-05-31 19:30:00	2006-05-31 22:40:00
95	96	2006-05-31 19:30:00	2006-05-31 22:40:00
95	23	2006-05-31 19:30:00	2006-05-31 21:10:47
95	27	2006-05-31 19:30:00	2006-05-31 22:40:00
95	28	2006-05-31 19:30:00	2006-05-31 22:40:00
95	31	2006-05-31 19:30:00	2006-05-31 22:40:00
95	164	2006-05-31 19:30:00	2006-05-31 22:40:00
95	32	2006-05-31 19:30:00	2006-05-31 22:40:00
95	136	2006-05-31 19:30:00	2006-05-31 22:40:00
95	81	2006-05-31 19:30:00	2006-05-31 22:40:00
95	45	2006-05-31 22:01:15	2006-05-31 22:40:00
95	142	2006-05-31 19:30:00	2006-05-31 22:40:00
95	190	2006-05-31 21:14:22	2006-05-31 22:40:00
95	48	2006-05-31 19:30:00	2006-05-31 22:40:00
95	100	2006-05-31 19:30:00	2006-05-31 22:40:00
95	51	2006-05-31 19:30:00	2006-05-31 22:40:00
95	107	2006-05-31 19:30:00	2006-05-31 21:12:56
95	89	2006-05-31 21:16:05	2006-05-31 22:40:00
95	76	2006-05-31 19:30:00	2006-05-31 22:40:00
95	58	2006-05-31 19:30:00	2006-05-31 21:56:05
98	2	2006-06-04 19:30:00	2006-06-04 23:15:00
98	97	2006-06-04 19:30:00	2006-06-04 23:15:00
98	4	2006-06-04 22:29:31	2006-06-04 23:15:00
98	5	2006-06-04 19:30:00	2006-06-04 23:15:00
98	6	2006-06-04 19:30:00	2006-06-04 23:15:00
98	8	2006-06-04 19:30:00	2006-06-04 23:15:00
98	14	2006-06-04 19:30:00	2006-06-04 23:15:00
98	15	2006-06-04 19:30:00	2006-06-04 23:15:00
98	16	2006-06-04 19:30:00	2006-06-04 23:15:00
98	19	2006-06-04 19:30:00	2006-06-04 23:15:00
98	21	2006-06-04 19:30:00	2006-06-04 23:15:00
98	96	2006-06-04 19:30:00	2006-06-04 23:15:00
98	24	2006-06-04 19:30:00	2006-06-04 23:15:00
98	27	2006-06-04 19:30:00	2006-06-04 23:15:00
98	28	2006-06-04 19:30:00	2006-06-04 23:15:00
105	62	2006-06-08 21:42:11	2006-06-08 22:30:56
98	31	2006-06-04 19:30:00	2006-06-04 23:15:00
98	164	2006-06-04 19:30:00	2006-06-04 23:15:00
98	136	2006-06-04 19:30:00	2006-06-04 23:15:00
98	35	2006-06-04 19:30:00	2006-06-04 23:15:00
98	150	2006-06-04 21:14:11	2006-06-04 23:15:00
98	155	2006-06-04 19:30:00	2006-06-04 23:15:00
98	39	2006-06-04 19:30:00	2006-06-04 23:15:00
98	40	2006-06-04 19:30:00	2006-06-04 23:15:00
105	142	2006-06-08 19:30:53	2006-06-08 22:30:56
98	43	2006-06-04 19:30:00	2006-06-04 23:15:00
98	44	2006-06-04 19:30:00	2006-06-04 22:29:07
98	45	2006-06-04 19:30:00	2006-06-04 23:15:00
98	106	2006-06-04 19:30:00	2006-06-04 23:15:00
98	48	2006-06-04 19:30:00	2006-06-04 23:15:00
98	49	2006-06-04 19:30:00	2006-06-04 23:15:00
98	100	2006-06-04 19:30:00	2006-06-04 23:15:00
98	51	2006-06-04 19:30:00	2006-06-04 23:15:00
98	165	2006-06-04 19:33:24	2006-06-04 23:15:00
98	115	2006-06-04 19:30:00	2006-06-04 23:05:01
98	116	2006-06-04 19:30:00	2006-06-04 23:15:00
98	61	2006-06-04 19:30:00	2006-06-04 21:08:50
98	107	2006-06-04 19:30:00	2006-06-04 23:15:00
98	89	2006-06-04 19:30:00	2006-06-04 23:15:00
98	55	2006-06-04 19:30:00	2006-06-04 23:15:00
98	58	2006-06-04 19:30:00	2006-06-04 23:15:00
98	59	2006-06-04 19:30:00	2006-06-04 23:15:00
98	60	2006-06-04 19:30:00	2006-06-04 23:15:00
105	48	2006-06-08 19:30:53	2006-06-08 22:30:56
105	49	2006-06-08 19:30:53	2006-06-08 22:30:56
105	100	2006-06-08 19:30:53	2006-06-08 22:30:56
105	51	2006-06-08 19:30:53	2006-06-08 22:30:56
105	116	2006-06-08 19:30:53	2006-06-08 22:30:56
105	61	2006-06-08 19:30:53	2006-06-08 22:30:56
105	171	2006-06-08 19:30:53	2006-06-08 22:30:56
100	27	2006-05-28 00:00:00	2006-05-28 04:00:00
100	15	2006-05-28 00:00:00	2006-05-28 04:00:00
100	8	2006-05-28 00:00:00	2006-05-28 04:00:00
100	19	2006-05-28 00:00:00	2006-05-28 04:00:00
100	96	2006-05-28 00:00:00	2006-05-28 04:00:00
100	29	2006-05-28 00:00:00	2006-05-28 04:00:00
100	6	2006-05-28 00:00:00	2006-05-28 04:00:00
100	24	2006-05-28 00:00:00	2006-05-28 04:00:00
100	16	2006-05-28 00:00:00	2006-05-28 04:00:00
100	135	2006-05-28 00:00:00	2006-05-28 04:00:00
100	28	2006-05-28 00:00:00	2006-05-28 04:00:00
100	21	2006-05-28 00:00:00	2006-05-28 04:00:00
100	2	2006-05-28 00:00:00	2006-05-28 04:00:00
100	136	2006-05-28 00:00:00	2006-05-28 04:00:00
100	155	2006-05-28 00:00:00	2006-05-28 04:00:00
100	177	2006-05-28 00:00:00	2006-05-28 04:00:00
100	33	2006-05-28 00:00:00	2006-05-28 04:00:00
100	133	2006-05-28 00:00:00	2006-05-28 04:00:00
100	42	2006-05-28 00:00:00	2006-05-28 04:00:00
100	48	2006-05-28 00:00:00	2006-05-28 04:00:00
100	45	2006-05-28 00:00:00	2006-05-28 04:00:00
100	116	2006-05-28 00:00:00	2006-05-28 04:00:00
100	160	2006-05-28 00:00:00	2006-05-28 04:00:00
100	171	2006-05-28 00:00:00	2006-05-28 04:00:00
100	51	2006-05-28 00:00:00	2006-05-28 04:00:00
100	43	2006-05-28 00:00:00	2006-05-28 04:00:00
100	40	2006-05-28 00:00:00	2006-05-28 04:00:00
100	52	2006-05-28 00:00:00	2006-05-28 04:00:00
100	81	2006-05-28 00:00:00	2006-05-28 04:00:00
100	115	2006-05-28 00:00:00	2006-05-28 04:00:00
100	129	2006-05-28 00:00:00	2006-05-28 04:00:00
100	109	2006-05-28 00:00:00	2006-05-28 04:00:00
100	142	2006-05-28 00:00:00	2006-05-28 04:00:00
100	60	2006-05-28 00:00:00	2006-05-28 04:00:00
100	57	2006-05-28 00:00:00	2006-05-28 04:00:00
100	107	2006-05-28 00:00:00	2006-05-28 04:00:00
100	144	2006-05-28 00:00:00	2006-05-28 04:00:00
100	178	2006-05-28 00:00:00	2006-05-28 04:00:00
100	153	2006-05-28 00:00:00	2006-05-28 04:00:00
100	176	2006-05-28 00:00:00	2006-05-28 04:00:00
100	100	2006-05-28 00:00:00	2006-05-28 04:00:00
100	154	2006-05-28 00:00:00	2006-05-28 04:00:00
99	1	2006-06-01 21:00:00	2006-06-01 22:45:00
99	2	2006-06-01 21:00:00	2006-06-01 22:45:00
99	4	2006-06-01 21:00:00	2006-06-01 22:45:00
99	6	2006-06-01 21:00:00	2006-06-01 22:45:00
99	156	2006-06-01 21:00:00	2006-06-01 22:45:00
99	179	2006-06-01 21:32:16	2006-06-01 22:45:00
99	102	2006-06-01 21:51:22	2006-06-01 22:45:00
99	180	2006-06-01 21:30:48	2006-06-01 22:45:00
99	90	2006-06-01 21:00:00	2006-06-01 22:45:00
99	14	2006-06-01 21:00:00	2006-06-01 22:45:00
99	15	2006-06-01 21:04:59	2006-06-01 22:45:00
99	181	2006-06-01 21:40:22	2006-06-01 22:45:00
99	96	2006-06-01 21:00:00	2006-06-01 22:45:00
99	182	2006-06-01 21:33:46	2006-06-01 22:45:00
99	26	2006-06-01 21:00:00	2006-06-01 21:38:00
99	27	2006-06-01 21:00:00	2006-06-01 22:45:00
99	28	2006-06-01 21:00:00	2006-06-01 22:45:00
99	98	2006-06-01 21:00:00	2006-06-01 22:45:00
99	30	2006-06-01 21:00:00	2006-06-01 22:45:00
99	31	2006-06-01 21:00:00	2006-06-01 22:45:00
99	164	2006-06-01 21:22:42	2006-06-01 22:45:00
99	32	2006-06-01 21:00:00	2006-06-01 22:45:00
99	133	2006-06-01 21:00:00	2006-06-01 22:45:00
99	82	2006-06-01 21:00:00	2006-06-01 22:45:00
99	136	2006-06-01 21:00:00	2006-06-01 22:45:00
99	169	2006-06-01 21:00:00	2006-06-01 22:45:00
99	39	2006-06-01 21:00:00	2006-06-01 22:45:00
99	42	2006-06-01 21:00:00	2006-06-01 22:45:00
99	43	2006-06-01 21:00:00	2006-06-01 22:45:00
99	45	2006-06-01 21:00:00	2006-06-01 22:45:00
99	142	2006-06-01 21:00:00	2006-06-01 22:45:00
99	105	2006-06-01 21:32:32	2006-06-01 22:45:00
99	100	2006-06-01 21:00:00	2006-06-01 22:45:00
99	51	2006-06-01 21:00:00	2006-06-01 22:45:00
99	183	2006-06-01 21:32:26	2006-06-01 22:45:00
99	165	2006-06-01 21:00:00	2006-06-01 22:45:00
99	184	2006-06-01 21:34:17	2006-06-01 21:35:02
99	115	2006-06-01 21:22:09	2006-06-01 22:45:00
99	116	2006-06-01 21:00:00	2006-06-01 22:45:00
99	185	2006-06-01 22:27:56	2006-06-01 22:45:00
99	107	2006-06-01 21:00:00	2006-06-01 22:45:00
99	160	2006-06-01 21:00:00	2006-06-01 22:25:59
99	76	2006-06-01 21:00:00	2006-06-01 22:45:00
99	63	2006-06-01 21:38:38	2006-06-01 22:45:00
101	1	2006-06-02 22:27:00	2006-06-03 00:00:00
101	97	2006-06-02 21:00:00	2006-06-03 00:00:00
101	4	2006-06-02 21:00:00	2006-06-02 22:26:19
101	5	2006-06-02 21:00:00	2006-06-03 00:00:00
101	6	2006-06-02 21:00:00	2006-06-02 23:46:30
101	156	2006-06-02 21:09:52	2006-06-03 00:00:00
101	8	2006-06-02 22:20:50	2006-06-03 00:00:00
101	186	2006-06-02 21:09:05	2006-06-02 23:21:13
101	13	2006-06-02 21:15:26	2006-06-02 23:46:07
101	15	2006-06-02 21:03:08	2006-06-02 22:20:19
101	16	2006-06-02 22:02:14	2006-06-03 00:00:00
101	27	2006-06-02 21:00:00	2006-06-03 00:00:00
101	98	2006-06-02 21:00:00	2006-06-02 21:04:05
101	30	2006-06-02 21:00:00	2006-06-03 00:00:00
101	31	2006-06-02 21:28:08	2006-06-02 23:12:08
101	164	2006-06-02 21:28:30	2006-06-03 00:00:00
101	133	2006-06-02 21:09:32	2006-06-03 00:00:00
101	154	2006-06-02 21:10:38	2006-06-03 00:00:00
101	136	2006-06-02 21:00:31	2006-06-03 00:00:00
101	35	2006-06-02 21:00:00	2006-06-03 00:00:00
101	36	2006-06-02 21:00:00	2006-06-03 00:00:00
101	39	2006-06-02 21:00:00	2006-06-03 00:00:00
101	40	2006-06-02 21:47:52	2006-06-03 00:00:00
101	176	2006-06-02 23:22:48	2006-06-03 00:00:00
101	43	2006-06-02 21:00:00	2006-06-02 23:21:17
101	174	2006-06-02 21:05:29	2006-06-03 00:00:00
101	44	2006-06-02 21:04:33	2006-06-03 00:00:00
101	45	2006-06-02 21:00:00	2006-06-03 00:00:00
101	142	2006-06-02 21:00:34	2006-06-03 00:00:00
101	48	2006-06-02 21:00:00	2006-06-03 00:00:00
101	187	2006-06-02 21:09:13	2006-06-03 00:00:00
101	49	2006-06-02 22:23:25	2006-06-02 23:46:32
101	100	2006-06-02 21:06:44	2006-06-03 00:00:00
101	165	2006-06-02 21:00:00	2006-06-02 23:41:31
101	115	2006-06-02 21:11:45	2006-06-02 23:00:22
101	116	2006-06-02 21:01:05	2006-06-03 00:00:00
101	61	2006-06-02 21:06:49	2006-06-03 00:00:00
101	171	2006-06-02 21:01:50	2006-06-02 23:44:54
101	109	2006-06-02 21:00:00	2006-06-02 23:45:12
101	107	2006-06-02 21:02:37	2006-06-02 23:46:35
101	160	2006-06-02 21:01:24	2006-06-03 00:00:00
101	54	2006-06-02 21:07:00	2006-06-03 00:00:00
101	63	2006-06-02 23:26:15	2006-06-03 00:00:00
101	55	2006-06-02 21:11:37	2006-06-03 00:00:00
101	58	2006-06-02 21:00:00	2006-06-02 21:58:26
101	166	2006-06-02 21:04:50	2006-06-02 22:19:03
101	60	2006-06-02 21:00:00	2006-06-03 00:00:00
93	1	2006-06-03 11:00:00	2006-06-03 16:15:00
93	97	2006-06-03 11:00:00	2006-06-03 16:15:00
93	5	2006-06-03 11:00:00	2006-06-03 16:15:00
93	102	2006-06-03 11:00:00	2006-06-03 16:15:00
93	90	2006-06-03 11:00:00	2006-06-03 16:15:00
93	186	2006-06-03 11:00:00	2006-06-03 15:16:17
93	157	2006-06-03 11:00:00	2006-06-03 16:08:08
93	64	2006-06-03 11:00:00	2006-06-03 16:15:00
93	27	2006-06-03 15:43:22	2006-06-03 16:15:00
93	30	2006-06-03 11:00:00	2006-06-03 16:15:00
93	32	2006-06-03 11:00:00	2006-06-03 16:15:00
93	136	2006-06-03 11:00:00	2006-06-03 16:15:00
93	35	2006-06-03 11:00:00	2006-06-03 16:15:00
93	36	2006-06-03 11:00:00	2006-06-03 13:15:11
93	44	2006-06-03 11:00:00	2006-06-03 16:15:00
93	142	2006-06-03 13:15:57	2006-06-03 16:15:00
93	100	2006-06-03 11:00:00	2006-06-03 16:15:00
93	51	2006-06-03 11:00:00	2006-06-03 16:15:00
93	188	2006-06-03 11:00:00	2006-06-03 16:15:00
93	115	2006-06-03 11:00:00	2006-06-03 15:42:09
93	61	2006-06-03 11:00:00	2006-06-03 16:15:00
93	109	2006-06-03 16:08:15	2006-06-03 16:15:00
93	58	2006-06-03 15:18:48	2006-06-03 16:15:00
93	60	2006-06-03 11:00:00	2006-06-03 16:15:00
98	81	2006-06-04 19:30:00	2006-06-04 23:15:00
105	1	2006-06-08 19:30:53	2006-06-08 22:30:56
105	4	2006-06-08 19:30:53	2006-06-08 22:30:56
105	8	2006-06-08 20:29:19	2006-06-08 22:30:56
105	28	2006-06-08 19:30:53	2006-06-08 22:30:56
105	98	2006-06-08 19:33:11	2006-06-08 21:41:39
105	32	2006-06-08 19:30:53	2006-06-08 22:30:56
105	82	2006-06-08 19:30:53	2006-06-08 20:27:26
105	136	2006-06-08 19:30:53	2006-06-08 22:30:56
105	150	2006-06-08 19:30:53	2006-06-08 22:30:56
105	40	2006-06-08 21:14:58	2006-06-08 22:30:56
105	81	2006-06-08 19:30:53	2006-06-08 21:01:46
105	160	2006-06-08 19:30:53	2006-06-08 22:30:56
105	153	2006-06-08 19:30:53	2006-06-08 22:30:56
105	60	2006-06-08 19:30:53	2006-06-08 22:30:56
107	2	2006-06-10 10:00:00	2006-06-10 13:20:50
107	5	2006-06-10 10:00:00	2006-06-10 13:20:50
107	90	2006-06-10 10:00:00	2006-06-10 13:20:50
107	186	2006-06-10 10:00:00	2006-06-10 12:06:13
107	30	2006-06-10 10:00:00	2006-06-10 13:20:50
107	32	2006-06-10 10:00:00	2006-06-10 13:20:50
107	136	2006-06-10 10:00:00	2006-06-10 13:20:50
107	36	2006-06-10 10:00:00	2006-06-10 13:20:50
107	155	2006-06-10 10:00:00	2006-06-10 13:20:50
107	39	2006-06-10 10:00:00	2006-06-10 13:03:22
107	41	2006-06-10 10:00:00	2006-06-10 13:20:50
107	193	2006-06-10 10:00:00	2006-06-10 13:20:50
107	44	2006-06-10 10:00:00	2006-06-10 13:20:50
107	142	2006-06-10 10:00:00	2006-06-10 12:28:52
107	100	2006-06-10 10:08:35	2006-06-10 13:20:50
107	51	2006-06-10 10:00:00	2006-06-10 13:20:50
107	188	2006-06-10 10:00:00	2006-06-10 13:20:50
107	115	2006-06-10 10:00:00	2006-06-10 13:20:50
107	160	2006-06-10 10:00:00	2006-06-10 13:20:50
107	54	2006-06-10 10:00:00	2006-06-10 13:20:50
107	58	2006-06-10 12:06:40	2006-06-10 13:20:50
97	1	2006-06-03 19:00:00	2006-06-03 20:00:00
97	97	2006-06-03 19:00:00	2006-06-03 20:00:00
97	175	2006-06-03 19:17:17	2006-06-03 20:00:00
97	14	2006-06-03 19:00:00	2006-06-03 20:00:00
97	15	2006-06-03 19:00:00	2006-06-03 20:00:00
97	19	2006-06-03 19:00:00	2006-06-03 20:00:00
97	21	2006-06-03 19:00:00	2006-06-03 20:00:00
97	157	2006-06-03 19:00:00	2006-06-03 20:00:00
97	27	2006-06-03 19:00:00	2006-06-03 20:00:00
97	133	2006-06-03 19:00:00	2006-06-03 20:00:00
97	119	2006-06-03 19:00:00	2006-06-03 20:00:00
97	154	2006-06-03 19:46:16	2006-06-03 20:00:00
97	136	2006-06-03 19:00:00	2006-06-03 20:00:00
97	35	2006-06-03 19:00:00	2006-06-03 20:00:00
97	150	2006-06-03 19:00:00	2006-06-03 20:00:00
97	155	2006-06-03 19:00:00	2006-06-03 20:00:00
97	178	2006-06-03 19:13:30	2006-06-03 20:00:00
97	81	2006-06-03 19:00:00	2006-06-03 20:00:00
97	45	2006-06-03 19:00:00	2006-06-03 20:00:00
97	142	2006-06-03 19:00:00	2006-06-03 20:00:00
97	190	2006-06-03 19:00:00	2006-06-03 20:00:00
97	48	2006-06-03 19:00:00	2006-06-03 20:00:00
97	49	2006-06-03 19:00:00	2006-06-03 20:00:00
97	100	2006-06-03 19:00:00	2006-06-03 20:00:00
97	51	2006-06-03 19:00:00	2006-06-03 20:00:00
97	115	2006-06-03 19:00:00	2006-06-03 20:00:00
97	116	2006-06-03 19:00:00	2006-06-03 20:00:00
97	61	2006-06-03 19:00:00	2006-06-03 20:00:00
97	172	2006-06-03 19:00:00	2006-06-03 20:00:00
97	171	2006-06-03 19:00:00	2006-06-03 20:00:00
97	107	2006-06-03 19:00:00	2006-06-03 20:00:00
97	89	2006-06-03 19:50:20	2006-06-03 20:00:00
97	58	2006-06-03 19:00:00	2006-06-03 20:00:00
97	56	2006-06-03 19:00:00	2006-06-03 20:00:00
97	59	2006-06-03 19:00:00	2006-06-03 20:00:00
97	60	2006-06-03 19:00:00	2006-06-03 20:00:00
108	2	2006-06-10 19:00:55	2006-06-10 22:45:00
108	97	2006-06-10 19:00:55	2006-06-10 22:45:00
108	4	2006-06-10 19:06:29	2006-06-10 22:45:00
108	5	2006-06-10 19:00:55	2006-06-10 22:45:00
108	6	2006-06-10 19:00:55	2006-06-10 22:45:00
108	156	2006-06-10 19:00:55	2006-06-10 22:45:00
108	8	2006-06-10 19:00:55	2006-06-10 22:45:00
108	175	2006-06-10 19:19:07	2006-06-10 22:45:00
108	186	2006-06-10 21:37:45	2006-06-10 22:45:00
108	15	2006-06-10 19:00:55	2006-06-10 22:45:00
108	21	2006-06-10 19:00:55	2006-06-10 22:45:00
108	96	2006-06-10 19:00:55	2006-06-10 22:45:00
108	157	2006-06-10 19:00:55	2006-06-10 20:44:48
108	24	2006-06-10 19:00:55	2006-06-10 22:45:00
108	27	2006-06-10 19:00:55	2006-06-10 22:45:00
108	31	2006-06-10 19:00:55	2006-06-10 22:45:00
108	32	2006-06-10 19:01:48	2006-06-10 20:59:03
108	133	2006-06-10 21:37:47	2006-06-10 22:45:00
108	154	2006-06-10 19:00:55	2006-06-10 22:45:00
108	136	2006-06-10 19:00:55	2006-06-10 22:45:00
108	35	2006-06-10 19:00:55	2006-06-10 22:45:00
108	150	2006-06-10 19:00:55	2006-06-10 22:45:00
108	40	2006-06-10 22:25:04	2006-06-10 22:45:00
108	81	2006-06-10 19:00:55	2006-06-10 22:45:00
108	41	2006-06-10 19:00:55	2006-06-10 22:45:00
108	43	2006-06-10 19:00:55	2006-06-10 21:28:00
108	142	2006-06-10 19:00:55	2006-06-10 22:45:00
108	194	2006-06-10 21:45:06	2006-06-10 22:45:00
108	48	2006-06-10 19:00:55	2006-06-10 22:45:00
108	100	2006-06-10 19:00:55	2006-06-10 22:45:00
108	51	2006-06-10 19:00:55	2006-06-10 19:01:40
108	188	2006-06-10 19:03:47	2006-06-10 22:45:00
108	165	2006-06-10 19:00:55	2006-06-10 22:45:00
108	52	2006-06-10 20:44:43	2006-06-10 22:45:00
108	72	2006-06-10 19:00:55	2006-06-10 22:45:00
108	115	2006-06-10 19:00:55	2006-06-10 22:45:00
108	116	2006-06-10 19:00:55	2006-06-10 21:34:57
108	107	2006-06-10 19:00:55	2006-06-10 22:43:24
108	160	2006-06-10 19:00:55	2006-06-10 22:34:05
108	89	2006-06-10 19:00:55	2006-06-10 19:41:01
108	76	2006-06-10 19:00:55	2006-06-10 22:45:00
108	58	2006-06-10 19:00:55	2006-06-10 22:45:00
102	24	2006-06-04 23:30:00	2006-06-05 00:24:00
108	153	2006-06-10 19:00:55	2006-06-10 22:45:00
108	56	2006-06-10 19:00:55	2006-06-10 22:45:00
102	31	2006-06-04 23:30:00	2006-06-05 00:24:00
108	59	2006-06-10 19:00:55	2006-06-10 22:45:00
102	32	2006-06-04 23:30:00	2006-06-05 00:24:00
108	60	2006-06-10 19:00:55	2006-06-10 22:45:00
102	39	2006-06-04 23:30:00	2006-06-05 00:24:00
102	40	2006-06-04 23:30:00	2006-06-05 00:24:00
102	44	2006-06-04 23:30:00	2006-06-05 00:24:00
102	115	2006-06-04 23:30:00	2006-06-05 00:24:00
102	89	2006-06-04 23:30:00	2006-06-05 00:24:00
102	58	2006-06-04 23:30:00	2006-06-05 00:24:00
102	60	2006-06-04 23:30:00	2006-06-05 00:24:00
102	1	2006-06-04 23:31:20	2006-06-05 00:24:00
102	2	2006-06-04 23:31:20	2006-06-05 00:24:00
102	97	2006-06-04 23:31:20	2006-06-05 00:18:43
102	4	2006-06-04 23:31:20	2006-06-05 00:19:42
102	5	2006-06-04 23:31:20	2006-06-05 00:22:25
102	6	2006-06-04 23:31:20	2006-06-05 00:22:04
102	156	2006-06-04 23:31:56	2006-06-05 00:20:44
102	135	2006-06-04 23:31:20	2006-06-05 00:24:00
102	8	2006-06-04 23:31:20	2006-06-05 00:08:51
102	175	2006-06-04 23:31:20	2006-06-05 00:22:54
102	14	2006-06-04 23:31:20	2006-06-05 00:20:22
102	15	2006-06-04 23:31:20	2006-06-05 00:24:00
102	16	2006-06-04 23:31:20	2006-06-05 00:24:00
102	19	2006-06-04 23:31:20	2006-06-05 00:21:30
102	21	2006-06-04 23:31:20	2006-06-05 00:08:59
102	96	2006-06-04 23:31:20	2006-06-05 00:24:00
102	157	2006-06-04 23:31:20	2006-06-05 00:24:00
102	27	2006-06-04 23:31:20	2006-06-05 00:07:32
102	28	2006-06-04 23:31:20	2006-06-05 00:24:00
102	164	2006-06-04 23:31:20	2006-06-05 00:24:00
102	154	2006-06-04 23:31:20	2006-06-05 00:20:41
102	136	2006-06-04 23:31:20	2006-06-05 00:24:00
102	35	2006-06-04 23:31:20	2006-06-05 00:24:00
102	150	2006-06-04 23:31:20	2006-06-05 00:24:00
102	38	2006-06-04 23:31:20	2006-06-05 00:23:02
102	155	2006-06-04 23:31:20	2006-06-05 00:21:23
102	81	2006-06-04 23:31:20	2006-06-05 00:11:00
102	42	2006-06-04 23:31:20	2006-06-05 00:24:00
102	43	2006-06-04 23:31:20	2006-06-05 00:24:00
102	45	2006-06-04 23:31:20	2006-06-05 00:24:00
102	106	2006-06-04 23:31:20	2006-06-05 00:24:00
102	48	2006-06-04 23:31:20	2006-06-05 00:24:00
102	49	2006-06-04 23:31:20	2006-06-05 00:24:00
102	100	2006-06-04 23:31:20	2006-06-05 00:24:00
102	51	2006-06-04 23:31:20	2006-06-05 00:22:37
102	165	2006-06-04 23:31:20	2006-06-05 00:24:00
102	116	2006-06-04 23:31:20	2006-06-05 00:24:00
102	61	2006-06-04 23:30:00	2006-06-05 00:24:00
102	107	2006-06-04 23:31:20	2006-06-05 00:24:00
102	160	2006-06-04 23:31:20	2006-06-05 00:24:00
102	55	2006-06-04 23:31:20	2006-06-05 00:24:00
102	59	2006-06-04 23:31:20	2006-06-05 00:24:00
103	1	2006-06-05 21:00:00	2006-06-05 23:20:00
103	2	2006-06-05 21:09:50	2006-06-05 23:20:00
103	97	2006-06-05 21:00:00	2006-06-05 23:20:00
103	4	2006-06-05 21:00:00	2006-06-05 23:20:00
103	5	2006-06-05 21:00:00	2006-06-05 23:20:00
103	6	2006-06-05 21:00:00	2006-06-05 23:20:00
103	8	2006-06-05 21:00:00	2006-06-05 23:20:00
103	175	2006-06-05 21:00:00	2006-06-05 23:20:00
103	14	2006-06-05 21:00:00	2006-06-05 23:20:00
103	15	2006-06-05 21:00:00	2006-06-05 23:20:00
103	16	2006-06-05 21:00:00	2006-06-05 23:20:00
103	19	2006-06-05 21:00:00	2006-06-05 23:20:00
103	96	2006-06-05 21:00:00	2006-06-05 23:20:00
103	157	2006-06-05 21:00:00	2006-06-05 23:20:00
103	27	2006-06-05 21:00:00	2006-06-05 23:20:00
103	28	2006-06-05 21:00:00	2006-06-05 23:20:00
103	29	2006-06-05 21:00:00	2006-06-05 23:20:00
103	32	2006-06-05 21:00:00	2006-06-05 23:20:00
103	133	2006-06-05 21:00:00	2006-06-05 23:20:00
103	82	2006-06-05 21:00:00	2006-06-05 23:20:00
103	154	2006-06-05 21:00:00	2006-06-05 23:20:00
103	136	2006-06-05 21:00:00	2006-06-05 23:20:00
103	35	2006-06-05 21:00:00	2006-06-05 23:20:00
103	36	2006-06-05 21:00:00	2006-06-05 23:20:00
103	150	2006-06-05 21:00:00	2006-06-05 23:20:00
103	38	2006-06-05 21:00:00	2006-06-05 23:20:00
103	155	2006-06-05 21:00:00	2006-06-05 23:20:00
103	39	2006-06-05 21:55:23	2006-06-05 23:20:00
103	176	2006-06-05 21:00:00	2006-06-05 23:20:00
103	42	2006-06-05 21:00:00	2006-06-05 23:20:00
103	43	2006-06-05 21:00:00	2006-06-05 23:20:00
103	45	2006-06-05 21:00:00	2006-06-05 23:20:00
103	142	2006-06-05 21:00:00	2006-06-05 23:20:00
103	48	2006-06-05 21:00:00	2006-06-05 23:20:00
103	187	2006-06-05 21:00:00	2006-06-05 23:20:00
103	49	2006-06-05 21:00:00	2006-06-05 23:20:00
103	100	2006-06-05 21:00:00	2006-06-05 23:20:00
103	51	2006-06-05 21:00:00	2006-06-05 23:20:00
103	165	2006-06-05 21:00:00	2006-06-05 23:20:00
103	61	2006-06-05 21:00:00	2006-06-05 23:20:00
103	171	2006-06-05 21:00:00	2006-06-05 23:20:00
103	107	2006-06-05 21:00:00	2006-06-05 23:20:00
103	160	2006-06-05 21:00:00	2006-06-05 23:20:00
103	117	2006-06-05 21:00:00	2006-06-05 23:20:00
103	54	2006-06-05 21:00:00	2006-06-05 23:20:00
103	58	2006-06-05 21:00:00	2006-06-05 23:20:00
103	153	2006-06-05 21:00:00	2006-06-05 23:20:00
103	59	2006-06-05 21:00:00	2006-06-05 23:20:00
103	60	2006-06-05 21:00:00	2006-06-05 23:20:00
104	1	2006-06-07 20:44:12	2006-06-07 20:45:00
104	5	2006-06-07 20:44:12	2006-06-07 20:44:12
104	6	2006-06-07 20:44:12	2006-06-07 20:45:00
104	8	2006-06-07 20:44:12	2006-06-07 20:45:00
104	14	2006-06-07 20:44:12	2006-06-07 20:45:00
104	16	2006-06-07 20:44:12	2006-06-07 20:45:00
104	23	2006-06-07 20:44:12	2006-06-07 20:45:00
104	27	2006-06-07 20:44:12	2006-06-07 20:45:00
104	30	2006-06-07 20:44:12	2006-06-07 20:45:00
104	32	2006-06-07 20:44:12	2006-06-07 20:45:00
104	133	2006-06-07 20:44:00	2006-06-07 20:45:00
104	136	2006-06-07 20:44:12	2006-06-07 20:45:00
104	35	2006-06-07 20:44:12	2006-06-07 20:45:00
104	36	2006-06-07 20:44:12	2006-06-07 20:45:00
104	40	2006-06-07 20:44:12	2006-06-07 20:45:00
104	42	2006-06-07 20:44:12	2006-06-07 20:44:12
104	43	2006-06-07 20:44:12	2006-06-07 20:45:00
104	45	2006-06-07 20:44:00	2006-06-07 20:45:00
104	100	2006-06-07 20:44:12	2006-06-07 20:45:00
104	51	2006-06-07 20:44:12	2006-06-07 20:45:00
104	61	2006-06-07 20:44:12	2006-06-07 20:45:00
104	171	2006-06-07 20:44:12	2006-06-07 20:45:00
104	107	2006-06-07 20:44:12	2006-06-07 20:45:00
104	160	2006-06-07 20:44:00	2006-06-07 20:45:00
104	55	2006-06-07 20:44:12	2006-06-07 20:45:00
104	60	2006-06-07 20:44:12	2006-06-07 20:45:00
106	23	2006-06-10 16:35:56	2006-06-10 16:37:37
106	42	2006-06-10 16:35:56	2006-06-10 16:37:37
106	160	2006-06-10 16:35:56	2006-06-10 16:37:37
106	51	2006-06-10 16:35:56	2006-06-10 16:37:37
106	40	2006-06-10 16:35:56	2006-06-10 16:37:37
106	36	2006-06-10 16:35:56	2006-06-10 16:37:37
106	82	2006-06-10 16:35:56	2006-06-10 16:37:37
106	6	2006-06-10 16:35:56	2006-06-10 16:37:37
106	44	2006-06-10 16:35:56	2006-06-10 16:37:37
106	90	2006-06-10 16:35:56	2006-06-10 16:37:37
106	5	2006-06-10 16:35:56	2006-06-10 16:37:37
106	60	2006-06-10 16:35:56	2006-06-10 16:37:37
106	63	2006-06-10 16:35:56	2006-06-10 16:37:37
106	165	2006-06-10 16:35:56	2006-06-10 16:37:37
106	167	2006-06-10 16:35:56	2006-06-10 16:37:37
106	1	2006-06-10 16:35:56	2006-06-10 16:37:37
106	58	2006-06-10 16:35:56	2006-06-10 16:37:37
106	100	2006-06-10 16:35:56	2006-06-10 16:37:37
106	142	2006-06-10 16:37:15	2006-06-10 16:37:37
117	2	2006-06-17 18:50:31	2006-06-17 23:12:26
117	97	2006-06-17 18:50:31	2006-06-17 23:12:26
117	6	2006-06-17 18:50:31	2006-06-17 23:10:58
117	135	2006-06-17 19:37:35	2006-06-17 23:12:26
117	175	2006-06-17 18:57:24	2006-06-17 23:12:26
117	90	2006-06-17 18:50:31	2006-06-17 23:12:26
117	186	2006-06-17 19:18:24	2006-06-17 23:12:26
117	14	2006-06-17 18:50:31	2006-06-17 21:01:01
117	15	2006-06-17 18:50:31	2006-06-17 23:12:26
117	199	2006-06-17 18:50:31	2006-06-17 23:12:26
117	16	2006-06-17 18:50:31	2006-06-17 23:12:26
117	123	2006-06-17 18:50:31	2006-06-17 23:12:26
117	19	2006-06-17 18:50:31	2006-06-17 19:02:58
117	96	2006-06-17 18:52:02	2006-06-17 23:12:26
117	24	2006-06-17 18:50:31	2006-06-17 23:10:56
117	27	2006-06-17 18:50:31	2006-06-17 23:12:26
117	33	2006-06-17 18:50:31	2006-06-17 23:12:19
117	119	2006-06-17 22:28:42	2006-06-17 23:12:26
117	154	2006-06-17 18:51:45	2006-06-17 23:12:26
117	136	2006-06-17 18:50:31	2006-06-17 23:12:26
117	150	2006-06-17 21:56:20	2006-06-17 23:12:26
117	84	2006-06-17 19:04:04	2006-06-17 23:12:26
117	155	2006-06-17 18:50:31	2006-06-17 23:12:26
117	39	2006-06-17 21:18:59	2006-06-17 23:12:26
117	40	2006-06-17 20:45:12	2006-06-17 20:53:20
117	42	2006-06-17 22:15:18	2006-06-17 23:12:24
117	43	2006-06-17 18:50:31	2006-06-17 23:12:26
117	45	2006-06-17 18:50:31	2006-06-17 23:12:26
117	142	2006-06-17 18:52:10	2006-06-17 23:12:26
117	162	2006-06-17 18:56:44	2006-06-17 23:12:26
117	187	2006-06-17 19:01:42	2006-06-17 23:12:26
117	49	2006-06-17 18:50:31	2006-06-17 23:12:26
117	100	2006-06-17 18:50:31	2006-06-17 23:12:26
117	51	2006-06-17 18:54:22	2006-06-17 18:58:17
117	188	2006-06-17 19:01:14	2006-06-17 23:12:26
117	52	2006-06-17 18:50:31	2006-06-17 23:12:26
117	132	2006-06-17 18:51:24	2006-06-17 23:12:26
118	96	2006-06-18 18:30:00	2006-06-18 23:30:00
118	23	2006-06-18 18:30:00	2006-06-18 23:30:00
118	157	2006-06-18 18:45:52	2006-06-18 23:30:00
118	24	2006-06-18 18:30:00	2006-06-18 22:16:20
118	27	2006-06-18 18:30:00	2006-06-18 23:30:00
118	28	2006-06-18 18:30:00	2006-06-18 23:30:00
118	30	2006-06-18 18:30:00	2006-06-18 23:30:00
113	1	2006-06-13 20:00:00	2006-06-13 23:40:00
113	2	2006-06-13 20:00:00	2006-06-13 23:40:00
113	97	2006-06-13 20:00:00	2006-06-13 20:36:27
113	5	2006-06-13 20:00:00	2006-06-13 23:40:00
113	6	2006-06-13 20:00:00	2006-06-13 23:40:00
110	2	2006-06-11 22:49:53	2006-06-12 00:25:00
110	4	2006-06-11 22:49:53	2006-06-12 00:25:00
110	5	2006-06-11 22:49:53	2006-06-12 00:25:00
110	6	2006-06-11 22:49:53	2006-06-12 00:25:00
110	135	2006-06-11 22:49:53	2006-06-12 00:25:00
110	102	2006-06-11 22:49:53	2006-06-12 00:25:00
110	14	2006-06-11 22:49:53	2006-06-12 00:25:00
110	15	2006-06-11 22:49:53	2006-06-12 00:25:00
110	16	2006-06-11 22:49:53	2006-06-12 00:25:00
110	19	2006-06-11 22:49:53	2006-06-12 00:25:00
110	21	2006-06-11 22:49:53	2006-06-12 00:25:00
110	96	2006-06-11 22:49:53	2006-06-12 00:25:00
110	24	2006-06-11 22:49:53	2006-06-12 00:25:00
110	27	2006-06-11 22:49:53	2006-06-12 00:25:00
110	28	2006-06-11 22:49:53	2006-06-12 00:25:00
110	29	2006-06-11 22:49:53	2006-06-12 00:25:00
110	30	2006-06-11 22:49:53	2006-06-11 23:09:30
110	32	2006-06-11 22:49:53	2006-06-11 23:47:41
110	154	2006-06-11 22:49:53	2006-06-12 00:25:00
110	136	2006-06-11 22:49:53	2006-06-12 00:25:00
110	35	2006-06-11 22:49:53	2006-06-12 00:25:00
110	150	2006-06-11 22:49:53	2006-06-12 00:25:00
110	155	2006-06-11 22:49:53	2006-06-12 00:25:00
110	39	2006-06-11 22:49:53	2006-06-12 00:25:00
110	81	2006-06-11 22:49:53	2006-06-12 00:25:00
110	42	2006-06-11 22:49:53	2006-06-12 00:25:00
110	43	2006-06-11 22:49:53	2006-06-12 00:25:00
110	44	2006-06-11 22:49:53	2006-06-12 00:25:00
110	45	2006-06-11 22:49:53	2006-06-12 00:25:00
110	48	2006-06-11 22:49:53	2006-06-12 00:25:00
110	187	2006-06-11 23:47:49	2006-06-12 00:25:00
110	100	2006-06-11 22:49:53	2006-06-12 00:25:00
110	114	2006-06-11 23:39:42	2006-06-11 23:46:03
110	51	2006-06-11 22:49:53	2006-06-12 00:25:00
110	52	2006-06-11 22:49:53	2006-06-12 00:25:00
110	160	2006-06-11 22:49:53	2006-06-12 00:25:00
110	54	2006-06-11 22:49:53	2006-06-12 00:25:00
110	55	2006-06-11 22:49:53	2006-06-12 00:25:00
110	58	2006-06-11 22:49:53	2006-06-12 00:25:00
110	57	2006-06-11 22:53:58	2006-06-12 00:25:00
110	153	2006-06-11 22:49:53	2006-06-12 00:25:00
110	59	2006-06-11 22:49:53	2006-06-12 00:25:00
110	60	2006-06-11 22:49:53	2006-06-12 00:25:00
116	1	2006-06-12 21:00:00	2006-06-13 00:30:00
116	2	2006-06-12 21:00:00	2006-06-13 00:30:00
116	4	2006-06-12 21:00:00	2006-06-13 00:30:00
116	5	2006-06-12 21:00:00	2006-06-13 00:30:00
116	6	2006-06-12 21:00:00	2006-06-13 00:30:00
116	14	2006-06-12 21:00:00	2006-06-12 23:40:02
116	15	2006-06-12 21:00:00	2006-06-13 00:30:00
116	16	2006-06-12 21:00:00	2006-06-13 00:30:00
116	19	2006-06-12 21:00:00	2006-06-13 00:30:00
116	21	2006-06-12 21:00:00	2006-06-13 00:30:00
116	96	2006-06-12 21:00:00	2006-06-13 00:30:00
116	24	2006-06-12 21:07:24	2006-06-13 00:30:00
116	27	2006-06-12 21:00:00	2006-06-13 00:30:00
116	28	2006-06-12 21:00:00	2006-06-13 00:30:00
116	29	2006-06-12 21:00:00	2006-06-13 00:30:00
116	30	2006-06-12 21:00:00	2006-06-13 00:30:00
116	31	2006-06-13 00:16:23	2006-06-13 00:30:00
116	32	2006-06-12 21:00:00	2006-06-13 00:30:00
116	82	2006-06-12 21:00:00	2006-06-13 00:30:00
116	136	2006-06-12 21:00:00	2006-06-13 00:30:00
116	35	2006-06-12 21:00:00	2006-06-13 00:30:00
116	36	2006-06-12 21:00:00	2006-06-13 00:30:00
116	39	2006-06-12 21:24:21	2006-06-13 00:30:00
116	40	2006-06-12 21:00:00	2006-06-13 00:30:00
116	41	2006-06-12 21:00:00	2006-06-13 00:30:00
116	42	2006-06-12 21:00:00	2006-06-13 00:30:00
116	43	2006-06-12 21:00:00	2006-06-13 00:30:00
116	45	2006-06-12 21:00:00	2006-06-13 00:30:00
116	142	2006-06-12 21:00:00	2006-06-13 00:30:00
116	48	2006-06-12 21:00:00	2006-06-13 00:30:00
116	49	2006-06-12 21:07:24	2006-06-13 00:30:00
116	100	2006-06-12 21:00:00	2006-06-13 00:30:00
116	51	2006-06-12 21:00:00	2006-06-13 00:30:00
116	52	2006-06-12 21:00:00	2006-06-13 00:30:00
116	116	2006-06-12 21:00:00	2006-06-13 00:30:00
116	160	2006-06-12 21:00:00	2006-06-13 00:11:07
116	117	2006-06-12 21:00:00	2006-06-13 00:30:00
116	76	2006-06-12 21:00:00	2006-06-13 00:25:57
116	55	2006-06-12 21:00:00	2006-06-13 00:30:00
116	58	2006-06-12 21:00:00	2006-06-13 00:30:00
116	57	2006-06-12 21:00:00	2006-06-13 00:30:00
116	59	2006-06-12 21:00:00	2006-06-13 00:30:00
116	60	2006-06-12 21:00:00	2006-06-13 00:30:00
109	1	2006-06-11 19:30:00	2006-06-11 22:10:00
109	2	2006-06-11 19:30:00	2006-06-11 22:10:00
109	97	2006-06-11 19:30:00	2006-06-11 20:54:37
109	4	2006-06-11 19:30:00	2006-06-11 22:10:00
109	5	2006-06-11 19:44:11	2006-06-11 22:10:00
109	6	2006-06-11 19:30:00	2006-06-11 22:10:00
109	135	2006-06-11 20:55:19	2006-06-11 22:10:00
109	102	2006-06-11 20:54:22	2006-06-11 22:10:00
109	195	2006-06-11 19:30:29	2006-06-11 22:10:00
109	14	2006-06-11 19:30:00	2006-06-11 22:10:00
109	15	2006-06-11 19:30:00	2006-06-11 22:10:00
109	16	2006-06-11 19:30:00	2006-06-11 22:10:00
109	19	2006-06-11 19:30:00	2006-06-11 22:10:00
109	21	2006-06-11 19:30:00	2006-06-11 22:10:00
109	96	2006-06-11 19:30:00	2006-06-11 22:10:00
109	24	2006-06-11 19:30:00	2006-06-11 22:10:00
109	27	2006-06-11 19:30:00	2006-06-11 22:10:00
109	28	2006-06-11 19:30:00	2006-06-11 22:10:00
109	29	2006-06-11 19:30:00	2006-06-11 22:10:00
109	30	2006-06-11 19:30:00	2006-06-11 22:10:00
109	32	2006-06-11 19:30:00	2006-06-11 22:10:00
109	154	2006-06-11 19:30:00	2006-06-11 22:10:00
109	136	2006-06-11 19:30:00	2006-06-11 22:10:00
109	35	2006-06-11 19:30:00	2006-06-11 22:10:00
109	36	2006-06-11 19:30:00	2006-06-11 22:10:00
109	150	2006-06-11 19:30:00	2006-06-11 22:10:00
109	155	2006-06-11 19:30:00	2006-06-11 22:10:00
109	39	2006-06-11 19:30:00	2006-06-11 22:10:00
109	40	2006-06-11 21:03:43	2006-06-11 22:10:00
109	81	2006-06-11 19:30:00	2006-06-11 22:10:00
109	41	2006-06-11 20:42:29	2006-06-11 22:10:00
109	42	2006-06-11 19:30:00	2006-06-11 22:10:00
109	43	2006-06-11 19:30:00	2006-06-11 22:10:00
109	44	2006-06-11 19:30:00	2006-06-11 22:10:00
109	45	2006-06-11 19:30:00	2006-06-11 22:10:00
109	48	2006-06-11 19:30:00	2006-06-11 22:10:00
109	196	2006-06-11 20:51:51	2006-06-11 20:58:21
109	49	2006-06-11 19:30:00	2006-06-11 22:10:00
109	100	2006-06-11 19:30:00	2006-06-11 22:10:00
109	51	2006-06-11 19:30:00	2006-06-11 22:10:00
109	52	2006-06-11 19:30:00	2006-06-11 22:10:00
109	160	2006-06-11 19:30:00	2006-06-11 22:10:00
109	117	2006-06-11 20:42:07	2006-06-11 20:42:07
109	54	2006-06-11 19:30:00	2006-06-11 22:10:00
109	55	2006-06-11 19:30:00	2006-06-11 22:10:00
109	58	2006-06-11 19:30:00	2006-06-11 22:10:00
109	153	2006-06-11 19:30:00	2006-06-11 22:10:00
109	59	2006-06-11 19:30:00	2006-06-11 22:10:00
109	60	2006-06-11 19:30:00	2006-06-11 22:10:00
113	14	2006-06-13 20:00:00	2006-06-13 23:40:00
113	15	2006-06-13 20:00:00	2006-06-13 23:40:00
113	16	2006-06-13 20:00:00	2006-06-13 23:40:00
113	21	2006-06-13 20:00:00	2006-06-13 23:40:00
113	96	2006-06-13 20:00:00	2006-06-13 23:40:00
113	23	2006-06-13 20:00:00	2006-06-13 23:40:00
113	24	2006-06-13 21:28:39	2006-06-13 23:40:00
113	27	2006-06-13 20:00:00	2006-06-13 23:40:00
113	28	2006-06-13 20:00:00	2006-06-13 23:40:00
113	29	2006-06-13 20:00:00	2006-06-13 23:40:00
113	30	2006-06-13 20:00:00	2006-06-13 23:40:00
113	32	2006-06-13 20:00:00	2006-06-13 23:40:00
113	33	2006-06-13 20:00:00	2006-06-13 23:40:00
113	82	2006-06-13 20:00:00	2006-06-13 23:40:00
113	136	2006-06-13 20:00:00	2006-06-13 21:25:44
113	35	2006-06-13 20:00:00	2006-06-13 23:40:00
113	36	2006-06-13 20:00:00	2006-06-13 23:40:00
113	39	2006-06-13 20:40:09	2006-06-13 23:40:00
113	40	2006-06-13 20:00:00	2006-06-13 23:40:00
113	81	2006-06-13 20:00:00	2006-06-13 23:40:00
113	41	2006-06-13 20:00:00	2006-06-13 23:40:00
113	42	2006-06-13 20:00:00	2006-06-13 23:40:00
113	43	2006-06-13 20:00:00	2006-06-13 23:40:00
113	45	2006-06-13 20:00:00	2006-06-13 23:40:00
113	142	2006-06-13 20:00:00	2006-06-13 23:40:00
113	46	2006-06-13 20:00:00	2006-06-13 23:40:00
113	48	2006-06-13 20:00:00	2006-06-13 23:40:00
113	49	2006-06-13 20:00:00	2006-06-13 23:40:00
113	100	2006-06-13 20:00:00	2006-06-13 23:40:00
113	51	2006-06-13 20:00:00	2006-06-13 23:40:00
113	52	2006-06-13 20:00:00	2006-06-13 23:40:00
113	116	2006-06-13 20:00:00	2006-06-13 23:40:00
113	160	2006-06-13 20:00:00	2006-06-13 23:40:00
113	55	2006-06-13 20:00:00	2006-06-13 23:40:00
113	58	2006-06-13 20:00:00	2006-06-13 23:40:00
113	57	2006-06-13 20:00:00	2006-06-13 23:40:00
113	60	2006-06-13 20:00:00	2006-06-13 23:40:00
118	1	2006-06-18 18:30:00	2006-06-18 23:30:00
118	2	2006-06-18 18:41:25	2006-06-18 23:30:00
118	97	2006-06-18 18:30:00	2006-06-18 23:30:00
118	4	2006-06-18 18:30:00	2006-06-18 23:30:00
118	5	2006-06-18 18:30:00	2006-06-18 23:30:00
118	6	2006-06-18 18:30:00	2006-06-18 22:16:14
118	102	2006-06-18 18:50:54	2006-06-18 20:57:21
118	186	2006-06-18 18:30:00	2006-06-18 23:30:00
118	15	2006-06-18 18:30:00	2006-06-18 23:30:00
118	16	2006-06-18 18:30:00	2006-06-18 23:30:00
118	32	2006-06-18 18:30:00	2006-06-18 23:30:00
118	33	2006-06-18 18:30:00	2006-06-18 23:30:00
118	136	2006-06-18 18:30:00	2006-06-18 23:30:00
118	36	2006-06-18 18:30:00	2006-06-18 23:30:00
118	150	2006-06-18 20:01:26	2006-06-18 23:30:00
118	39	2006-06-18 22:19:39	2006-06-18 23:30:00
118	40	2006-06-18 18:30:00	2006-06-18 23:30:00
118	41	2006-06-18 19:06:49	2006-06-18 23:30:00
118	42	2006-06-18 18:30:00	2006-06-18 23:30:00
118	43	2006-06-18 18:30:00	2006-06-18 23:30:00
118	44	2006-06-18 18:30:00	2006-06-18 23:30:00
118	45	2006-06-18 23:23:42	2006-06-18 23:30:00
118	48	2006-06-18 18:30:00	2006-06-18 23:30:00
118	49	2006-06-18 18:30:00	2006-06-18 23:30:00
118	50	2006-06-18 18:30:00	2006-06-18 21:14:45
118	67	2006-06-18 18:30:00	2006-06-18 23:23:36
118	100	2006-06-18 18:30:00	2006-06-18 23:30:00
118	51	2006-06-18 18:30:00	2006-06-18 23:30:00
118	52	2006-06-18 18:30:00	2006-06-18 23:30:00
118	116	2006-06-18 22:20:39	2006-06-18 23:30:00
118	61	2006-06-18 21:15:06	2006-06-18 23:30:00
118	107	2006-06-18 18:30:00	2006-06-18 23:30:00
118	160	2006-06-18 18:30:00	2006-06-18 23:30:00
118	76	2006-06-18 18:30:00	2006-06-18 23:30:00
118	167	2006-06-18 18:30:00	2006-06-18 22:48:43
118	55	2006-06-18 18:54:13	2006-06-18 23:30:00
118	58	2006-06-18 18:30:00	2006-06-18 23:30:00
118	57	2006-06-18 18:30:00	2006-06-18 23:30:00
118	153	2006-06-18 22:27:05	2006-06-18 23:30:00
118	60	2006-06-18 18:30:00	2006-06-18 23:30:00
111	1	2006-06-17 11:06:32	2006-06-17 16:00:00
111	2	2006-06-17 11:00:00	2006-06-17 16:00:00
111	5	2006-06-17 12:37:02	2006-06-17 14:03:01
111	6	2006-06-17 14:42:37	2006-06-17 16:00:00
111	90	2006-06-17 11:00:00	2006-06-17 16:00:00
111	186	2006-06-17 11:34:38	2006-06-17 16:00:00
111	19	2006-06-17 12:58:35	2006-06-17 16:00:00
111	157	2006-06-17 13:01:46	2006-06-17 14:02:42
111	24	2006-06-17 14:23:32	2006-06-17 16:00:00
111	30	2006-06-17 11:00:00	2006-06-17 16:00:00
111	32	2006-06-17 11:00:00	2006-06-17 16:00:00
111	154	2006-06-17 11:06:24	2006-06-17 15:00:03
111	36	2006-06-17 11:00:00	2006-06-17 16:00:00
111	169	2006-06-17 11:30:42	2006-06-17 16:00:00
111	155	2006-06-17 11:00:00	2006-06-17 16:00:00
111	39	2006-06-17 11:00:00	2006-06-17 14:33:30
111	40	2006-06-17 12:37:34	2006-06-17 13:59:02
111	41	2006-06-17 11:00:00	2006-06-17 16:00:00
111	42	2006-06-17 11:55:41	2006-06-17 14:00:17
111	43	2006-06-17 11:25:50	2006-06-17 16:00:00
111	49	2006-06-17 11:00:00	2006-06-17 16:00:00
111	100	2006-06-17 11:00:00	2006-06-17 16:00:00
111	114	2006-06-17 11:00:00	2006-06-17 16:00:00
111	132	2006-06-17 14:23:07	2006-06-17 15:39:05
111	160	2006-06-17 11:45:29	2006-06-17 16:00:00
111	58	2006-06-17 14:00:59	2006-06-17 16:00:00
111	57	2006-06-17 15:41:31	2006-06-17 16:00:00
117	116	2006-06-17 18:50:31	2006-06-17 23:12:26
117	107	2006-06-17 18:50:31	2006-06-17 22:47:20
117	160	2006-06-17 18:50:31	2006-06-17 23:12:26
117	55	2006-06-17 19:05:11	2006-06-17 23:12:26
117	58	2006-06-17 18:50:31	2006-06-17 23:12:26
117	57	2006-06-17 18:50:31	2006-06-17 23:12:26
117	59	2006-06-17 18:50:31	2006-06-17 23:12:26
120	1	2006-06-21 20:20:38	2006-06-22 01:08:52
120	97	2006-06-21 20:38:53	2006-06-21 22:15:18
120	6	2006-06-21 20:28:01	2006-06-21 21:00:49
120	200	2006-06-21 22:38:29	2006-06-22 01:09:33
120	175	2006-06-21 22:39:09	2006-06-22 01:09:11
120	90	2006-06-21 20:20:38	2006-06-22 01:09:53
120	186	2006-06-21 20:35:02	2006-06-22 00:54:25
120	13	2006-06-21 21:46:32	2006-06-21 23:01:50
123	1	2006-06-19 21:25:35	2006-06-19 23:29:28
123	16	2006-06-19 21:25:35	2006-06-19 23:29:28
123	32	2006-06-19 21:25:35	2006-06-19 23:29:28
123	169	2006-06-19 21:25:35	2006-06-19 23:29:28
123	40	2006-06-19 21:25:35	2006-06-19 23:29:28
123	41	2006-06-19 21:25:35	2006-06-19 23:29:28
123	67	2006-06-19 21:25:35	2006-06-19 23:29:28
114	1	2006-06-14 20:38:12	2006-06-15 00:25:28
114	2	2006-06-14 20:38:24	2006-06-15 00:25:08
114	97	2006-06-14 20:35:39	2006-06-15 00:25:28
114	8	2006-06-14 20:35:39	2006-06-15 00:25:28
114	90	2006-06-14 20:35:39	2006-06-15 00:25:28
114	15	2006-06-14 20:35:39	2006-06-15 00:25:28
114	157	2006-06-14 20:35:46	2006-06-15 00:24:51
114	24	2006-06-14 20:51:49	2006-06-15 00:23:34
114	27	2006-06-14 20:35:39	2006-06-15 00:25:28
114	28	2006-06-14 20:35:39	2006-06-15 00:25:28
114	30	2006-06-14 20:35:39	2006-06-14 23:39:35
114	32	2006-06-14 20:35:39	2006-06-15 00:23:25
114	33	2006-06-14 20:35:39	2006-06-15 00:25:28
114	82	2006-06-14 20:36:53	2006-06-15 00:25:28
114	136	2006-06-14 20:35:39	2006-06-15 00:25:28
114	81	2006-06-14 20:35:39	2006-06-15 00:23:37
114	142	2006-06-14 20:35:39	2006-06-15 00:25:28
114	51	2006-06-14 20:35:39	2006-06-15 00:25:28
114	107	2006-06-14 20:56:45	2006-06-14 21:14:46
114	160	2006-06-15 00:05:56	2006-06-15 00:25:28
114	58	2006-06-14 20:38:47	2006-06-15 00:22:02
114	60	2006-06-14 20:35:39	2006-06-15 00:25:28
124	1	2006-06-15 00:25:42	2006-06-15 02:06:12
124	97	2006-06-15 00:25:42	2006-06-15 01:57:27
124	8	2006-06-15 00:25:42	2006-06-15 02:00:06
124	90	2006-06-15 00:25:42	2006-06-15 02:22:08
124	186	2006-06-15 00:26:29	2006-06-15 02:22:08
124	15	2006-06-15 00:25:42	2006-06-15 02:22:08
124	157	2006-06-15 02:07:07	2006-06-15 02:22:08
124	27	2006-06-15 00:25:42	2006-06-15 02:22:08
124	28	2006-06-15 00:25:42	2006-06-15 02:22:08
124	33	2006-06-15 00:25:42	2006-06-15 02:22:08
124	82	2006-06-15 00:25:42	2006-06-15 02:22:08
124	136	2006-06-15 00:25:42	2006-06-15 02:22:08
124	150	2006-06-15 00:33:52	2006-06-15 02:22:08
124	39	2006-06-15 00:25:51	2006-06-15 02:06:15
124	142	2006-06-15 00:25:42	2006-06-15 02:06:06
124	187	2006-06-15 00:45:42	2006-06-15 02:22:08
124	100	2006-06-15 00:31:52	2006-06-15 00:44:47
124	51	2006-06-15 00:25:42	2006-06-15 02:22:08
124	188	2006-06-15 00:26:56	2006-06-15 02:22:08
124	52	2006-06-15 02:08:04	2006-06-15 02:22:08
124	198	2006-06-15 02:18:30	2006-06-15 02:22:08
124	116	2006-06-15 02:19:41	2006-06-15 02:22:08
124	109	2006-06-15 02:09:02	2006-06-15 02:22:08
124	160	2006-06-15 00:25:42	2006-06-15 02:06:00
124	54	2006-06-15 02:12:19	2006-06-15 02:22:08
124	153	2006-06-15 00:35:31	2006-06-15 02:22:08
124	60	2006-06-15 00:25:42	2006-06-15 02:22:08
120	23	2006-06-21 23:02:59	2006-06-22 01:09:07
120	201	2006-06-21 20:55:55	2006-06-21 23:06:11
120	164	2006-06-21 22:04:25	2006-06-22 01:09:53
120	32	2006-06-21 20:34:00	2006-06-21 23:53:47
120	177	2006-06-21 20:49:00	2006-06-21 22:30:54
120	35	2006-06-21 21:02:04	2006-06-22 01:08:52
120	111	2006-06-21 20:59:51	2006-06-22 01:09:12
120	155	2006-06-21 20:46:06	2006-06-21 23:42:05
123	197	2006-06-19 21:31:00	2006-06-19 21:39:21
120	39	2006-06-21 21:17:15	2006-06-22 01:08:59
120	202	2006-06-21 21:36:37	2006-06-22 01:08:55
120	41	2006-06-21 20:31:36	2006-06-21 20:37:18
120	190	2006-06-21 23:45:36	2006-06-22 01:09:53
120	67	2006-06-21 23:53:57	2006-06-22 01:09:53
122	4	2006-06-19 20:30:00	2006-06-19 21:15:00
122	5	2006-06-19 20:30:00	2006-06-19 21:15:00
122	6	2006-06-19 20:30:00	2006-06-19 21:15:00
122	175	2006-06-19 20:30:00	2006-06-19 21:15:00
122	90	2006-06-19 20:37:45	2006-06-19 21:15:00
122	186	2006-06-19 20:32:02	2006-06-19 21:15:00
122	197	2006-06-19 20:30:46	2006-06-19 20:48:14
122	15	2006-06-19 20:30:00	2006-06-19 21:15:00
122	19	2006-06-19 20:30:00	2006-06-19 21:15:00
122	21	2006-06-19 20:30:00	2006-06-19 21:15:00
122	96	2006-06-19 20:38:48	2006-06-19 21:15:00
122	157	2006-06-19 20:30:16	2006-06-19 21:15:00
122	24	2006-06-19 20:30:00	2006-06-19 21:15:00
122	27	2006-06-19 20:30:00	2006-06-19 21:15:00
122	28	2006-06-19 20:30:00	2006-06-19 21:15:00
122	30	2006-06-19 20:30:00	2006-06-19 21:15:00
122	32	2006-06-19 20:30:00	2006-06-19 21:15:00
122	33	2006-06-19 20:30:00	2006-06-19 21:15:00
122	154	2006-06-19 20:38:33	2006-06-19 21:15:00
122	136	2006-06-19 20:30:00	2006-06-19 21:15:00
122	36	2006-06-19 20:30:00	2006-06-19 21:15:00
122	41	2006-06-19 20:30:00	2006-06-19 21:15:00
122	42	2006-06-19 20:30:00	2006-06-19 21:15:00
122	43	2006-06-19 20:30:00	2006-06-19 21:15:00
122	44	2006-06-19 20:42:16	2006-06-19 21:15:00
122	45	2006-06-19 20:30:00	2006-06-19 21:15:00
122	142	2006-06-19 20:31:44	2006-06-19 21:15:00
122	49	2006-06-19 20:34:35	2006-06-19 21:15:00
122	100	2006-06-19 20:33:25	2006-06-19 21:15:00
122	51	2006-06-19 20:30:00	2006-06-19 21:15:00
122	52	2006-06-19 20:30:00	2006-06-19 21:15:00
122	116	2006-06-19 20:40:09	2006-06-19 21:15:00
122	61	2006-06-19 20:32:56	2006-06-19 21:15:00
122	107	2006-06-19 20:30:00	2006-06-19 21:15:00
122	160	2006-06-19 20:30:00	2006-06-19 21:15:00
122	54	2006-06-19 20:34:11	2006-06-19 21:15:00
122	167	2006-06-19 20:35:19	2006-06-19 21:15:00
122	55	2006-06-19 20:36:01	2006-06-19 21:15:00
122	58	2006-06-19 20:30:00	2006-06-19 21:15:00
122	57	2006-06-19 20:30:00	2006-06-19 21:15:00
122	153	2006-06-19 20:35:21	2006-06-19 21:15:00
120	100	2006-06-21 20:25:35	2006-06-22 01:09:06
120	115	2006-06-21 23:23:37	2006-06-22 01:09:05
120	116	2006-06-21 20:25:20	2006-06-22 01:08:58
120	107	2006-06-21 20:32:32	2006-06-22 01:09:50
120	160	2006-06-21 20:48:22	2006-06-22 01:09:15
120	55	2006-06-21 20:39:16	2006-06-22 01:09:53
120	58	2006-06-21 21:44:47	2006-06-21 21:52:29
123	154	2006-06-19 21:25:35	2006-06-19 22:49:32
120	57	2006-06-21 21:55:42	2006-06-21 23:46:39
120	59	2006-06-21 22:39:13	2006-06-22 01:08:57
130	97	2006-06-23 21:19:31	2006-06-24 01:12:59
130	203	2006-06-23 23:21:57	2006-06-23 23:53:42
130	5	2006-06-23 20:30:11	2006-06-24 01:11:55
130	6	2006-06-23 20:32:34	2006-06-24 01:12:41
130	156	2006-06-23 20:34:05	2006-06-24 01:12:58
130	9	2006-06-23 22:56:37	2006-06-24 01:13:42
130	90	2006-06-23 20:30:02	2006-06-24 01:18:49
130	186	2006-06-23 20:32:25	2006-06-24 01:18:49
130	13	2006-06-23 21:13:33	2006-06-23 21:17:59
130	23	2006-06-23 20:41:07	2006-06-24 01:18:49
130	64	2006-06-23 20:48:19	2006-06-24 01:18:49
130	30	2006-06-23 20:30:02	2006-06-24 01:12:32
130	31	2006-06-23 23:20:39	2006-06-24 00:36:28
130	35	2006-06-23 22:58:29	2006-06-24 01:13:41
130	36	2006-06-23 20:55:37	2006-06-24 01:11:42
130	39	2006-06-23 21:14:10	2006-06-24 01:16:23
130	204	2006-06-23 23:03:12	2006-06-23 23:41:02
130	81	2006-06-23 21:58:55	2006-06-24 01:13:22
130	202	2006-06-23 20:38:18	2006-06-24 01:14:03
123	160	2006-06-19 21:25:35	2006-06-19 23:27:00
130	44	2006-06-23 20:33:06	2006-06-24 01:18:28
123	167	2006-06-19 21:25:35	2006-06-19 23:28:19
123	63	2006-06-19 21:43:18	2006-06-19 23:27:44
130	190	2006-06-23 20:31:49	2006-06-23 23:27:59
130	100	2006-06-23 20:30:02	2006-06-24 01:18:49
130	116	2006-06-23 20:30:02	2006-06-24 01:13:30
130	109	2006-06-23 20:50:28	2006-06-23 21:57:49
130	107	2006-06-23 20:41:31	2006-06-23 22:51:54
123	51	2006-06-19 21:25:35	2006-06-19 23:29:28
123	2	2006-06-19 21:25:35	2006-06-19 23:29:28
123	4	2006-06-19 21:41:01	2006-06-19 23:29:28
123	5	2006-06-19 21:25:35	2006-06-19 23:29:28
123	6	2006-06-19 21:25:35	2006-06-19 23:29:28
123	175	2006-06-19 21:25:35	2006-06-19 23:29:28
123	90	2006-06-19 21:25:35	2006-06-19 23:29:28
123	186	2006-06-19 21:25:35	2006-06-19 23:29:28
123	15	2006-06-19 21:25:35	2006-06-19 23:29:28
123	19	2006-06-19 21:25:35	2006-06-19 23:29:28
123	21	2006-06-19 21:25:35	2006-06-19 23:29:28
123	96	2006-06-19 21:25:35	2006-06-19 23:29:28
123	157	2006-06-19 21:25:35	2006-06-19 23:29:28
123	24	2006-06-19 21:25:35	2006-06-19 23:29:28
123	27	2006-06-19 21:25:35	2006-06-19 23:29:28
123	28	2006-06-19 21:25:35	2006-06-19 23:29:28
123	31	2006-06-19 21:29:53	2006-06-19 23:29:28
123	33	2006-06-19 21:25:35	2006-06-19 23:29:28
123	136	2006-06-19 21:25:35	2006-06-19 23:29:28
123	150	2006-06-19 21:28:40	2006-06-19 23:29:28
123	155	2006-06-19 21:28:47	2006-06-19 23:29:28
123	39	2006-06-19 21:25:35	2006-06-19 23:29:28
123	42	2006-06-19 21:25:35	2006-06-19 23:29:28
123	43	2006-06-19 21:25:35	2006-06-19 23:29:28
123	44	2006-06-19 21:25:35	2006-06-19 23:29:28
123	45	2006-06-19 21:25:35	2006-06-19 23:29:28
123	142	2006-06-19 21:25:35	2006-06-19 23:29:28
123	48	2006-06-19 23:29:28	2006-06-19 23:29:28
123	49	2006-06-19 23:27:53	2006-06-19 23:29:28
123	100	2006-06-19 21:25:35	2006-06-19 23:29:28
123	52	2006-06-19 21:25:35	2006-06-19 23:29:28
123	116	2006-06-19 21:25:35	2006-06-19 23:29:28
123	61	2006-06-19 21:25:35	2006-06-19 23:29:28
123	107	2006-06-19 21:25:35	2006-06-19 23:29:28
123	54	2006-06-19 21:25:35	2006-06-19 23:29:28
123	55	2006-06-19 21:25:35	2006-06-19 23:29:28
123	58	2006-06-19 21:25:35	2006-06-19 23:29:28
123	57	2006-06-19 21:25:35	2006-06-19 23:29:28
123	153	2006-06-19 21:25:35	2006-06-19 23:29:28
123	60	2006-06-19 22:49:41	2006-06-19 23:29:28
119	1	2006-06-19 23:30:08	2006-06-20 01:15:14
119	2	2006-06-19 23:29:28	2006-06-20 01:10:29
119	4	2006-06-19 23:29:28	2006-06-20 01:17:09
119	5	2006-06-19 23:29:28	2006-06-20 01:13:03
119	6	2006-06-19 23:29:28	2006-06-20 01:15:21
119	175	2006-06-19 23:29:28	2006-06-20 01:14:40
119	90	2006-06-19 23:29:28	2006-06-20 01:19:29
119	186	2006-06-19 23:29:28	2006-06-20 01:12:54
119	197	2006-06-19 23:29:28	2006-06-20 01:19:29
119	15	2006-06-19 23:29:28	2006-06-20 01:19:16
119	16	2006-06-19 23:29:29	2006-06-20 01:17:20
119	19	2006-06-19 23:29:28	2006-06-20 01:14:19
119	21	2006-06-19 23:29:28	2006-06-20 01:13:28
119	96	2006-06-19 23:29:28	2006-06-20 01:19:29
119	157	2006-06-19 23:29:28	2006-06-20 01:19:29
119	24	2006-06-19 23:29:28	2006-06-20 01:19:29
119	27	2006-06-19 23:29:28	2006-06-20 01:14:52
119	28	2006-06-19 23:29:28	2006-06-20 01:19:06
119	31	2006-06-19 23:29:28	2006-06-20 01:13:44
119	32	2006-06-19 23:30:07	2006-06-20 01:14:19
119	33	2006-06-19 23:29:28	2006-06-20 01:19:09
119	154	2006-06-19 23:29:28	2006-06-20 01:19:29
119	136	2006-06-19 23:29:28	2006-06-20 01:19:29
119	150	2006-06-19 23:29:28	2006-06-20 01:16:31
119	169	2006-06-19 23:41:19	2006-06-20 01:14:46
119	155	2006-06-19 23:29:28	2006-06-20 01:12:38
119	39	2006-06-19 23:29:28	2006-06-20 01:12:44
119	40	2006-06-19 23:30:10	2006-06-20 01:14:22
119	41	2006-06-19 23:29:34	2006-06-20 01:19:29
119	42	2006-06-19 23:29:28	2006-06-20 01:16:04
119	43	2006-06-19 23:29:28	2006-06-20 01:14:25
119	44	2006-06-19 23:29:28	2006-06-20 01:19:29
119	45	2006-06-19 23:29:28	2006-06-20 01:19:29
119	142	2006-06-19 23:29:28	2006-06-20 01:19:29
119	48	2006-06-19 23:29:28	2006-06-20 01:19:29
119	49	2006-06-19 23:29:28	2006-06-20 01:15:05
119	67	2006-06-19 23:42:07	2006-06-20 01:15:03
119	100	2006-06-19 23:29:28	2006-06-20 01:12:47
119	51	2006-06-19 23:30:04	2006-06-20 01:19:29
119	52	2006-06-19 23:29:28	2006-06-20 01:14:56
119	116	2006-06-19 23:29:28	2006-06-20 01:18:51
119	61	2006-06-19 23:29:28	2006-06-19 23:42:53
119	107	2006-06-19 23:29:28	2006-06-20 01:19:29
119	160	2006-06-19 23:29:28	2006-06-20 01:19:29
119	54	2006-06-19 23:29:28	2006-06-19 23:41:03
119	167	2006-06-19 23:29:28	2006-06-20 01:19:29
119	63	2006-06-19 23:29:28	2006-06-20 01:19:29
119	55	2006-06-19 23:29:28	2006-06-20 01:19:29
119	58	2006-06-19 23:29:28	2006-06-20 01:19:29
119	57	2006-06-19 23:29:28	2006-06-20 01:12:32
119	153	2006-06-19 23:29:28	2006-06-20 01:16:24
119	60	2006-06-19 23:29:28	2006-06-20 01:19:09
130	160	2006-06-23 20:30:02	2006-06-24 01:13:48
130	205	2006-06-23 21:02:10	2006-06-24 01:18:49
130	55	2006-06-23 20:45:11	2006-06-23 22:52:29
126	1	2006-06-24 14:46:55	2006-06-24 16:00:00
126	2	2006-06-24 11:00:00	2006-06-24 16:00:00
126	156	2006-06-24 14:27:39	2006-06-24 16:00:00
126	8	2006-06-24 11:03:25	2006-06-24 16:00:00
126	90	2006-06-24 11:00:00	2006-06-24 16:00:00
126	186	2006-06-24 11:00:00	2006-06-24 14:10:11
126	123	2006-06-24 11:00:00	2006-06-24 16:00:00
126	30	2006-06-24 11:00:00	2006-06-24 16:00:00
126	164	2006-06-24 11:00:00	2006-06-24 11:50:57
126	32	2006-06-24 11:00:00	2006-06-24 16:00:00
126	177	2006-06-24 15:21:15	2006-06-24 16:00:00
126	136	2006-06-24 11:00:00	2006-06-24 16:00:00
126	36	2006-06-24 11:00:00	2006-06-24 16:00:00
126	155	2006-06-24 11:00:00	2006-06-24 16:00:00
126	39	2006-06-24 11:00:00	2006-06-24 14:46:01
126	81	2006-06-24 11:50:50	2006-06-24 14:24:06
126	44	2006-06-24 11:00:00	2006-06-24 16:00:00
126	48	2006-06-24 14:09:57	2006-06-24 15:15:19
126	49	2006-06-24 14:01:07	2006-06-24 16:00:00
126	100	2006-06-24 11:00:00	2006-06-24 16:00:00
126	114	2006-06-24 11:00:00	2006-06-24 16:00:00
126	51	2006-06-24 11:00:00	2006-06-24 16:00:00
126	107	2006-06-24 11:00:00	2006-06-24 15:15:26
126	160	2006-06-24 11:00:00	2006-06-24 16:00:00
126	54	2006-06-24 11:00:00	2006-06-24 15:15:10
126	60	2006-06-24 11:00:00	2006-06-24 16:00:00
127	2	2006-06-24 19:00:00	2006-06-24 23:20:00
127	97	2006-06-24 20:50:59	2006-06-24 23:20:00
127	206	2006-06-24 19:00:00	2006-06-24 22:23:01
127	189	2006-06-24 19:00:00	2006-06-24 20:50:51
127	135	2006-06-24 19:00:00	2006-06-24 23:20:00
127	8	2006-06-24 19:00:00	2006-06-24 23:20:00
127	175	2006-06-24 19:00:00	2006-06-24 23:20:00
127	90	2006-06-24 19:00:00	2006-06-24 23:20:00
127	15	2006-06-24 19:00:00	2006-06-24 23:20:00
127	16	2006-06-24 19:00:00	2006-06-24 23:20:00
127	123	2006-06-24 19:00:00	2006-06-24 23:20:00
127	26	2006-06-24 22:38:02	2006-06-24 23:20:00
127	64	2006-06-24 19:00:00	2006-06-24 23:20:00
127	27	2006-06-24 19:00:00	2006-06-24 23:20:00
127	31	2006-06-24 19:00:00	2006-06-24 23:20:00
127	164	2006-06-24 19:00:00	2006-06-24 21:36:14
127	33	2006-06-24 21:22:29	2006-06-24 21:35:12
127	119	2006-06-24 19:00:00	2006-06-24 23:20:00
127	154	2006-06-24 19:00:00	2006-06-24 23:20:00
127	136	2006-06-24 19:00:00	2006-06-24 23:20:00
127	35	2006-06-24 19:00:00	2006-06-24 23:20:00
127	150	2006-06-24 19:00:00	2006-06-24 23:20:00
127	169	2006-06-24 22:04:45	2006-06-24 23:20:00
127	39	2006-06-24 21:58:46	2006-06-24 23:20:00
127	42	2006-06-24 22:25:52	2006-06-24 23:20:00
127	44	2006-06-24 19:00:00	2006-06-24 23:20:00
127	45	2006-06-24 19:00:00	2006-06-24 23:20:00
127	142	2006-06-24 19:00:00	2006-06-24 23:04:04
127	190	2006-06-24 19:00:00	2006-06-24 23:20:00
127	100	2006-06-24 19:00:00	2006-06-24 23:20:00
127	51	2006-06-24 19:22:07	2006-06-24 23:20:00
127	207	2006-06-24 19:00:00	2006-06-24 23:20:00
127	165	2006-06-24 19:00:00	2006-06-24 23:20:00
127	52	2006-06-24 19:00:00	2006-06-24 23:20:00
127	72	2006-06-24 19:00:00	2006-06-24 23:20:00
127	116	2006-06-24 19:00:00	2006-06-24 23:20:00
127	107	2006-06-24 19:00:00	2006-06-24 23:20:00
127	160	2006-06-24 19:00:00	2006-06-24 23:20:00
127	54	2006-06-24 19:00:00	2006-06-24 22:19:40
127	89	2006-06-24 19:00:00	2006-06-24 23:20:00
127	63	2006-06-24 19:00:00	2006-06-24 23:20:00
127	55	2006-06-24 19:00:00	2006-06-24 21:36:52
127	58	2006-06-24 19:00:00	2006-06-24 23:20:00
127	85	2006-06-24 19:00:00	2006-06-24 23:20:00
127	57	2006-06-24 19:00:00	2006-06-24 23:20:00
127	60	2006-06-24 19:00:00	2006-06-24 23:20:00
128	1	2006-06-25 18:30:00	2006-06-25 23:36:08
128	2	2006-06-25 18:30:00	2006-06-25 18:53:11
128	4	2006-06-25 18:30:00	2006-06-25 23:50:00
128	5	2006-06-25 18:30:00	2006-06-25 23:50:00
128	6	2006-06-25 18:30:00	2006-06-25 23:50:00
128	135	2006-06-25 18:38:47	2006-06-25 23:50:00
128	8	2006-06-25 18:30:00	2006-06-25 23:50:00
128	14	2006-06-25 18:30:00	2006-06-25 21:38:53
128	15	2006-06-25 18:30:00	2006-06-25 23:50:00
128	21	2006-06-25 18:30:00	2006-06-25 23:50:00
128	96	2006-06-25 18:30:00	2006-06-25 23:50:00
128	24	2006-06-25 18:30:00	2006-06-25 23:50:00
128	27	2006-06-25 18:30:00	2006-06-25 23:50:00
128	28	2006-06-25 18:30:00	2006-06-25 23:50:00
128	30	2006-06-25 18:30:00	2006-06-25 23:50:00
128	32	2006-06-25 18:30:00	2006-06-25 23:50:00
128	33	2006-06-25 18:30:00	2006-06-25 23:50:00
128	154	2006-06-25 22:34:56	2006-06-25 23:50:00
128	136	2006-06-25 18:30:00	2006-06-25 23:50:00
128	35	2006-06-25 18:30:00	2006-06-25 23:50:00
128	36	2006-06-25 18:30:00	2006-06-25 23:50:00
128	38	2006-06-25 18:30:00	2006-06-25 23:50:00
128	155	2006-06-25 18:32:58	2006-06-25 23:50:00
128	39	2006-06-25 18:30:00	2006-06-25 23:50:00
128	40	2006-06-25 18:30:00	2006-06-25 23:50:00
128	41	2006-06-25 18:30:00	2006-06-25 23:50:00
128	42	2006-06-25 18:30:00	2006-06-25 23:50:00
128	43	2006-06-25 18:30:00	2006-06-25 23:37:41
128	45	2006-06-25 20:17:11	2006-06-25 23:50:00
128	142	2006-06-25 18:30:00	2006-06-25 23:50:00
128	48	2006-06-25 18:30:00	2006-06-25 23:50:00
128	187	2006-06-25 18:57:52	2006-06-25 23:50:00
128	49	2006-06-25 18:30:00	2006-06-25 23:50:00
128	67	2006-06-25 18:30:00	2006-06-25 23:50:00
128	100	2006-06-25 18:30:00	2006-06-25 23:50:00
128	51	2006-06-25 18:30:00	2006-06-25 23:50:00
128	52	2006-06-25 18:30:00	2006-06-25 23:50:00
128	116	2006-06-25 18:30:00	2006-06-25 23:50:00
128	61	2006-06-25 22:18:47	2006-06-25 22:33:41
128	107	2006-06-25 18:30:00	2006-06-25 23:50:00
128	160	2006-06-25 18:30:00	2006-06-25 21:59:37
128	205	2006-06-25 19:11:22	2006-06-25 23:50:00
128	58	2006-06-25 18:30:00	2006-06-25 23:50:00
128	57	2006-06-25 18:30:00	2006-06-25 23:50:00
128	60	2006-06-25 18:30:00	2006-06-25 23:50:00
125	1	2006-06-20 20:45:27	2006-06-21 00:20:06
125	2	2006-06-20 20:48:52	2006-06-21 00:20:06
125	4	2006-06-20 20:45:27	2006-06-21 00:20:06
125	5	2006-06-20 20:45:27	2006-06-21 00:19:33
125	6	2006-06-20 20:49:21	2006-06-21 00:20:06
125	7	2006-06-20 23:29:25	2006-06-21 00:20:05
125	135	2006-06-20 20:45:27	2006-06-20 23:10:28
125	8	2006-06-20 21:12:13	2006-06-21 00:19:11
125	186	2006-06-20 21:59:44	2006-06-20 23:12:15
125	15	2006-06-20 20:45:27	2006-06-21 00:20:06
125	16	2006-06-20 21:57:04	2006-06-21 00:20:06
125	21	2006-06-20 20:45:27	2006-06-21 00:19:21
125	96	2006-06-20 20:49:37	2006-06-21 00:20:06
125	23	2006-06-20 20:45:27	2006-06-21 00:20:06
125	27	2006-06-20 20:45:27	2006-06-21 00:20:06
125	28	2006-06-20 20:45:27	2006-06-21 00:19:59
125	30	2006-06-20 20:45:27	2006-06-21 00:20:06
125	31	2006-06-20 21:55:52	2006-06-21 00:19:03
125	32	2006-06-20 20:45:27	2006-06-21 00:19:15
125	33	2006-06-20 21:46:28	2006-06-21 00:20:06
125	136	2006-06-20 20:45:27	2006-06-21 00:20:06
125	35	2006-06-20 20:45:27	2006-06-21 00:19:46
125	36	2006-06-20 21:00:35	2006-06-21 00:20:06
125	39	2006-06-20 21:17:57	2006-06-21 00:20:06
125	40	2006-06-20 20:45:27	2006-06-21 00:20:06
125	81	2006-06-20 20:45:27	2006-06-21 00:01:54
125	41	2006-06-20 20:45:47	2006-06-21 00:19:21
125	42	2006-06-20 20:45:27	2006-06-21 00:20:06
125	43	2006-06-20 20:45:27	2006-06-21 00:20:06
125	44	2006-06-20 21:12:37	2006-06-20 21:53:21
125	45	2006-06-20 20:45:27	2006-06-21 00:20:06
125	142	2006-06-20 20:45:27	2006-06-21 00:20:05
125	48	2006-06-20 20:45:27	2006-06-21 00:20:06
125	49	2006-06-20 20:45:27	2006-06-21 00:18:16
125	100	2006-06-20 20:45:27	2006-06-21 00:20:06
125	51	2006-06-20 20:45:27	2006-06-21 00:20:06
125	52	2006-06-20 20:45:27	2006-06-21 00:20:06
125	116	2006-06-20 20:45:27	2006-06-21 00:17:35
125	61	2006-06-20 20:45:27	2006-06-21 00:20:06
125	107	2006-06-20 20:45:27	2006-06-21 00:20:06
125	55	2006-06-20 20:45:27	2006-06-21 00:20:06
125	58	2006-06-20 20:49:18	2006-06-21 00:18:35
125	57	2006-06-20 20:45:27	2006-06-21 00:20:06
125	60	2006-06-20 20:45:27	2006-06-21 00:19:16
131	5	2006-06-26 21:00:00	2006-06-26 21:30:00
131	6	2006-06-26 21:00:00	2006-06-26 21:30:00
131	135	2006-06-26 21:00:00	2006-06-26 21:30:00
131	8	2006-06-26 21:00:00	2006-06-26 21:30:00
131	175	2006-06-26 21:00:00	2006-06-26 21:30:00
131	14	2006-06-26 21:00:00	2006-06-26 21:30:00
131	15	2006-06-26 21:00:00	2006-06-26 21:30:00
131	16	2006-06-26 21:00:00	2006-06-26 21:30:00
131	21	2006-06-26 21:00:00	2006-06-26 21:30:00
131	96	2006-06-26 21:00:00	2006-06-26 21:30:00
131	23	2006-06-26 21:00:00	2006-06-26 21:30:00
131	24	2006-06-26 21:00:00	2006-06-26 21:30:00
131	27	2006-06-26 21:00:00	2006-06-26 21:30:00
131	28	2006-06-26 21:00:00	2006-06-26 21:30:00
131	30	2006-06-26 21:00:00	2006-06-26 21:30:00
131	32	2006-06-26 21:00:00	2006-06-26 21:30:00
131	33	2006-06-26 21:00:00	2006-06-26 21:30:00
131	154	2006-06-26 21:00:00	2006-06-26 21:30:00
131	136	2006-06-26 21:00:00	2006-06-26 21:30:00
131	35	2006-06-26 21:00:00	2006-06-26 21:30:00
131	41	2006-06-26 21:00:00	2006-06-26 21:30:00
131	42	2006-06-26 21:00:00	2006-06-26 21:30:00
131	43	2006-06-26 21:00:00	2006-06-26 21:30:00
131	45	2006-06-26 21:00:00	2006-06-26 21:30:00
131	142	2006-06-26 21:00:00	2006-06-26 21:30:00
131	48	2006-06-26 21:00:00	2006-06-26 21:30:00
131	49	2006-06-26 21:00:00	2006-06-26 21:30:00
131	67	2006-06-26 21:00:00	2006-06-26 21:30:00
131	100	2006-06-26 21:00:00	2006-06-26 21:30:00
131	51	2006-06-26 21:00:00	2006-06-26 21:30:00
131	115	2006-06-26 21:00:00	2006-06-26 21:30:00
131	116	2006-06-26 21:00:00	2006-06-26 21:30:00
131	61	2006-06-26 21:00:00	2006-06-26 21:29:50
131	107	2006-06-26 21:00:00	2006-06-26 21:30:00
131	160	2006-06-26 21:00:00	2006-06-26 21:30:00
131	55	2006-06-26 21:00:00	2006-06-26 21:30:00
131	58	2006-06-26 21:00:00	2006-06-26 21:30:00
131	57	2006-06-26 21:00:00	2006-06-26 21:30:00
131	153	2006-06-26 21:00:00	2006-06-26 21:30:00
131	60	2006-06-26 21:00:00	2006-06-26 21:30:00
129	1	2006-06-27 21:18:23	2006-06-28 00:57:23
129	2	2006-06-27 21:56:05	2006-06-28 00:57:23
129	97	2006-06-27 23:25:13	2006-06-28 00:57:23
129	4	2006-06-27 21:18:23	2006-06-28 00:57:23
129	5	2006-06-27 21:18:23	2006-06-28 00:57:23
129	6	2006-06-27 21:18:23	2006-06-28 00:57:23
129	135	2006-06-27 21:18:23	2006-06-27 22:57:05
129	14	2006-06-27 21:18:23	2006-06-27 23:42:47
129	208	2006-06-27 21:18:23	2006-06-27 22:41:51
129	15	2006-06-27 21:18:23	2006-06-28 00:57:23
129	16	2006-06-27 21:18:23	2006-06-28 00:57:23
129	21	2006-06-27 21:18:23	2006-06-28 00:57:23
129	96	2006-06-27 21:18:23	2006-06-28 00:57:23
129	23	2006-06-27 21:18:23	2006-06-28 00:57:23
129	24	2006-06-27 22:20:15	2006-06-28 00:57:23
129	27	2006-06-27 21:18:23	2006-06-28 00:57:23
129	28	2006-06-27 21:18:23	2006-06-28 00:57:23
129	30	2006-06-27 21:18:23	2006-06-28 00:57:23
129	32	2006-06-27 21:18:23	2006-06-28 00:57:23
129	33	2006-06-27 21:18:23	2006-06-28 00:57:23
129	154	2006-06-27 21:44:47	2006-06-28 00:57:23
129	136	2006-06-27 21:18:23	2006-06-28 00:57:23
129	35	2006-06-27 21:18:23	2006-06-28 00:57:23
129	36	2006-06-27 21:18:23	2006-06-28 00:57:23
129	150	2006-06-27 21:18:23	2006-06-28 00:57:23
129	155	2006-06-27 21:18:23	2006-06-28 00:57:23
129	39	2006-06-27 21:18:23	2006-06-28 00:57:23
129	40	2006-06-27 21:18:23	2006-06-28 00:57:23
129	209	2006-06-27 22:50:04	2006-06-28 00:57:23
129	81	2006-06-27 21:18:23	2006-06-27 22:17:53
129	41	2006-06-27 21:18:23	2006-06-28 00:57:23
129	42	2006-06-27 21:18:23	2006-06-28 00:57:23
129	43	2006-06-27 21:18:23	2006-06-28 00:57:23
129	45	2006-06-27 23:42:32	2006-06-28 00:57:23
129	142	2006-06-27 21:18:23	2006-06-28 00:57:23
129	48	2006-06-27 21:18:23	2006-06-28 00:57:23
129	49	2006-06-27 21:18:23	2006-06-28 00:57:23
129	100	2006-06-27 21:18:23	2006-06-27 21:42:28
129	51	2006-06-27 21:18:23	2006-06-28 00:57:23
129	52	2006-06-27 21:18:23	2006-06-28 00:57:23
129	210	2006-06-27 23:45:29	2006-06-28 00:57:23
129	116	2006-06-27 21:18:23	2006-06-27 23:36:44
129	61	2006-06-27 21:18:23	2006-06-27 22:48:31
129	160	2006-06-27 21:18:23	2006-06-27 21:55:00
129	76	2006-06-27 21:18:23	2006-06-28 00:57:23
129	58	2006-06-27 21:18:23	2006-06-28 00:57:23
129	57	2006-06-27 21:18:23	2006-06-28 00:56:47
129	56	2006-06-27 21:18:23	2006-06-27 22:20:09
129	60	2006-06-27 21:18:23	2006-06-28 00:57:23
133	90	2006-06-28 21:30:00	2006-06-28 22:30:00
133	211	2006-06-28 21:30:00	2006-06-28 22:30:00
133	123	2006-06-28 22:08:30	2006-06-28 22:30:00
133	30	2006-06-28 21:30:00	2006-06-28 22:30:00
133	32	2006-06-28 21:30:00	2006-06-28 22:30:00
133	177	2006-06-28 22:13:25	2006-06-28 22:30:00
133	133	2006-06-28 22:24:03	2006-06-28 22:30:00
133	170	2006-06-28 21:54:16	2006-06-28 22:30:00
133	45	2006-06-28 21:30:00	2006-06-28 22:30:00
133	100	2006-06-28 21:30:00	2006-06-28 22:30:00
133	61	2006-06-28 21:42:07	2006-06-28 22:30:00
133	212	2006-06-28 21:30:00	2006-06-28 22:30:00
133	58	2006-06-28 21:30:00	2006-06-28 22:30:00
132	1	2006-06-27 00:03:35	2006-06-27 00:03:35
132	2	2006-06-26 21:37:22	2006-06-26 23:12:32
132	4	2006-06-26 21:37:22	2006-06-27 00:03:35
132	5	2006-06-26 21:37:22	2006-06-27 00:03:35
132	6	2006-06-26 21:37:22	2006-06-27 00:03:35
132	135	2006-06-26 21:37:22	2006-06-27 00:03:35
132	8	2006-06-26 21:37:22	2006-06-26 23:58:59
132	175	2006-06-26 21:37:22	2006-06-27 00:03:24
132	186	2006-06-26 21:53:09	2006-06-27 00:03:35
132	13	2006-06-26 21:54:34	2006-06-26 22:03:24
132	208	2006-06-26 21:37:22	2006-06-27 00:03:35
132	15	2006-06-26 21:41:02	2006-06-27 00:03:35
132	16	2006-06-26 21:37:22	2006-06-27 00:03:35
132	21	2006-06-26 21:37:22	2006-06-27 00:03:35
132	96	2006-06-26 21:37:22	2006-06-27 00:03:35
132	24	2006-06-26 21:37:22	2006-06-27 00:00:52
132	27	2006-06-26 21:37:22	2006-06-27 00:03:35
132	28	2006-06-26 21:37:22	2006-06-27 00:03:35
132	31	2006-06-26 23:16:49	2006-06-27 00:03:35
132	32	2006-06-26 21:37:22	2006-06-27 00:03:35
132	33	2006-06-26 21:41:25	2006-06-27 00:03:35
132	154	2006-06-26 21:37:22	2006-06-27 00:03:35
132	136	2006-06-26 21:37:22	2006-06-27 00:03:35
132	35	2006-06-26 21:37:22	2006-06-27 00:03:35
132	150	2006-06-26 21:37:22	2006-06-27 00:03:35
132	155	2006-06-26 22:09:21	2006-06-27 00:03:35
132	39	2006-06-26 21:59:05	2006-06-27 00:03:35
132	40	2006-06-27 00:02:04	2006-06-27 00:03:35
132	41	2006-06-26 21:37:22	2006-06-27 00:03:35
132	42	2006-06-26 21:37:22	2006-06-27 00:03:35
132	43	2006-06-26 21:37:22	2006-06-27 00:03:35
132	45	2006-06-26 21:37:22	2006-06-27 00:03:35
132	142	2006-06-26 21:37:22	2006-06-27 00:03:35
132	190	2006-06-26 21:37:22	2006-06-27 00:01:00
132	131	2006-06-26 21:37:22	2006-06-27 00:03:35
132	48	2006-06-26 21:37:22	2006-06-27 00:03:35
132	49	2006-06-26 21:37:22	2006-06-27 00:03:35
132	67	2006-06-26 21:42:54	2006-06-27 00:03:35
132	100	2006-06-26 21:37:22	2006-06-27 00:03:35
132	51	2006-06-26 21:42:38	2006-06-27 00:03:35
132	207	2006-06-26 21:55:35	2006-06-27 00:03:35
132	115	2006-06-26 21:37:22	2006-06-27 00:03:35
132	107	2006-06-26 21:37:22	2006-06-27 00:03:35
132	160	2006-06-26 21:37:22	2006-06-27 00:03:35
132	205	2006-06-26 21:37:22	2006-06-27 00:03:35
132	55	2006-06-26 21:37:22	2006-06-27 00:03:35
132	58	2006-06-26 21:37:22	2006-06-27 00:03:35
132	57	2006-06-26 21:37:22	2006-06-27 00:03:35
132	153	2006-06-26 21:37:22	2006-06-27 00:03:35
132	60	2006-06-26 21:37:22	2006-06-27 00:03:35
137	1	2006-06-30 20:32:34	2006-07-01 00:19:53
137	2	2006-06-30 20:26:31	2006-07-01 00:18:19
137	5	2006-06-30 20:29:00	2006-07-01 00:18:34
137	6	2006-06-30 22:39:07	2006-07-01 00:19:01
137	200	2006-06-30 20:49:04	2006-07-01 00:19:58
137	135	2006-06-30 23:05:34	2006-07-01 00:19:37
137	90	2006-06-30 20:26:31	2006-07-01 00:19:58
137	186	2006-06-30 22:37:39	2006-07-01 00:17:51
137	27	2006-06-30 20:54:44	2006-07-01 00:19:58
137	31	2006-06-30 22:27:43	2006-07-01 00:14:45
137	164	2006-06-30 22:48:25	2006-07-01 00:19:31
137	32	2006-06-30 20:26:31	2006-06-30 22:41:02
137	136	2006-06-30 20:29:23	2006-07-01 00:19:58
137	39	2006-06-30 22:18:29	2006-06-30 22:42:22
137	174	2006-06-30 21:38:09	2006-07-01 00:19:58
137	142	2006-06-30 20:27:04	2006-07-01 00:19:58
137	100	2006-06-30 20:36:23	2006-06-30 22:49:13
137	51	2006-06-30 20:44:15	2006-07-01 00:19:58
137	72	2006-06-30 20:59:29	2006-07-01 00:19:58
137	116	2006-06-30 20:26:31	2006-07-01 00:19:58
137	61	2006-06-30 20:58:38	2006-06-30 22:14:06
137	160	2006-06-30 20:26:31	2006-07-01 00:19:40
137	153	2006-06-30 22:43:33	2006-07-01 00:19:41
137	60	2006-06-30 20:56:41	2006-07-01 00:19:58
139	2	2006-07-01 19:13:43	2006-07-01 22:29:48
139	6	2006-07-01 19:13:39	2006-07-01 21:46:05
139	175	2006-07-01 19:13:39	2006-07-01 22:29:48
139	90	2006-07-01 19:13:39	2006-07-01 22:30:30
139	214	2006-07-01 21:55:21	2006-07-01 22:30:03
139	96	2006-07-01 21:57:06	2006-07-01 22:30:06
139	64	2006-07-01 19:13:39	2006-07-01 22:30:16
139	27	2006-07-01 19:13:39	2006-07-01 22:29:23
139	28	2006-07-01 19:13:39	2006-07-01 22:29:36
139	154	2006-07-01 19:29:38	2006-07-01 20:30:11
139	136	2006-07-01 19:13:39	2006-07-01 22:30:08
139	39	2006-07-01 19:13:39	2006-07-01 22:30:30
139	81	2006-07-01 19:13:39	2006-07-01 19:18:30
139	45	2006-07-01 19:13:39	2006-07-01 22:30:30
139	190	2006-07-01 19:14:12	2006-07-01 22:30:30
139	187	2006-07-01 19:13:39	2006-07-01 22:30:30
139	51	2006-07-01 19:21:12	2006-07-01 22:29:22
139	115	2006-07-01 20:59:36	2006-07-01 21:49:15
139	61	2006-07-01 20:21:20	2006-07-01 20:44:48
139	109	2006-07-01 19:20:02	2006-07-01 21:45:18
139	107	2006-07-01 19:13:39	2006-07-01 20:50:42
139	167	2006-07-01 19:13:39	2006-07-01 22:30:30
139	212	2006-07-01 21:49:49	2006-07-01 22:29:56
139	63	2006-07-01 19:13:39	2006-07-01 22:29:48
139	57	2006-07-01 19:13:39	2006-07-01 22:29:48
139	153	2006-07-01 20:54:38	2006-07-01 22:29:58
139	60	2006-07-01 19:13:39	2006-07-01 22:30:30
145	4	2006-07-03 21:30:00	2006-07-03 21:56:30
145	6	2006-07-03 21:30:00	2006-07-03 22:00:00
145	156	2006-07-03 21:30:00	2006-07-03 22:00:00
145	8	2006-07-03 21:30:00	2006-07-03 22:00:00
145	175	2006-07-03 21:30:00	2006-07-03 22:00:00
145	197	2006-07-03 21:30:00	2006-07-03 22:00:00
145	14	2006-07-03 21:30:00	2006-07-03 22:00:00
145	15	2006-07-03 21:30:00	2006-07-03 22:00:00
145	16	2006-07-03 21:30:00	2006-07-03 22:00:00
145	24	2006-07-03 21:30:00	2006-07-03 22:00:00
145	64	2006-07-03 21:30:00	2006-07-03 22:00:00
145	27	2006-07-03 21:30:00	2006-07-03 22:00:00
145	28	2006-07-03 21:30:00	2006-07-03 22:00:00
145	30	2006-07-03 21:30:00	2006-07-03 22:00:00
145	31	2006-07-03 21:30:00	2006-07-03 22:00:00
145	32	2006-07-03 21:30:00	2006-07-03 22:00:00
145	154	2006-07-03 21:30:00	2006-07-03 22:00:00
145	136	2006-07-03 21:30:00	2006-07-03 22:00:00
145	36	2006-07-03 21:30:00	2006-07-03 22:00:00
145	150	2006-07-03 21:30:00	2006-07-03 22:00:00
145	155	2006-07-03 21:30:00	2006-07-03 22:00:00
145	39	2006-07-03 21:30:00	2006-07-03 22:00:00
145	40	2006-07-03 21:30:00	2006-07-03 22:00:00
145	41	2006-07-03 21:30:00	2006-07-03 22:00:00
145	43	2006-07-03 21:30:00	2006-07-03 22:00:00
145	129	2006-07-03 21:30:00	2006-07-03 22:00:00
145	45	2006-07-03 21:30:00	2006-07-03 22:00:00
145	48	2006-07-03 21:30:00	2006-07-03 22:00:00
145	100	2006-07-03 21:30:00	2006-07-03 22:00:00
145	51	2006-07-03 21:30:00	2006-07-03 22:00:00
145	52	2006-07-03 21:30:00	2006-07-03 22:00:00
145	116	2006-07-03 21:30:00	2006-07-03 22:00:00
145	171	2006-07-03 21:30:00	2006-07-03 22:00:00
145	160	2006-07-03 21:30:00	2006-07-03 22:00:00
145	76	2006-07-03 21:30:00	2006-07-03 22:00:00
145	167	2006-07-03 21:30:00	2006-07-03 22:00:00
145	63	2006-07-03 21:30:00	2006-07-03 22:00:00
145	55	2006-07-03 21:30:00	2006-07-03 22:00:00
145	58	2006-07-03 21:30:00	2006-07-03 22:00:00
145	57	2006-07-03 21:30:00	2006-07-03 22:00:00
145	60	2006-07-03 21:30:00	2006-07-03 22:00:00
143	216	2006-07-06 21:30:00	2006-07-07 00:30:00
143	1	2006-07-06 21:30:00	2006-07-06 23:14:31
143	2	2006-07-06 21:30:00	2006-07-07 00:30:00
143	97	2006-07-06 21:30:00	2006-07-07 00:30:00
143	4	2006-07-06 21:30:00	2006-07-06 23:31:15
143	206	2006-07-06 23:14:38	2006-07-07 00:30:00
143	5	2006-07-06 21:30:00	2006-07-07 00:30:00
143	200	2006-07-06 21:30:00	2006-07-07 00:30:00
143	8	2006-07-06 21:30:00	2006-07-06 23:31:22
143	90	2006-07-06 21:30:00	2006-07-07 00:30:00
143	186	2006-07-06 22:40:17	2006-07-07 00:26:17
143	13	2006-07-07 00:25:20	2006-07-07 00:30:00
143	217	2006-07-07 00:03:02	2006-07-07 00:30:00
143	15	2006-07-06 21:30:00	2006-07-07 00:30:00
143	16	2006-07-06 21:30:00	2006-07-07 00:30:00
143	123	2006-07-06 21:30:00	2006-07-07 00:30:00
143	21	2006-07-06 21:30:00	2006-07-06 22:26:56
143	24	2006-07-06 21:30:00	2006-07-07 00:30:00
143	27	2006-07-06 21:30:00	2006-07-07 00:30:00
143	30	2006-07-06 21:30:00	2006-07-07 00:30:00
143	32	2006-07-06 21:30:00	2006-07-06 23:10:33
143	33	2006-07-06 21:30:00	2006-07-07 00:30:00
143	154	2006-07-06 21:30:00	2006-07-07 00:30:00
143	136	2006-07-06 21:30:00	2006-07-07 00:30:00
143	36	2006-07-06 21:30:00	2006-07-07 00:30:00
143	155	2006-07-06 21:30:00	2006-07-07 00:30:00
143	39	2006-07-06 21:30:00	2006-07-07 00:30:00
143	40	2006-07-06 21:30:00	2006-07-07 00:30:00
143	41	2006-07-06 21:30:00	2006-07-07 00:30:00
143	42	2006-07-06 22:21:38	2006-07-07 00:30:00
143	43	2006-07-06 21:30:00	2006-07-07 00:30:00
143	142	2006-07-06 21:30:00	2006-07-07 00:30:00
143	219	2006-07-06 21:30:00	2006-07-07 00:30:00
143	48	2006-07-06 21:30:00	2006-07-07 00:30:00
143	220	2006-07-06 21:30:00	2006-07-07 00:30:00
143	50	2006-07-06 21:30:00	2006-07-07 00:30:00
143	100	2006-07-06 21:30:00	2006-07-07 00:30:00
143	221	2006-07-06 21:30:00	2006-07-07 00:30:00
143	207	2006-07-06 21:30:00	2006-07-07 00:30:00
143	222	2006-07-06 21:30:00	2006-07-07 00:30:00
143	52	2006-07-06 21:30:00	2006-07-07 00:30:00
143	223	2006-07-06 21:30:00	2006-07-07 00:30:00
143	224	2006-07-06 21:30:00	2006-07-07 00:30:00
136	1	2006-06-29 21:00:00	2006-06-29 22:00:00
136	5	2006-06-29 21:00:00	2006-06-29 22:00:00
136	6	2006-06-29 21:00:00	2006-06-29 22:00:00
136	8	2006-06-29 21:00:00	2006-06-29 22:00:00
136	15	2006-06-29 21:00:00	2006-06-29 22:00:00
136	16	2006-06-29 21:00:00	2006-06-29 22:00:00
136	96	2006-06-29 21:00:00	2006-06-29 22:00:00
136	23	2006-06-29 21:00:00	2006-06-29 22:00:00
136	64	2006-06-29 21:00:00	2006-06-29 22:00:00
136	27	2006-06-29 21:00:00	2006-06-29 22:00:00
136	28	2006-06-29 21:00:00	2006-06-29 22:00:00
136	30	2006-06-29 21:00:00	2006-06-29 22:00:00
136	32	2006-06-29 21:00:00	2006-06-29 22:00:00
136	33	2006-06-29 21:00:00	2006-06-29 22:00:00
136	154	2006-06-29 21:00:00	2006-06-29 22:00:00
136	136	2006-06-29 21:00:00	2006-06-29 22:00:00
136	35	2006-06-29 21:00:00	2006-06-29 22:00:00
136	36	2006-06-29 21:00:00	2006-06-29 22:00:00
136	38	2006-06-29 21:00:00	2006-06-29 22:00:00
136	39	2006-06-29 21:00:00	2006-06-29 22:00:00
136	40	2006-06-29 21:00:00	2006-06-29 22:00:00
136	41	2006-06-29 21:00:00	2006-06-29 22:00:00
136	42	2006-06-29 21:36:12	2006-06-29 22:00:00
136	45	2006-06-29 21:00:00	2006-06-29 22:00:00
136	142	2006-06-29 21:00:00	2006-06-29 22:00:00
136	48	2006-06-29 21:00:00	2006-06-29 22:00:00
136	49	2006-06-29 21:00:00	2006-06-29 22:00:00
136	50	2006-06-29 21:00:00	2006-06-29 22:00:00
136	67	2006-06-29 21:00:00	2006-06-29 22:00:00
136	100	2006-06-29 21:00:00	2006-06-29 22:00:00
136	51	2006-06-29 21:00:00	2006-06-29 22:00:00
136	52	2006-06-29 21:00:00	2006-06-29 22:00:00
136	116	2006-06-29 21:00:00	2006-06-29 22:00:00
136	61	2006-06-29 21:00:00	2006-06-29 22:00:00
136	109	2006-06-29 21:00:00	2006-06-29 21:57:04
136	107	2006-06-29 21:00:00	2006-06-29 22:00:00
136	160	2006-06-29 21:00:00	2006-06-29 22:00:00
136	167	2006-06-29 21:00:00	2006-06-29 22:00:00
136	58	2006-06-29 21:00:00	2006-06-29 22:00:00
136	57	2006-06-29 21:00:00	2006-06-29 22:00:00
136	60	2006-06-29 21:00:00	2006-06-29 22:00:00
138	1	2006-07-01 10:31:17	2006-07-01 14:38:18
138	2	2006-07-01 14:41:34	2006-07-01 15:56:39
138	5	2006-07-01 10:31:04	2006-07-01 15:55:55
138	6	2006-07-01 10:34:53	2006-07-01 14:38:17
138	8	2006-07-01 10:31:55	2006-07-01 15:57:07
138	90	2006-07-01 10:31:04	2006-07-01 15:57:07
138	12	2006-07-01 12:59:32	2006-07-01 14:41:31
138	186	2006-07-01 10:32:56	2006-07-01 12:53:32
138	24	2006-07-01 10:47:15	2006-07-01 14:05:11
138	213	2006-07-01 15:11:11	2006-07-01 15:57:07
138	28	2006-07-01 10:48:04	2006-07-01 15:56:26
138	32	2006-07-01 10:38:54	2006-07-01 14:38:09
138	136	2006-07-01 10:37:49	2006-07-01 15:57:07
138	36	2006-07-01 10:35:59	2006-07-01 15:55:47
138	111	2006-07-01 14:42:32	2006-07-01 15:56:44
138	44	2006-07-01 10:47:12	2006-07-01 15:57:07
138	190	2006-07-01 14:51:44	2006-07-01 15:57:07
138	100	2006-07-01 10:38:59	2006-07-01 14:38:31
138	51	2006-07-01 10:54:14	2006-07-01 15:56:39
138	116	2006-07-01 12:54:28	2006-07-01 15:55:55
138	61	2006-07-01 10:49:07	2006-07-01 15:56:19
138	107	2006-07-01 10:47:30	2006-07-01 15:57:07
138	160	2006-07-01 14:06:22	2006-07-01 14:48:37
138	167	2006-07-01 10:34:11	2006-07-01 15:57:07
138	55	2006-07-01 10:47:20	2006-07-01 15:56:14
138	57	2006-07-01 14:47:42	2006-07-01 15:31:56
138	60	2006-07-01 10:32:08	2006-07-01 15:57:07
140	2	2006-07-02 19:23:33	2006-07-03 00:21:30
140	4	2006-07-02 19:23:33	2006-07-03 00:21:57
140	206	2006-07-02 23:43:00	2006-07-03 00:21:57
140	5	2006-07-02 19:23:33	2006-07-02 20:43:14
140	6	2006-07-02 19:23:33	2006-07-03 00:21:57
140	135	2006-07-02 19:23:33	2006-07-03 00:21:57
140	175	2006-07-02 19:23:33	2006-07-03 00:21:57
140	14	2006-07-02 19:23:33	2006-07-03 00:21:57
140	15	2006-07-02 19:23:33	2006-07-03 00:21:52
140	16	2006-07-02 21:45:51	2006-07-03 00:21:57
140	19	2006-07-02 19:23:33	2006-07-03 00:21:57
140	21	2006-07-02 19:23:33	2006-07-03 00:21:57
140	24	2006-07-02 19:23:33	2006-07-02 23:23:00
140	64	2006-07-02 19:23:33	2006-07-03 00:21:57
140	27	2006-07-02 19:23:33	2006-07-03 00:21:57
135	2	2006-06-26 23:03:31	2006-06-27 00:30:13
135	8	2006-06-26 23:03:31	2006-06-27 00:30:13
135	175	2006-06-26 23:03:31	2006-06-27 00:30:13
135	13	2006-06-26 23:03:31	2006-06-27 00:30:13
135	14	2006-06-26 23:03:31	2006-06-27 00:30:13
135	23	2006-06-26 23:03:31	2006-06-27 00:30:13
135	24	2006-06-26 23:03:31	2006-06-27 00:30:13
135	30	2006-06-26 23:03:31	2006-06-27 00:30:13
135	116	2006-06-26 23:03:31	2006-06-27 00:30:13
135	61	2006-06-26 23:03:31	2006-06-27 00:30:13
135	205	2006-06-26 23:03:31	2006-06-27 00:30:13
135	1	2006-06-26 23:03:31	2006-06-27 00:30:13
135	4	2006-06-26 23:03:31	2006-06-27 00:30:13
135	5	2006-06-26 23:03:31	2006-06-27 00:30:13
135	6	2006-06-26 23:03:31	2006-06-27 00:30:10
135	135	2006-06-26 23:03:31	2006-06-27 00:29:51
135	186	2006-06-26 23:03:31	2006-06-26 23:05:23
135	208	2006-06-26 23:04:40	2006-06-27 00:30:13
135	15	2006-06-26 23:03:31	2006-06-27 00:30:13
135	16	2006-06-26 23:03:31	2006-06-27 00:30:13
135	21	2006-06-26 23:03:31	2006-06-27 00:30:13
135	96	2006-06-26 23:03:31	2006-06-27 00:30:13
135	27	2006-06-26 23:03:31	2006-06-27 00:30:13
135	28	2006-06-26 23:03:31	2006-06-27 00:30:13
135	31	2006-06-26 23:03:31	2006-06-27 00:30:13
135	32	2006-06-26 23:03:31	2006-06-27 00:30:13
135	33	2006-06-26 23:03:31	2006-06-27 00:30:13
135	154	2006-06-26 23:03:31	2006-06-27 00:30:13
135	136	2006-06-26 23:03:31	2006-06-27 00:30:13
135	35	2006-06-26 23:03:31	2006-06-27 00:30:13
135	150	2006-06-26 23:03:31	2006-06-27 00:30:13
135	155	2006-06-26 23:03:31	2006-06-27 00:29:41
135	39	2006-06-26 23:03:31	2006-06-27 00:30:13
135	40	2006-06-26 23:03:31	2006-06-27 00:30:13
135	41	2006-06-26 23:06:07	2006-06-27 00:30:13
135	42	2006-06-26 23:03:31	2006-06-27 00:30:13
135	43	2006-06-26 23:03:31	2006-06-27 00:30:13
135	45	2006-06-26 23:03:31	2006-06-27 00:30:13
135	142	2006-06-26 23:03:31	2006-06-27 00:30:13
135	131	2006-06-26 23:26:44	2006-06-27 00:30:13
135	48	2006-06-26 23:03:31	2006-06-27 00:30:13
135	49	2006-06-26 23:03:31	2006-06-27 00:30:13
135	67	2006-06-26 23:03:31	2006-06-27 00:15:29
135	100	2006-06-26 23:03:31	2006-06-27 00:30:13
135	51	2006-06-26 23:03:31	2006-06-27 00:30:13
135	207	2006-06-26 23:03:31	2006-06-26 23:05:29
135	115	2006-06-26 23:03:31	2006-06-27 00:30:13
135	107	2006-06-26 23:03:31	2006-06-27 00:30:13
135	160	2006-06-26 23:03:31	2006-06-27 00:30:13
135	55	2006-06-26 23:03:31	2006-06-27 00:30:13
135	58	2006-06-26 23:03:31	2006-06-27 00:30:13
135	57	2006-06-26 23:03:31	2006-06-27 00:30:13
135	153	2006-06-26 23:03:31	2006-06-26 23:03:50
135	60	2006-06-26 23:03:31	2006-06-27 00:30:13
134	1	2006-06-29 22:30:00	2006-06-30 00:30:00
134	206	2006-06-29 23:05:49	2006-06-30 00:30:00
134	5	2006-06-29 22:30:00	2006-06-30 00:30:00
134	6	2006-06-29 22:30:00	2006-06-30 00:30:00
134	8	2006-06-29 22:30:00	2006-06-30 00:30:00
134	175	2006-06-29 22:30:00	2006-06-30 00:30:00
134	15	2006-06-29 22:30:00	2006-06-30 00:30:00
134	16	2006-06-29 22:30:00	2006-06-30 00:30:00
134	21	2006-06-29 23:11:39	2006-06-30 00:30:00
134	96	2006-06-29 22:30:00	2006-06-30 00:30:00
134	23	2006-06-29 22:30:00	2006-06-29 23:06:21
134	24	2006-06-29 22:30:00	2006-06-30 00:30:00
134	27	2006-06-29 22:30:00	2006-06-30 00:30:00
134	28	2006-06-29 22:30:00	2006-06-30 00:30:00
134	30	2006-06-29 22:30:00	2006-06-30 00:30:00
134	31	2006-06-29 22:30:00	2006-06-30 00:30:00
134	32	2006-06-29 22:30:00	2006-06-30 00:30:00
134	33	2006-06-29 22:30:00	2006-06-30 00:30:00
134	154	2006-06-29 22:30:00	2006-06-30 00:30:00
134	136	2006-06-29 22:30:00	2006-06-30 00:30:00
134	35	2006-06-29 22:30:00	2006-06-30 00:30:00
134	36	2006-06-29 22:30:00	2006-06-30 00:30:00
134	38	2006-06-29 22:30:00	2006-06-30 00:30:00
134	39	2006-06-29 22:30:00	2006-06-30 00:30:00
134	40	2006-06-29 22:30:00	2006-06-30 00:30:00
134	41	2006-06-29 22:30:00	2006-06-30 00:30:00
134	42	2006-06-29 22:30:00	2006-06-30 00:30:00
134	45	2006-06-29 22:30:00	2006-06-30 00:30:00
134	142	2006-06-29 22:30:00	2006-06-30 00:30:00
134	48	2006-06-29 22:30:00	2006-06-30 00:30:00
134	49	2006-06-29 22:30:00	2006-06-30 00:10:39
134	50	2006-06-29 22:30:00	2006-06-30 00:30:00
134	67	2006-06-29 22:30:00	2006-06-30 00:30:00
134	100	2006-06-29 22:30:00	2006-06-30 00:30:00
134	51	2006-06-29 22:30:00	2006-06-30 00:30:00
134	52	2006-06-29 22:30:00	2006-06-30 00:30:00
134	116	2006-06-29 22:30:00	2006-06-29 23:05:28
134	107	2006-06-29 22:30:00	2006-06-30 00:30:00
134	160	2006-06-29 22:30:00	2006-06-30 00:30:00
134	167	2006-06-29 22:30:00	2006-06-29 23:37:06
134	58	2006-06-29 22:30:00	2006-06-30 00:29:46
134	57	2006-06-29 22:30:00	2006-06-30 00:30:00
134	60	2006-06-29 22:30:00	2006-06-30 00:30:00
140	28	2006-07-02 23:23:25	2006-07-03 00:21:57
140	33	2006-07-02 21:03:42	2006-07-02 21:14:03
140	119	2006-07-02 20:47:16	2006-07-03 00:21:57
140	154	2006-07-02 19:23:33	2006-07-03 00:21:57
140	136	2006-07-02 19:23:33	2006-07-03 00:21:57
140	36	2006-07-02 19:23:33	2006-07-03 00:21:56
140	150	2006-07-02 19:23:33	2006-07-03 00:21:57
140	39	2006-07-02 19:23:33	2006-07-03 00:21:57
140	42	2006-07-02 23:13:51	2006-07-03 00:21:57
140	129	2006-07-02 19:23:33	2006-07-03 00:21:57
140	44	2006-07-02 19:23:33	2006-07-03 00:21:57
140	142	2006-07-02 19:23:33	2006-07-03 00:21:57
140	190	2006-07-02 19:23:33	2006-07-03 00:21:57
140	48	2006-07-02 19:23:33	2006-07-03 00:21:57
140	50	2006-07-02 19:35:52	2006-07-03 00:21:57
140	100	2006-07-02 19:23:33	2006-07-03 00:21:57
140	165	2006-07-02 19:32:40	2006-07-02 23:39:41
140	52	2006-07-02 19:23:33	2006-07-03 00:21:57
140	72	2006-07-02 19:23:33	2006-07-03 00:21:57
140	198	2006-07-02 19:23:33	2006-07-03 00:21:57
140	61	2006-07-02 23:34:17	2006-07-03 00:21:57
140	171	2006-07-02 19:23:33	2006-07-03 00:21:57
140	109	2006-07-02 23:23:47	2006-07-03 00:21:57
140	107	2006-07-02 19:23:33	2006-07-03 00:21:57
140	160	2006-07-02 19:23:33	2006-07-03 00:21:57
140	76	2006-07-02 19:23:33	2006-07-02 23:13:12
140	55	2006-07-02 19:23:33	2006-07-02 23:27:16
140	58	2006-07-02 19:23:33	2006-07-03 00:21:57
140	85	2006-07-02 19:23:33	2006-07-02 23:23:04
140	57	2006-07-02 19:23:33	2006-07-03 00:21:57
140	153	2006-07-02 19:23:33	2006-07-03 00:21:25
140	56	2006-07-02 19:23:33	2006-07-02 23:22:21
140	60	2006-07-02 19:23:33	2006-07-03 00:21:57
142	1	2006-07-04 20:39:51	2006-07-04 23:20:48
142	2	2006-07-04 21:01:26	2006-07-04 23:20:48
142	4	2006-07-04 20:38:27	2006-07-04 21:28:29
142	206	2006-07-04 21:44:46	2006-07-04 22:50:32
142	200	2006-07-04 20:47:23	2006-07-04 23:20:33
142	135	2006-07-04 20:42:21	2006-07-04 23:20:39
142	8	2006-07-04 20:41:08	2006-07-04 23:20:48
142	175	2006-07-04 20:59:47	2006-07-04 23:20:48
142	13	2006-07-04 20:58:25	2006-07-04 21:43:26
142	14	2006-07-04 20:40:27	2006-07-04 22:47:48
142	15	2006-07-04 20:38:32	2006-07-04 23:19:27
142	123	2006-07-04 20:48:08	2006-07-04 23:20:12
142	23	2006-07-04 20:40:00	2006-07-04 22:51:02
142	157	2006-07-04 20:47:56	2006-07-04 23:20:48
142	24	2006-07-04 21:27:27	2006-07-04 22:46:30
142	64	2006-07-04 20:48:24	2006-07-04 23:20:48
142	27	2006-07-04 20:45:30	2006-07-04 23:20:48
142	28	2006-07-04 20:38:04	2006-07-04 23:20:48
142	31	2006-07-04 23:02:06	2006-07-04 23:19:45
142	32	2006-07-04 20:38:32	2006-07-04 23:20:40
142	33	2006-07-04 21:07:18	2006-07-04 23:19:45
142	154	2006-07-04 20:52:05	2006-07-04 23:20:42
142	136	2006-07-04 20:38:44	2006-07-04 23:20:14
142	36	2006-07-04 22:28:51	2006-07-04 23:20:48
142	39	2006-07-04 20:39:12	2006-07-04 23:20:33
142	40	2006-07-04 22:48:54	2006-07-04 23:20:37
142	209	2006-07-04 21:42:10	2006-07-04 23:20:48
142	41	2006-07-04 20:43:30	2006-07-04 23:20:48
142	42	2006-07-04 21:22:09	2006-07-04 23:20:48
142	43	2006-07-04 20:36:44	2006-07-04 23:20:48
142	45	2006-07-04 20:38:56	2006-07-04 23:20:48
142	142	2006-07-04 21:30:49	2006-07-04 23:20:48
142	48	2006-07-04 20:36:44	2006-07-04 23:20:48
142	50	2006-07-04 20:52:07	2006-07-04 23:20:48
142	100	2006-07-04 20:39:05	2006-07-04 23:20:48
142	114	2006-07-04 21:35:02	2006-07-04 22:28:44
142	51	2006-07-04 20:41:06	2006-07-04 23:20:01
142	52	2006-07-04 20:39:50	2006-07-04 23:20:48
142	72	2006-07-04 21:07:49	2006-07-04 23:20:44
142	116	2006-07-04 20:38:19	2006-07-04 23:20:48
142	61	2006-07-04 20:52:10	2006-07-04 21:01:14
142	171	2006-07-04 21:24:19	2006-07-04 23:08:10
142	109	2006-07-04 21:32:39	2006-07-04 23:20:48
142	160	2006-07-04 20:39:58	2006-07-04 23:20:00
142	76	2006-07-04 20:47:59	2006-07-04 21:07:39
142	57	2006-07-04 20:38:16	2006-07-04 23:20:47
142	60	2006-07-04 20:37:33	2006-07-04 23:20:48
143	210	2006-07-06 21:30:00	2006-07-07 00:30:00
143	116	2006-07-06 21:30:00	2006-07-07 00:30:00
143	61	2006-07-06 23:11:02	2006-07-07 00:30:00
143	160	2006-07-06 21:30:00	2006-07-07 00:30:00
143	167	2006-07-06 21:30:00	2006-07-06 23:31:56
143	85	2006-07-06 22:27:25	2006-07-07 00:30:00
143	57	2006-07-06 21:30:00	2006-07-07 00:30:00
143	56	2006-07-07 00:25:22	2006-07-07 00:30:00
143	60	2006-07-06 21:30:00	2006-07-07 00:30:00
144	4	2006-07-08 15:28:19	2006-07-08 16:30:00
144	200	2006-07-08 11:05:39	2006-07-08 12:59:10
148	2	2006-07-09 19:45:00	2006-07-09 20:30:00
148	206	2006-07-09 19:45:00	2006-07-09 20:30:00
148	135	2006-07-09 19:48:36	2006-07-09 20:30:00
144	13	2006-07-08 16:04:03	2006-07-08 16:30:00
148	8	2006-07-09 19:45:00	2006-07-09 20:30:00
148	175	2006-07-09 19:45:00	2006-07-09 20:30:00
148	90	2006-07-09 19:45:00	2006-07-09 20:30:00
148	186	2006-07-09 19:45:00	2006-07-09 20:30:00
144	136	2006-07-08 15:20:40	2006-07-08 16:30:00
148	14	2006-07-09 19:45:00	2006-07-09 20:30:00
148	16	2006-07-09 19:45:00	2006-07-09 20:30:00
144	40	2006-07-08 12:18:20	2006-07-08 16:30:00
148	19	2006-07-09 19:45:00	2006-07-09 20:30:00
144	45	2006-07-08 16:12:53	2006-07-08 16:30:00
148	21	2006-07-09 19:45:00	2006-07-09 20:30:00
144	100	2006-07-08 12:59:01	2006-07-08 16:09:12
148	157	2006-07-09 19:45:00	2006-07-09 20:30:00
148	24	2006-07-09 19:45:00	2006-07-09 20:30:00
148	27	2006-07-09 19:45:00	2006-07-09 20:30:00
144	115	2006-07-08 13:00:27	2006-07-08 15:55:05
148	28	2006-07-09 19:45:00	2006-07-09 20:30:00
148	98	2006-07-09 19:45:00	2006-07-09 20:30:00
148	30	2006-07-09 19:45:00	2006-07-09 20:30:00
148	32	2006-07-09 19:45:00	2006-07-09 20:30:00
148	33	2006-07-09 19:45:00	2006-07-09 20:30:00
148	154	2006-07-09 19:45:00	2006-07-09 20:30:00
144	2	2006-07-08 11:00:00	2006-07-08 16:30:00
144	8	2006-07-08 11:00:00	2006-07-08 16:30:00
144	90	2006-07-08 11:00:00	2006-07-08 16:30:00
144	186	2006-07-08 11:00:00	2006-07-08 11:05:33
144	123	2006-07-08 11:00:00	2006-07-08 15:20:14
144	21	2006-07-08 11:00:00	2006-07-08 16:30:00
144	30	2006-07-08 11:00:00	2006-07-08 16:30:00
144	215	2006-07-08 11:00:00	2006-07-08 16:30:00
144	36	2006-07-08 11:00:00	2006-07-08 12:17:49
144	225	2006-07-08 11:00:00	2006-07-08 16:30:00
144	44	2006-07-08 11:00:00	2006-07-08 13:03:30
144	142	2006-07-08 11:00:00	2006-07-08 16:30:00
148	136	2006-07-09 19:45:00	2006-07-09 20:30:00
144	221	2006-07-08 11:00:00	2006-07-08 16:30:00
144	114	2006-07-08 11:00:00	2006-07-08 15:22:10
144	61	2006-07-08 11:00:00	2006-07-08 16:30:00
144	171	2006-07-08 11:00:00	2006-07-08 16:30:00
144	107	2006-07-08 11:00:00	2006-07-08 16:30:00
144	160	2006-07-08 11:00:00	2006-07-08 16:30:00
144	167	2006-07-08 11:00:00	2006-07-08 16:30:00
144	60	2006-07-08 11:00:00	2006-07-08 16:30:00
148	35	2006-07-09 19:45:00	2006-07-09 20:30:00
148	36	2006-07-09 19:45:00	2006-07-09 20:30:00
148	155	2006-07-09 19:45:00	2006-07-09 20:30:00
148	39	2006-07-09 19:45:00	2006-07-09 20:30:00
148	43	2006-07-09 19:45:00	2006-07-09 20:30:00
148	190	2006-07-09 19:51:21	2006-07-09 20:30:00
148	106	2006-07-09 19:45:00	2006-07-09 20:30:00
148	50	2006-07-09 19:45:52	2006-07-09 20:30:00
148	100	2006-07-09 19:45:00	2006-07-09 20:30:00
148	52	2006-07-09 19:45:00	2006-07-09 20:30:00
148	116	2006-07-09 19:45:00	2006-07-09 20:30:00
148	61	2006-07-09 19:45:00	2006-07-09 20:30:00
148	171	2006-07-09 19:45:00	2006-07-09 20:30:00
148	160	2006-07-09 19:45:00	2006-07-09 20:30:00
148	76	2006-07-09 19:45:00	2006-07-09 20:30:00
148	167	2006-07-09 19:45:00	2006-07-09 20:30:00
148	63	2006-07-09 19:45:00	2006-07-09 20:30:00
148	55	2006-07-09 19:45:00	2006-07-09 20:30:00
148	60	2006-07-09 19:45:00	2006-07-09 20:30:00
149	216	2006-07-09 21:00:00	2006-07-09 23:30:05
149	2	2006-07-09 21:00:00	2006-07-10 00:30:00
149	206	2006-07-09 21:00:00	2006-07-10 00:30:00
149	5	2006-07-09 21:00:00	2006-07-10 00:30:00
149	135	2006-07-09 21:00:00	2006-07-10 00:30:00
149	8	2006-07-09 21:00:00	2006-07-10 00:30:00
149	175	2006-07-09 21:00:00	2006-07-10 00:30:00
149	90	2006-07-09 21:00:00	2006-07-10 00:30:00
149	186	2006-07-09 21:00:00	2006-07-10 00:30:00
149	14	2006-07-09 21:00:00	2006-07-09 22:30:05
149	15	2006-07-09 21:00:00	2006-07-10 00:30:00
149	16	2006-07-09 23:32:00	2006-07-10 00:30:00
149	19	2006-07-09 21:00:00	2006-07-10 00:30:00
149	21	2006-07-09 21:00:00	2006-07-09 23:33:05
149	27	2006-07-09 21:00:00	2006-07-10 00:30:00
149	33	2006-07-09 21:00:00	2006-07-10 00:30:00
149	154	2006-07-09 21:00:00	2006-07-10 00:30:00
149	136	2006-07-09 21:00:00	2006-07-10 00:30:00
149	36	2006-07-09 21:00:00	2006-07-10 00:30:00
149	155	2006-07-09 21:00:00	2006-07-10 00:30:00
149	39	2006-07-09 21:00:00	2006-07-10 00:30:00
149	209	2006-07-09 22:51:19	2006-07-10 00:30:00
149	202	2006-07-09 21:02:16	2006-07-10 00:30:00
149	42	2006-07-09 23:34:50	2006-07-10 00:30:00
149	43	2006-07-09 21:00:00	2006-07-10 00:30:00
149	62	2006-07-09 21:00:00	2006-07-10 00:30:00
149	190	2006-07-09 21:00:00	2006-07-10 00:30:00
149	106	2006-07-09 21:00:00	2006-07-10 00:30:00
149	50	2006-07-09 21:00:00	2006-07-10 00:02:29
149	100	2006-07-09 21:00:00	2006-07-10 00:30:00
149	221	2006-07-09 21:00:00	2006-07-10 00:30:00
149	52	2006-07-09 21:00:00	2006-07-10 00:30:00
149	116	2006-07-09 21:00:00	2006-07-10 00:30:00
149	61	2006-07-09 21:00:00	2006-07-10 00:30:00
149	171	2006-07-09 21:00:00	2006-07-10 00:30:00
149	107	2006-07-10 00:04:48	2006-07-10 00:30:00
149	160	2006-07-09 21:00:00	2006-07-10 00:30:00
149	89	2006-07-09 21:00:00	2006-07-10 00:30:00
149	76	2006-07-09 21:00:00	2006-07-10 00:30:00
149	167	2006-07-09 21:00:00	2006-07-10 00:30:00
149	63	2006-07-09 21:00:00	2006-07-09 23:34:35
149	55	2006-07-09 21:00:00	2006-07-10 00:30:00
149	56	2006-07-09 21:00:00	2006-07-10 00:30:00
149	60	2006-07-09 21:00:00	2006-07-10 00:30:00
155	1	2006-07-10 21:00:00	2006-07-10 21:25:00
155	2	2006-07-10 21:00:00	2006-07-10 21:25:00
155	97	2006-07-10 21:00:00	2006-07-10 21:25:00
155	4	2006-07-10 21:00:00	2006-07-10 21:25:00
155	135	2006-07-10 21:00:00	2006-07-10 21:25:00
155	8	2006-07-10 21:00:00	2006-07-10 21:25:00
155	175	2006-07-10 21:00:00	2006-07-10 21:25:00
155	90	2006-07-10 21:00:00	2006-07-10 21:25:00
155	186	2006-07-10 21:00:00	2006-07-10 21:25:00
155	197	2006-07-10 21:00:00	2006-07-10 21:25:00
155	14	2006-07-10 21:00:00	2006-07-10 21:25:00
155	16	2006-07-10 21:00:00	2006-07-10 21:25:00
155	19	2006-07-10 21:00:00	2006-07-10 21:25:00
155	21	2006-07-10 21:00:00	2006-07-10 21:25:00
155	157	2006-07-10 21:00:00	2006-07-10 21:25:00
155	27	2006-07-10 21:00:00	2006-07-10 21:25:00
155	28	2006-07-10 21:00:00	2006-07-10 21:25:00
155	98	2006-07-10 21:00:00	2006-07-10 21:25:00
155	30	2006-07-10 21:00:00	2006-07-10 21:25:00
155	32	2006-07-10 21:00:00	2006-07-10 21:25:00
155	33	2006-07-10 21:00:00	2006-07-10 21:25:00
155	136	2006-07-10 21:00:00	2006-07-10 21:25:00
155	35	2006-07-10 21:00:00	2006-07-10 21:25:00
155	36	2006-07-10 21:00:00	2006-07-10 21:25:00
155	155	2006-07-10 21:00:00	2006-07-10 21:25:00
155	39	2006-07-10 21:00:00	2006-07-10 21:25:00
155	41	2006-07-10 21:00:00	2006-07-10 21:25:00
155	42	2006-07-10 21:00:00	2006-07-10 21:25:00
155	45	2006-07-10 21:00:00	2006-07-10 21:25:00
155	142	2006-07-10 21:00:00	2006-07-10 21:25:00
155	190	2006-07-10 21:00:00	2006-07-10 21:25:00
155	227	2006-07-10 21:00:00	2006-07-10 21:25:00
155	50	2006-07-10 21:00:00	2006-07-10 21:25:00
155	100	2006-07-10 21:00:00	2006-07-10 21:25:00
155	51	2006-07-10 21:00:00	2006-07-10 21:25:00
155	52	2006-07-10 21:00:00	2006-07-10 21:25:00
155	210	2006-07-10 21:00:00	2006-07-10 21:25:00
155	116	2006-07-10 21:00:00	2006-07-10 21:25:00
155	107	2006-07-10 21:00:00	2006-07-10 21:25:00
155	160	2006-07-10 21:00:00	2006-07-10 21:25:00
155	167	2006-07-10 21:00:00	2006-07-10 21:25:00
155	60	2006-07-10 21:00:00	2006-07-10 21:25:00
150	1	2006-07-10 21:45:00	2006-07-11 00:30:00
150	2	2006-07-10 21:45:00	2006-07-11 00:30:00
150	97	2006-07-10 21:45:00	2006-07-11 00:00:12
150	4	2006-07-10 21:45:00	2006-07-11 00:30:00
150	8	2006-07-10 21:45:00	2006-07-11 00:30:00
150	175	2006-07-10 21:45:00	2006-07-10 22:04:06
150	186	2006-07-10 21:45:00	2006-07-11 00:30:00
150	197	2006-07-10 21:45:00	2006-07-11 00:30:00
150	14	2006-07-10 21:45:00	2006-07-10 23:36:41
150	15	2006-07-10 21:45:00	2006-07-11 00:30:00
150	16	2006-07-10 21:45:00	2006-07-11 00:30:00
150	19	2006-07-10 21:45:00	2006-07-11 00:30:00
150	21	2006-07-10 21:45:00	2006-07-11 00:30:00
150	157	2006-07-10 21:45:00	2006-07-11 00:30:00
150	24	2006-07-10 23:41:59	2006-07-11 00:30:00
150	27	2006-07-10 21:45:00	2006-07-11 00:30:00
150	28	2006-07-10 21:45:00	2006-07-11 00:30:00
150	29	2006-07-10 21:45:00	2006-07-11 00:30:00
150	30	2006-07-10 21:45:00	2006-07-11 00:30:00
150	32	2006-07-10 21:45:00	2006-07-11 00:30:00
150	33	2006-07-10 21:45:00	2006-07-11 00:30:00
150	136	2006-07-10 21:45:00	2006-07-10 23:40:02
150	35	2006-07-10 21:45:00	2006-07-11 00:30:00
150	36	2006-07-10 21:45:00	2006-07-11 00:30:00
150	39	2006-07-10 21:45:00	2006-07-11 00:30:00
150	40	2006-07-10 21:45:00	2006-07-11 00:30:00
150	41	2006-07-10 21:45:00	2006-07-11 00:30:00
150	42	2006-07-10 21:45:00	2006-07-11 00:30:00
150	43	2006-07-10 21:45:00	2006-07-11 00:30:00
150	45	2006-07-10 21:45:00	2006-07-11 00:30:00
150	142	2006-07-10 21:45:00	2006-07-11 00:30:00
150	48	2006-07-10 21:45:00	2006-07-11 00:30:00
150	227	2006-07-10 21:45:00	2006-07-11 00:30:00
150	50	2006-07-10 21:45:00	2006-07-11 00:24:41
150	100	2006-07-10 21:45:00	2006-07-11 00:30:00
150	51	2006-07-10 21:45:00	2006-07-11 00:30:00
150	52	2006-07-10 21:45:00	2006-07-11 00:30:00
150	210	2006-07-10 21:45:00	2006-07-11 00:30:00
150	116	2006-07-10 21:45:00	2006-07-11 00:30:00
150	107	2006-07-10 21:45:00	2006-07-11 00:30:00
150	160	2006-07-10 21:45:00	2006-07-11 00:30:00
150	55	2006-07-10 22:07:50	2006-07-11 00:30:00
150	57	2006-07-10 21:45:00	2006-07-11 00:30:00
150	60	2006-07-10 21:45:00	2006-07-11 00:30:00
151	1	2006-07-11 21:00:00	2006-07-12 00:15:00
151	2	2006-07-11 21:00:00	2006-07-12 00:15:00
151	4	2006-07-11 21:00:00	2006-07-12 00:15:00
151	5	2006-07-11 21:00:00	2006-07-12 00:15:00
151	135	2006-07-11 21:00:00	2006-07-12 00:15:00
151	8	2006-07-11 21:00:00	2006-07-12 00:15:00
151	14	2006-07-11 21:00:00	2006-07-11 22:00:29
151	15	2006-07-11 21:00:00	2006-07-12 00:15:00
151	19	2006-07-11 21:00:00	2006-07-12 00:15:00
151	21	2006-07-11 23:50:04	2006-07-12 00:15:00
151	157	2006-07-11 21:00:00	2006-07-12 00:15:00
151	27	2006-07-11 21:00:00	2006-07-12 00:15:00
151	28	2006-07-11 21:00:00	2006-07-12 00:15:00
151	29	2006-07-11 21:00:00	2006-07-12 00:15:00
151	30	2006-07-11 21:00:00	2006-07-12 00:15:00
151	32	2006-07-11 21:00:00	2006-07-12 00:15:00
151	33	2006-07-11 21:00:00	2006-07-12 00:15:00
151	136	2006-07-11 21:00:00	2006-07-12 00:15:00
151	35	2006-07-11 21:00:00	2006-07-12 00:15:00
151	36	2006-07-11 21:00:00	2006-07-12 00:15:00
151	39	2006-07-11 21:00:00	2006-07-12 00:15:00
151	40	2006-07-11 21:00:00	2006-07-12 00:15:00
151	41	2006-07-11 21:00:00	2006-07-12 00:15:00
151	42	2006-07-11 21:00:00	2006-07-11 22:23:07
151	43	2006-07-11 21:00:00	2006-07-12 00:15:00
151	62	2006-07-11 23:26:33	2006-07-11 23:58:08
151	45	2006-07-11 21:00:00	2006-07-12 00:15:00
151	142	2006-07-11 21:00:00	2006-07-12 00:15:00
151	48	2006-07-11 21:00:00	2006-07-12 00:15:00
151	227	2006-07-11 21:00:00	2006-07-12 00:15:00
151	100	2006-07-11 21:00:00	2006-07-12 00:15:00
151	51	2006-07-11 21:00:00	2006-07-12 00:15:00
151	52	2006-07-11 21:00:00	2006-07-12 00:15:00
151	148	2006-07-11 22:24:12	2006-07-12 00:15:00
151	210	2006-07-11 21:00:00	2006-07-12 00:15:00
151	116	2006-07-11 21:00:00	2006-07-12 00:15:00
151	61	2006-07-11 21:00:00	2006-07-12 00:15:00
151	171	2006-07-11 21:00:00	2006-07-12 00:15:00
151	160	2006-07-11 21:00:00	2006-07-12 00:15:00
151	167	2006-07-11 21:00:00	2006-07-11 23:05:48
151	55	2006-07-11 21:00:00	2006-07-12 00:15:00
151	57	2006-07-11 21:00:00	2006-07-12 00:15:00
151	166	2006-07-11 22:24:48	2006-07-12 00:15:00
151	60	2006-07-11 21:00:00	2006-07-12 00:15:00
152	1	2006-07-13 20:43:15	2006-07-13 21:46:51
152	2	2006-07-13 20:42:41	2006-07-13 21:46:51
152	4	2006-07-13 20:38:05	2006-07-13 21:46:51
152	5	2006-07-13 20:39:16	2006-07-13 21:46:51
152	135	2006-07-13 21:23:33	2006-07-13 21:46:51
152	8	2006-07-13 20:38:38	2006-07-13 21:46:51
152	175	2006-07-13 20:38:05	2006-07-13 20:53:53
152	90	2006-07-13 20:38:05	2006-07-13 21:46:51
152	14	2006-07-13 20:38:05	2006-07-13 21:46:51
152	15	2006-07-13 20:38:05	2006-07-13 21:46:51
152	16	2006-07-13 20:38:05	2006-07-13 21:46:51
152	21	2006-07-13 20:40:26	2006-07-13 21:46:51
152	24	2006-07-13 20:38:05	2006-07-13 21:46:51
152	27	2006-07-13 20:38:05	2006-07-13 21:46:51
152	28	2006-07-13 20:38:35	2006-07-13 21:46:51
152	30	2006-07-13 20:45:12	2006-07-13 21:46:51
152	31	2006-07-13 20:40:40	2006-07-13 21:46:51
152	32	2006-07-13 20:40:16	2006-07-13 21:46:51
152	33	2006-07-13 20:43:30	2006-07-13 21:46:51
152	136	2006-07-13 20:45:26	2006-07-13 21:46:51
152	35	2006-07-13 20:38:05	2006-07-13 21:46:51
152	36	2006-07-13 20:38:05	2006-07-13 21:46:51
152	39	2006-07-13 20:42:57	2006-07-13 21:46:51
152	41	2006-07-13 20:38:05	2006-07-13 21:46:51
152	42	2006-07-13 20:38:05	2006-07-13 21:46:51
152	43	2006-07-13 20:38:05	2006-07-13 21:46:51
152	142	2006-07-13 20:50:01	2006-07-13 21:46:51
152	190	2006-07-13 20:41:33	2006-07-13 20:52:11
152	228	2006-07-13 20:38:05	2006-07-13 21:46:51
152	100	2006-07-13 20:43:15	2006-07-13 21:46:51
152	51	2006-07-13 20:38:05	2006-07-13 21:46:51
152	52	2006-07-13 20:38:05	2006-07-13 21:46:51
152	148	2006-07-13 20:47:05	2006-07-13 21:46:51
152	116	2006-07-13 20:38:05	2006-07-13 21:46:51
152	61	2006-07-13 20:43:45	2006-07-13 21:46:51
152	171	2006-07-13 20:44:03	2006-07-13 21:46:51
152	109	2006-07-13 20:38:05	2006-07-13 21:46:51
152	160	2006-07-13 20:38:05	2006-07-13 21:46:51
152	76	2006-07-13 20:44:22	2006-07-13 21:46:51
152	55	2006-07-13 20:39:43	2006-07-13 21:46:51
152	57	2006-07-13 20:39:33	2006-07-13 21:46:51
152	60	2006-07-13 20:38:05	2006-07-13 21:46:51
153	1	2006-07-13 21:48:55	2006-07-14 00:38:59
153	2	2006-07-13 21:48:55	2006-07-14 00:34:25
153	4	2006-07-13 21:48:55	2006-07-14 00:33:08
153	5	2006-07-13 21:48:55	2006-07-14 00:37:47
153	135	2006-07-13 21:48:55	2006-07-13 23:42:13
153	8	2006-07-13 21:48:55	2006-07-14 00:33:22
153	14	2006-07-13 21:48:55	2006-07-14 00:37:14
153	15	2006-07-13 21:48:55	2006-07-14 00:38:11
153	16	2006-07-13 21:48:55	2006-07-14 00:38:31
153	21	2006-07-13 21:48:55	2006-07-14 00:33:22
153	24	2006-07-13 21:48:55	2006-07-14 00:36:39
153	27	2006-07-13 21:48:55	2006-07-14 00:37:29
153	28	2006-07-13 21:48:55	2006-07-14 00:37:32
153	29	2006-07-13 23:27:52	2006-07-14 00:38:57
153	30	2006-07-13 21:48:55	2006-07-13 23:42:02
153	31	2006-07-13 21:48:55	2006-07-14 00:31:58
153	32	2006-07-13 21:48:55	2006-07-14 00:34:47
153	33	2006-07-13 21:48:55	2006-07-14 00:44:00
153	136	2006-07-13 21:48:55	2006-07-14 00:18:15
153	35	2006-07-13 21:48:55	2006-07-14 00:38:05
153	36	2006-07-13 21:48:55	2006-07-14 00:36:50
153	39	2006-07-13 21:48:55	2006-07-14 00:30:08
153	40	2006-07-13 21:56:51	2006-07-14 00:37:49
153	81	2006-07-13 21:48:55	2006-07-14 00:37:53
153	41	2006-07-13 21:48:55	2006-07-14 00:38:14
153	42	2006-07-13 21:48:55	2006-07-14 00:37:38
153	43	2006-07-13 21:48:55	2006-07-14 00:37:39
153	62	2006-07-13 21:53:46	2006-07-13 23:27:05
153	45	2006-07-13 21:54:46	2006-07-14 00:39:56
153	142	2006-07-13 21:48:55	2006-07-14 00:40:02
153	48	2006-07-13 21:48:55	2006-07-14 00:54:31
153	228	2006-07-13 21:48:55	2006-07-14 00:46:56
153	100	2006-07-13 21:48:55	2006-07-14 00:37:10
153	51	2006-07-13 21:48:55	2006-07-14 00:39:01
153	52	2006-07-13 21:48:55	2006-07-14 00:37:59
153	148	2006-07-13 21:48:55	2006-07-14 00:35:56
153	116	2006-07-13 21:48:55	2006-07-14 00:35:23
153	61	2006-07-13 21:48:55	2006-07-14 00:37:26
153	171	2006-07-13 21:48:55	2006-07-13 21:54:33
153	160	2006-07-13 21:48:55	2006-07-14 00:38:46
153	76	2006-07-13 21:48:55	2006-07-13 21:59:50
153	55	2006-07-13 21:48:55	2006-07-14 00:35:45
153	57	2006-07-13 21:48:55	2006-07-14 00:35:51
153	60	2006-07-13 21:48:55	2006-07-14 00:37:29
156	5	2006-07-15 11:00:00	2006-07-15 15:20:00
156	90	2006-07-15 11:00:00	2006-07-15 15:20:00
156	13	2006-07-15 11:00:00	2006-07-15 15:20:00
156	19	2006-07-15 11:00:00	2006-07-15 15:20:00
156	21	2006-07-15 11:00:00	2006-07-15 15:20:00
156	213	2006-07-15 11:00:00	2006-07-15 15:20:00
156	30	2006-07-15 11:00:00	2006-07-15 15:20:00
156	32	2006-07-15 11:00:00	2006-07-15 15:20:00
156	136	2006-07-15 12:15:02	2006-07-15 15:20:00
156	111	2006-07-15 11:00:00	2006-07-15 15:20:00
156	155	2006-07-15 11:00:00	2006-07-15 15:20:00
156	39	2006-07-15 11:00:00	2006-07-15 15:20:00
156	41	2006-07-15 11:00:00	2006-07-15 15:20:00
156	226	2006-07-15 11:00:00	2006-07-15 15:20:00
156	221	2006-07-15 11:00:00	2006-07-15 15:20:00
156	114	2006-07-15 11:00:00	2006-07-15 14:44:30
156	229	2006-07-15 11:00:00	2006-07-15 15:20:00
156	61	2006-07-15 11:00:00	2006-07-15 15:20:00
156	171	2006-07-15 11:00:00	2006-07-15 15:20:00
156	107	2006-07-15 11:00:00	2006-07-15 12:15:34
156	160	2006-07-15 11:00:00	2006-07-15 13:11:41
156	54	2006-07-15 11:00:00	2006-07-15 15:20:00
156	55	2006-07-15 11:00:00	2006-07-15 15:20:00
156	57	2006-07-15 14:06:55	2006-07-15 15:20:00
156	60	2006-07-15 11:00:00	2006-07-15 15:20:00
157	1	2006-07-15 19:13:17	2006-07-15 23:21:13
157	97	2006-07-15 19:27:22	2006-07-15 23:21:13
157	135	2006-07-15 19:16:50	2006-07-15 23:21:13
157	90	2006-07-15 19:13:17	2006-07-15 23:21:13
157	217	2006-07-15 19:17:34	2006-07-15 23:21:13
157	23	2006-07-15 19:25:09	2006-07-15 20:20:04
157	230	2006-07-15 19:18:49	2006-07-15 23:20:56
157	27	2006-07-15 19:27:58	2006-07-15 23:21:11
157	213	2006-07-15 19:46:22	2006-07-15 22:45:06
157	28	2006-07-15 20:24:50	2006-07-15 23:20:42
157	29	2006-07-15 19:32:07	2006-07-15 23:21:13
157	119	2006-07-15 21:04:25	2006-07-15 23:21:03
157	154	2006-07-15 19:18:24	2006-07-15 23:21:13
157	136	2006-07-15 19:16:41	2006-07-15 23:21:13
157	42	2006-07-15 19:18:27	2006-07-15 23:21:04
157	51	2006-07-15 19:14:52	2006-07-15 23:21:04
157	148	2006-07-15 19:15:36	2006-07-15 23:20:57
157	116	2006-07-15 19:13:55	2006-07-15 23:20:53
157	61	2006-07-15 19:18:30	2006-07-15 23:20:07
157	160	2006-07-15 19:13:17	2006-07-15 23:21:04
157	76	2006-07-15 19:14:57	2006-07-15 23:20:12
157	231	2006-07-15 19:14:40	2006-07-15 23:20:48
159	1	2006-07-17 21:00:00	2006-07-18 00:00:00
159	2	2006-07-17 21:00:00	2006-07-18 00:00:00
159	97	2006-07-17 21:00:00	2006-07-18 00:00:00
159	4	2006-07-17 21:00:00	2006-07-18 00:00:00
159	8	2006-07-17 21:00:00	2006-07-18 00:00:00
159	15	2006-07-17 21:00:00	2006-07-18 00:00:00
159	16	2006-07-17 21:00:00	2006-07-18 00:00:00
159	157	2006-07-17 21:00:00	2006-07-18 00:00:00
159	27	2006-07-17 21:00:00	2006-07-18 00:00:00
159	28	2006-07-17 21:00:00	2006-07-18 00:00:00
159	232	2006-07-17 21:00:00	2006-07-18 00:00:00
159	29	2006-07-17 21:00:00	2006-07-18 00:00:00
159	30	2006-07-17 21:00:00	2006-07-18 00:00:00
159	31	2006-07-17 21:00:00	2006-07-18 00:00:00
159	32	2006-07-17 21:00:00	2006-07-18 00:00:00
159	33	2006-07-17 21:00:00	2006-07-18 00:00:00
159	136	2006-07-17 21:00:00	2006-07-18 00:00:00
159	35	2006-07-17 21:00:00	2006-07-18 00:00:00
159	36	2006-07-17 21:00:00	2006-07-18 00:00:00
159	39	2006-07-17 21:00:00	2006-07-18 00:00:00
159	40	2006-07-17 21:00:00	2006-07-18 00:00:00
159	81	2006-07-17 21:00:00	2006-07-17 22:07:23
159	41	2006-07-17 21:00:00	2006-07-18 00:00:00
159	42	2006-07-17 21:00:00	2006-07-18 00:00:00
159	43	2006-07-17 21:00:00	2006-07-18 00:00:00
159	45	2006-07-17 21:00:00	2006-07-18 00:00:00
159	142	2006-07-17 21:00:00	2006-07-18 00:00:00
159	48	2006-07-17 21:00:00	2006-07-18 00:00:00
159	227	2006-07-17 21:00:00	2006-07-18 00:00:00
159	50	2006-07-17 21:00:00	2006-07-18 00:00:00
159	100	2006-07-17 21:00:00	2006-07-18 00:00:00
159	51	2006-07-17 21:00:00	2006-07-18 00:00:00
159	52	2006-07-17 21:00:00	2006-07-18 00:00:00
159	148	2006-07-17 21:00:00	2006-07-18 00:00:00
159	233	2006-07-17 21:00:00	2006-07-18 00:00:00
159	116	2006-07-17 21:00:00	2006-07-18 00:00:00
159	160	2006-07-17 21:00:00	2006-07-18 00:00:00
159	76	2006-07-17 22:07:31	2006-07-18 00:00:00
159	55	2006-07-17 21:00:00	2006-07-18 00:00:00
159	57	2006-07-17 21:00:00	2006-07-18 00:00:00
159	60	2006-07-17 21:00:00	2006-07-18 00:00:00
158	4	2006-07-16 19:30:00	2006-07-17 02:30:00
158	5	2006-07-16 19:30:00	2006-07-17 02:30:00
158	189	2006-07-17 01:08:30	2006-07-17 02:30:00
158	8	2006-07-16 22:36:49	2006-07-17 02:30:00
158	175	2006-07-16 19:30:00	2006-07-17 00:39:02
158	90	2006-07-16 19:30:00	2006-07-17 02:30:00
158	15	2006-07-16 19:30:00	2006-07-17 02:30:00
158	199	2006-07-16 19:30:00	2006-07-17 02:30:00
158	16	2006-07-16 19:30:00	2006-07-17 01:03:01
158	157	2006-07-16 19:30:00	2006-07-16 22:49:02
158	230	2006-07-16 19:30:00	2006-07-17 02:30:00
158	64	2006-07-16 19:30:00	2006-07-17 02:30:00
158	27	2006-07-16 19:30:00	2006-07-17 02:30:00
158	213	2006-07-16 23:20:04	2006-07-17 01:02:05
158	232	2006-07-17 02:02:16	2006-07-17 02:30:00
158	31	2006-07-16 19:30:00	2006-07-17 00:38:25
158	33	2006-07-16 19:30:00	2006-07-17 02:30:00
158	34	2006-07-16 19:30:00	2006-07-17 01:00:21
158	154	2006-07-16 19:30:00	2006-07-17 02:30:00
158	136	2006-07-16 19:30:00	2006-07-17 02:30:00
158	36	2006-07-16 22:34:15	2006-07-17 02:30:00
158	225	2006-07-16 19:30:00	2006-07-17 02:30:00
158	150	2006-07-16 19:30:00	2006-07-17 02:30:00
158	155	2006-07-16 19:30:00	2006-07-17 02:30:00
158	39	2006-07-17 02:04:55	2006-07-17 02:30:00
158	81	2006-07-17 01:04:18	2006-07-17 02:30:00
158	202	2006-07-16 19:30:00	2006-07-17 02:30:00
158	42	2006-07-17 01:28:54	2006-07-17 01:42:50
158	43	2006-07-17 01:03:28	2006-07-17 02:30:00
158	62	2006-07-16 19:30:00	2006-07-17 02:30:00
158	142	2006-07-17 00:26:58	2006-07-17 02:30:00
158	190	2006-07-16 19:30:00	2006-07-16 23:55:50
158	220	2006-07-16 19:30:00	2006-07-17 00:37:27
158	50	2006-07-16 19:30:00	2006-07-17 02:30:00
158	100	2006-07-16 19:30:00	2006-07-17 02:30:00
158	221	2006-07-16 19:30:00	2006-07-17 01:01:56
158	51	2006-07-17 00:42:07	2006-07-17 02:30:00
158	222	2006-07-16 19:30:00	2006-07-17 02:30:00
158	52	2006-07-16 19:30:00	2006-07-17 02:30:00
158	72	2006-07-16 19:30:00	2006-07-17 02:30:00
158	148	2006-07-16 19:30:00	2006-07-17 02:30:00
158	233	2006-07-17 02:02:13	2006-07-17 02:30:00
158	116	2006-07-16 19:30:00	2006-07-17 02:30:00
158	61	2006-07-16 19:30:00	2006-07-17 02:30:00
158	171	2006-07-16 19:30:00	2006-07-17 02:30:00
158	160	2006-07-16 19:30:00	2006-07-17 02:30:00
158	54	2006-07-16 19:30:00	2006-07-17 02:30:00
158	89	2006-07-16 19:30:00	2006-07-17 00:38:20
158	55	2006-07-16 19:30:00	2006-07-17 02:30:00
158	57	2006-07-16 19:30:00	2006-07-17 01:02:18
158	56	2006-07-16 19:30:00	2006-07-17 02:30:00
158	60	2006-07-16 19:30:00	2006-07-17 02:30:00
160	1	2006-07-18 21:00:00	2006-07-19 00:48:00
160	2	2006-07-18 21:00:00	2006-07-19 00:48:00
160	4	2006-07-18 21:00:00	2006-07-19 00:48:00
160	5	2006-07-18 21:33:29	2006-07-18 22:43:38
160	200	2006-07-18 21:09:04	2006-07-18 23:07:40
160	8	2006-07-18 21:00:00	2006-07-19 00:48:00
160	175	2006-07-18 23:07:47	2006-07-19 00:48:00
160	14	2006-07-18 21:00:00	2006-07-18 22:45:46
160	15	2006-07-18 21:00:00	2006-07-19 00:48:00
160	16	2006-07-18 21:00:00	2006-07-19 00:48:00
160	21	2006-07-18 21:00:00	2006-07-19 00:48:00
160	23	2006-07-18 21:00:00	2006-07-19 00:48:00
160	27	2006-07-18 21:00:00	2006-07-19 00:48:00
160	28	2006-07-18 21:00:00	2006-07-19 00:48:00
160	232	2006-07-18 21:00:00	2006-07-19 00:48:00
160	29	2006-07-18 21:00:00	2006-07-19 00:48:00
160	31	2006-07-18 21:00:00	2006-07-19 00:48:00
160	32	2006-07-18 21:00:00	2006-07-18 21:32:56
160	33	2006-07-18 21:00:00	2006-07-18 21:13:46
160	136	2006-07-18 21:00:00	2006-07-19 00:48:00
160	234	2006-07-18 22:48:11	2006-07-19 00:48:00
160	35	2006-07-18 21:00:00	2006-07-19 00:48:00
160	155	2006-07-18 21:00:00	2006-07-19 00:48:00
160	39	2006-07-18 21:12:43	2006-07-19 00:48:00
160	40	2006-07-18 21:00:00	2006-07-19 00:47:27
160	209	2006-07-18 21:15:51	2006-07-19 00:48:00
160	81	2006-07-18 21:00:00	2006-07-19 00:48:00
160	41	2006-07-18 21:00:00	2006-07-19 00:48:00
160	42	2006-07-18 21:00:00	2006-07-19 00:48:00
160	43	2006-07-18 21:00:00	2006-07-19 00:48:00
160	142	2006-07-18 21:00:00	2006-07-19 00:48:00
160	48	2006-07-18 21:00:00	2006-07-19 00:48:00
160	50	2006-07-18 22:46:08	2006-07-19 00:48:00
160	100	2006-07-18 21:00:00	2006-07-19 00:45:53
160	51	2006-07-18 21:00:00	2006-07-19 00:48:00
160	52	2006-07-18 21:00:00	2006-07-19 00:48:00
160	148	2006-07-18 22:46:18	2006-07-19 00:48:00
160	233	2006-07-18 21:00:00	2006-07-19 00:48:00
160	116	2006-07-18 21:00:00	2006-07-19 00:48:00
160	61	2006-07-18 21:00:00	2006-07-19 00:05:46
160	171	2006-07-18 21:00:00	2006-07-19 00:48:00
160	160	2006-07-18 21:00:00	2006-07-19 00:48:00
160	167	2006-07-18 21:00:00	2006-07-18 22:46:58
160	55	2006-07-18 21:00:00	2006-07-19 00:48:00
160	57	2006-07-18 21:00:00	2006-07-19 00:48:00
160	60	2006-07-18 21:00:00	2006-07-19 00:48:00
143	230	2006-07-06 21:30:00	2006-07-07 00:30:00
161	1	2006-07-20 21:00:00	2006-07-20 21:30:00
161	2	2006-07-20 21:00:00	2006-07-20 21:30:00
161	5	2006-07-20 21:00:00	2006-07-20 21:30:00
161	6	2006-07-20 21:00:00	2006-07-20 21:30:00
161	135	2006-07-20 21:00:00	2006-07-20 21:30:00
161	8	2006-07-20 21:00:00	2006-07-20 21:30:00
161	90	2006-07-20 21:00:00	2006-07-20 21:30:00
161	14	2006-07-20 21:00:00	2006-07-20 21:30:00
161	15	2006-07-20 21:00:00	2006-07-20 21:30:00
161	16	2006-07-20 21:00:00	2006-07-20 21:30:00
161	19	2006-07-20 21:00:00	2006-07-20 21:30:00
161	21	2006-07-20 21:00:00	2006-07-20 21:30:00
161	23	2006-07-20 21:00:00	2006-07-20 21:30:00
161	64	2006-07-20 21:00:00	2006-07-20 21:30:00
161	27	2006-07-20 21:00:00	2006-07-20 21:30:00
161	28	2006-07-20 21:00:00	2006-07-20 21:30:00
161	30	2006-07-20 21:00:00	2006-07-20 21:30:00
161	31	2006-07-20 21:00:00	2006-07-20 21:30:00
161	32	2006-07-20 21:00:00	2006-07-20 21:30:00
161	33	2006-07-20 21:00:00	2006-07-20 21:30:00
161	136	2006-07-20 21:00:00	2006-07-20 21:30:00
161	36	2006-07-20 21:00:00	2006-07-20 21:30:00
161	40	2006-07-20 21:00:00	2006-07-20 21:30:00
161	81	2006-07-20 21:00:00	2006-07-20 21:30:00
161	41	2006-07-20 21:00:00	2006-07-20 21:30:00
161	42	2006-07-20 21:00:00	2006-07-20 21:30:00
161	43	2006-07-20 21:00:00	2006-07-20 21:30:00
161	45	2006-07-20 21:00:00	2006-07-20 21:30:00
161	142	2006-07-20 21:00:00	2006-07-20 21:30:00
161	100	2006-07-20 21:00:00	2006-07-20 21:30:00
161	51	2006-07-20 21:00:00	2006-07-20 21:30:00
161	222	2006-07-20 21:00:00	2006-07-20 21:30:00
161	148	2006-07-20 21:00:00	2006-07-20 21:30:00
161	116	2006-07-20 21:00:00	2006-07-20 21:30:00
161	61	2006-07-20 21:00:00	2006-07-20 21:30:00
161	171	2006-07-20 21:00:00	2006-07-20 21:30:00
161	76	2006-07-20 21:00:00	2006-07-20 21:30:00
161	167	2006-07-20 21:00:00	2006-07-20 21:30:00
161	57	2006-07-20 21:00:00	2006-07-20 21:30:00
161	60	2006-07-20 21:00:00	2006-07-20 21:30:00
163	1	2006-07-20 21:45:00	2006-07-21 00:39:15
163	2	2006-07-20 21:45:00	2006-07-21 01:00:00
163	5	2006-07-20 21:45:00	2006-07-21 01:00:00
163	135	2006-07-20 21:45:00	2006-07-21 01:00:00
163	8	2006-07-20 21:45:00	2006-07-21 01:00:00
163	14	2006-07-20 21:45:00	2006-07-21 01:00:00
163	15	2006-07-20 21:45:00	2006-07-21 01:00:00
163	16	2006-07-20 21:45:00	2006-07-21 01:00:00
163	19	2006-07-20 21:45:00	2006-07-21 01:00:00
163	21	2006-07-20 21:45:00	2006-07-21 01:00:00
163	23	2006-07-20 21:45:00	2006-07-20 23:21:41
163	27	2006-07-20 21:45:00	2006-07-21 01:00:00
163	28	2006-07-20 21:45:00	2006-07-21 01:00:00
163	232	2006-07-20 21:57:39	2006-07-21 01:00:00
163	29	2006-07-20 21:45:01	2006-07-21 01:00:00
163	30	2006-07-20 21:45:00	2006-07-21 01:00:00
163	31	2006-07-20 21:45:00	2006-07-21 00:38:38
163	32	2006-07-20 21:45:00	2006-07-21 01:00:00
163	33	2006-07-20 21:45:00	2006-07-21 01:00:00
163	136	2006-07-20 21:45:00	2006-07-21 01:00:00
163	36	2006-07-20 21:45:00	2006-07-21 01:00:00
163	39	2006-07-20 21:45:00	2006-07-21 01:00:00
163	40	2006-07-20 21:45:00	2006-07-21 01:00:00
163	81	2006-07-20 21:45:00	2006-07-21 01:00:00
163	41	2006-07-20 21:45:00	2006-07-21 01:00:00
163	42	2006-07-20 21:45:00	2006-07-21 01:00:00
163	45	2006-07-20 21:45:00	2006-07-21 01:00:00
163	142	2006-07-20 21:45:00	2006-07-21 01:00:00
163	48	2006-07-20 21:45:00	2006-07-21 01:00:00
163	227	2006-07-20 23:26:21	2006-07-21 00:37:09
163	50	2006-07-20 21:47:46	2006-07-21 01:00:00
163	100	2006-07-20 21:45:00	2006-07-21 01:00:00
163	51	2006-07-20 21:45:00	2006-07-21 01:00:00
163	52	2006-07-20 22:38:22	2006-07-21 01:00:00
163	148	2006-07-20 21:45:00	2006-07-21 01:00:00
163	233	2006-07-20 21:57:21	2006-07-21 01:00:00
163	116	2006-07-20 21:45:00	2006-07-21 01:00:00
163	171	2006-07-20 21:45:00	2006-07-21 01:00:00
163	76	2006-07-20 21:45:00	2006-07-21 01:00:00
163	57	2006-07-20 21:45:00	2006-07-21 01:00:00
163	60	2006-07-20 21:45:00	2006-07-21 01:00:00
164	2	2006-07-22 10:45:00	2006-07-22 15:00:00
164	5	2006-07-22 10:45:00	2006-07-22 15:00:00
164	135	2006-07-22 10:45:00	2006-07-22 15:00:00
164	102	2006-07-22 13:49:50	2006-07-22 15:00:00
164	90	2006-07-22 10:45:00	2006-07-22 15:00:00
164	235	2006-07-22 11:14:31	2006-07-22 13:26:55
164	123	2006-07-22 10:45:00	2006-07-22 15:00:00
164	157	2006-07-22 10:45:00	2006-07-22 13:38:12
164	30	2006-07-22 10:45:00	2006-07-22 15:00:00
164	236	2006-07-22 10:45:00	2006-07-22 13:42:59
164	136	2006-07-22 13:29:08	2006-07-22 15:00:00
164	36	2006-07-22 10:45:00	2006-07-22 14:57:27
164	111	2006-07-22 10:45:00	2006-07-22 15:00:00
164	155	2006-07-22 10:45:00	2006-07-22 15:00:00
164	41	2006-07-22 10:45:00	2006-07-22 15:00:00
164	100	2006-07-22 13:38:04	2006-07-22 15:00:00
164	237	2006-07-22 10:45:00	2006-07-22 15:00:00
164	226	2006-07-22 10:45:00	2006-07-22 13:29:16
164	51	2006-07-22 10:45:00	2006-07-22 15:00:00
164	148	2006-07-22 10:45:00	2006-07-22 15:00:00
164	171	2006-07-22 10:45:00	2006-07-22 15:00:00
164	160	2006-07-22 10:45:00	2006-07-22 15:00:00
164	54	2006-07-22 10:45:00	2006-07-22 15:00:00
164	60	2006-07-22 13:39:18	2006-07-22 15:00:00
166	216	2006-07-24 00:03:53	2006-07-24 00:51:38
166	2	2006-07-24 02:29:49	2006-07-24 02:40:00
166	239	2006-07-23 19:25:30	2006-07-24 00:51:19
166	4	2006-07-23 19:10:00	2006-07-24 02:40:00
166	206	2006-07-23 19:10:03	2006-07-23 23:55:08
166	5	2006-07-23 19:14:40	2006-07-24 02:40:00
166	135	2006-07-23 22:18:07	2006-07-24 02:40:00
166	90	2006-07-23 19:10:00	2006-07-24 02:40:00
166	13	2006-07-24 01:56:51	2006-07-24 02:40:00
166	217	2006-07-24 00:34:22	2006-07-24 02:40:00
166	15	2006-07-23 19:16:39	2006-07-24 02:40:00
166	123	2006-07-23 22:54:57	2006-07-24 02:40:00
166	21	2006-07-23 19:10:00	2006-07-23 22:49:23
166	157	2006-07-23 19:14:26	2006-07-24 02:40:00
166	230	2006-07-23 19:14:49	2006-07-24 02:40:00
166	64	2006-07-23 19:10:24	2006-07-24 01:55:08
166	27	2006-07-23 19:16:51	2006-07-24 02:40:00
166	98	2006-07-23 19:14:57	2006-07-24 01:55:02
166	33	2006-07-23 21:37:26	2006-07-23 21:56:00
166	34	2006-07-23 19:17:13	2006-07-24 02:40:00
166	154	2006-07-23 19:18:21	2006-07-24 02:40:00
166	136	2006-07-23 19:13:10	2006-07-24 02:40:00
166	234	2006-07-23 19:10:08	2006-07-24 02:22:20
166	36	2006-07-24 00:54:29	2006-07-24 02:40:00
166	150	2006-07-23 19:10:21	2006-07-24 02:40:00
166	155	2006-07-23 19:11:01	2006-07-24 01:56:15
166	39	2006-07-24 00:53:39	2006-07-24 02:40:00
166	81	2006-07-24 00:54:51	2006-07-24 02:40:00
166	202	2006-07-23 19:12:55	2006-07-24 00:45:55
166	42	2006-07-23 22:50:26	2006-07-24 02:40:00
166	62	2006-07-24 01:56:06	2006-07-24 02:40:00
166	142	2006-07-23 19:25:47	2006-07-24 02:40:00
166	220	2006-07-23 19:10:23	2006-07-24 00:46:23
166	50	2006-07-24 00:49:29	2006-07-24 02:40:00
166	100	2006-07-23 19:15:34	2006-07-24 02:40:00
166	221	2006-07-23 19:10:00	2006-07-24 02:40:00
166	51	2006-07-24 00:54:23	2006-07-24 02:40:00
166	222	2006-07-24 02:01:42	2006-07-24 02:40:00
166	165	2006-07-23 23:07:12	2006-07-24 00:31:53
166	52	2006-07-23 19:10:16	2006-07-24 01:55:55
166	223	2006-07-23 19:21:24	2006-07-24 02:40:00
166	148	2006-07-23 19:17:42	2006-07-24 02:40:00
166	198	2006-07-23 19:24:37	2006-07-23 22:07:43
166	132	2006-07-23 19:23:36	2006-07-24 02:40:00
166	116	2006-07-23 19:10:01	2006-07-24 02:40:00
166	171	2006-07-23 19:10:09	2006-07-24 02:40:00
166	160	2006-07-23 19:12:05	2006-07-24 02:40:00
166	54	2006-07-23 19:15:46	2006-07-24 02:40:00
166	240	2006-07-23 20:21:16	2006-07-24 00:45:57
166	89	2006-07-23 19:22:30	2006-07-23 23:53:58
166	76	2006-07-23 19:10:00	2006-07-24 02:20:56
166	167	2006-07-23 19:17:26	2006-07-23 22:47:37
166	63	2006-07-23 19:10:12	2006-07-24 00:28:12
166	55	2006-07-23 19:19:24	2006-07-24 02:40:00
166	241	2006-07-23 19:14:34	2006-07-24 02:40:00
166	153	2006-07-23 19:10:41	2006-07-24 02:40:00
166	56	2006-07-23 19:11:40	2006-07-24 02:40:00
166	60	2006-07-24 01:55:26	2006-07-24 02:40:00
167	4	2006-07-24 21:00:00	2006-07-24 22:30:00
167	5	2006-07-24 21:00:00	2006-07-24 22:30:00
167	8	2006-07-24 21:00:00	2006-07-24 22:30:00
167	90	2006-07-24 21:00:00	2006-07-24 22:30:00
167	15	2006-07-24 21:00:00	2006-07-24 21:53:39
167	16	2006-07-24 21:00:00	2006-07-24 22:30:00
167	21	2006-07-24 21:00:00	2006-07-24 22:30:00
167	23	2006-07-24 21:00:00	2006-07-24 22:30:00
167	157	2006-07-24 21:00:00	2006-07-24 22:30:00
167	26	2006-07-24 21:00:00	2006-07-24 22:30:00
167	230	2006-07-24 21:00:00	2006-07-24 22:30:00
167	64	2006-07-24 21:00:00	2006-07-24 22:30:00
167	27	2006-07-24 21:00:00	2006-07-24 22:30:00
167	213	2006-07-24 21:00:00	2006-07-24 22:30:00
167	28	2006-07-24 21:00:00	2006-07-24 22:30:00
167	232	2006-07-24 21:56:20	2006-07-24 22:30:00
167	33	2006-07-24 21:00:00	2006-07-24 22:30:00
167	154	2006-07-24 21:00:00	2006-07-24 22:30:00
167	136	2006-07-24 21:00:00	2006-07-24 22:30:00
167	234	2006-07-24 21:02:28	2006-07-24 22:30:00
167	35	2006-07-24 21:00:00	2006-07-24 22:30:00
167	36	2006-07-24 21:00:00	2006-07-24 22:30:00
167	155	2006-07-24 21:00:00	2006-07-24 22:30:00
167	81	2006-07-24 21:00:00	2006-07-24 22:30:00
167	202	2006-07-24 21:00:00	2006-07-24 22:30:00
167	42	2006-07-24 21:00:00	2006-07-24 22:30:00
167	43	2006-07-24 21:00:00	2006-07-24 22:30:00
167	142	2006-07-24 21:00:00	2006-07-24 22:30:00
167	220	2006-07-24 21:00:00	2006-07-24 22:30:00
167	50	2006-07-24 21:00:00	2006-07-24 22:30:00
167	100	2006-07-24 21:00:00	2006-07-24 22:30:00
167	222	2006-07-24 21:00:00	2006-07-24 22:30:00
167	52	2006-07-24 21:00:00	2006-07-24 22:30:00
167	223	2006-07-24 21:00:00	2006-07-24 21:55:07
167	148	2006-07-24 21:00:00	2006-07-24 22:30:00
167	233	2006-07-24 21:55:25	2006-07-24 22:30:00
167	116	2006-07-24 21:00:00	2006-07-24 22:30:00
167	61	2006-07-24 21:00:00	2006-07-24 22:30:00
167	171	2006-07-24 21:00:00	2006-07-24 22:30:00
167	107	2006-07-24 21:00:00	2006-07-24 22:30:00
167	160	2006-07-24 21:00:00	2006-07-24 22:30:00
167	54	2006-07-24 21:00:00	2006-07-24 22:30:00
167	89	2006-07-24 21:00:00	2006-07-24 22:30:00
167	63	2006-07-24 21:00:00	2006-07-24 22:30:00
167	55	2006-07-24 21:00:00	2006-07-24 22:30:00
167	57	2006-07-24 21:00:00	2006-07-24 22:30:00
167	56	2006-07-24 21:00:00	2006-07-24 22:30:00
168	1	2006-07-24 23:00:00	2006-07-25 00:45:00
168	4	2006-07-24 23:00:00	2006-07-25 00:45:00
168	8	2006-07-24 23:00:00	2006-07-25 00:45:00
168	15	2006-07-24 23:00:00	2006-07-25 00:45:00
168	16	2006-07-24 23:00:00	2006-07-25 00:01:37
168	19	2006-07-24 23:00:00	2006-07-25 00:45:00
168	21	2006-07-24 23:00:00	2006-07-25 00:45:00
168	23	2006-07-24 23:00:00	2006-07-25 00:45:00
168	27	2006-07-24 23:00:00	2006-07-25 00:45:00
168	28	2006-07-24 23:00:00	2006-07-25 00:45:00
168	232	2006-07-24 23:00:00	2006-07-25 00:45:00
168	29	2006-07-24 23:00:00	2006-07-25 00:45:00
168	30	2006-07-24 23:00:00	2006-07-25 00:45:00
168	32	2006-07-24 23:00:00	2006-07-25 00:45:00
168	33	2006-07-24 23:00:00	2006-07-25 00:45:00
168	136	2006-07-24 23:00:00	2006-07-25 00:45:00
168	234	2006-07-24 23:00:00	2006-07-25 00:45:00
168	35	2006-07-24 23:00:00	2006-07-25 00:45:00
168	36	2006-07-24 23:00:00	2006-07-25 00:45:00
168	39	2006-07-24 23:00:00	2006-07-25 00:45:00
168	40	2006-07-24 23:00:00	2006-07-25 00:45:00
168	81	2006-07-24 23:00:00	2006-07-25 00:45:00
168	41	2006-07-24 23:00:00	2006-07-25 00:45:00
168	42	2006-07-24 23:00:00	2006-07-25 00:45:00
168	43	2006-07-24 23:00:00	2006-07-25 00:45:00
168	45	2006-07-24 23:00:00	2006-07-25 00:45:00
168	142	2006-07-24 23:00:00	2006-07-25 00:45:00
168	48	2006-07-24 23:00:00	2006-07-25 00:45:00
168	50	2006-07-24 23:00:00	2006-07-25 00:45:00
168	100	2006-07-24 23:00:00	2006-07-25 00:45:00
168	51	2006-07-24 23:00:00	2006-07-25 00:45:00
168	52	2006-07-24 23:00:00	2006-07-25 00:45:00
168	233	2006-07-24 23:00:00	2006-07-25 00:45:00
168	116	2006-07-24 23:00:00	2006-07-25 00:45:00
168	61	2006-07-24 23:00:00	2006-07-25 00:45:00
168	171	2006-07-24 23:00:00	2006-07-25 00:45:00
168	107	2006-07-24 23:00:00	2006-07-25 00:45:00
168	160	2006-07-24 23:00:00	2006-07-25 00:45:00
168	55	2006-07-24 23:00:00	2006-07-25 00:45:00
168	57	2006-07-24 23:00:00	2006-07-25 00:45:00
168	60	2006-07-24 23:00:00	2006-07-25 00:45:00
169	1	2006-07-25 20:30:00	2006-07-25 21:05:00
169	2	2006-07-25 20:30:00	2006-07-25 21:05:00
169	4	2006-07-25 20:30:00	2006-07-25 21:05:00
169	135	2006-07-25 20:30:00	2006-07-25 21:05:00
169	90	2006-07-25 20:30:00	2006-07-25 21:05:00
169	15	2006-07-25 20:30:13	2006-07-25 21:05:00
169	21	2006-07-25 20:30:00	2006-07-25 21:05:00
169	157	2006-07-25 20:30:00	2006-07-25 21:05:00
169	27	2006-07-25 20:30:00	2006-07-25 21:05:00
169	232	2006-07-25 20:30:00	2006-07-25 21:05:00
169	30	2006-07-25 20:30:00	2006-07-25 21:05:00
169	32	2006-07-25 20:30:00	2006-07-25 21:05:00
169	154	2006-07-25 20:30:00	2006-07-25 21:05:00
169	136	2006-07-25 20:30:00	2006-07-25 21:05:00
169	234	2006-07-25 20:30:00	2006-07-25 21:05:00
169	35	2006-07-25 20:30:00	2006-07-25 21:05:00
169	36	2006-07-25 20:30:00	2006-07-25 21:05:00
169	225	2006-07-25 20:37:45	2006-07-25 21:05:00
169	150	2006-07-25 20:30:49	2006-07-25 21:05:00
169	155	2006-07-25 20:30:00	2006-07-25 21:05:00
169	39	2006-07-25 20:30:00	2006-07-25 21:05:00
169	81	2006-07-25 20:30:00	2006-07-25 21:05:00
169	43	2006-07-25 20:30:00	2006-07-25 21:05:00
169	45	2006-07-25 20:30:00	2006-07-25 21:05:00
169	142	2006-07-25 20:30:00	2006-07-25 21:05:00
169	50	2006-07-25 20:30:00	2006-07-25 21:05:00
169	100	2006-07-25 20:30:00	2006-07-25 21:05:00
169	51	2006-07-25 20:30:00	2006-07-25 21:05:00
169	222	2006-07-25 20:34:21	2006-07-25 21:05:00
169	52	2006-07-25 20:30:00	2006-07-25 21:05:00
169	233	2006-07-25 20:30:00	2006-07-25 21:05:00
169	116	2006-07-25 20:30:00	2006-07-25 21:05:00
169	61	2006-07-25 20:30:00	2006-07-25 21:05:00
169	171	2006-07-25 20:30:00	2006-07-25 21:05:00
169	160	2006-07-25 20:30:00	2006-07-25 21:05:00
169	167	2006-07-25 20:30:00	2006-07-25 21:05:00
169	55	2006-07-25 20:30:00	2006-07-25 21:05:00
169	57	2006-07-25 20:30:00	2006-07-25 21:05:00
169	153	2006-07-25 20:30:00	2006-07-25 21:05:00
169	60	2006-07-25 20:30:00	2006-07-25 21:05:00
170	1	2006-07-25 21:20:00	2006-07-25 21:24:37
170	2	2006-07-25 21:20:00	2006-07-26 00:35:00
170	4	2006-07-25 21:20:00	2006-07-26 00:35:00
170	6	2006-07-25 21:20:00	2006-07-26 00:35:00
170	135	2006-07-25 21:20:00	2006-07-26 00:35:00
170	8	2006-07-25 21:20:00	2006-07-25 23:33:48
170	15	2006-07-25 21:20:00	2006-07-26 00:35:00
170	16	2006-07-25 21:20:00	2006-07-26 00:35:00
170	19	2006-07-25 21:20:00	2006-07-26 00:35:00
170	21	2006-07-25 21:20:00	2006-07-26 00:35:00
170	23	2006-07-25 21:20:00	2006-07-26 00:35:00
170	157	2006-07-25 21:31:03	2006-07-26 00:35:00
170	27	2006-07-25 21:20:00	2006-07-26 00:35:00
170	28	2006-07-25 21:20:00	2006-07-26 00:35:00
170	232	2006-07-25 21:20:00	2006-07-26 00:35:00
170	29	2006-07-25 21:20:00	2006-07-26 00:35:00
170	30	2006-07-25 21:20:00	2006-07-25 23:59:36
170	31	2006-07-25 21:20:00	2006-07-26 00:35:00
170	32	2006-07-25 21:20:00	2006-07-26 00:35:00
170	33	2006-07-25 21:20:00	2006-07-26 00:35:00
170	136	2006-07-25 21:20:00	2006-07-26 00:35:00
170	35	2006-07-25 21:20:00	2006-07-26 00:35:00
170	36	2006-07-25 21:20:00	2006-07-25 23:55:43
170	150	2006-07-25 23:35:39	2006-07-26 00:35:00
170	155	2006-07-25 21:20:00	2006-07-26 00:35:00
170	39	2006-07-25 21:20:00	2006-07-26 00:35:00
170	40	2006-07-25 21:20:00	2006-07-26 00:35:00
170	42	2006-07-25 22:04:08	2006-07-26 00:35:00
170	43	2006-07-25 21:20:00	2006-07-26 00:35:00
170	45	2006-07-25 21:20:00	2006-07-26 00:35:00
170	142	2006-07-25 21:20:00	2006-07-26 00:35:00
170	48	2006-07-25 21:20:00	2006-07-26 00:35:00
170	50	2006-07-25 21:20:00	2006-07-26 00:35:00
170	100	2006-07-25 21:20:00	2006-07-26 00:35:00
170	51	2006-07-25 21:20:00	2006-07-26 00:35:00
170	52	2006-07-25 21:20:00	2006-07-26 00:35:00
170	148	2006-07-25 23:55:53	2006-07-26 00:35:00
170	233	2006-07-25 21:20:00	2006-07-26 00:35:00
170	116	2006-07-25 21:20:00	2006-07-26 00:35:00
170	61	2006-07-25 21:24:50	2006-07-25 22:03:37
170	171	2006-07-25 21:20:00	2006-07-25 23:59:18
170	160	2006-07-25 21:20:00	2006-07-26 00:35:00
170	205	2006-07-25 21:30:11	2006-07-26 00:35:00
170	76	2006-07-25 23:59:46	2006-07-26 00:35:00
170	55	2006-07-25 21:20:00	2006-07-26 00:35:00
170	57	2006-07-25 21:20:00	2006-07-26 00:35:00
170	60	2006-07-25 21:20:00	2006-07-26 00:35:00
171	1	2006-07-27 20:45:00	2006-07-27 23:45:35
176	239	2006-07-29 19:30:00	2006-07-29 20:30:00
176	206	2006-07-29 19:30:00	2006-07-29 20:30:00
171	206	2006-07-27 22:19:46	2006-07-28 00:14:57
176	135	2006-07-29 19:30:00	2006-07-29 20:30:00
176	243	2006-07-29 19:30:00	2006-07-29 20:30:00
176	90	2006-07-29 19:30:00	2006-07-29 20:30:00
176	15	2006-07-29 19:30:00	2006-07-29 20:30:00
176	123	2006-07-29 19:30:00	2006-07-29 20:30:00
176	21	2006-07-29 19:30:23	2006-07-29 20:30:00
171	21	2006-07-27 20:45:00	2006-07-28 00:15:02
176	157	2006-07-29 19:30:00	2006-07-29 20:30:00
176	244	2006-07-29 19:30:00	2006-07-29 20:30:00
176	27	2006-07-29 19:30:00	2006-07-29 20:30:00
176	232	2006-07-29 19:30:00	2006-07-29 20:30:00
176	29	2006-07-29 19:30:00	2006-07-29 20:30:00
176	245	2006-07-29 19:30:00	2006-07-29 20:30:00
171	31	2006-07-27 20:45:00	2006-07-28 00:15:37
176	154	2006-07-29 19:30:00	2006-07-29 20:30:00
176	136	2006-07-29 19:30:00	2006-07-29 20:30:00
176	246	2006-07-29 19:30:00	2006-07-29 20:30:00
176	35	2006-07-29 19:30:00	2006-07-29 20:30:00
176	225	2006-07-29 19:30:00	2006-07-29 20:30:00
176	84	2006-07-29 19:30:00	2006-07-29 20:30:00
171	40	2006-07-27 20:45:00	2006-07-27 23:56:14
176	155	2006-07-29 19:30:00	2006-07-29 20:30:00
176	202	2006-07-29 19:30:00	2006-07-29 20:30:00
176	44	2006-07-29 19:30:00	2006-07-29 20:30:00
176	247	2006-07-29 19:30:00	2006-07-29 20:30:00
176	248	2006-07-29 19:30:00	2006-07-29 20:30:00
176	249	2006-07-29 19:30:00	2006-07-29 20:30:00
176	221	2006-07-29 19:30:00	2006-07-29 20:30:00
176	188	2006-07-29 19:30:00	2006-07-29 20:30:00
176	165	2006-07-29 19:51:53	2006-07-29 20:30:00
171	148	2006-07-27 20:45:00	2006-07-27 22:17:55
176	151	2006-07-29 19:30:00	2006-07-29 20:30:00
176	223	2006-07-29 19:30:00	2006-07-29 20:30:00
176	233	2006-07-29 19:30:00	2006-07-29 20:30:00
176	116	2006-07-29 19:30:00	2006-07-29 20:30:00
176	61	2006-07-29 19:30:00	2006-07-29 20:30:00
176	250	2006-07-29 19:30:00	2006-07-29 20:30:00
176	160	2006-07-29 19:30:00	2006-07-29 20:30:00
176	240	2006-07-29 19:30:00	2006-07-29 20:30:00
176	55	2006-07-29 19:30:00	2006-07-29 20:30:00
176	241	2006-07-29 19:30:00	2006-07-29 19:39:49
171	2	2006-07-27 20:45:00	2006-07-28 00:35:00
171	4	2006-07-27 20:45:00	2006-07-28 00:35:00
171	6	2006-07-27 20:45:00	2006-07-28 00:35:00
171	200	2006-07-28 00:23:35	2006-07-28 00:35:00
171	8	2006-07-27 20:45:00	2006-07-28 00:35:00
171	15	2006-07-27 20:45:00	2006-07-28 00:35:00
171	16	2006-07-27 20:45:00	2006-07-28 00:35:00
171	19	2006-07-27 20:45:00	2006-07-28 00:35:00
171	24	2006-07-27 20:45:00	2006-07-28 00:35:00
171	27	2006-07-27 20:45:00	2006-07-28 00:35:00
171	28	2006-07-27 20:45:00	2006-07-28 00:35:00
171	232	2006-07-27 20:48:02	2006-07-28 00:35:00
171	29	2006-07-27 20:45:00	2006-07-28 00:35:00
171	30	2006-07-27 20:45:00	2006-07-28 00:35:00
171	32	2006-07-27 20:45:00	2006-07-28 00:35:00
171	33	2006-07-27 20:45:00	2006-07-28 00:35:00
171	34	2006-07-27 23:56:57	2006-07-28 00:35:00
171	136	2006-07-27 20:45:00	2006-07-28 00:35:00
171	35	2006-07-27 20:45:00	2006-07-28 00:35:00
171	39	2006-07-27 23:46:17	2006-07-28 00:35:00
171	41	2006-07-27 20:45:00	2006-07-28 00:35:00
171	43	2006-07-27 20:45:00	2006-07-28 00:35:00
171	45	2006-07-27 20:45:00	2006-07-28 00:35:00
171	142	2006-07-27 20:45:00	2006-07-28 00:35:00
171	48	2006-07-27 20:45:00	2006-07-28 00:35:00
171	50	2006-07-27 20:45:00	2006-07-28 00:35:00
171	100	2006-07-27 20:45:00	2006-07-28 00:35:00
171	51	2006-07-27 20:45:00	2006-07-28 00:35:00
171	52	2006-07-27 20:45:00	2006-07-28 00:35:00
171	233	2006-07-27 20:45:00	2006-07-28 00:35:00
171	116	2006-07-27 20:45:00	2006-07-28 00:35:00
171	61	2006-07-27 20:45:00	2006-07-28 00:35:00
171	171	2006-07-28 00:23:29	2006-07-28 00:35:00
171	107	2006-07-27 20:45:00	2006-07-28 00:35:00
171	160	2006-07-27 20:45:00	2006-07-28 00:35:00
171	76	2006-07-27 20:45:00	2006-07-28 00:35:00
171	55	2006-07-27 20:45:00	2006-07-28 00:35:00
171	57	2006-07-27 20:45:00	2006-07-28 00:35:00
171	60	2006-07-27 20:45:00	2006-07-28 00:35:00
176	251	2006-07-29 19:30:00	2006-07-29 20:30:00
176	231	2006-07-29 19:30:00	2006-07-29 20:30:00
176	60	2006-07-29 19:30:00	2006-07-29 20:30:00
177	135	2006-07-30 00:46:48	2006-07-30 01:57:19
177	243	2006-07-29 22:00:00	2006-07-30 00:41:25
177	90	2006-07-29 22:00:00	2006-07-30 02:45:00
177	235	2006-07-29 22:00:00	2006-07-30 02:45:00
177	217	2006-07-29 22:00:00	2006-07-30 02:45:00
177	15	2006-07-29 22:00:00	2006-07-30 02:45:00
177	19	2006-07-29 22:00:00	2006-07-30 02:45:00
177	157	2006-07-29 22:00:00	2006-07-29 23:04:04
177	252	2006-07-29 23:56:20	2006-07-30 02:45:00
177	244	2006-07-29 22:00:00	2006-07-29 23:55:08
177	24	2006-07-29 22:33:01	2006-07-30 00:44:41
177	230	2006-07-29 22:00:00	2006-07-30 02:45:00
177	27	2006-07-29 22:00:00	2006-07-30 02:45:00
177	213	2006-07-29 22:00:00	2006-07-29 22:32:45
177	35	2006-07-29 22:00:00	2006-07-30 02:45:00
177	39	2006-07-29 22:00:00	2006-07-30 02:45:00
177	40	2006-07-30 00:46:20	2006-07-30 02:45:00
177	253	2006-07-29 23:56:42	2006-07-30 00:42:44
177	202	2006-07-29 22:00:00	2006-07-30 02:45:00
177	142	2006-07-29 22:00:00	2006-07-30 02:45:00
177	100	2006-07-29 22:00:00	2006-07-30 02:45:00
177	221	2006-07-29 22:00:00	2006-07-30 02:45:00
177	52	2006-07-30 01:58:01	2006-07-30 02:45:00
177	223	2006-07-29 22:00:00	2006-07-30 02:03:53
177	116	2006-07-29 22:00:00	2006-07-30 02:45:00
177	61	2006-07-29 23:06:09	2006-07-30 02:45:00
177	107	2006-07-29 22:00:00	2006-07-30 02:45:00
177	167	2006-07-29 23:57:32	2006-07-30 02:45:00
177	231	2006-07-29 22:00:00	2006-07-30 02:45:00
175	1	2006-08-01 20:40:00	2006-08-01 21:40:00
175	2	2006-08-01 20:40:00	2006-08-01 21:40:00
174	2	2006-07-31 21:00:00	2006-08-01 00:15:00
174	4	2006-07-31 21:00:00	2006-08-01 00:15:00
174	5	2006-07-31 21:00:00	2006-08-01 00:15:00
174	200	2006-07-31 22:31:00	2006-08-01 00:15:00
174	135	2006-07-31 22:07:22	2006-08-01 00:15:00
174	8	2006-07-31 21:00:00	2006-08-01 00:15:00
174	15	2006-07-31 21:00:00	2006-08-01 00:15:00
174	16	2006-07-31 21:00:00	2006-08-01 00:15:00
174	19	2006-07-31 21:00:00	2006-08-01 00:15:00
174	23	2006-07-31 21:00:00	2006-08-01 00:15:00
173	256	2006-07-30 19:30:00	2006-07-30 19:57:07
174	157	2006-07-31 21:00:00	2006-08-01 00:15:00
174	24	2006-07-31 21:00:00	2006-07-31 22:27:04
174	27	2006-07-31 21:00:00	2006-08-01 00:15:00
174	28	2006-07-31 21:00:00	2006-08-01 00:15:00
174	232	2006-07-31 21:00:00	2006-07-31 22:58:54
174	29	2006-07-31 21:00:00	2006-08-01 00:15:00
174	30	2006-07-31 21:00:00	2006-08-01 00:15:00
174	31	2006-07-31 21:00:00	2006-08-01 00:15:00
174	32	2006-07-31 21:00:00	2006-08-01 00:15:00
174	154	2006-07-31 23:05:29	2006-08-01 00:15:00
174	136	2006-07-31 21:00:00	2006-08-01 00:15:00
174	35	2006-07-31 21:00:00	2006-08-01 00:15:00
174	36	2006-07-31 21:00:00	2006-08-01 00:15:00
174	39	2006-07-31 21:11:49	2006-08-01 00:15:00
174	40	2006-07-31 21:00:00	2006-08-01 00:15:00
174	41	2006-07-31 21:00:00	2006-08-01 00:15:00
174	43	2006-07-31 21:00:00	2006-08-01 00:15:00
174	45	2006-07-31 21:00:00	2006-08-01 00:15:00
174	142	2006-07-31 21:00:00	2006-08-01 00:15:00
174	48	2006-07-31 21:00:00	2006-08-01 00:15:00
174	50	2006-07-31 21:00:00	2006-08-01 00:15:00
174	100	2006-07-31 21:00:00	2006-08-01 00:15:00
174	221	2006-07-31 22:05:43	2006-08-01 00:15:00
174	51	2006-07-31 21:00:00	2006-08-01 00:15:00
174	52	2006-07-31 21:00:00	2006-08-01 00:15:00
174	233	2006-07-31 21:00:00	2006-08-01 00:15:00
174	116	2006-07-31 21:00:00	2006-08-01 00:15:00
174	61	2006-07-31 21:00:00	2006-08-01 00:15:00
174	171	2006-07-31 21:00:00	2006-07-31 22:00:05
173	205	2006-07-30 19:30:00	2006-07-31 02:00:00
174	160	2006-07-31 21:00:00	2006-07-31 21:58:13
174	55	2006-07-31 21:00:00	2006-08-01 00:15:00
174	57	2006-07-31 21:00:00	2006-08-01 00:15:00
174	153	2006-07-31 21:00:00	2006-08-01 00:15:00
174	60	2006-07-31 21:00:00	2006-08-01 00:15:00
173	2	2006-07-31 00:42:30	2006-07-31 02:00:00
173	239	2006-07-30 19:30:00	2006-07-31 02:00:00
173	4	2006-07-30 19:30:00	2006-07-31 02:00:00
173	5	2006-07-31 00:20:08	2006-07-31 02:00:00
173	156	2006-07-30 19:30:00	2006-07-31 02:00:00
173	200	2006-07-31 00:46:43	2006-07-31 02:00:00
173	90	2006-07-30 19:30:00	2006-07-31 01:08:56
173	15	2006-07-30 19:30:00	2006-07-31 02:00:00
173	199	2006-07-30 19:30:00	2006-07-31 02:00:00
173	123	2006-07-30 19:30:00	2006-07-31 02:00:00
173	157	2006-07-30 19:30:00	2006-07-31 01:02:50
173	244	2006-07-30 19:30:00	2006-07-31 02:00:00
173	230	2006-07-30 19:30:00	2006-07-31 02:00:00
173	27	2006-07-30 19:30:00	2006-07-31 02:00:00
173	213	2006-07-30 19:30:00	2006-07-31 02:00:00
173	31	2006-07-30 19:30:00	2006-07-31 00:18:39
173	33	2006-07-30 19:38:59	2006-07-31 02:00:00
173	34	2006-07-30 19:30:00	2006-07-31 02:00:00
173	154	2006-07-30 19:30:00	2006-07-31 02:00:00
173	136	2006-07-30 21:22:34	2006-07-31 02:00:00
173	225	2006-07-30 19:30:00	2006-07-31 02:00:00
173	150	2006-07-30 19:30:00	2006-07-31 02:00:00
173	155	2006-07-30 19:30:00	2006-07-31 02:00:00
173	81	2006-07-30 19:30:00	2006-07-31 02:00:00
173	202	2006-07-30 19:30:00	2006-07-31 02:00:00
173	43	2006-07-30 19:30:00	2006-07-31 02:00:00
173	62	2006-07-31 01:06:12	2006-07-31 02:00:00
173	44	2006-07-30 19:30:00	2006-07-31 02:00:00
173	142	2006-07-30 19:30:00	2006-07-31 02:00:00
173	48	2006-07-31 01:10:59	2006-07-31 02:00:00
173	221	2006-07-30 19:30:00	2006-07-31 02:00:00
173	51	2006-07-31 00:44:08	2006-07-31 02:00:00
173	188	2006-07-30 19:30:00	2006-07-31 00:40:52
173	222	2006-07-30 19:30:00	2006-07-31 02:00:00
173	223	2006-07-30 20:01:38	2006-07-31 02:00:00
173	198	2006-07-31 01:02:02	2006-07-31 01:04:21
173	116	2006-07-30 19:30:00	2006-07-31 02:00:00
173	250	2006-07-30 19:30:00	2006-07-31 02:00:00
173	171	2006-07-30 19:30:00	2006-07-31 02:00:00
173	160	2006-07-30 19:30:00	2006-07-31 02:00:00
173	54	2006-07-30 19:30:00	2006-07-31 02:00:00
173	89	2006-07-30 19:30:00	2006-07-31 00:40:45
173	76	2006-07-30 19:30:00	2006-07-31 02:00:00
173	167	2006-07-30 19:30:00	2006-07-30 23:33:35
173	55	2006-07-30 19:30:00	2006-07-31 02:00:00
173	57	2006-07-30 19:30:00	2006-07-31 00:44:26
173	241	2006-07-30 19:30:00	2006-07-31 02:00:00
173	251	2006-07-30 19:50:42	2006-07-31 00:41:43
173	153	2006-07-30 19:30:00	2006-07-31 02:00:00
173	60	2006-07-31 00:46:33	2006-07-31 02:00:00
175	135	2006-08-01 20:40:00	2006-08-01 21:40:00
175	8	2006-08-01 20:40:00	2006-08-01 21:40:00
175	90	2006-08-01 20:40:00	2006-08-01 21:40:00
175	15	2006-08-01 20:40:00	2006-08-01 21:40:00
175	16	2006-08-01 20:40:00	2006-08-01 21:40:00
175	19	2006-08-01 20:40:00	2006-08-01 21:40:00
175	21	2006-08-01 20:40:00	2006-08-01 21:40:00
175	23	2006-08-01 20:40:00	2006-08-01 21:18:10
175	157	2006-08-01 20:40:00	2006-08-01 21:40:00
175	27	2006-08-01 20:40:00	2006-08-01 21:40:00
175	213	2006-08-01 20:40:00	2006-08-01 21:40:00
175	28	2006-08-01 20:40:00	2006-08-01 21:40:00
175	232	2006-08-01 20:40:00	2006-08-01 21:40:00
175	30	2006-08-01 20:40:00	2006-08-01 21:40:00
175	31	2006-08-01 20:40:00	2006-08-01 21:40:00
175	32	2006-08-01 20:40:00	2006-08-01 21:40:00
175	136	2006-08-01 20:40:00	2006-08-01 21:40:00
175	35	2006-08-01 20:40:00	2006-08-01 21:40:00
175	36	2006-08-01 20:40:00	2006-08-01 21:40:00
175	225	2006-08-01 20:40:00	2006-08-01 21:40:00
175	155	2006-08-01 20:40:00	2006-08-01 21:40:00
175	41	2006-08-01 20:40:00	2006-08-01 21:40:00
175	43	2006-08-01 20:40:00	2006-08-01 21:40:00
175	142	2006-08-01 20:40:00	2006-08-01 21:40:00
175	50	2006-08-01 20:40:00	2006-08-01 21:40:00
175	100	2006-08-01 20:40:00	2006-08-01 21:40:00
175	221	2006-08-01 20:40:00	2006-08-01 21:40:00
175	51	2006-08-01 20:40:00	2006-08-01 21:40:00
175	222	2006-08-01 20:40:00	2006-08-01 21:40:00
175	52	2006-08-01 20:40:00	2006-08-01 21:40:00
175	233	2006-08-01 20:40:00	2006-08-01 21:40:00
175	116	2006-08-01 20:40:00	2006-08-01 21:40:00
175	61	2006-08-01 20:40:00	2006-08-01 21:40:00
175	171	2006-08-01 20:40:00	2006-08-01 21:40:00
175	54	2006-08-01 20:40:00	2006-08-01 21:40:00
175	167	2006-08-01 20:40:00	2006-08-01 21:40:00
175	55	2006-08-01 20:40:00	2006-08-01 21:40:00
175	241	2006-08-01 20:40:00	2006-08-01 21:38:50
175	153	2006-08-01 20:40:00	2006-08-01 21:40:00
175	60	2006-08-01 20:40:00	2006-08-01 21:40:00
178	1	2006-08-01 22:00:00	2006-08-02 00:45:00
178	2	2006-08-01 22:00:00	2006-08-02 00:45:00
178	97	2006-08-01 22:00:00	2006-08-02 00:45:00
178	4	2006-08-01 22:00:00	2006-08-02 00:45:00
178	5	2006-08-01 22:00:00	2006-08-02 00:45:00
178	6	2006-08-02 00:00:56	2006-08-02 00:45:00
178	200	2006-08-01 22:01:27	2006-08-02 00:45:00
178	135	2006-08-01 22:00:00	2006-08-02 00:45:00
178	8	2006-08-01 22:00:00	2006-08-01 23:40:18
178	15	2006-08-01 22:00:00	2006-08-02 00:45:00
178	16	2006-08-01 22:00:00	2006-08-02 00:45:00
178	19	2006-08-01 22:00:00	2006-08-02 00:45:00
178	21	2006-08-01 22:00:00	2006-08-02 00:45:00
178	157	2006-08-01 22:00:00	2006-08-01 23:56:59
178	27	2006-08-01 22:00:00	2006-08-02 00:45:00
178	28	2006-08-01 22:00:00	2006-08-02 00:45:00
178	232	2006-08-01 22:00:00	2006-08-02 00:45:00
178	29	2006-08-01 22:00:00	2006-08-02 00:45:00
178	30	2006-08-01 22:00:00	2006-08-02 00:45:00
178	31	2006-08-01 22:00:00	2006-08-02 00:45:00
178	32	2006-08-01 22:00:00	2006-08-02 00:45:00
178	136	2006-08-01 22:00:00	2006-08-02 00:45:00
178	35	2006-08-01 22:00:00	2006-08-02 00:45:00
178	36	2006-08-01 22:00:00	2006-08-02 00:45:00
178	39	2006-08-01 22:00:00	2006-08-02 00:45:00
178	40	2006-08-01 22:00:00	2006-08-02 00:45:00
178	41	2006-08-01 22:00:00	2006-08-02 00:45:00
178	43	2006-08-01 22:00:00	2006-08-02 00:45:00
178	45	2006-08-01 22:52:49	2006-08-02 00:45:00
178	142	2006-08-01 22:00:00	2006-08-02 00:45:00
178	48	2006-08-01 22:00:00	2006-08-02 00:45:00
178	50	2006-08-01 22:00:00	2006-08-02 00:45:00
178	100	2006-08-01 22:00:00	2006-08-02 00:45:00
178	221	2006-08-01 22:00:00	2006-08-02 00:45:00
178	51	2006-08-01 22:00:00	2006-08-02 00:45:00
178	52	2006-08-01 22:00:00	2006-08-02 00:06:12
178	233	2006-08-01 22:00:00	2006-08-02 00:45:00
178	116	2006-08-01 22:00:00	2006-08-02 00:45:00
178	61	2006-08-01 22:00:00	2006-08-02 00:45:00
178	171	2006-08-01 22:00:00	2006-08-02 00:45:00
178	160	2006-08-01 22:00:00	2006-08-01 22:52:40
178	76	2006-08-01 23:43:39	2006-08-02 00:45:00
178	55	2006-08-01 22:00:00	2006-08-02 00:45:00
178	60	2006-08-01 22:00:00	2006-08-02 00:45:00
180	1	2006-08-03 21:05:00	2006-08-03 21:35:00
180	2	2006-08-03 21:05:00	2006-08-03 21:35:00
180	200	2006-08-03 21:05:00	2006-08-03 21:35:00
180	135	2006-08-03 21:05:00	2006-08-03 21:35:00
180	90	2006-08-03 21:05:00	2006-08-03 21:35:00
180	13	2006-08-03 21:05:00	2006-08-03 21:35:00
180	15	2006-08-03 21:05:00	2006-08-03 21:35:00
180	16	2006-08-03 21:05:00	2006-08-03 21:35:00
180	18	2006-08-03 21:05:00	2006-08-03 21:35:00
180	23	2006-08-03 21:05:00	2006-08-03 21:35:00
180	157	2006-08-03 21:05:00	2006-08-03 21:35:00
180	24	2006-08-03 21:05:00	2006-08-03 21:35:00
180	230	2006-08-03 21:05:00	2006-08-03 21:35:00
180	27	2006-08-03 21:05:00	2006-08-03 21:35:00
180	213	2006-08-03 21:05:00	2006-08-03 21:35:00
180	28	2006-08-03 21:05:00	2006-08-03 21:35:00
180	232	2006-08-03 21:05:00	2006-08-03 21:35:00
180	30	2006-08-03 21:05:00	2006-08-03 21:35:00
180	31	2006-08-03 21:05:00	2006-08-03 21:35:00
180	136	2006-08-03 21:05:00	2006-08-03 21:35:00
180	36	2006-08-03 21:05:00	2006-08-03 21:35:00
180	150	2006-08-03 21:05:00	2006-08-03 21:35:00
180	155	2006-08-03 21:05:00	2006-08-03 21:35:00
180	81	2006-08-03 21:05:00	2006-08-03 21:35:00
180	41	2006-08-03 21:05:00	2006-08-03 21:35:00
180	43	2006-08-03 21:05:00	2006-08-03 21:35:00
180	259	2006-08-03 21:05:00	2006-08-03 21:35:00
180	142	2006-08-03 21:05:00	2006-08-03 21:35:00
180	260	2006-08-03 21:05:00	2006-08-03 21:35:00
180	50	2006-08-03 21:05:00	2006-08-03 21:35:00
180	100	2006-08-03 21:05:00	2006-08-03 21:35:00
180	114	2006-08-03 21:05:00	2006-08-03 21:14:59
180	51	2006-08-03 21:05:00	2006-08-03 21:35:00
180	233	2006-08-03 21:05:00	2006-08-03 21:35:00
180	116	2006-08-03 21:05:00	2006-08-03 21:35:00
180	61	2006-08-03 21:05:00	2006-08-03 21:35:00
180	160	2006-08-03 21:05:00	2006-08-03 21:35:00
180	55	2006-08-03 21:05:00	2006-08-03 21:35:00
180	153	2006-08-03 21:05:00	2006-08-03 21:35:00
180	60	2006-08-03 21:05:00	2006-08-03 21:35:00
179	1	2006-08-03 22:00:00	2006-08-04 00:45:00
179	2	2006-08-03 22:00:00	2006-08-04 00:45:00
179	4	2006-08-03 22:00:00	2006-08-04 00:45:00
179	5	2006-08-03 22:00:00	2006-08-04 00:45:00
179	6	2006-08-03 22:00:00	2006-08-04 00:39:12
179	200	2006-08-03 22:00:44	2006-08-04 00:45:00
179	8	2006-08-03 22:00:00	2006-08-04 00:45:00
179	13	2006-08-03 22:00:00	2006-08-03 23:07:49
179	15	2006-08-03 22:00:00	2006-08-04 00:45:00
179	16	2006-08-03 22:00:00	2006-08-04 00:45:00
179	19	2006-08-03 22:00:00	2006-08-04 00:45:00
179	21	2006-08-03 22:00:00	2006-08-04 00:45:00
179	23	2006-08-03 22:00:00	2006-08-03 22:49:49
179	157	2006-08-03 22:49:20	2006-08-04 00:45:00
179	24	2006-08-03 22:00:00	2006-08-04 00:45:00
179	230	2006-08-03 22:00:00	2006-08-04 00:45:00
179	27	2006-08-03 22:00:00	2006-08-04 00:45:00
179	28	2006-08-03 22:00:00	2006-08-04 00:45:00
179	232	2006-08-03 22:00:00	2006-08-04 00:45:00
179	29	2006-08-03 22:00:00	2006-08-04 00:45:00
179	30	2006-08-03 22:00:00	2006-08-04 00:45:00
179	31	2006-08-03 22:00:00	2006-08-04 00:45:00
179	136	2006-08-03 22:00:00	2006-08-04 00:45:00
179	36	2006-08-03 22:00:00	2006-08-04 00:45:00
179	39	2006-08-03 22:00:00	2006-08-04 00:45:00
179	40	2006-08-03 23:01:50	2006-08-04 00:45:00
179	81	2006-08-03 22:00:00	2006-08-04 00:45:00
179	41	2006-08-03 22:00:00	2006-08-04 00:45:00
179	43	2006-08-03 22:00:00	2006-08-04 00:45:00
179	259	2006-08-03 22:00:45	2006-08-03 22:49:14
179	45	2006-08-04 00:30:34	2006-08-04 00:45:00
179	142	2006-08-03 22:00:00	2006-08-04 00:45:00
179	48	2006-08-03 22:00:00	2006-08-04 00:45:00
179	50	2006-08-03 22:00:00	2006-08-04 00:45:00
179	100	2006-08-03 22:00:00	2006-08-04 00:45:00
179	51	2006-08-03 22:00:00	2006-08-04 00:45:00
179	222	2006-08-03 22:00:00	2006-08-04 00:45:00
179	233	2006-08-03 22:00:00	2006-08-04 00:45:00
179	116	2006-08-03 22:00:00	2006-08-04 00:45:00
179	61	2006-08-03 23:19:18	2006-08-04 00:45:00
179	160	2006-08-03 22:00:00	2006-08-04 00:29:45
179	55	2006-08-03 22:00:00	2006-08-04 00:45:00
179	153	2006-08-03 22:00:00	2006-08-04 00:45:00
179	60	2006-08-03 22:00:00	2006-08-04 00:45:00
181	206	2006-08-05 11:00:00	2006-08-05 13:23:51
181	135	2006-08-05 11:00:00	2006-08-05 15:45:00
181	8	2006-08-05 11:00:00	2006-08-05 15:45:00
181	90	2006-08-05 11:00:00	2006-08-05 15:45:00
181	13	2006-08-05 13:23:44	2006-08-05 15:45:00
181	32	2006-08-05 11:00:28	2006-08-05 14:39:50
181	154	2006-08-05 14:33:40	2006-08-05 15:45:00
181	258	2006-08-05 13:06:09	2006-08-05 15:45:00
181	155	2006-08-05 11:00:00	2006-08-05 15:45:00
181	39	2006-08-05 11:00:00	2006-08-05 14:32:48
181	120	2006-08-05 11:00:00	2006-08-05 15:45:00
181	41	2006-08-05 11:00:00	2006-08-05 14:53:26
172	1	2006-07-29 14:39:14	2006-07-29 17:00:00
172	2	2006-07-29 11:00:00	2006-07-29 14:39:28
172	206	2006-07-29 11:00:00	2006-07-29 15:41:53
172	90	2006-07-29 11:00:00	2006-07-29 15:41:55
172	123	2006-07-29 11:00:00	2006-07-29 17:00:00
172	157	2006-07-29 11:00:00	2006-07-29 17:00:00
172	24	2006-07-29 15:49:28	2006-07-29 17:00:00
172	26	2006-07-29 11:00:00	2006-07-29 12:21:03
172	230	2006-07-29 15:49:28	2006-07-29 17:00:00
172	245	2006-07-29 11:00:00	2006-07-29 15:03:04
172	32	2006-07-29 15:49:28	2006-07-29 17:00:00
172	136	2006-07-29 11:00:00	2006-07-29 17:00:00
172	35	2006-07-29 15:41:20	2006-07-29 17:00:00
172	111	2006-07-29 11:00:00	2006-07-29 17:00:00
172	39	2006-07-29 11:00:00	2006-07-29 13:33:55
172	41	2006-07-29 11:00:00	2006-07-29 15:41:55
172	44	2006-07-29 11:00:00	2006-07-29 17:00:00
172	248	2006-07-29 15:41:28	2006-07-29 17:00:00
172	100	2006-07-29 11:00:00	2006-07-29 12:06:45
172	221	2006-07-29 12:23:24	2006-07-29 17:00:00
172	51	2006-07-29 14:04:48	2006-07-29 17:00:00
172	188	2006-07-29 12:08:33	2006-07-29 15:41:55
172	223	2006-07-29 15:49:28	2006-07-29 17:00:00
172	116	2006-07-29 11:00:00	2006-07-29 17:00:00
172	61	2006-07-29 11:00:00	2006-07-29 15:41:55
172	171	2006-07-29 11:00:00	2006-07-29 17:00:00
172	107	2006-07-29 11:00:00	2006-07-29 17:00:00
172	160	2006-07-29 13:31:09	2006-07-29 17:00:00
172	54	2006-07-29 11:00:00	2006-07-29 16:37:14
172	89	2006-07-29 11:00:00	2006-07-29 17:00:00
172	167	2006-07-29 11:00:00	2006-07-29 15:40:46
172	251	2006-07-29 11:00:00	2006-07-29 15:39:59
172	60	2006-07-29 15:05:29	2006-07-29 17:00:00
181	259	2006-08-05 11:00:00	2006-08-05 14:32:16
181	44	2006-08-05 11:00:00	2006-08-05 15:45:00
181	190	2006-08-05 14:39:21	2006-08-05 15:45:00
181	261	2006-08-05 11:00:00	2006-08-05 15:45:00
181	100	2006-08-05 11:00:00	2006-08-05 15:45:00
181	233	2006-08-05 14:34:30	2006-08-05 15:27:52
181	116	2006-08-05 11:00:00	2006-08-05 15:45:00
181	171	2006-08-05 11:00:00	2006-08-05 15:45:00
181	160	2006-08-05 14:32:34	2006-08-05 15:45:00
181	262	2006-08-05 12:56:13	2006-08-05 14:50:04
181	212	2006-08-05 11:00:00	2006-08-05 15:45:00
181	251	2006-08-05 11:00:00	2006-08-05 15:45:00
181	60	2006-08-05 11:00:00	2006-08-05 15:45:00
186	244	2006-08-05 19:30:00	2006-08-05 20:45:00
186	97	2006-08-05 19:30:00	2006-08-05 20:45:00
186	239	2006-08-05 19:30:00	2006-08-05 20:45:00
186	156	2006-08-05 19:30:00	2006-08-05 20:45:00
186	200	2006-08-05 19:30:00	2006-08-05 20:45:00
186	135	2006-08-05 19:30:00	2006-08-05 20:45:00
186	90	2006-08-05 19:30:00	2006-08-05 20:45:00
186	13	2006-08-05 19:30:00	2006-08-05 20:45:00
186	217	2006-08-05 19:30:00	2006-08-05 20:45:00
186	230	2006-08-05 19:30:00	2006-08-05 20:45:00
186	27	2006-08-05 19:30:00	2006-08-05 20:45:00
186	213	2006-08-05 19:30:00	2006-08-05 20:45:00
186	32	2006-08-05 19:30:00	2006-08-05 20:29:31
186	154	2006-08-05 19:30:00	2006-08-05 20:45:00
186	136	2006-08-05 19:30:00	2006-08-05 20:45:00
186	258	2006-08-05 19:30:00	2006-08-05 20:45:00
186	225	2006-08-05 19:30:00	2006-08-05 20:45:00
186	150	2006-08-05 19:30:00	2006-08-05 20:45:00
186	155	2006-08-05 19:30:00	2006-08-05 20:45:00
186	120	2006-08-05 19:30:00	2006-08-05 20:45:00
186	253	2006-08-05 19:30:00	2006-08-05 20:45:00
186	259	2006-08-05 19:30:00	2006-08-05 20:45:00
186	44	2006-08-05 19:30:00	2006-08-05 20:45:00
186	142	2006-08-05 19:30:00	2006-08-05 20:45:00
186	100	2006-08-05 19:30:00	2006-08-05 20:45:00
186	264	2006-08-05 19:30:00	2006-08-05 20:45:00
186	114	2006-08-05 20:00:00	2006-08-05 20:45:00
186	188	2006-08-05 19:30:00	2006-08-05 20:45:00
186	242	2006-08-05 19:30:00	2006-08-05 20:45:00
186	116	2006-08-05 19:30:00	2006-08-05 20:45:00
186	171	2006-08-05 19:30:00	2006-08-05 20:45:00
186	160	2006-08-05 19:30:00	2006-08-05 20:45:00
186	240	2006-08-05 19:30:00	2006-08-05 20:45:00
186	76	2006-08-05 20:27:41	2006-08-05 20:45:00
186	212	2006-08-05 19:30:00	2006-08-05 20:45:00
186	55	2006-08-05 19:30:00	2006-08-05 20:45:00
186	251	2006-08-05 19:30:00	2006-08-05 20:45:00
186	153	2006-08-05 19:30:00	2006-08-05 20:45:00
186	56	2006-08-05 19:30:00	2006-08-05 20:45:00
186	60	2006-08-05 19:45:00	2006-08-05 20:45:00
182	2	2006-08-06 23:17:30	2006-08-07 00:15:00
182	97	2006-08-06 23:28:15	2006-08-07 00:15:00
182	4	2006-08-06 19:30:00	2006-08-06 20:46:03
182	5	2006-08-06 23:07:10	2006-08-07 00:15:00
182	156	2006-08-06 19:30:00	2006-08-06 23:14:25
182	200	2006-08-06 19:36:21	2006-08-06 23:09:41
182	135	2006-08-06 19:30:00	2006-08-07 00:15:00
182	8	2006-08-06 19:30:00	2006-08-07 00:15:00
182	90	2006-08-06 19:30:00	2006-08-07 00:15:00
182	235	2006-08-06 19:58:08	2006-08-06 23:12:07
182	13	2006-08-06 19:30:39	2006-08-07 00:15:00
182	15	2006-08-06 19:30:00	2006-08-07 00:15:00
182	23	2006-08-06 23:29:52	2006-08-06 23:41:54
182	244	2006-08-06 19:30:00	2006-08-07 00:15:00
182	255	2006-08-06 23:14:56	2006-08-07 00:15:00
182	27	2006-08-06 19:30:00	2006-08-07 00:15:00
182	213	2006-08-06 19:30:00	2006-08-07 00:15:00
182	28	2006-08-06 19:49:04	2006-08-06 22:20:34
182	31	2006-08-06 19:30:00	2006-08-06 21:01:11
182	164	2006-08-06 19:33:49	2006-08-06 23:28:05
182	34	2006-08-06 19:30:00	2006-08-07 00:15:00
182	119	2006-08-06 19:30:00	2006-08-07 00:15:00
182	154	2006-08-06 19:30:00	2006-08-07 00:15:00
182	258	2006-08-06 21:02:23	2006-08-07 00:15:00
182	150	2006-08-06 19:30:00	2006-08-07 00:15:00
182	155	2006-08-06 19:30:00	2006-08-07 00:15:00
182	253	2006-08-06 19:30:00	2006-08-06 23:07:19
182	81	2006-08-06 22:22:45	2006-08-06 23:07:22
182	43	2006-08-06 19:30:00	2006-08-07 00:15:00
182	259	2006-08-06 19:30:00	2006-08-07 00:15:00
182	44	2006-08-06 19:30:00	2006-08-07 00:15:00
182	265	2006-08-06 19:30:00	2006-08-06 19:46:43
182	220	2006-08-06 19:39:44	2006-08-07 00:15:00
182	221	2006-08-06 19:30:00	2006-08-07 00:15:00
182	114	2006-08-06 19:30:00	2006-08-07 00:15:00
182	51	2006-08-06 23:10:17	2006-08-07 00:15:00
182	188	2006-08-06 19:30:00	2006-08-07 00:15:00
182	222	2006-08-06 19:30:00	2006-08-07 00:15:00
182	52	2006-08-06 19:31:44	2006-08-07 00:15:00
182	72	2006-08-06 22:21:28	2006-08-07 00:15:00
182	148	2006-08-06 21:03:53	2006-08-07 00:15:00
182	116	2006-08-06 19:30:00	2006-08-07 00:15:00
182	171	2006-08-06 19:30:00	2006-08-07 00:15:00
182	109	2006-08-06 19:30:00	2006-08-07 00:15:00
182	107	2006-08-06 23:07:36	2006-08-07 00:15:00
182	160	2006-08-06 19:30:00	2006-08-07 00:15:00
182	240	2006-08-06 19:31:57	2006-08-06 23:04:38
182	89	2006-08-06 19:30:00	2006-08-07 00:15:00
182	76	2006-08-06 19:30:00	2006-08-06 19:35:34
182	167	2006-08-06 19:30:00	2006-08-06 23:28:06
182	55	2006-08-06 19:30:00	2006-08-07 00:15:00
182	57	2006-08-06 19:30:00	2006-08-07 00:15:00
182	251	2006-08-06 19:30:00	2006-08-07 00:15:00
182	153	2006-08-06 23:42:25	2006-08-07 00:15:00
182	59	2006-08-06 19:30:00	2006-08-07 00:15:00
183	1	2006-08-07 21:00:00	2006-08-08 00:25:00
183	2	2006-08-07 21:57:09	2006-08-08 00:25:00
183	4	2006-08-07 21:00:00	2006-08-08 00:25:00
183	8	2006-08-07 21:00:00	2006-08-08 00:25:00
183	13	2006-08-07 21:00:00	2006-08-07 21:18:30
183	15	2006-08-07 21:00:00	2006-08-08 00:25:00
183	16	2006-08-07 21:00:00	2006-08-08 00:25:00
183	21	2006-08-07 21:00:00	2006-08-08 00:25:00
183	157	2006-08-07 21:00:00	2006-08-07 22:50:05
183	255	2006-08-07 21:00:00	2006-08-08 00:25:00
183	230	2006-08-07 21:00:00	2006-08-08 00:25:00
183	27	2006-08-07 21:00:00	2006-08-08 00:25:00
183	28	2006-08-07 21:00:00	2006-08-08 00:25:00
183	232	2006-08-07 21:00:00	2006-08-08 00:25:00
183	29	2006-08-07 21:00:00	2006-08-08 00:25:00
183	30	2006-08-07 21:00:00	2006-08-08 00:25:00
183	31	2006-08-07 21:40:26	2006-08-08 00:25:00
183	32	2006-08-07 21:24:49	2006-08-08 00:25:00
183	33	2006-08-07 21:18:39	2006-08-08 00:25:00
183	136	2006-08-07 21:00:00	2006-08-08 00:25:00
183	35	2006-08-07 21:00:00	2006-08-08 00:25:00
183	36	2006-08-07 21:00:00	2006-08-08 00:25:00
183	225	2006-08-07 21:00:00	2006-08-08 00:25:00
183	155	2006-08-07 21:00:00	2006-08-08 00:25:00
183	39	2006-08-07 21:00:00	2006-08-08 00:25:00
183	40	2006-08-07 21:00:00	2006-08-08 00:25:00
183	41	2006-08-07 21:00:00	2006-08-08 00:25:00
183	43	2006-08-07 21:00:00	2006-08-08 00:25:00
183	259	2006-08-07 21:00:00	2006-08-07 21:24:41
183	45	2006-08-07 21:00:00	2006-08-08 00:25:00
183	142	2006-08-07 21:00:00	2006-08-08 00:25:00
183	48	2006-08-07 21:00:00	2006-08-08 00:25:00
183	50	2006-08-07 21:00:00	2006-08-08 00:25:00
183	100	2006-08-07 21:00:00	2006-08-08 00:25:00
183	51	2006-08-07 21:00:00	2006-08-08 00:25:00
183	52	2006-08-07 21:00:00	2006-08-08 00:25:00
183	148	2006-08-07 21:00:00	2006-08-08 00:21:20
183	233	2006-08-07 21:00:00	2006-08-08 00:25:00
183	116	2006-08-07 21:00:00	2006-08-08 00:25:00
183	171	2006-08-07 21:00:00	2006-08-07 23:37:17
183	160	2006-08-07 21:00:00	2006-08-08 00:04:17
183	76	2006-08-07 21:00:00	2006-08-08 00:25:00
183	55	2006-08-07 21:00:00	2006-08-08 00:25:00
183	57	2006-08-07 21:00:00	2006-08-08 00:25:00
183	153	2006-08-07 21:00:00	2006-08-08 00:25:00
183	60	2006-08-07 21:00:00	2006-08-08 00:25:00
185	1	2006-08-08 08:37:05	2006-08-08 11:40:00
185	2	2006-08-08 08:36:55	2006-08-08 11:40:00
185	97	2006-08-08 08:35:03	2006-08-08 11:40:00
185	4	2006-08-08 10:17:46	2006-08-08 11:40:00
185	5	2006-08-08 08:34:51	2006-08-08 11:40:00
185	135	2006-08-08 08:41:27	2006-08-08 11:40:00
185	8	2006-08-08 08:34:51	2006-08-08 11:40:00
185	13	2006-08-08 08:42:22	2006-08-08 11:40:00
185	15	2006-08-08 08:34:51	2006-08-08 11:40:00
185	16	2006-08-08 08:37:59	2006-08-08 11:40:00
185	21	2006-08-08 08:35:35	2006-08-08 11:40:00
185	23	2006-08-08 10:04:40	2006-08-08 11:40:00
185	157	2006-08-08 08:41:21	2006-08-08 11:40:00
185	255	2006-08-08 08:35:01	2006-08-08 11:40:00
185	27	2006-08-08 08:38:42	2006-08-08 11:40:00
185	213	2006-08-08 08:45:10	2006-08-08 11:40:00
185	28	2006-08-08 08:34:51	2006-08-08 11:40:00
185	232	2006-08-08 08:34:51	2006-08-08 11:40:00
185	29	2006-08-08 08:34:51	2006-08-08 11:40:00
185	30	2006-08-08 08:34:51	2006-08-08 11:40:00
185	32	2006-08-08 08:34:51	2006-08-08 11:40:00
185	136	2006-08-08 08:34:51	2006-08-08 11:40:00
185	39	2006-08-08 08:36:51	2006-08-08 11:07:15
185	81	2006-08-08 10:51:48	2006-08-08 11:40:00
185	41	2006-08-08 08:34:51	2006-08-08 11:40:00
185	43	2006-08-08 08:34:51	2006-08-08 11:40:00
185	45	2006-08-08 08:34:51	2006-08-08 11:40:00
185	142	2006-08-08 08:34:51	2006-08-08 11:40:00
185	48	2006-08-08 08:34:51	2006-08-08 11:40:00
185	50	2006-08-08 08:39:20	2006-08-08 11:40:00
185	100	2006-08-08 08:37:03	2006-08-08 11:40:00
185	51	2006-08-08 08:34:51	2006-08-08 11:40:00
185	188	2006-08-08 11:07:28	2006-08-08 11:40:00
185	52	2006-08-08 08:34:51	2006-08-08 11:40:00
185	233	2006-08-08 08:34:51	2006-08-08 11:40:00
185	116	2006-08-08 08:34:51	2006-08-08 11:40:00
185	171	2006-08-08 08:34:51	2006-08-08 11:40:00
185	160	2006-08-08 08:34:51	2006-08-08 11:40:00
185	205	2006-08-08 10:55:26	2006-08-08 11:40:00
185	167	2006-08-08 08:35:19	2006-08-08 10:33:05
185	118	2006-08-08 08:44:24	2006-08-08 10:04:36
185	55	2006-08-08 08:34:51	2006-08-08 11:40:00
185	57	2006-08-08 08:42:57	2006-08-08 11:40:00
185	153	2006-08-08 08:35:22	2006-08-08 10:17:12
185	60	2006-08-08 08:34:51	2006-08-08 11:40:00
184	2	2006-08-08 07:40:00	2006-08-08 08:20:15
184	135	2006-08-08 07:40:00	2006-08-08 08:20:15
184	8	2006-08-08 07:40:00	2006-08-08 08:20:15
184	90	2006-08-08 07:40:00	2006-08-08 08:20:15
184	13	2006-08-08 07:40:00	2006-08-08 08:20:15
184	15	2006-08-08 07:40:00	2006-08-08 08:20:15
184	21	2006-08-08 07:40:00	2006-08-08 08:20:15
184	157	2006-08-08 07:40:00	2006-08-08 08:20:15
184	230	2006-08-08 07:43:33	2006-08-08 08:20:15
184	64	2006-08-08 07:44:46	2006-08-08 08:20:15
184	27	2006-08-08 07:40:00	2006-08-08 08:20:15
184	213	2006-08-08 07:40:00	2006-08-08 08:20:15
184	28	2006-08-08 07:40:00	2006-08-08 08:20:15
184	232	2006-08-08 07:40:00	2006-08-08 08:20:15
184	29	2006-08-08 07:43:20	2006-08-08 07:50:14
184	30	2006-08-08 07:40:00	2006-08-08 08:20:15
184	164	2006-08-08 07:53:11	2006-08-08 08:20:15
184	32	2006-08-08 07:40:00	2006-08-08 08:20:15
184	154	2006-08-08 07:46:48	2006-08-08 08:20:15
184	136	2006-08-08 07:40:00	2006-08-08 08:20:15
184	150	2006-08-08 07:43:47	2006-08-08 08:20:15
184	39	2006-08-08 07:41:42	2006-08-08 08:20:15
184	41	2006-08-08 07:40:00	2006-08-08 08:20:15
184	43	2006-08-08 07:40:00	2006-08-08 08:20:15
184	259	2006-08-08 07:40:00	2006-08-08 08:20:15
184	45	2006-08-08 07:40:00	2006-08-08 08:20:15
184	142	2006-08-08 07:40:00	2006-08-08 08:20:15
184	50	2006-08-08 07:41:19	2006-08-08 08:20:15
184	100	2006-08-08 07:41:06	2006-08-08 08:20:15
184	51	2006-08-08 07:43:13	2006-08-08 08:20:15
184	222	2006-08-08 07:44:09	2006-08-08 08:20:15
184	165	2006-08-08 07:40:34	2006-08-08 08:20:15
184	52	2006-08-08 07:43:21	2006-08-08 07:46:10
184	233	2006-08-08 07:40:00	2006-08-08 08:20:15
184	116	2006-08-08 07:40:00	2006-08-08 08:20:15
184	171	2006-08-08 07:40:00	2006-08-08 08:20:15
184	109	2006-08-08 07:40:00	2006-08-08 08:20:15
184	63	2006-08-08 07:40:00	2006-08-08 08:20:15
184	55	2006-08-08 07:40:00	2006-08-08 08:20:15
184	57	2006-08-08 07:40:00	2006-08-08 08:20:15
184	153	2006-08-08 07:40:19	2006-08-08 08:20:15
184	160	2006-08-08 07:40:00	2006-08-08 08:20:15
188	1	2006-08-10 22:48:13	2006-08-11 00:45:00
188	2	2006-08-10 21:00:00	2006-08-11 00:45:00
188	97	2006-08-10 21:00:01	2006-08-11 00:45:00
188	4	2006-08-11 00:15:16	2006-08-11 00:45:00
188	5	2006-08-10 21:00:00	2006-08-11 00:45:00
188	8	2006-08-10 21:00:00	2006-08-11 00:45:00
188	15	2006-08-10 21:00:00	2006-08-11 00:45:00
188	16	2006-08-10 21:00:00	2006-08-11 00:45:00
188	21	2006-08-10 21:00:00	2006-08-11 00:45:00
188	157	2006-08-10 21:00:00	2006-08-11 00:17:10
188	244	2006-08-10 21:00:00	2006-08-11 00:45:00
188	255	2006-08-10 21:00:00	2006-08-11 00:45:00
188	27	2006-08-10 21:00:00	2006-08-11 00:45:00
188	213	2006-08-10 21:00:00	2006-08-10 22:48:03
188	28	2006-08-10 21:00:00	2006-08-11 00:45:00
188	232	2006-08-10 21:00:00	2006-08-11 00:45:00
188	29	2006-08-10 23:34:53	2006-08-11 00:45:00
188	30	2006-08-10 21:00:00	2006-08-11 00:45:00
188	31	2006-08-10 21:00:00	2006-08-11 00:12:45
188	32	2006-08-10 21:00:00	2006-08-11 00:45:00
188	33	2006-08-10 21:00:00	2006-08-11 00:45:00
188	136	2006-08-10 21:00:00	2006-08-11 00:45:00
188	234	2006-08-10 21:00:00	2006-08-11 00:45:00
188	35	2006-08-10 21:00:00	2006-08-11 00:45:00
188	258	2006-08-10 21:00:00	2006-08-11 00:45:00
188	150	2006-08-10 21:00:00	2006-08-11 00:45:00
188	39	2006-08-10 21:00:00	2006-08-10 23:25:25
188	41	2006-08-10 21:00:00	2006-08-11 00:45:00
188	43	2006-08-10 21:00:00	2006-08-11 00:45:00
188	45	2006-08-11 00:13:18	2006-08-11 00:45:00
188	142	2006-08-10 21:00:00	2006-08-11 00:45:00
188	48	2006-08-10 21:00:00	2006-08-11 00:45:00
188	100	2006-08-10 21:00:00	2006-08-11 00:45:00
188	103	2006-08-10 21:00:00	2006-08-11 00:45:00
188	51	2006-08-10 21:00:00	2006-08-11 00:45:00
188	222	2006-08-11 00:18:41	2006-08-11 00:45:00
188	52	2006-08-10 21:00:00	2006-08-11 00:45:00
188	233	2006-08-10 21:00:00	2006-08-11 00:45:00
188	116	2006-08-10 21:00:00	2006-08-11 00:45:00
188	160	2006-08-10 21:00:00	2006-08-11 00:12:34
188	55	2006-08-10 21:00:00	2006-08-11 00:45:00
188	57	2006-08-10 21:00:00	2006-08-11 00:45:00
188	251	2006-08-10 21:00:00	2006-08-11 00:45:00
188	153	2006-08-10 21:00:00	2006-08-11 00:45:00
188	60	2006-08-10 21:00:00	2006-08-11 00:45:00
189	206	2006-08-12 11:00:00	2006-08-12 12:35:39
189	5	2006-08-12 13:16:02	2006-08-12 15:41:38
189	200	2006-08-12 11:00:00	2006-08-12 14:49:54
189	135	2006-08-12 11:00:00	2006-08-12 16:25:00
189	90	2006-08-12 15:02:22	2006-08-12 16:19:50
189	186	2006-08-12 11:00:00	2006-08-12 12:19:11
189	13	2006-08-12 12:22:56	2006-08-12 16:25:00
189	123	2006-08-12 11:00:00	2006-08-12 13:16:13
189	238	2006-08-12 14:33:51	2006-08-12 16:25:00
189	157	2006-08-12 11:00:00	2006-08-12 16:25:00
189	255	2006-08-12 11:00:00	2006-08-12 15:53:49
189	268	2006-08-12 12:35:28	2006-08-12 14:34:05
189	213	2006-08-12 11:00:00	2006-08-12 15:45:32
189	29	2006-08-12 15:49:15	2006-08-12 16:25:00
189	30	2006-08-12 11:00:00	2006-08-12 12:27:47
189	234	2006-08-12 15:55:53	2006-08-12 16:25:00
189	258	2006-08-12 15:56:52	2006-08-12 16:25:00
189	257	2006-08-12 14:22:42	2006-08-12 16:25:00
189	269	2006-08-12 11:00:00	2006-08-12 13:41:24
189	39	2006-08-12 11:00:00	2006-08-12 16:25:00
189	81	2006-08-12 11:00:00	2006-08-12 14:21:18
189	259	2006-08-12 11:00:00	2006-08-12 13:55:29
189	62	2006-08-12 11:00:00	2006-08-12 15:48:33
189	44	2006-08-12 11:00:00	2006-08-12 16:25:00
189	142	2006-08-12 11:00:00	2006-08-12 12:13:33
189	100	2006-08-12 11:00:00	2006-08-12 16:25:00
189	114	2006-08-12 11:00:00	2006-08-12 14:42:22
189	103	2006-08-12 15:44:23	2006-08-12 16:25:00
189	188	2006-08-12 11:00:00	2006-08-12 16:24:20
189	72	2006-08-12 15:58:38	2006-08-12 16:25:00
189	148	2006-08-12 13:41:43	2006-08-12 16:24:40
189	116	2006-08-12 11:00:00	2006-08-12 16:25:00
189	171	2006-08-12 11:00:00	2006-08-12 16:25:00
189	89	2006-08-12 12:27:47	2006-08-12 16:25:00
189	57	2006-08-12 11:00:00	2006-08-12 16:25:00
189	60	2006-08-12 15:48:31	2006-08-12 15:58:43
193	266	2006-08-12 20:27:23	2006-08-12 21:00:00
193	2	2006-08-12 19:30:00	2006-08-12 21:00:00
193	97	2006-08-12 19:30:00	2006-08-12 20:25:47
193	4	2006-08-12 19:30:00	2006-08-12 21:00:00
193	5	2006-08-12 19:30:00	2006-08-12 21:00:00
193	135	2006-08-12 20:28:39	2006-08-12 21:00:00
193	186	2006-08-12 19:30:00	2006-08-12 21:00:00
193	13	2006-08-12 19:30:00	2006-08-12 21:00:00
193	123	2006-08-12 19:30:00	2006-08-12 21:00:00
193	157	2006-08-12 19:30:00	2006-08-12 21:00:00
193	244	2006-08-12 19:30:00	2006-08-12 21:00:00
193	230	2006-08-12 19:30:00	2006-08-12 21:00:00
193	27	2006-08-12 19:30:00	2006-08-12 21:00:00
193	213	2006-08-12 19:30:00	2006-08-12 21:00:00
193	30	2006-08-12 19:30:00	2006-08-12 21:00:00
193	154	2006-08-12 19:30:00	2006-08-12 21:00:00
193	136	2006-08-12 19:30:00	2006-08-12 21:00:00
193	258	2006-08-12 19:30:00	2006-08-12 21:00:00
193	36	2006-08-12 19:30:00	2006-08-12 21:00:00
193	257	2006-08-12 19:30:00	2006-08-12 20:25:56
193	150	2006-08-12 19:30:00	2006-08-12 21:00:00
193	155	2006-08-12 19:30:00	2006-08-12 21:00:00
193	39	2006-08-12 19:30:00	2006-08-12 21:00:00
193	43	2006-08-12 19:30:00	2006-08-12 21:00:00
193	259	2006-08-12 19:30:00	2006-08-12 21:00:00
193	50	2006-08-12 19:59:19	2006-08-12 21:00:00
193	100	2006-08-12 19:30:00	2006-08-12 20:25:51
193	103	2006-08-12 19:30:00	2006-08-12 21:00:00
193	51	2006-08-12 19:30:00	2006-08-12 21:00:00
193	52	2006-08-12 19:30:00	2006-08-12 20:26:03
193	72	2006-08-12 19:30:00	2006-08-12 21:00:00
193	116	2006-08-12 19:30:00	2006-08-12 21:00:00
193	61	2006-08-12 19:30:00	2006-08-12 21:00:00
193	109	2006-08-12 19:30:00	2006-08-12 21:00:00
193	160	2006-08-12 19:30:00	2006-08-12 21:00:00
193	212	2006-08-12 19:30:00	2006-08-12 21:00:00
193	55	2006-08-12 19:30:00	2006-08-12 21:00:00
193	57	2006-08-12 19:30:00	2006-08-12 20:25:59
193	251	2006-08-12 19:30:00	2006-08-12 21:00:00
193	153	2006-08-12 19:30:00	2006-08-12 21:00:00
193	60	2006-08-12 20:35:14	2006-08-12 21:00:00
191	266	2006-08-13 19:30:00	2006-08-14 00:40:00
191	4	2006-08-13 19:30:00	2006-08-14 00:40:00
191	135	2006-08-13 19:30:00	2006-08-13 23:34:59
191	65	2006-08-13 21:54:22	2006-08-14 00:40:00
191	90	2006-08-13 19:30:00	2006-08-14 00:40:00
191	235	2006-08-13 21:36:37	2006-08-13 23:50:24
191	186	2006-08-13 23:16:18	2006-08-14 00:40:00
191	13	2006-08-13 19:30:00	2006-08-14 00:40:00
191	123	2006-08-13 19:30:00	2006-08-14 00:40:00
191	157	2006-08-13 19:30:00	2006-08-14 00:40:00
191	161	2006-08-13 19:30:00	2006-08-13 23:09:41
191	255	2006-08-13 23:34:45	2006-08-14 00:40:00
191	230	2006-08-13 19:30:00	2006-08-14 00:40:00
191	27	2006-08-13 19:30:00	2006-08-14 00:39:07
191	213	2006-08-13 19:30:00	2006-08-14 00:40:00
191	98	2006-08-13 19:30:00	2006-08-14 00:40:00
191	31	2006-08-13 19:30:00	2006-08-13 21:23:31
191	34	2006-08-13 19:30:00	2006-08-14 00:40:00
191	119	2006-08-13 21:42:52	2006-08-13 23:12:34
191	154	2006-08-13 19:30:00	2006-08-14 00:39:25
191	258	2006-08-13 19:30:00	2006-08-14 00:40:00
191	225	2006-08-13 19:30:00	2006-08-14 00:40:00
191	150	2006-08-13 19:30:00	2006-08-14 00:40:00
191	155	2006-08-13 19:30:00	2006-08-14 00:40:00
191	39	2006-08-13 23:51:36	2006-08-14 00:40:00
191	81	2006-08-13 22:38:57	2006-08-13 23:33:05
191	259	2006-08-13 19:30:00	2006-08-14 00:14:05
191	270	2006-08-13 19:30:00	2006-08-14 00:40:00
191	44	2006-08-13 19:30:00	2006-08-14 00:40:00
191	114	2006-08-13 19:30:00	2006-08-13 19:32:37
191	103	2006-08-13 19:30:00	2006-08-14 00:40:00
191	51	2006-08-14 00:15:08	2006-08-14 00:40:00
191	188	2006-08-13 19:30:00	2006-08-14 00:40:00
191	271	2006-08-13 23:18:09	2006-08-14 00:40:00
191	222	2006-08-13 19:30:00	2006-08-14 00:40:00
191	52	2006-08-13 23:53:44	2006-08-14 00:40:00
191	151	2006-08-13 19:35:47	2006-08-13 23:33:00
191	72	2006-08-13 19:30:01	2006-08-14 00:40:00
191	148	2006-08-13 22:11:35	2006-08-14 00:40:00
191	132	2006-08-13 19:30:00	2006-08-13 22:38:48
191	116	2006-08-13 19:30:00	2006-08-14 00:40:00
191	61	2006-08-13 19:30:00	2006-08-14 00:39:10
191	171	2006-08-13 19:30:00	2006-08-14 00:40:00
191	109	2006-08-13 19:30:00	2006-08-14 00:40:00
191	262	2006-08-13 19:30:00	2006-08-13 22:03:28
191	240	2006-08-13 19:30:00	2006-08-13 23:33:40
191	89	2006-08-13 19:30:00	2006-08-14 00:40:00
191	76	2006-08-13 19:30:00	2006-08-14 00:40:00
191	167	2006-08-13 22:14:10	2006-08-14 00:40:00
191	118	2006-08-13 19:30:00	2006-08-13 23:30:51
191	63	2006-08-13 19:30:00	2006-08-13 22:13:48
191	55	2006-08-13 23:33:29	2006-08-14 00:40:00
191	57	2006-08-13 19:30:00	2006-08-14 00:40:00
191	251	2006-08-13 19:30:00	2006-08-13 21:35:13
191	153	2006-08-13 19:30:00	2006-08-14 00:40:00
197	1	2006-08-14 23:30:00	2006-08-15 00:30:00
197	266	2006-08-14 23:31:33	2006-08-15 00:30:00
197	2	2006-08-14 23:30:00	2006-08-15 00:30:00
197	97	2006-08-14 23:30:00	2006-08-15 00:30:00
197	4	2006-08-14 23:30:00	2006-08-15 00:30:00
197	135	2006-08-14 23:30:00	2006-08-15 00:30:00
197	8	2006-08-14 23:30:00	2006-08-15 00:30:00
197	13	2006-08-14 23:30:00	2006-08-15 00:30:00
197	15	2006-08-14 23:30:00	2006-08-15 00:30:00
197	16	2006-08-14 23:30:00	2006-08-15 00:30:00
197	19	2006-08-14 23:30:00	2006-08-15 00:30:00
197	23	2006-08-14 23:30:00	2006-08-15 00:30:00
197	161	2006-08-14 23:30:00	2006-08-15 00:30:00
197	255	2006-08-14 23:30:00	2006-08-15 00:30:00
197	27	2006-08-14 23:30:00	2006-08-15 00:30:00
197	213	2006-08-14 23:30:00	2006-08-15 00:30:00
197	28	2006-08-14 23:30:00	2006-08-15 00:30:00
197	29	2006-08-14 23:30:00	2006-08-15 00:30:00
197	30	2006-08-14 23:30:00	2006-08-15 00:30:00
197	32	2006-08-14 23:30:00	2006-08-15 00:30:00
197	33	2006-08-14 23:30:00	2006-08-15 00:30:00
197	34	2006-08-14 23:32:34	2006-08-15 00:30:00
197	136	2006-08-14 23:30:00	2006-08-15 00:30:00
197	35	2006-08-14 23:30:00	2006-08-15 00:30:00
197	36	2006-08-14 23:30:00	2006-08-15 00:30:00
190	266	2006-08-12 18:15:00	2006-08-12 19:40:00
190	239	2006-08-12 18:15:00	2006-08-12 19:40:00
190	135	2006-08-12 18:15:00	2006-08-12 19:40:00
190	102	2006-08-12 18:27:04	2006-08-12 19:40:00
190	235	2006-08-12 18:15:00	2006-08-12 19:40:00
190	186	2006-08-12 18:15:00	2006-08-12 19:40:00
190	13	2006-08-12 18:33:38	2006-08-12 19:40:00
190	199	2006-08-12 18:43:40	2006-08-12 19:40:00
190	123	2006-08-12 18:15:00	2006-08-12 19:40:00
190	238	2006-08-12 18:29:49	2006-08-12 19:40:00
190	157	2006-08-12 18:15:00	2006-08-12 19:40:00
190	244	2006-08-12 18:15:00	2006-08-12 19:40:00
190	161	2006-08-12 18:42:33	2006-08-12 19:40:00
190	230	2006-08-12 18:15:00	2006-08-12 19:40:00
190	27	2006-08-12 18:15:00	2006-08-12 19:40:00
190	213	2006-08-12 18:15:00	2006-08-12 19:40:00
190	154	2006-08-12 18:15:00	2006-08-12 19:40:00
190	136	2006-08-12 18:15:00	2006-08-12 19:40:00
190	258	2006-08-12 18:15:00	2006-08-12 19:40:00
190	150	2006-08-12 18:15:00	2006-08-12 19:40:00
190	259	2006-08-12 18:15:00	2006-08-12 19:40:00
190	273	2006-08-12 18:35:51	2006-08-12 19:40:00
190	265	2006-08-12 18:24:26	2006-08-12 19:40:00
190	249	2006-08-12 18:15:00	2006-08-12 19:40:00
190	220	2006-08-12 18:15:00	2006-08-12 19:40:00
190	114	2006-08-12 18:17:33	2006-08-12 19:40:00
190	103	2006-08-12 18:15:00	2006-08-12 19:40:00
190	188	2006-08-12 18:15:00	2006-08-12 19:40:00
190	151	2006-08-12 18:15:00	2006-08-12 18:15:26
190	72	2006-08-12 18:15:00	2006-08-12 19:40:00
190	116	2006-08-12 18:15:00	2006-08-12 19:40:00
190	61	2006-08-12 18:15:00	2006-08-12 19:40:00
190	240	2006-08-12 18:15:00	2006-08-12 19:40:00
190	212	2006-08-12 18:15:00	2006-08-12 19:40:00
190	118	2006-08-12 18:15:00	2006-08-12 19:40:00
190	251	2006-08-12 18:15:00	2006-08-12 19:12:34
190	153	2006-08-12 18:15:00	2006-08-12 19:40:00
190	59	2006-08-12 18:15:00	2006-08-12 19:40:00
190	60	2006-08-12 18:15:00	2006-08-12 19:40:00
197	39	2006-08-14 23:30:00	2006-08-15 00:30:00
197	41	2006-08-14 23:30:00	2006-08-15 00:30:00
197	43	2006-08-14 23:30:00	2006-08-15 00:30:00
197	259	2006-08-14 23:30:00	2006-08-14 23:52:19
197	45	2006-08-14 23:30:00	2006-08-15 00:30:00
197	142	2006-08-14 23:30:00	2006-08-15 00:30:00
197	48	2006-08-14 23:30:00	2006-08-15 00:30:00
197	50	2006-08-14 23:30:00	2006-08-15 00:30:00
197	100	2006-08-14 23:30:00	2006-08-15 00:30:00
197	103	2006-08-14 23:30:00	2006-08-15 00:30:00
197	51	2006-08-14 23:30:00	2006-08-15 00:30:00
197	52	2006-08-14 23:30:00	2006-08-15 00:30:00
197	116	2006-08-14 23:30:00	2006-08-15 00:30:00
197	61	2006-08-14 23:30:00	2006-08-15 00:30:00
197	171	2006-08-14 23:55:29	2006-08-15 00:30:00
197	55	2006-08-14 23:30:00	2006-08-15 00:30:00
197	60	2006-08-14 23:30:00	2006-08-15 00:30:00
192	1	2006-08-14 21:00:00	2006-08-14 23:00:00
192	2	2006-08-14 21:00:00	2006-08-14 23:00:00
192	97	2006-08-14 21:00:00	2006-08-14 23:00:00
192	4	2006-08-14 21:00:00	2006-08-14 23:00:00
192	135	2006-08-14 21:00:00	2006-08-14 23:00:00
192	8	2006-08-14 21:00:00	2006-08-14 23:00:00
192	15	2006-08-14 21:00:00	2006-08-14 23:00:00
192	16	2006-08-14 21:00:00	2006-08-14 23:00:00
192	19	2006-08-14 21:00:00	2006-08-14 23:00:00
192	21	2006-08-14 21:00:00	2006-08-14 23:00:00
192	23	2006-08-14 21:00:00	2006-08-14 23:00:00
192	157	2006-08-14 21:00:00	2006-08-14 22:02:45
192	255	2006-08-14 21:00:00	2006-08-14 23:00:00
192	27	2006-08-14 21:00:00	2006-08-14 23:00:00
192	28	2006-08-14 21:00:00	2006-08-14 23:00:00
192	232	2006-08-14 21:00:00	2006-08-14 23:00:00
192	30	2006-08-14 21:00:00	2006-08-14 23:00:00
192	31	2006-08-14 21:00:00	2006-08-14 23:00:00
192	32	2006-08-14 21:00:00	2006-08-14 23:00:00
192	136	2006-08-14 21:00:00	2006-08-14 23:00:00
192	35	2006-08-14 21:00:00	2006-08-14 23:00:00
192	36	2006-08-14 21:00:00	2006-08-14 23:00:00
192	39	2006-08-14 22:23:01	2006-08-14 23:00:00
192	40	2006-08-14 21:00:00	2006-08-14 23:00:00
192	41	2006-08-14 21:00:00	2006-08-14 23:00:00
192	43	2006-08-14 21:00:00	2006-08-14 23:00:00
192	45	2006-08-14 21:00:00	2006-08-14 23:00:00
192	142	2006-08-14 21:00:00	2006-08-14 23:00:00
192	48	2006-08-14 21:00:00	2006-08-14 23:00:00
192	50	2006-08-14 21:00:00	2006-08-14 23:00:00
192	100	2006-08-14 21:00:00	2006-08-14 23:00:00
192	103	2006-08-14 21:00:00	2006-08-14 23:00:00
192	51	2006-08-14 21:00:00	2006-08-14 23:00:00
192	52	2006-08-14 21:00:00	2006-08-14 23:00:00
192	233	2006-08-14 21:00:00	2006-08-14 23:00:00
192	116	2006-08-14 21:00:00	2006-08-14 23:00:00
192	61	2006-08-14 21:02:23	2006-08-14 23:00:00
192	160	2006-08-14 21:00:00	2006-08-14 23:00:00
192	55	2006-08-14 21:00:00	2006-08-14 23:00:00
192	57	2006-08-14 21:00:00	2006-08-14 23:00:00
192	60	2006-08-14 21:00:00	2006-08-14 23:00:00
194	1	2006-08-15 21:00:00	2006-08-16 00:50:00
194	4	2006-08-15 21:00:00	2006-08-16 00:50:00
194	135	2006-08-15 21:00:00	2006-08-16 00:50:00
194	8	2006-08-15 21:00:00	2006-08-15 23:58:28
194	15	2006-08-15 21:00:00	2006-08-16 00:50:00
194	16	2006-08-15 21:00:00	2006-08-16 00:50:00
194	19	2006-08-15 21:00:00	2006-08-16 00:50:00
194	23	2006-08-15 21:00:00	2006-08-16 00:50:00
194	157	2006-08-15 21:00:00	2006-08-16 00:50:00
194	255	2006-08-15 21:00:00	2006-08-16 00:50:00
194	27	2006-08-15 21:00:00	2006-08-16 00:50:00
194	28	2006-08-15 21:00:00	2006-08-16 00:50:00
194	232	2006-08-15 21:00:00	2006-08-16 00:50:00
194	29	2006-08-15 21:00:00	2006-08-16 00:50:00
194	30	2006-08-15 21:00:00	2006-08-16 00:43:52
194	31	2006-08-15 21:00:00	2006-08-15 23:51:18
194	32	2006-08-15 21:00:00	2006-08-16 00:50:00
194	33	2006-08-15 21:00:00	2006-08-16 00:50:00
194	154	2006-08-15 21:00:00	2006-08-15 21:41:20
194	136	2006-08-15 21:00:00	2006-08-16 00:50:00
194	35	2006-08-15 21:00:00	2006-08-16 00:50:00
194	36	2006-08-15 21:00:00	2006-08-16 00:50:00
194	39	2006-08-15 21:41:35	2006-08-16 00:50:00
194	40	2006-08-15 21:00:00	2006-08-16 00:50:00
194	81	2006-08-15 21:00:00	2006-08-16 00:50:00
194	41	2006-08-15 21:00:00	2006-08-16 00:50:00
194	43	2006-08-15 21:00:00	2006-08-16 00:50:00
194	259	2006-08-15 22:06:33	2006-08-15 22:20:51
194	45	2006-08-15 21:00:00	2006-08-16 00:50:00
194	142	2006-08-15 21:00:00	2006-08-16 00:50:00
194	48	2006-08-15 21:00:00	2006-08-16 00:50:00
194	50	2006-08-15 23:12:14	2006-08-16 00:50:00
194	100	2006-08-15 21:00:00	2006-08-16 00:50:00
194	103	2006-08-15 21:00:00	2006-08-16 00:50:00
194	51	2006-08-15 21:00:00	2006-08-16 00:50:00
194	52	2006-08-15 21:00:00	2006-08-16 00:50:00
194	148	2006-08-15 23:58:40	2006-08-16 00:50:00
194	233	2006-08-15 21:00:00	2006-08-16 00:50:00
194	116	2006-08-15 21:00:00	2006-08-16 00:50:00
194	171	2006-08-15 21:00:00	2006-08-16 00:50:00
194	160	2006-08-15 21:00:00	2006-08-15 22:45:02
194	55	2006-08-15 21:00:00	2006-08-16 00:50:00
194	57	2006-08-15 21:00:00	2006-08-16 00:50:00
194	153	2006-08-15 23:51:40	2006-08-16 00:50:00
194	60	2006-08-15 21:00:00	2006-08-16 00:50:00
195	1	2006-08-17 21:00:00	2006-08-18 00:00:00
195	2	2006-08-17 21:00:00	2006-08-18 00:00:00
195	97	2006-08-17 21:00:00	2006-08-17 22:01:36
195	4	2006-08-17 21:00:00	2006-08-18 00:00:00
195	135	2006-08-17 21:00:00	2006-08-17 23:50:30
195	8	2006-08-17 21:00:00	2006-08-18 00:00:00
195	186	2006-08-17 21:00:00	2006-08-18 00:00:00
195	15	2006-08-17 21:00:00	2006-08-18 00:00:00
195	16	2006-08-17 21:00:00	2006-08-18 00:00:00
195	19	2006-08-17 21:00:00	2006-08-18 00:00:00
195	21	2006-08-17 21:00:00	2006-08-18 00:00:00
195	157	2006-08-17 21:00:00	2006-08-18 00:00:00
195	27	2006-08-17 21:00:00	2006-08-18 00:00:00
195	28	2006-08-17 21:00:00	2006-08-18 00:00:00
195	232	2006-08-17 21:00:00	2006-08-18 00:00:00
195	29	2006-08-17 22:01:46	2006-08-18 00:00:00
195	30	2006-08-17 21:00:00	2006-08-18 00:00:00
195	32	2006-08-17 21:00:00	2006-08-18 00:00:00
195	33	2006-08-17 21:00:00	2006-08-18 00:00:00
195	136	2006-08-17 21:00:00	2006-08-18 00:00:00
195	35	2006-08-17 21:00:00	2006-08-18 00:00:00
195	258	2006-08-17 21:00:00	2006-08-18 00:00:00
195	36	2006-08-17 21:00:00	2006-08-18 00:00:00
195	150	2006-08-17 21:00:00	2006-08-18 00:00:00
195	39	2006-08-17 21:00:00	2006-08-17 23:13:35
195	40	2006-08-17 21:00:00	2006-08-18 00:00:00
195	81	2006-08-17 23:14:57	2006-08-18 00:00:00
195	41	2006-08-17 21:00:00	2006-08-18 00:00:00
195	43	2006-08-17 21:00:00	2006-08-18 00:00:00
195	142	2006-08-17 21:00:00	2006-08-18 00:00:00
195	48	2006-08-17 21:00:00	2006-08-18 00:00:00
195	50	2006-08-17 21:00:00	2006-08-18 00:00:00
195	100	2006-08-17 21:00:00	2006-08-18 00:00:00
195	51	2006-08-17 21:00:00	2006-08-18 00:00:00
195	52	2006-08-17 21:00:00	2006-08-18 00:00:00
195	148	2006-08-17 21:00:00	2006-08-18 00:00:00
195	233	2006-08-17 21:00:00	2006-08-18 00:00:00
195	116	2006-08-17 21:00:00	2006-08-18 00:00:00
195	61	2006-08-17 22:54:22	2006-08-17 22:59:11
195	55	2006-08-17 21:00:00	2006-08-18 00:00:00
195	57	2006-08-17 21:00:00	2006-08-18 00:00:00
195	153	2006-08-17 21:00:00	2006-08-18 00:00:00
195	60	2006-08-17 21:00:00	2006-08-18 00:00:00
196	97	2006-08-19 11:00:00	2006-08-19 13:51:01
196	5	2006-08-19 11:00:00	2006-08-19 16:00:00
196	102	2006-08-19 11:00:00	2006-08-19 13:16:42
196	8	2006-08-19 11:00:00	2006-08-19 14:49:33
196	90	2006-08-19 11:00:00	2006-08-19 14:52:59
196	19	2006-08-19 11:00:00	2006-08-19 16:00:00
196	23	2006-08-19 11:08:24	2006-08-19 16:00:00
196	157	2006-08-19 11:00:00	2006-08-19 16:00:00
196	255	2006-08-19 11:00:00	2006-08-19 15:57:46
196	26	2006-08-19 11:32:41	2006-08-19 13:52:13
196	213	2006-08-19 14:18:21	2006-08-19 16:00:00
196	30	2006-08-19 11:00:00	2006-08-19 16:00:00
196	274	2006-08-19 11:00:00	2006-08-19 16:00:00
196	33	2006-08-19 13:55:35	2006-08-19 16:00:00
196	136	2006-08-19 13:26:16	2006-08-19 16:00:00
196	269	2006-08-19 11:00:00	2006-08-19 16:00:00
196	39	2006-08-19 11:00:00	2006-08-19 14:17:33
196	81	2006-08-19 11:00:00	2006-08-19 16:00:00
196	41	2006-08-19 11:00:00	2006-08-19 16:00:00
196	259	2006-08-19 11:00:00	2006-08-19 16:00:00
196	187	2006-08-19 14:54:12	2006-08-19 15:58:06
196	100	2006-08-19 13:55:39	2006-08-19 16:00:00
196	237	2006-08-19 11:00:00	2006-08-19 14:18:08
196	51	2006-08-19 14:15:14	2006-08-19 14:48:52
196	116	2006-08-19 14:18:30	2006-08-19 16:00:00
196	61	2006-08-19 11:00:00	2006-08-19 13:55:03
196	171	2006-08-19 14:54:02	2006-08-19 16:00:00
196	54	2006-08-19 11:00:00	2006-08-19 16:00:00
196	212	2006-08-19 14:55:29	2006-08-19 16:00:00
198	266	2006-08-19 19:30:00	2006-08-19 20:00:00
198	2	2006-08-19 19:30:00	2006-08-19 20:00:00
198	135	2006-08-19 19:30:00	2006-08-19 20:00:00
198	8	2006-08-19 19:30:00	2006-08-19 20:00:00
198	186	2006-08-19 19:30:00	2006-08-19 20:00:00
198	123	2006-08-19 19:30:00	2006-08-19 20:00:00
198	21	2006-08-19 19:30:00	2006-08-19 20:00:00
198	157	2006-08-19 19:30:00	2006-08-19 20:00:00
198	244	2006-08-19 19:30:00	2006-08-19 20:00:00
198	27	2006-08-19 19:30:00	2006-08-19 20:00:00
198	32	2006-08-19 19:30:00	2006-08-19 20:00:00
198	33	2006-08-19 19:30:00	2006-08-19 20:00:00
198	154	2006-08-19 19:30:00	2006-08-19 20:00:00
198	136	2006-08-19 19:30:00	2006-08-19 20:00:00
198	258	2006-08-19 19:30:00	2006-08-19 20:00:00
198	225	2006-08-19 19:30:00	2006-08-19 20:00:00
198	150	2006-08-19 19:30:00	2006-08-19 20:00:00
198	84	2006-08-19 19:30:00	2006-08-19 20:00:00
198	269	2006-08-19 19:30:00	2006-08-19 20:00:00
198	120	2006-08-19 19:30:00	2006-08-19 20:00:00
198	259	2006-08-19 19:30:00	2006-08-19 20:00:00
198	270	2006-08-19 19:30:59	2006-08-19 19:31:09
198	44	2006-08-19 19:30:00	2006-08-19 20:00:00
198	142	2006-08-19 19:30:00	2006-08-19 20:00:00
198	249	2006-08-19 19:30:00	2006-08-19 20:00:00
198	100	2006-08-19 19:30:00	2006-08-19 20:00:00
198	103	2006-08-19 19:30:00	2006-08-19 20:00:00
198	51	2006-08-19 19:30:00	2006-08-19 20:00:00
198	223	2006-08-19 19:30:00	2006-08-19 20:00:00
198	72	2006-08-19 19:30:00	2006-08-19 20:00:00
198	132	2006-08-19 19:30:00	2006-08-19 20:00:00
198	116	2006-08-19 19:30:00	2006-08-19 20:00:00
198	171	2006-08-19 19:30:00	2006-08-19 20:00:00
198	109	2006-08-19 19:30:00	2006-08-19 20:00:00
198	160	2006-08-19 19:30:00	2006-08-19 20:00:00
198	54	2006-08-19 19:30:00	2006-08-19 20:00:00
198	89	2006-08-19 19:30:00	2006-08-19 20:00:00
198	212	2006-08-19 19:30:00	2006-08-19 20:00:00
198	55	2006-08-19 19:30:00	2006-08-19 20:00:00
198	251	2006-08-19 19:30:00	2006-08-19 20:00:00
199	266	2006-08-19 20:45:00	2006-08-19 21:55:00
199	135	2006-08-19 20:45:00	2006-08-19 21:55:00
199	8	2006-08-19 20:45:00	2006-08-19 21:55:00
199	186	2006-08-19 20:45:00	2006-08-19 21:06:12
199	123	2006-08-19 20:45:00	2006-08-19 21:55:00
199	21	2006-08-19 20:45:00	2006-08-19 21:55:00
199	238	2006-08-19 20:45:00	2006-08-19 21:55:00
199	157	2006-08-19 20:45:00	2006-08-19 21:55:00
199	244	2006-08-19 20:45:00	2006-08-19 21:55:00
199	27	2006-08-19 20:45:00	2006-08-19 21:55:00
199	245	2006-08-19 20:45:00	2006-08-19 21:55:00
199	274	2006-08-19 20:45:00	2006-08-19 21:55:00
199	154	2006-08-19 20:45:00	2006-08-19 21:55:00
199	136	2006-08-19 20:45:00	2006-08-19 21:55:00
199	258	2006-08-19 20:45:00	2006-08-19 21:55:00
199	225	2006-08-19 20:45:00	2006-08-19 21:55:00
199	150	2006-08-19 20:45:00	2006-08-19 21:55:00
199	84	2006-08-19 20:45:00	2006-08-19 21:55:00
199	269	2006-08-19 20:45:00	2006-08-19 21:55:00
199	120	2006-08-19 20:45:00	2006-08-19 21:55:00
199	170	2006-08-19 20:45:00	2006-08-19 21:55:00
199	259	2006-08-19 20:45:00	2006-08-19 21:55:00
199	270	2006-08-19 20:45:00	2006-08-19 21:55:00
199	44	2006-08-19 20:45:00	2006-08-19 21:55:00
199	187	2006-08-19 20:45:00	2006-08-19 21:55:00
199	103	2006-08-19 20:45:00	2006-08-19 21:55:00
199	188	2006-08-19 20:45:00	2006-08-19 21:55:00
199	165	2006-08-19 20:45:00	2006-08-19 21:55:00
199	72	2006-08-19 20:45:00	2006-08-19 21:55:00
199	132	2006-08-19 20:45:00	2006-08-19 21:55:00
199	152	2006-08-19 20:45:00	2006-08-19 21:55:00
199	54	2006-08-19 20:45:00	2006-08-19 21:55:00
199	262	2006-08-19 20:45:00	2006-08-19 21:55:00
199	240	2006-08-19 20:45:00	2006-08-19 21:55:00
199	89	2006-08-19 20:45:00	2006-08-19 21:55:00
199	212	2006-08-19 20:45:00	2006-08-19 21:55:00
199	118	2006-08-19 20:45:00	2006-08-19 21:55:00
199	85	2006-08-19 20:45:00	2006-08-19 21:55:00
199	57	2006-08-19 20:45:00	2006-08-19 21:55:00
199	251	2006-08-19 20:45:00	2006-08-19 21:55:00
200	266	2006-08-20 19:30:00	2006-08-21 01:10:00
200	4	2006-08-20 19:30:00	2006-08-20 22:35:29
200	206	2006-08-20 19:30:00	2006-08-20 23:53:38
200	135	2006-08-20 19:30:51	2006-08-21 01:10:00
200	8	2006-08-20 19:30:00	2006-08-21 01:10:00
200	90	2006-08-20 19:30:00	2006-08-21 01:10:00
200	235	2006-08-20 19:30:00	2006-08-20 22:52:53
200	13	2006-08-20 22:55:52	2006-08-21 01:10:00
200	217	2006-08-20 20:51:37	2006-08-21 01:10:00
200	123	2006-08-20 19:30:00	2006-08-21 01:10:00
200	19	2006-08-20 19:31:40	2006-08-21 01:10:00
200	238	2006-08-20 20:24:37	2006-08-21 01:10:00
200	157	2006-08-20 19:30:00	2006-08-21 01:10:00
200	244	2006-08-20 19:30:00	2006-08-20 22:54:41
200	255	2006-08-20 22:35:35	2006-08-21 01:10:00
200	27	2006-08-20 19:30:00	2006-08-21 01:10:00
200	274	2006-08-20 23:36:03	2006-08-20 23:38:02
200	31	2006-08-20 20:29:44	2006-08-20 20:44:58
200	154	2006-08-20 19:30:00	2006-08-21 01:10:00
200	136	2006-08-20 23:03:07	2006-08-21 01:10:00
200	258	2006-08-20 19:30:00	2006-08-21 01:10:00
200	225	2006-08-20 19:30:00	2006-08-21 01:10:00
200	150	2006-08-20 19:30:00	2006-08-21 01:10:00
200	155	2006-08-20 19:30:00	2006-08-21 01:10:00
200	269	2006-08-20 19:31:01	2006-08-21 01:10:00
200	209	2006-08-20 19:30:00	2006-08-21 01:10:00
200	273	2006-08-20 23:00:49	2006-08-21 01:10:00
200	270	2006-08-20 19:30:00	2006-08-21 01:10:00
200	44	2006-08-20 19:30:00	2006-08-21 01:10:00
200	190	2006-08-20 19:30:00	2006-08-20 22:51:22
200	114	2006-08-20 19:30:00	2006-08-20 23:37:36
200	103	2006-08-20 19:30:00	2006-08-21 01:10:00
200	188	2006-08-20 19:30:00	2006-08-21 01:10:00
200	222	2006-08-20 19:30:00	2006-08-21 01:10:00
200	165	2006-08-20 19:30:00	2006-08-21 01:10:00
200	72	2006-08-20 19:30:00	2006-08-21 01:10:00
200	148	2006-08-20 19:30:00	2006-08-21 01:10:00
200	132	2006-08-20 23:56:38	2006-08-21 01:10:00
200	116	2006-08-20 19:30:00	2006-08-21 01:10:00
200	61	2006-08-20 19:30:00	2006-08-21 01:10:00
200	171	2006-08-20 19:30:00	2006-08-21 01:10:00
200	109	2006-08-20 22:29:45	2006-08-21 01:10:00
200	205	2006-08-21 00:11:31	2006-08-21 01:10:00
200	54	2006-08-20 19:30:00	2006-08-21 01:10:00
200	89	2006-08-20 19:30:00	2006-08-21 01:10:00
200	167	2006-08-20 19:30:00	2006-08-20 22:50:57
200	55	2006-08-20 23:43:40	2006-08-21 01:10:00
200	85	2006-08-20 19:30:00	2006-08-20 22:28:40
200	57	2006-08-20 19:30:00	2006-08-21 01:10:00
200	153	2006-08-20 19:30:00	2006-08-21 01:10:00
200	56	2006-08-20 19:30:00	2006-08-21 01:10:00
201	1	2006-08-21 21:00:00	2006-08-22 00:00:00
201	97	2006-08-21 21:00:00	2006-08-21 23:59:54
201	4	2006-08-21 21:00:00	2006-08-21 23:57:02
201	206	2006-08-21 21:00:00	2006-08-21 23:59:28
201	5	2006-08-21 21:00:00	2006-08-22 00:00:00
201	135	2006-08-21 21:00:00	2006-08-21 22:49:12
201	8	2006-08-21 21:24:09	2006-08-22 00:00:00
201	15	2006-08-21 21:00:00	2006-08-22 00:00:00
201	16	2006-08-21 21:00:00	2006-08-22 00:00:00
201	19	2006-08-21 21:00:00	2006-08-22 00:00:00
201	21	2006-08-21 21:00:00	2006-08-22 00:00:00
201	157	2006-08-21 21:00:00	2006-08-21 21:55:49
201	255	2006-08-21 21:00:00	2006-08-22 00:00:00
201	27	2006-08-21 21:00:00	2006-08-22 00:00:00
201	28	2006-08-21 21:00:00	2006-08-22 00:00:00
201	232	2006-08-21 21:00:00	2006-08-22 00:00:00
201	29	2006-08-21 21:00:00	2006-08-22 00:00:00
201	30	2006-08-21 21:00:00	2006-08-22 00:00:00
201	31	2006-08-21 21:00:00	2006-08-21 23:20:59
201	32	2006-08-21 21:00:00	2006-08-22 00:00:00
201	33	2006-08-21 21:00:00	2006-08-22 00:00:00
201	136	2006-08-21 21:00:00	2006-08-22 00:00:00
201	35	2006-08-21 21:00:00	2006-08-22 00:00:00
201	36	2006-08-21 21:00:00	2006-08-22 00:00:00
201	39	2006-08-21 21:00:00	2006-08-21 22:48:37
201	40	2006-08-21 23:58:24	2006-08-22 00:00:00
201	209	2006-08-21 22:50:17	2006-08-22 00:00:00
201	81	2006-08-21 23:24:39	2006-08-22 00:00:00
201	43	2006-08-21 21:00:00	2006-08-22 00:00:00
201	45	2006-08-21 21:00:00	2006-08-22 00:00:00
201	142	2006-08-21 21:00:00	2006-08-22 00:00:00
201	106	2006-08-21 22:58:12	2006-08-22 00:00:00
201	48	2006-08-21 21:00:00	2006-08-22 00:00:00
201	50	2006-08-21 21:00:00	2006-08-22 00:00:00
201	100	2006-08-21 21:00:00	2006-08-22 00:00:00
201	51	2006-08-21 21:00:00	2006-08-22 00:00:00
201	52	2006-08-21 21:00:00	2006-08-22 00:00:00
201	148	2006-08-21 21:00:00	2006-08-22 00:00:00
201	233	2006-08-21 21:00:00	2006-08-22 00:00:00
201	116	2006-08-21 21:00:00	2006-08-22 00:00:00
201	61	2006-08-21 23:27:14	2006-08-22 00:00:00
201	160	2006-08-21 21:00:00	2006-08-21 23:19:09
201	55	2006-08-21 21:00:00	2006-08-22 00:00:00
201	57	2006-08-21 21:00:00	2006-08-22 00:00:00
201	153	2006-08-21 21:00:00	2006-08-22 00:00:00
201	60	2006-08-21 21:00:00	2006-08-22 00:00:00
202	1	2006-08-22 21:00:00	2006-08-22 23:20:00
202	4	2006-08-22 21:00:00	2006-08-22 23:20:00
202	5	2006-08-22 21:00:00	2006-08-22 23:20:00
202	135	2006-08-22 21:46:46	2006-08-22 23:20:00
202	8	2006-08-22 21:00:00	2006-08-22 23:20:00
202	15	2006-08-22 21:00:00	2006-08-22 23:20:00
202	16	2006-08-22 21:00:00	2006-08-22 23:03:31
202	19	2006-08-22 21:00:00	2006-08-22 23:20:00
202	21	2006-08-22 21:00:00	2006-08-22 23:20:00
202	23	2006-08-22 21:00:00	2006-08-22 23:20:00
202	157	2006-08-22 21:00:00	2006-08-22 21:45:39
202	255	2006-08-22 22:08:04	2006-08-22 23:03:23
202	27	2006-08-22 21:13:41	2006-08-22 23:20:00
202	28	2006-08-22 21:00:00	2006-08-22 23:20:00
202	232	2006-08-22 21:00:00	2006-08-22 23:20:00
202	29	2006-08-22 21:00:00	2006-08-22 23:20:00
202	30	2006-08-22 21:00:00	2006-08-22 23:20:00
202	31	2006-08-22 21:00:00	2006-08-22 22:27:31
202	32	2006-08-22 21:00:00	2006-08-22 23:20:00
202	33	2006-08-22 21:00:00	2006-08-22 23:20:00
202	34	2006-08-22 21:02:55	2006-08-22 23:20:00
202	154	2006-08-22 21:00:00	2006-08-22 23:20:00
202	136	2006-08-22 21:00:00	2006-08-22 22:01:44
202	35	2006-08-22 21:00:00	2006-08-22 23:20:00
202	36	2006-08-22 21:00:00	2006-08-22 23:20:00
202	39	2006-08-22 21:00:00	2006-08-22 23:03:10
202	41	2006-08-22 21:00:00	2006-08-22 23:20:00
202	43	2006-08-22 21:00:00	2006-08-22 23:20:00
202	259	2006-08-22 22:02:33	2006-08-22 23:20:00
202	45	2006-08-22 21:00:00	2006-08-22 23:20:00
202	142	2006-08-22 21:00:00	2006-08-22 23:20:00
202	48	2006-08-22 21:00:00	2006-08-22 23:20:00
202	50	2006-08-22 21:00:00	2006-08-22 23:20:00
202	100	2006-08-22 21:00:00	2006-08-22 23:20:00
202	103	2006-08-22 21:00:00	2006-08-22 23:20:00
202	51	2006-08-22 21:00:00	2006-08-22 23:17:59
202	148	2006-08-22 21:00:00	2006-08-22 23:20:00
202	233	2006-08-22 21:00:00	2006-08-22 23:20:00
202	116	2006-08-22 21:00:00	2006-08-22 23:20:00
202	160	2006-08-22 21:00:00	2006-08-22 23:20:00
202	55	2006-08-22 21:00:00	2006-08-22 23:20:00
202	57	2006-08-22 21:00:00	2006-08-22 23:20:00
202	153	2006-08-22 21:00:00	2006-08-22 22:04:55
202	60	2006-08-22 21:00:00	2006-08-22 23:20:00
203	1	2006-08-24 21:00:00	2006-08-24 21:49:51
203	2	2006-08-24 21:00:00	2006-08-24 22:38:24
203	135	2006-08-24 21:00:00	2006-08-24 23:23:03
203	8	2006-08-24 21:00:00	2006-08-25 00:30:00
203	15	2006-08-24 21:00:00	2006-08-25 00:30:00
203	16	2006-08-24 21:00:00	2006-08-25 00:30:00
203	123	2006-08-24 23:32:05	2006-08-25 00:30:00
203	19	2006-08-24 21:00:00	2006-08-25 00:30:00
203	23	2006-08-24 21:00:00	2006-08-25 00:30:00
203	244	2006-08-24 21:00:00	2006-08-25 00:30:00
203	255	2006-08-24 21:00:00	2006-08-25 00:30:00
203	27	2006-08-24 21:00:00	2006-08-25 00:30:00
203	28	2006-08-24 21:00:00	2006-08-25 00:30:00
203	232	2006-08-24 21:00:00	2006-08-25 00:30:00
203	30	2006-08-24 21:00:00	2006-08-25 00:30:00
203	32	2006-08-24 21:00:00	2006-08-25 00:30:00
203	33	2006-08-24 21:00:00	2006-08-25 00:30:00
203	34	2006-08-24 21:00:00	2006-08-24 23:33:33
203	154	2006-08-24 22:43:17	2006-08-25 00:30:00
203	136	2006-08-24 21:50:40	2006-08-25 00:17:08
203	35	2006-08-24 21:00:00	2006-08-25 00:30:00
203	36	2006-08-24 21:00:00	2006-08-25 00:30:00
203	150	2006-08-24 21:00:00	2006-08-24 23:22:58
203	155	2006-08-24 21:00:00	2006-08-25 00:30:00
203	39	2006-08-24 21:00:00	2006-08-24 23:17:02
203	40	2006-08-24 21:08:57	2006-08-25 00:30:00
203	41	2006-08-24 21:00:00	2006-08-24 23:26:21
203	43	2006-08-24 21:00:00	2006-08-25 00:30:00
203	259	2006-08-24 21:00:00	2006-08-24 23:28:06
203	270	2006-08-24 21:07:47	2006-08-25 00:30:00
203	142	2006-08-24 21:00:00	2006-08-25 00:30:00
203	190	2006-08-24 22:31:19	2006-08-25 00:30:00
203	106	2006-08-24 23:32:56	2006-08-25 00:30:00
203	48	2006-08-24 21:00:00	2006-08-25 00:30:00
203	50	2006-08-24 21:00:00	2006-08-25 00:30:00
203	100	2006-08-24 21:00:00	2006-08-25 00:30:00
203	103	2006-08-24 23:23:11	2006-08-25 00:30:00
203	51	2006-08-24 21:00:00	2006-08-25 00:17:52
203	53	2006-08-24 21:00:00	2006-08-25 00:30:00
203	148	2006-08-24 21:00:00	2006-08-25 00:30:00
203	233	2006-08-24 21:00:00	2006-08-25 00:30:00
203	132	2006-08-24 23:18:23	2006-08-25 00:30:00
203	116	2006-08-24 21:00:00	2006-08-25 00:30:00
203	171	2006-08-24 21:00:00	2006-08-25 00:30:00
203	160	2006-08-24 21:00:00	2006-08-25 00:30:00
203	167	2006-08-24 21:00:00	2006-08-24 22:20:34
203	57	2006-08-24 23:26:13	2006-08-25 00:30:00
203	153	2006-08-24 21:00:00	2006-08-25 00:30:00
203	60	2006-08-24 21:00:00	2006-08-25 00:30:00
204	1	2006-08-26 11:00:00	2006-08-26 14:15:00
204	97	2006-08-26 12:15:52	2006-08-26 14:15:00
204	206	2006-08-26 11:00:00	2006-08-26 14:10:03
204	5	2006-08-26 11:00:00	2006-08-26 14:15:00
204	8	2006-08-26 11:00:00	2006-08-26 14:15:00
204	90	2006-08-26 11:00:00	2006-08-26 14:15:00
204	276	2006-08-26 13:39:17	2006-08-26 14:15:00
204	13	2006-08-26 11:00:00	2006-08-26 14:15:00
204	123	2006-08-26 11:00:00	2006-08-26 14:15:00
204	157	2006-08-26 11:00:00	2006-08-26 14:15:00
204	30	2006-08-26 11:00:00	2006-08-26 14:15:00
204	245	2006-08-26 11:00:00	2006-08-26 12:42:56
204	32	2006-08-26 11:00:00	2006-08-26 14:15:00
204	258	2006-08-26 13:32:27	2006-08-26 14:15:00
204	111	2006-08-26 11:00:00	2006-08-26 14:15:00
204	269	2006-08-26 11:00:00	2006-08-26 14:15:00
204	259	2006-08-26 11:00:00	2006-08-26 13:29:00
204	248	2006-08-26 11:00:00	2006-08-26 14:15:00
204	100	2006-08-26 11:00:00	2006-08-26 14:15:00
204	237	2006-08-26 11:00:00	2006-08-26 14:15:00
204	61	2006-08-26 11:00:00	2006-08-26 14:15:00
204	89	2006-08-26 11:00:00	2006-08-26 14:15:00
204	167	2006-08-26 11:00:00	2006-08-26 14:15:00
204	55	2006-08-26 11:00:00	2006-08-26 14:15:00
205	1	2006-08-26 19:30:00	2006-08-26 20:25:00
205	206	2006-08-26 19:30:00	2006-08-26 20:25:00
205	5	2006-08-26 19:30:00	2006-08-26 20:25:00
205	135	2006-08-26 19:30:00	2006-08-26 20:25:00
205	90	2006-08-26 19:30:00	2006-08-26 20:25:00
205	235	2006-08-26 19:30:00	2006-08-26 20:25:00
205	13	2006-08-26 19:30:00	2006-08-26 20:25:00
205	17	2006-08-26 19:30:00	2006-08-26 20:25:00
205	21	2006-08-26 19:30:00	2006-08-26 20:25:00
205	244	2006-08-26 19:30:00	2006-08-26 20:25:00
205	27	2006-08-26 19:30:00	2006-08-26 20:25:00
205	232	2006-08-26 19:30:00	2006-08-26 20:25:00
205	98	2006-08-26 19:30:00	2006-08-26 20:25:00
205	32	2006-08-26 19:30:00	2006-08-26 20:25:00
205	119	2006-08-26 19:30:00	2006-08-26 20:25:00
205	136	2006-08-26 19:30:00	2006-08-26 20:25:00
205	258	2006-08-26 19:30:00	2006-08-26 20:25:00
205	150	2006-08-26 19:30:00	2006-08-26 20:25:00
205	84	2006-08-26 19:30:00	2006-08-26 20:25:00
205	155	2006-08-26 19:30:00	2006-08-26 20:25:00
205	43	2006-08-26 19:30:00	2006-08-26 20:25:00
205	44	2006-08-26 19:30:00	2006-08-26 20:25:00
205	45	2006-08-26 19:30:00	2006-08-26 20:25:00
205	142	2006-08-26 19:30:00	2006-08-26 20:25:00
205	190	2006-08-26 19:30:00	2006-08-26 20:25:00
205	50	2006-08-26 19:30:00	2006-08-26 20:25:00
205	100	2006-08-26 19:30:00	2006-08-26 20:25:00
205	103	2006-08-26 19:30:00	2006-08-26 20:25:00
205	51	2006-08-26 19:30:00	2006-08-26 20:25:00
205	188	2006-08-26 19:30:00	2006-08-26 20:25:00
205	222	2006-08-26 19:30:00	2006-08-26 20:25:00
205	223	2006-08-26 19:30:00	2006-08-26 20:25:00
205	72	2006-08-26 19:30:00	2006-08-26 20:25:00
205	148	2006-08-26 19:30:00	2006-08-26 20:25:00
205	233	2006-08-26 19:30:00	2006-08-26 20:25:00
205	116	2006-08-26 19:30:00	2006-08-26 20:25:00
205	61	2006-08-26 19:30:00	2006-08-26 20:25:00
205	171	2006-08-26 19:30:00	2006-08-26 20:25:00
205	160	2006-08-26 19:30:00	2006-08-26 20:25:00
205	89	2006-08-26 19:30:00	2006-08-26 20:25:00
205	167	2006-08-26 19:30:00	2006-08-26 20:25:00
205	60	2006-08-26 19:30:00	2006-08-26 20:25:00
206	239	2006-08-26 21:00:00	2006-08-26 23:30:00
206	4	2006-08-26 23:16:43	2006-08-26 23:30:00
206	206	2006-08-26 21:00:00	2006-08-26 23:30:00
206	135	2006-08-26 21:00:00	2006-08-26 23:30:00
206	90	2006-08-26 21:00:00	2006-08-26 23:30:00
206	235	2006-08-26 21:00:00	2006-08-26 23:30:00
206	17	2006-08-26 21:00:00	2006-08-26 23:30:00
206	244	2006-08-26 21:00:00	2006-08-26 23:30:00
206	64	2006-08-26 21:00:00	2006-08-26 23:30:00
206	27	2006-08-26 21:00:00	2006-08-26 23:30:00
206	98	2006-08-26 21:00:00	2006-08-26 23:30:00
206	245	2006-08-26 21:00:00	2006-08-26 23:30:00
206	119	2006-08-26 21:00:00	2006-08-26 23:30:00
206	258	2006-08-26 21:00:00	2006-08-26 23:30:00
206	257	2006-08-26 21:00:00	2006-08-26 23:30:00
206	150	2006-08-26 21:00:00	2006-08-26 23:30:00
206	84	2006-08-26 21:00:00	2006-08-26 23:30:00
206	155	2006-08-26 21:00:00	2006-08-26 23:30:00
206	170	2006-08-26 21:00:00	2006-08-26 23:30:00
206	259	2006-08-26 21:00:00	2006-08-26 23:30:00
206	273	2006-08-26 21:00:00	2006-08-26 23:30:00
206	44	2006-08-26 21:00:00	2006-08-26 23:30:00
206	190	2006-08-26 21:00:00	2006-08-26 23:30:00
206	103	2006-08-26 21:00:00	2006-08-26 23:30:00
206	51	2006-08-26 21:00:00	2006-08-26 23:30:00
206	188	2006-08-26 21:00:00	2006-08-26 23:30:00
206	222	2006-08-26 21:00:00	2006-08-26 23:30:00
206	151	2006-08-26 21:00:00	2006-08-26 23:15:50
206	223	2006-08-26 21:00:00	2006-08-26 23:30:00
206	72	2006-08-26 21:00:00	2006-08-26 23:30:00
206	267	2006-08-26 21:01:35	2006-08-26 23:30:00
206	148	2006-08-26 21:00:00	2006-08-26 22:45:39
206	233	2006-08-26 21:00:00	2006-08-26 23:30:00
206	116	2006-08-26 21:00:00	2006-08-26 23:30:00
206	171	2006-08-26 21:00:00	2006-08-26 23:30:00
206	107	2006-08-26 21:00:00	2006-08-26 23:30:00
206	152	2006-08-26 21:00:00	2006-08-26 23:23:36
206	240	2006-08-26 21:00:00	2006-08-26 23:30:00
206	89	2006-08-26 21:00:00	2006-08-26 23:30:00
206	167	2006-08-26 21:00:00	2006-08-26 23:30:00
206	153	2006-08-26 21:00:00	2006-08-26 23:30:00
206	277	2006-08-26 21:00:00	2006-08-26 23:30:00
206	60	2006-08-26 21:00:00	2006-08-26 23:30:00
210	135	2006-08-26 23:50:00	2006-08-27 00:35:00
210	90	2006-08-26 23:50:00	2006-08-27 00:35:00
210	217	2006-08-26 23:54:25	2006-08-27 00:35:00
210	244	2006-08-26 23:50:00	2006-08-27 00:35:00
210	64	2006-08-26 23:50:00	2006-08-27 00:35:00
210	27	2006-08-26 23:50:00	2006-08-27 00:35:00
210	119	2006-08-26 23:50:00	2006-08-27 00:35:00
210	136	2006-08-26 23:50:00	2006-08-27 00:35:00
210	35	2006-08-26 23:50:00	2006-08-27 00:35:00
210	258	2006-08-26 23:53:56	2006-08-27 00:35:00
210	257	2006-08-26 23:50:00	2006-08-27 00:35:00
210	150	2006-08-26 23:50:00	2006-08-27 00:35:00
210	84	2006-08-26 23:53:42	2006-08-27 00:35:00
210	155	2006-08-26 23:50:00	2006-08-27 00:35:00
210	39	2006-08-26 23:50:00	2006-08-27 00:35:00
210	100	2006-08-26 23:50:00	2006-08-27 00:35:00
210	103	2006-08-26 23:50:00	2006-08-27 00:35:00
210	51	2006-08-26 23:50:00	2006-08-27 00:35:00
210	222	2006-08-26 23:50:00	2006-08-27 00:35:00
210	223	2006-08-26 23:50:00	2006-08-27 00:35:00
210	116	2006-08-26 23:50:00	2006-08-27 00:35:00
210	171	2006-08-26 23:50:00	2006-08-27 00:35:00
210	160	2006-08-26 23:50:00	2006-08-27 00:35:00
210	167	2006-08-26 23:50:00	2006-08-27 00:35:00
210	57	2006-08-26 23:50:00	2006-08-27 00:35:00
210	153	2006-08-26 23:50:00	2006-08-27 00:35:00
207	266	2006-08-27 19:30:00	2006-08-27 23:55:00
207	239	2006-08-27 19:30:55	2006-08-27 23:55:00
207	135	2006-08-27 19:30:00	2006-08-27 22:48:01
207	9	2006-08-27 19:30:00	2006-08-27 22:46:59
207	90	2006-08-27 19:30:00	2006-08-27 23:55:00
207	235	2006-08-27 19:30:00	2006-08-27 22:52:19
207	13	2006-08-27 20:12:25	2006-08-27 23:55:00
207	217	2006-08-27 19:30:17	2006-08-27 23:55:00
207	123	2006-08-27 19:30:00	2006-08-27 23:55:00
207	157	2006-08-27 19:34:56	2006-08-27 23:55:00
207	244	2006-08-27 19:30:00	2006-08-27 23:55:00
207	161	2006-08-27 19:30:00	2006-08-27 23:55:00
207	255	2006-08-27 22:47:49	2006-08-27 23:55:00
207	27	2006-08-27 19:30:00	2006-08-27 23:55:00
207	98	2006-08-27 19:30:00	2006-08-27 23:55:00
207	154	2006-08-27 19:30:00	2006-08-27 23:55:00
207	272	2006-08-27 19:30:39	2006-08-27 23:55:00
207	234	2006-08-27 19:32:29	2006-08-27 23:55:00
207	258	2006-08-27 19:30:00	2006-08-27 23:55:00
207	36	2006-08-27 22:52:41	2006-08-27 23:55:00
207	150	2006-08-27 19:30:00	2006-08-27 23:55:00
207	155	2006-08-27 19:30:00	2006-08-27 23:55:00
207	202	2006-08-27 19:30:00	2006-08-27 23:55:00
207	43	2006-08-27 22:47:15	2006-08-27 23:55:00
207	259	2006-08-27 19:30:00	2006-08-27 23:55:00
207	129	2006-08-27 19:30:00	2006-08-27 23:55:00
207	270	2006-08-27 19:30:00	2006-08-27 23:55:00
207	44	2006-08-27 19:30:00	2006-08-27 23:55:00
207	220	2006-08-27 19:30:00	2006-08-27 22:52:44
207	114	2006-08-27 19:30:00	2006-08-27 23:55:00
207	103	2006-08-27 19:30:00	2006-08-27 23:55:00
207	222	2006-08-27 19:30:00	2006-08-27 23:55:00
207	223	2006-08-27 19:30:00	2006-08-27 23:55:00
207	148	2006-08-27 22:48:44	2006-08-27 23:55:00
207	132	2006-08-27 19:30:00	2006-08-27 23:55:00
207	116	2006-08-27 19:30:00	2006-08-27 23:55:00
207	61	2006-08-27 19:30:00	2006-08-27 23:55:00
207	171	2006-08-27 20:17:01	2006-08-27 23:55:00
207	152	2006-08-27 19:30:00	2006-08-27 20:01:48
207	54	2006-08-27 19:30:00	2006-08-27 23:55:00
207	89	2006-08-27 19:30:00	2006-08-27 23:55:00
207	76	2006-08-27 19:30:00	2006-08-27 23:55:00
207	167	2006-08-27 19:30:00	2006-08-27 22:47:24
207	212	2006-08-27 19:34:22	2006-08-27 22:47:31
207	55	2006-08-27 22:47:37	2006-08-27 23:55:00
207	251	2006-08-27 19:30:00	2006-08-27 23:55:00
207	153	2006-08-27 19:30:00	2006-08-27 23:55:00
207	56	2006-08-27 19:30:00	2006-08-27 19:30:21
217	90	2006-08-28 00:30:00	2006-08-28 01:00:00
217	13	2006-08-28 00:30:00	2006-08-28 01:00:00
217	217	2006-08-28 00:30:00	2006-08-28 01:00:00
217	123	2006-08-28 00:30:00	2006-08-28 01:00:00
217	278	2006-08-28 00:30:00	2006-08-28 01:00:00
217	157	2006-08-28 00:30:00	2006-08-28 01:00:00
217	244	2006-08-28 00:30:00	2006-08-28 01:00:00
217	161	2006-08-28 00:31:22	2006-08-28 01:00:00
217	27	2006-08-28 00:30:00	2006-08-28 01:00:00
217	274	2006-08-28 00:30:00	2006-08-28 01:00:00
217	154	2006-08-28 00:30:00	2006-08-28 01:00:00
217	272	2006-08-28 00:30:00	2006-08-28 01:00:00
217	234	2006-08-28 00:30:00	2006-08-28 01:00:00
217	258	2006-08-28 00:30:00	2006-08-28 01:00:00
217	257	2006-08-28 00:30:00	2006-08-28 01:00:00
217	150	2006-08-28 00:30:00	2006-08-28 01:00:00
217	43	2006-08-28 00:30:00	2006-08-28 01:00:00
217	129	2006-08-28 00:30:00	2006-08-28 01:00:00
217	142	2006-08-28 00:30:00	2006-08-28 01:00:00
217	106	2006-08-28 00:30:00	2006-08-28 01:00:00
217	50	2006-08-28 00:30:00	2006-08-28 01:00:00
217	100	2006-08-28 00:30:00	2006-08-28 01:00:00
217	222	2006-08-28 00:30:00	2006-08-28 01:00:00
217	223	2006-08-28 00:30:00	2006-08-28 01:00:00
217	148	2006-08-28 00:30:00	2006-08-28 01:00:00
217	116	2006-08-28 00:30:00	2006-08-28 01:00:00
217	109	2006-08-28 00:30:00	2006-08-28 01:00:00
217	54	2006-08-28 00:30:00	2006-08-28 01:00:00
217	89	2006-08-28 00:30:00	2006-08-28 01:00:00
217	55	2006-08-28 00:30:00	2006-08-28 01:00:00
217	153	2006-08-28 00:30:00	2006-08-28 01:00:00
217	56	2006-08-28 00:30:00	2006-08-28 01:00:00
208	1	2006-08-28 21:00:00	2006-08-28 23:31:55
208	2	2006-08-28 21:00:00	2006-08-29 00:20:00
208	4	2006-08-28 21:12:50	2006-08-29 00:20:00
208	5	2006-08-28 21:00:00	2006-08-29 00:20:00
208	135	2006-08-28 21:00:00	2006-08-29 00:20:00
208	8	2006-08-28 21:00:00	2006-08-29 00:20:00
208	15	2006-08-28 21:00:00	2006-08-29 00:20:00
208	16	2006-08-28 21:00:00	2006-08-29 00:20:00
208	19	2006-08-28 21:00:00	2006-08-29 00:20:00
208	21	2006-08-28 21:00:00	2006-08-29 00:20:00
208	157	2006-08-28 21:00:00	2006-08-28 22:46:07
208	255	2006-08-28 21:00:00	2006-08-29 00:20:00
208	27	2006-08-28 21:00:00	2006-08-29 00:20:00
208	28	2006-08-28 21:00:00	2006-08-29 00:20:00
208	232	2006-08-28 21:00:00	2006-08-29 00:20:00
208	29	2006-08-28 21:00:00	2006-08-29 00:20:00
208	30	2006-08-28 21:00:00	2006-08-29 00:20:00
208	32	2006-08-28 21:00:00	2006-08-29 00:20:00
208	33	2006-08-28 21:00:00	2006-08-29 00:20:00
208	154	2006-08-28 23:31:45	2006-08-29 00:20:00
208	136	2006-08-28 21:00:00	2006-08-29 00:20:00
208	234	2006-08-28 22:50:58	2006-08-29 00:20:00
208	35	2006-08-28 21:00:00	2006-08-29 00:20:00
208	258	2006-08-28 23:35:32	2006-08-29 00:20:00
208	36	2006-08-28 21:00:00	2006-08-29 00:20:00
208	40	2006-08-28 21:00:00	2006-08-29 00:20:00
208	43	2006-08-28 21:00:00	2006-08-29 00:20:00
208	259	2006-08-28 21:00:00	2006-08-28 23:30:19
208	48	2006-08-28 21:00:00	2006-08-29 00:20:00
208	50	2006-08-28 21:00:00	2006-08-29 00:20:00
208	100	2006-08-28 21:00:00	2006-08-29 00:20:00
208	103	2006-08-28 21:00:00	2006-08-29 00:20:00
208	51	2006-08-28 21:00:00	2006-08-29 00:20:00
208	52	2006-08-28 21:00:00	2006-08-29 00:20:00
208	53	2006-08-28 21:00:00	2006-08-29 00:20:00
208	148	2006-08-28 21:00:00	2006-08-29 00:20:00
208	233	2006-08-28 21:00:00	2006-08-29 00:20:00
208	116	2006-08-28 21:00:00	2006-08-29 00:20:00
208	171	2006-08-28 21:00:00	2006-08-29 00:20:00
208	160	2006-08-28 21:00:00	2006-08-29 00:20:00
208	55	2006-08-28 21:00:00	2006-08-29 00:20:00
208	57	2006-08-28 21:00:00	2006-08-29 00:20:00
208	153	2006-08-28 21:00:00	2006-08-29 00:20:00
208	60	2006-08-28 21:00:00	2006-08-29 00:20:00
209	1	2006-08-29 21:00:00	2006-08-30 00:20:00
209	2	2006-08-29 21:00:00	2006-08-29 22:51:33
209	97	2006-08-29 21:00:00	2006-08-29 22:48:06
209	206	2006-08-29 21:00:00	2006-08-30 00:20:00
209	135	2006-08-29 21:00:00	2006-08-30 00:20:00
209	8	2006-08-29 21:00:00	2006-08-30 00:20:00
209	15	2006-08-29 21:00:00	2006-08-30 00:20:00
209	16	2006-08-29 21:00:00	2006-08-30 00:20:00
209	19	2006-08-29 21:00:00	2006-08-30 00:20:00
209	21	2006-08-29 21:00:00	2006-08-30 00:20:00
209	157	2006-08-29 21:00:00	2006-08-30 00:20:00
209	244	2006-08-29 21:00:00	2006-08-30 00:20:00
209	255	2006-08-29 21:00:00	2006-08-30 00:20:00
209	27	2006-08-29 21:00:00	2006-08-30 00:20:00
209	28	2006-08-29 21:00:00	2006-08-30 00:20:00
209	232	2006-08-29 21:00:00	2006-08-30 00:20:00
209	29	2006-08-29 21:00:00	2006-08-30 00:20:00
209	30	2006-08-29 21:00:00	2006-08-30 00:20:00
209	32	2006-08-29 21:00:00	2006-08-30 00:20:00
209	33	2006-08-29 22:53:48	2006-08-30 00:20:00
209	154	2006-08-29 21:00:00	2006-08-30 00:20:00
209	136	2006-08-29 21:00:00	2006-08-30 00:20:00
209	35	2006-08-29 21:00:00	2006-08-30 00:20:00
209	36	2006-08-29 21:00:00	2006-08-29 22:47:37
209	39	2006-08-29 22:52:10	2006-08-29 22:53:38
209	40	2006-08-29 21:00:00	2006-08-30 00:20:00
209	41	2006-08-29 21:00:00	2006-08-29 23:00:08
209	43	2006-08-29 21:00:00	2006-08-30 00:20:00
209	259	2006-08-29 21:00:00	2006-08-30 00:20:00
209	142	2006-08-29 21:00:00	2006-08-30 00:20:00
209	48	2006-08-29 21:00:00	2006-08-30 00:20:00
209	50	2006-08-29 21:00:00	2006-08-30 00:20:00
209	100	2006-08-29 21:00:00	2006-08-30 00:20:00
209	103	2006-08-29 22:49:18	2006-08-30 00:20:00
209	51	2006-08-29 21:00:00	2006-08-30 00:20:00
209	222	2006-08-29 23:02:21	2006-08-30 00:20:00
209	148	2006-08-29 21:00:00	2006-08-30 00:20:00
209	233	2006-08-29 21:00:00	2006-08-30 00:20:00
209	116	2006-08-29 21:00:00	2006-08-30 00:20:00
209	171	2006-08-29 21:00:00	2006-08-30 00:20:00
209	160	2006-08-29 21:00:00	2006-08-30 00:20:00
209	55	2006-08-29 21:00:00	2006-08-30 00:20:00
209	57	2006-08-29 21:00:00	2006-08-30 00:20:00
209	153	2006-08-29 21:00:00	2006-08-30 00:20:00
209	60	2006-08-29 21:00:00	2006-08-30 00:20:00
212	1	2006-08-31 21:00:00	2006-09-01 00:14:16
212	266	2006-08-31 21:00:00	2006-09-01 00:20:00
212	97	2006-08-31 21:00:00	2006-08-31 23:07:18
212	206	2006-08-31 21:00:00	2006-09-01 00:20:00
212	135	2006-08-31 21:00:00	2006-09-01 00:20:00
212	15	2006-08-31 21:00:00	2006-09-01 00:20:00
212	16	2006-08-31 21:00:00	2006-09-01 00:20:00
212	21	2006-08-31 21:00:00	2006-09-01 00:20:00
212	157	2006-08-31 21:00:00	2006-08-31 23:41:46
212	244	2006-08-31 21:12:11	2006-09-01 00:20:00
212	255	2006-08-31 21:00:00	2006-08-31 23:45:29
212	27	2006-08-31 21:00:00	2006-09-01 00:20:00
212	28	2006-08-31 21:00:00	2006-09-01 00:20:00
212	232	2006-08-31 21:00:00	2006-09-01 00:20:00
212	29	2006-08-31 21:00:00	2006-09-01 00:20:00
212	30	2006-08-31 21:00:00	2006-08-31 22:30:33
212	32	2006-08-31 21:00:00	2006-09-01 00:13:03
212	33	2006-08-31 21:00:00	2006-09-01 00:20:00
212	279	2006-08-31 21:00:00	2006-08-31 21:02:06
212	136	2006-08-31 21:00:00	2006-09-01 00:20:00
212	35	2006-08-31 23:04:27	2006-09-01 00:20:00
212	36	2006-08-31 21:00:00	2006-09-01 00:20:00
212	150	2006-08-31 21:00:00	2006-09-01 00:20:00
212	39	2006-08-31 21:00:00	2006-08-31 23:20:34
212	40	2006-08-31 21:00:00	2006-09-01 00:20:00
212	43	2006-08-31 21:00:00	2006-09-01 00:20:00
212	259	2006-08-31 21:00:00	2006-09-01 00:20:00
212	106	2006-08-31 23:46:24	2006-09-01 00:20:00
212	48	2006-08-31 21:00:00	2006-09-01 00:20:00
212	50	2006-08-31 21:00:00	2006-09-01 00:20:00
212	100	2006-08-31 21:00:00	2006-09-01 00:20:00
212	103	2006-08-31 23:20:20	2006-09-01 00:20:00
212	51	2006-08-31 21:00:00	2006-09-01 00:20:00
212	53	2006-08-31 21:00:00	2006-09-01 00:20:00
212	148	2006-08-31 21:00:00	2006-09-01 00:20:00
212	233	2006-08-31 21:00:00	2006-09-01 00:20:00
212	132	2006-08-31 21:05:10	2006-09-01 00:20:00
212	116	2006-08-31 21:00:00	2006-09-01 00:20:00
212	171	2006-08-31 21:00:00	2006-08-31 23:41:39
212	160	2006-08-31 23:20:46	2006-09-01 00:20:00
212	205	2006-08-31 22:39:28	2006-09-01 00:20:00
212	89	2006-08-31 22:32:37	2006-09-01 00:20:00
212	167	2006-08-31 21:00:00	2006-08-31 23:01:56
212	55	2006-08-31 21:00:00	2006-09-01 00:20:00
212	57	2006-08-31 21:00:00	2006-09-01 00:20:00
212	153	2006-08-31 21:00:00	2006-09-01 00:20:00
212	60	2006-08-31 21:00:00	2006-09-01 00:20:00
214	266	2006-09-02 11:06:28	2006-09-02 14:30:00
214	135	2006-09-02 11:00:00	2006-09-02 14:30:00
214	90	2006-09-02 11:00:00	2006-09-02 14:30:00
214	280	2006-09-02 11:00:00	2006-09-02 14:30:00
214	30	2006-09-02 11:07:50	2006-09-02 14:30:00
214	245	2006-09-02 11:00:00	2006-09-02 14:30:00
214	111	2006-09-02 11:00:00	2006-09-02 14:30:00
214	155	2006-09-02 11:00:00	2006-09-02 14:30:00
214	120	2006-09-02 11:00:00	2006-09-02 13:27:21
214	40	2006-09-02 12:05:13	2006-09-02 14:30:00
214	41	2006-09-02 11:00:00	2006-09-02 14:30:00
214	259	2006-09-02 11:00:00	2006-09-02 14:30:00
214	248	2006-09-02 11:01:58	2006-09-02 14:30:00
214	103	2006-09-02 11:00:00	2006-09-02 14:30:00
214	267	2006-09-02 11:00:00	2006-09-02 11:04:14
214	61	2006-09-02 11:00:00	2006-09-02 14:30:00
214	75	2006-09-02 11:00:00	2006-09-02 14:30:00
214	171	2006-09-02 13:41:03	2006-09-02 14:30:00
214	281	2006-09-02 11:00:00	2006-09-02 14:30:00
214	54	2006-09-02 11:00:00	2006-09-02 14:30:00
214	89	2006-09-02 11:00:00	2006-09-02 11:08:31
214	167	2006-09-02 11:00:00	2006-09-02 14:30:00
214	251	2006-09-02 11:00:00	2006-09-02 14:30:00
214	282	2006-09-02 11:00:00	2006-09-02 14:30:00
214	283	2006-09-02 11:00:00	2006-09-02 14:30:00
213	266	2006-09-02 19:30:00	2006-09-02 20:00:00
213	97	2006-09-02 19:30:00	2006-09-02 20:00:00
213	4	2006-09-02 19:30:00	2006-09-02 20:00:00
213	135	2006-09-02 19:30:00	2006-09-02 20:00:00
213	90	2006-09-02 19:30:00	2006-09-02 20:00:00
213	235	2006-09-02 19:38:22	2006-09-02 20:00:00
213	13	2006-09-02 19:34:09	2006-09-02 20:00:00
213	217	2006-09-02 19:30:00	2006-09-02 20:00:00
213	280	2006-09-02 19:30:00	2006-09-02 20:00:00
213	244	2006-09-02 19:30:00	2006-09-02 19:33:11
213	64	2006-09-02 19:30:00	2006-09-02 20:00:00
213	27	2006-09-02 19:30:00	2006-09-02 20:00:00
213	274	2006-09-02 19:30:00	2006-09-02 20:00:00
213	32	2006-09-02 19:30:00	2006-09-02 20:00:00
213	154	2006-09-02 19:30:00	2006-09-02 20:00:00
213	234	2006-09-02 19:33:15	2006-09-02 20:00:00
213	150	2006-09-02 19:30:00	2006-09-02 20:00:00
213	111	2006-09-02 19:30:00	2006-09-02 20:00:00
213	155	2006-09-02 19:30:00	2006-09-02 20:00:00
213	39	2006-09-02 19:30:00	2006-09-02 19:36:32
213	170	2006-09-02 19:30:00	2006-09-02 20:00:00
213	259	2006-09-02 19:30:00	2006-09-02 20:00:00
213	44	2006-09-02 19:30:00	2006-09-02 20:00:00
213	142	2006-09-02 19:30:00	2006-09-02 20:00:00
213	100	2006-09-02 19:30:00	2006-09-02 20:00:00
213	103	2006-09-02 19:30:00	2006-09-02 20:00:00
213	222	2006-09-02 19:30:00	2006-09-02 20:00:00
213	151	2006-09-02 19:30:00	2006-09-02 20:00:00
213	223	2006-09-02 19:30:00	2006-09-02 20:00:00
213	72	2006-09-02 19:30:00	2006-09-02 20:00:00
213	148	2006-09-02 19:30:00	2006-09-02 20:00:00
213	233	2006-09-02 19:30:00	2006-09-02 20:00:00
213	116	2006-09-02 19:30:00	2006-09-02 20:00:00
213	61	2006-09-02 19:30:00	2006-09-02 20:00:00
213	171	2006-09-02 19:30:00	2006-09-02 20:00:00
213	109	2006-09-02 19:30:00	2006-09-02 20:00:00
213	160	2006-09-02 19:36:00	2006-09-02 20:00:00
213	89	2006-09-02 19:30:00	2006-09-02 20:00:00
213	251	2006-09-02 19:30:00	2006-09-02 20:00:00
213	153	2006-09-02 19:30:00	2006-09-02 20:00:00
213	282	2006-09-02 19:30:00	2006-09-02 20:00:00
213	283	2006-09-02 19:30:00	2006-09-02 20:00:00
213	60	2006-09-02 19:30:00	2006-09-02 20:00:00
215	266	2006-09-02 20:30:00	2006-09-02 22:45:00
215	4	2006-09-02 22:19:42	2006-09-02 22:45:00
215	135	2006-09-02 20:30:00	2006-09-02 22:45:00
215	243	2006-09-02 20:30:00	2006-09-02 22:45:00
215	90	2006-09-02 20:30:00	2006-09-02 22:45:00
215	235	2006-09-02 20:30:00	2006-09-02 22:45:00
215	13	2006-09-02 20:30:00	2006-09-02 22:45:00
215	217	2006-09-02 20:30:00	2006-09-02 22:45:00
215	280	2006-09-02 20:30:00	2006-09-02 22:45:00
215	244	2006-09-02 20:30:00	2006-09-02 21:35:44
215	230	2006-09-02 20:30:00	2006-09-02 22:45:00
215	64	2006-09-02 20:30:00	2006-09-02 22:45:00
215	274	2006-09-02 20:30:00	2006-09-02 22:45:00
215	154	2006-09-02 20:30:00	2006-09-02 22:45:00
215	285	2006-09-02 20:30:00	2006-09-02 22:45:00
215	234	2006-09-02 20:30:00	2006-09-02 22:45:00
215	286	2006-09-02 20:30:00	2006-09-02 22:45:00
215	257	2006-09-02 21:37:40	2006-09-02 22:45:00
215	150	2006-09-02 20:30:00	2006-09-02 22:45:00
215	155	2006-09-02 20:30:00	2006-09-02 22:45:00
215	170	2006-09-02 20:30:00	2006-09-02 22:45:00
215	202	2006-09-02 20:30:00	2006-09-02 22:45:00
215	259	2006-09-02 20:30:00	2006-09-02 22:45:00
215	270	2006-09-02 20:30:00	2006-09-02 22:45:00
215	44	2006-09-02 20:30:00	2006-09-02 22:45:00
215	220	2006-09-02 20:30:00	2006-09-02 22:45:00
215	100	2006-09-02 20:30:00	2006-09-02 22:45:00
215	103	2006-09-02 20:30:00	2006-09-02 22:45:00
215	188	2006-09-02 20:30:00	2006-09-02 22:45:00
215	222	2006-09-02 20:30:00	2006-09-02 22:45:00
215	151	2006-09-02 20:30:00	2006-09-02 22:18:44
215	223	2006-09-02 20:30:00	2006-09-02 22:45:00
215	72	2006-09-02 20:30:00	2006-09-02 22:45:00
215	148	2006-09-02 20:30:00	2006-09-02 22:45:00
215	116	2006-09-02 20:30:00	2006-09-02 22:45:00
215	61	2006-09-02 20:30:00	2006-09-02 22:45:00
215	171	2006-09-02 20:30:00	2006-09-02 22:45:00
215	109	2006-09-02 20:30:00	2006-09-02 22:45:00
215	152	2006-09-02 20:35:35	2006-09-02 22:45:00
215	262	2006-09-02 21:53:33	2006-09-02 22:45:00
215	89	2006-09-02 20:30:00	2006-09-02 22:45:00
215	167	2006-09-02 20:30:00	2006-09-02 22:45:00
215	212	2006-09-02 20:30:00	2006-09-02 22:45:00
215	85	2006-09-02 20:30:00	2006-09-02 22:45:00
215	251	2006-09-02 20:30:00	2006-09-02 22:45:00
215	153	2006-09-02 20:30:00	2006-09-02 22:45:00
215	282	2006-09-02 20:30:00	2006-09-02 21:39:32
215	283	2006-09-02 20:30:00	2006-09-02 22:45:00
215	60	2006-09-02 20:30:00	2006-09-02 22:45:00
220	266	2006-09-04 00:15:00	2006-09-04 02:15:00
220	90	2006-09-04 01:44:00	2006-09-04 02:15:00
220	235	2006-09-04 00:15:00	2006-09-04 02:15:00
220	15	2006-09-04 00:15:00	2006-09-04 02:15:00
220	123	2006-09-04 00:15:00	2006-09-04 02:06:59
220	280	2006-09-04 00:15:00	2006-09-04 02:15:00
220	244	2006-09-04 00:15:00	2006-09-04 02:15:00
220	29	2006-09-04 00:15:00	2006-09-04 02:07:34
220	272	2006-09-04 00:15:00	2006-09-04 02:15:00
220	209	2006-09-04 00:15:00	2006-09-04 02:11:44
220	259	2006-09-04 00:15:00	2006-09-04 01:30:00
220	103	2006-09-04 00:15:00	2006-09-04 02:15:00
220	51	2006-09-04 00:15:00	2006-09-04 02:07:48
220	148	2006-09-04 00:15:00	2006-09-04 02:15:00
220	132	2006-09-04 00:15:00	2006-09-04 02:15:00
220	116	2006-09-04 00:15:00	2006-09-04 02:15:00
220	61	2006-09-04 00:15:00	2006-09-04 02:15:00
220	171	2006-09-04 00:15:00	2006-09-04 02:15:00
220	251	2006-09-04 00:15:00	2006-09-04 02:15:00
220	282	2006-09-04 00:15:00	2006-09-04 02:15:00
220	283	2006-09-04 00:15:00	2006-09-04 02:15:00
216	266	2006-09-03 19:30:00	2006-09-03 23:35:00
216	135	2006-09-03 19:30:00	2006-09-03 23:35:00
216	275	2006-09-03 19:30:00	2006-09-03 23:35:00
216	90	2006-09-03 19:30:00	2006-09-03 23:35:00
216	235	2006-09-03 19:30:00	2006-09-03 23:35:00
216	13	2006-09-03 19:30:00	2006-09-03 23:35:00
216	217	2006-09-03 19:30:00	2006-09-03 23:35:00
216	123	2006-09-03 19:30:00	2006-09-03 23:35:00
216	280	2006-09-03 19:30:00	2006-09-03 23:35:00
216	157	2006-09-03 19:30:00	2006-09-03 20:34:18
216	244	2006-09-03 19:30:00	2006-09-03 23:35:00
216	64	2006-09-03 19:30:00	2006-09-03 23:35:00
216	98	2006-09-03 19:30:00	2006-09-03 23:35:00
216	32	2006-09-03 19:30:00	2006-09-03 23:35:00
216	154	2006-09-03 19:30:00	2006-09-03 23:35:00
216	285	2006-09-03 19:30:00	2006-09-03 22:28:23
216	272	2006-09-03 19:30:00	2006-09-03 23:35:00
216	150	2006-09-03 19:30:00	2006-09-03 23:35:00
216	155	2006-09-03 19:30:00	2006-09-03 23:35:00
216	120	2006-09-03 19:30:00	2006-09-03 22:36:14
216	81	2006-09-03 19:30:00	2006-09-03 23:35:00
216	259	2006-09-03 19:30:00	2006-09-03 23:35:00
216	270	2006-09-03 19:30:00	2006-09-03 23:35:00
216	44	2006-09-03 19:30:00	2006-09-03 23:35:00
216	67	2006-09-03 22:38:21	2006-09-03 23:35:00
216	114	2006-09-03 19:30:00	2006-09-03 23:35:00
216	103	2006-09-03 19:30:00	2006-09-03 23:35:00
216	51	2006-09-03 22:24:57	2006-09-03 23:35:00
216	188	2006-09-03 19:30:00	2006-09-03 23:35:00
216	222	2006-09-03 19:30:00	2006-09-03 23:35:00
216	223	2006-09-03 19:30:00	2006-09-03 23:35:00
216	148	2006-09-03 19:30:00	2006-09-03 23:35:00
216	132	2006-09-03 19:30:00	2006-09-03 23:35:00
216	116	2006-09-03 19:30:00	2006-09-03 23:35:00
216	61	2006-09-03 19:30:00	2006-09-03 23:35:00
216	171	2006-09-03 19:30:00	2006-09-03 23:35:00
216	152	2006-09-03 20:36:37	2006-09-03 23:35:00
216	89	2006-09-03 19:30:00	2006-09-03 23:35:00
216	167	2006-09-03 19:30:00	2006-09-03 23:35:00
216	55	2006-09-03 22:32:17	2006-09-03 23:35:00
216	251	2006-09-03 19:30:00	2006-09-03 23:35:00
216	153	2006-09-03 19:30:00	2006-09-03 23:32:40
216	282	2006-09-03 19:30:00	2006-09-03 21:41:51
216	277	2006-09-03 19:30:00	2006-09-03 23:35:00
218	1	2006-09-04 13:30:00	2006-09-04 16:00:00
218	266	2006-09-04 13:30:00	2006-09-04 16:00:00
218	284	2006-09-04 13:30:00	2006-09-04 16:00:00
218	2	2006-09-04 13:30:00	2006-09-04 16:00:00
218	97	2006-09-04 13:30:00	2006-09-04 16:00:00
218	239	2006-09-04 14:39:40	2006-09-04 15:19:42
218	5	2006-09-04 13:30:00	2006-09-04 16:00:00
218	287	2006-09-04 13:36:58	2006-09-04 14:50:15
218	90	2006-09-04 13:30:00	2006-09-04 14:18:22
218	13	2006-09-04 13:30:00	2006-09-04 16:00:00
218	16	2006-09-04 13:30:00	2006-09-04 14:15:17
218	123	2006-09-04 13:30:00	2006-09-04 16:00:00
218	21	2006-09-04 13:30:00	2006-09-04 16:00:00
218	96	2006-09-04 14:03:37	2006-09-04 16:00:00
218	23	2006-09-04 13:30:00	2006-09-04 16:00:00
218	157	2006-09-04 13:30:00	2006-09-04 16:00:00
218	26	2006-09-04 15:57:22	2006-09-04 16:00:00
218	30	2006-09-04 13:30:00	2006-09-04 16:00:00
218	274	2006-09-04 13:30:00	2006-09-04 15:36:58
218	31	2006-09-04 14:47:25	2006-09-04 16:00:00
218	32	2006-09-04 13:30:00	2006-09-04 16:00:00
218	272	2006-09-04 13:30:00	2006-09-04 16:00:00
218	35	2006-09-04 13:44:01	2006-09-04 16:00:00
218	225	2006-09-04 14:03:21	2006-09-04 16:00:00
218	150	2006-09-04 14:52:18	2006-09-04 16:00:00
218	155	2006-09-04 13:30:00	2006-09-04 16:00:00
218	39	2006-09-04 13:41:26	2006-09-04 16:00:00
218	209	2006-09-04 13:30:00	2006-09-04 16:00:00
218	41	2006-09-04 13:30:00	2006-09-04 16:00:00
218	43	2006-09-04 15:25:23	2006-09-04 16:00:00
218	259	2006-09-04 13:40:33	2006-09-04 16:00:00
218	174	2006-09-04 13:30:00	2006-09-04 16:00:00
218	270	2006-09-04 13:30:00	2006-09-04 16:00:00
218	44	2006-09-04 13:30:00	2006-09-04 16:00:00
218	248	2006-09-04 13:30:00	2006-09-04 15:43:47
218	48	2006-09-04 14:17:20	2006-09-04 16:00:00
218	100	2006-09-04 13:30:00	2006-09-04 16:00:00
218	103	2006-09-04 13:30:00	2006-09-04 16:00:00
218	132	2006-09-04 13:55:51	2006-09-04 16:00:00
218	61	2006-09-04 13:30:00	2006-09-04 16:00:00
218	171	2006-09-04 14:19:03	2006-09-04 16:00:00
218	160	2006-09-04 14:33:52	2006-09-04 16:00:00
218	54	2006-09-04 14:47:18	2006-09-04 16:00:00
218	55	2006-09-04 15:11:40	2006-09-04 16:00:00
218	251	2006-09-04 13:30:00	2006-09-04 16:00:00
218	153	2006-09-04 14:34:24	2006-09-04 16:00:00
218	282	2006-09-04 14:16:35	2006-09-04 16:00:00
219	1	2006-09-04 21:00:00	2006-09-04 22:45:00
219	284	2006-09-04 21:00:00	2006-09-04 22:45:00
219	2	2006-09-04 21:00:00	2006-09-04 22:45:00
219	4	2006-09-04 21:00:00	2006-09-04 22:45:00
219	206	2006-09-04 21:00:00	2006-09-04 22:45:00
219	5	2006-09-04 21:00:00	2006-09-04 22:45:00
219	15	2006-09-04 21:00:00	2006-09-04 22:45:00
219	16	2006-09-04 21:00:00	2006-09-04 22:45:00
219	19	2006-09-04 21:00:00	2006-09-04 22:45:00
219	96	2006-09-04 21:00:00	2006-09-04 22:45:00
219	27	2006-09-04 21:00:00	2006-09-04 22:45:00
219	28	2006-09-04 21:00:00	2006-09-04 22:45:00
219	232	2006-09-04 21:00:00	2006-09-04 22:45:00
219	29	2006-09-04 21:00:00	2006-09-04 22:45:00
219	30	2006-09-04 21:00:00	2006-09-04 22:45:00
219	32	2006-09-04 21:00:00	2006-09-04 22:45:00
219	136	2006-09-04 21:00:00	2006-09-04 22:45:00
219	234	2006-09-04 21:00:00	2006-09-04 22:45:00
219	35	2006-09-04 21:00:00	2006-09-04 22:45:00
219	36	2006-09-04 21:00:00	2006-09-04 22:45:00
219	39	2006-09-04 21:00:00	2006-09-04 22:45:00
219	40	2006-09-04 21:00:00	2006-09-04 22:45:00
219	41	2006-09-04 21:00:00	2006-09-04 22:45:00
219	43	2006-09-04 21:00:00	2006-09-04 22:45:00
219	259	2006-09-04 21:00:00	2006-09-04 22:45:00
219	48	2006-09-04 21:00:00	2006-09-04 22:45:00
219	50	2006-09-04 21:00:00	2006-09-04 22:45:00
219	100	2006-09-04 21:00:00	2006-09-04 22:45:00
219	103	2006-09-04 21:00:00	2006-09-04 22:45:00
219	51	2006-09-04 21:00:00	2006-09-04 22:45:00
219	52	2006-09-04 21:00:00	2006-09-04 22:45:00
219	148	2006-09-04 21:00:00	2006-09-04 22:45:00
219	233	2006-09-04 21:00:00	2006-09-04 22:45:00
219	132	2006-09-04 21:00:00	2006-09-04 22:45:00
219	116	2006-09-04 21:00:00	2006-09-04 22:45:00
219	61	2006-09-04 21:00:00	2006-09-04 22:45:00
219	160	2006-09-04 21:00:00	2006-09-04 22:45:00
219	57	2006-09-04 21:00:00	2006-09-04 22:45:00
219	153	2006-09-04 21:00:00	2006-09-04 22:45:00
219	60	2006-09-04 21:00:00	2006-09-04 22:45:00
221	289	2006-09-05 00:49:40	2006-09-05 01:25:00
221	4	2006-09-05 00:45:00	2006-09-05 01:25:00
221	135	2006-09-05 00:45:00	2006-09-05 01:25:00
221	290	2006-09-05 00:50:47	2006-09-05 01:25:00
221	217	2006-09-05 00:45:00	2006-09-05 00:58:14
221	15	2006-09-05 00:45:00	2006-09-05 01:25:00
221	19	2006-09-05 00:45:00	2006-09-05 01:25:00
221	21	2006-09-05 00:45:00	2006-09-05 01:25:00
221	96	2006-09-05 00:45:00	2006-09-05 01:25:00
221	230	2006-09-05 00:51:12	2006-09-05 01:25:00
221	27	2006-09-05 00:45:00	2006-09-05 01:25:00
221	28	2006-09-05 00:45:00	2006-09-05 01:25:00
221	232	2006-09-05 00:45:00	2006-09-05 01:25:00
221	32	2006-09-05 00:45:00	2006-09-05 01:25:00
221	33	2006-09-05 00:45:00	2006-09-05 01:25:00
221	35	2006-09-05 00:45:00	2006-09-05 01:25:00
221	36	2006-09-05 00:45:00	2006-09-05 01:25:00
221	257	2006-09-05 00:45:00	2006-09-05 01:25:00
221	209	2006-09-05 00:45:00	2006-09-05 01:25:00
221	81	2006-09-05 00:45:00	2006-09-05 01:25:00
221	41	2006-09-05 00:45:00	2006-09-05 01:25:00
221	43	2006-09-05 00:45:00	2006-09-05 01:25:00
221	45	2006-09-05 00:45:23	2006-09-05 01:25:00
221	291	2006-09-05 00:50:52	2006-09-05 01:25:00
221	106	2006-09-05 00:45:00	2006-09-05 01:25:00
221	48	2006-09-05 00:45:00	2006-09-05 01:25:00
221	50	2006-09-05 00:45:00	2006-09-05 01:25:00
221	100	2006-09-05 00:45:00	2006-09-05 00:52:17
221	103	2006-09-05 00:45:00	2006-09-05 01:25:00
221	51	2006-09-05 00:45:00	2006-09-05 01:25:00
221	222	2006-09-05 00:45:00	2006-09-05 01:25:00
221	52	2006-09-05 00:45:00	2006-09-05 01:25:00
221	148	2006-09-05 00:45:00	2006-09-05 01:25:00
221	233	2006-09-05 00:45:00	2006-09-05 01:25:00
221	116	2006-09-05 00:45:00	2006-09-05 01:25:00
221	61	2006-09-05 00:45:00	2006-09-05 01:25:00
221	152	2006-09-05 00:45:00	2006-09-05 01:25:00
221	55	2006-09-05 00:45:00	2006-09-05 01:25:00
221	153	2006-09-05 00:45:00	2006-09-05 01:25:00
221	283	2006-09-05 00:45:00	2006-09-05 01:25:00
221	60	2006-09-05 00:45:00	2006-09-05 01:25:00
222	1	2006-09-05 21:00:00	2006-09-06 00:20:00
222	2	2006-09-05 21:00:00	2006-09-06 00:20:00
222	4	2006-09-05 21:00:00	2006-09-06 00:20:00
222	135	2006-09-05 21:00:00	2006-09-06 00:20:00
222	8	2006-09-05 21:00:00	2006-09-06 00:20:00
222	15	2006-09-05 21:00:00	2006-09-06 00:20:00
222	19	2006-09-05 21:00:00	2006-09-06 00:20:00
222	21	2006-09-05 21:00:00	2006-09-06 00:20:00
222	96	2006-09-05 21:00:00	2006-09-06 00:20:00
222	157	2006-09-05 21:00:00	2006-09-06 00:20:00
222	27	2006-09-05 21:00:00	2006-09-06 00:20:00
222	28	2006-09-05 21:00:00	2006-09-06 00:20:00
222	232	2006-09-05 21:00:00	2006-09-06 00:20:00
222	29	2006-09-05 21:59:04	2006-09-06 00:20:00
222	30	2006-09-05 21:00:00	2006-09-06 00:20:00
222	32	2006-09-05 21:00:00	2006-09-06 00:20:00
222	33	2006-09-05 21:00:00	2006-09-05 22:42:06
222	136	2006-09-05 21:00:00	2006-09-06 00:20:00
222	272	2006-09-05 21:00:00	2006-09-06 00:20:00
222	36	2006-09-05 21:00:00	2006-09-06 00:20:00
222	155	2006-09-05 21:00:00	2006-09-06 00:20:00
222	209	2006-09-05 23:52:22	2006-09-06 00:20:00
222	81	2006-09-05 21:00:00	2006-09-06 00:20:00
222	41	2006-09-05 21:00:00	2006-09-06 00:20:00
222	43	2006-09-05 21:00:00	2006-09-06 00:20:00
222	259	2006-09-05 21:00:00	2006-09-05 23:31:58
222	270	2006-09-05 21:00:00	2006-09-06 00:20:00
222	45	2006-09-05 23:04:56	2006-09-06 00:20:00
222	142	2006-09-05 21:00:00	2006-09-06 00:20:00
222	48	2006-09-05 21:00:00	2006-09-06 00:20:00
222	50	2006-09-05 21:00:00	2006-09-06 00:20:00
222	100	2006-09-05 21:00:00	2006-09-05 23:50:04
222	51	2006-09-05 21:00:00	2006-09-06 00:20:00
222	222	2006-09-05 23:34:09	2006-09-06 00:20:00
222	52	2006-09-05 21:00:00	2006-09-06 00:20:00
222	148	2006-09-05 21:00:00	2006-09-05 22:30:23
222	233	2006-09-05 21:00:00	2006-09-06 00:20:00
222	116	2006-09-05 21:00:00	2006-09-06 00:20:00
222	171	2006-09-05 21:00:00	2006-09-06 00:20:00
222	160	2006-09-05 21:00:00	2006-09-06 00:20:00
222	152	2006-09-05 21:00:00	2006-09-06 00:20:00
222	55	2006-09-05 22:34:16	2006-09-06 00:20:00
222	57	2006-09-05 21:00:00	2006-09-06 00:20:00
222	282	2006-09-05 21:00:00	2006-09-05 21:57:20
222	60	2006-09-05 21:00:00	2006-09-06 00:20:00
223	1	2006-09-07 21:00:00	2006-09-07 23:28:40
223	2	2006-09-07 21:00:00	2006-09-08 00:30:00
223	4	2006-09-07 21:00:00	2006-09-08 00:30:00
223	5	2006-09-07 21:00:00	2006-09-08 00:30:00
223	135	2006-09-07 21:00:00	2006-09-08 00:30:00
223	8	2006-09-07 21:00:00	2006-09-08 00:30:00
223	15	2006-09-07 21:00:00	2006-09-08 00:30:00
223	16	2006-09-07 21:00:00	2006-09-08 00:30:00
223	19	2006-09-07 21:00:00	2006-09-08 00:30:00
223	21	2006-09-07 21:00:00	2006-09-08 00:30:00
223	96	2006-09-07 21:00:00	2006-09-08 00:30:00
223	157	2006-09-07 21:00:00	2006-09-08 00:30:00
223	244	2006-09-08 00:10:51	2006-09-08 00:30:00
223	27	2006-09-07 21:00:00	2006-09-08 00:30:00
223	28	2006-09-07 21:00:00	2006-09-08 00:30:00
223	232	2006-09-07 21:00:00	2006-09-08 00:30:00
223	30	2006-09-07 21:00:00	2006-09-08 00:30:00
223	31	2006-09-07 21:00:00	2006-09-08 00:14:41
223	32	2006-09-07 21:00:00	2006-09-08 00:30:00
223	33	2006-09-07 21:00:00	2006-09-08 00:30:00
223	136	2006-09-07 21:00:00	2006-09-08 00:30:00
223	35	2006-09-07 21:00:00	2006-09-08 00:30:00
223	36	2006-09-07 21:00:00	2006-09-08 00:30:00
223	39	2006-09-07 21:00:00	2006-09-07 22:55:40
223	40	2006-09-07 21:00:00	2006-09-08 00:10:16
223	81	2006-09-08 00:18:28	2006-09-08 00:30:00
223	41	2006-09-07 21:00:00	2006-09-08 00:30:00
223	43	2006-09-07 21:00:00	2006-09-08 00:30:00
223	62	2006-09-07 23:34:15	2006-09-08 00:30:00
223	45	2006-09-07 21:00:00	2006-09-08 00:30:00
223	142	2006-09-07 23:31:46	2006-09-08 00:30:00
223	106	2006-09-07 21:00:00	2006-09-08 00:30:00
223	48	2006-09-07 21:00:00	2006-09-08 00:30:00
223	50	2006-09-07 21:00:00	2006-09-08 00:30:00
223	100	2006-09-07 21:00:00	2006-09-08 00:30:00
223	103	2006-09-07 21:00:00	2006-09-08 00:30:00
223	51	2006-09-07 21:00:00	2006-09-08 00:30:00
223	222	2006-09-07 22:04:14	2006-09-08 00:30:00
223	52	2006-09-07 21:00:00	2006-09-08 00:30:00
223	233	2006-09-07 21:00:00	2006-09-08 00:30:00
223	116	2006-09-07 21:00:00	2006-09-08 00:30:00
223	61	2006-09-07 22:56:42	2006-09-08 00:30:00
223	171	2006-09-07 21:00:00	2006-09-07 21:56:05
223	160	2006-09-07 21:00:00	2006-09-07 23:26:05
223	57	2006-09-07 21:00:00	2006-09-08 00:30:00
223	153	2006-09-07 21:00:00	2006-09-08 00:30:00
223	60	2006-09-07 21:00:00	2006-09-08 00:30:00
231	1	2006-09-11 22:30:00	2006-09-12 00:15:00
231	97	2006-09-11 22:30:00	2006-09-12 00:15:00
231	4	2006-09-11 22:30:00	2006-09-11 23:51:14
231	5	2006-09-11 22:30:00	2006-09-12 00:15:00
231	135	2006-09-11 22:30:00	2006-09-12 00:15:00
231	8	2006-09-11 22:30:00	2006-09-12 00:15:00
231	15	2006-09-11 22:30:00	2006-09-12 00:15:00
231	19	2006-09-11 22:30:00	2006-09-12 00:15:00
231	21	2006-09-11 22:30:00	2006-09-12 00:15:00
231	96	2006-09-11 22:30:00	2006-09-12 00:15:00
231	23	2006-09-11 22:30:00	2006-09-12 00:15:00
231	157	2006-09-11 22:30:00	2006-09-12 00:09:58
231	244	2006-09-11 22:30:00	2006-09-11 23:59:21
231	27	2006-09-11 22:30:00	2006-09-12 00:15:00
231	28	2006-09-11 22:30:00	2006-09-12 00:15:00
231	232	2006-09-11 22:30:00	2006-09-12 00:15:00
231	30	2006-09-11 22:30:00	2006-09-12 00:15:00
231	32	2006-09-11 22:30:00	2006-09-11 23:59:12
231	299	2006-09-11 23:42:54	2006-09-12 00:15:00
231	33	2006-09-11 22:30:00	2006-09-12 00:15:00
231	35	2006-09-11 22:30:00	2006-09-12 00:15:00
231	258	2006-09-11 22:30:00	2006-09-12 00:15:00
231	36	2006-09-11 22:30:00	2006-09-12 00:15:00
231	39	2006-09-11 22:30:00	2006-09-11 23:37:48
231	41	2006-09-11 22:30:00	2006-09-12 00:15:00
231	43	2006-09-11 22:30:00	2006-09-12 00:15:00
231	62	2006-09-11 22:30:00	2006-09-12 00:15:00
231	45	2006-09-11 23:38:26	2006-09-12 00:15:00
231	142	2006-09-11 22:30:00	2006-09-12 00:15:00
231	48	2006-09-11 22:30:00	2006-09-12 00:15:00
231	50	2006-09-11 22:30:00	2006-09-12 00:15:00
231	100	2006-09-11 22:30:00	2006-09-11 23:51:28
231	103	2006-09-11 22:30:00	2006-09-12 00:15:00
231	51	2006-09-11 22:30:00	2006-09-12 00:15:00
231	52	2006-09-11 22:30:00	2006-09-12 00:15:00
231	223	2006-09-11 23:53:50	2006-09-12 00:15:00
227	266	2006-09-10 19:30:00	2006-09-10 23:20:00
227	97	2006-09-10 19:30:00	2006-09-10 23:20:00
227	200	2006-09-10 19:30:00	2006-09-10 23:20:00
227	135	2006-09-10 19:30:00	2006-09-10 23:20:00
227	90	2006-09-10 19:30:00	2006-09-10 23:20:00
227	235	2006-09-10 19:30:00	2006-09-10 23:20:00
227	13	2006-09-10 19:30:00	2006-09-10 23:20:00
227	123	2006-09-10 19:30:00	2006-09-10 23:20:00
227	238	2006-09-10 19:35:51	2006-09-10 23:20:00
227	280	2006-09-10 19:30:00	2006-09-10 23:20:00
227	157	2006-09-10 19:30:00	2006-09-10 23:20:00
227	244	2006-09-10 19:30:00	2006-09-10 23:20:00
227	230	2006-09-10 19:30:00	2006-09-10 23:20:00
227	98	2006-09-10 19:30:00	2006-09-10 23:20:00
227	154	2006-09-10 19:30:00	2006-09-10 23:20:00
227	285	2006-09-10 19:30:00	2006-09-10 23:20:00
227	272	2006-09-10 19:30:00	2006-09-10 23:20:00
227	234	2006-09-10 19:30:00	2006-09-10 23:20:00
227	258	2006-09-10 19:30:00	2006-09-10 23:20:00
227	257	2006-09-10 19:30:00	2006-09-10 23:20:00
227	150	2006-09-10 19:30:00	2006-09-10 23:20:00
227	155	2006-09-10 19:30:00	2006-09-10 23:20:00
227	170	2006-09-10 19:30:00	2006-09-10 23:20:00
227	209	2006-09-10 19:30:00	2006-09-10 23:20:00
227	202	2006-09-10 19:30:00	2006-09-10 23:20:00
227	259	2006-09-10 19:30:00	2006-09-10 23:20:00
227	270	2006-09-10 19:30:00	2006-09-10 23:20:00
227	44	2006-09-10 19:30:00	2006-09-10 23:20:00
227	297	2006-09-10 19:32:27	2006-09-10 19:33:55
227	221	2006-09-10 20:59:35	2006-09-10 23:20:00
227	103	2006-09-10 19:30:00	2006-09-10 23:20:00
227	222	2006-09-10 19:30:00	2006-09-10 23:20:00
227	148	2006-09-10 19:30:00	2006-09-10 20:58:46
227	132	2006-09-10 19:30:00	2006-09-10 21:54:01
227	171	2006-09-10 19:30:00	2006-09-10 23:20:00
227	54	2006-09-10 19:30:00	2006-09-10 23:20:00
227	89	2006-09-10 19:43:04	2006-09-10 23:20:00
227	76	2006-09-10 19:30:00	2006-09-10 23:20:00
227	251	2006-09-10 19:30:00	2006-09-10 22:17:20
227	153	2006-09-10 19:30:00	2006-09-10 23:20:00
227	56	2006-09-10 19:30:00	2006-09-10 23:20:00
227	283	2006-09-10 21:57:02	2006-09-10 23:20:00
227	59	2006-09-10 19:30:00	2006-09-10 23:20:00
227	277	2006-09-10 19:30:00	2006-09-10 23:20:00
231	233	2006-09-11 22:30:00	2006-09-12 00:15:00
231	116	2006-09-11 22:30:00	2006-09-12 00:15:00
231	61	2006-09-11 22:30:00	2006-09-12 00:15:00
231	160	2006-09-11 22:30:00	2006-09-11 23:37:37
231	55	2006-09-11 22:30:00	2006-09-12 00:15:00
231	153	2006-09-11 22:30:00	2006-09-11 23:39:28
231	283	2006-09-11 22:30:00	2006-09-12 00:15:00
231	60	2006-09-11 22:30:00	2006-09-12 00:15:00
230	1	2006-09-12 21:00:00	2006-09-12 23:50:00
230	97	2006-09-12 21:00:00	2006-09-12 21:35:39
230	4	2006-09-12 21:00:00	2006-09-12 23:50:00
230	206	2006-09-12 21:00:00	2006-09-12 23:50:00
230	5	2006-09-12 21:00:00	2006-09-12 23:50:00
230	135	2006-09-12 21:00:00	2006-09-12 23:50:00
230	8	2006-09-12 21:00:00	2006-09-12 23:50:00
230	13	2006-09-12 23:08:20	2006-09-12 23:50:00
230	15	2006-09-12 21:00:00	2006-09-12 23:50:00
230	16	2006-09-12 21:00:00	2006-09-12 23:50:00
230	19	2006-09-12 21:00:00	2006-09-12 23:50:00
230	21	2006-09-12 21:00:00	2006-09-12 23:50:00
230	96	2006-09-12 21:00:00	2006-09-12 23:50:00
230	157	2006-09-12 21:00:00	2006-09-12 23:50:00
230	244	2006-09-12 21:00:00	2006-09-12 23:50:00
230	230	2006-09-12 21:56:02	2006-09-12 23:50:00
230	27	2006-09-12 21:00:00	2006-09-12 23:50:00
230	28	2006-09-12 21:00:00	2006-09-12 23:50:00
230	232	2006-09-12 21:00:00	2006-09-12 23:50:00
230	30	2006-09-12 21:00:00	2006-09-12 23:50:00
230	32	2006-09-12 21:00:00	2006-09-12 23:50:00
230	33	2006-09-12 21:00:00	2006-09-12 23:38:37
230	136	2006-09-12 21:00:00	2006-09-12 23:50:00
230	258	2006-09-12 22:43:15	2006-09-12 23:50:00
230	36	2006-09-12 21:00:00	2006-09-12 23:50:00
230	269	2006-09-12 21:35:30	2006-09-12 22:11:29
230	39	2006-09-12 21:00:00	2006-09-12 23:07:13
230	209	2006-09-12 23:07:06	2006-09-12 23:50:00
230	41	2006-09-12 21:00:00	2006-09-12 23:50:00
230	43	2006-09-12 21:00:00	2006-09-12 23:50:00
230	259	2006-09-12 21:00:00	2006-09-12 23:50:00
230	62	2006-09-12 21:00:00	2006-09-12 23:50:00
230	142	2006-09-12 21:00:00	2006-09-12 23:50:00
230	48	2006-09-12 21:00:00	2006-09-12 23:50:00
230	100	2006-09-12 21:00:00	2006-09-12 23:50:00
230	103	2006-09-12 21:00:00	2006-09-12 23:50:00
230	51	2006-09-12 21:00:00	2006-09-12 23:50:00
230	222	2006-09-12 22:43:11	2006-09-12 23:50:00
230	52	2006-09-12 21:00:00	2006-09-12 23:04:54
230	233	2006-09-12 21:00:00	2006-09-12 23:50:00
230	116	2006-09-12 21:00:00	2006-09-12 23:07:39
230	61	2006-09-12 21:16:40	2006-09-12 23:04:45
230	171	2006-09-12 21:00:00	2006-09-12 22:38:31
230	160	2006-09-12 21:00:00	2006-09-12 22:38:21
230	57	2006-09-12 21:00:00	2006-09-12 23:50:00
230	153	2006-09-12 21:00:00	2006-09-12 23:50:00
230	60	2006-09-12 21:00:00	2006-09-12 23:50:00
226	284	2006-09-09 20:30:00	2006-09-09 23:15:00
226	97	2006-09-09 20:30:00	2006-09-09 23:14:41
226	4	2006-09-09 20:30:00	2006-09-09 23:15:00
226	200	2006-09-09 20:44:29	2006-09-09 23:15:00
226	263	2006-09-09 20:38:21	2006-09-09 23:15:00
226	135	2006-09-09 20:30:00	2006-09-09 23:14:52
226	288	2006-09-09 20:30:00	2006-09-09 23:15:00
226	275	2006-09-09 20:30:00	2006-09-09 23:14:58
226	90	2006-09-09 20:30:00	2006-09-09 23:15:00
226	294	2006-09-09 20:50:35	2006-09-09 20:52:01
226	235	2006-09-09 21:44:53	2006-09-09 23:15:00
226	13	2006-09-09 20:30:00	2006-09-09 23:15:00
226	123	2006-09-09 20:30:00	2006-09-09 23:14:51
226	17	2006-09-09 20:44:50	2006-09-09 23:15:00
226	278	2006-09-09 20:30:00	2006-09-09 23:15:00
226	295	2006-09-09 20:35:51	2006-09-09 23:15:00
226	280	2006-09-09 20:30:00	2006-09-09 23:15:00
226	244	2006-09-09 20:30:00	2006-09-09 20:36:20
226	161	2006-09-09 21:13:37	2006-09-09 23:14:56
226	27	2006-09-09 20:30:00	2006-09-09 23:14:50
226	274	2006-09-09 20:30:00	2006-09-09 23:14:53
226	119	2006-09-09 22:16:14	2006-09-09 23:15:00
226	258	2006-09-09 20:30:00	2006-09-09 23:15:00
226	257	2006-09-09 20:30:00	2006-09-09 23:15:00
226	150	2006-09-09 20:30:00	2006-09-09 23:15:00
226	155	2006-09-09 20:30:00	2006-09-09 23:14:54
226	170	2006-09-09 20:30:00	2006-09-09 23:15:00
226	202	2006-09-09 20:30:00	2006-09-09 23:15:00
226	259	2006-09-09 20:30:00	2006-09-09 23:15:00
226	270	2006-09-09 20:30:00	2006-09-09 22:00:07
226	44	2006-09-09 20:30:00	2006-09-09 23:14:59
226	249	2006-09-09 20:43:36	2006-09-09 23:15:00
226	296	2006-09-09 20:30:00	2006-09-09 23:15:00
226	114	2006-09-09 20:44:33	2006-09-09 22:23:29
226	103	2006-09-09 20:30:00	2006-09-09 23:14:46
226	188	2006-09-09 20:30:00	2006-09-09 23:15:00
226	52	2006-09-09 20:32:18	2006-09-09 22:16:03
226	223	2006-09-09 20:30:00	2006-09-09 23:14:58
226	61	2006-09-09 20:30:00	2006-09-09 23:15:00
226	160	2006-09-09 20:30:00	2006-09-09 23:15:00
226	152	2006-09-09 20:36:46	2006-09-09 23:15:00
226	76	2006-09-09 20:30:00	2006-09-09 23:15:00
226	85	2006-09-09 20:39:48	2006-09-09 23:15:00
226	57	2006-09-09 20:45:45	2006-09-09 23:14:52
226	56	2006-09-09 20:30:00	2006-09-09 23:14:57
226	283	2006-09-09 20:30:00	2006-09-09 23:15:00
226	231	2006-09-09 20:30:00	2006-09-09 20:30:40
226	59	2006-09-09 20:31:06	2006-09-09 23:15:00
229	284	2006-09-09 11:30:00	2006-09-09 16:30:00
229	97	2006-09-09 11:30:00	2006-09-09 16:30:00
229	5	2006-09-09 11:30:00	2006-09-09 16:30:00
229	288	2006-09-09 11:30:00	2006-09-09 16:30:00
229	287	2006-09-09 11:30:00	2006-09-09 11:48:28
229	90	2006-09-09 11:30:00	2006-09-09 16:30:00
229	235	2006-09-09 11:30:00	2006-09-09 14:14:40
229	123	2006-09-09 12:00:38	2006-09-09 16:30:00
229	19	2006-09-09 12:00:30	2006-09-09 16:30:00
229	23	2006-09-09 12:58:19	2006-09-09 16:10:18
229	280	2006-09-09 11:30:00	2006-09-09 16:30:00
229	157	2006-09-09 11:30:00	2006-09-09 12:57:32
229	35	2006-09-09 12:03:48	2006-09-09 16:30:00
229	258	2006-09-09 13:02:37	2006-09-09 16:30:00
229	111	2006-09-09 11:30:00	2006-09-09 16:08:42
229	259	2006-09-09 11:30:00	2006-09-09 16:30:00
229	100	2006-09-09 11:30:00	2006-09-09 16:30:00
229	293	2006-09-09 11:30:00	2006-09-09 15:53:16
229	114	2006-09-09 11:30:00	2006-09-09 12:06:38
229	103	2006-09-09 11:30:00	2006-09-09 16:30:00
229	148	2006-09-09 11:30:00	2006-09-09 16:30:00
229	61	2006-09-09 11:30:00	2006-09-09 16:30:00
229	160	2006-09-09 11:30:00	2006-09-09 16:30:00
229	54	2006-09-09 11:30:00	2006-09-09 16:30:00
229	76	2006-09-09 15:54:33	2006-09-09 16:30:00
229	85	2006-09-09 11:30:00	2006-09-09 16:30:00
229	283	2006-09-09 15:53:17	2006-09-09 16:30:00
228	1	2006-09-11 21:00:00	2006-09-11 22:00:00
228	97	2006-09-11 21:00:00	2006-09-11 22:00:00
228	4	2006-09-11 21:00:00	2006-09-11 22:00:00
228	5	2006-09-11 21:00:00	2006-09-11 22:00:00
228	135	2006-09-11 21:00:00	2006-09-11 22:00:00
228	8	2006-09-11 21:00:00	2006-09-11 22:00:00
228	15	2006-09-11 21:00:00	2006-09-11 22:00:00
228	16	2006-09-11 21:00:00	2006-09-11 22:00:00
228	19	2006-09-11 21:00:00	2006-09-11 22:00:00
228	21	2006-09-11 21:01:02	2006-09-11 22:00:00
228	96	2006-09-11 21:00:00	2006-09-11 22:00:00
228	157	2006-09-11 21:00:00	2006-09-11 22:00:00
228	244	2006-09-11 21:00:17	2006-09-11 22:00:00
228	27	2006-09-11 21:00:00	2006-09-11 22:00:00
228	28	2006-09-11 21:00:00	2006-09-11 22:00:00
228	232	2006-09-11 21:00:00	2006-09-11 22:00:00
228	30	2006-09-11 21:00:00	2006-09-11 22:00:00
228	32	2006-09-11 21:00:00	2006-09-11 22:00:00
228	33	2006-09-11 21:00:00	2006-09-11 22:00:00
228	35	2006-09-11 21:00:00	2006-09-11 22:00:00
228	258	2006-09-11 21:01:32	2006-09-11 22:00:00
228	36	2006-09-11 21:00:00	2006-09-11 22:00:00
228	39	2006-09-11 21:17:12	2006-09-11 22:00:00
228	40	2006-09-11 21:00:00	2006-09-11 22:00:00
228	41	2006-09-11 21:00:00	2006-09-11 22:00:00
228	43	2006-09-11 21:00:00	2006-09-11 22:00:00
228	142	2006-09-11 21:00:00	2006-09-11 22:00:00
228	48	2006-09-11 21:00:00	2006-09-11 22:00:00
228	50	2006-09-11 21:00:00	2006-09-11 22:00:00
228	100	2006-09-11 21:00:00	2006-09-11 22:00:00
228	103	2006-09-11 21:02:15	2006-09-11 22:00:00
228	51	2006-09-11 21:00:00	2006-09-11 22:00:00
228	52	2006-09-11 21:00:00	2006-09-11 22:00:00
228	233	2006-09-11 21:00:00	2006-09-11 22:00:00
228	116	2006-09-11 21:00:00	2006-09-11 22:00:00
228	160	2006-09-11 21:00:00	2006-09-11 22:00:00
228	55	2006-09-11 21:00:00	2006-09-11 22:00:00
228	57	2006-09-11 21:00:00	2006-09-11 22:00:00
228	153	2006-09-11 21:00:00	2006-09-11 22:00:00
228	60	2006-09-11 21:00:00	2006-09-11 22:00:00
225	284	2006-09-09 19:45:00	2006-09-09 20:15:00
225	97	2006-09-09 19:45:00	2006-09-09 20:15:00
225	4	2006-09-09 19:45:00	2006-09-09 20:15:00
225	135	2006-09-09 19:45:00	2006-09-09 20:15:00
225	275	2006-09-09 19:45:00	2006-09-09 20:15:00
225	90	2006-09-09 19:45:00	2006-09-09 20:15:00
225	13	2006-09-09 19:45:00	2006-09-09 20:15:00
225	123	2006-09-09 19:45:00	2006-09-09 20:15:00
225	278	2006-09-09 19:45:00	2006-09-09 20:15:00
225	280	2006-09-09 19:45:00	2006-09-09 20:15:00
225	244	2006-09-09 19:45:00	2006-09-09 20:15:00
225	27	2006-09-09 19:45:00	2006-09-09 20:15:00
225	274	2006-09-09 19:45:00	2006-09-09 20:15:00
225	33	2006-09-09 19:45:00	2006-09-09 20:15:00
225	119	2006-09-09 19:45:00	2006-09-09 20:15:00
225	136	2006-09-09 19:45:00	2006-09-09 20:15:00
225	258	2006-09-09 19:45:00	2006-09-09 20:15:00
225	257	2006-09-09 19:45:00	2006-09-09 20:15:00
225	150	2006-09-09 19:45:00	2006-09-09 20:15:00
225	155	2006-09-09 19:45:00	2006-09-09 20:15:00
225	170	2006-09-09 19:45:16	2006-09-09 20:15:00
225	202	2006-09-09 19:45:00	2006-09-09 20:15:00
225	43	2006-09-09 19:45:00	2006-09-09 20:15:00
225	259	2006-09-09 19:45:00	2006-09-09 20:15:00
225	292	2006-09-09 19:45:00	2006-09-09 20:15:00
225	270	2006-09-09 19:45:00	2006-09-09 20:15:00
225	44	2006-09-09 19:45:00	2006-09-09 20:15:00
225	100	2006-09-09 19:45:00	2006-09-09 20:15:00
225	103	2006-09-09 19:45:00	2006-09-09 20:15:00
225	51	2006-09-09 19:45:00	2006-09-09 20:15:00
225	188	2006-09-09 19:45:00	2006-09-09 20:15:00
225	52	2006-09-09 19:45:00	2006-09-09 20:15:00
225	223	2006-09-09 19:45:00	2006-09-09 20:15:00
225	61	2006-09-09 19:45:00	2006-09-09 20:15:00
225	171	2006-09-09 19:45:00	2006-09-09 20:15:00
225	107	2006-09-09 19:45:00	2006-09-09 20:15:00
225	160	2006-09-09 19:45:00	2006-09-09 20:15:00
225	76	2006-09-09 19:45:00	2006-09-09 20:15:00
225	55	2006-09-09 19:45:00	2006-09-09 20:15:00
225	56	2006-09-09 19:45:00	2006-09-09 20:15:00
225	283	2006-09-09 19:45:00	2006-09-09 20:15:00
225	231	2006-09-09 19:45:00	2006-09-09 20:15:00
232	1	2006-09-14 21:00:00	2006-09-15 00:40:00
232	284	2006-09-15 00:19:42	2006-09-15 00:40:00
232	2	2006-09-14 21:00:00	2006-09-15 00:40:00
232	4	2006-09-14 21:00:00	2006-09-15 00:40:00
232	5	2006-09-14 21:00:00	2006-09-15 00:40:00
232	135	2006-09-14 21:00:00	2006-09-15 00:40:00
232	8	2006-09-14 21:00:00	2006-09-15 00:40:00
232	175	2006-09-14 21:00:00	2006-09-15 00:40:00
232	15	2006-09-14 21:00:00	2006-09-15 00:40:00
232	16	2006-09-14 21:00:00	2006-09-15 00:40:00
232	19	2006-09-14 21:00:00	2006-09-15 00:40:00
232	21	2006-09-14 21:00:00	2006-09-15 00:40:00
232	96	2006-09-14 21:00:00	2006-09-15 00:40:00
232	157	2006-09-14 21:00:00	2006-09-14 23:49:16
232	244	2006-09-14 21:00:00	2006-09-15 00:40:00
232	27	2006-09-14 21:00:00	2006-09-15 00:40:00
232	232	2006-09-14 21:00:00	2006-09-15 00:40:00
232	29	2006-09-14 21:00:00	2006-09-15 00:40:00
232	30	2006-09-14 21:00:00	2006-09-15 00:40:00
232	32	2006-09-14 21:00:00	2006-09-15 00:40:00
232	33	2006-09-14 21:00:00	2006-09-15 00:40:00
232	136	2006-09-14 21:00:00	2006-09-15 00:40:00
232	258	2006-09-15 00:19:04	2006-09-15 00:40:00
232	36	2006-09-14 21:00:00	2006-09-15 00:40:00
232	39	2006-09-14 21:00:00	2006-09-15 00:15:18
232	170	2006-09-15 00:20:45	2006-09-15 00:40:00
232	40	2006-09-14 21:00:00	2006-09-15 00:15:31
232	81	2006-09-15 00:21:27	2006-09-15 00:40:00
232	41	2006-09-14 21:00:00	2006-09-15 00:40:00
232	43	2006-09-15 00:15:28	2006-09-15 00:40:00
232	270	2006-09-14 21:00:00	2006-09-15 00:40:00
232	45	2006-09-14 21:00:00	2006-09-15 00:40:00
232	48	2006-09-14 21:00:00	2006-09-15 00:40:00
232	67	2006-09-14 21:00:00	2006-09-15 00:15:57
232	100	2006-09-14 21:00:00	2006-09-15 00:15:11
232	103	2006-09-14 21:00:00	2006-09-15 00:40:00
232	51	2006-09-14 21:00:00	2006-09-15 00:40:00
232	52	2006-09-14 21:00:00	2006-09-15 00:40:00
232	233	2006-09-14 21:00:00	2006-09-15 00:40:00
232	116	2006-09-14 21:00:00	2006-09-15 00:40:00
232	61	2006-09-14 23:52:10	2006-09-15 00:40:00
232	160	2006-09-14 21:00:00	2006-09-15 00:14:52
232	55	2006-09-14 21:00:00	2006-09-15 00:40:00
232	57	2006-09-14 21:00:00	2006-09-15 00:40:00
232	282	2006-09-14 21:00:00	2006-09-15 00:40:00
232	60	2006-09-14 21:00:00	2006-09-15 00:40:00
233	301	2006-09-16 13:45:49	2006-09-16 15:30:00
233	266	2006-09-16 11:00:00	2006-09-16 15:30:00
233	284	2006-09-16 11:00:00	2006-09-16 15:30:00
233	2	2006-09-16 11:00:00	2006-09-16 15:30:00
233	90	2006-09-16 11:00:00	2006-09-16 15:30:00
233	280	2006-09-16 11:00:00	2006-09-16 15:30:00
233	157	2006-09-16 11:00:00	2006-09-16 15:30:00
233	30	2006-09-16 11:00:00	2006-09-16 13:50:06
233	299	2006-09-16 11:00:00	2006-09-16 15:09:17
233	285	2006-09-16 11:00:00	2006-09-16 15:30:00
233	136	2006-09-16 11:00:00	2006-09-16 15:30:00
233	234	2006-09-16 11:00:42	2006-09-16 12:49:18
233	155	2006-09-16 11:00:00	2006-09-16 15:30:00
233	39	2006-09-16 15:09:17	2006-09-16 15:30:00
233	259	2006-09-16 11:00:00	2006-09-16 15:30:00
233	270	2006-09-16 13:41:49	2006-09-16 15:30:00
233	100	2006-09-16 11:24:53	2006-09-16 11:59:22
233	51	2006-09-16 12:10:53	2006-09-16 15:30:00
233	148	2006-09-16 11:00:00	2006-09-16 15:30:00
233	61	2006-09-16 11:00:00	2006-09-16 13:40:19
233	281	2006-09-16 11:00:00	2006-09-16 15:30:00
233	54	2006-09-16 11:33:10	2006-09-16 15:30:00
233	89	2006-09-16 13:50:02	2006-09-16 15:30:00
233	167	2006-09-16 11:00:00	2006-09-16 15:30:00
233	55	2006-09-16 13:12:45	2006-09-16 15:30:00
233	251	2006-09-16 11:00:00	2006-09-16 15:30:00
233	282	2006-09-16 11:00:00	2006-09-16 15:30:00
233	283	2006-09-16 11:00:00	2006-09-16 15:30:00
234	5	2006-09-16 19:30:00	2006-09-16 20:13:58
234	135	2006-09-16 19:30:00	2006-09-16 20:15:00
234	8	2006-09-16 19:30:00	2006-09-16 20:15:00
234	175	2006-09-16 19:30:00	2006-09-16 19:35:28
234	90	2006-09-16 19:30:00	2006-09-16 20:15:00
234	235	2006-09-16 19:30:00	2006-09-16 20:15:00
234	13	2006-09-16 19:30:00	2006-09-16 20:15:00
234	16	2006-09-16 19:30:00	2006-09-16 20:15:00
234	123	2006-09-16 19:30:00	2006-09-16 20:15:00
234	280	2006-09-16 19:53:15	2006-09-16 20:15:00
234	157	2006-09-16 19:30:00	2006-09-16 20:15:00
234	244	2006-09-16 19:30:00	2006-09-16 20:15:00
234	274	2006-09-16 19:30:00	2006-09-16 20:15:00
234	299	2006-09-16 19:30:00	2006-09-16 20:15:00
234	154	2006-09-16 19:30:00	2006-09-16 20:15:00
234	285	2006-09-16 19:30:00	2006-09-16 20:15:00
234	258	2006-09-16 19:30:00	2006-09-16 20:15:00
234	257	2006-09-16 19:30:00	2006-09-16 20:15:00
234	150	2006-09-16 19:51:06	2006-09-16 20:15:00
234	300	2006-09-16 19:30:00	2006-09-16 20:15:00
234	155	2006-09-16 19:30:00	2006-09-16 20:15:00
234	170	2006-09-16 19:30:00	2006-09-16 20:15:00
234	202	2006-09-16 19:30:00	2006-09-16 20:15:00
234	43	2006-09-16 19:30:00	2006-09-16 20:15:00
234	259	2006-09-16 19:30:00	2006-09-16 20:15:00
234	270	2006-09-16 19:30:00	2006-09-16 20:15:00
234	44	2006-09-16 19:30:00	2006-09-16 20:15:00
234	296	2006-09-16 19:30:00	2006-09-16 20:15:00
234	100	2006-09-16 19:30:00	2006-09-16 20:15:00
234	188	2006-09-16 19:30:00	2006-09-16 19:52:43
234	223	2006-09-16 19:30:00	2006-09-16 20:15:00
234	233	2006-09-16 19:30:00	2006-09-16 20:15:00
234	132	2006-09-16 19:30:00	2006-09-16 20:15:00
234	116	2006-09-16 19:30:00	2006-09-16 20:15:00
234	61	2006-09-16 19:30:00	2006-09-16 20:15:00
234	171	2006-09-16 19:30:00	2006-09-16 20:15:00
234	89	2006-09-16 19:30:00	2006-09-16 20:15:00
234	76	2006-09-16 19:30:00	2006-09-16 20:15:00
234	212	2006-09-16 19:30:00	2006-09-16 20:15:00
234	282	2006-09-16 19:30:00	2006-09-16 20:15:00
234	283	2006-09-16 19:30:00	2006-09-16 20:15:00
235	284	2006-09-16 20:45:00	2006-09-16 23:45:00
235	4	2006-09-16 22:34:29	2006-09-16 22:51:33
235	135	2006-09-16 20:45:00	2006-09-16 23:45:00
235	8	2006-09-16 20:45:00	2006-09-16 23:45:00
235	175	2006-09-16 20:45:00	2006-09-16 23:45:00
235	243	2006-09-16 20:52:09	2006-09-16 23:45:00
235	90	2006-09-16 20:45:00	2006-09-16 23:45:00
235	235	2006-09-16 20:45:00	2006-09-16 23:45:00
235	13	2006-09-16 20:45:00	2006-09-16 23:45:00
235	123	2006-09-16 20:45:00	2006-09-16 21:46:01
235	280	2006-09-16 20:45:00	2006-09-16 23:45:00
235	244	2006-09-16 20:45:00	2006-09-16 23:45:00
235	230	2006-09-16 20:45:00	2006-09-16 23:45:00
235	274	2006-09-16 20:45:00	2006-09-16 23:45:00
235	299	2006-09-16 20:45:00	2006-09-16 23:45:00
235	119	2006-09-16 20:45:00	2006-09-16 23:45:00
235	154	2006-09-16 20:45:00	2006-09-16 23:45:00
235	285	2006-09-16 20:45:00	2006-09-16 23:45:00
235	234	2006-09-16 20:45:00	2006-09-16 23:45:00
235	258	2006-09-16 20:45:00	2006-09-16 23:45:00
235	257	2006-09-16 20:45:00	2006-09-16 23:45:00
235	150	2006-09-16 20:45:00	2006-09-16 23:45:00
235	300	2006-09-16 20:45:00	2006-09-16 23:45:00
235	155	2006-09-16 20:45:00	2006-09-16 23:45:00
235	170	2006-09-16 20:45:00	2006-09-16 23:45:00
235	202	2006-09-16 20:45:00	2006-09-16 23:45:00
235	259	2006-09-16 20:45:00	2006-09-16 23:45:00
235	302	2006-09-16 20:45:00	2006-09-16 23:45:00
235	44	2006-09-16 20:45:00	2006-09-16 23:45:00
235	296	2006-09-16 20:45:00	2006-09-16 23:45:00
235	221	2006-09-16 22:51:56	2006-09-16 23:45:00
235	114	2006-09-16 20:45:00	2006-09-16 22:34:24
235	222	2006-09-16 20:45:00	2006-09-16 23:45:00
235	223	2006-09-16 20:45:00	2006-09-16 22:51:19
235	267	2006-09-16 22:53:25	2006-09-16 23:45:00
235	132	2006-09-16 20:45:00	2006-09-16 23:45:00
235	61	2006-09-16 20:45:00	2006-09-16 23:45:00
235	89	2006-09-16 20:45:00	2006-09-16 23:45:00
235	76	2006-09-16 20:45:00	2006-09-16 23:45:00
235	212	2006-09-16 20:45:00	2006-09-16 23:45:00
235	153	2006-09-16 20:45:00	2006-09-16 23:45:00
235	282	2006-09-16 20:45:00	2006-09-16 23:45:00
235	283	2006-09-16 20:45:00	2006-09-16 23:45:00
235	59	2006-09-16 20:45:00	2006-09-16 23:45:00
236	266	2006-09-17 19:30:00	2006-09-17 22:00:00
236	135	2006-09-17 19:30:00	2006-09-17 22:00:00
236	175	2006-09-17 19:30:00	2006-09-17 22:00:00
236	243	2006-09-17 19:30:00	2006-09-17 22:00:00
236	90	2006-09-17 19:30:00	2006-09-17 22:00:00
236	235	2006-09-17 19:30:00	2006-09-17 22:00:00
236	13	2006-09-17 19:30:00	2006-09-17 22:00:00
236	217	2006-09-17 19:30:00	2006-09-17 22:00:00
236	199	2006-09-17 19:30:00	2006-09-17 22:00:00
236	123	2006-09-17 19:30:00	2006-09-17 22:00:00
236	244	2006-09-17 19:30:00	2006-09-17 22:00:00
236	230	2006-09-17 19:30:00	2006-09-17 22:00:00
236	98	2006-09-17 19:30:00	2006-09-17 22:00:00
236	299	2006-09-17 19:30:00	2006-09-17 20:15:30
236	154	2006-09-17 19:30:00	2006-09-17 22:00:00
236	285	2006-09-17 19:30:00	2006-09-17 22:00:00
236	234	2006-09-17 20:22:22	2006-09-17 22:00:00
236	258	2006-09-17 19:30:00	2006-09-17 22:00:00
236	257	2006-09-17 19:30:00	2006-09-17 22:00:00
236	150	2006-09-17 19:30:00	2006-09-17 22:00:00
236	300	2006-09-17 19:30:00	2006-09-17 19:36:27
236	155	2006-09-17 19:30:00	2006-09-17 22:00:00
236	170	2006-09-17 19:30:00	2006-09-17 22:00:00
236	202	2006-09-17 19:30:00	2006-09-17 22:00:00
236	259	2006-09-17 19:30:00	2006-09-17 22:00:00
236	270	2006-09-17 19:30:00	2006-09-17 22:00:00
236	44	2006-09-17 19:30:00	2006-09-17 22:00:00
236	296	2006-09-17 19:30:00	2006-09-17 22:00:00
236	221	2006-09-17 19:36:37	2006-09-17 22:00:00
236	103	2006-09-17 19:30:00	2006-09-17 21:22:14
236	222	2006-09-17 19:30:00	2006-09-17 22:00:00
236	223	2006-09-17 19:30:00	2006-09-17 22:00:00
236	132	2006-09-17 19:30:00	2006-09-17 22:00:00
236	61	2006-09-17 19:30:00	2006-09-17 22:00:00
236	89	2006-09-17 19:30:00	2006-09-17 22:00:00
236	76	2006-09-17 19:30:00	2006-09-17 22:00:00
236	212	2006-09-17 19:30:00	2006-09-17 22:00:00
236	251	2006-09-17 19:30:00	2006-09-17 22:00:00
236	153	2006-09-17 19:33:25	2006-09-17 22:00:00
236	56	2006-09-17 19:30:00	2006-09-17 22:00:00
236	282	2006-09-17 21:24:18	2006-09-17 22:00:00
236	283	2006-09-17 19:30:00	2006-09-17 22:00:00
236	59	2006-09-17 19:30:00	2006-09-17 22:00:00
237	1	2006-09-18 21:00:00	2006-09-19 00:12:44
237	2	2006-09-18 21:00:00	2006-09-19 00:15:00
237	4	2006-09-18 21:00:00	2006-09-18 23:39:13
237	5	2006-09-18 21:00:00	2006-09-19 00:15:00
237	135	2006-09-18 23:40:58	2006-09-19 00:15:00
237	8	2006-09-18 21:00:00	2006-09-19 00:15:00
237	90	2006-09-18 21:57:05	2006-09-19 00:15:00
237	13	2006-09-18 22:57:34	2006-09-19 00:15:00
237	15	2006-09-18 23:09:38	2006-09-19 00:15:00
237	16	2006-09-18 21:00:00	2006-09-19 00:15:00
237	19	2006-09-18 22:48:09	2006-09-19 00:15:00
237	244	2006-09-18 21:00:00	2006-09-19 00:15:00
237	27	2006-09-18 21:00:00	2006-09-19 00:15:00
237	28	2006-09-18 21:00:00	2006-09-19 00:15:00
237	232	2006-09-18 21:00:00	2006-09-18 23:58:58
237	29	2006-09-18 21:00:00	2006-09-19 00:15:00
237	30	2006-09-18 21:00:00	2006-09-19 00:15:00
237	32	2006-09-18 21:00:00	2006-09-19 00:15:00
237	299	2006-09-18 21:00:00	2006-09-19 00:15:00
237	33	2006-09-18 21:00:00	2006-09-19 00:15:00
237	234	2006-09-18 23:45:57	2006-09-19 00:15:00
237	258	2006-09-18 21:56:47	2006-09-19 00:15:00
237	36	2006-09-18 21:00:00	2006-09-19 00:15:00
237	150	2006-09-18 21:00:00	2006-09-19 00:15:00
237	39	2006-09-18 21:00:00	2006-09-18 22:48:36
237	40	2006-09-18 21:00:00	2006-09-19 00:13:21
237	41	2006-09-18 21:00:00	2006-09-19 00:15:00
237	43	2006-09-18 21:00:00	2006-09-19 00:15:00
237	270	2006-09-18 21:00:00	2006-09-19 00:15:00
237	45	2006-09-18 21:00:00	2006-09-19 00:15:00
237	142	2006-09-18 21:00:00	2006-09-19 00:15:00
237	48	2006-09-18 21:00:00	2006-09-18 21:56:58
237	50	2006-09-18 21:00:00	2006-09-19 00:15:00
237	100	2006-09-18 21:00:00	2006-09-19 00:12:27
237	103	2006-09-18 21:00:00	2006-09-19 00:15:00
237	51	2006-09-18 21:00:00	2006-09-18 22:47:58
237	52	2006-09-18 21:00:00	2006-09-19 00:15:00
237	148	2006-09-18 21:00:00	2006-09-18 23:40:11
237	233	2006-09-18 21:00:00	2006-09-18 23:59:13
237	116	2006-09-18 21:00:00	2006-09-19 00:15:00
237	61	2006-09-18 22:53:02	2006-09-19 00:15:00
237	171	2006-09-18 21:00:00	2006-09-19 00:15:00
237	160	2006-09-18 21:00:00	2006-09-18 22:50:35
237	167	2006-09-18 21:00:00	2006-09-18 22:55:38
237	55	2006-09-18 21:00:00	2006-09-19 00:15:00
237	57	2006-09-18 21:00:00	2006-09-19 00:15:00
237	153	2006-09-18 21:00:00	2006-09-18 21:45:27
237	60	2006-09-18 21:00:00	2006-09-19 00:15:00
238	2	2006-09-19 21:00:00	2006-09-20 00:15:00
238	4	2006-09-19 21:00:00	2006-09-20 00:15:00
238	5	2006-09-19 21:01:10	2006-09-20 00:15:00
238	135	2006-09-19 21:00:00	2006-09-20 00:15:00
238	8	2006-09-19 21:00:00	2006-09-20 00:15:00
238	175	2006-09-19 21:00:00	2006-09-20 00:15:00
238	15	2006-09-19 21:00:00	2006-09-20 00:15:00
238	19	2006-09-19 21:00:00	2006-09-20 00:15:00
238	21	2006-09-19 21:00:00	2006-09-19 23:59:46
238	157	2006-09-19 21:00:00	2006-09-20 00:15:00
238	244	2006-09-19 21:00:00	2006-09-20 00:15:00
238	27	2006-09-19 21:00:00	2006-09-20 00:15:00
238	28	2006-09-19 21:00:00	2006-09-20 00:15:00
238	232	2006-09-19 21:00:00	2006-09-20 00:15:00
238	29	2006-09-19 21:00:00	2006-09-20 00:15:00
238	30	2006-09-19 21:00:00	2006-09-20 00:15:00
238	32	2006-09-19 21:00:00	2006-09-20 00:15:00
238	299	2006-09-19 23:28:27	2006-09-20 00:15:00
238	154	2006-09-19 23:56:58	2006-09-20 00:15:00
238	136	2006-09-19 21:00:00	2006-09-20 00:15:00
238	272	2006-09-19 23:45:09	2006-09-20 00:15:00
238	258	2006-09-19 23:28:29	2006-09-20 00:15:00
238	39	2006-09-19 21:00:00	2006-09-19 23:23:35
238	170	2006-09-19 21:00:00	2006-09-20 00:15:00
238	40	2006-09-19 21:00:00	2006-09-20 00:15:00
238	41	2006-09-19 21:00:00	2006-09-20 00:15:00
238	43	2006-09-19 23:26:29	2006-09-20 00:15:00
238	259	2006-09-19 21:00:00	2006-09-19 23:20:47
238	270	2006-09-19 21:00:00	2006-09-19 23:21:42
238	45	2006-09-19 21:00:00	2006-09-20 00:15:00
238	142	2006-09-19 21:00:00	2006-09-20 00:15:00
238	48	2006-09-19 21:00:00	2006-09-20 00:15:00
238	50	2006-09-19 21:00:00	2006-09-20 00:15:00
238	100	2006-09-19 21:00:00	2006-09-20 00:01:19
238	221	2006-09-19 23:35:04	2006-09-20 00:15:00
238	103	2006-09-19 21:00:00	2006-09-19 23:17:07
238	51	2006-09-19 21:00:00	2006-09-20 00:15:00
238	52	2006-09-19 21:00:00	2006-09-20 00:15:00
238	148	2006-09-19 21:00:00	2006-09-19 23:59:44
238	233	2006-09-19 21:00:00	2006-09-20 00:15:00
238	116	2006-09-19 21:00:00	2006-09-20 00:15:00
238	171	2006-09-19 21:00:00	2006-09-19 23:21:40
238	55	2006-09-19 21:00:00	2006-09-20 00:15:00
238	57	2006-09-19 21:00:00	2006-09-20 00:15:00
238	153	2006-09-19 21:00:00	2006-09-19 23:22:00
238	60	2006-09-19 21:00:00	2006-09-20 00:15:00
239	1	2006-09-21 21:00:00	2006-09-22 00:30:00
239	4	2006-09-21 21:00:00	2006-09-22 00:30:00
239	206	2006-09-21 21:00:00	2006-09-22 00:30:00
239	5	2006-09-21 21:00:00	2006-09-22 00:30:00
239	135	2006-09-21 21:00:00	2006-09-22 00:30:00
239	8	2006-09-21 21:00:00	2006-09-22 00:30:00
239	175	2006-09-21 21:18:43	2006-09-22 00:30:00
239	90	2006-09-21 21:00:00	2006-09-21 21:10:55
239	15	2006-09-21 21:00:00	2006-09-22 00:30:00
239	16	2006-09-21 23:18:39	2006-09-22 00:30:00
239	19	2006-09-21 23:43:23	2006-09-22 00:30:00
239	21	2006-09-21 21:00:00	2006-09-21 23:55:58
239	157	2006-09-21 21:00:00	2006-09-22 00:30:00
239	244	2006-09-21 21:00:00	2006-09-22 00:29:55
239	27	2006-09-21 21:00:00	2006-09-21 21:41:19
239	28	2006-09-21 21:00:00	2006-09-22 00:30:00
239	232	2006-09-21 21:00:00	2006-09-22 00:29:39
239	29	2006-09-21 21:55:04	2006-09-22 00:30:00
240	284	2006-09-23 11:00:00	2006-09-23 15:55:00
239	32	2006-09-21 21:00:00	2006-09-22 00:30:00
239	33	2006-09-21 21:17:52	2006-09-22 00:30:00
239	154	2006-09-21 23:11:33	2006-09-22 00:30:00
239	136	2006-09-21 21:00:00	2006-09-22 00:30:00
239	257	2006-09-21 21:00:00	2006-09-22 00:30:00
239	300	2006-09-21 21:00:00	2006-09-22 00:29:59
239	39	2006-09-21 21:00:00	2006-09-21 23:08:43
239	170	2006-09-21 21:00:00	2006-09-22 00:30:00
239	40	2006-09-21 21:00:00	2006-09-22 00:30:00
239	81	2006-09-21 21:00:00	2006-09-21 21:17:11
239	41	2006-09-21 21:00:00	2006-09-22 00:30:00
239	259	2006-09-21 21:00:00	2006-09-22 00:30:00
239	270	2006-09-21 21:13:02	2006-09-21 23:56:30
239	44	2006-09-21 21:11:27	2006-09-22 00:30:00
239	45	2006-09-22 00:00:15	2006-09-22 00:30:00
239	142	2006-09-21 23:10:30	2006-09-22 00:30:00
239	48	2006-09-21 21:12:24	2006-09-22 00:29:49
239	50	2006-09-21 21:00:00	2006-09-21 21:09:19
239	100	2006-09-21 21:00:00	2006-09-21 23:36:55
239	51	2006-09-21 21:00:00	2006-09-22 00:30:00
239	52	2006-09-21 21:00:00	2006-09-22 00:30:00
239	148	2006-09-21 21:00:00	2006-09-21 23:08:38
239	233	2006-09-21 21:00:00	2006-09-22 00:30:00
239	116	2006-09-21 21:00:00	2006-09-22 00:30:00
239	160	2006-09-21 21:00:00	2006-09-22 00:29:59
239	89	2006-09-21 21:00:00	2006-09-22 00:30:00
239	167	2006-09-21 21:00:00	2006-09-21 23:11:53
239	55	2006-09-21 21:00:00	2006-09-22 00:30:00
239	57	2006-09-21 21:00:00	2006-09-22 00:30:00
239	153	2006-09-21 21:00:00	2006-09-21 21:12:55
239	283	2006-09-21 21:00:00	2006-09-22 00:28:15
239	60	2006-09-21 21:00:00	2006-09-22 00:30:00
240	5	2006-09-23 11:00:00	2006-09-23 14:36:44
240	8	2006-09-23 11:47:34	2006-09-23 15:55:00
240	275	2006-09-23 11:00:00	2006-09-23 15:55:00
240	90	2006-09-23 11:00:00	2006-09-23 15:55:00
240	304	2006-09-23 15:01:30	2006-09-23 15:55:00
240	19	2006-09-23 11:00:00	2006-09-23 15:55:00
240	23	2006-09-23 11:00:00	2006-09-23 15:55:00
240	26	2006-09-23 11:29:54	2006-09-23 13:27:20
240	30	2006-09-23 11:00:00	2006-09-23 15:55:00
240	274	2006-09-23 14:22:59	2006-09-23 15:01:59
240	31	2006-09-23 12:55:04	2006-09-23 14:19:01
240	299	2006-09-23 11:03:46	2006-09-23 15:55:00
240	136	2006-09-23 14:42:39	2006-09-23 15:55:00
240	286	2006-09-23 13:21:09	2006-09-23 15:55:00
240	257	2006-09-23 11:00:00	2006-09-23 15:55:00
240	39	2006-09-23 11:00:00	2006-09-23 15:55:00
240	41	2006-09-23 11:00:00	2006-09-23 14:39:36
240	305	2006-09-23 11:00:00	2006-09-23 14:35:33
240	259	2006-09-23 11:00:00	2006-09-23 15:55:00
240	270	2006-09-23 14:22:17	2006-09-23 15:55:00
240	306	2006-09-23 11:26:19	2006-09-23 14:19:09
240	100	2006-09-23 13:32:35	2006-09-23 13:40:00
240	103	2006-09-23 11:00:00	2006-09-23 11:21:12
240	115	2006-09-23 13:00:19	2006-09-23 13:26:55
240	307	2006-09-23 11:00:00	2006-09-23 11:46:25
240	116	2006-09-23 13:31:43	2006-09-23 15:55:00
240	109	2006-09-23 14:41:40	2006-09-23 15:55:00
240	54	2006-09-23 11:00:00	2006-09-23 15:55:00
240	163	2006-09-23 11:00:00	2006-09-23 12:59:11
240	89	2006-09-23 12:44:59	2006-09-23 15:55:00
240	251	2006-09-23 11:00:00	2006-09-23 15:55:00
240	283	2006-09-23 11:00:00	2006-09-23 15:55:00
241	284	2006-09-23 19:30:00	2006-09-23 20:15:00
241	5	2006-09-23 19:30:00	2006-09-23 20:15:00
241	135	2006-09-23 19:30:00	2006-09-23 20:15:00
241	8	2006-09-23 19:30:00	2006-09-23 20:15:00
241	175	2006-09-23 19:30:00	2006-09-23 20:15:00
241	90	2006-09-23 19:30:00	2006-09-23 20:15:00
241	235	2006-09-23 19:30:00	2006-09-23 20:15:00
241	217	2006-09-23 19:30:00	2006-09-23 20:15:00
241	123	2006-09-23 19:30:00	2006-09-23 20:15:00
241	244	2006-09-23 19:30:00	2006-09-23 20:15:00
241	230	2006-09-23 19:30:00	2006-09-23 20:15:00
241	32	2006-09-23 19:30:00	2006-09-23 20:15:00
241	299	2006-09-23 19:30:00	2006-09-23 20:15:00
241	119	2006-09-23 19:30:00	2006-09-23 20:15:00
241	154	2006-09-23 19:30:00	2006-09-23 20:15:00
241	136	2006-09-23 19:30:00	2006-09-23 20:15:00
241	258	2006-09-23 19:30:00	2006-09-23 20:15:00
241	257	2006-09-23 19:30:00	2006-09-23 20:15:00
241	150	2006-09-23 19:30:00	2006-09-23 20:15:00
241	155	2006-09-23 19:30:00	2006-09-23 20:15:00
241	170	2006-09-23 19:30:00	2006-09-23 20:15:00
241	202	2006-09-23 19:40:44	2006-09-23 20:15:00
241	259	2006-09-23 19:32:42	2006-09-23 20:15:00
241	270	2006-09-23 19:30:00	2006-09-23 20:15:00
241	44	2006-09-23 19:30:00	2006-09-23 20:15:00
241	296	2006-09-23 19:30:00	2006-09-23 20:15:00
241	221	2006-09-23 19:30:00	2006-09-23 20:15:00
241	51	2006-09-23 19:30:00	2006-09-23 20:15:00
241	188	2006-09-23 19:30:00	2006-09-23 20:15:00
241	222	2006-09-23 19:30:00	2006-09-23 20:15:00
241	307	2006-09-23 19:30:00	2006-09-23 20:15:00
241	233	2006-09-23 19:30:00	2006-09-23 20:15:00
241	132	2006-09-23 19:30:00	2006-09-23 20:15:00
241	308	2006-09-23 19:30:00	2006-09-23 20:15:00
241	171	2006-09-23 19:30:00	2006-09-23 20:15:00
241	109	2006-09-23 19:30:00	2006-09-23 20:15:00
241	76	2006-09-23 19:30:00	2006-09-23 20:15:00
241	212	2006-09-23 19:30:00	2006-09-23 20:15:00
241	251	2006-09-23 19:30:00	2006-09-23 20:15:00
241	283	2006-09-23 19:30:00	2006-09-23 20:15:00
241	59	2006-09-23 19:30:00	2006-09-23 20:15:00
241	60	2006-09-23 19:30:00	2006-09-23 20:15:00
242	301	2006-09-23 22:02:33	2006-09-24 00:25:00
242	284	2006-09-23 21:00:00	2006-09-24 00:24:58
242	4	2006-09-23 23:03:43	2006-09-23 23:21:10
242	135	2006-09-23 21:00:00	2006-09-24 00:24:27
242	175	2006-09-23 21:00:00	2006-09-24 00:25:00
242	243	2006-09-23 21:00:00	2006-09-24 00:25:00
242	275	2006-09-23 21:00:00	2006-09-24 00:25:00
242	90	2006-09-23 21:00:00	2006-09-24 00:25:00
242	235	2006-09-23 21:00:00	2006-09-24 00:25:00
242	217	2006-09-23 21:00:00	2006-09-24 00:25:00
242	123	2006-09-23 21:00:00	2006-09-24 00:25:00
242	244	2006-09-23 21:00:00	2006-09-24 00:25:00
242	230	2006-09-23 21:00:00	2006-09-24 00:25:00
242	31	2006-09-23 21:00:00	2006-09-24 00:25:00
242	164	2006-09-23 21:00:00	2006-09-24 00:25:00
242	299	2006-09-23 21:00:00	2006-09-24 00:24:43
242	119	2006-09-23 21:00:00	2006-09-24 00:25:00
242	154	2006-09-23 21:00:00	2006-09-24 00:25:00
242	136	2006-09-23 21:00:00	2006-09-24 00:25:00
242	286	2006-09-23 21:00:00	2006-09-24 00:25:00
242	258	2006-09-23 21:00:00	2006-09-24 00:25:00
242	257	2006-09-23 21:00:00	2006-09-24 00:24:51
242	150	2006-09-23 21:00:00	2006-09-24 00:25:00
242	310	2006-09-23 21:00:00	2006-09-24 00:25:00
242	155	2006-09-23 21:00:00	2006-09-24 00:25:00
242	170	2006-09-23 21:00:00	2006-09-24 00:24:23
242	202	2006-09-23 21:00:00	2006-09-24 00:25:00
242	259	2006-09-23 21:00:00	2006-09-24 00:24:51
243	301	2006-09-24 19:30:00	2006-09-24 22:07:53
242	306	2006-09-23 21:00:00	2006-09-24 00:25:00
242	50	2006-09-23 21:00:00	2006-09-24 00:24:59
242	226	2006-09-23 21:00:00	2006-09-23 22:04:28
242	293	2006-09-23 21:00:00	2006-09-24 00:25:00
242	221	2006-09-23 21:00:00	2006-09-24 00:24:43
242	114	2006-09-23 21:00:00	2006-09-23 23:02:52
242	103	2006-09-23 21:00:00	2006-09-24 00:25:00
242	51	2006-09-23 21:00:00	2006-09-23 21:17:05
242	188	2006-09-23 21:00:00	2006-09-24 00:25:00
242	311	2006-09-23 21:00:26	2006-09-24 00:24:51
242	222	2006-09-23 21:00:00	2006-09-24 00:24:43
242	165	2006-09-23 21:04:51	2006-09-23 23:35:18
242	267	2006-09-23 21:00:00	2006-09-24 00:24:53
242	148	2006-09-23 21:00:00	2006-09-24 00:25:00
242	132	2006-09-23 21:00:00	2006-09-24 00:25:00
242	308	2006-09-23 21:00:00	2006-09-24 00:25:00
242	109	2006-09-23 21:00:00	2006-09-24 00:25:00
242	76	2006-09-23 21:00:00	2006-09-24 00:24:17
242	212	2006-09-23 21:00:00	2006-09-24 00:25:00
242	251	2006-09-23 21:00:00	2006-09-24 00:25:00
242	153	2006-09-23 23:35:59	2006-09-24 00:24:51
242	283	2006-09-23 21:00:00	2006-09-24 00:25:00
242	59	2006-09-23 21:00:00	2006-09-24 00:24:51
242	60	2006-09-23 21:00:00	2006-09-23 22:02:25
243	266	2006-09-24 19:30:00	2006-09-24 22:14:58
243	284	2006-09-24 19:30:00	2006-09-24 23:15:00
243	135	2006-09-24 19:30:00	2006-09-24 23:15:00
243	243	2006-09-24 19:30:00	2006-09-24 23:15:00
243	275	2006-09-24 19:30:00	2006-09-24 23:15:00
243	90	2006-09-24 19:30:00	2006-09-24 23:15:00
243	235	2006-09-24 19:30:00	2006-09-24 23:15:00
243	13	2006-09-24 19:30:00	2006-09-24 23:15:00
243	217	2006-09-24 19:30:00	2006-09-24 23:15:00
243	123	2006-09-24 19:30:00	2006-09-24 23:15:00
243	244	2006-09-24 19:30:00	2006-09-24 23:15:00
243	230	2006-09-24 19:30:00	2006-09-24 23:15:00
243	28	2006-09-24 22:08:42	2006-09-24 23:15:00
243	274	2006-09-24 19:30:00	2006-09-24 23:15:00
243	154	2006-09-24 19:30:00	2006-09-24 23:15:00
243	285	2006-09-24 19:30:00	2006-09-24 23:15:00
243	234	2006-09-24 19:30:00	2006-09-24 23:15:00
243	258	2006-09-24 19:30:00	2006-09-24 23:15:00
243	257	2006-09-24 19:30:00	2006-09-24 23:15:00
243	150	2006-09-24 22:15:13	2006-09-24 23:15:00
243	300	2006-09-24 19:30:00	2006-09-24 23:15:00
243	84	2006-09-24 19:40:04	2006-09-24 23:15:00
243	155	2006-09-24 19:30:00	2006-09-24 23:15:00
243	259	2006-09-24 19:30:00	2006-09-24 22:45:48
243	270	2006-09-24 19:30:00	2006-09-24 22:18:48
243	44	2006-09-24 19:30:00	2006-09-24 23:15:00
243	227	2006-09-24 22:10:15	2006-09-24 23:15:00
243	296	2006-09-24 22:10:37	2006-09-24 23:15:00
243	221	2006-09-24 19:30:00	2006-09-24 23:15:00
243	312	2006-09-24 19:30:00	2006-09-24 19:36:07
243	188	2006-09-24 19:30:00	2006-09-24 22:06:06
243	222	2006-09-24 19:30:00	2006-09-24 23:15:00
243	223	2006-09-24 19:30:00	2006-09-24 23:15:00
243	267	2006-09-24 19:30:47	2006-09-24 22:06:34
243	148	2006-09-24 19:30:00	2006-09-24 23:15:00
243	132	2006-09-24 19:30:00	2006-09-24 23:15:00
243	54	2006-09-24 19:30:00	2006-09-24 23:15:00
243	262	2006-09-24 19:30:00	2006-09-24 22:06:51
243	89	2006-09-24 19:30:00	2006-09-24 23:15:00
243	76	2006-09-24 19:30:00	2006-09-24 23:15:00
243	167	2006-09-24 19:30:00	2006-09-24 23:15:00
243	212	2006-09-24 19:30:00	2006-09-24 23:15:00
243	55	2006-09-24 19:30:51	2006-09-24 23:15:00
243	251	2006-09-24 19:30:00	2006-09-24 22:16:10
243	153	2006-09-24 19:30:33	2006-09-24 23:15:00
243	283	2006-09-24 19:30:00	2006-09-24 23:14:36
243	59	2006-09-24 19:30:00	2006-09-24 23:15:00
244	1	2006-09-25 21:00:00	2006-09-26 00:00:00
244	2	2006-09-25 21:00:00	2006-09-26 00:00:00
244	4	2006-09-25 21:00:00	2006-09-26 00:00:00
244	5	2006-09-25 22:49:43	2006-09-26 00:00:00
244	135	2006-09-25 21:00:00	2006-09-26 00:00:00
244	8	2006-09-25 21:00:00	2006-09-26 00:00:00
244	90	2006-09-25 21:00:00	2006-09-26 00:00:00
244	15	2006-09-25 21:00:00	2006-09-26 00:00:00
244	19	2006-09-25 21:00:00	2006-09-26 00:00:00
244	21	2006-09-25 21:00:00	2006-09-26 00:00:00
244	157	2006-09-25 21:00:00	2006-09-26 00:00:00
244	230	2006-09-25 23:04:41	2006-09-26 00:00:00
244	27	2006-09-25 21:00:00	2006-09-26 00:00:00
244	28	2006-09-25 21:00:00	2006-09-26 00:00:00
244	232	2006-09-25 21:00:00	2006-09-26 00:00:00
244	30	2006-09-25 21:00:00	2006-09-26 00:00:00
244	31	2006-09-25 21:00:00	2006-09-26 00:00:00
244	32	2006-09-25 21:00:00	2006-09-26 00:00:00
244	33	2006-09-25 21:00:00	2006-09-26 00:00:00
244	154	2006-09-25 23:31:05	2006-09-26 00:00:00
244	136	2006-09-25 21:00:00	2006-09-26 00:00:00
244	36	2006-09-25 21:00:00	2006-09-26 00:00:00
244	257	2006-09-25 23:33:02	2006-09-26 00:00:00
244	39	2006-09-25 21:00:00	2006-09-25 23:28:02
244	40	2006-09-25 21:00:00	2006-09-26 00:00:00
244	41	2006-09-25 21:07:13	2006-09-26 00:00:00
244	259	2006-09-25 21:00:00	2006-09-25 23:30:46
244	270	2006-09-25 21:00:00	2006-09-26 00:00:00
244	45	2006-09-25 21:00:00	2006-09-26 00:00:00
244	142	2006-09-25 21:00:00	2006-09-26 00:00:00
244	227	2006-09-25 23:34:12	2006-09-26 00:00:00
244	50	2006-09-25 21:00:00	2006-09-26 00:00:00
244	100	2006-09-25 21:00:00	2006-09-26 00:00:00
244	103	2006-09-25 21:00:00	2006-09-26 00:00:00
244	51	2006-09-25 21:00:00	2006-09-26 00:00:00
244	52	2006-09-25 21:00:00	2006-09-26 00:00:00
244	148	2006-09-25 21:00:00	2006-09-25 22:47:30
244	233	2006-09-25 21:00:00	2006-09-26 00:00:00
244	116	2006-09-25 21:00:00	2006-09-26 00:00:00
244	171	2006-09-25 21:00:00	2006-09-26 00:00:00
244	160	2006-09-25 21:00:00	2006-09-25 23:30:43
244	167	2006-09-25 21:00:00	2006-09-25 22:45:53
244	55	2006-09-25 21:00:00	2006-09-26 00:00:00
244	57	2006-09-25 21:00:00	2006-09-26 00:00:00
244	60	2006-09-25 21:00:00	2006-09-26 00:00:00
246	1	2006-09-26 21:00:00	2006-09-27 00:30:00
246	2	2006-09-26 21:00:00	2006-09-27 00:30:00
246	4	2006-09-26 21:00:00	2006-09-27 00:30:00
246	5	2006-09-26 21:00:00	2006-09-27 00:30:00
246	135	2006-09-26 21:00:00	2006-09-27 00:30:00
246	8	2006-09-26 21:00:00	2006-09-27 00:30:00
246	90	2006-09-26 21:00:00	2006-09-27 00:30:00
246	13	2006-09-26 21:00:00	2006-09-27 00:30:00
246	15	2006-09-26 21:16:21	2006-09-27 00:30:00
246	16	2006-09-26 23:14:18	2006-09-27 00:30:00
246	19	2006-09-26 21:00:00	2006-09-27 00:30:00
246	21	2006-09-26 21:01:10	2006-09-27 00:30:00
246	157	2006-09-26 21:02:34	2006-09-27 00:30:00
246	27	2006-09-26 21:00:00	2006-09-27 00:30:00
246	28	2006-09-26 21:00:00	2006-09-27 00:30:00
246	232	2006-09-26 21:00:00	2006-09-27 00:30:00
246	31	2006-09-26 21:00:00	2006-09-27 00:30:00
246	32	2006-09-26 21:00:00	2006-09-27 00:30:00
246	33	2006-09-26 21:00:00	2006-09-27 00:30:00
246	136	2006-09-26 21:00:00	2006-09-27 00:30:00
246	39	2006-09-26 21:00:00	2006-09-26 23:07:07
246	170	2006-09-26 23:42:57	2006-09-27 00:25:42
246	81	2006-09-26 21:00:00	2006-09-27 00:30:00
246	41	2006-09-26 21:00:00	2006-09-27 00:30:00
246	259	2006-09-26 21:00:00	2006-09-27 00:10:01
246	270	2006-09-26 21:00:00	2006-09-27 00:30:00
246	45	2006-09-26 21:00:00	2006-09-27 00:30:00
246	142	2006-09-26 21:00:00	2006-09-27 00:30:00
246	227	2006-09-26 21:00:00	2006-09-27 00:30:00
246	50	2006-09-26 23:30:23	2006-09-27 00:30:00
246	100	2006-09-26 21:00:00	2006-09-27 00:30:00
246	103	2006-09-26 21:00:00	2006-09-27 00:30:00
246	51	2006-09-26 23:10:08	2006-09-27 00:30:00
246	53	2006-09-26 21:00:00	2006-09-26 23:32:49
246	148	2006-09-26 21:00:00	2006-09-26 23:15:41
246	233	2006-09-26 21:00:00	2006-09-27 00:30:00
246	116	2006-09-26 22:37:15	2006-09-27 00:30:00
246	171	2006-09-26 21:00:00	2006-09-27 00:30:00
246	160	2006-09-26 21:00:00	2006-09-26 22:02:18
246	89	2006-09-26 21:00:00	2006-09-27 00:30:00
246	55	2006-09-26 21:00:00	2006-09-27 00:30:00
246	57	2006-09-26 21:00:00	2006-09-27 00:30:00
246	251	2006-09-26 21:00:00	2006-09-26 23:06:15
246	153	2006-09-26 21:00:00	2006-09-27 00:30:00
246	60	2006-09-26 21:00:00	2006-09-27 00:30:00
248	284	2006-09-30 11:00:00	2006-09-30 14:40:00
248	313	2006-09-30 11:00:00	2006-09-30 14:40:00
248	8	2006-09-30 11:00:59	2006-09-30 14:40:00
248	90	2006-09-30 11:00:00	2006-09-30 14:40:00
248	235	2006-09-30 11:00:00	2006-09-30 13:37:01
248	123	2006-09-30 11:00:00	2006-09-30 14:12:21
248	280	2006-09-30 11:00:00	2006-09-30 14:40:00
248	26	2006-09-30 11:00:00	2006-09-30 14:40:00
248	285	2006-09-30 11:00:00	2006-09-30 14:25:42
248	120	2006-09-30 11:00:00	2006-09-30 13:37:56
248	40	2006-09-30 11:07:16	2006-09-30 14:40:00
248	259	2006-09-30 11:00:00	2006-09-30 14:40:00
248	227	2006-09-30 11:00:05	2006-09-30 14:40:00
248	237	2006-09-30 14:05:32	2006-09-30 14:40:00
248	188	2006-09-30 11:02:22	2006-09-30 13:38:34
248	148	2006-09-30 11:00:00	2006-09-30 14:40:00
248	160	2006-09-30 11:00:00	2006-09-30 14:40:00
248	54	2006-09-30 11:00:00	2006-09-30 14:40:00
248	240	2006-09-30 11:00:00	2006-09-30 14:35:07
248	89	2006-09-30 11:00:00	2006-09-30 14:27:02
248	167	2006-09-30 11:00:00	2006-09-30 14:40:00
248	251	2006-09-30 11:00:00	2006-09-30 14:40:00
248	283	2006-09-30 11:00:00	2006-09-30 14:40:00
248	59	2006-09-30 13:41:06	2006-09-30 14:40:00
249	1	2006-09-30 19:30:00	2006-09-30 19:57:20
249	301	2006-09-30 19:30:00	2006-09-30 20:00:00
249	135	2006-09-30 19:30:00	2006-09-30 20:00:00
249	90	2006-09-30 19:30:00	2006-09-30 20:00:00
249	217	2006-09-30 19:30:00	2006-09-30 20:00:00
249	123	2006-09-30 19:30:00	2006-09-30 20:00:00
249	21	2006-09-30 19:30:00	2006-09-30 20:00:00
249	238	2006-09-30 19:30:00	2006-09-30 20:00:00
249	244	2006-09-30 19:30:00	2006-09-30 20:00:00
249	26	2006-09-30 19:30:00	2006-09-30 20:00:00
249	98	2006-09-30 19:30:00	2006-09-30 20:00:00
249	274	2006-09-30 19:30:00	2006-09-30 20:00:00
249	154	2006-09-30 19:30:00	2006-09-30 20:00:00
249	285	2006-09-30 19:30:00	2006-09-30 20:00:00
249	257	2006-09-30 19:30:00	2006-09-30 20:00:00
249	150	2006-09-30 19:30:00	2006-09-30 20:00:00
249	300	2006-09-30 19:30:00	2006-09-30 20:00:00
249	170	2006-09-30 19:30:00	2006-09-30 20:00:00
249	259	2006-09-30 19:30:00	2006-09-30 20:00:00
249	270	2006-09-30 19:30:00	2006-09-30 20:00:00
249	44	2006-09-30 19:30:00	2006-09-30 20:00:00
249	106	2006-09-30 19:30:00	2006-09-30 20:00:00
249	296	2006-09-30 19:30:00	2006-09-30 20:00:00
249	221	2006-09-30 19:30:00	2006-09-30 20:00:00
249	233	2006-09-30 19:30:00	2006-09-30 20:00:00
249	132	2006-09-30 19:30:00	2006-09-30 20:00:00
249	308	2006-09-30 19:30:00	2006-09-30 20:00:00
249	89	2006-09-30 19:30:00	2006-09-30 20:00:00
249	76	2006-09-30 19:30:00	2006-09-30 20:00:00
249	167	2006-09-30 19:30:00	2006-09-30 20:00:00
249	212	2006-09-30 19:30:00	2006-09-30 20:00:00
249	55	2006-09-30 19:30:00	2006-09-30 20:00:00
249	251	2006-09-30 19:30:00	2006-09-30 20:00:00
249	56	2006-09-30 19:30:00	2006-09-30 20:00:00
249	282	2006-09-30 19:30:00	2006-09-30 20:00:00
249	283	2006-09-30 19:30:00	2006-09-30 20:00:00
249	59	2006-09-30 19:30:00	2006-09-30 20:00:00
249	277	2006-09-30 19:30:00	2006-09-30 20:00:00
250	1	2006-09-30 20:30:00	2006-09-30 23:30:00
250	301	2006-09-30 20:30:00	2006-09-30 23:29:38
250	284	2006-09-30 20:30:00	2006-09-30 23:29:38
250	4	2006-09-30 22:10:19	2006-09-30 22:40:01
250	135	2006-09-30 20:30:00	2006-09-30 23:29:38
250	275	2006-09-30 20:30:00	2006-09-30 23:29:38
250	90	2006-09-30 20:30:00	2006-09-30 23:29:38
250	235	2006-09-30 22:52:28	2006-09-30 23:29:38
250	217	2006-09-30 20:30:00	2006-09-30 23:29:38
250	123	2006-09-30 20:30:00	2006-09-30 23:29:38
250	18	2006-09-30 20:30:00	2006-09-30 23:29:38
250	21	2006-09-30 20:30:00	2006-09-30 23:30:00
250	238	2006-09-30 20:30:00	2006-09-30 23:29:38
250	280	2006-09-30 20:30:00	2006-09-30 23:29:38
250	244	2006-09-30 20:30:00	2006-09-30 23:29:38
250	98	2006-09-30 20:30:00	2006-09-30 23:29:38
250	274	2006-09-30 20:30:00	2006-09-30 23:30:00
250	31	2006-09-30 20:30:00	2006-09-30 22:39:46
250	154	2006-09-30 20:30:00	2006-09-30 23:29:38
250	285	2006-09-30 20:30:00	2006-09-30 23:29:28
250	257	2006-09-30 20:30:00	2006-09-30 23:29:26
250	150	2006-09-30 20:30:00	2006-09-30 23:29:32
250	300	2006-09-30 20:30:00	2006-09-30 23:29:33
250	84	2006-09-30 20:30:00	2006-09-30 23:29:38
250	170	2006-09-30 20:30:00	2006-09-30 23:29:38
250	259	2006-09-30 20:30:00	2006-09-30 22:38:47
250	270	2006-09-30 20:30:00	2006-09-30 23:29:38
250	44	2006-09-30 20:30:00	2006-09-30 23:29:38
250	297	2006-09-30 20:30:00	2006-09-30 23:29:38
250	106	2006-09-30 20:30:00	2006-09-30 23:30:00
250	227	2006-09-30 20:30:00	2006-09-30 22:09:59
250	296	2006-09-30 20:30:00	2006-09-30 23:29:38
250	226	2006-09-30 20:30:00	2006-09-30 22:09:07
250	221	2006-09-30 20:30:00	2006-09-30 23:29:38
250	132	2006-09-30 20:30:00	2006-09-30 23:29:38
250	308	2006-09-30 20:30:00	2006-09-30 23:29:38
250	75	2006-09-30 20:30:00	2006-09-30 23:29:20
250	281	2006-09-30 21:20:28	2006-09-30 23:29:38
250	89	2006-09-30 20:30:00	2006-09-30 23:29:32
250	76	2006-09-30 20:30:00	2006-09-30 23:29:38
250	167	2006-09-30 20:30:00	2006-09-30 23:29:38
250	212	2006-09-30 20:30:00	2006-09-30 23:29:35
250	63	2006-09-30 21:20:52	2006-09-30 23:29:38
250	55	2006-09-30 20:30:00	2006-09-30 23:30:00
250	251	2006-09-30 20:30:00	2006-09-30 23:29:38
250	153	2006-09-30 20:30:00	2006-09-30 23:29:38
250	56	2006-09-30 20:30:00	2006-09-30 23:29:38
250	282	2006-09-30 20:30:00	2006-09-30 20:36:19
250	283	2006-09-30 20:30:00	2006-09-30 23:29:38
250	59	2006-09-30 20:30:00	2006-09-30 23:29:38
250	277	2006-09-30 20:30:00	2006-09-30 23:29:38
247	1	2006-09-28 21:00:00	2006-09-28 22:50:00
247	284	2006-09-28 21:00:00	2006-09-28 22:50:00
247	206	2006-09-28 21:00:00	2006-09-28 22:50:00
247	5	2006-09-28 21:00:00	2006-09-28 22:50:00
247	135	2006-09-28 21:00:00	2006-09-28 22:50:00
247	90	2006-09-28 21:00:00	2006-09-28 22:50:00
247	13	2006-09-28 21:00:00	2006-09-28 22:49:20
247	15	2006-09-28 21:00:00	2006-09-28 22:50:00
247	19	2006-09-28 21:00:00	2006-09-28 22:50:00
247	21	2006-09-28 21:00:00	2006-09-28 22:50:00
247	157	2006-09-28 21:00:00	2006-09-28 22:50:00
247	27	2006-09-28 21:00:00	2006-09-28 22:50:00
247	28	2006-09-28 21:00:00	2006-09-28 22:50:00
247	232	2006-09-28 21:00:00	2006-09-28 22:50:00
247	30	2006-09-28 21:00:00	2006-09-28 22:50:00
247	31	2006-09-28 21:00:00	2006-09-28 22:50:00
247	32	2006-09-28 21:00:00	2006-09-28 22:50:00
247	154	2006-09-28 21:41:05	2006-09-28 22:50:00
247	136	2006-09-28 21:00:00	2006-09-28 22:50:00
247	257	2006-09-28 21:38:41	2006-09-28 22:50:00
247	39	2006-09-28 21:00:00	2006-09-28 22:50:00
247	170	2006-09-28 21:00:00	2006-09-28 22:50:00
247	40	2006-09-28 21:00:00	2006-09-28 22:50:00
247	41	2006-09-28 21:00:00	2006-09-28 22:50:00
247	43	2006-09-28 21:00:00	2006-09-28 22:50:00
247	259	2006-09-28 21:00:00	2006-09-28 22:50:00
247	44	2006-09-28 21:10:03	2006-09-28 21:11:55
247	142	2006-09-28 22:49:27	2006-09-28 22:50:00
247	106	2006-09-28 21:08:25	2006-09-28 22:50:00
247	48	2006-09-28 21:00:00	2006-09-28 22:50:00
247	100	2006-09-28 21:00:00	2006-09-28 22:50:00
247	103	2006-09-28 21:00:00	2006-09-28 22:50:00
247	51	2006-09-28 21:00:00	2006-09-28 22:50:00
247	222	2006-09-28 21:32:31	2006-09-28 22:50:00
247	52	2006-09-28 21:00:00	2006-09-28 22:50:00
247	148	2006-09-28 21:00:00	2006-09-28 22:50:00
247	233	2006-09-28 21:00:00	2006-09-28 22:50:00
247	116	2006-09-28 21:00:00	2006-09-28 22:50:00
247	171	2006-09-28 21:00:00	2006-09-28 22:50:00
247	167	2006-09-28 21:00:00	2006-09-28 22:50:00
247	57	2006-09-28 21:00:00	2006-09-28 22:50:00
247	153	2006-09-28 21:00:00	2006-09-28 22:50:00
247	60	2006-09-28 21:00:00	2006-09-28 22:50:00
252	284	2006-10-02 21:00:00	2006-10-02 23:45:00
252	135	2006-10-02 21:00:00	2006-10-02 23:45:00
252	275	2006-10-02 21:46:02	2006-10-02 23:45:00
252	90	2006-10-02 21:00:00	2006-10-02 23:45:00
252	235	2006-10-02 21:00:00	2006-10-02 23:29:53
252	217	2006-10-02 21:00:00	2006-10-02 23:45:00
252	123	2006-10-02 21:00:00	2006-10-02 23:45:00
252	238	2006-10-02 21:04:01	2006-10-02 21:05:04
252	295	2006-10-02 21:11:59	2006-10-02 23:45:00
252	26	2006-10-02 21:00:00	2006-10-02 23:45:00
252	98	2006-10-02 21:04:47	2006-10-02 23:45:00
252	245	2006-10-02 22:54:08	2006-10-02 22:55:46
252	31	2006-10-02 21:00:00	2006-10-02 23:45:00
252	154	2006-10-02 21:00:00	2006-10-02 23:45:00
252	285	2006-10-02 21:04:56	2006-10-02 23:45:00
252	234	2006-10-02 21:00:00	2006-10-02 23:45:00
252	257	2006-10-02 21:00:00	2006-10-02 23:45:00
252	150	2006-10-02 21:00:00	2006-10-02 23:45:00
252	155	2006-10-02 21:00:00	2006-10-02 23:45:00
252	170	2006-10-02 21:22:30	2006-10-02 23:45:00
252	42	2006-10-02 21:00:00	2006-10-02 23:45:00
252	259	2006-10-02 21:00:00	2006-10-02 23:45:00
252	270	2006-10-02 21:00:00	2006-10-02 23:45:00
252	44	2006-10-02 21:00:00	2006-10-02 23:45:00
252	297	2006-10-02 21:00:00	2006-10-02 21:05:54
252	106	2006-10-02 21:06:39	2006-10-02 23:45:00
252	221	2006-10-02 21:00:00	2006-10-02 23:45:00
252	114	2006-10-02 21:00:00	2006-10-02 23:45:00
252	51	2006-10-02 22:36:36	2006-10-02 23:45:00
252	188	2006-10-02 21:00:00	2006-10-02 22:32:50
252	222	2006-10-02 21:00:00	2006-10-02 23:45:00
252	52	2006-10-02 21:12:30	2006-10-02 23:45:00
252	223	2006-10-02 21:00:00	2006-10-02 23:45:00
252	148	2006-10-02 22:54:59	2006-10-02 23:45:00
252	308	2006-10-02 21:00:00	2006-10-02 23:45:00
252	315	2006-10-02 21:00:00	2006-10-02 23:45:00
252	75	2006-10-02 21:06:33	2006-10-02 23:45:00
252	54	2006-10-02 21:00:00	2006-10-02 23:45:00
252	89	2006-10-02 21:00:00	2006-10-02 23:45:00
252	212	2006-10-02 21:00:00	2006-10-02 22:54:14
252	251	2006-10-02 21:00:00	2006-10-02 23:45:00
252	153	2006-10-02 21:00:00	2006-10-02 23:45:00
252	282	2006-10-02 21:00:00	2006-10-02 23:45:00
252	283	2006-10-02 21:00:00	2006-10-02 23:45:00
252	277	2006-10-02 21:00:00	2006-10-02 23:45:00
251	1	2006-10-01 19:30:00	2006-10-01 22:00:00
251	2	2006-10-01 19:30:00	2006-10-01 22:00:00
251	4	2006-10-01 19:30:00	2006-10-01 22:00:00
251	5	2006-10-01 19:30:00	2006-10-01 22:00:00
251	135	2006-10-01 19:30:00	2006-10-01 22:00:00
251	90	2006-10-01 19:30:00	2006-10-01 22:00:00
251	15	2006-10-01 19:30:00	2006-10-01 22:00:00
251	16	2006-10-01 19:30:00	2006-10-01 22:00:00
251	21	2006-10-01 19:30:00	2006-10-01 22:00:00
251	157	2006-10-01 19:30:00	2006-10-01 22:00:00
251	230	2006-10-01 19:30:00	2006-10-01 22:00:00
251	27	2006-10-01 19:30:00	2006-10-01 22:00:00
251	28	2006-10-01 19:30:00	2006-10-01 22:00:00
251	232	2006-10-01 19:30:00	2006-10-01 22:00:00
251	29	2006-10-01 19:30:00	2006-10-01 22:00:00
251	30	2006-10-01 19:30:00	2006-10-01 20:25:17
251	31	2006-10-01 19:30:00	2006-10-01 22:00:00
251	32	2006-10-01 19:30:00	2006-10-01 22:00:00
251	33	2006-10-01 19:30:00	2006-10-01 22:00:00
251	136	2006-10-01 19:33:09	2006-10-01 22:00:00
251	257	2006-10-01 19:30:00	2006-10-01 22:00:00
251	155	2006-10-01 20:28:47	2006-10-01 22:00:00
251	39	2006-10-01 19:30:00	2006-10-01 22:00:00
251	40	2006-10-01 19:30:00	2006-10-01 21:26:45
251	41	2006-10-01 19:30:00	2006-10-01 22:00:00
251	43	2006-10-01 19:43:15	2006-10-01 22:00:00
251	259	2006-10-01 19:30:00	2006-10-01 22:00:00
251	45	2006-10-01 19:30:00	2006-10-01 22:00:00
251	142	2006-10-01 19:30:00	2006-10-01 22:00:00
251	50	2006-10-01 19:44:43	2006-10-01 22:00:00
251	100	2006-10-01 19:30:00	2006-10-01 22:00:00
251	51	2006-10-01 19:30:00	2006-10-01 22:00:00
251	222	2006-10-01 19:30:00	2006-10-01 22:00:00
251	52	2006-10-01 21:29:44	2006-10-01 22:00:00
251	233	2006-10-01 19:30:00	2006-10-01 22:00:00
251	132	2006-10-01 19:31:50	2006-10-01 19:44:19
251	116	2006-10-01 19:30:00	2006-10-01 22:00:00
251	171	2006-10-01 19:30:00	2006-10-01 22:00:00
251	167	2006-10-01 19:30:00	2006-10-01 22:00:00
251	118	2006-10-01 19:30:00	2006-10-01 22:00:00
251	57	2006-10-01 19:30:00	2006-10-01 22:00:00
251	251	2006-10-01 19:30:00	2006-10-01 22:00:00
251	153	2006-10-01 19:30:00	2006-10-01 19:43:04
251	60	2006-10-01 19:30:00	2006-10-01 22:00:00
254	1	2006-10-03 21:00:00	2006-10-04 00:30:00
254	284	2006-10-04 00:15:23	2006-10-04 00:30:00
254	2	2006-10-03 21:00:00	2006-10-03 22:59:20
254	4	2006-10-03 21:00:00	2006-10-04 00:30:00
254	5	2006-10-03 21:00:00	2006-10-04 00:30:00
254	135	2006-10-03 21:00:00	2006-10-04 00:30:00
254	8	2006-10-03 21:00:00	2006-10-04 00:30:00
254	90	2006-10-03 21:00:00	2006-10-04 00:30:00
254	15	2006-10-03 21:00:00	2006-10-04 00:30:00
254	16	2006-10-03 21:00:00	2006-10-03 22:58:05
254	19	2006-10-03 21:00:00	2006-10-04 00:30:00
254	21	2006-10-03 21:00:00	2006-10-04 00:30:00
254	23	2006-10-03 21:00:00	2006-10-04 00:30:00
254	157	2006-10-03 21:00:00	2006-10-04 00:03:22
254	230	2006-10-03 22:58:09	2006-10-04 00:30:00
254	27	2006-10-03 21:00:00	2006-10-04 00:30:00
254	28	2006-10-03 21:00:00	2006-10-04 00:30:00
254	232	2006-10-03 21:00:00	2006-10-04 00:30:00
254	29	2006-10-03 22:55:18	2006-10-04 00:30:00
254	30	2006-10-03 21:00:00	2006-10-04 00:30:00
254	31	2006-10-03 21:00:00	2006-10-04 00:30:00
254	32	2006-10-03 21:00:00	2006-10-04 00:30:00
254	154	2006-10-03 23:00:11	2006-10-04 00:30:00
254	136	2006-10-03 21:00:00	2006-10-04 00:02:32
254	257	2006-10-04 00:02:14	2006-10-04 00:30:00
254	39	2006-10-03 21:00:00	2006-10-03 22:59:25
254	40	2006-10-03 21:00:00	2006-10-04 00:30:00
254	41	2006-10-03 21:00:00	2006-10-04 00:30:00
254	43	2006-10-03 21:00:00	2006-10-04 00:30:00
254	259	2006-10-03 21:00:00	2006-10-04 00:30:00
254	270	2006-10-03 21:00:00	2006-10-04 00:30:00
254	45	2006-10-03 21:17:19	2006-10-04 00:30:00
254	142	2006-10-03 21:00:00	2006-10-04 00:30:00
254	50	2006-10-03 21:00:00	2006-10-04 00:30:00
254	100	2006-10-03 21:00:00	2006-10-04 00:02:03
254	103	2006-10-03 21:00:00	2006-10-04 00:30:00
254	51	2006-10-03 21:00:00	2006-10-04 00:30:00
254	222	2006-10-03 23:12:33	2006-10-04 00:30:00
254	233	2006-10-03 21:00:00	2006-10-04 00:30:00
254	116	2006-10-03 21:00:00	2006-10-04 00:30:00
254	171	2006-10-03 21:00:00	2006-10-04 00:30:00
254	160	2006-10-03 21:00:00	2006-10-03 21:16:16
254	55	2006-10-03 21:00:00	2006-10-04 00:30:00
254	57	2006-10-03 21:00:00	2006-10-04 00:30:00
254	251	2006-10-03 21:00:00	2006-10-03 22:50:42
254	153	2006-10-03 21:00:00	2006-10-04 00:30:00
254	60	2006-10-03 21:00:00	2006-10-04 00:30:00
258	301	2006-10-07 20:40:00	2006-10-08 00:00:00
258	284	2006-10-07 20:40:00	2006-10-08 00:00:00
258	4	2006-10-07 22:28:38	2006-10-07 23:05:04
258	189	2006-10-07 20:40:00	2006-10-08 00:00:00
258	135	2006-10-07 20:40:00	2006-10-08 00:00:00
258	287	2006-10-07 20:40:00	2006-10-08 00:00:00
258	275	2006-10-07 20:40:00	2006-10-08 00:00:00
258	90	2006-10-07 20:40:00	2006-10-08 00:00:00
258	322	2006-10-07 20:40:06	2006-10-08 00:00:00
258	235	2006-10-07 20:40:00	2006-10-08 00:00:00
258	217	2006-10-07 20:40:00	2006-10-08 00:00:00
258	123	2006-10-07 20:40:00	2006-10-08 00:00:00
258	238	2006-10-07 20:40:00	2006-10-08 00:00:00
258	280	2006-10-07 20:40:00	2006-10-08 00:00:00
258	26	2006-10-07 20:40:00	2006-10-08 00:00:00
258	230	2006-10-07 20:40:00	2006-10-07 21:54:18
258	98	2006-10-07 20:40:00	2006-10-07 22:27:54
258	274	2006-10-07 22:02:06	2006-10-08 00:00:00
258	299	2006-10-07 20:40:00	2006-10-08 00:00:00
258	119	2006-10-07 20:40:00	2006-10-08 00:00:00
258	279	2006-10-07 20:40:00	2006-10-08 00:00:00
258	136	2006-10-07 20:40:00	2006-10-07 23:05:25
258	234	2006-10-07 20:40:00	2006-10-08 00:00:00
258	257	2006-10-07 20:40:00	2006-10-08 00:00:00
258	150	2006-10-07 20:40:00	2006-10-08 00:00:00
258	84	2006-10-07 20:40:00	2006-10-08 00:00:00
258	170	2006-10-07 20:40:00	2006-10-08 00:00:00
258	323	2006-10-07 20:40:00	2006-10-08 00:00:00
258	259	2006-10-07 20:40:00	2006-10-07 23:05:20
258	317	2006-10-07 20:40:00	2006-10-08 00:00:00
258	106	2006-10-07 20:46:36	2006-10-08 00:00:00
258	221	2006-10-07 20:40:00	2006-10-08 00:00:00
258	103	2006-10-07 20:40:00	2006-10-08 00:00:00
258	188	2006-10-07 20:40:00	2006-10-08 00:00:00
258	222	2006-10-07 20:40:09	2006-10-08 00:00:00
258	267	2006-10-07 20:40:00	2006-10-08 00:00:00
258	148	2006-10-07 20:40:00	2006-10-08 00:00:00
258	132	2006-10-07 20:40:00	2006-10-08 00:00:00
258	75	2006-10-07 20:40:00	2006-10-08 00:00:00
258	171	2006-10-07 20:40:00	2006-10-08 00:00:00
258	68	2006-10-07 20:40:00	2006-10-08 00:00:00
258	89	2006-10-07 22:07:26	2006-10-08 00:00:00
258	212	2006-10-07 20:40:00	2006-10-08 00:00:00
258	57	2006-10-07 23:07:43	2006-10-08 00:00:00
258	251	2006-10-07 20:40:00	2006-10-08 00:00:00
258	153	2006-10-07 22:33:36	2006-10-08 00:00:00
258	56	2006-10-07 20:40:00	2006-10-08 00:00:00
258	59	2006-10-07 20:40:00	2006-10-08 00:00:00
258	277	2006-10-07 20:40:00	2006-10-08 00:00:00
261	1	2006-10-10 21:00:00	2006-10-11 00:25:00
261	284	2006-10-10 21:00:00	2006-10-11 00:25:00
261	2	2006-10-10 22:08:19	2006-10-11 00:25:00
261	5	2006-10-10 21:00:00	2006-10-11 00:25:00
261	135	2006-10-10 21:00:00	2006-10-11 00:25:00
261	8	2006-10-10 21:00:00	2006-10-11 00:25:00
261	175	2006-10-10 21:00:00	2006-10-11 00:25:00
261	90	2006-10-10 21:00:00	2006-10-11 00:25:00
261	15	2006-10-10 21:00:00	2006-10-11 00:25:00
261	19	2006-10-10 23:12:41	2006-10-11 00:25:00
261	21	2006-10-10 21:00:00	2006-10-11 00:25:00
261	157	2006-10-10 21:00:18	2006-10-11 00:25:00
261	27	2006-10-10 21:00:00	2006-10-11 00:25:00
261	28	2006-10-10 21:00:00	2006-10-11 00:25:00
260	301	2006-10-09 21:00:00	2006-10-09 23:35:00
260	284	2006-10-09 21:00:00	2006-10-09 23:35:00
260	206	2006-10-09 22:51:31	2006-10-09 23:35:00
260	135	2006-10-09 21:00:00	2006-10-09 23:35:00
260	90	2006-10-09 21:00:00	2006-10-09 23:35:00
260	235	2006-10-09 21:00:00	2006-10-09 23:35:00
260	217	2006-10-09 21:00:00	2006-10-09 23:35:00
259	257	2006-10-08 19:30:00	2006-10-08 22:34:47
259	300	2006-10-08 19:30:00	2006-10-08 20:12:18
260	123	2006-10-09 21:00:00	2006-10-09 23:35:00
260	280	2006-10-09 21:00:00	2006-10-09 23:35:00
260	98	2006-10-09 21:00:00	2006-10-09 23:35:00
260	164	2006-10-09 21:00:00	2006-10-09 22:14:33
260	299	2006-10-09 21:00:00	2006-10-09 23:35:00
260	119	2006-10-09 21:00:00	2006-10-09 23:35:00
260	154	2006-10-09 21:00:00	2006-10-09 23:35:00
260	285	2006-10-09 21:00:00	2006-10-09 23:35:00
260	136	2006-10-09 21:00:00	2006-10-09 23:35:00
260	234	2006-10-09 21:00:00	2006-10-09 23:35:00
259	222	2006-10-08 19:30:00	2006-10-08 21:24:03
260	257	2006-10-09 21:00:00	2006-10-09 23:35:00
260	150	2006-10-09 21:00:00	2006-10-09 23:35:00
260	170	2006-10-09 21:00:00	2006-10-09 23:35:00
260	42	2006-10-09 21:00:00	2006-10-09 23:35:00
260	259	2006-10-09 21:00:00	2006-10-09 23:35:00
260	317	2006-10-09 21:05:02	2006-10-09 23:35:00
259	55	2006-10-08 19:30:00	2006-10-08 21:22:43
260	270	2006-10-09 21:00:00	2006-10-09 23:35:00
260	44	2006-10-09 21:00:00	2006-10-09 23:35:00
259	282	2006-10-08 19:30:00	2006-10-08 21:21:01
260	106	2006-10-09 21:00:00	2006-10-09 23:35:00
259	1	2006-10-08 19:30:00	2006-10-08 23:00:00
259	2	2006-10-08 21:25:30	2006-10-08 23:00:00
259	8	2006-10-08 19:47:52	2006-10-08 23:00:00
259	15	2006-10-08 19:30:00	2006-10-08 23:00:00
259	16	2006-10-08 19:30:00	2006-10-08 23:00:00
259	19	2006-10-08 19:30:00	2006-10-08 23:00:00
259	21	2006-10-08 19:30:00	2006-10-08 23:00:00
259	26	2006-10-08 21:37:42	2006-10-08 23:00:00
259	28	2006-10-08 19:30:00	2006-10-08 23:00:00
259	29	2006-10-08 19:30:00	2006-10-08 23:00:00
259	30	2006-10-08 19:30:00	2006-10-08 23:00:00
259	32	2006-10-08 19:30:00	2006-10-08 23:00:00
259	33	2006-10-08 19:30:00	2006-10-08 23:00:00
259	39	2006-10-08 19:30:00	2006-10-08 23:00:00
259	41	2006-10-08 19:30:00	2006-10-08 23:00:00
259	45	2006-10-08 19:48:20	2006-10-08 23:00:00
259	50	2006-10-08 19:30:00	2006-10-08 23:00:00
259	51	2006-10-08 19:30:00	2006-10-08 23:00:00
259	52	2006-10-08 19:30:00	2006-10-08 23:00:00
259	53	2006-10-08 22:36:57	2006-10-08 23:00:00
259	57	2006-10-08 19:30:00	2006-10-08 23:00:00
259	60	2006-10-08 19:30:00	2006-10-08 23:00:00
259	90	2006-10-08 19:30:00	2006-10-08 23:00:00
259	100	2006-10-08 19:30:00	2006-10-08 23:00:00
259	103	2006-10-08 19:33:14	2006-10-08 23:00:00
259	116	2006-10-08 19:30:00	2006-10-08 23:00:00
259	135	2006-10-08 19:34:38	2006-10-08 23:00:00
259	136	2006-10-08 19:30:00	2006-10-08 23:00:00
259	142	2006-10-08 19:30:00	2006-10-08 23:00:00
259	148	2006-10-08 19:30:00	2006-10-08 23:00:00
259	153	2006-10-08 19:30:00	2006-10-08 23:00:00
259	175	2006-10-08 19:30:35	2006-10-08 23:00:00
259	230	2006-10-08 19:33:47	2006-10-08 23:00:00
259	232	2006-10-08 19:30:00	2006-10-08 23:00:00
259	233	2006-10-08 19:30:00	2006-10-08 23:00:00
259	234	2006-10-08 19:30:00	2006-10-08 23:00:00
259	259	2006-10-08 19:30:00	2006-10-08 23:00:00
259	270	2006-10-08 19:30:00	2006-10-08 23:00:00
259	284	2006-10-08 19:30:00	2006-10-08 23:00:00
259	315	2006-10-08 19:30:00	2006-10-08 23:00:00
255	1	2006-10-05 21:00:00	2006-10-05 23:20:00
255	301	2006-10-05 21:00:00	2006-10-05 23:20:00
255	284	2006-10-05 21:00:00	2006-10-05 23:20:00
255	2	2006-10-05 22:27:10	2006-10-05 23:20:00
255	206	2006-10-05 23:08:21	2006-10-05 23:20:00
255	5	2006-10-05 21:00:00	2006-10-05 23:20:00
255	135	2006-10-05 21:00:00	2006-10-05 22:27:02
255	287	2006-10-05 21:10:18	2006-10-05 23:07:50
255	8	2006-10-05 21:00:00	2006-10-05 23:20:00
255	322	2006-10-05 21:09:43	2006-10-05 23:20:00
255	15	2006-10-05 21:00:00	2006-10-05 23:20:00
255	16	2006-10-05 21:00:00	2006-10-05 23:20:00
255	19	2006-10-05 21:00:00	2006-10-05 23:20:00
255	21	2006-10-05 21:00:00	2006-10-05 23:20:00
255	23	2006-10-05 21:00:00	2006-10-05 23:20:00
255	26	2006-10-05 21:29:09	2006-10-05 23:20:00
255	27	2006-10-05 21:00:00	2006-10-05 23:20:00
255	28	2006-10-05 21:00:00	2006-10-05 23:20:00
255	232	2006-10-05 21:00:00	2006-10-05 23:20:00
255	29	2006-10-05 22:57:55	2006-10-05 23:20:00
255	30	2006-10-05 21:00:00	2006-10-05 23:20:00
255	31	2006-10-05 21:29:22	2006-10-05 23:20:00
255	32	2006-10-05 21:00:00	2006-10-05 21:17:28
255	33	2006-10-05 21:00:00	2006-10-05 23:20:00
255	279	2006-10-05 21:01:36	2006-10-05 23:20:00
255	136	2006-10-05 21:00:00	2006-10-05 23:20:00
255	150	2006-10-05 21:00:00	2006-10-05 23:20:00
255	39	2006-10-05 21:00:00	2006-10-05 23:20:00
255	40	2006-10-05 21:00:00	2006-10-05 23:20:00
255	41	2006-10-05 21:00:00	2006-10-05 23:20:00
255	43	2006-10-05 21:00:00	2006-10-05 23:20:00
255	259	2006-10-05 22:08:12	2006-10-05 23:20:00
255	62	2006-10-05 21:00:00	2006-10-05 22:56:32
255	270	2006-10-05 21:26:04	2006-10-05 23:20:00
255	142	2006-10-05 21:00:00	2006-10-05 23:20:00
255	48	2006-10-05 21:00:00	2006-10-05 23:20:00
255	50	2006-10-05 21:00:00	2006-10-05 23:20:00
255	100	2006-10-05 21:00:00	2006-10-05 23:20:00
255	103	2006-10-05 21:00:00	2006-10-05 21:05:51
255	51	2006-10-05 23:01:10	2006-10-05 23:20:00
255	52	2006-10-05 21:00:00	2006-10-05 23:20:00
255	148	2006-10-05 21:27:03	2006-10-05 23:20:00
255	233	2006-10-05 21:00:00	2006-10-05 23:20:00
255	116	2006-10-05 21:00:00	2006-10-05 23:20:00
255	160	2006-10-05 21:00:00	2006-10-05 22:06:34
255	89	2006-10-05 21:00:00	2006-10-05 23:20:00
255	55	2006-10-05 21:00:00	2006-10-05 23:20:00
255	57	2006-10-05 21:00:00	2006-10-05 23:20:00
255	153	2006-10-05 21:00:00	2006-10-05 23:20:00
255	60	2006-10-05 21:00:00	2006-10-05 23:01:05
257	1	2006-10-07 19:40:00	2006-10-07 20:10:00
257	301	2006-10-07 19:40:00	2006-10-07 20:10:00
257	284	2006-10-07 19:40:00	2006-10-07 20:10:00
257	135	2006-10-07 19:40:00	2006-10-07 20:10:00
257	275	2006-10-07 19:40:00	2006-10-07 20:10:00
257	90	2006-10-07 19:40:00	2006-10-07 20:10:00
257	235	2006-10-07 19:40:00	2006-10-07 20:10:00
257	123	2006-10-07 19:40:00	2006-10-07 20:10:00
257	21	2006-10-07 19:40:00	2006-10-07 20:09:58
257	230	2006-10-07 19:40:00	2006-10-07 20:10:00
257	28	2006-10-07 19:40:00	2006-10-07 20:10:00
257	98	2006-10-07 19:40:00	2006-10-07 20:10:00
257	299	2006-10-07 19:40:00	2006-10-07 20:10:00
257	119	2006-10-07 19:40:00	2006-10-07 20:10:00
257	154	2006-10-07 19:40:00	2006-10-07 20:10:00
257	136	2006-10-07 19:40:00	2006-10-07 20:09:53
257	234	2006-10-07 19:40:00	2006-10-07 20:10:00
257	257	2006-10-07 19:40:00	2006-10-07 20:10:00
257	150	2006-10-07 19:40:00	2006-10-07 20:10:00
257	84	2006-10-07 19:40:00	2006-10-07 20:10:00
257	155	2006-10-07 19:40:00	2006-10-07 20:10:00
257	170	2006-10-07 19:40:00	2006-10-07 20:10:00
257	259	2006-10-07 19:40:00	2006-10-07 20:10:00
257	270	2006-10-07 19:40:00	2006-10-07 20:10:00
257	44	2006-10-07 19:40:00	2006-10-07 20:10:00
257	45	2006-10-07 19:40:00	2006-10-07 20:09:55
257	50	2006-10-07 19:40:00	2006-10-07 20:10:00
257	103	2006-10-07 19:40:00	2006-10-07 20:09:55
257	188	2006-10-07 19:40:00	2006-10-07 20:10:00
257	148	2006-10-07 19:40:00	2006-10-07 20:10:00
257	132	2006-10-07 19:40:00	2006-10-07 20:10:00
257	116	2006-10-07 19:40:00	2006-10-07 20:09:55
257	315	2006-10-07 19:40:00	2006-10-07 20:09:24
257	75	2006-10-07 19:40:00	2006-10-07 20:10:00
257	171	2006-10-07 19:40:00	2006-10-07 20:10:00
257	109	2006-10-07 19:40:00	2006-10-07 20:09:41
257	89	2006-10-07 19:40:00	2006-10-07 20:10:00
257	167	2006-10-07 19:40:00	2006-10-07 20:08:59
257	55	2006-10-07 19:40:00	2006-10-07 20:09:54
257	251	2006-10-07 19:40:00	2006-10-07 20:10:00
257	56	2006-10-07 19:40:00	2006-10-07 20:10:00
257	59	2006-10-07 19:40:00	2006-10-07 20:10:00
257	60	2006-10-07 19:40:00	2006-10-07 20:09:51
256	284	2006-10-07 11:00:00	2006-10-07 14:45:00
256	5	2006-10-07 11:00:00	2006-10-07 14:45:00
256	8	2006-10-07 14:20:18	2006-10-07 14:45:00
256	275	2006-10-07 12:44:24	2006-10-07 14:43:31
256	90	2006-10-07 11:00:00	2006-10-07 14:45:00
256	19	2006-10-07 11:00:00	2006-10-07 14:45:00
256	21	2006-10-07 11:00:00	2006-10-07 14:24:17
256	157	2006-10-07 11:00:00	2006-10-07 14:44:46
256	30	2006-10-07 11:00:00	2006-10-07 14:45:00
256	164	2006-10-07 11:00:00	2006-10-07 12:41:44
256	32	2006-10-07 11:13:40	2006-10-07 14:45:00
256	33	2006-10-07 12:47:58	2006-10-07 14:45:00
256	154	2006-10-07 11:00:00	2006-10-07 14:45:00
256	257	2006-10-07 11:00:00	2006-10-07 14:45:00
256	111	2006-10-07 11:00:00	2006-10-07 14:45:00
256	319	2006-10-07 11:00:00	2006-10-07 14:45:00
256	259	2006-10-07 11:00:00	2006-10-07 14:45:00
256	317	2006-10-07 11:03:49	2006-10-07 14:45:00
256	142	2006-10-07 11:00:00	2006-10-07 14:45:00
256	296	2006-10-07 11:00:00	2006-10-07 12:38:42
256	221	2006-10-07 11:00:00	2006-10-07 14:21:24
256	307	2006-10-07 11:00:00	2006-10-07 14:18:48
256	89	2006-10-07 11:00:00	2006-10-07 14:45:00
256	55	2006-10-07 11:00:00	2006-10-07 14:45:00
256	251	2006-10-07 14:23:29	2006-10-07 14:45:00
256	282	2006-10-07 11:00:00	2006-10-07 14:44:47
260	188	2006-10-09 21:00:00	2006-10-09 22:41:48
260	222	2006-10-09 21:00:00	2006-10-09 23:35:00
260	52	2006-10-09 21:00:00	2006-10-09 23:35:00
260	223	2006-10-09 21:00:00	2006-10-09 23:35:00
260	148	2006-10-09 21:00:00	2006-10-09 23:35:00
260	307	2006-10-09 21:00:00	2006-10-09 21:06:26
260	132	2006-10-09 21:00:00	2006-10-09 23:35:00
260	308	2006-10-09 21:00:00	2006-10-09 23:35:00
260	54	2006-10-09 21:00:00	2006-10-09 23:35:00
260	89	2006-10-09 21:00:00	2006-10-09 23:35:00
260	167	2006-10-09 21:00:00	2006-10-09 23:35:00
260	212	2006-10-09 21:05:55	2006-10-09 22:41:55
260	251	2006-10-09 21:00:00	2006-10-09 23:35:00
260	153	2006-10-09 21:00:00	2006-10-09 23:35:00
260	56	2006-10-09 21:00:00	2006-10-09 23:35:00
260	282	2006-10-09 21:00:00	2006-10-09 23:35:00
260	59	2006-10-09 22:14:39	2006-10-09 23:35:00
260	277	2006-10-09 21:08:14	2006-10-09 23:35:00
261	232	2006-10-10 21:00:00	2006-10-11 00:25:00
261	29	2006-10-10 21:00:00	2006-10-11 00:25:00
261	30	2006-10-10 21:00:00	2006-10-11 00:25:00
261	32	2006-10-10 21:00:00	2006-10-11 00:25:00
261	33	2006-10-10 21:00:00	2006-10-11 00:25:00
261	34	2006-10-10 21:00:00	2006-10-11 00:25:00
261	136	2006-10-10 21:00:00	2006-10-11 00:25:00
261	234	2006-10-10 21:00:00	2006-10-11 00:25:00
261	257	2006-10-10 21:00:00	2006-10-11 00:25:00
261	39	2006-10-10 21:00:00	2006-10-11 00:07:04
261	40	2006-10-10 21:00:00	2006-10-11 00:25:00
261	41	2006-10-10 21:00:00	2006-10-11 00:25:00
261	259	2006-10-10 21:00:00	2006-10-11 00:25:00
261	270	2006-10-10 21:00:00	2006-10-11 00:25:00
261	45	2006-10-10 21:00:00	2006-10-11 00:25:00
261	142	2006-10-10 21:00:00	2006-10-11 00:25:00
261	50	2006-10-10 21:00:00	2006-10-11 00:25:00
261	100	2006-10-10 21:00:00	2006-10-11 00:25:00
261	103	2006-10-10 21:00:00	2006-10-11 00:25:00
261	51	2006-10-10 21:00:00	2006-10-11 00:25:00
261	222	2006-10-10 21:00:00	2006-10-11 00:25:00
261	52	2006-10-10 21:00:00	2006-10-11 00:25:00
261	148	2006-10-10 21:00:00	2006-10-11 00:25:00
261	233	2006-10-10 21:00:00	2006-10-11 00:25:00
261	116	2006-10-10 21:00:00	2006-10-11 00:25:00
261	75	2006-10-10 21:00:00	2006-10-10 22:02:44
261	160	2006-10-10 21:00:00	2006-10-11 00:25:00
261	57	2006-10-10 21:00:00	2006-10-11 00:25:00
261	153	2006-10-10 21:00:00	2006-10-11 00:25:00
261	60	2006-10-10 21:00:00	2006-10-11 00:25:00
262	1	2006-10-13 07:42:42	2006-10-13 07:42:43
262	2	2006-10-13 07:42:42	2006-10-13 07:42:43
262	5	2006-10-13 07:42:42	2006-10-13 07:42:43
262	135	2006-10-13 07:42:42	2006-10-13 07:42:43
262	8	2006-10-13 07:42:42	2006-10-13 07:42:43
262	318	2006-10-13 07:42:42	2006-10-13 07:42:43
262	15	2006-10-13 07:42:42	2006-10-13 07:42:43
262	325	2006-10-13 07:42:42	2006-10-13 07:42:43
262	23	2006-10-13 07:42:42	2006-10-13 07:42:43
262	157	2006-10-13 07:42:42	2006-10-13 07:42:43
262	26	2006-10-13 07:42:42	2006-10-13 07:42:43
262	27	2006-10-13 07:42:42	2006-10-13 07:42:43
262	213	2006-10-13 07:42:42	2006-10-13 07:42:43
262	28	2006-10-13 07:42:42	2006-10-13 07:42:43
262	232	2006-10-13 07:42:42	2006-10-13 07:42:43
262	30	2006-10-13 07:42:42	2006-10-13 07:42:43
262	136	2006-10-13 07:42:42	2006-10-13 07:42:43
262	234	2006-10-13 07:42:42	2006-10-13 07:42:43
262	111	2006-10-13 07:42:42	2006-10-13 07:42:43
262	40	2006-10-13 07:42:42	2006-10-13 07:42:43
262	41	2006-10-13 07:42:42	2006-10-13 07:42:43
262	259	2006-10-13 07:42:42	2006-10-13 07:42:43
262	62	2006-10-13 07:42:42	2006-10-13 07:42:43
262	270	2006-10-13 07:42:42	2006-10-13 07:42:43
262	48	2006-10-13 07:42:42	2006-10-13 07:42:43
262	50	2006-10-13 07:42:42	2006-10-13 07:42:43
262	100	2006-10-13 07:42:42	2006-10-13 07:42:43
262	52	2006-10-13 07:42:42	2006-10-13 07:42:43
262	148	2006-10-13 07:42:42	2006-10-13 07:42:43
262	307	2006-10-13 07:42:42	2006-10-13 07:42:43
262	233	2006-10-13 07:42:42	2006-10-13 07:42:43
262	116	2006-10-13 07:42:42	2006-10-13 07:42:43
262	160	2006-10-13 07:42:42	2006-10-13 07:42:43
262	55	2006-10-13 07:42:42	2006-10-13 07:42:43
262	153	2006-10-13 07:42:42	2006-10-13 07:42:43
262	60	2006-10-13 07:42:42	2006-10-13 07:42:43
263	284	2006-10-14 11:00:00	2006-10-14 16:20:00
263	2	2006-10-14 14:45:06	2006-10-14 16:20:00
263	8	2006-10-14 14:14:22	2006-10-14 16:20:00
263	90	2006-10-14 11:00:00	2006-10-14 16:20:00
263	235	2006-10-14 15:38:20	2006-10-14 16:20:00
263	123	2006-10-14 15:10:53	2006-10-14 16:20:00
263	280	2006-10-14 11:00:00	2006-10-14 16:20:00
263	157	2006-10-14 11:00:00	2006-10-14 14:48:30
263	27	2006-10-14 15:46:50	2006-10-14 16:20:00
263	213	2006-10-14 15:24:26	2006-10-14 16:20:00
263	245	2006-10-14 11:00:00	2006-10-14 13:02:20
263	164	2006-10-14 11:00:00	2006-10-14 12:58:30
263	285	2006-10-14 13:04:02	2006-10-14 15:05:33
263	234	2006-10-14 11:00:00	2006-10-14 16:20:00
263	35	2006-10-14 15:26:04	2006-10-14 16:20:00
263	286	2006-10-14 11:00:00	2006-10-14 15:33:16
263	111	2006-10-14 11:00:00	2006-10-14 15:41:32
263	40	2006-10-14 13:05:26	2006-10-14 15:05:37
263	259	2006-10-14 11:00:00	2006-10-14 16:20:00
263	326	2006-10-14 11:00:00	2006-10-14 15:16:11
263	100	2006-10-14 15:37:24	2006-10-14 15:37:56
263	229	2006-10-14 11:00:00	2006-10-14 16:20:00
263	267	2006-10-14 11:00:00	2006-10-14 14:44:48
263	307	2006-10-14 11:00:00	2006-10-14 14:14:50
263	116	2006-10-14 15:35:10	2006-10-14 16:20:00
263	109	2006-10-14 11:00:00	2006-10-14 15:06:01
263	160	2006-10-14 14:47:17	2006-10-14 15:05:10
263	240	2006-10-14 11:00:00	2006-10-14 16:20:00
263	89	2006-10-14 11:00:00	2006-10-14 16:20:00
263	55	2006-10-14 11:00:00	2006-10-14 15:27:03
263	251	2006-10-14 11:00:00	2006-10-14 16:20:00
263	282	2006-10-14 11:00:00	2006-10-14 15:48:45
263	231	2006-10-14 11:00:00	2006-10-14 16:20:00
264	301	2006-10-14 19:30:00	2006-10-14 20:10:00
264	284	2006-10-14 19:30:00	2006-10-14 20:10:00
264	175	2006-10-14 19:30:00	2006-10-14 20:10:00
264	275	2006-10-14 19:30:00	2006-10-14 20:10:00
264	90	2006-10-14 19:30:00	2006-10-14 20:10:00
264	235	2006-10-14 19:30:00	2006-10-14 20:10:00
264	13	2006-10-14 19:30:00	2006-10-14 20:10:00
264	123	2006-10-14 19:30:00	2006-10-14 20:10:00
264	18	2006-10-14 19:30:00	2006-10-14 20:10:00
264	21	2006-10-14 19:30:00	2006-10-14 20:10:00
264	280	2006-10-14 19:30:00	2006-10-14 20:10:00
264	157	2006-10-14 19:30:00	2006-10-14 20:10:00
264	27	2006-10-14 19:30:00	2006-10-14 20:10:00
264	28	2006-10-14 19:30:00	2006-10-14 20:10:00
264	98	2006-10-14 19:30:00	2006-10-14 20:10:00
264	274	2006-10-14 19:30:00	2006-10-14 20:10:00
264	299	2006-10-14 19:30:00	2006-10-14 20:10:00
264	119	2006-10-14 19:30:00	2006-10-14 20:10:00
264	154	2006-10-14 19:30:00	2006-10-14 20:10:00
264	285	2006-10-14 19:30:00	2006-10-14 20:10:00
264	234	2006-10-14 19:30:00	2006-10-14 20:10:00
264	150	2006-10-14 19:30:00	2006-10-14 20:10:00
264	84	2006-10-14 19:30:00	2006-10-14 20:10:00
264	155	2006-10-14 19:30:00	2006-10-14 20:10:00
264	170	2006-10-14 19:30:00	2006-10-14 20:10:00
264	202	2006-10-14 19:30:00	2006-10-14 20:10:00
264	319	2006-10-14 19:30:00	2006-10-14 20:10:00
264	259	2006-10-14 19:30:00	2006-10-14 20:10:00
264	270	2006-10-14 19:30:00	2006-10-14 20:10:00
264	44	2006-10-14 19:30:00	2006-10-14 20:10:00
264	188	2006-10-14 19:30:00	2006-10-14 20:10:00
264	222	2006-10-14 19:31:20	2006-10-14 20:10:00
264	223	2006-10-14 19:30:00	2006-10-14 20:10:00
264	116	2006-10-14 19:30:00	2006-10-14 20:10:00
264	308	2006-10-14 19:30:00	2006-10-14 20:10:00
264	75	2006-10-14 19:33:20	2006-10-14 20:10:00
264	109	2006-10-14 19:30:00	2006-10-14 20:10:00
264	316	2006-10-14 19:30:00	2006-10-14 20:10:00
264	167	2006-10-14 19:30:00	2006-10-14 20:10:00
264	118	2006-10-14 19:30:00	2006-10-14 20:10:00
264	55	2006-10-14 19:30:00	2006-10-14 20:10:00
264	153	2006-10-14 19:30:00	2006-10-14 20:10:00
265	301	2006-10-14 21:00:00	2006-10-15 01:15:00
265	284	2006-10-14 21:00:00	2006-10-15 01:15:00
265	4	2006-10-14 23:09:03	2006-10-14 23:44:55
265	200	2006-10-14 22:19:45	2006-10-14 23:51:32
265	90	2006-10-14 21:00:00	2006-10-15 01:15:00
265	235	2006-10-14 21:00:00	2006-10-15 01:15:00
265	13	2006-10-14 21:00:00	2006-10-15 01:15:00
265	318	2006-10-14 21:00:00	2006-10-14 22:19:02
265	123	2006-10-14 21:00:00	2006-10-14 23:48:18
265	244	2006-10-14 21:00:00	2006-10-15 01:15:00
265	161	2006-10-14 21:00:00	2006-10-15 00:09:07
265	26	2006-10-14 21:04:11	2006-10-14 23:46:45
265	98	2006-10-14 21:00:00	2006-10-15 01:15:00
265	274	2006-10-14 21:00:00	2006-10-15 00:55:47
265	164	2006-10-14 21:00:00	2006-10-15 01:15:00
265	299	2006-10-14 21:00:00	2006-10-15 01:15:00
265	119	2006-10-14 21:00:00	2006-10-15 01:15:00
265	154	2006-10-14 21:00:00	2006-10-15 01:15:00
265	285	2006-10-14 21:00:00	2006-10-14 23:07:35
265	136	2006-10-15 00:28:41	2006-10-15 01:15:00
265	234	2006-10-14 21:00:00	2006-10-15 01:15:00
265	257	2006-10-14 21:00:00	2006-10-14 22:35:35
265	150	2006-10-14 21:00:00	2006-10-15 01:15:00
265	84	2006-10-14 21:00:00	2006-10-15 01:15:00
265	155	2006-10-14 21:00:00	2006-10-15 01:15:00
265	170	2006-10-14 21:00:00	2006-10-15 00:31:36
265	320	2006-10-14 21:30:44	2006-10-15 01:15:00
265	202	2006-10-14 21:00:00	2006-10-15 01:15:00
265	259	2006-10-14 21:00:00	2006-10-15 01:15:00
265	270	2006-10-14 21:00:00	2006-10-15 01:15:00
265	44	2006-10-14 21:00:00	2006-10-15 01:15:00
265	297	2006-10-14 21:12:33	2006-10-15 01:15:00
265	106	2006-10-14 23:22:34	2006-10-14 23:46:20
265	188	2006-10-14 21:00:00	2006-10-15 01:15:00
265	327	2006-10-14 23:16:47	2006-10-15 01:15:00
265	223	2006-10-14 21:00:00	2006-10-15 01:15:00
265	267	2006-10-14 21:00:00	2006-10-15 01:15:00
265	308	2006-10-14 21:00:00	2006-10-15 01:15:00
265	75	2006-10-14 21:00:00	2006-10-15 01:15:00
265	152	2006-10-14 21:18:09	2006-10-15 01:15:00
265	316	2006-10-14 21:00:00	2006-10-15 00:44:55
265	167	2006-10-14 21:00:00	2006-10-15 01:15:00
265	118	2006-10-14 21:00:00	2006-10-15 01:15:00
265	328	2006-10-14 21:00:00	2006-10-15 01:15:00
265	153	2006-10-14 21:00:00	2006-10-15 01:15:00
265	56	2006-10-14 21:00:00	2006-10-15 01:15:00
265	282	2006-10-14 22:45:59	2006-10-15 01:15:00
265	59	2006-10-14 21:00:00	2006-10-15 01:15:00
265	277	2006-10-14 21:00:00	2006-10-15 00:47:38
265	329	2006-10-14 23:48:54	2006-10-15 01:15:00
266	1	2006-10-15 19:30:17	2006-10-15 20:10:00
266	2	2006-10-15 19:30:00	2006-10-15 20:10:00
266	97	2006-10-15 19:30:00	2006-10-15 20:10:00
266	4	2006-10-15 19:30:00	2006-10-15 20:10:00
266	206	2006-10-15 19:32:33	2006-10-15 20:10:00
266	8	2006-10-15 19:30:00	2006-10-15 20:10:00
266	90	2006-10-15 19:30:00	2006-10-15 20:10:00
266	318	2006-10-15 19:30:00	2006-10-15 20:10:00
266	15	2006-10-15 19:30:00	2006-10-15 20:10:00
266	16	2006-10-15 19:30:00	2006-10-15 20:10:00
266	19	2006-10-15 19:30:00	2006-10-15 20:10:00
266	21	2006-10-15 19:30:00	2006-10-15 20:10:00
266	27	2006-10-15 19:30:00	2006-10-15 20:10:00
266	28	2006-10-15 19:30:00	2006-10-15 20:10:00
266	232	2006-10-15 19:30:00	2006-10-15 20:10:00
266	29	2006-10-15 19:30:00	2006-10-15 20:10:00
266	30	2006-10-15 19:30:00	2006-10-15 20:10:00
266	32	2006-10-15 19:30:00	2006-10-15 20:10:00
266	33	2006-10-15 19:30:00	2006-10-15 20:10:00
266	136	2006-10-15 19:30:00	2006-10-15 20:10:00
266	257	2006-10-15 19:30:00	2006-10-15 20:10:00
266	39	2006-10-15 19:30:00	2006-10-15 20:10:00
266	43	2006-10-15 19:30:00	2006-10-15 20:10:00
266	259	2006-10-15 19:30:00	2006-10-15 19:31:21
266	270	2006-10-15 19:30:00	2006-10-15 20:10:00
266	45	2006-10-15 19:30:00	2006-10-15 20:10:00
266	142	2006-10-15 19:30:00	2006-10-15 20:10:00
266	50	2006-10-15 19:32:23	2006-10-15 20:10:00
266	100	2006-10-15 19:30:00	2006-10-15 20:10:00
266	51	2006-10-15 19:30:00	2006-10-15 20:10:00
266	222	2006-10-15 19:30:00	2006-10-15 20:10:00
266	52	2006-10-15 19:30:00	2006-10-15 20:10:00
266	148	2006-10-15 19:30:00	2006-10-15 20:10:00
266	233	2006-10-15 19:30:00	2006-10-15 20:10:00
266	132	2006-10-15 19:31:37	2006-10-15 20:10:00
266	116	2006-10-15 19:30:00	2006-10-15 20:10:00
266	167	2006-10-15 19:30:00	2006-10-15 20:10:00
266	55	2006-10-15 19:30:00	2006-10-15 20:10:00
266	57	2006-10-15 19:30:00	2006-10-15 20:10:00
266	282	2006-10-15 19:30:00	2006-10-15 20:10:00
266	60	2006-10-15 19:30:00	2006-10-15 20:10:00
268	1	2006-10-15 20:30:00	2006-10-15 22:50:00
268	284	2006-10-15 20:30:00	2006-10-15 22:50:00
268	2	2006-10-15 20:30:00	2006-10-15 22:09:25
268	4	2006-10-15 20:30:00	2006-10-15 22:50:00
268	206	2006-10-15 20:30:00	2006-10-15 22:50:00
268	5	2006-10-15 21:06:39	2006-10-15 22:50:00
268	8	2006-10-15 20:30:00	2006-10-15 22:50:00
268	90	2006-10-15 20:30:00	2006-10-15 22:50:00
268	318	2006-10-15 20:30:00	2006-10-15 22:08:15
268	15	2006-10-15 20:30:00	2006-10-15 22:50:00
268	123	2006-10-15 20:36:15	2006-10-15 22:50:00
268	19	2006-10-15 20:30:00	2006-10-15 22:50:00
268	21	2006-10-15 20:30:00	2006-10-15 22:50:00
268	27	2006-10-15 20:30:00	2006-10-15 22:50:00
268	213	2006-10-15 21:55:57	2006-10-15 22:50:00
268	28	2006-10-15 20:30:00	2006-10-15 22:50:00
268	30	2006-10-15 20:30:00	2006-10-15 22:50:00
268	31	2006-10-15 20:30:00	2006-10-15 22:50:00
268	32	2006-10-15 20:30:00	2006-10-15 21:01:52
268	33	2006-10-15 20:30:00	2006-10-15 22:50:00
268	279	2006-10-15 22:13:22	2006-10-15 22:50:00
268	136	2006-10-15 20:30:00	2006-10-15 22:50:00
268	257	2006-10-15 20:30:00	2006-10-15 22:50:00
268	39	2006-10-15 20:30:00	2006-10-15 22:50:00
268	40	2006-10-15 20:31:36	2006-10-15 22:50:00
268	43	2006-10-15 20:30:00	2006-10-15 22:50:00
268	270	2006-10-15 20:30:00	2006-10-15 22:50:00
268	45	2006-10-15 20:30:00	2006-10-15 22:50:00
268	142	2006-10-15 20:30:00	2006-10-15 22:50:00
268	326	2006-10-15 22:05:05	2006-10-15 22:50:00
268	50	2006-10-15 20:30:00	2006-10-15 22:50:00
268	100	2006-10-15 20:30:00	2006-10-15 22:50:00
268	51	2006-10-15 20:30:00	2006-10-15 22:50:00
268	222	2006-10-15 20:30:00	2006-10-15 22:45:00
268	52	2006-10-15 20:30:00	2006-10-15 22:50:00
268	148	2006-10-15 20:30:00	2006-10-15 22:50:00
268	233	2006-10-15 20:30:00	2006-10-15 21:55:28
268	132	2006-10-15 20:30:00	2006-10-15 22:50:00
268	116	2006-10-15 20:30:00	2006-10-15 22:50:00
268	308	2006-10-15 21:03:35	2006-10-15 22:50:00
268	160	2006-10-15 20:30:00	2006-10-15 22:41:33
268	167	2006-10-15 20:30:00	2006-10-15 22:08:11
268	55	2006-10-15 20:30:00	2006-10-15 22:50:00
268	57	2006-10-15 20:30:00	2006-10-15 22:50:00
268	282	2006-10-15 20:30:00	2006-10-15 20:34:22
268	60	2006-10-15 20:30:00	2006-10-15 22:50:00
270	284	2006-10-16 21:00:00	2006-10-17 01:00:00
270	4	2006-10-17 00:27:19	2006-10-17 00:28:57
270	200	2006-10-17 00:07:34	2006-10-17 01:00:00
270	90	2006-10-16 21:00:00	2006-10-17 01:00:00
270	235	2006-10-16 21:00:00	2006-10-16 23:07:59
270	13	2006-10-16 23:26:32	2006-10-17 01:00:00
270	217	2006-10-16 21:00:00	2006-10-17 01:00:00
270	318	2006-10-16 21:00:00	2006-10-17 00:03:36
270	123	2006-10-16 21:00:00	2006-10-17 01:00:00
270	325	2006-10-16 23:21:59	2006-10-17 01:00:00
270	238	2006-10-16 21:00:00	2006-10-17 01:00:00
270	23	2006-10-16 21:00:00	2006-10-17 00:02:42
270	280	2006-10-17 00:07:10	2006-10-17 01:00:00
270	299	2006-10-16 21:00:00	2006-10-17 01:00:00
270	34	2006-10-16 21:00:00	2006-10-17 01:00:00
270	119	2006-10-17 00:07:17	2006-10-17 01:00:00
270	154	2006-10-16 21:00:00	2006-10-17 01:00:00
270	279	2006-10-16 21:01:43	2006-10-17 01:00:00
270	285	2006-10-16 21:00:00	2006-10-17 01:00:00
270	234	2006-10-16 21:00:00	2006-10-17 01:00:00
270	150	2006-10-16 21:00:00	2006-10-17 01:00:00
270	155	2006-10-16 21:00:00	2006-10-17 01:00:00
270	170	2006-10-16 21:00:00	2006-10-17 01:00:00
270	202	2006-10-16 21:00:00	2006-10-17 01:00:00
270	42	2006-10-16 21:00:00	2006-10-17 01:00:00
270	259	2006-10-16 21:00:00	2006-10-17 00:03:50
270	270	2006-10-16 21:00:00	2006-10-17 01:00:00
270	44	2006-10-16 21:00:00	2006-10-17 01:00:00
270	106	2006-10-16 21:00:00	2006-10-17 01:00:00
270	114	2006-10-16 21:00:49	2006-10-17 01:00:00
270	188	2006-10-16 21:00:00	2006-10-17 00:00:40
270	222	2006-10-16 23:16:27	2006-10-17 01:00:00
270	52	2006-10-16 22:06:27	2006-10-17 00:03:10
270	223	2006-10-16 21:00:00	2006-10-17 01:00:00
270	148	2006-10-16 21:00:00	2006-10-17 01:00:00
270	115	2006-10-16 21:00:00	2006-10-16 22:06:20
270	132	2006-10-16 21:00:00	2006-10-17 01:00:00
270	116	2006-10-17 00:20:57	2006-10-17 01:00:00
270	315	2006-10-16 21:00:00	2006-10-17 01:00:00
270	109	2006-10-16 21:00:00	2006-10-17 01:00:00
270	152	2006-10-16 21:00:00	2006-10-17 01:00:00
270	89	2006-10-16 21:00:00	2006-10-17 00:24:52
270	76	2006-10-16 22:02:46	2006-10-17 01:00:00
270	167	2006-10-16 21:00:00	2006-10-16 23:17:01
270	118	2006-10-16 21:00:00	2006-10-17 01:00:00
270	328	2006-10-16 21:00:00	2006-10-17 01:00:00
270	251	2006-10-16 21:00:00	2006-10-16 22:59:35
270	153	2006-10-16 21:00:00	2006-10-17 01:00:00
270	56	2006-10-16 21:00:00	2006-10-17 01:00:00
270	282	2006-10-16 21:00:00	2006-10-17 01:00:00
270	332	2006-10-16 21:00:00	2006-10-17 01:00:00
270	59	2006-10-16 21:00:00	2006-10-17 01:00:00
270	329	2006-10-17 00:37:14	2006-10-17 01:00:00
271	1	2006-10-17 21:00:00	2006-10-18 01:00:00
271	284	2006-10-17 23:55:02	2006-10-18 01:00:00
271	97	2006-10-17 21:00:00	2006-10-18 01:00:00
271	4	2006-10-17 21:00:00	2006-10-18 01:00:00
271	206	2006-10-17 22:35:07	2006-10-18 01:00:00
271	5	2006-10-17 21:00:00	2006-10-18 01:00:00
271	135	2006-10-17 21:00:00	2006-10-18 01:00:00
271	8	2006-10-17 21:00:00	2006-10-18 01:00:00
271	90	2006-10-17 21:00:00	2006-10-18 01:00:00
271	15	2006-10-18 00:14:19	2006-10-18 01:00:00
271	123	2006-10-17 21:00:00	2006-10-18 01:00:00
271	325	2006-10-17 23:56:10	2006-10-18 01:00:00
271	19	2006-10-17 21:00:00	2006-10-18 01:00:00
271	21	2006-10-17 21:00:00	2006-10-18 01:00:00
271	157	2006-10-17 21:00:00	2006-10-17 23:46:29
271	27	2006-10-17 21:00:00	2006-10-18 01:00:00
271	28	2006-10-17 21:00:00	2006-10-18 01:00:00
271	232	2006-10-17 21:00:00	2006-10-18 01:00:00
271	32	2006-10-17 21:00:00	2006-10-17 23:53:02
271	136	2006-10-17 21:00:00	2006-10-18 01:00:00
271	257	2006-10-17 21:00:00	2006-10-18 01:00:00
271	150	2006-10-17 21:00:00	2006-10-18 01:00:00
271	155	2006-10-17 21:00:00	2006-10-18 01:00:00
271	39	2006-10-17 21:00:00	2006-10-17 23:56:44
271	40	2006-10-17 21:00:00	2006-10-18 00:13:21
271	41	2006-10-17 21:00:00	2006-10-17 22:30:26
271	43	2006-10-17 21:00:00	2006-10-18 01:00:00
271	259	2006-10-17 21:00:00	2006-10-18 01:00:00
271	270	2006-10-17 21:00:00	2006-10-18 01:00:00
271	45	2006-10-17 21:00:00	2006-10-18 01:00:00
271	142	2006-10-17 21:00:00	2006-10-18 01:00:00
271	50	2006-10-17 21:00:00	2006-10-18 01:00:00
271	100	2006-10-17 21:00:00	2006-10-17 23:53:32
271	103	2006-10-17 21:00:00	2006-10-18 01:00:00
271	51	2006-10-17 21:00:00	2006-10-18 01:00:00
271	222	2006-10-17 21:00:00	2006-10-18 01:00:00
271	233	2006-10-17 21:00:00	2006-10-18 01:00:00
271	132	2006-10-18 00:12:06	2006-10-18 01:00:00
271	116	2006-10-17 21:00:00	2006-10-18 01:00:00
271	109	2006-10-17 21:00:00	2006-10-18 01:00:00
271	160	2006-10-17 21:00:00	2006-10-18 00:03:57
271	118	2006-10-17 21:00:00	2006-10-18 01:00:00
271	55	2006-10-17 21:00:00	2006-10-18 01:00:00
271	153	2006-10-17 21:00:00	2006-10-18 01:00:00
271	59	2006-10-17 23:54:30	2006-10-18 01:00:00
271	60	2006-10-17 21:00:00	2006-10-18 01:00:00
273	1	2006-10-19 21:00:00	2006-10-19 23:30:00
273	284	2006-10-19 21:00:00	2006-10-19 23:30:00
273	2	2006-10-19 21:00:00	2006-10-19 23:30:00
273	97	2006-10-19 21:00:00	2006-10-19 23:30:00
273	4	2006-10-19 21:00:00	2006-10-19 23:30:00
273	206	2006-10-19 21:00:00	2006-10-19 23:30:00
273	5	2006-10-19 21:00:00	2006-10-19 23:30:00
273	135	2006-10-19 21:00:00	2006-10-19 23:30:00
273	16	2006-10-19 21:00:00	2006-10-19 23:30:00
273	23	2006-10-19 21:00:00	2006-10-19 23:30:00
273	157	2006-10-19 21:00:00	2006-10-19 23:30:00
273	27	2006-10-19 21:00:00	2006-10-19 23:30:00
273	213	2006-10-19 21:02:08	2006-10-19 23:30:00
273	28	2006-10-19 21:00:00	2006-10-19 23:30:00
273	232	2006-10-19 21:00:00	2006-10-19 23:30:00
273	30	2006-10-19 21:00:00	2006-10-19 23:30:00
273	31	2006-10-19 21:00:00	2006-10-19 23:30:00
273	32	2006-10-19 21:00:00	2006-10-19 23:30:00
273	33	2006-10-19 21:00:00	2006-10-19 23:30:00
273	136	2006-10-19 21:00:00	2006-10-19 23:30:00
273	36	2006-10-19 21:00:00	2006-10-19 23:30:00
273	150	2006-10-19 21:00:00	2006-10-19 23:30:00
273	111	2006-10-19 21:00:00	2006-10-19 23:30:00
273	155	2006-10-19 21:56:10	2006-10-19 23:30:00
273	39	2006-10-19 21:00:00	2006-10-19 23:30:00
273	40	2006-10-19 21:00:00	2006-10-19 23:30:00
273	41	2006-10-19 21:00:00	2006-10-19 23:30:00
273	43	2006-10-19 21:00:00	2006-10-19 23:30:00
273	259	2006-10-19 21:00:00	2006-10-19 23:30:00
273	142	2006-10-19 21:00:00	2006-10-19 23:30:00
273	48	2006-10-19 21:00:00	2006-10-19 23:30:00
273	333	2006-10-19 21:35:17	2006-10-19 23:30:00
273	100	2006-10-19 21:00:00	2006-10-19 23:30:00
273	103	2006-10-19 21:00:00	2006-10-19 23:30:00
273	51	2006-10-19 21:00:00	2006-10-19 23:30:00
273	229	2006-10-19 21:53:53	2006-10-19 21:55:41
273	222	2006-10-19 21:34:58	2006-10-19 23:30:00
273	52	2006-10-19 21:00:00	2006-10-19 23:30:00
273	148	2006-10-19 21:00:00	2006-10-19 23:30:00
273	233	2006-10-19 21:00:00	2006-10-19 23:30:00
273	315	2006-10-19 21:03:11	2006-10-19 23:22:09
273	160	2006-10-19 21:00:00	2006-10-19 23:30:00
273	205	2006-10-19 21:38:29	2006-10-19 23:30:00
273	89	2006-10-19 21:00:00	2006-10-19 23:19:38
273	118	2006-10-19 21:00:00	2006-10-19 21:13:42
273	55	2006-10-19 21:00:00	2006-10-19 23:30:00
273	153	2006-10-19 21:00:00	2006-10-19 23:30:00
273	231	2006-10-19 21:00:00	2006-10-19 23:30:00
273	66	2006-10-19 21:54:57	2006-10-19 23:30:00
273	60	2006-10-19 21:00:00	2006-10-19 23:30:00
278	1	2006-10-22 21:15:00	2006-10-22 23:15:00
278	284	2006-10-22 21:15:00	2006-10-22 23:15:00
278	2	2006-10-22 21:15:00	2006-10-22 23:15:00
278	97	2006-10-22 21:15:00	2006-10-22 23:15:00
278	4	2006-10-22 21:15:00	2006-10-22 23:15:00
278	206	2006-10-22 21:15:00	2006-10-22 21:37:13
278	5	2006-10-22 21:15:00	2006-10-22 23:15:00
278	200	2006-10-22 21:36:15	2006-10-22 23:15:00
278	135	2006-10-22 21:15:00	2006-10-22 23:15:00
278	15	2006-10-22 21:15:00	2006-10-22 23:07:17
278	123	2006-10-22 21:15:00	2006-10-22 22:09:59
278	325	2006-10-22 21:15:00	2006-10-22 23:15:00
278	19	2006-10-22 21:15:00	2006-10-22 23:15:00
278	21	2006-10-22 21:15:00	2006-10-22 23:15:00
278	23	2006-10-22 21:15:00	2006-10-22 23:15:00
278	157	2006-10-22 21:15:00	2006-10-22 23:15:00
278	27	2006-10-22 21:15:00	2006-10-22 23:15:00
278	28	2006-10-22 21:15:00	2006-10-22 23:15:00
278	30	2006-10-22 21:15:00	2006-10-22 23:15:00
278	164	2006-10-22 21:39:41	2006-10-22 21:43:07
278	119	2006-10-22 22:20:32	2006-10-22 23:15:00
278	136	2006-10-22 21:15:00	2006-10-22 23:15:00
278	36	2006-10-22 21:15:00	2006-10-22 23:15:00
278	150	2006-10-22 21:15:00	2006-10-22 23:15:00
278	155	2006-10-22 21:15:00	2006-10-22 23:15:00
278	39	2006-10-22 21:15:00	2006-10-22 23:15:00
278	40	2006-10-22 21:15:00	2006-10-22 21:20:46
278	43	2006-10-22 21:15:00	2006-10-22 23:15:00
278	142	2006-10-22 21:15:00	2006-10-22 23:15:00
278	48	2006-10-22 21:15:00	2006-10-22 23:15:00
278	50	2006-10-22 21:15:00	2006-10-22 23:15:00
278	100	2006-10-22 21:15:00	2006-10-22 23:15:00
278	103	2006-10-22 21:15:00	2006-10-22 23:15:00
278	51	2006-10-22 21:15:00	2006-10-22 23:15:00
278	334	2006-10-22 21:15:00	2006-10-22 23:15:00
278	52	2006-10-22 21:15:00	2006-10-22 23:15:00
278	148	2006-10-22 21:15:00	2006-10-22 23:15:00
278	116	2006-10-22 21:15:00	2006-10-22 23:15:00
278	109	2006-10-22 21:15:00	2006-10-22 23:15:00
278	160	2006-10-22 21:15:00	2006-10-22 23:15:00
278	54	2006-10-22 21:15:00	2006-10-22 23:15:00
278	153	2006-10-22 21:15:00	2006-10-22 23:15:00
278	60	2006-10-22 21:15:00	2006-10-22 23:15:00
277	1	2006-10-22 19:30:00	2006-10-22 20:30:00
277	284	2006-10-22 19:30:34	2006-10-22 20:30:00
277	2	2006-10-22 19:30:00	2006-10-22 20:30:00
277	97	2006-10-22 19:30:00	2006-10-22 20:30:00
277	4	2006-10-22 19:30:00	2006-10-22 20:30:00
277	135	2006-10-22 19:30:00	2006-10-22 20:30:00
277	90	2006-10-22 19:30:00	2006-10-22 20:30:00
277	15	2006-10-22 19:30:00	2006-10-22 20:30:00
277	16	2006-10-22 19:30:00	2006-10-22 20:30:00
277	19	2006-10-22 19:30:00	2006-10-22 20:30:00
277	21	2006-10-22 19:30:00	2006-10-22 20:30:00
277	157	2006-10-22 19:30:00	2006-10-22 20:30:00
277	27	2006-10-22 19:30:00	2006-10-22 20:30:00
277	28	2006-10-22 19:30:00	2006-10-22 20:30:00
277	232	2006-10-22 19:30:00	2006-10-22 20:30:00
277	30	2006-10-22 19:30:00	2006-10-22 20:30:00
277	274	2006-10-22 19:30:00	2006-10-22 20:30:00
277	32	2006-10-22 19:30:00	2006-10-22 20:30:00
277	154	2006-10-22 19:30:00	2006-10-22 20:30:00
277	136	2006-10-22 19:30:00	2006-10-22 20:30:00
277	36	2006-10-22 19:30:00	2006-10-22 20:30:00
277	150	2006-10-22 19:30:00	2006-10-22 20:30:00
277	155	2006-10-22 19:30:00	2006-10-22 20:30:00
277	39	2006-10-22 19:30:00	2006-10-22 20:30:00
277	40	2006-10-22 19:30:00	2006-10-22 20:30:00
277	41	2006-10-22 19:30:00	2006-10-22 20:30:00
277	43	2006-10-22 19:30:00	2006-10-22 20:30:00
277	270	2006-10-22 19:30:00	2006-10-22 20:30:00
277	44	2006-10-22 19:30:00	2006-10-22 20:30:00
277	142	2006-10-22 19:30:00	2006-10-22 20:30:00
277	48	2006-10-22 19:30:16	2006-10-22 20:30:00
277	50	2006-10-22 19:30:00	2006-10-22 20:30:00
277	100	2006-10-22 19:30:00	2006-10-22 20:30:00
277	103	2006-10-22 19:30:00	2006-10-22 20:30:00
277	51	2006-10-22 19:30:00	2006-10-22 20:30:00
277	52	2006-10-22 19:30:00	2006-10-22 20:30:00
277	148	2006-10-22 19:30:00	2006-10-22 20:30:00
277	116	2006-10-22 19:30:00	2006-10-22 20:30:00
277	160	2006-10-22 19:30:00	2006-10-22 20:30:00
277	57	2006-10-22 19:30:00	2006-10-22 20:30:00
277	153	2006-10-22 19:30:00	2006-10-22 20:30:00
277	60	2006-10-22 19:47:47	2006-10-22 20:30:00
274	284	2006-10-21 11:00:00	2006-10-21 12:22:28
274	90	2006-10-21 11:00:00	2006-10-21 14:35:00
274	235	2006-10-21 12:26:34	2006-10-21 14:35:00
274	213	2006-10-21 11:00:00	2006-10-21 14:35:00
274	30	2006-10-21 11:00:00	2006-10-21 14:35:00
274	164	2006-10-21 11:00:00	2006-10-21 12:54:36
274	33	2006-10-21 11:00:00	2006-10-21 14:35:00
274	136	2006-10-21 13:22:27	2006-10-21 14:35:00
274	234	2006-10-21 11:00:00	2006-10-21 14:35:00
274	35	2006-10-21 12:57:08	2006-10-21 14:35:00
274	286	2006-10-21 11:00:00	2006-10-21 12:56:20
274	155	2006-10-21 11:00:00	2006-10-21 14:35:00
274	319	2006-10-21 11:00:00	2006-10-21 12:22:40
274	259	2006-10-21 11:00:00	2006-10-21 14:35:00
274	142	2006-10-21 11:00:00	2006-10-21 12:51:38
274	326	2006-10-21 11:00:00	2006-10-21 14:35:00
274	100	2006-10-21 11:00:00	2006-10-21 14:35:00
274	293	2006-10-21 13:19:50	2006-10-21 14:35:00
274	51	2006-10-21 13:33:38	2006-10-21 14:35:00
274	188	2006-10-21 11:05:39	2006-10-21 13:33:54
274	165	2006-10-21 11:09:14	2006-10-21 14:35:00
274	61	2006-10-21 11:00:00	2006-10-21 14:35:00
274	109	2006-10-21 11:20:50	2006-10-21 14:35:00
274	160	2006-10-21 11:00:00	2006-10-21 11:15:29
274	167	2006-10-21 11:00:00	2006-10-21 14:35:00
274	251	2006-10-21 12:24:15	2006-10-21 14:35:00
274	282	2006-10-21 11:00:00	2006-10-21 14:35:00
274	231	2006-10-21 13:36:23	2006-10-21 14:35:00
274	59	2006-10-21 11:00:00	2006-10-21 13:34:00
275	301	2006-10-21 19:30:00	2006-10-21 20:20:00
275	2	2006-10-21 19:30:00	2006-10-21 20:20:00
275	4	2006-10-21 19:30:00	2006-10-21 20:20:00
275	135	2006-10-21 19:30:00	2006-10-21 20:20:00
275	275	2006-10-21 19:36:16	2006-10-21 20:20:00
275	13	2006-10-21 19:52:18	2006-10-21 20:20:00
275	27	2006-10-21 19:30:00	2006-10-21 20:20:00
275	213	2006-10-21 19:41:40	2006-10-21 20:20:00
275	274	2006-10-21 19:30:00	2006-10-21 20:20:00
275	299	2006-10-21 19:30:00	2006-10-21 20:20:00
275	33	2006-10-21 19:40:20	2006-10-21 20:20:00
275	154	2006-10-21 19:30:00	2006-10-21 20:20:00
275	285	2006-10-21 19:30:00	2006-10-21 20:20:00
275	136	2006-10-21 19:30:00	2006-10-21 20:20:00
275	234	2006-10-21 19:30:00	2006-10-21 20:20:00
275	257	2006-10-21 19:30:00	2006-10-21 20:20:00
275	150	2006-10-21 19:30:00	2006-10-21 20:20:00
275	155	2006-10-21 19:30:00	2006-10-21 20:20:00
275	259	2006-10-21 19:38:24	2006-10-21 20:20:00
275	44	2006-10-21 19:30:00	2006-10-21 20:20:00
275	50	2006-10-21 19:30:00	2006-10-21 20:20:00
275	100	2006-10-21 19:30:00	2006-10-21 20:20:00
275	264	2006-10-21 19:41:26	2006-10-21 20:20:00
275	293	2006-10-21 19:30:00	2006-10-21 20:20:00
275	188	2006-10-21 19:30:00	2006-10-21 20:20:00
275	334	2006-10-21 19:41:22	2006-10-21 20:20:00
275	52	2006-10-21 19:30:00	2006-10-21 20:20:00
275	148	2006-10-21 19:30:00	2006-10-21 20:20:00
275	308	2006-10-21 19:30:00	2006-10-21 20:20:00
275	315	2006-10-21 19:30:00	2006-10-21 20:20:00
275	75	2006-10-21 19:30:00	2006-10-21 20:20:00
275	109	2006-10-21 19:30:00	2006-10-21 20:20:00
275	76	2006-10-21 19:30:00	2006-10-21 20:20:00
275	167	2006-10-21 19:30:00	2006-10-21 20:20:00
275	55	2006-10-21 19:49:02	2006-10-21 20:20:00
275	251	2006-10-21 19:30:00	2006-10-21 20:20:00
275	153	2006-10-21 19:33:27	2006-10-21 20:20:00
275	332	2006-10-21 19:38:17	2006-10-21 20:20:00
275	231	2006-10-21 19:34:30	2006-10-21 20:20:00
275	59	2006-10-21 19:30:00	2006-10-21 20:20:00
276	301	2006-10-21 21:00:00	2006-10-22 00:25:00
276	266	2006-10-21 22:13:18	2006-10-22 00:25:00
276	284	2006-10-21 21:00:00	2006-10-22 00:25:00
276	97	2006-10-21 21:00:00	2006-10-21 22:43:28
276	203	2006-10-21 22:22:02	2006-10-21 22:50:50
276	4	2006-10-21 21:00:00	2006-10-22 00:20:29
276	156	2006-10-21 21:00:00	2006-10-22 00:25:00
276	135	2006-10-21 21:00:00	2006-10-22 00:25:00
276	287	2006-10-21 21:00:00	2006-10-22 00:25:00
276	275	2006-10-21 21:00:00	2006-10-22 00:25:00
276	235	2006-10-21 21:15:37	2006-10-22 00:25:00
276	336	2006-10-21 22:22:17	2006-10-21 22:55:48
276	123	2006-10-21 21:00:25	2006-10-22 00:25:00
276	213	2006-10-21 21:00:00	2006-10-22 00:25:00
276	245	2006-10-21 21:00:33	2006-10-21 22:05:17
276	274	2006-10-21 21:00:00	2006-10-22 00:19:49
276	299	2006-10-21 21:00:00	2006-10-22 00:25:00
276	33	2006-10-21 21:00:00	2006-10-22 00:25:00
276	154	2006-10-21 21:00:00	2006-10-22 00:22:28
276	279	2006-10-21 21:20:08	2006-10-22 00:25:00
276	285	2006-10-21 21:00:00	2006-10-22 00:17:40
276	136	2006-10-21 21:00:00	2006-10-22 00:25:00
276	234	2006-10-21 21:00:00	2006-10-22 00:25:00
276	257	2006-10-21 21:00:00	2006-10-21 22:03:01
276	150	2006-10-21 21:00:00	2006-10-22 00:25:00
276	155	2006-10-21 21:00:00	2006-10-22 00:25:00
276	269	2006-10-22 00:22:48	2006-10-22 00:25:00
276	202	2006-10-21 21:37:00	2006-10-22 00:25:00
276	323	2006-10-21 21:00:00	2006-10-22 00:15:27
276	259	2006-10-21 21:00:00	2006-10-22 00:25:00
276	142	2006-10-21 22:05:26	2006-10-22 00:17:37
276	326	2006-10-21 22:11:08	2006-10-21 23:46:26
276	297	2006-10-21 21:32:49	2006-10-22 00:25:00
276	106	2006-10-21 21:28:23	2006-10-21 23:54:14
276	296	2006-10-22 00:22:37	2006-10-22 00:25:00
276	264	2006-10-21 21:00:00	2006-10-22 00:25:00
276	293	2006-10-21 21:00:00	2006-10-22 00:25:00
276	114	2006-10-21 21:00:00	2006-10-22 00:20:24
276	188	2006-10-21 21:00:00	2006-10-22 00:25:00
276	334	2006-10-21 21:00:00	2006-10-22 00:18:30
276	148	2006-10-21 21:00:00	2006-10-21 23:04:06
276	132	2006-10-21 21:00:00	2006-10-22 00:25:00
276	337	2006-10-21 21:00:00	2006-10-22 00:25:00
276	75	2006-10-21 21:00:00	2006-10-22 00:25:00
276	160	2006-10-21 21:00:00	2006-10-22 00:25:00
276	316	2006-10-21 21:00:00	2006-10-22 00:25:00
276	76	2006-10-21 21:00:00	2006-10-22 00:25:00
276	332	2006-10-21 21:00:00	2006-10-22 00:17:09
276	231	2006-10-21 21:00:00	2006-10-22 00:25:00
276	59	2006-10-21 21:00:00	2006-10-22 00:25:00
276	277	2006-10-21 21:00:00	2006-10-21 22:05:20
276	329	2006-10-21 21:00:00	2006-10-21 22:23:55
279	301	2006-10-23 21:00:00	2006-10-24 00:30:00
279	284	2006-10-23 21:00:00	2006-10-24 00:30:00
279	97	2006-10-23 21:12:47	2006-10-23 23:16:47
279	200	2006-10-23 21:00:00	2006-10-24 00:30:00
279	287	2006-10-23 21:04:18	2006-10-23 22:25:03
279	335	2006-10-23 21:06:20	2006-10-23 23:40:42
279	90	2006-10-23 21:00:00	2006-10-24 00:30:00
279	322	2006-10-23 21:06:15	2006-10-24 00:30:00
279	235	2006-10-23 21:00:00	2006-10-24 00:30:00
279	217	2006-10-23 21:00:00	2006-10-24 00:30:00
279	123	2006-10-23 21:00:00	2006-10-23 23:00:53
279	325	2006-10-23 21:00:00	2006-10-24 00:30:00
279	280	2006-10-23 21:00:00	2006-10-24 00:30:00
279	213	2006-10-23 21:00:00	2006-10-24 00:30:00
279	274	2006-10-23 21:00:00	2006-10-24 00:30:00
279	299	2006-10-23 21:00:00	2006-10-24 00:30:00
279	154	2006-10-23 21:00:00	2006-10-24 00:30:00
279	285	2006-10-23 21:00:00	2006-10-24 00:30:00
279	136	2006-10-23 21:00:00	2006-10-24 00:30:00
279	257	2006-10-23 21:00:00	2006-10-24 00:30:00
279	150	2006-10-23 21:00:00	2006-10-24 00:30:00
279	155	2006-10-23 21:00:00	2006-10-24 00:30:00
279	269	2006-10-23 23:20:27	2006-10-24 00:30:00
279	319	2006-10-23 21:00:00	2006-10-24 00:30:00
279	42	2006-10-23 21:00:00	2006-10-24 00:30:00
279	270	2006-10-23 21:00:00	2006-10-24 00:30:00
279	44	2006-10-23 21:00:00	2006-10-24 00:30:00
279	297	2006-10-23 22:21:44	2006-10-23 23:06:08
279	106	2006-10-23 21:00:00	2006-10-24 00:30:00
279	220	2006-10-23 21:00:00	2006-10-24 00:30:00
279	293	2006-10-23 21:00:00	2006-10-24 00:30:00
279	338	2006-10-23 21:04:05	2006-10-24 00:30:00
279	188	2006-10-23 21:00:00	2006-10-24 00:30:00
279	222	2006-10-23 23:41:36	2006-10-24 00:30:00
279	52	2006-10-23 23:46:51	2006-10-24 00:30:00
279	223	2006-10-23 21:00:00	2006-10-24 00:30:00
279	148	2006-10-23 21:00:00	2006-10-24 00:30:00
279	132	2006-10-23 23:00:59	2006-10-24 00:30:00
279	152	2006-10-23 21:00:00	2006-10-24 00:30:00
279	54	2006-10-23 21:00:00	2006-10-24 00:30:00
279	316	2006-10-23 21:00:00	2006-10-24 00:30:00
279	240	2006-10-23 21:00:00	2006-10-24 00:30:00
279	89	2006-10-23 21:00:00	2006-10-24 00:30:00
279	76	2006-10-23 22:27:26	2006-10-24 00:30:00
279	118	2006-10-23 21:00:00	2006-10-24 00:30:00
279	251	2006-10-23 21:00:00	2006-10-23 23:43:50
279	56	2006-10-23 21:00:00	2006-10-24 00:30:00
279	59	2006-10-23 21:00:00	2006-10-24 00:30:00
280	1	2006-10-24 21:00:00	2006-10-25 00:45:00
280	284	2006-10-24 21:00:00	2006-10-25 00:45:00
280	2	2006-10-24 21:32:53	2006-10-24 22:55:57
280	97	2006-10-24 23:55:11	2006-10-25 00:45:00
280	4	2006-10-24 21:00:00	2006-10-25 00:45:00
280	206	2006-10-24 21:00:00	2006-10-25 00:45:00
280	5	2006-10-24 21:00:00	2006-10-24 22:24:02
280	8	2006-10-24 21:00:00	2006-10-25 00:45:00
280	175	2006-10-24 21:00:00	2006-10-24 23:47:26
280	90	2006-10-24 21:00:00	2006-10-25 00:45:00
280	15	2006-10-24 21:00:00	2006-10-25 00:45:00
280	123	2006-10-24 21:00:00	2006-10-25 00:45:00
280	19	2006-10-24 23:14:51	2006-10-25 00:45:00
280	21	2006-10-24 21:00:00	2006-10-25 00:45:00
280	157	2006-10-24 21:00:00	2006-10-25 00:45:00
280	27	2006-10-24 23:55:15	2006-10-25 00:45:00
280	28	2006-10-24 21:00:00	2006-10-25 00:45:00
280	232	2006-10-24 21:00:00	2006-10-25 00:45:00
280	30	2006-10-24 21:00:00	2006-10-25 00:45:00
280	32	2006-10-24 21:00:00	2006-10-25 00:45:00
280	33	2006-10-24 21:00:00	2006-10-25 00:45:00
280	136	2006-10-24 21:00:00	2006-10-25 00:45:00
280	36	2006-10-24 21:00:00	2006-10-25 00:45:00
280	257	2006-10-24 21:00:00	2006-10-24 23:46:10
280	150	2006-10-24 21:00:00	2006-10-25 00:45:00
280	155	2006-10-24 22:24:46	2006-10-25 00:45:00
280	39	2006-10-24 21:00:00	2006-10-24 23:17:06
280	43	2006-10-24 23:54:50	2006-10-25 00:45:00
280	259	2006-10-24 21:00:00	2006-10-25 00:45:00
280	270	2006-10-24 21:00:00	2006-10-24 23:14:18
280	45	2006-10-24 21:00:00	2006-10-25 00:45:00
280	142	2006-10-24 21:00:00	2006-10-25 00:41:41
280	50	2006-10-24 21:00:00	2006-10-25 00:45:00
280	100	2006-10-24 21:00:00	2006-10-24 23:45:13
280	293	2006-10-24 23:22:14	2006-10-25 00:45:00
280	103	2006-10-24 21:00:00	2006-10-25 00:45:00
280	51	2006-10-24 21:00:00	2006-10-25 00:37:26
280	222	2006-10-24 21:00:00	2006-10-24 21:47:23
280	52	2006-10-24 21:00:00	2006-10-25 00:45:00
280	148	2006-10-24 21:00:00	2006-10-25 00:42:19
280	233	2006-10-24 21:00:00	2006-10-25 00:45:00
280	132	2006-10-24 21:00:00	2006-10-25 00:45:00
280	116	2006-10-24 21:00:00	2006-10-25 00:45:00
280	160	2006-10-24 21:00:00	2006-10-24 23:53:58
280	55	2006-10-24 21:00:00	2006-10-25 00:45:00
280	57	2006-10-24 21:00:00	2006-10-25 00:45:00
280	153	2006-10-24 21:00:00	2006-10-25 00:45:00
280	231	2006-10-24 21:49:44	2006-10-25 00:45:00
280	60	2006-10-24 21:00:00	2006-10-25 00:45:00
283	301	2006-10-28 19:32:23	2006-10-28 20:15:00
283	284	2006-10-28 19:30:00	2006-10-28 20:15:00
283	2	2006-10-28 19:30:00	2006-10-28 20:15:00
283	156	2006-10-28 19:32:03	2006-10-28 20:15:00
283	135	2006-10-28 19:30:00	2006-10-28 20:15:00
283	90	2006-10-28 19:30:00	2006-10-28 20:15:00
283	13	2006-10-28 19:47:19	2006-10-28 20:15:00
283	217	2006-10-28 19:30:00	2006-10-28 20:15:00
283	123	2006-10-28 19:30:00	2006-10-28 20:15:00
283	19	2006-10-28 19:39:46	2006-10-28 20:15:00
283	280	2006-10-28 19:30:00	2006-10-28 20:15:00
283	157	2006-10-28 19:30:00	2006-10-28 20:15:00
283	245	2006-10-28 19:30:00	2006-10-28 20:15:00
283	274	2006-10-28 19:30:00	2006-10-28 20:15:00
283	299	2006-10-28 19:30:31	2006-10-28 20:15:00
283	285	2006-10-28 19:30:00	2006-10-28 20:15:00
283	136	2006-10-28 19:30:00	2006-10-28 20:15:00
283	234	2006-10-28 19:30:00	2006-10-28 20:15:00
283	36	2006-10-28 19:30:00	2006-10-28 20:15:00
283	150	2006-10-28 19:30:00	2006-10-28 20:15:00
283	44	2006-10-28 19:30:00	2006-10-28 20:15:00
283	45	2006-10-28 19:30:00	2006-10-28 20:15:00
283	296	2006-10-28 19:32:00	2006-10-28 20:15:00
283	100	2006-10-28 19:30:00	2006-10-28 20:15:00
283	223	2006-10-28 19:30:00	2006-10-28 20:15:00
283	148	2006-10-28 19:30:00	2006-10-28 20:15:00
283	132	2006-10-28 19:30:00	2006-10-28 20:15:00
283	116	2006-10-28 19:30:00	2006-10-28 20:15:00
283	316	2006-10-28 19:30:00	2006-10-28 20:15:00
283	89	2006-10-28 19:30:00	2006-10-28 20:15:00
283	118	2006-10-28 19:30:00	2006-10-28 20:15:00
283	328	2006-10-28 19:30:00	2006-10-28 20:15:00
283	282	2006-10-28 19:31:20	2006-10-28 20:15:00
283	59	2006-10-28 19:30:00	2006-10-28 20:15:00
283	60	2006-10-28 19:30:00	2006-10-28 20:15:00
284	301	2006-10-28 21:00:00	2006-10-29 00:17:35
284	284	2006-10-28 21:00:00	2006-10-29 00:30:00
284	143	2006-10-28 21:00:00	2006-10-29 00:30:00
284	4	2006-10-28 22:38:52	2006-10-28 23:12:06
284	156	2006-10-28 21:00:00	2006-10-29 00:30:00
284	135	2006-10-28 21:00:00	2006-10-29 00:17:17
284	335	2006-10-28 21:00:00	2006-10-29 00:30:00
284	90	2006-10-28 21:00:00	2006-10-29 00:30:00
284	336	2006-10-28 21:00:00	2006-10-29 00:17:07
284	217	2006-10-28 21:00:00	2006-10-28 23:14:21
284	123	2006-10-28 21:00:00	2006-10-29 00:17:35
284	325	2006-10-28 21:00:00	2006-10-28 22:16:17
284	21	2006-10-28 21:00:00	2006-10-29 00:17:31
284	280	2006-10-28 21:00:00	2006-10-29 00:16:30
284	245	2006-10-28 21:00:00	2006-10-28 21:54:05
284	274	2006-10-28 21:00:00	2006-10-29 00:30:00
284	299	2006-10-28 21:00:00	2006-10-29 00:30:00
284	285	2006-10-28 21:00:00	2006-10-29 00:30:00
284	234	2006-10-28 21:00:00	2006-10-29 00:30:00
284	286	2006-10-28 23:00:03	2006-10-29 00:16:42
284	150	2006-10-28 21:00:00	2006-10-29 00:30:00
284	84	2006-10-28 21:00:00	2006-10-28 21:54:55
284	320	2006-10-28 21:41:07	2006-10-29 00:16:51
284	202	2006-10-28 21:00:00	2006-10-29 00:30:00
284	270	2006-10-28 21:00:00	2006-10-28 21:54:28
284	44	2006-10-28 21:00:00	2006-10-29 00:30:00
284	249	2006-10-28 21:02:35	2006-10-29 00:17:45
284	220	2006-10-28 21:00:00	2006-10-29 00:16:17
284	296	2006-10-28 21:00:00	2006-10-29 00:17:24
284	293	2006-10-28 23:16:13	2006-10-29 00:30:00
284	114	2006-10-28 21:00:00	2006-10-29 00:30:00
284	339	2006-10-28 21:00:00	2006-10-29 00:30:00
284	188	2006-10-28 23:16:11	2006-10-29 00:30:00
284	344	2006-10-28 21:00:00	2006-10-28 22:17:23
284	151	2006-10-28 21:00:00	2006-10-29 00:17:09
284	223	2006-10-28 21:00:00	2006-10-28 23:43:30
284	148	2006-10-28 21:00:00	2006-10-29 00:17:21
284	307	2006-10-28 21:00:00	2006-10-29 00:16:20
284	132	2006-10-28 21:00:00	2006-10-29 00:17:05
284	116	2006-10-28 21:00:00	2006-10-28 23:43:39
284	152	2006-10-28 23:26:58	2006-10-29 00:30:00
284	316	2006-10-28 21:00:00	2006-10-29 00:30:00
284	89	2006-10-28 21:00:00	2006-10-28 23:14:02
284	76	2006-10-28 21:00:00	2006-10-28 23:25:11
284	118	2006-10-28 21:00:00	2006-10-29 00:30:00
284	328	2006-10-28 21:00:00	2006-10-29 00:16:25
284	251	2006-10-28 21:55:40	2006-10-29 00:17:45
284	282	2006-10-28 21:00:00	2006-10-29 00:30:00
284	332	2006-10-28 22:30:53	2006-10-29 00:16:49
284	59	2006-10-28 21:00:00	2006-10-29 00:17:08
282	284	2006-10-28 11:00:00	2006-10-28 14:39:56
282	2	2006-10-28 11:00:00	2006-10-28 16:00:00
282	4	2006-10-28 15:22:20	2006-10-28 16:00:00
282	8	2006-10-28 12:47:52	2006-10-28 16:00:00
282	90	2006-10-28 11:00:00	2006-10-28 16:00:00
282	235	2006-10-28 12:39:46	2006-10-28 16:00:00
282	13	2006-10-28 12:42:56	2006-10-28 16:00:00
282	280	2006-10-28 11:00:00	2006-10-28 16:00:00
282	157	2006-10-28 11:00:00	2006-10-28 16:00:00
282	299	2006-10-28 11:02:58	2006-10-28 15:33:42
282	136	2006-10-28 13:33:18	2006-10-28 16:00:00
282	234	2006-10-28 14:42:45	2006-10-28 16:00:00
282	257	2006-10-28 14:53:41	2006-10-28 16:00:00
282	269	2006-10-28 11:00:00	2006-10-28 14:35:39
282	319	2006-10-28 11:00:00	2006-10-28 16:00:00
282	259	2006-10-28 11:00:00	2006-10-28 16:00:00
282	326	2006-10-28 11:00:00	2006-10-28 15:38:17
282	296	2006-10-28 11:00:00	2006-10-28 15:31:46
282	100	2006-10-28 11:00:00	2006-10-28 13:36:08
282	51	2006-10-28 15:26:41	2006-10-28 16:00:00
282	312	2006-10-28 11:00:00	2006-10-28 12:40:53
282	229	2006-10-28 11:00:00	2006-10-28 16:00:00
282	148	2006-10-28 15:32:27	2006-10-28 16:00:00
282	307	2006-10-28 11:00:00	2006-10-28 12:47:22
282	160	2006-10-28 11:00:00	2006-10-28 16:00:00
282	152	2006-10-28 15:53:20	2006-10-28 16:00:00
282	240	2006-10-28 11:00:00	2006-10-28 15:20:43
282	345	2006-10-28 11:00:00	2006-10-28 16:00:00
282	89	2006-10-28 11:00:00	2006-10-28 16:00:00
282	328	2006-10-28 11:00:00	2006-10-28 14:49:36
282	251	2006-10-28 12:41:36	2006-10-28 13:34:29
282	282	2006-10-28 11:00:00	2006-10-28 16:00:00
281	284	2006-10-26 21:00:00	2006-10-26 23:00:00
281	2	2006-10-26 21:00:00	2006-10-26 23:00:00
281	5	2006-10-26 21:00:00	2006-10-26 23:00:00
281	8	2006-10-26 21:00:00	2006-10-26 23:00:00
281	322	2006-10-26 21:00:00	2006-10-26 22:56:03
281	15	2006-10-26 21:00:00	2006-10-26 23:00:00
281	16	2006-10-26 21:00:00	2006-10-26 23:00:00
281	325	2006-10-26 21:15:24	2006-10-26 23:00:00
281	19	2006-10-26 21:00:00	2006-10-26 23:00:00
281	21	2006-10-26 21:00:00	2006-10-26 23:00:00
281	23	2006-10-26 21:00:00	2006-10-26 23:00:00
281	157	2006-10-26 21:00:00	2006-10-26 23:00:00
281	26	2006-10-26 21:01:31	2006-10-26 23:00:00
281	27	2006-10-26 21:00:00	2006-10-26 23:00:00
281	28	2006-10-26 21:00:00	2006-10-26 23:00:00
281	31	2006-10-26 21:00:27	2006-10-26 21:13:22
281	32	2006-10-26 21:00:00	2006-10-26 23:00:00
281	33	2006-10-26 21:00:00	2006-10-26 23:00:00
281	154	2006-10-26 21:00:00	2006-10-26 23:00:00
281	136	2006-10-26 21:00:00	2006-10-26 23:00:00
281	257	2006-10-26 21:00:00	2006-10-26 23:00:00
281	155	2006-10-26 21:00:00	2006-10-26 23:00:00
281	39	2006-10-26 21:00:00	2006-10-26 22:54:54
281	319	2006-10-26 21:00:00	2006-10-26 22:54:31
281	43	2006-10-26 21:07:44	2006-10-26 23:00:00
281	44	2006-10-26 21:00:00	2006-10-26 23:00:00
281	142	2006-10-26 22:34:33	2006-10-26 23:00:00
281	48	2006-10-26 21:00:00	2006-10-26 23:00:00
281	100	2006-10-26 21:00:00	2006-10-26 23:00:00
281	293	2006-10-26 21:00:00	2006-10-26 23:00:00
281	103	2006-10-26 21:00:00	2006-10-26 23:00:00
281	51	2006-10-26 21:55:58	2006-10-26 23:00:00
281	334	2006-10-26 21:00:00	2006-10-26 23:00:00
281	52	2006-10-26 21:00:00	2006-10-26 23:00:00
281	148	2006-10-26 21:00:00	2006-10-26 23:00:00
281	116	2006-10-26 21:00:00	2006-10-26 23:00:00
281	160	2006-10-26 21:00:00	2006-10-26 22:54:53
281	316	2006-10-26 21:00:00	2006-10-26 23:00:00
281	167	2006-10-26 21:00:00	2006-10-26 23:00:00
281	118	2006-10-26 21:00:00	2006-10-26 23:00:00
281	153	2006-10-26 21:00:00	2006-10-26 22:34:12
281	59	2006-10-26 21:00:00	2006-10-26 23:00:00
281	60	2006-10-26 21:00:00	2006-10-26 23:00:00
286	1	2006-10-29 22:06:17	2006-10-29 22:40:00
286	284	2006-10-29 21:00:00	2006-10-29 22:40:00
286	2	2006-10-29 21:00:00	2006-10-29 22:40:00
286	97	2006-10-29 21:38:14	2006-10-29 22:40:00
286	143	2006-10-29 21:21:33	2006-10-29 22:40:00
286	4	2006-10-29 21:00:00	2006-10-29 22:39:57
286	5	2006-10-29 21:00:00	2006-10-29 22:40:00
286	8	2006-10-29 21:00:00	2006-10-29 22:40:00
286	15	2006-10-29 21:00:00	2006-10-29 22:40:00
286	19	2006-10-29 21:00:00	2006-10-29 22:40:00
286	21	2006-10-29 21:00:00	2006-10-29 22:40:00
286	157	2006-10-29 21:00:00	2006-10-29 22:40:00
286	27	2006-10-29 21:00:00	2006-10-29 22:40:00
286	30	2006-10-29 21:00:00	2006-10-29 22:40:00
286	32	2006-10-29 21:00:00	2006-10-29 22:40:00
286	33	2006-10-29 21:00:00	2006-10-29 22:40:00
286	154	2006-10-29 21:16:08	2006-10-29 22:40:00
286	136	2006-10-29 21:00:00	2006-10-29 22:40:00
286	36	2006-10-29 21:00:00	2006-10-29 22:39:18
286	155	2006-10-29 21:00:00	2006-10-29 22:40:00
286	39	2006-10-29 21:00:00	2006-10-29 22:06:06
286	40	2006-10-29 21:00:00	2006-10-29 22:40:00
286	41	2006-10-29 21:00:00	2006-10-29 22:40:00
286	45	2006-10-29 21:00:00	2006-10-29 22:40:00
286	142	2006-10-29 21:00:00	2006-10-29 22:06:44
286	48	2006-10-29 21:00:00	2006-10-29 22:40:00
286	50	2006-10-29 21:00:00	2006-10-29 22:40:00
286	100	2006-10-29 21:00:00	2006-10-29 22:40:00
286	293	2006-10-29 21:13:48	2006-10-29 22:40:00
286	103	2006-10-29 21:00:00	2006-10-29 22:40:00
286	51	2006-10-29 21:00:00	2006-10-29 22:40:00
286	52	2006-10-29 21:00:00	2006-10-29 22:40:00
286	223	2006-10-29 21:18:22	2006-10-29 22:40:00
286	233	2006-10-29 21:00:00	2006-10-29 22:40:00
286	116	2006-10-29 21:00:00	2006-10-29 22:40:00
286	160	2006-10-29 21:00:00	2006-10-29 22:40:00
286	152	2006-10-29 21:03:53	2006-10-29 22:40:00
286	316	2006-10-29 21:00:00	2006-10-29 22:40:00
286	55	2006-10-29 21:30:59	2006-10-29 22:40:00
286	282	2006-10-29 22:13:48	2006-10-29 22:40:00
286	59	2006-10-29 21:00:56	2006-10-29 22:40:00
286	60	2006-10-29 21:00:00	2006-10-29 22:40:00
288	284	2006-10-30 21:00:00	2006-10-30 23:40:00
288	200	2006-10-30 22:22:05	2006-10-30 23:40:00
288	135	2006-10-30 21:00:00	2006-10-30 23:40:00
288	335	2006-10-30 21:00:00	2006-10-30 23:03:33
288	90	2006-10-30 21:00:00	2006-10-30 23:40:00
288	322	2006-10-30 21:00:00	2006-10-30 23:39:31
288	346	2006-10-30 22:53:15	2006-10-30 23:06:18
288	235	2006-10-30 21:00:00	2006-10-30 23:40:00
288	217	2006-10-30 21:00:00	2006-10-30 23:40:00
288	123	2006-10-30 21:00:00	2006-10-30 23:40:00
288	325	2006-10-30 21:00:00	2006-10-30 23:40:00
288	245	2006-10-30 21:00:00	2006-10-30 23:40:00
288	299	2006-10-30 21:00:00	2006-10-30 23:40:00
288	314	2006-10-30 21:00:00	2006-10-30 21:02:45
288	33	2006-10-30 21:00:00	2006-10-30 23:40:00
288	154	2006-10-30 21:00:00	2006-10-30 23:40:00
288	285	2006-10-30 21:00:00	2006-10-30 23:40:00
288	150	2006-10-30 21:00:00	2006-10-30 23:40:00
288	155	2006-10-30 21:00:00	2006-10-30 23:40:00
288	202	2006-10-30 21:00:00	2006-10-30 23:40:00
288	270	2006-10-30 21:00:00	2006-10-30 23:40:00
288	44	2006-10-30 21:00:00	2006-10-30 23:40:00
288	297	2006-10-30 21:00:00	2006-10-30 23:39:14
288	106	2006-10-30 22:05:08	2006-10-30 22:22:54
288	187	2006-10-30 21:00:00	2006-10-30 23:40:00
288	220	2006-10-30 21:00:00	2006-10-30 23:40:00
288	340	2006-10-30 21:00:00	2006-10-30 23:40:00
288	293	2006-10-30 21:00:00	2006-10-30 23:40:00
288	114	2006-10-30 21:00:00	2006-10-30 23:33:26
288	103	2006-10-30 21:03:48	2006-10-30 23:39:39
288	51	2006-10-30 22:25:05	2006-10-30 23:40:00
288	339	2006-10-30 21:00:00	2006-10-30 23:40:00
288	188	2006-10-30 21:00:00	2006-10-30 22:22:08
288	222	2006-10-30 21:00:00	2006-10-30 23:40:00
288	347	2006-10-30 21:00:00	2006-10-30 21:59:36
288	52	2006-10-30 21:00:00	2006-10-30 23:40:00
288	223	2006-10-30 21:00:00	2006-10-30 23:40:00
288	148	2006-10-30 21:00:00	2006-10-30 23:40:00
288	307	2006-10-30 21:00:00	2006-10-30 23:40:00
288	132	2006-10-30 21:00:00	2006-10-30 23:40:00
288	152	2006-10-30 21:00:00	2006-10-30 23:40:00
288	240	2006-10-30 21:00:00	2006-10-30 23:40:00
288	89	2006-10-30 21:00:00	2006-10-30 23:40:00
288	76	2006-10-30 21:20:03	2006-10-30 23:40:00
288	167	2006-10-30 21:00:00	2006-10-30 23:03:15
288	56	2006-10-30 21:00:00	2006-10-30 23:40:00
288	282	2006-10-30 21:00:00	2006-10-30 23:40:00
288	66	2006-10-30 21:00:00	2006-10-30 23:40:00
288	59	2006-10-30 21:00:00	2006-10-30 23:40:00
285	284	2006-10-29 19:30:00	2006-10-29 20:45:00
285	2	2006-10-29 19:30:00	2006-10-29 20:45:00
285	4	2006-10-29 19:30:00	2006-10-29 20:45:00
285	5	2006-10-29 19:30:00	2006-10-29 20:45:00
285	8	2006-10-29 19:30:00	2006-10-29 20:45:00
285	90	2006-10-29 19:30:00	2006-10-29 20:45:00
285	15	2006-10-29 19:30:00	2006-10-29 20:45:00
285	16	2006-10-29 19:30:00	2006-10-29 20:45:00
285	19	2006-10-29 19:30:00	2006-10-29 20:45:00
285	21	2006-10-29 19:30:00	2006-10-29 20:45:00
285	157	2006-10-29 19:30:00	2006-10-29 20:45:00
285	27	2006-10-29 19:30:00	2006-10-29 20:45:00
285	232	2006-10-29 19:30:00	2006-10-29 20:45:00
285	30	2006-10-29 19:30:00	2006-10-29 20:45:00
285	32	2006-10-29 19:30:00	2006-10-29 20:45:00
285	33	2006-10-29 19:30:00	2006-10-29 20:45:00
285	136	2006-10-29 19:30:00	2006-10-29 20:45:00
285	36	2006-10-29 19:30:00	2006-10-29 20:45:00
285	155	2006-10-29 19:30:00	2006-10-29 20:45:00
285	39	2006-10-29 19:30:00	2006-10-29 20:45:00
285	40	2006-10-29 19:30:00	2006-10-29 20:45:00
285	41	2006-10-29 19:30:00	2006-10-29 20:45:00
285	42	2006-10-29 19:30:00	2006-10-29 20:45:00
285	259	2006-10-29 19:30:00	2006-10-29 20:45:00
285	270	2006-10-29 19:30:00	2006-10-29 20:45:00
285	45	2006-10-29 19:30:00	2006-10-29 20:45:00
285	142	2006-10-29 19:30:00	2006-10-29 20:45:00
285	50	2006-10-29 19:30:00	2006-10-29 20:45:00
285	100	2006-10-29 19:30:00	2006-10-29 20:45:00
285	103	2006-10-29 19:30:00	2006-10-29 20:45:00
285	51	2006-10-29 19:30:00	2006-10-29 20:45:00
285	52	2006-10-29 19:31:30	2006-10-29 20:45:00
285	233	2006-10-29 19:30:00	2006-10-29 20:45:00
285	132	2006-10-29 19:30:00	2006-10-29 20:45:00
285	116	2006-10-29 19:30:00	2006-10-29 20:45:00
285	160	2006-10-29 19:30:00	2006-10-29 20:45:00
285	316	2006-10-29 19:30:00	2006-10-29 20:45:00
285	167	2006-10-29 19:30:00	2006-10-29 20:45:00
285	57	2006-10-29 19:30:00	2006-10-29 20:45:00
285	153	2006-10-29 19:30:00	2006-10-29 20:45:00
285	60	2006-10-29 19:30:00	2006-10-29 20:45:00
290	1	2006-11-02 21:00:00	2006-11-02 23:50:00
290	284	2006-11-02 21:00:00	2006-11-02 23:50:00
290	4	2006-11-02 21:00:00	2006-11-02 23:50:00
290	5	2006-11-02 21:00:00	2006-11-02 23:50:00
290	135	2006-11-02 21:00:00	2006-11-02 23:50:00
290	8	2006-11-02 21:00:00	2006-11-02 23:50:00
290	322	2006-11-02 21:00:00	2006-11-02 22:38:46
290	15	2006-11-02 21:00:00	2006-11-02 23:50:00
290	23	2006-11-02 21:00:00	2006-11-02 23:50:00
290	157	2006-11-02 21:00:00	2006-11-02 23:50:00
290	161	2006-11-02 23:12:34	2006-11-02 23:50:00
290	27	2006-11-02 21:00:00	2006-11-02 23:50:00
290	28	2006-11-02 21:00:00	2006-11-02 23:50:00
290	30	2006-11-02 21:00:00	2006-11-02 23:50:00
290	31	2006-11-02 21:00:00	2006-11-02 22:49:04
290	32	2006-11-02 21:00:00	2006-11-02 23:50:00
290	299	2006-11-02 21:00:00	2006-11-02 23:50:00
290	33	2006-11-02 21:00:00	2006-11-02 23:50:00
290	154	2006-11-02 21:00:00	2006-11-02 23:50:00
290	136	2006-11-02 21:00:00	2006-11-02 23:50:00
290	234	2006-11-02 21:00:00	2006-11-02 23:25:36
290	36	2006-11-02 21:00:00	2006-11-02 23:50:00
290	155	2006-11-02 21:00:00	2006-11-02 23:50:00
290	39	2006-11-02 21:00:00	2006-11-02 23:50:00
290	41	2006-11-02 21:00:00	2006-11-02 23:50:00
290	319	2006-11-02 21:00:00	2006-11-02 22:48:32
290	43	2006-11-02 21:00:00	2006-11-02 23:50:00
290	270	2006-11-02 23:09:58	2006-11-02 23:50:00
290	45	2006-11-02 21:00:00	2006-11-02 23:50:00
290	142	2006-11-02 21:00:00	2006-11-02 23:50:00
290	48	2006-11-02 21:00:00	2006-11-02 23:50:00
290	50	2006-11-02 21:00:35	2006-11-02 23:50:00
290	100	2006-11-02 21:00:00	2006-11-02 23:50:00
290	103	2006-11-02 21:00:27	2006-11-02 23:50:00
290	51	2006-11-02 21:00:00	2006-11-02 23:50:00
290	52	2006-11-02 21:00:00	2006-11-02 23:50:00
290	148	2006-11-02 21:00:00	2006-11-02 23:50:00
290	116	2006-11-02 21:00:00	2006-11-02 23:50:00
290	160	2006-11-02 21:00:00	2006-11-02 22:51:06
290	316	2006-11-02 22:51:31	2006-11-02 23:50:00
290	55	2006-11-02 21:00:00	2006-11-02 23:50:00
290	59	2006-11-02 21:00:00	2006-11-02 23:50:00
290	60	2006-11-02 21:00:00	2006-11-02 23:50:00
291	284	2006-11-04 11:00:00	2006-11-04 15:20:00
291	348	2006-11-04 12:51:28	2006-11-04 15:20:00
291	206	2006-11-04 11:00:00	2006-11-04 15:20:00
291	5	2006-11-04 11:00:00	2006-11-04 15:20:00
291	156	2006-11-04 11:00:00	2006-11-04 15:20:00
291	189	2006-11-04 11:00:00	2006-11-04 14:15:44
291	8	2006-11-04 14:15:25	2006-11-04 15:20:00
291	90	2006-11-04 11:00:00	2006-11-04 14:13:02
291	235	2006-11-04 11:00:00	2006-11-04 14:13:33
291	123	2006-11-04 11:00:00	2006-11-04 12:56:05
291	325	2006-11-04 11:00:00	2006-11-04 15:20:00
291	157	2006-11-04 11:34:33	2006-11-04 15:20:00
291	164	2006-11-04 11:00:00	2006-11-04 15:20:00
291	111	2006-11-04 11:00:00	2006-11-04 14:02:22
291	39	2006-11-04 14:14:02	2006-11-04 15:20:00
291	319	2006-11-04 11:00:00	2006-11-04 12:27:48
291	259	2006-11-04 11:00:00	2006-11-04 15:20:00
291	270	2006-11-04 13:31:33	2006-11-04 15:20:00
291	44	2006-11-04 11:00:00	2006-11-04 15:20:00
291	142	2006-11-04 11:00:00	2006-11-04 15:20:00
291	326	2006-11-04 11:00:00	2006-11-04 15:20:00
291	48	2006-11-04 14:15:07	2006-11-04 14:57:59
291	220	2006-11-04 15:03:14	2006-11-04 15:20:00
291	51	2006-11-04 12:31:13	2006-11-04 15:20:00
291	312	2006-11-04 11:00:00	2006-11-04 12:46:22
291	148	2006-11-04 12:46:51	2006-11-04 13:30:56
291	307	2006-11-04 11:00:00	2006-11-04 14:15:27
291	132	2006-11-04 14:13:41	2006-11-04 15:20:00
291	109	2006-11-04 11:00:00	2006-11-04 15:20:00
291	89	2006-11-04 11:00:00	2006-11-04 15:20:00
291	282	2006-11-04 11:00:00	2006-11-04 15:20:00
291	231	2006-11-04 11:00:00	2006-11-04 15:02:38
292	301	2006-11-04 19:45:00	2006-11-04 20:15:00
292	284	2006-11-04 19:45:00	2006-11-04 20:15:00
292	2	2006-11-04 19:45:00	2006-11-04 20:12:43
292	348	2006-11-04 19:45:00	2006-11-04 20:15:00
292	156	2006-11-04 19:45:00	2006-11-04 20:15:00
292	135	2006-11-04 19:45:00	2006-11-04 20:15:00
292	90	2006-11-04 19:45:00	2006-11-04 20:15:00
292	123	2006-11-04 19:45:00	2006-11-04 20:15:00
292	325	2006-11-04 19:45:00	2006-11-04 20:15:00
292	21	2006-11-04 19:45:00	2006-11-04 20:15:00
292	280	2006-11-04 19:45:00	2006-11-04 20:15:00
292	213	2006-11-04 19:45:00	2006-11-04 20:15:00
292	274	2006-11-04 19:45:00	2006-11-04 20:15:00
292	164	2006-11-04 19:45:00	2006-11-04 20:15:00
292	215	2006-11-04 19:45:00	2006-11-04 20:15:00
292	154	2006-11-04 19:45:00	2006-11-04 20:15:00
292	285	2006-11-04 19:45:00	2006-11-04 20:15:00
292	136	2006-11-04 19:45:00	2006-11-04 20:15:00
292	234	2006-11-04 19:45:00	2006-11-04 20:15:00
292	36	2006-11-04 19:45:00	2006-11-04 20:10:41
292	150	2006-11-04 19:45:00	2006-11-04 20:15:00
292	155	2006-11-04 19:45:00	2006-11-04 20:15:00
292	259	2006-11-04 19:45:00	2006-11-04 20:14:10
292	44	2006-11-04 19:45:00	2006-11-04 20:13:57
292	261	2006-11-04 19:45:00	2006-11-04 20:12:41
292	106	2006-11-04 19:45:00	2006-11-04 20:15:00
292	100	2006-11-04 19:45:00	2006-11-04 20:13:33
292	293	2006-11-04 19:45:00	2006-11-04 20:15:00
292	339	2006-11-04 19:45:00	2006-11-04 20:15:00
292	223	2006-11-04 19:45:00	2006-11-04 20:15:00
292	307	2006-11-04 19:45:00	2006-11-04 20:15:00
292	132	2006-11-04 19:45:00	2006-11-04 20:15:00
292	109	2006-11-04 19:45:00	2006-11-04 20:15:00
292	316	2006-11-04 19:45:00	2006-11-04 20:15:00
292	118	2006-11-04 19:45:00	2006-11-04 20:15:00
292	153	2006-11-04 19:45:00	2006-11-04 20:14:55
292	56	2006-11-04 19:45:00	2006-11-04 20:15:00
292	282	2006-11-04 19:45:00	2006-11-04 20:15:00
292	66	2006-11-04 19:45:00	2006-11-04 20:15:00
292	59	2006-11-04 19:45:00	2006-11-04 20:15:00
293	301	2006-11-04 21:45:00	2006-11-05 00:00:00
293	284	2006-11-04 21:45:00	2006-11-05 00:00:00
293	239	2006-11-04 21:45:00	2006-11-05 00:00:00
293	348	2006-11-04 21:45:00	2006-11-05 00:00:00
293	4	2006-11-04 22:20:07	2006-11-04 23:10:33
293	156	2006-11-04 21:45:00	2006-11-05 00:00:00
293	135	2006-11-04 21:45:00	2006-11-05 00:00:00
293	275	2006-11-04 21:45:00	2006-11-04 23:59:25
293	90	2006-11-04 21:45:00	2006-11-05 00:00:00
293	235	2006-11-04 21:45:00	2006-11-05 00:00:00
293	217	2006-11-04 21:45:00	2006-11-05 00:00:00
293	123	2006-11-04 21:45:00	2006-11-05 00:00:00
293	18	2006-11-04 21:45:00	2006-11-04 23:59:52
293	325	2006-11-04 21:45:00	2006-11-04 21:46:52
293	21	2006-11-04 21:45:00	2006-11-05 00:00:00
293	280	2006-11-04 21:45:00	2006-11-05 00:00:00
293	213	2006-11-04 21:45:00	2006-11-05 00:00:00
293	245	2006-11-04 21:45:00	2006-11-05 00:00:00
293	274	2006-11-04 21:45:00	2006-11-05 00:00:00
293	31	2006-11-04 21:45:00	2006-11-05 00:00:00
293	164	2006-11-04 21:45:00	2006-11-05 00:00:00
293	215	2006-11-04 21:45:00	2006-11-05 00:00:00
293	154	2006-11-04 21:45:00	2006-11-05 00:00:00
293	285	2006-11-04 21:45:00	2006-11-05 00:00:00
293	234	2006-11-04 21:45:00	2006-11-04 23:22:34
293	36	2006-11-04 21:45:00	2006-11-05 00:00:00
293	150	2006-11-04 21:45:00	2006-11-05 00:00:00
293	349	2006-11-04 21:47:05	2006-11-05 00:00:00
293	202	2006-11-04 21:45:00	2006-11-05 00:00:00
293	259	2006-11-04 21:45:00	2006-11-05 00:00:00
293	326	2006-11-04 21:45:00	2006-11-05 00:00:00
293	297	2006-11-04 21:45:00	2006-11-05 00:00:00
293	106	2006-11-04 21:45:00	2006-11-05 00:00:00
293	220	2006-11-04 21:45:00	2006-11-05 00:00:00
293	340	2006-11-04 21:45:00	2006-11-04 23:59:58
293	100	2006-11-04 21:45:00	2006-11-05 00:00:00
293	293	2006-11-04 21:45:00	2006-11-05 00:00:00
293	114	2006-11-04 21:45:00	2006-11-05 00:00:00
293	339	2006-11-04 21:45:00	2006-11-05 00:00:00
293	229	2006-11-04 21:45:00	2006-11-05 00:00:00
293	188	2006-11-04 23:25:35	2006-11-05 00:00:00
293	223	2006-11-04 21:45:00	2006-11-05 00:00:00
293	307	2006-11-04 21:45:00	2006-11-05 00:00:00
293	132	2006-11-04 21:45:00	2006-11-05 00:00:00
293	337	2006-11-04 21:46:05	2006-11-04 23:59:58
293	109	2006-11-04 21:45:00	2006-11-05 00:00:00
293	316	2006-11-04 21:45:00	2006-11-05 00:00:00
293	240	2006-11-04 21:49:42	2006-11-05 00:00:00
293	118	2006-11-04 21:45:00	2006-11-05 00:00:00
293	56	2006-11-04 21:45:00	2006-11-05 00:00:00
293	282	2006-11-04 21:45:00	2006-11-05 00:00:00
293	66	2006-11-04 21:45:00	2006-11-04 23:59:48
293	59	2006-11-04 21:45:00	2006-11-05 00:00:00
294	1	2006-11-05 19:30:00	2006-11-06 00:15:00
294	284	2006-11-05 19:30:00	2006-11-06 00:15:00
294	2	2006-11-05 19:30:00	2006-11-06 00:15:00
294	4	2006-11-05 19:45:02	2006-11-06 00:15:00
294	206	2006-11-05 19:30:00	2006-11-06 00:15:00
294	5	2006-11-05 19:30:00	2006-11-06 00:15:00
294	8	2006-11-05 19:30:00	2006-11-06 00:15:00
294	90	2006-11-05 19:30:00	2006-11-06 00:15:00
294	15	2006-11-05 19:30:00	2006-11-06 00:15:00
294	16	2006-11-05 22:57:05	2006-11-06 00:15:00
294	19	2006-11-05 23:37:51	2006-11-06 00:15:00
294	21	2006-11-05 19:30:00	2006-11-06 00:15:00
294	23	2006-11-05 19:30:00	2006-11-05 23:48:46
294	157	2006-11-05 19:30:00	2006-11-05 23:46:51
294	27	2006-11-05 19:30:00	2006-11-06 00:15:00
294	28	2006-11-05 19:30:00	2006-11-06 00:15:00
294	232	2006-11-05 19:30:00	2006-11-06 00:15:00
294	31	2006-11-05 19:30:00	2006-11-05 23:32:46
294	32	2006-11-05 19:30:00	2006-11-06 00:15:00
294	33	2006-11-05 19:30:00	2006-11-06 00:15:00
294	136	2006-11-05 19:30:00	2006-11-06 00:15:00
294	36	2006-11-05 19:30:00	2006-11-06 00:15:00
294	155	2006-11-05 19:30:00	2006-11-06 00:15:00
294	39	2006-11-05 19:30:00	2006-11-06 00:15:00
294	40	2006-11-05 23:35:27	2006-11-06 00:15:00
294	41	2006-11-05 19:30:00	2006-11-06 00:15:00
294	42	2006-11-05 21:28:01	2006-11-06 00:15:00
294	43	2006-11-05 19:30:00	2006-11-06 00:15:00
294	259	2006-11-05 19:30:00	2006-11-06 00:15:00
294	270	2006-11-05 19:30:00	2006-11-06 00:15:00
294	45	2006-11-05 22:13:45	2006-11-06 00:15:00
294	48	2006-11-05 19:30:00	2006-11-05 19:44:17
294	50	2006-11-05 19:30:00	2006-11-06 00:15:00
294	100	2006-11-05 19:30:00	2006-11-06 00:15:00
294	103	2006-11-05 19:30:00	2006-11-06 00:15:00
294	51	2006-11-05 19:30:00	2006-11-06 00:15:00
294	52	2006-11-05 19:30:00	2006-11-06 00:15:00
294	148	2006-11-05 19:30:00	2006-11-06 00:15:00
294	233	2006-11-05 19:30:00	2006-11-06 00:15:00
294	132	2006-11-05 19:30:00	2006-11-06 00:15:00
294	116	2006-11-05 19:30:00	2006-11-06 00:15:00
294	160	2006-11-05 19:30:00	2006-11-06 00:15:00
294	89	2006-11-05 19:30:00	2006-11-06 00:15:00
294	55	2006-11-05 19:30:00	2006-11-05 22:13:19
294	153	2006-11-05 19:30:00	2006-11-06 00:15:00
294	282	2006-11-05 19:30:00	2006-11-05 21:27:55
294	60	2006-11-05 19:30:00	2006-11-06 00:15:00
295	284	2006-11-06 21:00:00	2006-11-06 23:55:00
295	239	2006-11-06 21:00:00	2006-11-06 23:55:00
295	348	2006-11-06 21:00:00	2006-11-06 23:55:00
295	7	2006-11-06 21:00:00	2006-11-06 23:55:00
295	189	2006-11-06 23:04:18	2006-11-06 23:55:00
295	90	2006-11-06 21:00:00	2006-11-06 23:55:00
295	322	2006-11-06 21:00:00	2006-11-06 23:53:38
295	235	2006-11-06 21:08:02	2006-11-06 23:55:00
295	13	2006-11-06 21:11:17	2006-11-06 23:06:43
295	217	2006-11-06 21:00:00	2006-11-06 21:33:11
295	123	2006-11-06 21:00:00	2006-11-06 23:55:00
295	274	2006-11-06 22:30:28	2006-11-06 23:55:00
295	31	2006-11-06 21:00:00	2006-11-06 23:55:00
295	32	2006-11-06 23:04:22	2006-11-06 23:55:00
295	314	2006-11-06 21:54:21	2006-11-06 23:55:00
295	154	2006-11-06 21:00:00	2006-11-06 23:55:00
295	279	2006-11-06 23:21:19	2006-11-06 23:55:00
295	285	2006-11-06 21:00:00	2006-11-06 23:55:00
295	236	2006-11-06 21:19:46	2006-11-06 22:22:19
295	234	2006-11-06 21:00:00	2006-11-06 21:44:31
295	36	2006-11-06 21:00:00	2006-11-06 23:55:00
295	150	2006-11-06 21:00:00	2006-11-06 23:55:00
295	84	2006-11-06 21:00:00	2006-11-06 23:55:00
295	270	2006-11-06 21:00:00	2006-11-06 23:55:00
295	44	2006-11-06 21:00:00	2006-11-06 23:55:00
295	354	2006-11-06 21:00:00	2006-11-06 23:55:00
295	220	2006-11-06 21:00:00	2006-11-06 23:55:00
295	340	2006-11-06 21:00:00	2006-11-06 23:55:00
295	338	2006-11-06 21:02:47	2006-11-06 23:55:00
295	114	2006-11-06 21:00:00	2006-11-06 23:21:12
295	223	2006-11-06 21:00:00	2006-11-06 23:55:00
295	148	2006-11-06 21:00:00	2006-11-06 23:55:00
295	307	2006-11-06 21:00:00	2006-11-06 23:55:00
295	132	2006-11-06 21:00:00	2006-11-06 23:55:00
295	337	2006-11-06 21:02:36	2006-11-06 23:55:00
295	160	2006-11-06 23:08:23	2006-11-06 23:55:00
295	152	2006-11-06 21:00:00	2006-11-06 23:55:00
295	54	2006-11-06 21:00:00	2006-11-06 21:14:31
295	240	2006-11-06 21:00:00	2006-11-06 23:55:00
295	89	2006-11-06 21:00:00	2006-11-06 23:55:00
295	76	2006-11-06 21:00:00	2006-11-06 23:55:00
295	167	2006-11-06 21:33:19	2006-11-06 22:58:41
295	118	2006-11-06 21:00:00	2006-11-06 23:55:00
295	55	2006-11-06 21:12:00	2006-11-06 23:55:00
295	328	2006-11-06 21:00:00	2006-11-06 23:55:00
295	251	2006-11-06 21:00:00	2006-11-06 22:54:25
295	56	2006-11-06 21:00:00	2006-11-06 23:55:00
295	282	2006-11-06 21:00:00	2006-11-06 23:55:00
295	59	2006-11-06 21:00:00	2006-11-06 23:55:00
297	1	2006-11-11 14:48:24	2006-11-11 15:10:00
297	284	2006-11-11 11:30:00	2006-11-11 15:10:00
297	203	2006-11-11 11:30:00	2006-11-11 15:10:00
297	7	2006-11-11 11:30:00	2006-11-11 15:10:00
297	156	2006-11-11 11:30:00	2006-11-11 15:10:00
297	8	2006-11-11 14:49:31	2006-11-11 15:10:00
297	90	2006-11-11 11:30:00	2006-11-11 15:10:00
297	235	2006-11-11 11:30:00	2006-11-11 15:10:00
297	123	2006-11-11 12:01:41	2006-11-11 15:10:00
297	356	2006-11-11 12:19:48	2006-11-11 15:10:00
297	245	2006-11-11 11:30:00	2006-11-11 15:10:00
297	158	2006-11-11 11:30:00	2006-11-11 15:10:00
297	36	2006-11-11 13:50:40	2006-11-11 15:10:00
297	84	2006-11-11 11:58:56	2006-11-11 15:10:00
297	111	2006-11-11 11:30:00	2006-11-11 15:10:00
297	40	2006-11-11 12:20:34	2006-11-11 14:48:12
297	319	2006-11-11 11:30:00	2006-11-11 15:10:00
297	326	2006-11-11 11:30:00	2006-11-11 15:10:00
297	293	2006-11-11 11:30:00	2006-11-11 15:10:00
297	114	2006-11-11 11:30:00	2006-11-11 11:58:45
297	339	2006-11-11 11:30:00	2006-11-11 15:10:00
297	327	2006-11-11 11:30:00	2006-11-11 11:56:24
297	148	2006-11-11 11:30:00	2006-11-11 13:38:26
297	307	2006-11-11 11:30:00	2006-11-11 14:49:00
297	240	2006-11-11 11:30:00	2006-11-11 15:10:00
297	282	2006-11-11 11:30:00	2006-11-11 15:10:00
297	231	2006-11-11 11:30:00	2006-11-11 15:10:00
298	284	2006-11-11 20:00:00	2006-11-11 20:45:00
298	143	2006-11-11 20:00:00	2006-11-11 20:45:00
298	7	2006-11-11 20:00:00	2006-11-11 20:45:00
298	156	2006-11-11 20:00:00	2006-11-11 20:45:00
298	335	2006-11-11 20:00:00	2006-11-11 20:45:00
298	90	2006-11-11 20:00:00	2006-11-11 20:45:00
298	322	2006-11-11 20:00:00	2006-11-11 20:45:00
298	235	2006-11-11 20:00:00	2006-11-11 20:45:00
298	217	2006-11-11 20:06:50	2006-11-11 20:45:00
298	16	2006-11-11 20:00:00	2006-11-11 20:45:00
298	123	2006-11-11 20:00:00	2006-11-11 20:45:00
298	19	2006-11-11 20:00:00	2006-11-11 20:45:00
298	245	2006-11-11 20:00:00	2006-11-11 20:45:00
298	31	2006-11-11 20:00:00	2006-11-11 20:45:00
298	299	2006-11-11 20:00:00	2006-11-11 20:45:00
298	154	2006-11-11 20:00:00	2006-11-11 20:45:00
298	285	2006-11-11 20:00:00	2006-11-11 20:45:00
298	136	2006-11-11 20:00:00	2006-11-11 20:45:00
298	158	2006-11-11 20:00:00	2006-11-11 20:45:00
298	257	2006-11-11 20:00:00	2006-11-11 20:45:00
298	259	2006-11-11 20:00:00	2006-11-11 20:45:00
298	270	2006-11-11 20:00:00	2006-11-11 20:45:00
298	45	2006-11-11 20:00:00	2006-11-11 20:45:00
298	326	2006-11-11 20:00:00	2006-11-11 20:45:00
298	261	2006-11-11 20:00:00	2006-11-11 20:45:00
298	106	2006-11-11 20:00:00	2006-11-11 20:45:00
298	249	2006-11-11 20:00:00	2006-11-11 20:45:00
298	100	2006-11-11 20:00:00	2006-11-11 20:45:00
298	188	2006-11-11 20:00:00	2006-11-11 20:45:00
298	148	2006-11-11 20:00:00	2006-11-11 20:45:00
298	132	2006-11-11 20:00:00	2006-11-11 20:45:00
298	75	2006-11-11 20:00:00	2006-11-11 20:45:00
298	109	2006-11-11 20:00:00	2006-11-11 20:45:00
298	153	2006-11-11 20:00:00	2006-11-11 20:45:00
298	56	2006-11-11 20:00:00	2006-11-11 20:45:00
298	282	2006-11-11 20:00:00	2006-11-11 20:45:00
298	66	2006-11-11 20:00:00	2006-11-11 20:45:00
298	59	2006-11-11 20:00:00	2006-11-11 20:45:00
299	284	2006-11-11 21:30:00	2006-11-12 00:45:00
299	143	2006-11-11 21:30:00	2006-11-12 00:45:00
299	3	2006-11-11 21:30:00	2006-11-12 00:45:00
299	357	2006-11-11 21:49:42	2006-11-12 00:45:00
299	4	2006-11-11 23:35:38	2006-11-12 00:03:20
299	7	2006-11-11 21:30:00	2006-11-12 00:45:00
299	156	2006-11-11 21:30:00	2006-11-12 00:45:00
299	135	2006-11-11 21:30:00	2006-11-12 00:45:00
299	335	2006-11-11 21:30:00	2006-11-12 00:45:00
299	90	2006-11-11 21:30:00	2006-11-12 00:45:00
299	322	2006-11-11 21:30:00	2006-11-12 00:45:00
299	235	2006-11-11 21:30:00	2006-11-12 00:45:00
299	123	2006-11-11 21:30:00	2006-11-12 00:45:00
299	19	2006-11-11 21:30:00	2006-11-12 00:45:00
299	26	2006-11-11 21:30:00	2006-11-12 00:45:00
299	245	2006-11-11 21:30:00	2006-11-12 00:45:00
299	31	2006-11-11 23:36:34	2006-11-12 00:00:55
299	154	2006-11-11 21:30:00	2006-11-12 00:45:00
299	285	2006-11-11 21:30:00	2006-11-12 00:45:00
299	236	2006-11-11 21:30:00	2006-11-12 00:45:00
299	136	2006-11-11 21:30:00	2006-11-12 00:45:00
299	158	2006-11-11 21:30:00	2006-11-12 00:45:00
299	257	2006-11-11 21:30:00	2006-11-12 00:45:00
299	150	2006-11-11 21:30:00	2006-11-12 00:45:00
299	269	2006-11-11 21:31:16	2006-11-11 22:17:34
299	120	2006-11-11 21:30:00	2006-11-12 00:45:00
299	202	2006-11-11 21:30:00	2006-11-11 22:45:41
299	319	2006-11-11 21:30:00	2006-11-12 00:45:00
299	326	2006-11-11 21:30:00	2006-11-12 00:45:00
299	297	2006-11-11 22:46:54	2006-11-12 00:45:00
299	106	2006-11-11 22:28:28	2006-11-11 22:45:56
299	187	2006-11-11 21:32:55	2006-11-12 00:45:00
299	249	2006-11-11 21:30:00	2006-11-12 00:45:00
299	340	2006-11-11 22:46:29	2006-11-12 00:45:00
299	114	2006-11-11 21:30:00	2006-11-12 00:45:00
299	103	2006-11-11 21:30:00	2006-11-12 00:45:00
299	188	2006-11-11 21:30:00	2006-11-12 00:45:00
299	358	2006-11-11 21:30:00	2006-11-12 00:07:27
299	207	2006-11-11 21:30:00	2006-11-12 00:45:00
299	347	2006-11-11 21:30:00	2006-11-12 00:45:00
299	132	2006-11-11 21:30:00	2006-11-12 00:45:00
299	116	2006-11-11 21:30:00	2006-11-12 00:45:00
299	75	2006-11-11 21:30:00	2006-11-12 00:45:00
299	281	2006-11-11 21:30:00	2006-11-12 00:45:00
299	212	2006-11-11 21:30:00	2006-11-12 00:45:00
299	55	2006-11-11 21:30:00	2006-11-12 00:45:00
299	328	2006-11-11 21:32:18	2006-11-12 00:45:00
299	56	2006-11-11 21:30:00	2006-11-12 00:45:00
299	282	2006-11-11 21:30:00	2006-11-12 00:45:00
299	231	2006-11-11 21:30:00	2006-11-12 00:45:00
299	355	2006-11-11 21:30:00	2006-11-12 00:45:00
299	66	2006-11-11 21:30:00	2006-11-12 00:45:00
299	59	2006-11-11 21:30:00	2006-11-12 00:02:35
300	1	2006-11-12 19:30:00	2006-11-13 00:30:00
300	284	2006-11-12 19:30:00	2006-11-13 00:30:00
300	2	2006-11-12 19:30:00	2006-11-13 00:30:00
300	143	2006-11-12 23:09:50	2006-11-12 23:17:28
300	4	2006-11-12 19:30:00	2006-11-13 00:30:00
300	7	2006-11-12 19:30:00	2006-11-13 00:30:00
300	135	2006-11-12 19:30:00	2006-11-13 00:30:00
300	8	2006-11-12 19:30:00	2006-11-13 00:08:30
300	13	2006-11-12 19:33:24	2006-11-12 21:51:38
300	15	2006-11-12 19:30:00	2006-11-13 00:30:00
300	16	2006-11-12 22:41:09	2006-11-13 00:30:00
300	123	2006-11-12 19:30:00	2006-11-12 23:44:20
300	19	2006-11-12 19:30:00	2006-11-13 00:30:00
300	21	2006-11-12 20:00:56	2006-11-13 00:30:00
300	157	2006-11-12 19:30:00	2006-11-13 00:08:32
300	27	2006-11-12 19:30:00	2006-11-13 00:30:00
300	28	2006-11-12 19:30:00	2006-11-13 00:30:00
300	232	2006-11-12 19:30:00	2006-11-13 00:30:00
300	32	2006-11-12 19:30:00	2006-11-13 00:30:00
300	119	2006-11-13 00:14:36	2006-11-13 00:30:00
300	136	2006-11-12 19:45:42	2006-11-13 00:30:00
300	36	2006-11-12 19:30:00	2006-11-13 00:30:00
300	257	2006-11-12 19:30:00	2006-11-12 22:54:06
300	155	2006-11-12 19:30:00	2006-11-13 00:30:00
300	39	2006-11-12 19:30:00	2006-11-13 00:30:00
300	40	2006-11-12 19:30:00	2006-11-13 00:30:00
300	319	2006-11-12 19:30:51	2006-11-13 00:30:00
300	42	2006-11-12 19:30:00	2006-11-13 00:30:00
300	259	2006-11-12 19:30:00	2006-11-12 22:49:16
300	270	2006-11-12 19:30:00	2006-11-12 19:56:56
300	44	2006-11-12 19:30:00	2006-11-13 00:08:29
300	45	2006-11-12 19:30:00	2006-11-13 00:30:00
300	48	2006-11-12 19:30:00	2006-11-13 00:30:00
300	50	2006-11-12 21:52:13	2006-11-13 00:30:00
300	100	2006-11-12 19:30:00	2006-11-13 00:30:00
300	103	2006-11-12 19:30:00	2006-11-13 00:30:00
300	51	2006-11-12 19:30:00	2006-11-13 00:30:00
300	223	2006-11-13 00:13:37	2006-11-13 00:30:00
300	233	2006-11-12 19:30:00	2006-11-13 00:30:00
300	132	2006-11-12 23:46:41	2006-11-13 00:30:00
300	116	2006-11-12 19:30:00	2006-11-13 00:30:00
300	109	2006-11-12 19:30:00	2006-11-13 00:30:00
300	160	2006-11-12 19:30:00	2006-11-13 00:07:56
300	205	2006-11-13 00:24:41	2006-11-13 00:30:00
300	152	2006-11-13 00:13:41	2006-11-13 00:30:00
300	76	2006-11-12 19:30:00	2006-11-13 00:30:00
300	167	2006-11-12 19:30:00	2006-11-12 22:40:44
300	55	2006-11-12 23:18:05	2006-11-13 00:30:00
300	153	2006-11-12 19:30:00	2006-11-13 00:30:00
300	282	2006-11-12 19:30:00	2006-11-13 00:30:00
300	66	2006-11-12 23:09:46	2006-11-13 00:30:00
300	60	2006-11-12 19:30:00	2006-11-13 00:30:00
301	284	2006-11-13 21:30:00	2006-11-14 00:45:00
301	143	2006-11-13 21:30:00	2006-11-14 00:45:00
301	357	2006-11-13 21:30:00	2006-11-14 00:45:00
301	348	2006-11-13 21:30:00	2006-11-14 00:45:00
301	335	2006-11-13 21:30:00	2006-11-13 23:13:42
301	90	2006-11-13 21:30:00	2006-11-14 00:45:00
301	235	2006-11-13 21:30:00	2006-11-13 23:32:40
301	217	2006-11-13 21:30:00	2006-11-14 00:45:00
301	123	2006-11-13 21:30:00	2006-11-14 00:45:00
301	325	2006-11-13 21:30:00	2006-11-14 00:45:00
301	28	2006-11-13 21:30:00	2006-11-14 00:01:46
301	245	2006-11-13 21:30:00	2006-11-14 00:23:37
301	274	2006-11-13 21:30:00	2006-11-14 00:45:00
301	31	2006-11-13 21:30:00	2006-11-14 00:45:00
301	299	2006-11-13 22:06:59	2006-11-14 00:45:00
301	314	2006-11-13 23:09:35	2006-11-14 00:45:00
301	154	2006-11-13 21:30:00	2006-11-14 00:45:00
301	279	2006-11-13 21:30:00	2006-11-14 00:45:00
301	285	2006-11-13 21:30:00	2006-11-14 00:45:00
301	236	2006-11-13 21:30:00	2006-11-13 23:07:19
301	136	2006-11-14 00:02:48	2006-11-14 00:45:00
301	234	2006-11-13 21:30:00	2006-11-14 00:45:00
301	158	2006-11-13 21:30:00	2006-11-14 00:45:00
301	36	2006-11-13 23:10:23	2006-11-13 23:32:32
301	150	2006-11-13 21:30:00	2006-11-14 00:45:00
301	349	2006-11-13 21:30:00	2006-11-14 00:45:00
301	269	2006-11-13 21:30:00	2006-11-13 21:41:47
301	124	2006-11-13 21:32:15	2006-11-14 00:45:00
301	71	2006-11-13 21:30:00	2006-11-14 00:45:00
301	270	2006-11-13 21:30:00	2006-11-14 00:45:00
301	297	2006-11-13 21:30:18	2006-11-14 00:45:00
301	354	2006-11-13 21:45:44	2006-11-14 00:45:00
301	220	2006-11-13 21:30:00	2006-11-14 00:45:00
301	340	2006-11-13 21:30:00	2006-11-14 00:45:00
301	293	2006-11-13 23:37:46	2006-11-14 00:45:00
301	114	2006-11-13 23:14:30	2006-11-14 00:45:00
301	358	2006-11-13 21:30:00	2006-11-14 00:45:00
301	223	2006-11-13 21:30:00	2006-11-14 00:45:00
301	148	2006-11-13 21:30:00	2006-11-13 23:55:46
301	132	2006-11-13 21:30:00	2006-11-14 00:45:00
301	160	2006-11-13 21:30:00	2006-11-14 00:45:00
301	152	2006-11-13 21:30:00	2006-11-14 00:45:00
301	240	2006-11-13 21:30:00	2006-11-14 00:45:00
301	76	2006-11-13 22:11:07	2006-11-14 00:45:00
301	212	2006-11-13 21:30:00	2006-11-14 00:45:00
301	55	2006-11-13 21:30:00	2006-11-14 00:45:00
301	251	2006-11-13 21:30:00	2006-11-14 00:45:00
301	153	2006-11-14 00:25:20	2006-11-14 00:45:00
301	56	2006-11-13 21:30:00	2006-11-14 00:45:00
301	282	2006-11-13 21:30:00	2006-11-13 21:41:32
301	355	2006-11-13 21:30:00	2006-11-14 00:45:00
301	66	2006-11-13 21:30:00	2006-11-14 00:45:00
301	59	2006-11-13 21:30:00	2006-11-14 00:45:00
302	1	2006-11-14 21:00:00	2006-11-15 00:10:00
302	284	2006-11-14 21:00:00	2006-11-15 00:00:29
302	143	2006-11-14 21:00:00	2006-11-14 23:16:18
302	348	2006-11-14 21:00:00	2006-11-15 00:10:00
302	206	2006-11-14 21:00:00	2006-11-15 00:10:00
302	5	2006-11-14 21:00:00	2006-11-15 00:10:00
302	7	2006-11-14 21:00:00	2006-11-15 00:10:00
302	135	2006-11-14 21:00:00	2006-11-15 00:10:00
302	123	2006-11-14 21:00:00	2006-11-15 00:10:00
302	325	2006-11-14 22:48:25	2006-11-15 00:10:00
302	21	2006-11-14 21:00:00	2006-11-15 00:10:00
302	157	2006-11-14 21:00:00	2006-11-14 22:07:33
302	27	2006-11-14 21:00:00	2006-11-15 00:10:00
302	28	2006-11-14 21:00:00	2006-11-15 00:10:00
302	30	2006-11-14 21:00:00	2006-11-15 00:10:00
302	32	2006-11-14 22:48:57	2006-11-15 00:10:00
302	33	2006-11-14 21:00:00	2006-11-15 00:10:00
302	154	2006-11-14 21:00:00	2006-11-15 00:10:00
302	136	2006-11-14 21:00:00	2006-11-15 00:10:00
302	36	2006-11-14 21:00:00	2006-11-15 00:10:00
302	155	2006-11-14 21:00:00	2006-11-15 00:10:00
302	269	2006-11-14 23:30:47	2006-11-15 00:10:00
302	39	2006-11-14 21:00:00	2006-11-15 00:10:00
302	40	2006-11-14 21:00:00	2006-11-15 00:10:00
302	41	2006-11-14 21:00:00	2006-11-15 00:10:00
302	319	2006-11-14 21:00:00	2006-11-14 22:48:30
302	259	2006-11-14 21:00:00	2006-11-15 00:10:00
302	44	2006-11-14 21:00:00	2006-11-15 00:10:00
302	45	2006-11-14 21:00:00	2006-11-15 00:10:00
302	142	2006-11-14 21:00:00	2006-11-14 23:35:05
302	297	2006-11-14 21:00:00	2006-11-14 22:13:05
302	354	2006-11-14 22:09:59	2006-11-15 00:10:00
302	48	2006-11-14 21:00:00	2006-11-15 00:10:00
302	227	2006-11-14 22:22:33	2006-11-15 00:10:00
302	100	2006-11-14 21:00:00	2006-11-15 00:10:00
302	103	2006-11-14 21:00:00	2006-11-15 00:10:00
302	51	2006-11-14 21:44:41	2006-11-15 00:10:00
302	222	2006-11-14 21:00:00	2006-11-15 00:10:00
302	223	2006-11-14 21:00:00	2006-11-15 00:10:00
302	233	2006-11-14 21:00:00	2006-11-15 00:10:00
302	116	2006-11-14 21:00:00	2006-11-15 00:10:00
302	160	2006-11-14 21:00:00	2006-11-14 23:18:03
302	167	2006-11-14 21:00:00	2006-11-14 22:47:24
302	153	2006-11-14 21:00:00	2006-11-14 21:44:37
302	282	2006-11-14 23:48:26	2006-11-15 00:10:00
302	66	2006-11-14 21:00:00	2006-11-15 00:10:00
302	59	2006-11-14 21:00:00	2006-11-15 00:10:00
302	60	2006-11-14 21:00:00	2006-11-15 00:10:00
311	284	2006-11-25 11:00:00	2006-11-25 13:39:52
311	357	2006-11-25 11:00:00	2006-11-25 16:00:00
308	284	2006-11-20 21:15:00	2006-11-21 00:45:00
308	4	2006-11-20 21:15:00	2006-11-21 00:45:00
308	335	2006-11-20 21:15:00	2006-11-20 23:28:33
308	275	2006-11-20 23:53:41	2006-11-21 00:45:00
308	90	2006-11-20 21:15:00	2006-11-21 00:45:00
308	235	2006-11-20 21:15:00	2006-11-21 00:45:00
308	13	2006-11-20 21:15:00	2006-11-21 00:45:00
308	217	2006-11-20 22:41:42	2006-11-21 00:45:00
308	280	2006-11-20 21:15:00	2006-11-21 00:45:00
308	98	2006-11-20 21:15:00	2006-11-21 00:45:00
308	245	2006-11-20 21:15:00	2006-11-21 00:45:00
308	299	2006-11-20 22:38:12	2006-11-21 00:45:00
308	314	2006-11-20 23:41:02	2006-11-21 00:45:00
308	177	2006-11-20 21:15:00	2006-11-20 23:29:22
308	154	2006-11-20 21:15:00	2006-11-21 00:45:00
308	285	2006-11-20 21:15:00	2006-11-21 00:45:00
303	154	2006-11-16 21:00:00	2006-11-16 21:57:40
308	234	2006-11-20 21:15:00	2006-11-20 22:37:11
308	257	2006-11-20 21:15:00	2006-11-21 00:45:00
308	150	2006-11-20 21:15:00	2006-11-21 00:45:00
308	359	2006-11-20 21:16:10	2006-11-21 00:45:00
308	349	2006-11-20 21:15:00	2006-11-21 00:45:00
308	270	2006-11-20 21:15:00	2006-11-21 00:45:00
308	297	2006-11-20 21:15:00	2006-11-21 00:45:00
308	220	2006-11-20 21:15:00	2006-11-21 00:45:00
308	340	2006-11-20 21:15:00	2006-11-21 00:45:00
308	338	2006-11-20 21:15:00	2006-11-21 00:45:00
308	114	2006-11-20 21:15:00	2006-11-21 00:45:00
308	339	2006-11-20 21:15:00	2006-11-21 00:45:00
308	222	2006-11-20 23:29:42	2006-11-21 00:45:00
308	223	2006-11-20 21:15:00	2006-11-21 00:45:00
308	132	2006-11-20 21:15:00	2006-11-21 00:45:00
308	337	2006-11-20 21:15:00	2006-11-21 00:45:00
308	75	2006-11-20 21:15:00	2006-11-21 00:45:00
308	109	2006-11-20 21:15:00	2006-11-21 00:45:00
308	205	2006-11-20 21:15:00	2006-11-21 00:45:00
308	152	2006-11-20 21:15:00	2006-11-20 23:52:49
308	54	2006-11-20 21:15:00	2006-11-21 00:45:00
308	240	2006-11-20 21:15:00	2006-11-21 00:45:00
308	89	2006-11-20 21:15:00	2006-11-21 00:45:00
308	76	2006-11-20 21:15:00	2006-11-21 00:45:00
308	167	2006-11-20 21:15:00	2006-11-20 22:36:01
308	118	2006-11-20 21:15:00	2006-11-21 00:45:00
308	328	2006-11-20 21:15:00	2006-11-21 00:45:00
308	251	2006-11-20 21:15:00	2006-11-21 00:45:00
308	56	2006-11-20 21:15:00	2006-11-21 00:45:00
308	282	2006-11-20 21:15:00	2006-11-21 00:45:00
308	66	2006-11-20 21:15:00	2006-11-21 00:45:00
308	59	2006-11-20 21:15:00	2006-11-21 00:45:00
311	5	2006-11-25 14:59:31	2006-11-25 16:00:00
311	189	2006-11-25 11:00:00	2006-11-25 16:00:00
311	90	2006-11-25 11:00:00	2006-11-25 16:00:00
311	235	2006-11-25 11:00:00	2006-11-25 14:25:30
303	66	2006-11-16 21:00:00	2006-11-16 21:56:38
311	13	2006-11-25 12:22:39	2006-11-25 16:00:00
311	123	2006-11-25 15:10:02	2006-11-25 16:00:00
309	45	2006-11-16 23:29:57	2006-11-17 00:15:00
309	142	2006-11-16 22:39:24	2006-11-17 00:15:00
309	223	2006-11-16 22:37:45	2006-11-17 00:15:00
309	227	2006-11-16 22:49:14	2006-11-17 00:15:00
309	255	2006-11-16 23:03:24	2006-11-17 00:14:25
309	282	2006-11-16 23:02:10	2006-11-17 00:15:00
311	19	2006-11-25 11:00:00	2006-11-25 16:00:00
311	157	2006-11-25 11:00:00	2006-11-25 13:50:10
311	29	2006-11-25 13:19:19	2006-11-25 16:00:00
311	30	2006-11-25 11:00:00	2006-11-25 16:00:00
311	245	2006-11-25 11:00:00	2006-11-25 14:58:22
311	33	2006-11-25 11:00:00	2006-11-25 15:39:01
311	236	2006-11-25 11:00:00	2006-11-25 16:00:00
311	136	2006-11-25 11:00:00	2006-11-25 16:00:00
311	371	2006-11-25 11:00:00	2006-11-25 12:11:11
311	111	2006-11-25 11:00:00	2006-11-25 16:00:00
311	39	2006-11-25 15:28:47	2006-11-25 16:00:00
311	142	2006-11-25 15:02:17	2006-11-25 16:00:00
311	100	2006-11-25 13:52:12	2006-11-25 16:00:00
311	293	2006-11-25 11:00:00	2006-11-25 11:34:58
311	51	2006-11-25 13:46:18	2006-11-25 15:27:23
311	312	2006-11-25 11:00:00	2006-11-25 12:44:36
311	148	2006-11-25 11:00:00	2006-11-25 16:00:00
311	360	2006-11-25 11:00:00	2006-11-25 16:00:00
311	233	2006-11-25 11:00:00	2006-11-25 16:00:00
311	152	2006-11-25 15:45:19	2006-11-25 16:00:00
311	240	2006-11-25 11:00:00	2006-11-25 14:56:28
311	89	2006-11-25 11:00:00	2006-11-25 16:00:00
311	251	2006-11-25 11:03:06	2006-11-25 16:00:00
311	282	2006-11-25 11:54:38	2006-11-25 16:00:00
314	1	2006-11-26 19:30:00	2006-11-26 22:22:02
314	284	2006-11-26 19:30:00	2006-11-26 21:25:53
314	4	2006-11-26 20:32:23	2006-11-27 00:30:00
314	206	2006-11-26 19:30:00	2006-11-26 22:30:08
314	5	2006-11-26 19:30:00	2006-11-27 00:30:00
314	7	2006-11-26 19:30:00	2006-11-27 00:30:00
314	135	2006-11-26 19:30:00	2006-11-27 00:30:00
314	8	2006-11-26 19:30:00	2006-11-27 00:30:00
314	90	2006-11-26 19:30:00	2006-11-27 00:30:00
314	13	2006-11-26 19:30:00	2006-11-27 00:30:00
314	15	2006-11-26 21:26:03	2006-11-27 00:30:00
314	123	2006-11-26 19:30:00	2006-11-27 00:30:00
314	19	2006-11-26 19:30:00	2006-11-27 00:30:00
314	21	2006-11-26 19:30:00	2006-11-27 00:30:00
309	1	2006-11-16 22:30:00	2006-11-17 00:15:00
309	4	2006-11-16 22:30:00	2006-11-17 00:15:00
309	5	2006-11-16 22:30:00	2006-11-17 00:15:00
309	7	2006-11-16 22:30:00	2006-11-17 00:15:00
309	15	2006-11-16 22:30:00	2006-11-17 00:15:00
309	19	2006-11-16 22:30:00	2006-11-17 00:15:00
309	27	2006-11-16 22:30:00	2006-11-17 00:15:00
309	28	2006-11-16 22:30:00	2006-11-17 00:15:00
309	30	2006-11-16 22:30:00	2006-11-17 00:15:00
309	32	2006-11-16 22:30:00	2006-11-17 00:15:00
309	33	2006-11-16 22:30:00	2006-11-17 00:15:00
309	36	2006-11-16 22:30:00	2006-11-17 00:15:00
309	39	2006-11-16 22:30:00	2006-11-17 00:15:00
309	40	2006-11-16 22:30:00	2006-11-17 00:15:00
309	41	2006-11-16 22:30:00	2006-11-17 00:15:00
309	43	2006-11-16 22:30:00	2006-11-17 00:15:00
309	48	2006-11-16 22:30:00	2006-11-17 00:15:00
309	50	2006-11-16 22:30:00	2006-11-17 00:15:00
309	51	2006-11-16 22:30:00	2006-11-17 00:15:00
309	59	2006-11-16 22:30:00	2006-11-17 00:15:00
309	60	2006-11-16 22:30:00	2006-11-17 00:15:00
309	100	2006-11-16 22:30:00	2006-11-17 00:15:00
309	103	2006-11-16 22:30:00	2006-11-17 00:15:00
309	106	2006-11-16 22:30:00	2006-11-17 00:15:00
309	116	2006-11-16 22:30:00	2006-11-17 00:15:00
309	135	2006-11-16 22:30:00	2006-11-17 00:15:00
309	136	2006-11-16 22:30:00	2006-11-17 00:15:00
309	155	2006-11-16 22:30:00	2006-11-17 00:15:00
309	157	2006-11-16 22:30:00	2006-11-17 00:15:00
309	160	2006-11-16 22:30:00	2006-11-17 00:15:00
309	222	2006-11-16 22:30:00	2006-11-17 00:15:00
309	235	2006-11-16 22:30:00	2006-11-17 00:15:00
309	257	2006-11-16 22:30:00	2006-11-17 00:15:00
309	259	2006-11-16 22:30:00	2006-11-17 00:15:00
309	284	2006-11-16 22:30:00	2006-11-17 00:15:00
309	319	2006-11-16 22:30:00	2006-11-17 00:15:00
309	327	2006-11-16 22:30:00	2006-11-17 00:15:00
309	348	2006-11-16 22:30:00	2006-11-17 00:15:00
303	1	2006-11-16 21:00:00	2006-11-16 22:30:00
303	4	2006-11-16 21:00:00	2006-11-16 22:30:00
303	5	2006-11-16 21:00:00	2006-11-16 22:30:00
303	7	2006-11-16 21:00:00	2006-11-16 22:30:00
303	15	2006-11-16 21:00:00	2006-11-16 22:30:00
303	19	2006-11-16 21:00:00	2006-11-16 22:30:00
303	27	2006-11-16 21:00:00	2006-11-16 22:30:00
303	28	2006-11-16 21:00:00	2006-11-16 22:30:00
303	30	2006-11-16 21:00:00	2006-11-16 22:30:00
303	32	2006-11-16 21:00:00	2006-11-16 22:30:00
303	33	2006-11-16 21:00:00	2006-11-16 22:30:00
303	36	2006-11-16 21:00:00	2006-11-16 22:30:00
303	39	2006-11-16 21:00:00	2006-11-16 22:30:00
303	40	2006-11-16 21:00:00	2006-11-16 22:30:00
303	41	2006-11-16 21:00:00	2006-11-16 22:30:00
303	42	2006-11-16 21:00:00	2006-11-16 22:30:00
303	43	2006-11-16 21:58:32	2006-11-16 22:30:00
303	44	2006-11-16 21:00:00	2006-11-16 22:30:00
303	48	2006-11-16 21:00:00	2006-11-16 22:30:00
303	50	2006-11-16 21:00:00	2006-11-16 22:30:00
303	51	2006-11-16 21:00:00	2006-11-16 22:30:00
303	59	2006-11-16 21:00:00	2006-11-16 22:30:00
303	60	2006-11-16 21:00:00	2006-11-16 22:30:00
303	100	2006-11-16 21:00:00	2006-11-16 22:30:00
303	103	2006-11-16 21:00:00	2006-11-16 22:30:00
303	106	2006-11-16 21:00:00	2006-11-16 22:30:00
303	116	2006-11-16 21:00:00	2006-11-16 22:30:00
303	135	2006-11-16 21:00:00	2006-11-16 22:30:00
303	136	2006-11-16 21:00:00	2006-11-16 22:30:00
303	148	2006-11-16 21:00:00	2006-11-16 22:30:00
303	155	2006-11-16 21:00:00	2006-11-16 22:30:00
303	157	2006-11-16 21:00:00	2006-11-16 22:30:00
303	160	2006-11-16 21:00:00	2006-11-16 22:30:00
303	222	2006-11-16 21:57:43	2006-11-16 22:30:00
303	234	2006-11-16 21:00:00	2006-11-16 22:30:00
303	235	2006-11-16 21:00:00	2006-11-16 22:30:00
303	257	2006-11-16 21:00:00	2006-11-16 22:30:00
303	259	2006-11-16 21:00:00	2006-11-16 22:30:00
303	284	2006-11-16 21:00:00	2006-11-16 22:30:00
303	319	2006-11-16 21:00:00	2006-11-16 22:30:00
303	327	2006-11-16 21:00:00	2006-11-16 22:30:00
303	348	2006-11-16 21:00:00	2006-11-16 22:30:00
304	284	2006-11-18 11:00:00	2006-11-18 11:51:47
304	348	2006-11-18 11:00:00	2006-11-18 15:02:57
304	5	2006-11-18 11:00:00	2006-11-18 13:52:08
304	7	2006-11-18 11:00:00	2006-11-18 16:15:00
304	287	2006-11-18 11:02:21	2006-11-18 13:10:12
304	90	2006-11-18 11:00:00	2006-11-18 16:15:00
304	235	2006-11-18 11:00:00	2006-11-18 16:15:00
304	19	2006-11-18 11:00:00	2006-11-18 15:05:26
304	157	2006-11-18 11:43:22	2006-11-18 15:03:38
304	30	2006-11-18 11:00:00	2006-11-18 16:15:00
304	31	2006-11-18 12:24:09	2006-11-18 15:04:07
304	236	2006-11-18 11:00:00	2006-11-18 16:06:44
304	136	2006-11-18 15:20:21	2006-11-18 16:15:00
304	111	2006-11-18 11:00:00	2006-11-18 14:40:14
304	269	2006-11-18 14:20:38	2006-11-18 16:15:00
304	81	2006-11-18 15:13:43	2006-11-18 16:15:00
304	319	2006-11-18 11:00:00	2006-11-18 12:28:59
304	44	2006-11-18 11:00:00	2006-11-18 16:15:00
304	261	2006-11-18 11:00:00	2006-11-18 16:15:00
304	100	2006-11-18 14:40:52	2006-11-18 15:16:13
304	338	2006-11-18 13:53:21	2006-11-18 16:15:00
304	339	2006-11-18 11:00:00	2006-11-18 16:15:00
304	312	2006-11-18 11:00:00	2006-11-18 13:04:15
304	207	2006-11-18 11:10:47	2006-11-18 16:15:00
304	347	2006-11-18 15:05:17	2006-11-18 16:15:00
304	148	2006-11-18 15:29:42	2006-11-18 16:15:00
304	109	2006-11-18 11:00:00	2006-11-18 15:13:12
304	160	2006-11-18 13:16:29	2006-11-18 16:15:00
304	316	2006-11-18 13:15:47	2006-11-18 16:15:00
304	76	2006-11-18 15:07:38	2006-11-18 16:15:00
304	282	2006-11-18 11:00:00	2006-11-18 16:15:00
304	231	2006-11-18 11:03:32	2006-11-18 16:15:00
305	301	2006-11-18 19:35:14	2006-11-18 20:45:00
305	284	2006-11-18 19:30:00	2006-11-18 20:45:00
305	143	2006-11-18 19:30:00	2006-11-18 20:45:00
305	357	2006-11-18 19:41:56	2006-11-18 20:45:00
305	135	2006-11-18 19:30:00	2006-11-18 20:45:00
305	275	2006-11-18 19:30:00	2006-11-18 20:45:00
305	90	2006-11-18 19:30:00	2006-11-18 20:45:00
305	235	2006-11-18 19:30:00	2006-11-18 20:45:00
305	217	2006-11-18 19:30:00	2006-11-18 20:45:00
305	123	2006-11-18 19:30:00	2006-11-18 20:45:00
305	19	2006-11-18 19:30:00	2006-11-18 20:45:00
305	280	2006-11-18 19:30:00	2006-11-18 20:45:00
305	213	2006-11-18 19:43:14	2006-11-18 20:45:00
305	98	2006-11-18 19:30:00	2006-11-18 20:45:00
305	245	2006-11-18 19:30:00	2006-11-18 20:45:00
305	31	2006-11-18 19:30:00	2006-11-18 20:24:15
305	314	2006-11-18 19:30:00	2006-11-18 20:45:00
305	154	2006-11-18 19:30:00	2006-11-18 20:45:00
305	236	2006-11-18 19:30:00	2006-11-18 20:45:00
305	136	2006-11-18 19:30:00	2006-11-18 20:45:00
305	234	2006-11-18 19:30:00	2006-11-18 20:45:00
305	257	2006-11-18 19:30:00	2006-11-18 20:45:00
305	150	2006-11-18 19:30:00	2006-11-18 20:45:00
305	359	2006-11-18 19:30:00	2006-11-18 20:45:00
305	269	2006-11-18 19:30:00	2006-11-18 20:45:00
305	323	2006-11-18 19:30:00	2006-11-18 20:45:00
305	319	2006-11-18 19:30:00	2006-11-18 20:45:00
305	261	2006-11-18 19:30:00	2006-11-18 20:45:00
305	297	2006-11-18 19:30:00	2006-11-18 20:45:00
305	106	2006-11-18 19:30:00	2006-11-18 20:45:00
305	354	2006-11-18 19:46:34	2006-11-18 20:45:00
305	249	2006-11-18 19:30:00	2006-11-18 20:45:00
305	220	2006-11-18 19:30:00	2006-11-18 20:45:00
305	340	2006-11-18 19:30:00	2006-11-18 20:45:00
305	100	2006-11-18 19:30:00	2006-11-18 20:45:00
305	343	2006-11-18 19:30:00	2006-11-18 20:45:00
305	339	2006-11-18 19:30:00	2006-11-18 20:45:00
305	188	2006-11-18 19:30:00	2006-11-18 20:45:00
305	207	2006-11-18 19:30:00	2006-11-18 20:45:00
305	78	2006-11-18 19:30:00	2006-11-18 20:45:00
305	360	2006-11-18 19:30:00	2006-11-18 20:45:00
305	132	2006-11-18 20:15:50	2006-11-18 20:45:00
305	75	2006-11-18 19:30:00	2006-11-18 20:45:00
305	89	2006-11-18 19:30:00	2006-11-18 20:45:00
305	76	2006-11-18 19:30:00	2006-11-18 20:45:00
305	118	2006-11-18 19:30:00	2006-11-18 20:45:00
305	56	2006-11-18 19:30:00	2006-11-18 20:45:00
305	282	2006-11-18 19:48:38	2006-11-18 20:45:00
305	231	2006-11-18 19:30:00	2006-11-18 20:45:00
305	66	2006-11-18 19:39:42	2006-11-18 20:45:00
305	59	2006-11-18 19:30:00	2006-11-18 20:45:00
305	60	2006-11-18 19:30:00	2006-11-18 20:45:00
306	284	2006-11-18 21:30:00	2006-11-19 00:10:00
306	143	2006-11-18 21:30:00	2006-11-19 00:10:00
306	357	2006-11-18 21:30:00	2006-11-19 00:10:00
306	4	2006-11-18 22:50:59	2006-11-18 23:19:16
306	275	2006-11-18 21:30:00	2006-11-18 23:22:45
306	90	2006-11-18 21:30:00	2006-11-19 00:10:00
306	235	2006-11-18 21:30:00	2006-11-18 23:20:02
306	13	2006-11-18 21:30:00	2006-11-19 00:10:00
306	217	2006-11-18 21:30:00	2006-11-18 22:10:08
306	123	2006-11-18 21:30:00	2006-11-19 00:10:00
306	325	2006-11-18 21:30:00	2006-11-18 22:22:31
306	19	2006-11-18 21:30:00	2006-11-19 00:10:00
306	280	2006-11-18 21:30:00	2006-11-19 00:09:36
306	368	2006-11-18 22:54:23	2006-11-19 00:10:00
306	356	2006-11-18 22:10:25	2006-11-19 00:10:00
306	213	2006-11-18 21:30:00	2006-11-19 00:10:00
306	98	2006-11-18 21:30:00	2006-11-19 00:10:00
306	245	2006-11-18 21:30:00	2006-11-19 00:10:00
306	314	2006-11-18 23:26:40	2006-11-19 00:10:00
306	154	2006-11-18 21:30:00	2006-11-19 00:10:00
306	236	2006-11-18 21:30:00	2006-11-19 00:10:00
306	136	2006-11-18 21:30:00	2006-11-19 00:10:00
306	234	2006-11-18 21:30:00	2006-11-19 00:10:00
306	257	2006-11-18 21:30:00	2006-11-19 00:10:00
306	150	2006-11-18 21:30:00	2006-11-19 00:10:00
306	359	2006-11-18 21:30:00	2006-11-19 00:10:00
306	269	2006-11-18 21:30:00	2006-11-18 22:52:00
306	323	2006-11-18 21:30:00	2006-11-19 00:10:00
306	326	2006-11-18 23:23:10	2006-11-19 00:10:00
306	297	2006-11-18 21:30:00	2006-11-19 00:10:00
306	106	2006-11-18 21:57:29	2006-11-18 22:06:16
306	220	2006-11-18 21:30:00	2006-11-19 00:10:00
306	340	2006-11-18 21:30:00	2006-11-19 00:10:00
306	343	2006-11-18 21:30:00	2006-11-19 00:10:00
306	338	2006-11-18 21:30:00	2006-11-19 00:10:00
306	339	2006-11-18 21:30:00	2006-11-19 00:09:24
306	207	2006-11-18 21:30:00	2006-11-19 00:10:00
306	222	2006-11-18 22:11:49	2006-11-19 00:10:00
306	78	2006-11-18 21:30:00	2006-11-19 00:10:00
306	148	2006-11-18 22:33:58	2006-11-18 22:37:57
306	360	2006-11-18 21:30:00	2006-11-19 00:10:00
306	337	2006-11-18 21:30:00	2006-11-19 00:10:00
306	75	2006-11-18 21:30:00	2006-11-19 00:10:00
306	89	2006-11-18 21:30:00	2006-11-19 00:10:00
306	76	2006-11-18 21:30:00	2006-11-19 00:10:00
306	118	2006-11-18 21:30:00	2006-11-19 00:10:00
306	56	2006-11-18 21:30:00	2006-11-19 00:10:00
306	355	2006-11-18 21:30:00	2006-11-19 00:10:00
306	66	2006-11-18 21:30:00	2006-11-19 00:10:00
306	59	2006-11-18 21:30:00	2006-11-19 00:10:00
307	1	2006-11-19 19:30:00	2006-11-19 23:25:00
307	284	2006-11-19 19:30:00	2006-11-19 23:25:00
307	2	2006-11-19 19:30:00	2006-11-19 23:25:00
307	4	2006-11-19 19:30:00	2006-11-19 23:25:00
307	206	2006-11-19 19:30:00	2006-11-19 23:25:00
307	5	2006-11-19 19:30:00	2006-11-19 23:25:00
307	135	2006-11-19 19:30:00	2006-11-19 23:25:00
307	90	2006-11-19 19:54:47	2006-11-19 23:25:00
307	13	2006-11-19 19:30:00	2006-11-19 23:25:00
307	15	2006-11-19 19:30:00	2006-11-19 23:25:00
307	16	2006-11-19 19:30:00	2006-11-19 23:25:00
307	123	2006-11-19 19:30:00	2006-11-19 23:25:00
307	19	2006-11-19 19:30:00	2006-11-19 23:25:00
307	21	2006-11-19 19:30:00	2006-11-19 23:25:00
307	157	2006-11-19 19:30:00	2006-11-19 23:00:17
307	27	2006-11-19 19:30:00	2006-11-19 23:25:00
307	28	2006-11-19 19:30:00	2006-11-19 23:25:00
307	232	2006-11-19 19:30:00	2006-11-19 23:25:00
307	29	2006-11-19 19:30:00	2006-11-19 23:25:00
307	36	2006-11-19 19:30:00	2006-11-19 23:25:00
307	155	2006-11-19 19:30:00	2006-11-19 23:25:00
307	39	2006-11-19 19:30:00	2006-11-19 23:25:00
307	40	2006-11-19 19:30:00	2006-11-19 23:25:00
307	41	2006-11-19 19:30:00	2006-11-19 23:25:00
307	259	2006-11-19 19:30:00	2006-11-19 22:53:02
307	270	2006-11-19 19:30:00	2006-11-19 23:25:00
307	44	2006-11-19 19:30:00	2006-11-19 23:25:00
307	45	2006-11-19 19:30:00	2006-11-19 23:25:00
307	142	2006-11-19 19:30:00	2006-11-19 23:25:00
307	297	2006-11-19 19:30:00	2006-11-19 23:25:00
307	48	2006-11-19 19:30:00	2006-11-19 19:54:37
307	50	2006-11-19 19:30:00	2006-11-19 23:25:00
307	100	2006-11-19 19:30:00	2006-11-19 23:25:00
307	103	2006-11-19 19:30:00	2006-11-19 23:25:00
307	51	2006-11-19 19:30:00	2006-11-19 23:25:00
307	222	2006-11-19 22:53:55	2006-11-19 23:25:00
307	52	2006-11-19 22:28:55	2006-11-19 23:25:00
307	233	2006-11-19 19:30:00	2006-11-19 23:25:00
307	116	2006-11-19 19:30:00	2006-11-19 23:25:00
307	160	2006-11-19 19:30:00	2006-11-19 23:25:00
307	89	2006-11-19 19:30:00	2006-11-19 23:25:00
307	167	2006-11-19 19:30:00	2006-11-19 22:27:16
307	118	2006-11-19 19:30:00	2006-11-19 20:27:20
307	55	2006-11-19 20:27:26	2006-11-19 23:25:00
307	60	2006-11-19 19:30:00	2006-11-19 23:25:00
310	1	2006-11-21 21:00:00	2006-11-22 00:35:00
310	2	2006-11-21 21:00:00	2006-11-21 23:12:30
310	4	2006-11-21 21:00:00	2006-11-22 00:35:00
310	5	2006-11-21 21:00:00	2006-11-22 00:35:00
310	7	2006-11-21 21:00:00	2006-11-22 00:35:00
310	135	2006-11-21 21:00:00	2006-11-22 00:35:00
310	275	2006-11-21 23:13:44	2006-11-22 00:35:00
310	13	2006-11-21 21:00:00	2006-11-22 00:35:00
310	217	2006-11-21 21:00:00	2006-11-22 00:35:00
310	15	2006-11-21 21:00:00	2006-11-22 00:35:00
310	123	2006-11-21 21:00:00	2006-11-22 00:35:00
310	19	2006-11-22 00:05:48	2006-11-22 00:35:00
310	21	2006-11-21 21:00:00	2006-11-22 00:35:00
310	255	2006-11-21 21:00:00	2006-11-22 00:10:06
310	27	2006-11-21 21:00:00	2006-11-22 00:35:00
310	28	2006-11-21 21:00:00	2006-11-22 00:35:00
310	29	2006-11-21 21:19:49	2006-11-22 00:35:00
310	30	2006-11-21 21:00:00	2006-11-22 00:35:00
310	136	2006-11-21 21:00:00	2006-11-22 00:35:00
310	234	2006-11-21 21:03:22	2006-11-22 00:12:06
310	36	2006-11-21 21:00:00	2006-11-22 00:35:00
310	257	2006-11-21 21:00:00	2006-11-22 00:35:00
310	359	2006-11-21 23:15:35	2006-11-22 00:35:00
310	155	2006-11-21 21:00:00	2006-11-22 00:35:00
310	269	2006-11-21 21:00:00	2006-11-21 21:06:26
310	39	2006-11-21 21:00:00	2006-11-22 00:35:00
310	41	2006-11-21 21:00:00	2006-11-22 00:35:00
310	319	2006-11-21 21:00:00	2006-11-21 22:25:06
310	43	2006-11-21 21:42:06	2006-11-22 00:35:00
310	259	2006-11-21 21:00:00	2006-11-22 00:02:33
310	44	2006-11-21 21:00:00	2006-11-21 23:11:48
310	45	2006-11-21 21:00:00	2006-11-22 00:35:00
310	48	2006-11-21 21:00:00	2006-11-22 00:35:00
310	50	2006-11-21 21:00:00	2006-11-22 00:35:00
310	100	2006-11-21 21:00:00	2006-11-22 00:35:00
310	338	2006-11-21 23:14:31	2006-11-22 00:35:00
310	103	2006-11-21 21:00:00	2006-11-22 00:35:00
310	51	2006-11-21 21:00:00	2006-11-22 00:35:00
310	229	2006-11-21 21:00:00	2006-11-22 00:35:00
310	222	2006-11-21 21:03:17	2006-11-22 00:35:00
310	148	2006-11-21 21:00:00	2006-11-22 00:35:00
310	233	2006-11-21 21:00:00	2006-11-22 00:35:00
310	116	2006-11-21 21:00:00	2006-11-22 00:35:00
310	75	2006-11-21 21:00:00	2006-11-22 00:35:00
310	160	2006-11-21 21:00:00	2006-11-22 00:35:00
310	167	2006-11-21 21:00:00	2006-11-21 23:11:47
310	66	2006-11-21 22:28:00	2006-11-22 00:35:00
310	59	2006-11-21 21:00:00	2006-11-22 00:35:00
310	60	2006-11-21 21:54:15	2006-11-22 00:35:00
314	157	2006-11-26 19:30:00	2006-11-27 00:29:51
314	27	2006-11-26 19:30:00	2006-11-27 00:29:57
314	232	2006-11-26 19:30:00	2006-11-27 00:30:00
314	29	2006-11-26 19:30:00	2006-11-27 00:30:00
314	373	2006-11-26 19:30:00	2006-11-26 23:39:20
314	32	2006-11-26 19:30:00	2006-11-26 21:55:34
314	177	2006-11-26 23:39:39	2006-11-27 00:30:00
314	257	2006-11-26 19:30:00	2006-11-27 00:30:00
314	39	2006-11-26 19:30:00	2006-11-26 23:59:52
314	41	2006-11-26 19:30:00	2006-11-27 00:30:00
314	42	2006-11-26 23:37:42	2006-11-27 00:30:00
314	259	2006-11-26 19:30:00	2006-11-26 23:29:24
314	270	2006-11-26 19:30:00	2006-11-27 00:30:00
314	44	2006-11-26 19:30:00	2006-11-27 00:30:00
314	45	2006-11-26 19:30:00	2006-11-27 00:30:00
314	142	2006-11-26 19:30:00	2006-11-27 00:30:00
314	48	2006-11-26 19:30:00	2006-11-27 00:30:00
314	227	2006-11-26 19:30:00	2006-11-26 20:29:06
314	50	2006-11-26 20:33:21	2006-11-27 00:30:00
314	100	2006-11-26 19:30:00	2006-11-27 00:30:00
314	103	2006-11-26 19:30:42	2006-11-26 20:33:11
314	51	2006-11-26 19:30:00	2006-11-27 00:30:00
314	222	2006-11-26 19:30:00	2006-11-27 00:30:00
314	148	2006-11-26 19:30:00	2006-11-27 00:30:00
314	233	2006-11-26 19:30:00	2006-11-27 00:30:00
314	116	2006-11-26 19:30:00	2006-11-27 00:30:00
314	160	2006-11-26 19:30:00	2006-11-27 00:30:00
314	205	2006-11-26 23:03:10	2006-11-27 00:30:00
314	89	2006-11-26 19:30:00	2006-11-27 00:30:00
314	167	2006-11-26 19:30:00	2006-11-26 23:28:50
314	55	2006-11-26 19:30:00	2006-11-27 00:30:00
314	57	2006-11-26 19:30:00	2006-11-27 00:30:00
314	251	2006-11-26 22:30:54	2006-11-27 00:30:00
314	282	2006-11-26 23:39:35	2006-11-27 00:30:00
314	59	2006-11-26 22:59:20	2006-11-27 00:30:00
314	60	2006-11-26 19:30:00	2006-11-27 00:30:00
312	370	2006-11-25 19:30:00	2006-11-25 20:15:00
312	284	2006-11-25 19:30:00	2006-11-25 20:15:00
312	143	2006-11-25 19:30:00	2006-11-25 20:15:00
312	357	2006-11-25 19:30:00	2006-11-25 20:15:00
312	156	2006-11-25 19:30:00	2006-11-25 20:15:00
312	135	2006-11-25 19:30:00	2006-11-25 20:15:00
312	335	2006-11-25 19:30:00	2006-11-25 20:15:00
312	275	2006-11-25 19:30:00	2006-11-25 20:15:00
312	90	2006-11-25 19:30:00	2006-11-25 20:15:00
312	235	2006-11-25 19:30:00	2006-11-25 20:15:00
312	13	2006-11-25 19:30:00	2006-11-25 20:15:00
312	325	2006-11-25 19:30:00	2006-11-25 19:37:42
312	19	2006-11-25 19:30:00	2006-11-25 20:15:00
312	244	2006-11-25 19:30:00	2006-11-25 20:15:00
312	213	2006-11-25 19:30:00	2006-11-25 20:15:00
312	98	2006-11-25 19:30:00	2006-11-25 20:15:00
312	245	2006-11-25 19:30:00	2006-11-25 20:15:00
312	31	2006-11-25 19:30:00	2006-11-25 20:15:00
312	215	2006-11-25 19:30:00	2006-11-25 20:15:00
312	154	2006-11-25 19:30:00	2006-11-25 20:15:00
312	285	2006-11-25 19:30:00	2006-11-25 20:15:00
312	236	2006-11-25 19:30:00	2006-11-25 20:15:00
312	369	2006-11-25 19:30:00	2006-11-25 20:15:00
312	155	2006-11-25 19:30:00	2006-11-25 20:15:00
312	323	2006-11-25 19:30:00	2006-11-25 20:15:00
312	319	2006-11-25 19:30:00	2006-11-25 20:15:00
312	45	2006-11-25 19:30:00	2006-11-25 20:15:00
312	261	2006-11-25 19:30:00	2006-11-25 20:15:00
312	106	2006-11-25 19:30:00	2006-11-25 20:15:00
312	340	2006-11-25 19:30:15	2006-11-25 20:15:00
312	100	2006-11-25 19:30:00	2006-11-25 20:15:00
312	343	2006-11-25 19:30:00	2006-11-25 20:15:00
312	78	2006-11-25 19:30:00	2006-11-25 20:15:00
312	151	2006-11-25 19:30:00	2006-11-25 20:15:00
312	148	2006-11-25 19:30:00	2006-11-25 20:15:00
312	360	2006-11-25 19:30:00	2006-11-25 20:15:00
312	89	2006-11-25 19:30:00	2006-11-25 20:15:00
312	76	2006-11-25 19:30:00	2006-11-25 20:15:00
312	118	2006-11-25 19:30:00	2006-11-25 20:15:00
312	55	2006-11-25 19:30:00	2006-11-25 20:15:00
312	251	2006-11-25 19:30:00	2006-11-25 20:15:00
312	56	2006-11-25 19:30:00	2006-11-25 20:15:00
312	66	2006-11-25 19:30:00	2006-11-25 20:15:00
312	277	2006-11-25 19:30:00	2006-11-25 20:15:00
313	370	2006-11-25 21:00:00	2006-11-25 23:32:10
313	284	2006-11-25 21:00:00	2006-11-26 00:30:00
313	143	2006-11-25 21:00:00	2006-11-25 23:35:34
313	357	2006-11-25 21:00:00	2006-11-26 00:30:00
313	203	2006-11-25 21:00:00	2006-11-26 00:30:00
313	4	2006-11-25 23:11:13	2006-11-25 23:31:08
313	200	2006-11-25 23:09:34	2006-11-25 23:13:42
313	335	2006-11-25 21:00:00	2006-11-26 00:30:00
313	275	2006-11-25 21:00:00	2006-11-26 00:30:00
313	90	2006-11-25 21:00:00	2006-11-26 00:30:00
313	372	2006-11-25 21:00:00	2006-11-26 00:30:00
313	13	2006-11-25 21:00:00	2006-11-25 21:44:52
313	325	2006-11-25 21:00:00	2006-11-26 00:30:00
313	28	2006-11-25 21:00:00	2006-11-26 00:30:00
313	98	2006-11-25 21:00:00	2006-11-26 00:30:00
313	245	2006-11-25 21:00:00	2006-11-26 00:30:00
313	314	2006-11-25 21:00:00	2006-11-26 00:30:00
313	215	2006-11-25 21:00:00	2006-11-26 00:30:00
313	236	2006-11-25 21:00:00	2006-11-26 00:30:00
313	136	2006-11-25 22:48:06	2006-11-26 00:30:00
313	234	2006-11-25 21:00:00	2006-11-25 23:33:05
313	286	2006-11-25 21:00:00	2006-11-26 00:30:00
313	257	2006-11-25 21:00:00	2006-11-26 00:30:00
313	371	2006-11-25 23:11:04	2006-11-26 00:30:00
313	359	2006-11-25 21:05:30	2006-11-26 00:30:00
313	369	2006-11-25 21:00:00	2006-11-26 00:30:00
313	349	2006-11-25 21:00:00	2006-11-25 22:57:37
313	202	2006-11-25 21:00:00	2006-11-25 22:10:05
313	323	2006-11-25 21:00:00	2006-11-26 00:30:00
313	319	2006-11-25 21:00:00	2006-11-26 00:12:24
313	297	2006-11-25 21:00:00	2006-11-26 00:30:00
313	106	2006-11-25 21:00:00	2006-11-25 22:02:53
313	340	2006-11-25 21:00:00	2006-11-26 00:30:00
313	343	2006-11-25 21:00:00	2006-11-25 22:57:31
313	293	2006-11-25 21:00:00	2006-11-26 00:30:00
313	229	2006-11-25 21:00:00	2006-11-25 22:09:37
313	207	2006-11-25 21:00:00	2006-11-26 00:30:00
313	222	2006-11-25 23:19:31	2006-11-26 00:30:00
313	327	2006-11-25 21:05:01	2006-11-26 00:12:18
313	78	2006-11-25 21:00:00	2006-11-26 00:30:00
313	151	2006-11-25 21:00:00	2006-11-26 00:30:00
313	148	2006-11-25 21:00:00	2006-11-25 22:17:22
313	360	2006-11-25 21:00:00	2006-11-26 00:30:00
313	337	2006-11-25 21:00:00	2006-11-26 00:30:00
313	152	2006-11-25 21:00:00	2006-11-26 00:30:00
313	76	2006-11-25 21:00:00	2006-11-26 00:30:00
313	66	2006-11-25 21:00:00	2006-11-25 23:35:46
313	277	2006-11-25 21:00:00	2006-11-25 23:59:56
315	370	2006-11-27 21:50:14	2006-11-28 00:04:50
315	284	2006-11-27 21:26:08	2006-11-28 00:45:00
315	357	2006-11-27 21:00:00	2006-11-28 00:45:00
315	200	2006-11-27 21:32:07	2006-11-27 22:32:39
315	9	2006-11-28 00:11:41	2006-11-28 00:45:00
315	335	2006-11-27 21:00:00	2006-11-27 22:00:04
315	90	2006-11-27 21:00:00	2006-11-28 00:45:00
315	235	2006-11-27 21:00:00	2006-11-28 00:40:41
315	372	2006-11-27 21:00:00	2006-11-28 00:45:00
315	13	2006-11-27 21:00:00	2006-11-28 00:45:00
315	217	2006-11-27 21:00:00	2006-11-28 00:45:00
315	280	2006-11-27 21:00:00	2006-11-28 00:44:50
315	26	2006-11-27 21:00:00	2006-11-28 00:44:52
315	377	2006-11-27 23:23:08	2006-11-28 00:45:00
315	98	2006-11-27 21:00:00	2006-11-28 00:45:00
315	245	2006-11-27 21:00:00	2006-11-28 00:10:24
315	274	2006-11-27 21:00:00	2006-11-28 00:45:00
315	31	2006-11-27 21:33:40	2006-11-28 00:45:00
315	314	2006-11-27 21:03:42	2006-11-28 00:44:13
315	177	2006-11-27 22:05:07	2006-11-27 23:43:04
315	33	2006-11-27 23:40:00	2006-11-28 00:42:57
315	236	2006-11-27 21:00:00	2006-11-27 23:43:30
315	136	2006-11-27 21:23:21	2006-11-27 23:23:08
315	234	2006-11-27 21:00:00	2006-11-28 00:45:00
315	257	2006-11-27 21:00:00	2006-11-28 00:44:36
315	150	2006-11-27 21:00:00	2006-11-28 00:45:00
315	371	2006-11-27 22:11:31	2006-11-28 00:44:47
315	359	2006-11-27 21:00:00	2006-11-28 00:44:54
315	369	2006-11-27 21:09:24	2006-11-28 00:44:42
315	349	2006-11-27 22:26:17	2006-11-28 00:45:00
315	269	2006-11-28 00:37:21	2006-11-28 00:44:22
315	81	2006-11-28 00:34:22	2006-11-28 00:45:00
315	323	2006-11-27 21:00:00	2006-11-28 00:45:00
315	270	2006-11-27 23:52:19	2006-11-28 00:44:46
315	297	2006-11-27 21:06:45	2006-11-27 21:12:04
315	293	2006-11-27 21:00:00	2006-11-28 00:45:00
315	338	2006-11-27 21:07:29	2006-11-27 21:08:20
315	229	2006-11-27 21:11:08	2006-11-28 00:45:00
315	222	2006-11-28 00:10:53	2006-11-28 00:45:00
315	78	2006-11-27 21:02:46	2006-11-28 00:45:00
315	148	2006-11-27 21:00:00	2006-11-27 21:53:59
315	360	2006-11-27 21:29:05	2006-11-27 22:11:49
315	307	2006-11-27 21:09:21	2006-11-28 00:43:53
315	337	2006-11-27 21:00:00	2006-11-28 00:45:00
315	281	2006-11-27 21:24:29	2006-11-27 21:31:01
315	152	2006-11-27 21:00:00	2006-11-28 00:45:00
315	54	2006-11-27 21:00:00	2006-11-28 00:45:00
315	76	2006-11-27 21:00:00	2006-11-28 00:44:57
315	118	2006-11-27 21:00:00	2006-11-28 00:45:00
315	55	2006-11-27 21:16:55	2006-11-28 00:45:00
315	153	2006-11-27 23:29:12	2006-11-28 00:44:39
315	56	2006-11-27 21:00:00	2006-11-28 00:44:45
315	59	2006-11-27 21:00:00	2006-11-28 00:45:00
315	277	2006-11-27 21:00:00	2006-11-28 00:45:00
316	1	2006-11-28 20:30:00	2006-11-28 23:45:00
316	284	2006-11-28 20:40:13	2006-11-28 23:45:00
316	348	2006-11-28 20:47:04	2006-11-28 23:14:09
316	5	2006-11-28 20:30:44	2006-11-28 23:45:00
316	7	2006-11-28 20:30:00	2006-11-28 23:45:00
316	135	2006-11-28 20:42:55	2006-11-28 23:45:00
316	8	2006-11-28 20:37:23	2006-11-28 23:45:00
316	13	2006-11-28 20:49:07	2006-11-28 23:45:00
316	15	2006-11-28 20:30:00	2006-11-28 23:45:00
316	19	2006-11-28 20:30:00	2006-11-28 23:45:00
316	23	2006-11-28 20:30:00	2006-11-28 23:45:00
316	157	2006-11-28 20:30:00	2006-11-28 22:59:53
316	378	2006-11-28 23:22:11	2006-11-28 23:45:00
316	28	2006-11-28 20:30:00	2006-11-28 23:45:00
316	232	2006-11-28 20:46:27	2006-11-28 23:45:00
316	379	2006-11-28 21:00:18	2006-11-28 23:45:00
316	30	2006-11-28 20:30:00	2006-11-28 23:45:00
316	32	2006-11-28 20:36:15	2006-11-28 23:45:00
316	136	2006-11-28 20:30:00	2006-11-28 23:45:00
316	36	2006-11-28 23:19:04	2006-11-28 23:45:00
316	257	2006-11-28 20:45:01	2006-11-28 23:45:00
316	369	2006-11-28 21:00:18	2006-11-28 23:45:00
316	39	2006-11-28 20:30:00	2006-11-28 23:45:00
316	40	2006-11-28 20:32:56	2006-11-28 23:45:00
316	81	2006-11-28 20:45:17	2006-11-28 23:45:00
316	41	2006-11-28 20:30:00	2006-11-28 23:45:00
316	259	2006-11-28 20:30:00	2006-11-28 21:13:13
316	62	2006-11-28 20:44:10	2006-11-28 23:45:00
316	45	2006-11-28 20:30:00	2006-11-28 23:45:00
316	142	2006-11-28 20:33:48	2006-11-28 23:45:00
316	48	2006-11-28 20:30:00	2006-11-28 23:45:00
316	100	2006-11-28 20:30:00	2006-11-28 23:45:00
316	293	2006-11-28 22:10:41	2006-11-28 23:45:00
316	222	2006-11-28 23:37:23	2006-11-28 23:45:00
316	52	2006-11-28 20:45:59	2006-11-28 22:42:27
316	148	2006-11-28 20:30:00	2006-11-28 23:45:00
316	233	2006-11-28 20:38:27	2006-11-28 23:45:00
316	116	2006-11-28 20:30:00	2006-11-28 23:45:00
316	109	2006-11-28 20:42:47	2006-11-28 20:44:09
316	281	2006-11-28 23:16:54	2006-11-28 23:45:00
316	160	2006-11-28 20:30:00	2006-11-28 23:33:55
316	152	2006-11-28 21:00:18	2006-11-28 23:45:00
316	167	2006-11-28 20:51:50	2006-11-28 23:13:35
316	55	2006-11-28 20:32:29	2006-11-28 23:45:00
316	282	2006-11-28 22:10:16	2006-11-28 23:45:00
316	59	2006-11-28 20:38:14	2006-11-28 23:45:00
316	60	2006-11-28 20:40:15	2006-11-28 23:45:00
317	1	2006-11-30 21:30:00	2006-12-01 00:00:00
317	284	2006-11-30 21:30:00	2006-12-01 00:00:00
317	2	2006-11-30 21:30:00	2006-12-01 00:00:00
317	203	2006-11-30 21:30:00	2006-12-01 00:00:00
317	348	2006-11-30 21:30:00	2006-11-30 23:59:20
317	7	2006-11-30 21:30:00	2006-12-01 00:00:00
317	8	2006-11-30 21:30:00	2006-12-01 00:00:00
317	19	2006-11-30 21:30:00	2006-12-01 00:00:00
317	21	2006-11-30 23:07:19	2006-12-01 00:00:00
317	23	2006-11-30 21:30:00	2006-11-30 22:14:49
317	157	2006-11-30 21:30:00	2006-12-01 00:00:00
317	378	2006-11-30 22:40:01	2006-12-01 00:00:00
317	26	2006-11-30 21:30:00	2006-11-30 23:59:20
317	27	2006-11-30 21:30:00	2006-12-01 00:00:00
317	28	2006-11-30 21:30:00	2006-12-01 00:00:00
317	29	2006-11-30 21:30:00	2006-12-01 00:00:00
317	379	2006-11-30 21:30:00	2006-11-30 23:35:42
317	30	2006-11-30 21:30:00	2006-12-01 00:00:00
317	31	2006-11-30 21:30:00	2006-12-01 00:00:00
317	32	2006-11-30 21:30:00	2006-12-01 00:00:00
317	33	2006-11-30 21:30:00	2006-11-30 22:39:55
317	136	2006-11-30 21:30:00	2006-12-01 00:00:00
317	35	2006-11-30 21:30:00	2006-11-30 23:35:30
317	36	2006-11-30 21:30:00	2006-11-30 22:35:55
317	39	2006-11-30 21:30:00	2006-12-01 00:00:00
317	40	2006-11-30 22:02:51	2006-12-01 00:00:00
317	41	2006-11-30 22:14:36	2006-12-01 00:00:00
317	380	2006-11-30 21:30:00	2006-11-30 23:34:41
317	43	2006-11-30 21:30:00	2006-12-01 00:00:00
317	44	2006-11-30 21:30:00	2006-12-01 00:00:00
317	45	2006-11-30 23:36:04	2006-12-01 00:00:00
317	142	2006-11-30 23:11:44	2006-12-01 00:00:00
317	48	2006-11-30 21:30:00	2006-12-01 00:00:00
317	227	2006-11-30 21:30:00	2006-12-01 00:00:00
317	100	2006-11-30 21:30:00	2006-12-01 00:00:00
317	51	2006-11-30 21:50:03	2006-12-01 00:00:00
317	222	2006-11-30 21:30:00	2006-12-01 00:00:00
317	148	2006-11-30 21:30:00	2006-12-01 00:00:00
317	116	2006-11-30 21:30:00	2006-12-01 00:00:00
317	160	2006-11-30 21:30:00	2006-12-01 00:00:00
317	152	2006-11-30 21:30:00	2006-12-01 00:00:00
317	76	2006-11-30 21:30:00	2006-12-01 00:00:00
317	167	2006-11-30 21:30:00	2006-11-30 22:37:03
317	55	2006-11-30 22:53:44	2006-12-01 00:00:00
317	59	2006-11-30 21:30:00	2006-12-01 00:00:00
317	60	2006-11-30 21:30:00	2006-12-01 00:00:00
318	1	2006-12-02 11:00:00	2006-12-02 13:12:28
318	284	2006-12-02 15:31:02	2006-12-02 16:00:00
318	156	2006-12-02 11:00:00	2006-12-02 16:00:00
318	8	2006-12-02 11:02:00	2006-12-02 11:04:19
318	90	2006-12-02 11:00:00	2006-12-02 16:00:00
318	381	2006-12-02 14:52:46	2006-12-02 15:59:32
318	235	2006-12-02 11:00:00	2006-12-02 15:30:37
318	372	2006-12-02 11:00:00	2006-12-02 16:00:00
318	19	2006-12-02 13:13:14	2006-12-02 15:58:12
318	26	2006-12-02 11:19:30	2006-12-02 14:21:16
318	377	2006-12-02 13:47:14	2006-12-02 14:47:46
318	98	2006-12-02 11:43:58	2006-12-02 14:44:13
318	30	2006-12-02 11:43:22	2006-12-02 13:41:42
318	236	2006-12-02 11:00:00	2006-12-02 16:00:00
318	382	2006-12-02 13:52:54	2006-12-02 16:00:00
318	158	2006-12-02 11:00:00	2006-12-02 16:00:00
318	111	2006-12-02 11:00:00	2006-12-02 13:45:09
318	369	2006-12-02 12:39:02	2006-12-02 15:57:26
318	270	2006-12-02 12:39:13	2006-12-02 16:00:00
318	261	2006-12-02 11:00:00	2006-12-02 16:00:00
318	297	2006-12-02 14:23:30	2006-12-02 15:14:20
318	312	2006-12-02 11:00:00	2006-12-02 12:30:59
318	383	2006-12-02 11:00:00	2006-12-02 16:00:00
318	78	2006-12-02 11:00:00	2006-12-02 16:00:00
318	148	2006-12-02 14:45:44	2006-12-02 16:00:00
318	360	2006-12-02 11:09:03	2006-12-02 16:00:00
318	307	2006-12-02 11:05:08	2006-12-02 12:34:52
318	109	2006-12-02 11:00:00	2006-12-02 13:17:47
318	160	2006-12-02 11:00:00	2006-12-02 16:00:00
318	89	2006-12-02 13:42:32	2006-12-02 16:00:00
318	76	2006-12-02 13:51:35	2006-12-02 14:48:28
318	55	2006-12-02 11:00:00	2006-12-02 11:41:00
318	282	2006-12-02 11:00:00	2006-12-02 16:00:00
318	231	2006-12-02 11:00:00	2006-12-02 16:00:00
319	301	2006-12-02 20:00:00	2006-12-02 20:50:00
319	284	2006-12-02 20:00:00	2006-12-02 20:50:00
319	357	2006-12-02 20:00:00	2006-12-02 20:50:00
319	5	2006-12-02 20:00:00	2006-12-02 20:50:00
319	135	2006-12-02 20:00:00	2006-12-02 20:50:00
319	335	2006-12-02 20:00:00	2006-12-02 20:50:00
319	275	2006-12-02 20:00:00	2006-12-02 20:50:00
319	90	2006-12-02 20:00:00	2006-12-02 20:50:00
319	384	2006-12-02 20:00:00	2006-12-02 20:50:00
319	325	2006-12-02 20:00:00	2006-12-02 20:50:00
319	19	2006-12-02 20:00:00	2006-12-02 20:50:00
319	21	2006-12-02 20:00:00	2006-12-02 20:50:00
319	98	2006-12-02 20:00:00	2006-12-02 20:50:00
319	30	2006-12-02 20:00:00	2006-12-02 20:50:00
319	245	2006-12-02 20:00:00	2006-12-02 20:50:00
319	119	2006-12-02 20:00:00	2006-12-02 20:50:00
319	154	2006-12-02 20:00:00	2006-12-02 20:50:00
319	136	2006-12-02 20:00:00	2006-12-02 20:50:00
319	382	2006-12-02 20:00:00	2006-12-02 20:50:00
319	257	2006-12-02 20:00:00	2006-12-02 20:50:00
319	150	2006-12-02 20:00:00	2006-12-02 20:50:00
319	371	2006-12-02 20:00:00	2006-12-02 20:50:00
319	84	2006-12-02 20:00:00	2006-12-02 20:50:00
319	369	2006-12-02 20:00:00	2006-12-02 20:50:00
319	269	2006-12-02 20:00:00	2006-12-02 20:50:00
319	323	2006-12-02 20:00:00	2006-12-02 20:50:00
319	45	2006-12-02 20:00:00	2006-12-02 20:50:00
319	326	2006-12-02 20:00:00	2006-12-02 20:50:00
319	261	2006-12-02 20:00:00	2006-12-02 20:50:00
319	106	2006-12-02 20:00:00	2006-12-02 20:50:00
319	220	2006-12-02 20:00:00	2006-12-02 20:50:00
319	340	2006-12-02 20:00:00	2006-12-02 20:50:00
319	100	2006-12-02 20:00:00	2006-12-02 20:09:48
319	383	2006-12-02 20:00:00	2006-12-02 20:50:00
319	78	2006-12-02 20:00:00	2006-12-02 20:36:23
319	52	2006-12-02 20:00:00	2006-12-02 20:50:00
319	148	2006-12-02 20:00:00	2006-12-02 20:50:00
319	61	2006-12-02 20:00:00	2006-12-02 20:50:00
319	160	2006-12-02 20:00:00	2006-12-02 20:50:00
319	89	2006-12-02 20:00:00	2006-12-02 20:50:00
319	76	2006-12-02 20:00:00	2006-12-02 20:50:00
319	167	2006-12-02 20:00:00	2006-12-02 20:50:00
319	328	2006-12-02 20:00:00	2006-12-02 20:50:00
319	56	2006-12-02 20:00:00	2006-12-02 20:50:00
319	59	2006-12-02 20:00:00	2006-12-02 20:50:00
319	277	2006-12-02 20:00:00	2006-12-02 20:50:00
320	370	2006-12-03 00:01:49	2006-12-03 00:55:00
320	284	2006-12-02 21:15:00	2006-12-02 21:15:21
320	357	2006-12-02 21:15:00	2006-12-03 00:55:00
320	203	2006-12-02 21:15:00	2006-12-03 00:55:00
320	4	2006-12-02 23:12:01	2006-12-02 23:56:32
320	200	2006-12-02 21:20:02	2006-12-02 23:13:14
320	135	2006-12-02 21:15:00	2006-12-03 00:55:00
320	335	2006-12-02 21:15:00	2006-12-03 00:55:00
320	275	2006-12-02 21:15:00	2006-12-03 00:55:00
320	90	2006-12-02 21:15:00	2006-12-03 00:55:00
320	235	2006-12-02 22:31:37	2006-12-03 00:55:00
320	336	2006-12-02 23:22:06	2006-12-03 00:55:00
320	372	2006-12-02 21:15:00	2006-12-02 22:11:08
320	384	2006-12-02 21:15:00	2006-12-03 00:55:00
320	13	2006-12-02 21:15:00	2006-12-03 00:55:00
320	325	2006-12-02 21:15:00	2006-12-02 21:53:18
320	255	2006-12-02 23:05:11	2006-12-02 23:33:14
320	377	2006-12-02 21:15:00	2006-12-03 00:03:24
320	98	2006-12-02 21:15:00	2006-12-03 00:55:00
320	245	2006-12-02 21:15:00	2006-12-03 00:55:00
320	177	2006-12-02 22:37:26	2006-12-03 00:55:00
320	119	2006-12-02 21:15:00	2006-12-02 23:59:12
320	154	2006-12-02 21:15:00	2006-12-03 00:55:00
320	382	2006-12-02 21:15:00	2006-12-03 00:55:00
320	234	2006-12-03 00:32:43	2006-12-03 00:52:36
320	257	2006-12-02 21:15:00	2006-12-03 00:55:00
320	150	2006-12-02 21:15:00	2006-12-03 00:55:00
320	371	2006-12-02 21:15:00	2006-12-03 00:42:20
320	359	2006-12-02 23:59:11	2006-12-03 00:55:00
320	369	2006-12-02 21:15:00	2006-12-03 00:55:00
320	349	2006-12-02 21:15:00	2006-12-02 23:18:08
320	269	2006-12-02 21:15:00	2006-12-02 23:59:54
320	202	2006-12-02 21:15:00	2006-12-03 00:55:00
320	323	2006-12-03 00:05:01	2006-12-03 00:55:00
320	326	2006-12-02 21:15:00	2006-12-03 00:55:00
320	297	2006-12-02 21:15:00	2006-12-03 00:55:00
320	106	2006-12-02 21:15:00	2006-12-02 22:34:16
320	220	2006-12-02 21:15:00	2006-12-03 00:55:00
320	340	2006-12-02 21:15:00	2006-12-03 00:55:00
320	114	2006-12-02 23:30:26	2006-12-03 00:55:00
320	339	2006-12-02 21:47:59	2006-12-03 00:55:00
320	383	2006-12-03 00:01:46	2006-12-03 00:55:00
320	207	2006-12-02 21:15:00	2006-12-03 00:55:00
320	311	2006-12-02 21:26:25	2006-12-03 00:55:00
320	327	2006-12-02 21:53:46	2006-12-03 00:55:00
320	78	2006-12-02 21:15:00	2006-12-03 00:55:00
320	148	2006-12-02 21:15:00	2006-12-03 00:55:00
320	360	2006-12-02 21:15:00	2006-12-03 00:55:00
320	61	2006-12-02 21:15:00	2006-12-03 00:55:00
320	385	2006-12-02 21:15:00	2006-12-03 00:55:00
320	76	2006-12-02 21:15:00	2006-12-02 23:59:00
320	167	2006-12-02 21:15:00	2006-12-03 00:55:00
320	56	2006-12-02 21:15:00	2006-12-03 00:55:00
320	231	2006-12-02 21:15:00	2006-12-03 00:55:00
320	355	2006-12-02 21:15:00	2006-12-02 23:59:28
320	277	2006-12-02 21:15:00	2006-12-02 23:10:44
321	167	2006-12-03 20:13:45	\N
\.


--
-- Data for Name: dkp_adjustments; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY dkp_adjustments (id, toon_id, value, adj_date, reason, item_value, ct_value) FROM stdin;
228	159	0	2006-05-14	Clock Time	0	03:00:00
2	1	-1120	2006-03-09	ROSCO Items	0	00:00:00
231	157	-20	2006-05-23	Transfer from Ellessdee	0	17:14:40
5	4	841	2006-03-09	ROSCO DKP	0	00:00:00
6	1	150	2006-03-09	ROSCO DKP Corr.	0	00:00:00
7	2	27	2006-03-09	ROSCO DKP Corr.	0	00:00:00
8	3	3	2006-03-09	ROSCO DKP Adj.	0	00:00:00
9	4	114	2006-03-09	ROSCO DKP Corr.	0	00:00:00
10	4	-1000	2006-03-09	ROSCO Items	0	00:00:00
11	5	275	2006-03-09	ROSCO DKP	0	00:00:00
12	5	-160	2006-03-09	ROSCO Items	0	00:00:00
18	7	-320	2006-03-09	ROSCO Items	0	00:00:00
21	9	-480	2006-03-09	Reason	0	00:00:00
24	10	-771	2006-03-09	Mistake	0	00:00:00
25	10	0	2006-03-09	Mistake	0	-44:00:00
27	11	-840	2006-03-09	ROSCO Items	0	00:00:00
30	13	-920	2006-03-10	ROSCO Items	0	00:00:00
33	15	-680	2006-03-10	ROSCO Items	0	00:00:00
35	16	-600	2006-03-10	ROSCO Items	0	00:00:00
38	18	-600	2006-03-10	ROSCO Items	0	00:00:00
40	19	-1000	2006-03-11	ROSCO Items	0	00:00:00
42	20	-80	2006-03-11	ROSCO Items	0	00:00:00
44	21	-880	2006-03-11	ROSCO Items	0	00:00:00
46	22	-160	2006-03-11	ROSCO Items	0	00:00:00
48	23	-480	2006-03-11	ROSCO Items	0	00:00:00
51	25	-280	2006-03-11	ROSCO Items	0	00:00:00
54	27	-840	2006-03-11	ROSCO Items	0	00:00:00
56	28	-560	2006-03-11	ROSCO Items	0	00:00:00
58	29	-840	2006-03-11	ROSCO Items	0	00:00:00
60	30	-800	2006-03-11	ROSCO Items	0	00:00:00
62	31	-400	2006-03-11	Reason	0	00:00:00
64	31	-1275	2006-03-11	Mistake	0	-72:00:00
66	32	-1000	2006-03-11	ROSCO Items	0	00:00:00
68	33	-160	2006-03-11	ROSCO Items	0	00:00:00
70	34	-80	2006-03-11	ROSCO Items	0	00:00:00
72	35	-920	2006-03-11	ROSCO Items	0	00:00:00
74	36	-880	2006-03-11	ROSCO Items	0	00:00:00
76	37	-320	2006-03-12	ROSCO Items	0	00:00:00
80	40	-560	2006-03-12	ROSCO Items	0	00:00:00
82	41	-680	2006-03-12	ROSCO Items	0	00:00:00
84	42	-880	2006-03-12	ROSCO Items	0	00:00:00
86	43	-680	2006-03-12	ROSCO Items	0	00:00:00
89	45	-480	2006-03-12	ROSCO Items	0	00:00:00
91	46	-400	2006-03-12	ROSCO Items	0	00:00:00
93	47	-800	2006-03-12	ROSCO Items	0	00:00:00
226	153	0	2006-05-14	Extra Clock Time	0	03:00:00
95	48	640	2006-03-12	ROSCO Items	0	00:00:00
229	144	0	2006-05-14	Clock Time	0	05:00:00
97	49	-800	2006-03-12	ROSCO Items	0	00:00:00
98	48	-1280	2006-03-12	Mistake	0	00:00:00
100	50	-280	2006-03-12	ROSCO Items	0	00:00:00
102	51	-560	2006-03-12	ROSCO Items	0	00:00:00
104	52	-400	2006-03-12	ROSCO Items	0	00:00:00
106	53	-920	2006-03-12	ROSCO Items	0	00:00:00
111	57	0	2006-03-12	Reason	0	00:00:00
112	57	-520	2006-03-12	ROSCO Items	0	00:00:00
114	58	-920	2006-03-12	ROSCO Items	0	00:00:00
117	60	-560	2006-03-12	ROSCO Items	0	00:00:00
118	55	-47	2006-03-12	Mistake	0	00:00:00
120	62	-560	2006-03-12	ROSCO Items	0	00:00:00
125	1	-120	2006-03-12	ROSCO BWL Items	0	00:00:00
128	11	-80	2006-03-12	ROSCO BWL Items	0	00:00:00
140	35	-120	2006-03-12	ROSCO BWL Items	0	00:00:00
147	47	6	2006-03-12	ROSCO BWL DKP	0	00:00:00
149	48	-120	2006-03-12	ROSCO BWL Items	0	00:00:00
153	53	-120	2006-03-12	ROSCO BWL Item	0	00:00:00
157	2	0	2006-03-12	Mistake	0	-12:00:00
158	3	6	2006-03-12	HUZZ ZG DKP	0	00:00:00
159	5	29	2006-03-12	HUZZ ZG DKP	0	00:00:00
160	7	6	2006-03-12	HUZZ ZG DKP	0	00:00:00
161	65	6	2006-03-12	HUZZ ZG DKP	0	00:00:00
162	11	8	2006-03-12	HUZZ ZG DKP	0	00:00:00
163	16	6	2006-03-12	HUZZ ZG DKP	0	00:00:00
164	20	15	2006-03-12	HUZZ ZG DKP	0	00:00:00
165	25	12	2006-03-12	HUZZ ZG DKP	0	00:00:00
166	26	23	2006-03-12	HUZZ ZG DKP	0	00:00:00
167	30	38	2006-03-12	HUZZ ZG DKP	0	00:00:00
168	31	11	2006-03-12	HUZZ ZG DKP	0	00:00:00
169	32	38	2006-03-12	HUZZ ZG DKP	0	00:00:00
170	35	18	2006-03-12	HUZZ ZG DKP	0	00:00:00
171	36	38	2006-03-12	HUZZ ZG DKP	0	00:00:00
172	38	14	2006-03-12	HUZZ ZG DKP	0	00:00:00
173	40	6	2006-03-12	HUZZ ZG DKP	0	00:00:00
174	70	32	2006-03-12	HUZZ ZG DKP	0	00:00:00
175	41	12	2006-03-12	HUZZ ZG DKP	0	00:00:00
176	44	14	2006-03-12	HUZZ ZG DKP	0	00:00:00
177	47	18	2006-03-12	HUZZ ZG DKP	0	00:00:00
178	48	21	2006-03-12	HUZZ ZG DKP	0	00:00:00
179	51	12	2006-03-12	HUZZ ZG DKP	0	00:00:00
180	53	12	2006-03-12	HUZZ ZG DKP	0	00:00:00
181	54	20	2006-03-12	HUZZ ZG DKP	0	00:00:00
182	60	-2	2006-03-12	HUZZ ZG DKP	0	00:00:00
183	55	6	2006-03-12	HUZZ ZG DKP	0	00:00:00
184	57	-210	2006-03-12	Mistake	0	00:00:00
195	65	-80	2006-03-13	Robes of Prophecy 12 Mar	0	00:00:00
203	61	0	2006-03-18	ZG out of raid CT	0	04:00:00
204	59	0	2006-03-18	ZG out of raid CT	0	04:00:00
205	81	28	2006-03-20	19 Mar 2006 MC Run	0	06:00:00
206	82	12	2006-03-20	19 Mar 2006 MC Run	0	06:00:00
212	84	517	2006-04-09	ROSCO DKP	0	40:00:00
213	84	-400	2006-04-09	ROSCO Items	0	00:00:00
214	80	30	2006-03-15	HUZZ ZG DKP	0	00:00:00
215	124	0	2006-04-30	Waitlist DKP	0	07:00:00
216	133	0	2006-04-30	Waitlist Clocktime	0	05:00:00
217	144	0	2006-04-30	Waitlist Clocktime	0	05:00:00
218	82	0	2006-04-30	Waitlist Clocktime	0	03:00:00
219	100	0	2006-05-01	Warlord's Command	0	04:00:00
220	141	0	2006-05-01	LBRS	0	04:00:00
221	8	0	2006-05-01	LBRS	0	04:00:00
222	32	0	2006-05-01	LBRS	0	04:00:00
223	91	67	2006-05-01	Transfer to Wetaad	0	00:00:00
224	91	-134	2006-05-01	Mistake in Transfer	0	00:00:00
225	141	67	2006-05-01	Transfer to Tolroutan	0	00:00:00
1	1	956	2006-03-10	ROSCO DKP	0	73:00:00
3	2	177	2006-03-10	ROSCO 	0	40:00:00
4	3	23	2006-03-10	ROSCO DKP	0	04:00:00
13	6	60	2006-03-10	ROSCO DKP	0	08:00:00
14	5	0	2006-03-10	ROSCO CT	0	32:00:00
15	4	0	2006-03-10	ROSCO CT	0	70:00:00
16	3	0	2006-03-10	ROSCO CT	0	04:00:00
17	7	309	2006-03-10	ROSCO DKP	0	42:00:00
19	8	29	2006-03-10	ROSCO DKP	0	04:00:00
20	9	329	2006-03-10	ROSCO DKP	0	08:00:00
22	10	12	2006-03-10	ROSCO DKP	0	04:00:00
23	10	771	2006-03-10	ROSCO CT	0	44:00:00
26	11	771	2006-03-10	ROSCO DKP	0	44:00:00
28	12	11	2006-03-10	ROSCO DKP	0	08:00:00
29	13	925	2006-03-10	ROSCO DKP	0	52:00:00
31	14	7	2006-03-10	ROSCO DKP	0	04:00:00
32	15	917	2006-03-10	ROSCO DKP	0	70:00:00
34	16	725	2006-03-10	ROSCO DKP	0	68:00:00
36	17	60	2006-03-10	ROSCO DKP	0	12:00:00
37	18	815	2006-03-10	ROSCO DKP	0	60:00:00
39	19	1004	2006-03-10	ROSCO DKP	0	72:00:00
41	20	88	2006-03-10	ROSCO DKP	0	14:00:00
43	21	975	2006-03-10	ROSCO DKP	0	68:00:00
45	22	335	2006-03-10	ROSCO DKP	0	18:00:00
47	23	596	2006-03-10	Reason	0	52:00:00
49	24	189	2006-03-10	ROSCO DKP	0	28:00:00
50	25	343	2006-03-10	ROSCO DKP	0	54:00:00
52	26	36	2006-03-10	ROSCO DKP	0	04:00:00
53	27	1088	2006-03-10	ROSCO DKP	0	72:00:00
55	28	539	2006-03-10	ROSCO DKP	0	46:00:00
57	29	826	2006-03-10	ROSCO DKP	0	64:00:00
59	30	947	2006-03-10	ROSCO DKP	0	68:00:00
61	31	328	2006-03-10	ROSCO DKP	0	16:00:00
63	31	1275	2006-03-10	ROSCO DKP	0	72:00:00
65	32	1275	2006-03-10	ROSCO DKP	0	72:00:00
67	33	406	2006-03-10	ROSCO DKP	0	42:00:00
69	34	56	2006-03-10	ROSCO DKP	0	08:00:00
71	35	1150	2006-03-10	ROSCO DKP	0	54:00:00
73	36	954	2006-03-10	ROSCO DKP	0	70:00:00
75	37	439	2006-03-10	ROSCO DKP	0	32:00:00
77	38	5	2006-03-10	ROSCO DKP	0	04:00:00
78	39	16	2006-03-10	ROSCO DKP	0	12:00:00
79	40	746	2006-03-10	ROSCO DKP	0	66:00:00
81	41	805	2006-03-10	ROSCO DKP	0	64:00:00
83	42	1009	2006-03-10	ROSCO DKP	0	72:00:00
85	43	766	2006-03-10	ROSCO DKP	0	34:00:00
87	44	5	2006-03-10	ROSCO DKP	0	04:00:00
88	45	849	2006-03-10	ROSCO DKP	0	66:00:00
90	46	681	2006-03-10	ROSCO DKP	0	56:00:00
92	47	946	2006-03-10	Reason	0	54:00:00
94	48	1023	2006-03-10	ROSCO DKP	0	76:00:00
96	49	714	2006-03-10	ROSCO DKP	0	58:00:00
99	50	445	2006-03-10	ROSCO DKP	0	20:00:00
101	51	642	2006-03-10	ROSCO DKP	0	68:00:00
103	52	632	2006-03-10	ROSCO DKP	0	68:00:00
105	53	952	2006-03-10	ROSCO DKP	0	70:00:00
107	54	19	2006-03-10	ROSCO DKP	0	02:00:00
108	55	135	2006-03-10	ROSCO DKP	0	13:00:00
109	56	5	2006-03-10	ROSCO DKP	0	04:00:00
110	57	894	2006-03-10	ROSCO DKP	0	68:00:00
113	58	948	2006-03-10	ROSCO DKP	0	76:00:00
115	59	11	2006-03-10	Clock Time	0	08:00:00
116	60	790	2006-03-10	ROSCO DKP	0	60:00:00
119	62	559	2006-03-10	ROSCO DKP	0	44:00:00
121	63	62	2006-03-10	ROSCO DKP	0	12:00:00
122	64	100	2006-03-10	ROSCO DKP	0	12:00:00
123	1	67	2006-03-10	ROSCO BWL DKP	0	28:00:00
124	4	70	2006-03-10	ROSCO BWL DKP	0	28:00:00
126	13	51	2006-03-10	ROSCO BWL DKP	0	24:00:00
127	11	37	2006-03-10	ROSCO BWL DKP	0	16:00:00
129	15	74	2006-03-10	ROSCO BWL DKP	0	32:00:00
130	16	26	2006-03-10	ROSCO BWL DKP	0	12:00:00
131	18	14	2006-03-10	ROSCO BWL DKP	0	12:00:00
132	19	29	2006-03-10	ROSCO BWL DKP	0	12:00:00
133	21	7	2006-03-10	ROSCO BWL DKP	0	04:00:00
134	23	13	2006-03-10	ROSCO BWL DKP	0	04:00:00
135	29	56	2006-03-10	ROSCO BWL DKP	0	28:00:00
136	30	7	2006-03-10	ROSCO BWL DKP	0	04:00:00
137	32	73	2006-03-10	ROSCO BWL DKP	0	32:00:00
138	27	68	2006-03-10	ROSCO BWL DKP	0	28:00:00
139	35	50	2006-03-10	ROSCO BWL DKP	0	20:00:00
141	40	49	2006-03-10	ROSCO BWL DKP	0	20:00:00
142	41	7	2006-03-10	ROSCO BWL DKP	0	04:00:00
143	25	7	2006-03-10	ROSCO BWL DKP	0	04:00:00
144	42	29	2006-03-10	ROSCO BWL DKP	0	12:00:00
145	43	34	2006-03-10	ROSCO BWL DKP	0	16:00:00
146	45	13	2006-03-10	ROSCO BWL DKP	0	08:00:00
148	48	75	2006-03-10	ROSCO BWL DKP	0	32:00:00
150	50	7	2006-03-10	BWL DKP 	0	04:00:00
151	51	6	2006-03-10	ROSCO BWL DKP	0	04:00:00
152	53	69	2006-03-10	ROSCO BWL DKP	0	32:00:00
154	58	59	2006-03-10	ROSCO BWL DKP	0	24:00:00
155	60	68	2006-03-10	ROSCO BWL DKP	0	28:00:00
156	2	24	2006-03-10	HUZZ ZG DKP	0	12:00:00
189	72	117	2006-03-10	ROSCO DKP	0	20:00:00
227	150	0	2006-05-14	Clock Time	0	03:00:00
230	107	0	2006-05-14	Clock Time	0	05:00:00
232	136	17	2006-06-13	Left Early at Raid Leader's Request	0	02:14:16
233	76	-80	2006-07-03	EF Legs got missed somewhere	0	00:00:00
235	58	0	2006-07-07	Inactive Raider	0	-420:00:00
234	210	-320	2006-07-04	spent in a prior life	0	00:00:00
236	206	-320	2006-06-24	spent in a prior life	0	00:00:00
237	209	-320	2006-06-27	spent in a prior life	0	00:00:00
238	227	-320	2006-07-10	spent in a prior life	0	00:00:00
239	61	12	2006-07-20	Left early at raid leader's request	0	03:15:00
240	222	12	2006-07-20	Left early at raid leader's request	0	03:15:00
241	61	10	2006-08-03	Garkar screwed up invites	0	01:19:18
242	259	14	2006-08-03	Left Early at Raid Leader's Request	0	01:57:00
243	259	-320	2006-08-04	spent in a prior life	0	00:00:00
244	265	-320	2006-08-09	spent in a prior life	0	00:00:00
245	271	-320	2006-08-14	spent in a prior life	0	00:00:00
246	255	-320	2006-08-06	spent in a prior life	0	00:00:00
247	284	0	2006-09-02	onxyia Waitlist 	0	00:30:00
248	206	20	2006-09-05	ZG ring erroneously charged	0	00:00:00
249	282	-320	2006-09-16	Spent in a prior life	0	00:00:00
250	300	-320	2006-09-16	spent in a prior life	0	00:00:00
251	234	-320	2006-09-16	spent in a prior life	0	00:00:00
260	318	-320	2006-10-08	Vet adjustment	0	00:00:00
253	42	0	2006-10-02	reactivated	0	00:00:01
254	315	-320	2006-10-02	spent in a prior life	0	00:00:00
255	271	0	2006-10-02	inactive	0	-01:21:51
256	258	0	2006-10-02	inactive	0	-101:01:39
257	265	0	2006-10-02	inactive	0	-03:32:17
258	243	0	2006-10-02	inactive	0	-22:20:00
259	283	-320	2006-10-02	spent in a prior life	0	00:00:00
261	1	-29	2006-10-08	Wasn't in raid 9/30/06	0	00:00:00
262	148	-28	2006-10-08	Wasn't in raid 10/8/06	0	00:00:00
263	316	-320	2006-10-16	spent in a prior life	0	00:00:00
264	283	0	2006-10-17	he likes demise	0	-85:00:00
265	148	-27	2006-10-17	Wasn't in raid 10/16/06	0	00:00:00
266	325	-320	2006-10-18	Vet = Owey	0	00:00:00
267	171	0	2006-10-18	no more raids per Awry	0	-81:00:00
268	318	0	2006-10-23	inactive	0	-14:22:42
269	316	320	2006-10-23	/inspect tells a different story	0	00:00:00
270	322	-320	2006-10-24	spent in a prior life	0	00:00:00
271	334	-320	2006-10-24	Vet meh!	0	00:00:00
272	7	0	2006-11-05	reactivation	0	00:00:01
273	236	0	2006-11-06	reactivation	0	00:00:01
274	156	-4	2006-11-11	brought alt to raid	0	03:40:00
275	257	-28	2006-11-12	wasn't in MC 11/11	0	-03:15:00
276	319	-28	2006-11-12	Wasn't in MC 11/11	0	-03:15:00
277	59	-18	2006-11-13	Was there only for Garr	0	00:00:00
278	354	-320	2006-11-14	spent in a prior life	0	00:00:00
279	28	-23	2006-11-25	toon-swap per raid leader	0	-03:30:00
280	56	23	2006-11-27	toon-swap per raid leader	0	03:30:00
281	382	-320	2006-12-02	vet adjustment	0	00:00:00
\.


--
-- Data for Name: dungeon_bosses; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY dungeon_bosses (id, dungeon_id, name, value) FROM stdin;
\.


--
-- Data for Name: dungeon_loot_types; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY dungeon_loot_types (id, name, shortdesc) FROM stdin;
1	Assigned DKP Value	STATIC
2	Kill-Based DKP	KILLBASED
\.


--
-- Data for Name: dungeons; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY dungeons (id, loot_type, value, name, content_tier) FROM stdin;
1	1	0	Molten Core	1
2	1	0	Onyxia's Lair	1
3	1	0	Blackwing Lair	1
4	1	0	Ruins of Ahn'Qiraj	1
5	1	0	Zul'Gurub	1
6	1	0	Temple of Ahn'Qiraj	1
7	1	0	World Encounter	1
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY items (id, name, value, bank_inventory, dungeon_id) FROM stdin;
239	Claw of the Black Drake	120	0	3
245	Dragon's Touch	120	0	3
338	Boots of Unwavering Will	80	0	6
158	Stormrage Bracers	120	1	3
251	Belt of Transcendence	120	0	3
256	Drake Talon Cleaver	120	1	3
151	Earthfury Bracers	0	2	1
67	Vambraces of Prophecy	0	1	1
265	Dragonstalker's Spaulders	120	0	3
31	Cenarion Boots	80	2	1
95	Gold	0	0	\N
96	Dark Iron Ore	0	0	\N
89	Skullflame Shield	0	0	\N
110	Jeweled Amulet of Cainwyn	0	0	\N
144	Blood of the Mountain	0	1	\N
240	Handguards of Transcendence	120	0	3
55	Girdle of Prophecy	0	3	1
246	Ringo's Blizzard Boots	80	0	3
349	Belt of the Dark Bog	40	0	7
321	Cloak of Concentrated Hatred	120	0	6
247	Seal of the Gurubashi Beserker	20	0	5
252	Lifegiving Gem	40	0	3
257	Natural Alignment Crystal	40	0	3
262	Gurubashi Dwarf Destroyer	20	0	5
266	Chromatically Tempered Sword	120	0	3
270	Maladath, Runed Blade of the Black Flight	120	0	3
94	Nexus Crystal	0	53	\N
27	Netherwind Crown	120	1	2
5	Aged Core Leather Gloves	40	0	1
185	Zin'rokh, Destroyer of Worlds	20	0	5
40	Mantle of Prophecy	80	1	1
107	Wristguards of Stability	80	0	1
141	Will of Arlokk	20	0	5
221	Vis'kag the Bloodletter	120	0	2
197	Vestments of the Shifting Sand	20	0	4
216	Netherwind Gloves	120	3	3
162	Touch of Chaos	20	0	5
192	The Untamed Blade	120	0	3
82	Talisman of Ephemeral Power	80	0	1
26	Head of Onyxia	120	1	2
33	Striker's Mark	80	0	1
123	Stormrage Legguards	120	0	1
227	Stormrage Handguards	120	0	3
263	Bloodlord's Defender	20	0	5
212	Sabatons of Wrath	120	2	3
157	Stormrage Belt	120	0	3
62	Staff of Dominance	80	0	1
156	Spineshatter	120	0	3
63	Nightslayer Belt	0	1	1
6	Sorcerous Dagger	40	0	1
86	Sulfuron Ingot	0	10	1
226	Shroud of Pure Thought	120	0	3
253	Waistband of Wrath	120	0	3
39	Seal of the Archmagus	80	0	1
161	Seafury Gauntlets	20	0	5
171	Soul Corrupter's Necklace	20	1	5
159	Sapphiron Drape	120	0	2
88	Salamander Scale Pants	80	0	1
54	Sabatons of the Flamewaker	40	0	1
181	Sabatons of Might	80	0	1
173	Runed Bloodstained Hauberk	20	0	5
14	Robes of Prophecy	80	0	1
120	Robe of Volatile Power	80	0	1
119	Ring of Spell Power	80	0	1
214	Ring of Blackrock	120	0	3
92	Ring of Binding	80	0	2
135	Qiraji Sacrificial Dagger	20	0	4
207	Pendant of the Fallen Dragon	120	0	3
83	Pauldrons of Might	80	0	1
108	Pants of Prophecy	80	0	1
170	Onyxia Hide Backpack	0	0	2
106	Onslaught Girdle	120	0	1
248	Warblade of the Hakkari (MH)	20	0	5
53	Nightslayer Pants	80	0	1
4	Nightslayer Leggings	80	0	1
153	Shadowstrike	0	4	1
36	Nightslayer Cover	80	0	1
118	Nightslayer Chestpiece	80	0	1
29	Nemesis Skullcap	120	1	2
117	Nightslayer Boots	80	0	1
184	Netherwind Bindings	120	1	3
47	Netherwind Pants	120	0	1
269	Stormrage Boots	120	1	3
193	Felheart Belt	0	7	1
188	Netherwind Boots	120	0	3
91	Wild Growth Spaulders	80	1	1
222	Deep Earth Spaulders	80	1	1
333	Robes of the Triumvirate	40	0	6
24	Nemesis Leggings	120	0	1
169	Nemesis Bracers	120	0	3
154	Nemesis Belt	120	0	3
32	Medallion of Steadfast Might	80	0	1
98	Marli's Touch	20	0	5
238	Bracelets of Wrath	120	3	3
49	Earthfury Gauntlets	80	1	1
35	Manastorm Leggings	80	0	1
18	Mana Igniting Cord	80	0	1
48	Malistar's Defender	120	0	1
130	Legplates of Wrath	120	0	1
164	Legplates of Ten Storms	120	0	1
174	Legplates of Might	80	0	1
152	Leggings of Transcendence	120	0	1
124	Jeklik's Crusher	20	0	5
178	Mantle of the Blackwing Cabal 	80	1	3
90	Helm of the Lifegiver	40	0	1
364	Rittsyn's Ring of Chaos	120	0	6
9	Helm of Might	80	0	1
167	Helm of Endless Rage	120	0	3
99	Heavy Dark Iron Ring	80	0	1
115	Cenarion Bracers	0	1	1
138	Heart of Hakkar	20	0	5
121	Sash of Whispered Secrets	80	2	1
50	Halo of Transcendence	120	0	2
206	Greaves of Ten Storms	120	0	3
122	Helm of Wrath	120	1	2
258	Drake Fang Talisman	120	0	3
57	Giantstalker's Helmet	80	0	1
10	Giantstalker's Gloves	80	0	1
60	Giantstalker's Epaulets	80	0	1
13	Giantstalker's Breastplate	80	0	1
79	Giantstalker's Boots	80	0	1
254	Mind Quickening Gem	40	0	3
182	Gauntlets of the Immovable	20	0	4
52	Gauntlets of Might	80	0	1
136	Foror's Eyepatch	20	0	5
220	Flowing Ritual Robes	20	0	5
58	Flameguard Gauntlets	80	0	1
189	Heartstriker	80	1	3
236	Firemaw's Clutch	120	0	3
261	Emberweave Leggings	80	3	3
104	Fire Runed Grimoire	80	0	1
11	Felheart Slippers	80	0	1
142	Fiery Core	0	37	1
143	Lava Core	0	12	1
17	Felheart Shoulder Pads	80	0	1
87	Felheart Robes	80	0	1
175	Felheart Pants	80	0	1
8	Felheart Horns	80	0	1
2	Felheart Gloves	80	0	1
259	Doom's Edge	120	0	3
140	Fang of the Faceless	20	0	5
109	Fang of Venoxis	20	0	5
163	Eye of Sulfuras	120	0	1
172	Eye of Hakkar	20	0	5
20	Eye of Divinity	80	0	1
249	Warblade of the Hakkari (OH)	20	0	5
223	Essence Gatherer	80	0	3
34	Eskhandar's Right Claw	80	0	1
21	Fireproof Cloak	80	2	1
3	Earthfury Legguards	80	0	1
37	Earthfury Helmet	80	0	1
77	Core Forged Greaves	40	1	1
177	Dragonstalker's Belt	120	2	3
200	Earthfury Boots	80	0	1
68	Earthfury Belt	0	0	1
103	Drillborer Disk	80	0	1
323	Stormrage Chestguard	120	0	3
23	Dragonstalker's Legguards	120	0	1
160	Dragonstalker's Helm	120	0	2
243	Shadow Wing Focus Staff	120	0	3
229	Dragonstalker's Gauntlets	120	0	3
209	Dragonstalker's Bracers	120	0	3
296	Primalist's Linked Waistguard	120	2	3
191	Dragonfang Blade	120	0	3
22	Dragon's Blood Cape	120	0	1
211	Draconic Maul	80	0	3
232	Draconic Avenger	80	0	3
201	Deathbringer	120	0	2
46	Crown of Destruction	120	0	1
131	Crimson Shocker	80	0	1
97	Core Leather	0	31	1
150	Core Hound Tooth	80	0	1
352	Leggings of Immersion	80	1	6
129	Cloak of the Shrouded Mists	120	0	1
166	Cloak of Draconic Might	40	0	3
219	Cloak of Consumption	20	0	5
116	Circlet of Prophecy	80	0	1
65	Choker of the Fire Lord	120	0	1
1	Choker of Enlightenment	80	0	1
61	Cenarion Vestments	80	0	1
313	Prestor's Talisman of Connivery	120	0	3
344	Staff of the Ruins	20	0	4
149	Cauterizing Band	80	0	1
30	Buru's Skull Fragment	20	0	4
38	Brutality Blade	80	0	1
75	Breastplate of Might	80	0	1
100	Giantstalker's Belt	0	3	1
210	Bracers of Ten Storms	120	0	3
205	Bracers of Arcane Accuracy	120	0	3
231	Boots of Transcendence	120	0	3
127	Cenarion Gloves	80	2	1
183	Boots of Pure Thought	80	0	3
59	Boots of Prophecy	80	0	1
126	Bonereaver's Edge	120	0	1
195	Bloodsoaked Legplates	20	0	5
102	Bloodfang Pants	120	0	1
101	Bracers of Might	0	2	1
176	Bloodfang Bracers	120	0	3
139	Bloodcaller	20	0	5
113	Blastershot Launcher	80	0	1
194	Bindings of the Windseeker	80	0	1
51	Bloodfang Hood	120	1	2
125	Betrayer's Boots	20	0	5
168	Belt of Ten Storms	120	0	3
25	Band of Sulfuras	120	0	1
228	Band of Forced Concentration	120	0	3
224	Band of Dark Dominion	80	0	3
64	Band of Accuria	120	0	1
15	Azuresong Mageblade	80	0	1
111	Aurastone Hammer	80	0	1
196	Arlokk's Grasp	20	0	5
180	Arcanist Robes	80	0	1
44	Ancient Petrified Leaf	80	1	1
72	Arcanist Leggings	80	0	1
73	Arcanist Gloves	80	0	1
146	Arcanist Crown	80	0	1
19	Wristguards of True Flight	40	2	1
309	Boots of the Vanguard	20	0	4
260	Rejuvenating Gem	120	0	3
355	Neretzek, The Blood Drinker	120	0	6
199	Ancient Hakkari Manslayer	20	0	5
288	Giantstalker's Leggings	80	0	1
204	Cenarion Spaulders	80	0	1
244	Malfurion's Blessed Bulwark	120	0	3
250	Band of Servitude	20	0	5
69	Nightslayer Bracelets	0	4	1
292	Gauntlets of Ten Storms	120	0	3
71	Arcanist Boots	80	1	1
264	Nemesis Spaulders	120	0	3
272	Styleen's Impending Scarab	120	0	3
273	Aegis of the Blood God	20	0	5
274	Chromatic Boots	120	0	3
342	Head of Ossirian the Unscarred	20	0	4
277	Ebony Flame Gloves	120	0	3
278	Dustwind Turban	20	0	4
279	Perdition's Blade	120	0	1
280	Circle of Applied Force	120	0	3
282	Stormrage Pauldrons	120	0	3
283	Empowered Leggings	120	0	3
133	Arcane Infused Gem	40	0	3
78	Essence of the Pure Flame	40	1	1
357	Badge of the Swarmguard	120	0	6
322	Claw of Chromaggus	120	0	3
284	Elementium Threaded Cloak	120	0	3
12	Nightslayer Shoulder Pads	80	1	1
312	Neltharion's Tear	120	0	3
299	Breastplate of Ten Storms	120	0	3
137	Halberd of Smiting	20	0	5
134	Manslayer of the Qiraj	20	0	4
255	Black Brood Pauldrons	120	1	3
314	Nemesis Robes	120	0	3
329	Netherwind Mantle	120	0	3
165	Stormrage Cover	120	2	2
267	Shimmering Geta	120	2	3
286	Cloak of Firemaw	120	0	3
287	Nemesis Gloves	120	0	3
242	The Black Book	40	4	3
350	Black Bark Wristbands	80	0	7
147	Felheart Bracers	0	4	1
112	Belt of Might	0	2	1
276	Gauntlets of Wrath	120	1	3
289	Pauldrons of Wrath	120	0	3
290	Elementium Reinforced Bulwark	120	0	3
291	Ashjre'thul, Crossbow of Smiting	120	0	3
268	Gloves of Rapid Evolution	120	1	3
190	Bloodfang Belt	120	1	3
293	Bloodfang Gloves	120	0	3
114	Cenarion Belt	0	3	1
93	Giantstalker's Bracers	0	3	1
334	Cloak of the Brood Lord	120	0	3
297	Helmet of Ten Storms	120	0	2
315	Angelista's Grasp	80	2	3
353	Helm of Narv	0	0	\N
298	Quick Strike Ring	80	0	1
300	Robes of Transcendence	120	0	3
301	Therazane's Link	120	0	3
302	Archimtiros' Ring of Reckoning	120	0	3
303	Head of Nefarian	120	0	3
179	Red Dragonscale Protector 	120	1	3
304	Taut Dragonhide Belt	120	0	3
305	Bloodfang Spaulders	120	0	3
306	Thekal's Grasp	20	0	5
275	Pauldrons of Transcendence	120	1	3
307	Shard of the Scale	120	0	2
76	Cenarion Helm	80	1	1
324	Breastplate of Wrath	120	0	3
308	Finkle's Lava Dredger	80	0	1
84	Arcanist Belt	0	6	1
74	Arcanist Mantle	80	1	1
187	Dragonstalker's Greaves	120	1	3
66	Cenarion Leggings	80	1	1
28	Eskhandar's Collar	80	1	2
215	Primalist's Linked Legguards	120	1	3
310	Dragonbreath Handcannon	120	0	3
7	Gloves of Prophecy	80	1	1
345	Silithid Carapace Chestguard	40	0	6
132	Bindings of Transcendence	120	2	3
326	Mish'undare Circlet of the Mind Flayer	120	0	3
359	Imperial Qiraji Armaments	120	0	6
128	Fireguard Shoulders	40	0	1
80	Gloves of the Hypnotic Flame	40	2	1
155	Rune of Metamorphosis	40	1	3
316	Dragonstalker's Breastplate	120	0	3
317	Lok'amir il Romathis	120	0	3
318	Netherwind Robes	120	0	3
319	Pure Elementium Band	120	0	3
320	Breastplate of Annihilation	120	0	6
285	Bloodfang Boots	120	1	3
241	Nemesis Boots	120	2	3
311	Taut Dragonhide Gloves	120	3	3
198	Slimy Scaled Gauntlets	20	0	4
203	Ancient Cornerstone Grimoire	80	2	2
294	Epaulets of Ten Storms	120	1	3
213	Venomous Totem	40	2	3
85	Arcanist Bindings	0	5	1
233	Interlaced Shadow Jerkin	40	1	3
331	Boots of the Fallen Prophet	120	0	6
330	Bloodfang Chestpiece	120	0	3
81	Nightslayer Gloves	80	1	1
339	New Progression Bonus	0	3	\N
335	Staff of the Shadow Flame	120	0	3
186	Head of the Broodlord Lashlayer	0	5	3
336	Carebear Fork	0	0	\N
208	Netherwind Belt	120	1	3
343	Shackles of the Unscarred	20	0	4
234	Drake Talon Pauldrons	120	3	3
340	Jin'Do's Evil Eye	20	0	5
295	Taut Dragonhide Shoulderpads	120	2	3
56	Gutgore Ripper	80	1	1
337	Amulet of Foul Warding	40	0	6
105	Obsidian Edged Blade	80	3	1
346	Recomposed Boots	40	0	6
332	Ooze-ridden Gauntlets	40	0	6
347	Bile-Covered Gauntlets	40	0	6
341	Beetle Scaled Wristguards	40	0	6
348	Necklace of Purity	40	0	6
70	Earthshaker	80	3	1
217	Aegis of Preservation	40	5	3
354	Crul'shorukh, Edge of Chaos	120	0	3
356	Hammer of Ji'zhi	120	0	6
358	Thick Qirajihide Belt	120	0	6
360	Jin'Do's Hexxer	20	0	5
328	Black Ash Robe	40	1	3
361	Herald of Woe	120	0	3
16	Earthfury Epaulets	80	2	1
42	Earthfury Vestments	80	3	1
363	Gauntlets of Steadfast Determination	120	0	6
362	Barrage Shoulders	120	1	6
365	Talon of Furious Concentration	20	0	4
351	Nightmare Engulfed Object	40	0	7
\.


--
-- Data for Name: loot; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY loot (id, raid_id, toon_id, item_id, value) FROM stdin;
1	1	40	1	80
2	1	55	3	80
3	1	38	4	80
4	1	11	6	40
5	1	47	8	80
6	1	2	9	80
7	1	14	12	80
8	1	40	18	80
9	1	46	13	80
10	1	43	15	80
11	1	60	16	80
12	3	21	26	120
13	3	50	28	80
14	3	52	27	120
15	2	55	19	40
16	2	65	20	80
17	2	19	21	80
18	2	58	22	120
19	2	48	23	120
20	2	32	24	120
21	2	15	25	120
22	6	50	30	20
23	10	7	31	80
24	10	1	32	80
25	10	4	33	80
26	10	58	34	80
27	10	71	35	80
28	10	14	36	80
29	10	5	37	80
30	10	50	38	80
31	10	15	39	80
32	10	60	42	80
33	10	71	40	80
34	10	51	18	80
35	10	67	44	80
36	10	45	23	120
37	10	45	46	120
73	4	75	12	80
39	10	52	47	120
40	10	30	48	120
41	10	5	49	80
42	11	18	50	120
43	11	38	51	120
44	1	67	10	80
45	1	71	7	80
46	11	105	26	120
47	4	37	31	80
48	4	2	52	80
49	4	75	53	80
74	22	98	66	80
51	4	82	7	80
75	22	89	67	0
53	4	14	56	80
54	4	67	57	80
55	4	2	38	80
56	4	5	39	80
57	4	2	58	80
58	4	103	59	80
59	4	106	60	80
60	4	37	61	80
61	4	82	14	80
62	4	51	62	80
76	22	75	69	0
50	4	72	54	40
52	4	103	55	0
63	4	38	63	0
64	19	35	21	80
65	19	109	20	80
66	19	16	64	120
67	19	21	24	120
68	19	25	47	120
69	19	32	65	120
70	20	40	27	120
71	20	96	50	120
72	20	27	26	120
77	22	55	68	0
78	22	72	70	80
79	22	54	33	80
80	24	115	71	80
81	24	66	72	80
82	24	7	66	80
83	24	33	52	80
84	25	71	67	0
85	25	24	81	80
86	25	106	79	80
87	25	24	36	80
88	25	7	76	80
89	25	19	82	80
90	25	28	16	80
91	25	67	60	80
92	25	2	75	80
93	25	2	77	40
94	25	83	80	40
95	25	71	20	80
96	25	1	22	120
97	25	43	47	120
98	25	67	23	120
134	33	33	30	20
100	25	39	83	80
101	25	-1	73	80
102	25	-1	74	80
103	25	-1	69	0
104	1	-1	84	0
105	1	-1	85	0
106	1	-1	2	80
107	1	-1	17	80
108	1	-1	11	80
109	1	-1	86	0
110	3	-1	29	120
111	10	-1	5	40
112	10	-1	85	0
113	10	-1	73	80
114	10	-1	2	80
115	10	-1	87	80
116	10	-1	12	80
117	10	-1	88	80
118	18	-1	89	0
119	4	-1	73	80
120	4	-1	90	80
121	19	-1	91	80
122	20	-1	92	120
123	22	-1	71	80
125	22	-1	2	80
126	22	-1	93	0
99	25	58	78	40
127	31	35	98	20
128	32	33	34	80
129	32	-1	72	80
130	32	85	66	80
131	32	1	99	80
132	32	-1	71	80
133	32	-1	100	0
135	27	50	101	0
136	27	-1	5	40
194	40	50	122	120
138	27	2	44	0
139	27	-1	84	0
140	27	30	25	120
141	27	16	102	120
142	27	38	102	120
143	27	33	77	40
144	27	39	103	80
145	27	28	42	80
146	27	62	87	80
147	27	97	17	80
148	27	25	104	80
149	27	-1	93	0
150	27	-1	10	80
151	27	96	7	80
152	27	119	80	40
153	27	24	56	80
154	27	119	35	80
155	27	96	40	80
156	27	38	12	80
157	27	100	105	80
158	27	58	106	120
159	27	-1	107	80
160	36	60	1	80
161	36	26	3	80
162	36	-1	2	80
163	36	103	108	80
164	36	55	54	40
165	38	25	109	20
166	38	36	110	0
167	34	24	63	0
168	34	71	55	0
169	34	106	44	80
170	34	23	111	80
171	34	-1	112	0
172	34	46	113	80
193	40	45	26	120
174	34	-1	114	0
175	34	-1	115	0
176	34	23	76	80
177	34	121	116	80
178	34	5	16	80
179	34	139	49	80
180	34	5	42	80
181	34	106	10	80
182	34	-1	55	0
183	34	138	80	40
184	34	121	40	80
195	40	51	27	120
186	34	16	117	80
187	34	-1	69	0
188	34	16	118	80
189	34	97	119	80
190	34	109	120	80
191	34	3	121	80
192	34	46	39	80
196	40	-1	92	120
197	41	14	102	120
198	41	48	46	120
199	41	60	48	120
200	41	-1	69	0
201	41	27	123	120
202	46	39	124	20
203	46	41	125	20
204	39	50	126	120
205	39	6	63	0
206	39	103	116	80
207	39	8	76	80
208	39	28	111	80
209	39	-1	74	80
210	39	57	16	80
211	39	8	127	80
212	39	-1	11	80
213	39	-1	84	0
214	39	-1	60	80
215	39	6	12	80
216	39	48	13	80
217	39	-1	87	80
218	39	55	62	80
219	39	61	77	40
220	39	7	128	0
221	39	121	44	0
222	39	48	129	120
223	39	50	130	120
224	39	15	123	120
225	39	60	46	120
235	51	62	29	120
236	51	19	26	120
228	48	98	31	80
229	48	52	72	80
227	39	25	131	80
226	39	55	49	80
230	49	25	27	120
231	49	2	28	80
232	49	121	50	120
233	49	49	26	120
237	50	36	132	120
238	50	41	132	120
239	50	-1	133	40
240	52	2	134	20
241	52	6	135	20
242	54	147	136	20
243	54	39	137	20
244	55	97	139	20
417	89	15	138	20
246	55	4	138	20
247	55	8	141	20
248	56	61	52	80
249	56	61	105	80
250	56	8	66	80
251	47	81	146	80
252	47	-1	74	80
253	47	116	113	80
254	47	-1	101	0
255	47	57	149	80
256	47	-1	115	0
257	47	-1	127	80
258	47	-1	76	80
259	47	52	65	120
260	47	45	129	120
261	47	6	150	80
262	47	81	131	80
263	47	150	151	0
264	47	144	151	0
265	47	-1	147	0
266	47	-1	147	0
267	47	23	104	80
268	47	49	104	80
269	47	67	13	80
270	47	35	152	120
271	47	51	47	120
272	47	24	117	80
273	47	24	118	80
274	47	14	81	80
275	47	44	12	80
276	47	82	153	0
277	47	103	20	80
278	58	29	132	120
279	58	32	154	120
280	58	15	155	40
281	58	59	156	120
282	58	42	157	120
283	58	27	158	120
284	59	31	29	120
285	59	46	160	120
286	59	19	159	120
287	59	15	26	120
288	62	5	161	20
289	62	32	162	20
290	62	30	138	20
291	63	58	32	80
292	63	115	72	80
293	63	115	84	0
294	63	115	84	0
295	63	115	85	0
296	63	61	34	80
297	62	32	125	20
298	64	51	65	120
299	64	49	24	120
300	64	39	22	120
301	64	8	91	80
302	64	56	44	80
303	64	25	15	80
304	64	44	118	80
305	64	57	42	80
306	64	33	83	80
307	64	136	40	80
722	143	39	112	0
309	64	52	146	80
310	64	6	81	80
311	64	60	163	120
312	64	39	54	40
313	66	54	28	80
314	66	42	165	120
315	66	4	26	120
316	64	30	164	120
317	67	-1	166	40
318	67	58	167	120
319	67	27	157	120
320	67	30	168	120
321	67	-1	133	40
322	67	49	169	120
323	67	96	132	120
324	68	107	28	80
325	68	15	165	120
326	68	33	122	120
327	68	51	26	120
328	68	21	170	0
329	70	33	134	20
330	71	40	138	20
331	71	115	171	20
332	71	100	172	20
333	71	26	173	20
334	73	59	174	80
335	73	59	52	80
336	73	64	71	80
340	75	136	132	120
338	73	107	54	40
339	73	97	175	80
373	77	33	182	20
342	75	31	154	120
343	75	19	178	80
344	75	28	179	120
345	74	7	78	40
346	74	97	24	120
347	74	106	23	120
348	74	57	48	120
349	74	115	80	40
350	74	97	121	80
351	74	96	20	80
352	74	-1	147	0
353	74	-1	101	0
354	74	-1	86	0
355	74	19	180	80
356	74	50	75	80
357	74	24	12	80
358	74	-1	153	0
359	74	14	117	80
360	74	-1	127	80
361	74	26	16	80
362	74	129	74	80
363	74	-1	54	40
364	74	-1	76	80
365	74	62	8	80
366	74	-1	84	0
367	74	76	151	0
368	74	-1	151	0
369	74	58	181	80
370	74	103	7	80
371	74	58	113	80
372	75	45	177	120
341	75	4	176	120
374	78	100	30	20
375	79	81	139	20
376	79	81	171	20
377	79	51	138	20
378	82	-1	66	80
379	82	5	1	80
380	82	100	52	80
381	82	157	63	0
382	82	-1	105	80
383	82	141	33	80
384	81	16	51	120
385	81	82	50	120
386	81	33	26	120
387	81	51	159	120
388	81	59	170	0
389	84	35	183	80
390	83	24	176	120
391	83	81	184	120
392	83	7	155	40
393	83	23	157	120
394	83	15	157	120
395	83	-1	133	40
396	80	28	46	120
397	80	31	24	120
398	80	6	102	120
399	80	67	64	120
400	80	98	91	80
401	80	116	44	80
402	80	-1	80	40
403	80	14	118	80
404	80	8	61	80
405	80	135	12	80
406	80	103	40	80
407	80	-1	11	80
408	80	98	127	80
409	80	63	16	80
410	80	-1	74	80
411	80	44	38	80
412	80	-1	146	80
413	80	-1	100	0
414	80	63	6	40
415	80	89	7	80
245	55	157	140	20
416	89	100	185	20
418	89	135	172	20
419	91	39	34	80
420	91	33	32	80
421	91	96	108	80
422	91	15	1	80
423	91	76	6	40
1143	206	267	9	80
427	88	40	27	120
428	90	38	190	120
429	90	14	176	120
430	90	4	191	120
431	90	48	177	120
432	90	42	158	120
433	90	1	192	120
1605	270	279	10	80
436	88	48	187	120
437	100	160	44	80
438	100	144	111	80
439	100	154	77	40
440	100	21	131	80
441	100	144	49	80
442	100	153	193	0
443	100	153	11	80
501	108	-1	71	80
445	100	33	194	80
446	100	160	13	80
447	100	153	80	40
448	100	16	56	80
449	100	60	164	120
450	100	57	164	120
451	100	109	40	80
452	100	133	105	80
453	100	2	106	120
454	100	96	14	80
455	100	142	39	80
456	100	42	62	80
457	93	58	195	20
458	93	60	161	20
459	93	60	138	20
460	93	44	196	20
461	93	30	109	20
462	98	81	62	80
463	98	116	23	120
464	98	165	24	120
465	98	2	22	120
466	98	-1	69	0
467	98	89	44	0
468	98	27	91	80
469	98	81	21	80
470	98	6	118	80
471	98	39	75	80
472	98	-1	153	0
473	98	136	35	80
474	98	165	11	80
475	98	55	16	80
476	98	44	56	80
477	98	-1	79	80
478	98	136	7	80
479	98	155	151	0
480	98	55	151	0
481	98	-1	151	0
444	100	116	79	80
482	105	32	197	20
483	105	61	134	20
484	105	150	198	20
485	107	5	199	20
486	107	41	162	20
487	107	41	138	20
488	107	54	196	20
489	97	60	200	80
490	97	190	2	80
491	97	155	3	80
492	97	89	108	80
493	97	154	70	80
494	102	1	201	120
495	102	136	50	120
536	113	-1	133	40
497	102	136	203	80
498	102	42	26	120
499	102	135	170	0
500	108	96	55	0
502	108	156	52	80
503	108	58	112	0
504	108	142	7	80
505	108	97	120	80
506	108	6	36	80
507	108	100	9	80
508	108	5	111	80
509	108	96	39	80
510	108	56	10	80
511	108	-1	11	80
512	108	142	40	80
513	108	2	83	80
514	108	142	14	80
515	108	40	15	80
516	108	-1	204	80
517	108	186	13	80
518	110	153	147	0
519	110	96	152	120
520	110	29	152	120
521	110	28	22	120
522	110	114	20	80
523	110	-1	78	40
524	110	55	21	80
525	116	43	205	120
526	116	30	206	120
527	116	45	187	120
1597	270	279	44	80
529	116	42	207	120
530	116	40	208	120
531	116	14	190	120
532	116	-1	133	40
533	116	142	132	120
534	116	45	209	120
496	102	160	160	120
535	108	142	108	80
537	113	6	190	120
538	113	16	190	120
539	113	30	210	120
540	113	23	211	80
541	113	46	209	120
1606	270	109	152	120
543	113	1	167	120
544	113	51	188	120
545	113	1	212	120
546	113	-1	213	40
547	110	150	19	40
548	118	51	216	120
549	118	76	215	120
550	118	23	214	120
551	111	100	195	20
552	111	32	219	20
553	111	49	138	20
554	111	49	220	20
555	118	-1	217	40
556	122	58	26	120
557	122	43	27	120
558	122	116	160	120
559	122	49	159	120
560	122	24	221	120
561	114	2	195	20
562	114	24	138	20
563	114	28	161	20
720	140	198	14	80
565	117	-1	85	0
566	117	155	111	80
567	117	52	15	80
568	117	100	101	0
569	117	154	101	0
570	117	-1	31	80
571	117	-1	204	80
572	117	59	103	80
573	117	107	3	80
574	117	55	42	80
601	127	52	180	80
576	117	199	2	80
577	117	199	17	80
578	117	186	10	80
579	117	-1	7	80
580	117	187	56	80
581	117	58	99	80
582	117	84	40	80
583	117	59	83	80
584	117	162	6	40
585	117	24	33	80
586	123	-1	85	0
587	123	57	25	120
588	123	24	102	120
589	123	24	129	120
590	123	167	193	0
591	123	136	55	0
592	123	167	24	120
593	130	64	171	20
594	130	35	138	20
595	130	6	172	20
596	126	156	137	20
597	126	39	195	20
598	126	81	219	20
599	126	32	138	20
600	127	150	62	80
602	127	107	42	80
603	127	100	83	80
604	127	89	40	80
605	127	-1	151	0
606	127	190	11	80
607	127	175	73	80
608	127	72	16	80
609	127	63	39	80
610	127	-1	105	80
611	127	85	76	80
612	127	-1	56	80
613	127	-1	193	0
614	127	150	90	40
621	108	154	34	80
575	117	188	34	80
615	127	-1	7	80
616	127	-1	222	80
617	127	164	66	80
618	127	119	2	80
619	127	72	200	80
620	127	-1	112	0
622	128	28	232	80
623	128	4	233	40
624	128	48	229	120
625	128	21	228	120
626	128	27	227	120
627	128	35	226	120
1598	270	123	25	120
629	128	52	188	120
630	128	36	231	120
631	128	32	224	80
633	128	-1	213	40
641	128	58	234	120
644	128	49	223	80
645	128	41	236	120
646	125	4	190	120
647	125	2	167	120
648	125	43	178	80
649	125	49	154	120
650	125	40	184	120
651	125	58	238	120
652	131	67	26	120
653	131	8	165	120
654	131	61	122	120
655	131	154	28	80
656	127	136	14	80
657	129	6	239	120
658	129	35	240	120
659	129	-1	213	40
660	129	21	241	120
678	132	135	102	120
662	129	16	191	120
663	129	116	177	120
664	129	-1	242	40
665	129	33	238	120
666	129	6	176	120
667	129	208	177	120
668	135	150	232	80
669	136	23	28	80
670	136	67	160	120
671	136	64	27	120
672	136	28	26	120
673	134	30	243	120
674	134	15	244	120
675	134	36	240	120
676	134	40	245	120
677	134	206	246	80
661	129	116	187	120
679	132	39	77	40
680	132	-1	78	40
681	132	-1	80	40
682	132	-1	69	0
564	114	142	141	20
683	138	5	219	20
684	138	167	220	20
685	138	8	138	20
687	138	100	248	20
688	138	107	247	20
689	139	154	134	20
690	140	44	5	40
691	140	175	74	80
692	140	44	102	120
693	140	85	127	80
694	140	-1	76	80
695	140	27	1	80
696	140	21	65	120
697	140	16	129	120
698	140	107	16	80
699	140	-1	70	80
700	140	153	8	80
701	140	153	175	80
702	140	39	52	80
703	140	160	93	0
704	140	-1	55	0
705	140	28	164	120
706	140	44	117	80
707	140	44	81	80
708	140	64	120	80
709	140	-1	12	80
710	132	100	106	120
711	145	39	122	120
721	140	142	20	80
713	145	175	27	120
712	145	-1	203	80
714	145	136	26	120
715	145	58	170	0
723	143	-1	151	0
717	140	76	62	80
718	140	76	42	80
308	64	76	16	80
719	140	171	60	80
724	143	8	31	80
725	143	50	52	80
726	143	221	66	80
727	143	1	33	80
728	143	90	5	40
729	143	219	81	80
730	143	15	88	80
731	143	97	8	80
732	143	221	76	80
733	143	223	105	80
884	168	35	275	120
735	143	85	204	80
886	168	21	264	120
737	143	136	59	80
738	144	160	248	20
739	144	21	219	20
740	144	107	138	20
741	144	61	247	20
742	144	21	250	20
743	149	2	130	120
744	149	5	48	120
745	149	90	150	80
746	149	-1	78	40
747	149	136	121	80
748	149	39	130	120
749	149	89	20	80
750	149	175	180	80
751	149	-1	114	0
752	149	-1	147	0
753	149	-1	100	0
754	149	-1	153	0
755	149	155	42	80
756	149	61	83	80
757	149	167	62	80
758	155	136	159	120
759	155	98	165	120
760	155	2	122	120
761	155	107	26	120
762	150	21	169	120
763	150	-1	133	40
764	150	35	251	120
765	150	8	157	120
766	150	55	179	120
767	150	60	166	40
768	150	39	212	120
769	150	160	187	120
770	150	1	252	40
771	151	51	184	120
772	151	15	158	120
773	151	-1	133	40
774	151	1	253	120
775	151	19	208	120
776	151	40	254	40
777	151	2	212	120
778	151	19	188	120
779	151	28	255	120
1599	270	114	59	80
781	151	100	256	120
782	151	60	257	40
783	152	24	26	120
784	152	-1	165	120
785	152	148	28	80
786	152	148	165	120
787	153	24	258	120
788	153	100	234	120
789	153	45	259	120
790	153	27	260	120
791	153	57	261	80
792	156	229	98	20
793	156	136	125	20
794	156	21	138	20
795	156	61	262	20
796	156	171	185	20
797	156	61	263	20
798	157	-1	134	20
799	157	154	30	20
800	108	186	44	80
801	159	32	264	120
802	159	48	265	120
803	159	16	266	120
804	159	36	267	120
805	158	221	31	80
806	158	15	99	80
807	158	-1	66	80
808	158	202	108	80
809	158	-1	105	80
810	158	202	7	80
811	158	50	181	80
812	158	89	116	80
813	158	54	9	80
814	158	-1	105	80
815	158	150	39	80
816	158	221	204	80
817	158	160	10	80
818	158	90	117	80
819	158	160	100	0
820	158	54	99	80
821	158	33	75	80
822	158	202	14	80
823	158	175	62	80
824	158	5	21	80
825	158	155	91	80
826	158	202	20	80
827	158	90	63	0
828	158	72	48	120
829	158	8	123	120
830	158	62	24	120
831	158	60	65	120
832	160	41	268	120
833	160	16	176	120
834	160	39	238	120
835	160	29	251	120
836	160	233	190	120
837	160	23	155	40
838	160	171	187	120
839	160	27	269	120
840	160	35	260	120
841	160	155	215	120
734	143	230	74	80
736	143	230	73	80
842	161	167	29	120
843	161	6	51	120
844	161	76	26	120
845	161	-1	28	80
846	163	40	216	120
847	163	31	228	120
848	163	1	234	120
849	163	50	272	120
1607	270	152	12	80
851	164	235	98	20
852	164	235	125	20
853	164	135	138	20
854	164	102	262	20
855	164	54	273	20
856	164	100	263	20
857	166	5	200	80
858	166	154	52	80
859	166	-1	66	80
860	166	132	72	80
861	166	240	70	80
862	166	155	68	0
863	166	56	79	80
864	166	157	81	80
865	166	171	100	0
866	166	157	5	40
867	166	154	9	80
868	166	90	36	80
869	166	148	204	80
870	166	220	17	80
871	166	220	11	80
872	166	221	127	80
873	166	154	112	0
874	166	54	112	0
875	166	157	69	0
876	166	165	120	80
877	166	160	60	80
878	166	100	75	80
879	166	64	62	80
880	166	221	91	80
881	166	100	150	80
882	166	216	20	80
883	168	100	274	120
885	168	-1	267	120
887	167	42	25	120
888	167	81	47	120
889	167	4	129	120
890	167	160	23	120
891	169	-1	28	80
892	169	81	27	120
893	169	171	160	120
894	170	19	184	120
895	170	31	169	120
896	170	15	156	120
897	170	136	251	120
898	170	135	190	120
899	170	-1	155	40
900	170	31	241	120
901	170	-1	187	120
902	170	135	213	40
903	169	55	26	120
904	171	52	236	120
905	171	32	277	120
906	171	50	276	120
907	171	2	276	120
908	176	123	1	80
909	176	225	6	40
910	176	-1	66	80
911	176	90	4	80
912	177	142	278	20
913	172	-1	137	20
914	172	60	172	20
915	172	107	173	20
916	173	221	88	80
917	173	-1	7	80
918	173	230	85	0
919	173	155	222	80
920	173	223	103	80
921	173	213	36	80
975	181	155	138	20
923	173	4	194	80
924	173	34	18	80
925	173	225	74	80
926	173	199	11	80
927	173	251	73	80
928	173	154	83	80
929	173	202	40	80
930	173	123	42	80
931	173	31	87	80
932	173	230	62	80
933	173	54	77	40
934	173	54	150	80
935	173	198	20	80
936	173	4	279	120
937	173	76	48	120
938	173	33	130	120
939	173	142	152	120
940	174	15	227	120
941	174	16	280	120
942	174	27	282	120
943	174	31	264	120
944	174	29	283	120
945	174	-1	284	120
946	172	206	250	20
947	172	54	247	20
948	172	188	273	20
949	172	157	138	20
950	178	116	209	120
951	178	50	238	120
952	178	-1	242	40
953	178	51	208	120
954	178	21	154	120
955	178	52	254	40
956	178	15	269	120
957	178	4	285	120
958	178	16	270	120
959	175	31	159	120
960	175	225	27	120
961	175	54	122	120
962	175	171	26	120
963	179	142	240	120
964	179	160	286	120
965	179	5	232	80
966	179	43	216	120
967	179	157	244	120
968	179	21	287	120
976	181	60	219	20
970	179	55	261	80
971	180	-1	203	80
972	180	-1	165	120
973	180	230	27	120
974	180	160	26	120
922	173	33	194	0
977	181	13	171	20
978	186	55	200	80
979	186	153	2	80
980	186	13	18	80
981	186	253	108	80
982	186	56	288	80
983	182	-1	193	0
984	182	150	49	80
985	182	222	79	80
986	182	-1	93	0
987	182	156	105	80
988	182	240	103	80
989	182	253	116	80
990	182	8	204	80
991	182	235	74	80
992	182	119	11	80
993	182	109	121	80
994	182	213	12	80
995	182	-1	84	0
996	182	72	42	80
997	182	81	180	80
998	182	34	15	80
999	182	-1	147	0
1000	182	-1	112	0
1001	182	167	80	40
1002	182	222	44	80
1003	182	-1	114	0
1004	182	171	129	120
1005	182	154	130	120
1006	182	5	164	120
1007	182	8	25	120
1008	182	188	126	120
1009	183	29	275	120
1010	183	33	289	120
1011	183	39	290	120
1012	183	48	291	120
1013	185	16	285	120
1014	185	213	176	120
1015	185	2	238	120
1016	185	160	177	120
1017	185	-1	268	120
1600	270	-1	101	0
1019	185	52	208	120
1020	185	28	207	120
1021	185	50	212	120
1022	184	213	221	120
1023	184	90	170	0
1024	184	150	26	120
1025	184	135	51	120
1027	188	160	229	120
1026	184	153	29	120
1028	188	5	257	40
1029	188	60	292	120
1030	188	-1	217	40
1031	188	16	293	120
1032	188	234	280	120
1033	188	30	294	120
1034	188	142	275	120
1035	188	15	295	120
1036	188	28	296	120
1037	193	154	92	80
1038	193	157	51	120
1039	193	30	297	120
1040	193	116	26	120
1041	191	98	107	80
1042	191	213	81	80
1043	191	161	116	80
1044	191	61	9	80
1045	191	213	38	80
1046	191	150	16	80
1047	191	270	17	80
1048	191	89	59	80
1049	191	222	10	80
1050	191	270	6	40
1051	191	151	153	0
1052	191	81	15	80
1053	191	135	118	80
1054	191	116	13	80
1055	191	-1	80	40
1056	191	-1	121	80
1057	191	258	44	80
1058	191	-1	100	0
1059	191	13	65	120
1060	191	103	152	120
1061	191	34	24	120
1062	191	155	48	120
1063	190	59	32	80
1064	190	123	90	40
1065	190	239	33	80
1066	190	135	298	80
1067	190	114	1	80
1068	184	15	92	80
1074	194	60	210	120
1070	192	60	301	120
1071	192	35	300	120
1072	192	2	302	120
1073	192	45	303	120
1069	192	60	299	120
1075	194	135	176	120
1076	194	52	178	80
1077	194	39	253	120
1078	194	-1	179	120
1079	194	35	231	120
1080	194	33	212	120
1081	194	255	213	40
1082	194	27	304	120
1083	194	35	236	120
1084	194	148	227	120
1085	194	48	258	120
1086	194	57	214	120
1087	194	39	272	120
1088	195	2	289	120
1089	195	16	305	120
1090	195	232	274	120
1091	195	55	296	120
1092	196	5	250	20
1093	196	19	219	20
1094	196	259	138	20
1095	196	-1	171	20
1096	196	54	306	20
1108	200	274	44	80
1098	198	269	203	80
1099	198	258	160	120
1100	198	212	122	120
1101	198	157	26	120
1097	198	27	307	120
1102	199	270	193	0
1103	199	132	71	80
1104	199	57	90	40
1105	199	118	66	80
1106	199	270	175	80
1107	199	118	70	80
1109	200	-1	85	0
1110	200	266	35	80
1111	200	266	7	80
1112	200	209	56	80
1113	200	-1	76	80
1114	200	269	54	40
1115	200	61	58	80
1116	200	238	74	80
1117	200	165	35	80
1118	200	-1	127	80
1119	200	-1	63	0
1120	200	-1	193	0
1121	200	244	12	80
1122	200	109	18	80
1123	200	206	180	80
1124	200	148	61	80
1125	200	-1	86	0
1126	200	150	308	80
1127	200	188	77	40
1128	200	-1	84	0
1129	107	90	249	20
1130	203	244	286	120
1131	203	8	214	120
1601	270	222	23	120
426	88	157	189	80
1251	222	-1	132	120
1134	203	153	241	120
1135	203	255	285	120
1136	203	36	207	120
1137	203	142	251	120
1138	203	33	253	120
1139	203	-1	238	120
1140	203	-1	184	120
1141	204	157	309	20
1142	206	206	146	80
1144	206	170	105	80
1145	206	151	99	80
1146	206	257	7	80
1147	206	-1	70	80
1148	206	152	53	80
1149	206	72	3	80
1150	206	-1	31	80
1151	206	188	52	80
1152	210	90	221	120
1153	210	119	26	120
1154	210	64	203	80
1155	210	103	50	120
1156	210	119	29	120
1157	207	132	74	80
1158	207	123	16	80
1159	207	270	11	80
1160	207	-1	127	80
1161	207	116	60	80
1162	207	90	12	80
1163	207	-1	86	0
1164	207	153	15	80
1165	207	150	42	80
1166	207	90	118	80
1167	207	44	150	80
1168	207	239	44	80
1169	207	-1	91	80
1170	207	154	22	120
1171	207	55	164	120
1172	207	89	152	120
1173	207	-1	78	40
1174	217	258	28	80
1175	217	-1	165	120
1176	217	55	297	120
1177	217	54	26	120
1178	208	232	234	120
1179	208	33	276	120
1180	208	57	226	120
1181	208	116	265	120
1182	208	171	265	120
1183	208	136	283	120
1184	208	-1	267	120
1185	208	-1	217	40
1186	209	-1	132	120
1187	209	154	238	120
1188	209	97	178	80
1189	209	157	190	120
1190	209	-1	190	120
1191	209	100	167	120
1192	209	154	212	120
1193	209	-1	212	120
1194	209	-1	213	40
1195	209	19	216	120
1196	209	-1	215	120
1197	212	-1	234	120
1198	212	135	293	120
1199	212	150	261	80
1200	212	55	294	120
1201	212	150	294	120
1202	212	148	295	120
1203	212	15	311	120
1133	203	100	189	120
1204	214	111	263	20
1205	213	13	92	80
1206	213	222	160	120
1207	213	142	50	120
1208	213	100	26	120
1209	215	150	68	0
1210	215	285	114	0
1211	215	155	200	80
1212	215	151	52	80
1213	215	282	32	80
1214	215	266	108	80
1215	215	223	34	80
1216	215	283	79	80
1217	215	-1	7	80
1218	215	257	116	80
1219	215	170	103	80
1220	215	-1	105	80
1221	220	251	219	20
1222	220	280	273	20
1223	220	123	138	20
1224	216	103	67	0
1225	216	266	67	0
1226	216	244	69	0
1227	216	123	68	0
1228	216	217	16	80
1229	216	64	74	80
1230	216	285	88	80
1231	216	235	73	80
1232	216	223	83	80
1233	216	222	60	80
1234	216	153	104	80
1235	216	103	14	80
1236	216	171	13	80
1237	216	244	150	80
1238	216	272	44	80
1239	216	272	19	40
1240	216	123	48	120
1241	216	90	102	120
1242	216	155	164	120
1243	216	13	78	40
1244	216	150	163	120
1245	219	15	303	120
1246	219	43	312	120
1247	219	48	313	120
1248	219	30	299	120
1249	219	153	314	120
1250	220	244	247	20
1252	222	152	190	120
1253	222	270	205	120
1254	222	19	236	120
1602	270	285	128	0
1256	222	19	254	40
1257	222	270	241	120
1258	222	52	184	120
1259	222	8	269	120
1260	222	8	227	120
1261	222	-1	242	40
1262	222	50	253	120
1263	223	-1	315	80
1264	223	43	228	120
1265	223	4	305	120
1266	223	233	305	120
1267	223	52	216	120
1268	223	35	214	120
1269	223	2	272	120
1270	223	-1	311	120
1271	226	170	52	80
1272	226	280	200	80
1273	226	-1	70	80
1274	226	223	32	80
1275	226	61	33	80
1276	226	123	88	80
1277	226	90	81	80
1278	226	284	36	80
1279	226	200	57	80
1280	226	152	5	40
1281	227	132	84	0
1282	227	235	85	0
1283	227	155	16	80
1485	254	136	268	120
1285	227	285	127	80
1286	227	277	59	80
1287	227	54	83	80
1288	227	-1	153	0
1289	227	209	75	80
1290	227	244	118	80
1291	227	272	113	80
1292	227	202	55	0
1293	227	200	44	80
1294	227	157	150	80
1295	227	-1	19	40
1296	227	-1	69	0
1306	231	100	320	120
1298	227	266	152	120
1299	227	171	23	120
1300	227	90	279	120
1297	227	150	129	120
1301	228	48	316	120
1302	228	48	303	120
1303	228	41	317	120
1304	228	43	318	120
1305	228	27	319	120
1307	231	157	321	120
1308	230	57	210	120
1309	230	233	176	120
1310	230	244	190	120
1311	230	103	251	120
1312	230	51	254	40
1313	230	96	231	120
1314	230	206	205	120
1608	270	223	106	120
1321	232	103	223	80
1316	230	233	285	120
1317	225	61	92	80
1318	225	257	50	120
1319	225	-1	27	120
1320	225	97	26	120
1322	232	175	216	120
1323	232	55	257	40
1324	232	116	258	120
1325	232	-1	216	120
1326	232	33	234	120
1327	232	5	226	120
1328	232	15	282	120
1329	232	36	275	120
1330	232	27	295	120
1331	232	-1	267	120
1332	233	251	139	20
1333	233	284	140	20
1334	233	55	138	20
1335	235	244	117	80
1336	235	132	73	80
1337	235	-1	74	80
1338	235	302	204	80
1339	235	302	114	0
1340	235	284	69	0
1341	235	302	5	40
1342	235	212	103	80
1343	235	132	146	80
1344	235	13	119	80
1345	235	155	49	80
1346	235	89	131	80
1347	235	230	71	80
1348	235	8	115	0
1349	235	257	108	80
1350	235	235	104	80
1351	236	153	65	120
1352	236	98	123	120
1353	236	202	152	120
1354	236	61	106	120
1355	236	270	21	80
1356	236	266	20	80
1357	236	296	121	80
1358	236	175	82	80
1359	236	199	87	80
1360	236	217	42	80
1361	236	-1	153	0
1362	236	170	83	80
1363	236	266	55	0
1364	236	217	151	0
1603	270	222	13	80
1366	238	5	205	120
1367	238	-1	241	120
1368	238	-1	241	120
1369	238	57	207	120
1370	238	55	168	120
1371	238	171	177	120
1372	238	170	192	120
1373	238	170	238	120
1374	238	8	158	120
1375	239	57	260	120
1376	239	175	236	120
1377	239	28	259	120
1378	239	116	229	120
1379	239	-1	217	40
1380	239	1	276	120
1381	239	160	261	80
1382	239	52	246	80
1383	239	157	305	120
1384	239	-1	295	120
1385	239	-1	311	120
1386	239	-1	294	120
1387	242	-1	114	0
1388	242	243	1	80
1389	242	275	52	80
1390	242	275	105	80
1391	242	275	32	80
1392	242	119	175	80
1393	242	259	100	0
1394	242	123	49	80
1395	242	59	99	80
1396	242	284	56	80
1397	242	164	76	80
1398	242	251	18	80
1399	242	286	74	80
1400	242	311	16	80
1401	242	-1	93	0
1402	242	148	88	80
1403	243	257	40	80
1404	243	188	83	80
1405	243	284	118	80
1406	243	251	82	80
1407	243	-1	42	80
1408	243	-1	21	80
1409	243	274	19	40
1410	243	257	20	80
1411	243	54	106	120
1412	243	153	24	120
1413	243	84	152	120
1414	243	89	25	120
1415	246	103	132	120
1416	246	90	176	120
1417	246	-1	242	40
1418	246	2	253	120
1419	246	153	154	120
1420	246	148	155	40
1421	246	157	285	120
1422	246	-1	189	80
1423	246	13	216	120
1424	246	5	236	120
1425	246	19	228	120
1426	246	-1	256	120
1427	246	-1	276	120
1428	246	-1	261	80
1429	246	-1	187	120
1609	270	109	14	80
1431	248	40	250	20
1432	248	167	98	20
1433	248	160	247	20
1434	248	167	138	20
1435	248	188	262	20
1436	248	259	140	20
1437	235	280	3	80
1438	249	259	26	120
1439	249	283	28	80
1440	249	296	29	120
1441	249	251	27	120
1442	250	301	71	80
1443	250	270	2	80
1444	250	281	174	80
1445	250	284	4	80
1446	250	212	34	80
1447	250	-1	193	0
1483	254	5	210	120
1449	250	63	49	80
1450	250	76	120	80
1451	250	238	146	80
1452	250	217	37	80
1453	250	63	54	40
1486	254	259	177	120
1455	250	76	68	0
1456	250	296	17	80
1457	250	285	204	80
1458	250	283	10	80
1459	250	167	120	80
1460	252	-1	69	0
1461	252	-1	151	0
1462	252	257	55	0
1463	252	283	153	0
1464	252	26	42	80
1465	252	295	180	80
1466	252	235	15	80
1467	252	-1	21	80
1468	252	155	149	80
1469	252	245	44	80
1470	252	44	64	120
1471	252	251	47	120
1472	252	259	23	120
1473	252	155	65	120
1474	252	54	163	120
1448	250	280	151	0
1284	227	-1	74	80
1475	251	136	275	120
1476	251	167	264	120
1477	251	257	283	120
1478	251	51	322	120
1479	251	33	324	120
1480	251	43	326	120
1481	251	57	319	120
1482	251	100	303	120
1484	254	-1	238	120
1487	254	251	208	120
1488	254	-1	155	40
1489	254	251	188	120
1490	254	135	285	120
1491	254	-1	213	40
1492	254	251	216	120
1493	254	142	328	40
1494	254	55	214	120
1495	254	21	277	120
1496	254	154	276	120
1497	254	-1	261	80
1498	254	-1	233	40
1604	270	56	60	80
1500	252	212	83	80
1501	258	257	67	0
1502	258	317	31	80
1503	258	267	52	80
1504	258	317	66	80
1505	258	230	72	80
1506	258	267	34	80
1507	258	75	81	80
1508	258	59	181	80
1509	258	301	146	80
1510	258	106	57	80
1511	258	212	105	80
1512	258	217	68	0
1513	258	238	74	80
1514	258	317	204	80
1515	258	301	73	80
1516	258	84	59	80
1517	259	51	329	120
1518	259	28	294	120
1519	259	230	315	80
1520	259	45	291	120
1521	259	28	299	120
1522	259	233	330	120
1523	259	52	326	120
1524	259	32	312	120
1525	259	21	303	120
1526	257	-1	28	80
1527	257	-1	122	120
1528	257	-1	51	120
1529	257	-1	26	120
1530	260	280	68	0
1531	260	308	40	80
1532	260	-1	12	80
1533	260	212	113	80
1534	260	-1	86	0
1535	260	-1	42	80
1536	260	89	14	80
1537	260	-1	80	40
1538	260	-1	121	80
1539	260	277	20	80
1540	260	148	22	120
1541	260	123	164	120
1542	260	234	102	120
1543	260	123	65	120
1544	260	223	126	120
1545	261	148	158	120
1546	261	222	177	120
1547	261	-1	158	120
1548	261	-1	178	80
1549	261	-1	177	120
1550	261	175	254	40
1551	261	148	211	80
1552	261	284	285	120
1553	261	57	206	120
1554	261	-1	255	120
1555	261	148	304	120
1556	261	30	215	120
1557	261	51	246	80
1558	261	-1	234	120
1559	261	34	277	120
1560	261	30	292	120
1561	261	100	280	120
1562	261	40	329	120
1563	261	153	264	120
1564	261	-1	315	80
1565	261	-1	296	120
1610	270	-1	19	40
1567	166	132	180	80
1568	263	231	250	20
1569	263	286	220	20
1570	263	280	141	20
1571	263	111	247	20
1572	263	326	138	20
1573	263	326	262	20
1574	263	55	171	20
1575	263	259	249	20
1576	265	-1	71	80
1577	265	235	72	80
1578	265	320	111	80
1579	265	13	131	80
1580	265	327	16	80
1581	265	155	37	80
1582	265	299	17	80
1583	265	164	104	80
1584	265	277	7	80
1585	265	188	174	80
1586	265	44	36	80
1587	265	297	6	40
1588	268	233	321	120
1589	268	60	331	120
1806	297	203	161	20
1809	299	26	200	80
1592	266	55	299	120
1593	266	57	299	120
1594	266	51	334	120
1595	266	32	335	120
1596	266	1	303	120
425	88	157	186	0
528	116	41	186	0
542	113	49	186	0
628	128	1	186	0
780	151	135	186	0
850	160	50	186	0
1018	185	81	186	0
1132	203	190	186	0
1255	222	-1	186	0
1315	230	13	186	0
1365	238	-1	186	0
1430	246	-1	186	0
1499	254	-1	186	0
1566	261	-1	186	0
1611	268	40	336	0
1612	271	135	176	120
1613	271	135	305	120
1614	271	-1	238	120
1615	271	100	239	120
1616	271	45	229	120
1617	271	259	187	120
1618	271	-1	261	80
1619	271	142	223	80
1620	271	60	186	0
1621	271	232	167	120
1622	271	39	270	120
1623	271	118	244	120
1624	271	118	178	80
1625	271	97	154	120
1626	271	32	241	120
1627	271	97	287	120
1628	271	-1	208	120
1629	271	206	216	120
1630	271	103	275	120
1744	291	51	342	20
1632	271	150	296	120
1804	297	339	247	20
1634	273	333	338	80
1635	278	-1	339	200
1636	277	36	300	120
1637	277	142	300	120
1638	277	4	313	120
1639	277	43	335	120
1640	277	27	303	120
1641	275	44	51	120
1642	276	285	31	80
1643	276	202	116	80
1644	276	76	222	80
1673	280	259	209	120
1646	276	264	52	80
1647	276	279	57	80
1648	275	109	50	120
1649	275	153	26	120
1650	276	264	32	80
1651	275	188	92	80
1652	276	275	181	80
1653	276	135	33	80
1654	276	-1	67	0
1645	276	-1	70	80
1655	279	-1	17	80
1656	279	-1	16	80
1657	279	293	73	80
1658	279	299	11	80
1659	279	322	12	80
1660	279	-1	153	0
1661	279	-1	86	0
1662	279	285	61	80
1663	279	257	14	80
1664	279	213	113	80
1665	279	-1	193	0
1666	279	89	21	80
1667	279	335	44	80
1668	279	240	77	40
1669	279	59	22	120
1670	279	42	123	120
1671	279	56	23	120
1672	279	269	78	40
1674	280	257	132	120
1675	280	-1	269	120
1676	280	257	268	120
1677	280	132	208	120
1678	280	123	179	120
1679	280	-1	177	120
1680	280	136	183	80
1681	280	148	166	40
1682	280	116	186	0
1683	280	231	241	120
1684	280	150	255	120
1685	280	150	215	120
1686	280	-1	234	120
1687	280	132	216	120
1688	280	-1	217	40
1689	280	153	287	120
1690	280	33	272	120
1691	283	156	28	80
1692	283	90	26	120
1693	283	123	297	120
1694	283	132	27	120
1695	284	284	5	40
1696	284	217	111	80
1697	284	-1	31	80
1698	284	-1	115	0
1699	284	118	127	80
1700	284	285	76	80
1701	284	332	16	80
1702	284	217	3	80
1703	284	-1	193	0
1704	284	-1	193	0
1705	284	220	2	80
1706	284	335	79	80
1707	284	234	56	80
1708	284	234	117	80
1709	284	-1	81	80
1710	284	44	53	80
1711	284	143	39	80
1712	282	328	250	20
1713	282	319	139	20
1714	282	235	138	20
1715	282	8	340	20
1716	282	259	249	20
1717	288	-1	85	0
1718	288	270	15	80
1719	288	89	149	80
1720	288	284	150	80
1721	288	148	78	40
1722	288	299	87	80
1723	288	106	13	80
1724	288	-1	55	0
1725	288	59	130	120
1726	288	217	48	120
1727	288	270	24	120
1728	288	284	63	0
1729	288	187	12	80
1730	288	346	20	80
1731	285	132	329	120
1732	285	-1	275	120
1733	285	-1	311	120
1734	285	-1	295	120
1735	285	51	318	120
1736	285	40	318	120
1737	285	39	302	120
1738	285	52	312	120
1739	285	116	303	120
1631	271	118	295	120
1807	297	326	140	20
1810	299	236	52	80
1745	291	220	343	20
1743	290	-1	339	200
1746	291	142	344	20
1747	291	5	198	20
1748	292	-1	203	80
1749	292	56	26	120
1750	292	-1	29	120
1751	292	316	27	120
1752	293	293	71	80
1753	293	202	59	80
1754	293	297	127	80
1755	293	215	16	80
1756	293	215	49	80
1757	293	348	2	80
1758	293	340	17	80
1759	293	56	57	80
1760	293	-1	56	80
1761	293	223	174	80
1762	293	213	53	80
1763	293	-1	105	80
1764	293	-1	105	80
1765	293	164	107	80
1766	293	215	68	0
1767	294	160	303	120
1768	294	28	301	120
1769	294	19	326	120
1770	294	32	314	120
1771	294	2	324	120
1772	294	23	311	120
1773	294	232	290	120
1774	294	89	275	120
1775	294	5	294	120
1776	294	-1	216	120
1777	294	1	272	120
1778	294	33	310	120
1779	294	60	260	120
1780	294	90	286	120
1781	294	282	304	120
1782	294	50	252	40
1783	294	232	212	120
1784	294	155	206	120
1785	294	5	207	120
1786	294	282	157	120
1787	294	206	208	120
1788	294	33	192	120
1789	294	89	132	120
1790	294	132	184	120
1791	295	-1	40	80
1792	295	114	35	80
1793	295	-1	86	0
1794	295	56	13	80
1795	295	340	87	80
1796	295	148	62	80
1797	295	328	91	80
1798	295	235	80	40
1799	295	84	20	80
1800	295	338	152	120
1801	295	7	123	120
1802	295	31	25	120
1803	295	56	129	120
1633	273	160	337	40
1741	290	157	337	40
1591	268	136	333	40
1590	268	2	332	40
1742	290	23	341	40
1805	297	284	138	20
1808	299	120	115	0
1811	299	156	34	80
1812	299	114	108	80
1813	299	328	3	80
1814	299	114	7	80
1815	299	207	79	80
1816	299	235	18	80
1817	299	26	37	80
1818	299	75	36	80
1819	299	212	112	0
1820	299	347	17	80
1821	299	235	82	80
1822	299	355	73	80
1823	299	357	59	80
1824	300	153	169	120
1825	300	109	132	120
1826	300	-1	242	40
1827	300	13	208	120
1828	300	155	168	120
1829	300	39	167	120
1830	300	8	186	0
1831	300	319	205	120
1832	300	-1	212	120
1833	300	42	269	120
1834	300	103	214	120
1835	300	157	239	120
1836	300	76	214	120
1837	300	4	258	120
1838	300	42	227	120
1839	300	232	272	120
1840	300	319	329	120
1841	300	109	275	120
1842	300	157	295	120
1843	300	-1	296	120
1844	301	240	83	80
1845	301	-1	153	0
1846	301	297	61	80
1847	301	234	118	80
1848	301	-1	222	80
1849	301	136	21	80
1850	301	285	149	80
1851	302	-1	339	120
1904	308	270	147	0
1905	308	339	83	80
1906	308	245	60	80
1852	303	43	349	40
1853	303	348	350	80
1855	309	223	338	80
1856	309	15	352	80
1857	304	287	353	0
1858	305	60	307	120
1859	305	118	203	80
1860	305	280	297	120
1861	305	89	50	120
1862	305	284	26	120
1863	306	217	200	80
1864	306	269	107	80
1865	306	220	175	80
1866	306	-1	66	80
1867	306	-1	70	80
1868	306	66	35	80
1869	306	-1	49	80
1870	306	143	67	0
1871	306	297	56	80
1872	306	59	9	80
1873	306	76	111	80
1874	306	66	39	80
1875	306	76	82	80
1876	306	66	73	80
1877	306	326	117	80
1878	307	118	158	120
1879	307	13	184	120
1880	307	45	133	40
1881	307	297	157	120
1882	307	167	154	120
1883	307	103	207	120
1884	307	13	188	120
1885	307	297	269	120
1886	307	259	255	120
1887	307	15	186	0
1888	307	28	292	120
1889	307	142	236	120
1890	307	36	223	80
1891	307	232	276	120
1892	307	-1	217	40
1893	307	157	293	120
1894	307	15	272	120
1895	307	297	282	120
1896	307	52	329	120
1897	307	233	266	120
1898	307	60	322	120
1899	307	52	318	120
1900	307	116	316	120
1901	307	100	354	120
1902	307	21	335	120
1903	307	4	303	120
1907	308	337	13	80
1908	308	223	113	80
1909	308	66	80	40
1910	308	-1	77	40
1911	308	-1	44	80
1912	308	235	180	80
1913	310	-1	352	80
1914	310	30	355	120
1915	310	15	356	120
1916	310	100	357	120
1917	310	15	358	120
1918	310	50	359	120
1919	311	189	109	20
1920	311	189	98	20
1921	311	236	137	20
1922	311	51	162	20
1923	311	357	138	20
1924	311	30	161	20
1925	311	123	360	20
1926	314	232	238	120
1927	314	270	154	120
1928	314	7	157	120
1929	314	142	207	120
1930	314	44	285	120
1931	314	167	241	120
1932	314	157	213	40
1933	314	55	186	0
1934	314	-1	216	120
1935	314	-1	328	40
1936	314	257	223	80
1937	314	39	234	120
1938	314	60	258	120
1939	314	39	276	120
1940	314	7	361	120
1941	314	45	265	120
1942	314	270	264	120
1943	314	44	295	120
1944	314	177	296	120
1945	313	359	5	40
1946	313	337	57	80
1947	313	319	146	80
1948	313	286	73	80
1949	313	152	117	80
1950	313	207	93	0
1951	313	323	193	0
1952	313	245	79	80
1953	313	143	7	80
1954	313	293	82	80
1955	313	359	53	80
1956	313	327	3	80
1957	313	76	119	80
1958	313	203	200	80
1959	313	245	93	0
1960	313	203	68	0
1961	314	373	156	120
1962	315	26	68	0
1963	315	-1	16	80
1964	315	323	17	80
1965	315	314	83	80
1966	315	357	40	80
1967	315	-1	42	80
1968	315	349	14	80
1969	315	245	113	80
1970	316	-1	362	120
1971	316	28	331	120
1972	317	152	357	120
1973	317	33	363	120
1974	317	32	364	120
1975	318	236	134	20
1976	318	270	365	20
1977	319	59	26	120
1978	319	369	28	80
1979	319	277	50	120
1980	319	340	29	120
1981	320	269	68	0
1982	320	150	200	80
1983	320	220	120	80
1984	320	231	82	80
1985	320	311	3	80
1986	320	357	108	80
1987	320	277	55	0
1988	320	357	7	80
1989	320	340	6	40
1990	320	-1	85	0
1991	320	326	36	80
1992	320	339	9	80
1993	320	326	5	40
1994	320	385	16	80
1995	320	231	17	80
1996	320	370	127	80
1997	320	359	117	80
1998	321	167	242	40
1854	303	50	351	40
\.


--
-- Data for Name: raid_kills; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY raid_kills (id, raid_id, boss_id, value) FROM stdin;
\.


--
-- Data for Name: raids; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY raids (id, dungeon_id, raid_date, note, value, start_tstamp, stop_tstamp) FROM stdin;
7	4	2006-03-16	\N	0	2006-03-17 00:32:20	2006-03-17 00:32:24
9	5	2006-03-18	\N	0	2006-03-18 11:07:50	2006-03-18 15:20:39
14	4	2006-03-22	\N	0	2006-03-22 21:00:00	2006-03-22 23:59:00
8	5	2006-03-07	\N	0	2006-03-07 21:00:00	2006-03-07 23:39:00
15	1	2006-03-08	\N	0	2006-03-08 21:00:00	2006-03-08 23:30:00
16	5	2006-03-11	\N	0	2006-03-11 11:00:00	2006-03-11 15:00:00
273	6	2006-10-19	\N	3	2006-10-19 21:00:00	2006-10-19 23:30:00
288	1	2006-10-30	\N	24	2006-10-30 21:00:00	2006-10-30 23:40:00
314	3	2006-11-26	\N	52	2006-11-26 19:30:00	2006-11-27 00:30:00
5	3	2006-03-14	\N	4	2006-03-14 21:00:00	2006-03-14 23:57:01
6	4	2006-03-15	\N	1	2006-03-15 21:04:12	2006-03-16 00:50:23
297	5	2006-11-11	\N	4	2006-11-11 11:30:00	2006-11-11 15:10:00
13	3	2006-03-21	\N	4	2006-03-21 21:00:00	2006-03-22 01:00:00
17	4	2006-03-23	\N	0	2006-03-23 21:00:00	2006-03-23 23:15:00
23	5	2006-04-01	\N	0	2006-04-01 11:00:00	2006-04-01 15:00:00
18	5	2006-03-25	\N	0	2006-03-25 10:58:05	2006-03-25 16:22:08
279	1	2006-10-23	\N	31	2006-10-23 21:00:00	2006-10-24 00:30:00
276	1	2006-10-21	\N	18	2006-10-21 21:00:00	2006-10-22 00:25:00
22	1	2006-03-29	\N	10	2006-03-29 21:45:00	2006-03-29 23:40:00
282	5	2006-10-28	\N	5	2006-10-28 11:00:00	2006-10-28 16:00:00
24	1	2006-04-01	\N	8	2006-04-01 19:00:00	2006-04-01 20:30:00
294	3	2006-11-05	\N	70	2006-11-05 19:30:00	2006-11-06 00:15:00
285	3	2006-10-29	\N	27	2006-10-29 19:30:00	2006-10-29 20:45:00
33	4	2006-04-06	\N	1	2006-04-06 23:58:16	2006-04-07 01:00:00
26	2	2006-04-03	\N	0	2006-04-03 23:30:00	2006-04-04 01:00:00
79	5	2006-05-20	\N	3	2006-05-20 10:00:00	2006-05-20 12:45:53
29	4	2006-04-05	\N	0	2006-04-05 21:30:00	2006-04-06 00:00:00
28	2	2006-04-04	\N	0	2006-04-04 21:00:00	2006-04-04 22:10:42
37	2	2006-04-12	\N	0	2006-04-12 21:30:00	2006-04-13 00:00:00
291	4	2006-11-04	\N	4	2006-11-04 11:00:00	2006-11-04 15:20:00
59	2	2006-05-03	\N	12	2006-05-03 21:00:00	2006-05-03 21:30:00
300	3	2006-11-12	\N	55	2006-11-12 19:30:00	2006-11-13 00:30:00
30	4	2006-04-06	\N	0	2006-04-06 21:11:58	2006-04-06 23:37:11
21	3	2006-04-03	\N	4	2006-04-03 21:00:00	2006-04-03 23:00:00
41	1	2006-04-17	\N	12	2006-04-17 21:55:40	2006-04-18 00:15:28
34	1	2006-04-16	\N	33	2006-04-16 20:00:00	2006-04-17 00:15:00
36	1	2006-04-11	\N	9	2006-04-11 21:00:00	2006-04-11 22:30:00
31	5	2006-04-08	\N	1	2006-04-08 11:00:00	2006-04-08 15:00:00
38	5	2006-04-15	\N	1	2006-04-15 11:00:00	2006-04-15 15:30:00
32	1	2006-04-08	\N	10	2006-04-08 19:00:00	2006-04-08 20:45:00
35	3	2006-04-10	\N	4	2006-04-10 21:15:00	2006-04-10 23:00:00
44	4	2006-04-19	\N	0	2006-04-19 21:00:00	2006-04-20 00:18:43
43	4	2006-04-19	\N	0	2006-04-19 00:00:00	2006-04-19 01:00:00
46	5	2006-04-22	\N	2	2006-04-22 11:00:00	2006-04-22 15:00:00
45	4	2006-04-20	\N	0	\N	\N
311	5	2006-11-25	\N	7	2006-11-25 11:00:00	2006-11-25 16:00:00
70	4	2006-05-11	\N	1	2006-05-11 18:56:48	2006-05-11 22:10:40
42	5	2006-04-18	\N	0	2006-04-18 21:00:00	2006-04-18 23:45:00
75	3	2006-05-15	\N	17	2006-05-15 20:00:00	2006-05-15 23:30:00
67	3	2006-05-09	\N	17	2006-05-09 21:00:00	2006-05-09 23:45:00
57	3	2006-05-01	\N	4	2006-05-01 21:00:00	2006-05-02 00:40:00
52	4	2006-04-26	\N	2	2006-04-26 21:00:00	2006-04-27 00:30:00
60	3	2006-05-03	\N	4	2006-05-03 21:30:00	2006-05-04 00:12:00
53	4	2006-04-27	\N	0	2006-04-27 22:57:56	2006-04-28 00:20:00
72	5	2006-05-12	\N	0	2006-05-12 20:30:00	2006-05-12 23:45:00
49	2	2006-04-24	\N	11	2006-04-24 21:30:00	2006-04-24 22:15:00
312	2	2006-11-25	\N	0	2006-11-25 19:30:00	2006-11-25 20:15:00
54	5	2006-04-28	\N	2	2006-04-28 21:46:00	2006-04-29 00:52:00
47	1	2006-04-30	\N	44	2006-04-30 19:30:00	2006-05-01 00:40:00
76	2	2006-05-17	\N	0	2006-05-17 21:00:00	2006-05-18 00:00:00
55	5	2006-04-29	\N	4	2006-04-29 11:00:00	2006-04-29 14:40:00
317	6	2006-11-30	\N	9	2006-11-30 21:30:00	2006-12-01 00:00:00
61	5	2006-05-05	\N	0	2006-05-05 21:00:00	2006-05-05 23:30:00
65	3	2006-05-08	\N	4	2006-05-08 21:00:00	2006-05-09 00:05:00
319	2	2006-12-02	\N	11	2006-12-02 20:00:00	2006-12-02 20:50:00
71	5	2006-05-13	\N	4	2006-05-13 11:00:00	2006-05-13 17:15:00
95	4	2006-05-31	\N	0	2006-05-31 19:30:00	2006-05-31 22:40:00
68	2	2006-05-10	\N	11	2006-05-10 19:31:29	2006-05-10 21:20:00
320	1	2006-12-02	\N	26	2006-12-02 21:15:00	2006-12-03 00:55:00
62	5	2006-05-06	\N	4	2006-05-06 11:00:00	2006-05-06 14:50:00
77	4	2006-05-18	\N	1	2006-05-18 19:00:00	2006-05-18 23:20:32
85	5	2006-05-26	\N	0	2006-05-26 21:00:00	2006-05-27 00:00:00
73	1	2006-05-13	\N	9	2006-05-13 19:03:06	2006-05-13 20:00:00
78	4	2006-05-20	\N	1	2006-05-20 14:01:20	2006-05-20 16:31:11
89	5	2006-05-28	\N	3	2006-05-28 00:00:00	2006-05-28 01:15:00
84	3	2006-05-22	\N	2	2006-05-22 20:45:12	2006-05-22 22:22:03
80	1	2006-05-21	\N	40	2006-05-21 19:30:00	2006-05-21 23:34:04
83	3	2006-05-23	\N	14	2006-05-23 20:00:00	2006-05-23 23:14:02
96	5	2006-06-02	\N	0	\N	\N
120	5	2006-06-21	\N	0	2006-06-21 20:20:38	2006-06-22 01:09:53
90	3	2006-05-30	\N	18	2006-05-30 21:00:00	2006-05-31 01:00:00
303	7	2006-11-16	\N	6	2006-11-16 21:00:00	2006-11-16 22:30:00
86	5	2006-05-27	\N	0	2006-05-27 20:30:00	2006-05-27 23:30:00
93	5	2006-06-03	\N	5	2006-06-03 11:00:00	2006-06-03 16:15:00
91	1	2006-05-27	\N	9	2006-05-30 20:37:32	2006-05-30 20:37:33
100	1	2006-05-28	\N	39	2006-05-28 00:00:00	2006-05-28 04:00:00
99	2	2006-06-01	\N	0	2006-06-01 21:00:00	2006-06-01 22:45:00
101	2	2006-06-02	\N	0	2006-06-02 21:00:00	2006-06-03 00:00:00
105	4	2006-06-08	\N	3	2006-06-08 19:30:53	2006-06-08 22:30:56
97	1	2006-06-03	\N	10	2006-06-03 19:00:00	2006-06-03 20:00:00
309	6	2006-11-16	\N	4	2006-11-16 22:30:00	2006-11-17 00:15:00
103	3	2006-06-05	\N	0	2006-06-05 21:00:00	2006-06-05 23:20:00
104	3	2006-06-07	\N	0	2006-06-07 20:44:00	2006-06-07 20:45:00
106	5	2006-06-09	\N	0	2006-06-10 16:33:49	2006-06-10 16:37:37
117	1	2006-06-17	\N	35	2006-06-17 18:50:31	2006-06-17 23:12:26
115	4	2006-06-15	\N	0	\N	\N
109	3	2006-06-11	\N	0	2006-06-11 19:30:00	2006-06-11 22:10:00
306	1	2006-11-18	\N	28	2006-11-18 21:30:00	2006-11-19 00:10:00
119	3	2006-06-19	\N	0	2006-06-19 23:29:28	2006-06-20 01:19:29
125	3	2006-06-20	\N	17	2006-06-20 20:45:27	2006-06-21 00:20:06
111	5	2006-06-17	\N	4	2006-06-17 11:00:00	2006-06-17 16:00:00
118	3	2006-06-18	\N	10	2006-06-18 18:30:00	2006-06-18 23:30:00
124	5	2006-06-15	\N	0	2006-06-15 00:25:42	2006-06-15 02:22:08
114	5	2006-06-14	\N	4	2006-06-14 20:35:39	2006-06-15 00:25:28
130	5	2006-06-23	\N	3	2006-06-23 20:30:02	2006-06-24 01:18:49
123	1	2006-06-19	\N	12	2006-06-19 21:25:35	2006-06-19 23:29:28
126	5	2006-06-24	\N	4	2006-06-24 11:00:00	2006-06-24 16:00:00
122	2	2006-06-19	\N	15	2006-06-19 20:30:00	2006-06-19 21:15:00
142	3	2006-07-04	\N	0	2006-07-04 20:36:44	2006-07-04 23:20:48
131	2	2006-06-26	\N	11	2006-06-26 21:00:00	2006-06-26 21:30:00
127	1	2006-06-24	\N	37	2006-06-24 19:00:00	2006-06-24 23:20:00
139	4	2006-07-01	\N	1	2006-07-01 19:13:39	2006-07-01 22:30:30
133	5	2006-06-28	\N	0	2006-06-28 21:30:00	2006-06-28 22:30:00
140	1	2006-07-02	\N	49	2006-07-02 19:23:33	2006-07-03 00:21:57
137	4	2006-06-30	\N	0	2006-06-30 20:26:31	2006-07-01 00:19:58
129	3	2006-06-27	\N	29	2006-06-27 21:18:23	2006-06-28 00:57:23
147	4	2006-07-08	\N	0	\N	\N
136	2	2006-06-29	\N	11	2006-06-29 21:00:00	2006-06-29 22:00:00
134	3	2006-06-29	\N	14	2006-06-29 22:30:00	2006-06-30 00:30:00
135	3	2006-06-26	\N	2	2006-06-26 23:03:31	2006-06-27 00:30:13
298	2	2006-11-11	\N	0	2006-11-11 20:00:00	2006-11-11 20:45:00
148	2	2006-07-09	\N	0	2006-07-09 19:45:00	2006-07-09 20:30:00
138	5	2006-07-01	\N	5	2006-07-01 10:31:04	2006-07-01 15:57:07
160	3	2006-07-18	\N	28	2006-07-18 21:00:00	2006-07-19 00:48:00
152	2	2006-07-13	\N	11	2006-07-13 20:38:05	2006-07-13 21:46:51
159	3	2006-07-17	\N	12	2006-07-17 21:00:00	2006-07-18 00:00:00
156	5	2006-07-15	\N	6	2006-07-15 11:00:00	2006-07-15 15:20:00
155	2	2006-07-10	\N	12	2006-07-10 21:00:00	2006-07-10 21:25:00
145	2	2006-07-03	\N	11	2006-07-03 21:30:00	2006-07-03 22:00:00
132	1	2006-06-26	\N	9	2006-06-26 21:37:22	2006-06-27 00:03:35
144	5	2006-07-08	\N	5	2006-07-08 11:00:00	2006-07-08 16:30:00
143	1	2006-07-06	\N	27	2006-07-06 21:30:00	2006-07-07 00:30:00
149	1	2006-07-09	\N	24	2006-07-09 21:00:00	2006-07-10 00:30:00
150	3	2006-07-10	\N	21	2006-07-10 21:45:00	2006-07-11 00:30:00
153	3	2006-07-13	\N	14	2006-07-13 21:48:55	2006-07-14 00:54:31
157	4	2006-07-15	\N	1	2006-07-15 19:13:17	2006-07-15 23:21:13
108	1	2006-06-10	\N	38	2006-06-10 19:00:00	2006-06-10 22:45:00
158	1	2006-07-16	\N	54	2006-07-16 19:30:00	2006-07-17 02:30:00
164	5	2006-07-22	\N	6	2006-07-22 10:45:00	2006-07-22 15:00:00
171	3	2006-07-27	\N	12	2006-07-27 20:45:00	2006-07-28 00:35:00
170	3	2006-07-25	\N	23	2006-07-25 21:20:00	2006-07-26 00:35:00
161	2	2006-07-20	\N	11	2006-07-20 21:00:00	2006-07-20 21:30:00
163	3	2006-07-20	\N	12	2006-07-20 21:45:00	2006-07-21 01:00:00
169	2	2006-07-25	\N	11	2006-07-25 20:30:00	2006-07-25 21:05:00
261	3	2006-10-10	\N	57	2006-10-10 21:00:00	2006-10-11 00:25:00
167	1	2006-07-24	\N	12	2006-07-24 21:00:00	2006-07-24 22:30:00
168	3	2006-07-24	\N	12	2006-07-24 23:00:00	2006-07-25 00:45:00
177	4	2006-07-29	\N	1	2006-07-29 22:00:00	2006-07-30 02:45:00
187	4	2006-08-05	\N	0	\N	\N
174	3	2006-07-31	\N	18	2006-07-31 21:00:00	2006-08-01 00:15:00
176	1	2006-07-29	\N	7	2006-07-29 19:30:00	2006-07-29 20:30:00
180	2	2006-08-03	\N	11	2006-08-03 21:05:00	2006-08-03 21:35:00
181	5	2006-08-05	\N	3	2006-08-05 11:00:00	2006-08-05 15:45:00
182	1	2006-08-06	\N	44	2006-08-06 19:30:00	2006-08-07 00:15:00
189	5	2006-08-12	\N	0	2006-08-12 11:00:00	2006-08-12 16:25:00
280	3	2006-10-24	\N	46	2006-10-24 21:00:00	2006-10-25 00:45:00
179	3	2006-08-03	\N	19	2006-08-03 22:00:00	2006-08-04 00:45:00
175	2	2006-08-01	\N	12	2006-08-01 20:40:00	2006-08-01 21:40:00
197	6	2006-08-14	\N	0	2006-08-14 23:30:00	2006-08-15 00:30:00
178	3	2006-08-01	\N	23	2006-08-01 22:00:00	2006-08-02 00:45:00
188	3	2006-08-10	\N	26	2006-08-10 21:00:00	2006-08-11 00:45:00
191	1	2006-08-13	\N	42	2006-08-13 19:30:00	2006-08-14 00:40:00
172	5	2006-07-29	\N	7	2006-07-29 11:00:00	2006-07-29 17:00:00
186	1	2006-08-05	\N	10	2006-08-05 19:30:00	2006-08-05 20:45:00
283	2	2006-10-28	\N	11	2006-10-28 19:30:00	2006-10-28 20:15:00
183	3	2006-08-07	\N	12	2006-08-07 21:00:00	2006-08-08 00:25:00
205	2	2006-08-26	\N	0	2006-08-26 19:30:00	2006-08-26 20:25:00
200	1	2006-08-20	\N	30	2006-08-20 19:30:00	2006-08-21 01:10:00
107	5	2006-06-10	\N	5	2006-06-10 10:00:00	2006-06-10 13:20:50
196	5	2006-08-19	\N	5	2006-08-19 11:00:00	2006-08-19 16:00:00
193	2	2006-08-12	\N	11	2006-08-12 19:30:00	2006-08-12 21:00:00
201	3	2006-08-21	\N	0	2006-08-21 21:00:00	2006-08-22 00:00:00
194	3	2006-08-15	\N	39	2006-08-15 21:00:00	2006-08-16 00:50:00
195	3	2006-08-17	\N	12	2006-08-17 21:00:00	2006-08-18 00:00:00
184	2	2006-08-08	\N	14	2006-08-08 07:40:00	2006-08-08 08:20:15
207	1	2006-08-27	\N	34	2006-08-27 19:30:00	2006-08-27 23:55:00
190	1	2006-08-12	\N	9	2006-08-12 18:15:00	2006-08-12 19:40:00
198	2	2006-08-19	\N	14	2006-08-19 19:30:00	2006-08-19 20:00:00
192	3	2006-08-14	\N	15	2006-08-14 21:00:00	2006-08-14 23:00:00
199	1	2006-08-19	\N	9	2006-08-19 20:45:00	2006-08-19 21:55:00
206	1	2006-08-26	\N	20	2006-08-26 21:00:00	2006-08-26 23:30:00
202	3	2006-08-22	\N	0	2006-08-22 21:00:00	2006-08-22 23:20:00
277	3	2006-10-22	\N	15	2006-10-22 19:30:00	2006-10-22 20:30:00
214	5	2006-09-02	\N	1	2006-09-02 11:00:00	2006-09-02 14:30:00
204	4	2006-08-26	\N	1	2006-08-26 11:00:00	2006-08-26 14:15:00
213	2	2006-09-02	\N	11	2006-09-02 19:30:00	2006-09-02 20:00:00
240	4	2006-09-23	\N	0	2006-09-23 11:00:00	2006-09-23 15:55:00
221	6	2006-09-04	\N	0	2006-09-05 00:45:00	2006-09-05 01:25:00
210	2	2006-08-26	\N	14	2006-08-26 23:50:00	2006-08-27 00:35:00
234	2	2006-09-16	\N	0	2006-09-16 19:30:00	2006-09-16 20:15:00
232	3	2006-09-14	\N	30	2006-09-14 21:00:00	2006-09-15 00:40:00
217	2	2006-08-27	\N	11	2006-08-28 00:30:00	2006-08-28 01:00:00
209	3	2006-08-29	\N	30	2006-08-29 21:00:00	2006-08-30 00:20:00
208	3	2006-08-28	\N	22	2006-08-28 21:00:00	2006-08-29 00:20:00
212	3	2006-08-31	\N	20	2006-08-31 21:00:00	2006-09-01 00:20:00
215	1	2006-09-02	\N	20	2006-09-02 20:30:00	2006-09-02 22:45:00
227	1	2006-09-10	\N	33	2006-09-10 19:30:00	2006-09-10 23:20:00
231	6	2006-09-11	\N	6	2006-09-11 22:30:00	2006-09-12 00:15:00
216	1	2006-09-03	\N	36	2006-09-03 19:30:00	2006-09-03 23:35:00
218	6	2006-09-04	\N	0	2006-09-04 13:30:00	2006-09-04 16:00:00
220	5	2006-09-03	\N	4	2006-09-04 00:15:00	2006-09-04 02:15:00
219	3	2006-09-04	\N	15	2006-09-04 21:00:00	2006-09-04 22:45:00
274	4	2006-10-21	\N	0	2006-10-21 11:00:00	2006-10-21 14:35:00
233	5	2006-09-16	\N	3	2006-09-16 11:00:00	2006-09-16 15:30:00
223	3	2006-09-07	\N	23	2006-09-07 21:00:00	2006-09-08 00:30:00
237	3	2006-09-18	\N	0	2006-09-18 21:00:00	2006-09-19 00:15:00
226	1	2006-09-09	\N	19	2006-09-09 20:30:00	2006-09-09 23:15:00
228	3	2006-09-11	\N	15	2006-09-11 21:00:00	2006-09-11 22:00:00
229	4	2006-09-09	\N	0	2006-09-09 11:30:00	2006-09-09 16:30:00
236	1	2006-09-17	\N	26	2006-09-17 19:30:00	2006-09-17 22:00:00
239	3	2006-09-21	\N	32	2006-09-21 21:00:00	2006-09-22 00:30:00
286	6	2006-10-29	\N	0	2006-10-29 21:00:00	2006-10-29 22:40:00
241	2	2006-09-23	\N	0	2006-09-23 19:30:00	2006-09-23 20:15:00
225	2	2006-09-09	\N	11	2006-09-09 19:45:00	2006-09-09 20:15:00
247	6	2006-09-28	\N	0	2006-09-28 21:00:00	2006-09-28 22:50:00
248	5	2006-09-30	\N	6	2006-09-30 11:00:00	2006-09-30 14:40:00
243	1	2006-09-24	\N	27	2006-09-24 19:30:00	2006-09-24 23:15:00
292	2	2006-11-04	\N	11	2006-11-04 19:45:00	2006-11-04 20:15:00
242	1	2006-09-23	\N	26	2006-09-23 21:00:00	2006-09-24 00:25:00
235	1	2006-09-16	\N	27	2006-09-16 20:45:00	2006-09-16 23:45:00
244	3	2006-09-25	\N	0	2006-09-25 21:00:00	2006-09-26 00:00:00
301	1	2006-11-13	\N	12	2006-11-13 21:30:00	2006-11-14 00:45:00
256	4	2006-10-07	\N	0	2006-10-07 11:00:00	2006-10-07 14:45:00
258	1	2006-10-07	\N	28	2006-10-07 20:40:00	2006-10-08 00:00:00
166	1	2006-07-23	\N	43	2006-07-23 19:10:00	2006-07-24 02:40:00
252	1	2006-10-02	\N	29	2006-10-02 21:00:00	2006-10-02 23:45:00
295	1	2006-11-06	\N	27	2006-11-06 21:00:00	2006-11-06 23:55:00
304	4	2006-11-18	\N	0	2006-11-18 11:00:00	2006-11-18 16:15:00
249	2	2006-09-30	\N	11	2006-09-30 19:30:00	2006-09-30 20:00:00
253	4	2006-10-02	\N	0	\N	\N
260	1	2006-10-09	\N	30	2006-10-09 21:00:00	2006-10-09 23:35:00
263	5	2006-10-14	\N	8	2006-10-14 11:00:00	2006-10-14 16:20:00
264	2	2006-10-14	\N	0	2006-10-14 19:30:00	2006-10-14 20:10:00
321	3	2006-12-03	\N	0	\N	\N
251	3	2006-10-01	\N	24	2006-10-01 19:30:00	2006-10-01 22:00:00
262	6	2006-10-12	\N	0	2006-10-13 07:42:42	2006-10-13 07:42:43
254	3	2006-10-03	\N	39	2006-10-03 21:00:00	2006-10-04 00:30:00
259	3	2006-10-08	\N	26	2006-10-08 19:30:00	2006-10-08 23:00:00
255	6	2006-10-05	\N	0	2006-10-05 21:00:00	2006-10-05 23:20:00
265	1	2006-10-14	\N	23	2006-10-14 21:00:00	2006-10-15 01:15:00
257	2	2006-10-07	\N	11	2006-10-07 19:40:00	2006-10-07 20:10:00
250	1	2006-09-30	\N	27	2006-09-30 20:30:00	2006-09-30 23:30:00
246	3	2006-09-26	\N	39	2006-09-26 21:00:00	2006-09-27 00:30:00
238	3	2006-09-19	\N	27	2006-09-19 21:00:00	2006-09-20 00:15:00
230	3	2006-09-12	\N	22	2006-09-12 21:00:00	2006-09-12 23:50:00
222	3	2006-09-05	\N	29	2006-09-05 21:00:00	2006-09-06 00:20:00
305	2	2006-11-18	\N	14	2006-11-18 19:30:00	2006-11-18 20:45:00
266	3	2006-10-15	\N	15	2006-10-15 19:30:00	2006-10-15 20:10:00
284	1	2006-10-28	\N	27	2006-10-28 21:00:00	2006-10-29 00:30:00
281	6	2006-10-26	\N	0	2006-10-26 21:00:00	2006-10-26 23:00:00
203	3	2006-08-24	\N	30	2006-08-24 21:00:00	2006-08-25 00:30:00
185	3	2006-08-08	\N	24	2006-08-08 08:30:00	2006-08-08 11:40:00
173	1	2006-07-30	\N	47	2006-07-30 19:30:00	2006-07-31 02:00:00
151	3	2006-07-11	\N	27	2006-07-11 21:00:00	2006-07-12 00:15:00
128	3	2006-06-25	\N	32	2006-06-25 18:30:00	2006-06-25 23:50:00
113	3	2006-06-13	\N	25	2006-06-13 20:00:00	2006-06-13 23:40:00
116	3	2006-06-12	\N	25	2006-06-12 21:00:00	2006-06-13 00:30:00
110	1	2006-06-11	\N	15	2006-06-11 22:49:00	2006-06-12 00:25:00
98	1	2006-06-04	\N	31	2006-06-04 19:30:00	2006-06-04 23:15:00
102	2	2006-06-04	\N	14	2006-06-04 23:30:00	2006-06-05 00:24:00
88	3	2006-05-29	\N	8	2006-05-29 20:00:00	2006-05-29 23:50:00
81	2	2006-05-22	\N	12	2006-05-22 19:30:00	2006-05-22 20:44:00
82	1	2006-05-20	\N	10	2006-05-20 18:00:00	2006-05-20 19:30:17
74	1	2006-05-14	\N	40	2006-05-14 19:30:00	2006-05-14 23:15:00
66	2	2006-05-07	\N	8	2006-05-07 23:26:00	2006-05-08 00:14:00
64	1	2006-05-07	\N	36	2006-05-07 19:39:00	2006-05-07 23:23:00
63	1	2006-05-06	\N	6	2006-05-06 19:00:00	2006-05-06 20:00:00
58	3	2006-05-02	\N	16	2006-05-02 21:00:00	2006-05-03 00:40:00
56	1	2006-04-29	\N	6	2006-04-29 19:00:00	2006-04-29 20:17:00
50	3	2006-04-25	\N	7	2006-04-25 21:00:00	2006-04-26 00:24:12
51	2	2006-04-23	\N	6	2006-04-23 20:00:00	2006-04-23 23:00:00
39	1	2006-04-23	\N	44	2006-04-23 19:30:00	2006-04-23 23:15:00
48	1	2006-04-22	\N	4	2006-04-22 19:00:00	2006-04-22 20:14:00
40	2	2006-04-17	\N	12	2006-04-17 21:00:00	2006-04-17 21:30:00
27	1	2006-04-09	\N	41	2006-04-09 19:30:00	2006-04-10 00:15:00
25	1	2006-04-02	\N	36	2006-04-02 19:30:00	2006-04-03 00:15:00
19	1	2006-03-27	\N	18	2006-03-27 21:00:44	2006-03-27 23:07:06
20	2	2006-03-27	\N	12	2006-03-27 23:32:24	2006-03-28 00:07:38
4	1	2006-03-26	\N	35	2006-03-26 19:47:53	2006-03-27 01:00:52
11	2	2006-03-20	\N	9	2006-03-20 21:00:00	2006-03-20 22:00:00
10	1	2006-03-19	\N	51	2006-03-19 19:30:00	2006-03-20 01:52:29
2	1	2006-03-13	\N	17	2006-03-13 21:00:00	2006-03-13 23:18:47
3	2	2006-03-13	\N	11	2006-03-13 23:20:00	2006-03-13 23:45:00
1	1	2006-03-12	\N	31	2006-03-12 19:30:00	2006-03-13 00:44:22
270	1	2006-10-16	\N	27	2006-10-16 21:00:00	2006-10-17 01:00:00
302	6	2006-11-14	\N	3	2006-11-14 21:00:00	2006-11-15 00:10:00
271	3	2006-10-17	\N	57	2006-10-17 21:00:00	2006-10-18 01:00:00
278	6	2006-10-22	\N	5	2006-10-22 21:15:00	2006-10-22 23:15:00
296	6	2006-11-09	\N	0	\N	\N
293	1	2006-11-04	\N	28	2006-11-04 21:45:00	2006-11-05 00:00:00
299	1	2006-11-11	\N	28	2006-11-11 21:30:00	2006-11-12 00:45:00
308	1	2006-11-20	\N	14	2006-11-20 21:15:00	2006-11-21 00:45:00
275	2	2006-10-21	\N	11	2006-10-21 19:30:00	2006-10-21 20:20:00
268	6	2006-10-15	\N	8	2006-10-15 20:30:00	2006-10-15 22:50:00
290	6	2006-11-02	\N	7	2006-11-02 21:00:00	2006-11-02 23:50:00
316	6	2006-11-28	\N	6	2006-11-28 20:30:00	2006-11-28 23:45:00
315	1	2006-11-27	\N	14	2006-11-27 21:00:00	2006-11-28 00:45:00
307	3	2006-11-19	\N	70	2006-11-19 19:30:00	2006-11-19 23:25:00
310	6	2006-11-21	\N	17	2006-11-21 21:00:00	2006-11-22 00:35:00
313	1	2006-11-25	\N	23	2006-11-25 21:00:00	2006-11-26 00:30:00
318	4	2006-12-02	\N	2	2006-12-02 11:00:00	2006-12-02 16:00:00
\.


--
-- Data for Name: toon_classes; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY toon_classes (id, name) FROM stdin;
1	Shaman
2	Priest
3	Warlock
4	Warrior
5	Rogue
6	Hunter
7	Mage
8	Druid
9	Unknown
\.


--
-- Data for Name: toon_ranks; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY toon_ranks (id, name) FROM stdin;
1	New Raider
2	Tier-1 Raider
3	Tier-1 Veteran
4	Boddhisatva
5	Roshi
\.


--
-- Data for Name: toons; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY toons (id, name, class_id, rank_id, "password", last_challenge, alt) FROM stdin;
-1	*** BANK ***	9	1	\N	\N	f
71	Meiko	2	3	\N	\N	f
3	Altord	3	1	\N	\N	f
25	Falinmor	7	3	\N	\N	f
376	Trunxx	7	1	\N	\N	f
384	Crypteaz	9	1	\N	\N	f
102	Bonanaza	6	2	\N	\N	f
341	Ottoshot	6	1	\N	\N	f
10	Brotherfosin	5	1	\N	\N	f
73	Tukanae	5	1	\N	\N	f
12	Carough	7	1	\N	\N	f
74	Disenchant	2	1	\N	\N	f
67	Rajji	6	4	\N	\N	f
17	Declana	7	1	\N	\N	f
77	Thantos	3	1	\N	\N	f
345	Velvictus	9	1	\N	\N	f
20	Dragonheart	4	1	\N	\N	f
97	Alfaa	3	4	\N	\N	f
7	Baruma	8	4	\N	3l7uc	f
80	Akatche	8	1	\N	\N	f
16	Darkfuneral	5	5	\N	rpeic	f
146	Hikagehi	1	2	\N	\N	f
140	Tahtaya	7	1	\N	agd1m	t
37	Jpdragon	8	1	\N	\N	f
83	Faloran	3	1	\N	\N	f
233	Tangg	5	5	\N	\N	f
53	Susumagego	7	4	\N	\N	f
338	Roame	2	1	\N	\N	f
106	Oistenska	6	3	\N	\N	f
88	Frosthammer	8	1	\N	\N	f
92	Trinculo	4	1	\N	\N	f
93	Twinkie	4	1	\N	\N	f
91	Tolroutan	1	1	\N	\N	f
95	Darkblade	6	1	\N	\N	f
94	Bebu	8	1	\N	\N	f
121	Lorbert	2	2	\N	\N	f
81	Lokina	7	3	\N	ec23v	f
4	Arthritis	5	5	\N	\N	f
68	Uerga	6	1	\N	\N	f
278	Drluv	2	1	\N	\N	f
340	Radioaktive	3	2	\N	tgql5	f
11	Candylady	3	3	\N	\N	f
232	Gak	4	5	\N	\N	f
303	Chatolakin	4	1	\N	tt5pq	f
57	Woodstove	1	5	\N	\N	f
158	Igore	5	1	\N	xxs6b	f
82	Hambroil	2	2	\N	h7t7w	f
22	Draxx	5	2	\N	\N	f
19	Dorigord	7	5	\N	ppbir	f
14	Daigh	5	3	\N	\N	f
27	Flowers	8	5	\N	\N	f
41	Lugz	2	5	\N	\N	f
48	Orodruin	6	5	\N	s722a	f
46	Murong	6	3	\N	\N	f
47	Onuk	3	3	\N	\N	f
129	Merridian	7	2	\N	\N	f
276	Chaosmaster	7	1	\N	y2wpr	f
28	Gaijin	1	5	\N	\N	f
65	Buuddha	2	1	\N	\N	f
70	Kusazero	2	1	\N	\N	f
104	Kohna	4	1	\N	\N	f
105	Papadukes	6	1	\N	\N	f
113	Meembachi	9	1	\N	\N	f
112	Sahtina	1	1	\N	\N	f
29	Galenorn	2	4	\N	pp72l	f
117	Unknown Entity	9	1	\N	\N	f
21	Dragonrider	3	5	\N	\N	f
371	Jestor	6	2	\N	hytc4	f
309	15	9	1	\N	btrat	f
114	Rumatoid	2	1	\N	\N	f
327	Sooca	1	1	\N	\N	f
130	Thras	6	1	\N	\N	f
145	Theseal	4	1	\N	\N	f
329	Zuun	7	1	\N	\N	f
297	Nightellf	8	2	\N	\N	f
127	Ethy	4	1	\N	\N	f
352	Thatwaseasy	5	2	\N	\N	f
307	Tabaqui	6	1	\N	kmkum	t
271	Shawdell	8	3	\N	\N	f
332	Zarkonix	9	1	\N	dyz5l	f
126	Deathmoo	8	1	\N	\N	f
137	Joanus	7	1	\N	\N	f
124	Lestatt	5	2	\N	\N	f
138	Lols	7	1	\N	\N	f
161	Eyae	2	2	\N	\N	f
131	Nozomi	4	1	\N	\N	f
125	Veranus	5	1	\N	\N	f
199	Darkfire	3	1	\N	\N	f
162	Omania	1	1	\N	\N	f
134	Volstag	4	2	\N	\N	f
333	Phillychesse	4	1	\N	\N	f
176	Linus	3	1	\N	\N	f
159	Orvis	4	1	\N	\N	f
194	Orcultist	3	1	\N	\N	f
349	Katylee	2	1	\N	\N	f
149	Bullrider	4	1	\N	\N	f
128	Jonkinky	2	1	\N	\N	f
304	Cowpaddy	8	1	\N	\N	f
305	Malgrumm	8	1	\N	\N	f
163	Venomblade	5	1	\N	\N	f
306	Nightfear	3	1	\N	\N	f
144	Pighead	1	2	\N	zzwsr	f
168	Toon Name	8	1	\N	\N	f
179	Bigtuffguy	6	1	\N	\N	f
172	Toreen	2	1	\N	\N	f
173	Abbracadaver	2	1	\N	\N	f
174	Mhdoog	5	1	\N	\N	f
182	Enkata	9	1	\N	\N	f
184	Sotuma	9	1	\N	\N	f
181	Dilvish	7	1	\N	\N	f
185	Tulair	5	1	\N	\N	f
169	Kadr	1	1	\N	3pt51	f
186	Crogan	6	2	\N	ug1pe	f
180	Boolzeye	6	1	\N	\N	f
201	Frostkeep	7	1	\N	\N	f
196	Painpleaser	6	1	\N	\N	f
99	Rashar	6	1	\N	\N	f
195	Broncow	8	1	\N	\N	f
183	Snowwitch	2	1	\N	\N	f
259	Manorc	6	5	\N	q1jel	f
141	Wetaad	6	2	\N	z5r68	f
214	Draconian	2	1	\N	\N	f
193	Mistikeye	8	1	\N	\N	f
368	Elom	9	1	\N	\N	f
311	Shockwar	9	1	\N	\N	f
264	Reepo	4	1	\N	\N	f
208	Dako	6	1	\N	\N	f
72	Stormron	1	3	\N	jx18k	f
313	Bovinicus	4	1	\N	\N	t
96	Eatmymaggots	2	4	\N	\N	f
385	Tougefreak	9	1	\N	\N	f
6	Bantor	5	4	\N	ubmi4	f
135	Bloodydragon	5	4	\N	n67ey	f
205	Unknown	9	1	\N	\N	f
204	Knightalfa	7	1	\N	\N	f
35	Huzzanti	2	5	\N	2ajdd	f
58	Wingdwarrior	4	3	\N	5wz5l	f
49	Puffball	3	4	\N	zvd7i	f
34	Gwodien	3	2	\N	7z4r4	f
241	Woolffee	2	2	\N	\N	t
310	Jojoma	2	1	\N	\N	f
210	Talnoth	1	3	\N	\N	f
8	Briarmane	8	4	\N	su219	f
87	Fishmon	1	1	\N	i5147	f
263	Bindi	2	1	\N	fueyd	f
178	Kossori	5	1	\N	vn2hl	f
165	Sorrek	3	2	\N	qkhs9	f
116	Taukemouta	6	5	\N	pas38	f
246	Honther	6	1	\N	\N	f
36	Imazizi	2	5	\N	\N	f
250	Toadsterchod	3	1	\N	\N	f
227	Picklepotamu	6	3	\N	\N	f
260	Poppz	4	1	\N	\N	f
316	Vaporizer	7	2	\N	sac25	f
133	Hackblade	4	2	\N	7ls2t	f
211	Carou	8	1	\N	dpn9p	f
224	Synr	5	1	\N	\N	f
38	Kadiya	5	3	\N	aaxvc	f
219	Nevik	5	1	\N	\N	f
230	Fdp	7	2	\N	v8vrh	f
59	Zomby	4	3	\N	luy9h	f
323	Lurom	3	1	\N	\N	f
237	Razorburn	5	1	\N	\N	f
60	Zydan	1	5	\N	eszja	f
154	Hecuvus	4	3	\N	msvhe	f
377	Frustration	2	1	\N	\N	f
228	Punchu	6	1	\N	\N	f
282	Yunalesca	8	3	\N	jwqeq	f
190	Naseros	3	2	\N	j7m44	f
215	Gypsydawg	1	2	\N	s3je8	f
372	Cosgrove	3	1	\N	74s7l	f
167	Vormulag	3	3	\N	2wt8m	f
269	Kikaokola	1	2	\N	dtank	f
31	Greatness	3	3	\N	vcfgx	f
288	Bokall	6	2	\N	avpra	f
30	Garkar	1	5	\N	ukxsk	f
317	Mashne	8	1	\N	16zax	f
51	Sandwizapipe	7	5	\N	r5z1f	f
187	Pandaran	5	1	\N	7vrs1	f
236	Heyman	4	2	\N	ag6bw	t
339	Sanosque	4	2	\N	vf2di	f
111	Karan	4	1	\N	r33hq	f
50	Raen	4	5	\N	ayb29	f
249	Phantom	4	1	\N	ar676	f
5	Awahapacha	1	5	\N	p66mc	f
107	Tungiluli	1	3	\N	b8c8a	f
256	Doodad	8	1	\N	\N	f
334	Seg	5	3	\N	6ntzx	f
268	Fasheng	7	1	\N	\N	f
240	Velaska	4	2	\N	ep68p	t
265	Oranges	7	3	\N	ina1v	f
64	Firetroll	7	2	\N	6z6r3	f
32	Grimzeak	3	5	\N	njq1d	f
225	Ith	7	2	\N	jknxh	f
42	Malgrubel	8	4	\N	4rgyl	f
54	Usurper	4	3	\N	2xmhk	f
136	Holyshnikees	2	5	\N	wkps5	f
262	Vaydon	8	1	\N	qflnh	f
119	Hb	3	2	\N	h1rb3	f
63	Windbritches	1	3	\N	lzbsj	f
255	Faitalis	5	3	\N	xjpm4	f
346	Clergy	2	1	\N	\N	f
266	Aldrayk	2	2	\N	1r5pc	f
200	Bellock	6	2	\N	8k6d6	f
24	Exacerate	5	4	\N	el3kx	f
273	Marxi	3	1	\N	7u6wf	f
23	Eldertea	8	4	\N	kjvvl	f
206	Aurom	7	3	\N	lhdl8	f
109	Tui	2	3	\N	r7nw3	t
216	Abrracadaver	2	1	\N	\N	t
335	Buttertray	6	2	\N	g8nej	t
62	Menereg	3	4	\N	\N	t
251	Yalib	7	2	\N	txxm5	f
198	Tamunç	2	1	\N	\N	t
239	Amelor	6	2	\N	8prra	f
209	Lithius	4	3	\N	hgv2x	f
100	Rayno	4	5	\N	pratp	f
312	Sassyy	2	1	\N	\N	f
286	Huzzauntie	7	2	\N	hyf8k	t
373	Gnack	4	2	\N	4r1d5	f
197	Curses	3	1	\N	\N	t
378	Evilbeavers	9	1	\N	\N	f
9	Brookamoon	7	1	\N	\N	t
245	Gibbous	6	2	\N	y3sbl	t
285	Hemster	8	3	\N	5rj4k	t
202	Lucent	2	2	\N	\N	t
289	Arkaic	4	1	\N	\N	f
292	Memnok	4	1	\N	\N	f
379	Galkana	9	1	\N	\N	f
221	Rowdyone	8	2	\N	tud4t	t
217	Cutama	1	3	\N	7zef9	f
325	Dkillah	4	3	\N	h6gf7	f
270	Mireiwyr	3	4	\N	xdu9a	f
157	Elessdee	5	5	\N	x2f8u	f
203	Angél	1	1	\N	41dav	t
248	Oberi	5	2	\N	t8dnh	f
223	Stonehand	4	3	\N	dmmjj	f
153	Yalsnomed	3	4	\N	5k598	f
89	Veren	2	4	\N	71eh1	t
40	Kularanini	7	5	\N	htk4l	f
39	Killerbrute	4	5	\N	27c61	f
2	Alexwilson	4	5	\N	pa5sp	f
290	Cahaal	9	1	\N	\N	f
291	Mostyn	9	1	\N	\N	f
98	Galendae	8	3	\N	\N	t
231	Zerro	3	2	\N	6f2vc	t
90	Caradhras	5	3	\N	z8zh7	t
76	Voodu	1	3	\N	srygb	f
274	Gorsk	6	2	\N	r3cnf	t
369	Karasil	4	2	\N	vzmph	f
103	Sabhrina	2	4	\N	bmt8c	f
257	Ithaedriel	2	2	\N	1u91y	f
115	Swimnick	7	2	\N	rgysw	t
229	Saut	3	1	\N	\N	t
324	Helltrackers	5	1	\N	pwces	f
33	Grundlemung	4	5	\N	ewh6z	f
252	Ender	3	1	\N	\N	t
13	Curti	7	3	\N	kwiuw	f
56	Yartar	6	3	\N	36379	t
26	Fameus	1	2	\N	lfzsb	f
160	Ugarprime	6	5	\N	fnwxl	f
212	Wassup	4	2	\N	\N	t
155	Kavian	1	4	\N	cn6k4	f
18	Dementrous	2	3	\N	\N	t
118	Wiink	8	2	\N	9mc9k	t
238	Drakarra	7	2	\N	2zjcl	f
328	Wolfsoka	1	2	\N	2m1ct	f
84	Kadin	2	3	\N	\N	t
120	Koom	8	2	\N	\N	t
253	Lambadinj	2	1	\N	\N	t
247	Narcotize	4	1	\N	lx68h	t
261	Naxx	2	2	\N	\N	t
226	Reaver	6	1	\N	\N	t
242	Segnaro	5	1	\N	xf3pm	t
43	Malivia	7	5	\N	leiwq	f
85	Wodin	8	2	\N	ryy28	t
166	Zulia	5	2	\N	\N	t
150	Izraahla	1	3	\N	qfllx	f
147	Zwick	5	1	\N	\N	t
139	Zeb	1	2	\N	\N	t
151	Stomping	4	2	\N	sc74u	t
234	Hungryhippo	5	3	\N	awcjb	f
318	Damebix	6	3	\N	bx612	f
347	Solunesa	3	1	\N	znnim	f
294	Cdmac	9	1	\N	\N	f
171	Tubtub	6	5	\N	ixfsz	f
301	Aislin	7	1	\N	yg9ub	f
55	Windrider	1	5	\N	ktehe	f
279	Hehateme	6	1	\N	nipyc	f
302	Meshan	8	1	\N	\N	f
287	Bowman	6	1	\N	3gfqh	f
123	Darksoilder	1	4	\N	c7fi4	f
222	Sissycat	6	3	\N	uhs7h	f
350	Infernalice	7	1	\N	f62pf	f
295	Eldred	7	1	\N	\N	f
319	Magest	7	2	\N	3npyq	f
337	Tfug	6	2	\N	axsrv	f
322	Chosennone	5	3	\N	npjrl	f
284	Alert	5	3	\N	htpb1	f
143	Alitaka	2	1	\N	yk78v	f
189	Bellona	3	1	\N	8d6we	f
331	Rawrness	5	1	\N	rbidq	f
243	Buffalonious	1	2	\N	7g6vr	f
45	Mooluroo	6	5	\N	2hhd3	f
148	Swim	8	3	\N	2k769	f
300	Jynos	3	3	\N	ju6qa	f
380	Makura	9	1	\N	\N	f
235	Combustion	7	3	\N	r7i2r	t
44	Montresor	5	4	\N	kdbqp	f
170	Kruz	4	2	\N	7jsly	t
220	Prynn	3	1	\N	hiwlh	t
15	Danika	8	5	\N	uzgnw	f
336	Consorn	2	2	\N	\N	f
156	Basher	4	2	\N	ecr8n	f
75	Thrinether	5	3	\N	vwey2	f
354	Orock	6	3	\N	sagbn	f
296	Raistreborn	3	2	\N	rf7bc	f
244	Esuka	5	3	\N	eqhaj	f
258	Icyth	6	2	\N	lln21	f
142	Moonbroke	2	5	\N	799q1	f
207	Setch	6	1	\N	rui2c	f
320	Lotanz	1	1	\N	jx81s	t
283	Zaelen	6	3	\N	8z27q	f
272	Hugren	6	2	\N	38l81	f
326	Murahk	5	2	\N	mu8u7	t
315	Thne	6	3	\N	vqhu5	f
277	Zortingis	2	2	\N	h1kfj	f
360	Syretia	6	1	\N	ky9k1	f
86		9	1	\N	7ydrd	f
1	Acer	4	5	\N	69bsh	f
213	Foska	5	2	\N	tyske	f
152	Unliving	5	2	\N	5nfy3	f
308	Tavitorie	2	2	\N	pmusl	f
61	Thogar	4	3	\N	hnwrw	f
175	Bruj	7	3	\N	y7x34	f
374	Bizzy	4	1	\N	56q51	f
267	Stringpuller	4	2	\N	ptpl8	f
330	Jig	7	2	\N	r6tvx	f
164	Grimshepherd	8	2	\N	6a2e7	f
343	Reddik	6	2	\N	y6a54	f
132	Taste	7	3	\N	c7j4k	f
52	Staff	7	5	\N	dzewt	f
299	Grock	3	3	\N	4evt7	f
342	Killertribes	4	1	\N	\N	f
188	Scarabhdm	4	3	\N	iwdb2	t
281	Tureth	4	2	\N	p5evz	t
357	Anatwabaka	2	2	\N	\N	f
348	Appocalypse	3	1	\N	\N	f
351	Unholycrypt	2	2	\N	\N	f
375	Sickwidit	5	1	\N	\N	f
344	Seriath	9	1	\N	\N	f
66	Zindanda	7	2	\N	nymj9	f
383	Seegen	9	1	\N	d5rn3	t
381	Chazaw	9	1	\N	\N	f
370	Ahumm	8	2	\N	\N	f
177	Grukthal	1	2	\N	jnium	f
78	Squall	4	2	\N	ltksa	f
382	Humphrie	7	3	\N	\N	f
314	Grube	4	2	\N	vqxnr	t
275	Capital	4	2	\N	ntbyd	f
359	Kalark	5	2	\N	6y55l	f
293	Risken	7	2	\N	8tdy9	f
358	Seato	5	1	\N	\N	f
355	Zewp	7	1	\N	7sgm1	f
280	Elementalbum	1	3	\N	n84wp	t
356	Fake	4	1	\N	3khv2	f
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY users (id, name, email, "password", "admin") FROM stdin;
1	mdg	\N	\N	200
2	huzzanti	\N	\N	200
3	orodruin		\N	100
4	grimzeak		\N	100
\.


--
-- Data for Name: waitlist_requests; Type: TABLE DATA; Schema: public; Owner: mdg
--

COPY waitlist_requests (id, toon_id, raid_id, first_request, last_expire, approved) FROM stdin;
833	272	207	2006-08-27 19:30:00	2006-08-27 19:30:39	t
827	76	206	2006-08-26 22:22:23	2006-08-26 23:30:00	t
821	170	206	2006-08-26 21:00:00	2006-08-26 21:00:00	t
731	187	199	2006-08-19 20:45:00	2006-08-19 20:45:00	t
749	275	200	2006-08-20 19:48:50	2006-08-21 01:10:00	t
743	274	200	2006-08-20 19:30:00	2006-08-20 23:36:03	t
755	136	200	2006-08-20 22:51:44	2006-08-20 23:03:07	t
779	103	202	2006-08-22 21:00:00	2006-08-22 21:00:00	t
803	170	203	2006-08-25 00:00:27	2006-08-25 00:30:00	t
797	167	203	2006-08-24 21:00:00	2006-08-24 21:00:00	t
839	170	207	2006-08-27 19:56:54	2006-08-27 21:56:54	t
809	2	204	2006-08-26 12:19:45	2006-08-26 14:15:00	t
761	123	201	2006-08-21 21:00:00	2006-08-21 22:50:50	t
773	188	201	2006-08-21 21:51:17	2006-08-22 00:00:00	t
767	206	201	2006-08-21 21:00:00	2006-08-21 21:00:00	t
822	249	205	2006-08-26 19:39:31	2006-08-26 20:25:00	t
834	244	207	2006-08-27 19:30:00	2006-08-27 19:30:00	t
750	267	200	2006-08-20 19:50:21	2006-08-20 21:50:21	t
756	76	200	2006-08-20 23:04:40	2006-08-21 01:04:40	t
744	272	200	2006-08-20 19:30:00	2006-08-20 20:57:04	t
726	170	199	2006-08-19 20:45:00	2006-08-19 20:45:00	t
732	270	199	2006-08-19 20:45:00	2006-08-19 20:45:00	t
780	222	202	2006-08-22 21:00:00	2006-08-22 23:20:00	t
786	135	202	2006-08-22 21:16:08	2006-08-22 21:46:46	t
798	244	203	2006-08-24 21:00:00	2006-08-24 21:00:00	t
762	270	201	2006-08-21 21:00:00	2006-08-21 21:34:05	t
768	171	201	2006-08-21 21:00:00	2006-08-21 22:55:58	t
810	258	204	2006-08-26 12:46:29	2006-08-26 13:32:27	t
721	2	196	2006-08-19 11:09:06	2006-08-19 13:09:06	t
823	245	206	2006-08-26 21:00:00	2006-08-26 21:00:00	t
781	150	202	2006-08-22 21:00:00	2006-08-22 22:45:00	t
787	244	202	2006-08-22 21:33:09	2006-08-22 23:20:00	t
835	275	207	2006-08-27 19:30:00	2006-08-27 23:55:00	t
733	217	199	2006-08-19 20:45:00	2006-08-19 21:55:00	t
727	258	199	2006-08-19 20:45:00	2006-08-19 20:45:00	t
751	259	200	2006-08-20 20:27:33	2006-08-20 23:41:28	t
745	170	200	2006-08-20 19:30:00	2006-08-20 21:10:30	t
757	257	200	2006-08-20 23:54:22	2006-08-21 01:10:00	t
739	270	200	2006-08-20 19:30:00	2006-08-20 19:30:00	t
793	170	203	2006-08-24 21:00:00	2006-08-24 21:41:42	t
799	103	203	2006-08-24 21:39:41	2006-08-24 23:23:11	t
805	170	204	2006-08-26 11:00:00	2006-08-26 12:54:17	t
811	272	204	2006-08-26 13:42:46	2006-08-26 14:15:00	t
769	13	201	2006-08-21 21:10:30	2006-08-21 23:10:30	t
775	272	201	2006-08-21 21:55:39	2006-08-22 00:00:00	t
763	150	201	2006-08-21 21:00:00	2006-08-22 00:00:00	t
722	170	196	2006-08-19 12:50:45	2006-08-19 14:50:45	t
711	258	195	2006-08-17 21:00:00	2006-08-17 21:00:00	t
694	258	194	2006-08-15 21:00:00	2006-08-15 22:16:28	t
824	257	206	2006-08-26 21:00:00	2006-08-26 21:00:00	t
842	188	207	2006-08-27 22:06:32	2006-08-27 23:55:00	t
836	234	207	2006-08-27 19:31:57	2006-08-27 19:32:29	t
788	272	202	2006-08-22 21:41:58	2006-08-22 23:20:00	t
734	151	199	2006-08-19 20:45:00	2006-08-19 21:55:00	t
728	152	199	2006-08-19 20:45:00	2006-08-19 20:45:00	t
746	240	200	2006-08-20 19:30:00	2006-08-20 21:17:59	t
740	123	200	2006-08-20 19:30:00	2006-08-20 19:30:00	t
752	273	200	2006-08-20 21:23:44	2006-08-20 23:00:49	t
782	34	202	2006-08-22 21:00:00	2006-08-22 21:02:55	t
800	222	203	2006-08-24 21:57:22	2006-08-25 00:30:00	t
794	190	203	2006-08-24 21:00:00	2006-08-24 22:31:19	t
806	190	204	2006-08-26 11:00:00	2006-08-26 12:58:08	t
812	148	204	2006-08-26 13:54:43	2006-08-26 14:15:00	t
764	103	201	2006-08-21 21:00:00	2006-08-22 00:00:00	t
770	8	201	2006-08-21 21:15:49	2006-08-21 21:24:09	t
776	209	201	2006-08-21 22:48:43	2006-08-21 22:50:17	t
696	155	194	2006-08-15 21:00:00	2006-08-15 22:26:24	t
698	167	194	2006-08-15 21:00:00	2006-08-15 22:39:06	t
695	200	194	2006-08-15 21:00:00	2006-08-15 22:22:17	t
705	34	194	2006-08-15 21:23:20	2006-08-15 23:23:20	t
701	123	194	2006-08-15 21:00:00	2006-08-15 22:54:43	t
702	111	194	2006-08-15 21:00:00	2006-08-15 22:55:48	t
700	150	194	2006-08-15 21:00:00	2006-08-16 00:30:18	t
697	244	194	2006-08-15 21:00:00	2006-08-16 00:50:00	t
723	217	196	2006-08-19 13:31:29	2006-08-19 15:31:29	t
693	222	194	2006-08-15 21:00:00	2006-08-16 00:50:00	t
703	239	194	2006-08-15 21:01:20	2006-08-16 00:50:00	t
704	39	194	2006-08-15 21:16:41	2006-08-15 21:41:35	t
707	259	194	2006-08-15 21:42:46	2006-08-15 22:06:33	t
699	103	194	2006-08-15 21:00:00	2006-08-15 21:00:00	t
706	153	194	2006-08-15 21:23:55	2006-08-15 23:51:40	t
783	200	202	2006-08-22 21:00:00	2006-08-22 22:57:39	t
789	249	202	2006-08-22 22:57:40	2006-08-22 23:20:00	t
837	267	207	2006-08-27 19:36:48	2006-08-27 23:55:00	t
735	273	199	2006-08-19 20:59:42	2006-08-19 21:55:00	t
729	188	199	2006-08-19 20:45:00	2006-08-19 20:45:00	t
741	187	200	2006-08-20 19:30:00	2006-08-20 20:28:56	t
747	223	200	2006-08-20 19:30:00	2006-08-20 21:26:21	t
753	272	200	2006-08-20 22:04:27	2006-08-21 01:10:00	t
801	55	203	2006-08-24 22:07:59	2006-08-25 00:07:59	t
795	123	203	2006-08-24 21:00:00	2006-08-24 23:32:05	t
807	217	204	2006-08-26 12:12:22	2006-08-26 14:12:22	t
813	160	204	2006-08-26 14:02:00	2006-08-26 14:15:00	t
843	55	207	2006-08-27 22:38:22	2006-08-27 22:47:37	t
765	258	201	2006-08-21 21:00:00	2006-08-21 23:58:37	t
777	249	201	2006-08-21 23:29:27	2006-08-22 00:00:00	t
771	61	201	2006-08-21 21:42:15	2006-08-21 23:27:14	t
114	154	116	2006-06-12 21:00:00	2006-06-13 00:30:00	t
34	171	98	2006-06-04 19:30:00	2006-06-04 22:24:39	t
40	135	98	2006-06-04 19:38:15	2006-06-04 20:53:15	t
39	154	98	2006-06-04 19:30:00	2006-06-04 22:52:24	t
31	32	98	2006-06-04 19:30:00	2006-06-04 23:15:00	t
252	61	131	2006-06-26 21:00:00	2006-06-26 21:00:00	t
317	24	142	2006-07-04 20:54:29	2006-07-04 21:27:27	t
43	156	98	2006-06-04 19:46:34	2006-06-04 21:01:34	t
49	178	98	2006-06-04 22:09:02	2006-06-04 23:15:00	t
44	64	98	2006-06-04 19:47:02	2006-06-04 21:02:02	t
50	154	98	2006-06-04 22:55:47	2006-06-04 23:15:00	t
212	190	126	2006-06-24 15:23:19	2006-06-24 16:00:00	t
215	133	127	2006-06-24 19:00:00	2006-06-24 19:24:04	t
218	178	127	2006-06-24 19:00:00	2006-06-24 19:51:30	t
11	155	90	2006-05-30 21:00:00	2006-05-30 22:12:20	t
224	24	127	2006-06-24 19:19:02	2006-06-24 20:34:02	t
221	123	127	2006-06-24 19:00:00	2006-06-24 19:00:00	t
227	39	127	2006-06-24 21:25:59	2006-06-24 21:58:46	t
236	55	128	2006-06-25 19:44:52	2006-06-25 20:59:52	t
239	76	128	2006-06-25 20:56:38	2006-06-25 22:11:38	t
230	150	128	2006-06-25 18:30:00	2006-06-25 23:50:00	t
233	154	128	2006-06-25 18:30:00	2006-06-25 22:34:56	t
15	154	90	2006-05-30 21:08:37	2006-05-31 00:10:37	t
248	150	131	2006-06-26 21:00:00	2006-06-26 21:30:00	t
251	155	131	2006-06-26 21:00:00	2006-06-26 21:30:00	t
245	123	131	2006-06-26 21:00:00	2006-06-26 21:30:00	t
326	76	143	2006-07-06 22:09:25	2006-07-07 00:09:25	t
297	155	140	2006-07-02 19:38:27	2006-07-02 21:38:27	t
12	160	90	2006-05-30 21:01:41	2006-05-31 00:08:28	t
13	133	90	2006-05-30 21:03:07	2006-05-30 22:18:07	t
14	49	90	2006-05-30 21:07:52	2006-05-30 23:30:25	t
16	155	90	2006-05-30 22:49:42	2006-05-31 00:04:42	t
120	133	113	2006-06-13 20:05:59	2006-06-13 21:20:59	t
80	8	106	2006-06-09 20:42:52	2006-06-09 21:57:52	t
20	35	96	2006-06-02 13:48:53	2006-06-02 15:03:53	t
21	8	96	2006-06-02 22:06:50	2006-06-02 23:21:50	t
81	164	106	2006-06-09 20:42:53	2006-06-09 21:57:53	t
104	115	109	2006-06-11 19:52:56	2006-06-11 21:07:56	t
143	133	115	2006-06-15 02:14:07	2006-06-15 03:29:07	t
23	160	93	2006-06-03 13:03:30	2006-06-03 14:18:30	t
25	39	93	2006-06-03 14:06:48	2006-06-03 15:21:48	t
210	81	126	2006-06-24 11:32:26	2006-06-24 11:50:50	t
26	160	93	2006-06-03 14:34:07	2006-06-03 16:15:00	t
24	58	93	2006-06-03 13:36:41	2006-06-03 15:18:48	t
222	188	127	2006-06-24 19:00:00	2006-06-24 22:36:31	t
237	157	128	2006-06-25 20:37:04	2006-06-25 21:52:04	t
228	188	127	2006-06-24 22:40:09	2006-06-24 23:20:00	t
225	133	127	2006-06-24 19:29:06	2006-06-24 20:44:06	t
216	164	127	2006-06-24 19:00:00	2006-06-24 19:00:00	t
219	89	127	2006-06-24 19:00:00	2006-06-24 19:00:00	t
83	142	106	2006-06-09 20:43:44	2006-06-09 21:58:44	t
240	206	128	2006-06-25 21:41:58	2006-06-25 23:50:00	t
234	76	128	2006-06-25 18:30:00	2006-06-25 20:28:11	t
85	167	106	2006-06-09 20:46:42	2006-06-09 22:01:42	t
86	24	106	2006-06-09 20:50:00	2006-06-09 22:05:00	t
87	6	106	2006-06-09 20:50:14	2006-06-09 22:05:14	t
88	133	106	2006-06-09 20:50:39	2006-06-09 22:05:39	t
89	171	106	2006-06-09 20:56:03	2006-06-09 22:11:03	t
82	160	106	2006-06-09 20:43:10	2006-06-09 22:15:57	t
84	30	106	2006-06-09 20:44:24	2006-06-09 22:29:17	t
90	39	106	2006-06-09 21:26:52	2006-06-09 22:41:52	t
91	24	106	2006-06-09 22:42:40	2006-06-10 00:51:58	t
205	187	120	2006-06-21 20:20:38	2006-06-21 21:22:21	t
79	2	105	2006-06-08 20:58:34	2006-06-08 22:13:34	t
94	24	107	2006-06-10 12:02:12	2006-06-10 13:20:50	t
332	190	147	2006-07-08 16:16:06	2006-07-08 18:16:06	t
299	116	140	2006-07-02 20:21:28	2006-07-02 22:21:28	t
335	39	147	2006-07-08 21:27:24	2006-07-08 23:27:24	t
93	58	107	2006-06-10 11:08:08	2006-06-10 12:06:40	t
30	175	98	2006-06-04 19:30:00	2006-06-04 20:25:55	t
33	157	98	2006-06-04 19:30:00	2006-06-04 20:32:51	t
37	187	98	2006-06-04 19:30:00	2006-06-04 20:42:58	t
29	160	98	2006-06-04 19:30:00	2006-06-04 21:12:52	t
36	178	98	2006-06-04 19:30:00	2006-06-04 21:49:07	t
41	167	98	2006-06-04 19:39:28	2006-06-04 23:15:00	t
47	160	98	2006-06-04 21:24:01	2006-06-04 23:15:00	t
32	164	98	2006-06-04 19:30:00	2006-06-04 19:30:00	t
38	150	98	2006-06-04 19:30:00	2006-06-04 21:14:11	t
45	133	98	2006-06-04 20:09:53	2006-06-04 21:24:53	t
35	165	98	2006-06-04 19:30:00	2006-06-04 19:33:24	t
28	89	98	2006-06-04 19:30:00	2006-06-04 19:30:00	t
46	141	98	2006-06-04 20:38:24	2006-06-04 21:53:24	t
42	38	98	2006-06-04 19:43:06	2006-06-04 21:53:35	t
48	42	98	2006-06-04 21:37:18	2006-06-04 22:52:18	t
97	155	108	2006-06-10 19:00:00	2006-06-10 22:11:14	t
98	133	108	2006-06-10 20:17:14	2006-06-10 21:37:47	t
95	142	108	2006-06-10 19:00:00	2006-06-10 19:00:55	t
96	188	108	2006-06-10 19:00:00	2006-06-10 19:03:47	t
207	190	120	2006-06-21 21:51:35	2006-06-21 23:45:36	t
103	175	109	2006-06-11 19:41:47	2006-06-11 20:56:47	t
105	187	109	2006-06-11 20:06:54	2006-06-11 21:27:29	t
149	142	115	2006-06-15 20:20:34	2006-06-15 21:35:34	t
151	160	115	2006-06-15 20:30:28	2006-06-15 21:45:28	t
59	164	103	2006-06-05 21:00:00	2006-06-05 22:01:02	t
56	167	103	2006-06-05 21:00:00	2006-06-05 23:20:00	t
66	24	103	2006-06-05 21:44:27	2006-06-05 23:20:00	t
64	31	103	2006-06-05 21:22:47	2006-06-05 22:37:47	t
67	186	103	2006-06-05 21:47:23	2006-06-05 23:02:23	t
58	133	103	2006-06-05 21:00:00	2006-06-05 21:00:00	t
53	154	103	2006-06-05 21:00:00	2006-06-05 21:00:00	t
54	150	103	2006-06-05 21:00:00	2006-06-05 21:00:00	t
61	155	103	2006-06-05 21:00:00	2006-06-05 21:00:00	t
63	39	103	2006-06-05 21:22:03	2006-06-05 21:55:23	t
57	142	103	2006-06-05 21:00:00	2006-06-05 21:00:00	t
60	165	103	2006-06-05 21:00:00	2006-06-05 21:00:00	t
55	160	103	2006-06-05 21:00:00	2006-06-05 21:00:00	t
73	187	104	2006-06-07 20:44:00	2006-06-07 20:45:00	t
72	30	104	2006-06-07 20:44:00	2006-06-07 20:44:12	t
112	187	110	2006-06-11 22:50:07	2006-06-11 23:47:49	t
165	133	117	2006-06-17 20:12:41	2006-06-17 21:27:41	t
167	42	117	2006-06-17 22:14:14	2006-06-17 22:15:18	t
155	187	115	2006-06-15 21:19:11	2006-06-15 22:34:11	t
161	187	117	2006-06-17 18:50:31	2006-06-17 19:01:42	t
163	49	117	2006-06-17 18:50:31	2006-06-17 18:50:31	t
159	132	117	2006-06-17 18:50:31	2006-06-17 18:51:24	t
147	153	115	2006-06-15 20:17:13	2006-06-15 23:27:15	t
153	24	115	2006-06-15 21:01:49	2006-06-15 23:44:38	t
145	150	115	2006-06-15 20:07:16	2006-06-16 00:31:34	t
115	156	116	2006-06-12 21:00:00	2006-06-12 21:57:50	t
116	187	116	2006-06-12 21:00:00	2006-06-12 22:04:26	t
118	155	116	2006-06-12 21:00:00	2006-06-13 00:30:00	t
113	24	116	2006-06-12 21:00:00	2006-06-12 21:07:24	t
117	42	116	2006-06-12 21:00:00	2006-06-12 21:00:00	t
201	24	125	2006-06-20 22:24:53	2006-06-20 23:39:53	t
197	150	125	2006-06-20 21:30:45	2006-06-20 23:58:00	t
99	133	109	2006-06-11 19:30:00	2006-06-11 20:29:20	t
106	133	109	2006-06-11 20:56:49	2006-06-11 22:10:00	t
102	154	109	2006-06-11 19:30:00	2006-06-11 19:30:00	t
101	150	109	2006-06-11 19:30:00	2006-06-11 19:30:00	t
100	153	109	2006-06-11 19:30:00	2006-06-11 19:30:00	t
169	155	118	2006-06-18 18:59:41	2006-06-18 20:14:41	t
144	58	115	2006-06-15 03:05:45	2006-06-15 04:20:45	t
206	24	120	2006-06-21 20:27:26	2006-06-21 21:42:26	t
148	175	115	2006-06-15 20:19:47	2006-06-15 21:34:47	t
208	135	120	2006-06-21 23:31:31	2006-06-22 00:46:31	t
152	186	115	2006-06-15 20:36:34	2006-06-15 21:51:34	t
122	123	113	2006-06-13 20:23:53	2006-06-13 23:40:00	t
121	167	113	2006-06-13 20:17:36	2006-06-13 23:40:00	t
154	48	115	2006-06-15 21:13:55	2006-06-15 22:28:55	t
128	24	113	2006-06-13 21:26:07	2006-06-13 21:28:39	t
126	107	113	2006-06-13 20:37:12	2006-06-13 21:52:12	t
124	155	113	2006-06-13 20:29:21	2006-06-13 22:17:12	t
127	150	113	2006-06-13 21:05:32	2006-06-13 22:20:32	t
129	31	113	2006-06-13 22:07:04	2006-06-13 23:22:04	t
166	81	117	2006-06-17 21:30:26	2006-06-17 22:45:26	t
146	167	115	2006-06-15 20:14:27	2006-06-15 23:03:07	t
164	133	117	2006-06-17 18:50:31	2006-06-17 19:51:42	t
156	52	115	2006-06-15 21:55:47	2006-06-15 23:10:47	t
150	154	115	2006-06-15 20:23:26	2006-06-15 23:34:35	t
160	123	117	2006-06-17 18:50:31	2006-06-17 18:50:31	t
188	30	123	2006-06-19 21:42:17	2006-06-19 23:29:28	t
196	155	125	2006-06-20 21:12:08	2006-06-20 22:27:08	t
200	123	125	2006-06-20 22:10:06	2006-06-20 23:25:06	t
175	54	118	2006-06-18 19:48:19	2006-06-18 21:03:19	t
179	133	118	2006-06-18 22:43:14	2006-06-18 23:30:00	t
173	61	118	2006-06-18 19:31:02	2006-06-18 21:15:06	t
176	155	118	2006-06-18 21:56:28	2006-06-18 23:30:00	t
170	154	118	2006-06-18 19:01:06	2006-06-18 23:30:00	t
172	150	118	2006-06-18 19:22:42	2006-06-18 20:01:26	t
157	24	111	2006-06-17 11:18:28	2006-06-17 14:23:32	t
158	58	111	2006-06-17 13:57:08	2006-06-17 14:00:59	t
135	55	114	2006-06-14 20:49:47	2006-06-14 22:04:47	t
137	190	114	2006-06-14 21:25:47	2006-06-14 22:40:47	t
139	164	114	2006-06-14 21:40:26	2006-06-14 22:55:26	t
141	167	114	2006-06-14 22:31:13	2006-06-14 23:46:13	t
136	100	114	2006-06-14 21:00:29	2006-06-14 22:15:29	t
134	150	114	2006-06-14 20:47:55	2006-06-14 22:28:49	t
140	39	114	2006-06-14 21:40:50	2006-06-14 22:55:50	t
131	167	114	2006-06-14 20:35:39	2006-06-14 22:15:14	t
130	186	114	2006-06-14 20:35:39	2006-06-14 21:16:29	t
132	133	114	2006-06-14 20:35:39	2006-06-14 21:50:12	t
138	6	114	2006-06-14 21:36:16	2006-06-15 00:25:28	t
142	150	114	2006-06-14 22:56:06	2006-06-15 00:25:28	t
133	160	114	2006-06-14 20:42:25	2006-06-15 00:05:56	t
181	63	122	2006-06-19 21:00:07	2006-06-19 21:15:00	t
182	155	122	2006-06-19 21:00:35	2006-06-19 21:15:00	t
180	150	122	2006-06-19 20:54:39	2006-06-19 21:15:00	t
238	115	128	2006-06-25 20:50:22	2006-06-25 22:05:22	t
223	49	127	2006-06-24 19:14:20	2006-06-24 21:39:33	t
226	133	127	2006-06-24 21:04:45	2006-06-24 22:19:45	t
220	175	127	2006-06-24 19:00:00	2006-06-24 19:00:00	t
217	150	127	2006-06-24 19:00:00	2006-06-24 19:00:00	t
235	123	128	2006-06-25 19:30:52	2006-06-25 23:50:00	t
232	156	128	2006-06-25 18:30:00	2006-06-25 20:20:54	t
202	154	125	2006-06-20 23:38:57	2006-06-21 00:20:06	t
204	155	125	2006-06-20 23:51:06	2006-06-21 00:20:06	t
198	33	125	2006-06-20 21:45:38	2006-06-20 21:46:28	t
256	2	131	2006-06-26 21:22:04	2006-06-26 21:30:00	t
253	154	131	2006-06-26 21:00:00	2006-06-26 21:00:00	t
250	142	131	2006-06-26 21:00:00	2006-06-26 21:00:00	t
292	90	140	2006-07-02 19:23:33	2006-07-02 21:16:11	t
290	190	139	2006-07-01 19:13:39	2006-07-01 19:14:12	t
254	123	132	2006-06-26 21:37:22	2006-06-27 00:02:16	t
255	72	132	2006-06-26 21:37:22	2006-06-26 22:54:50	t
320	40	142	2006-07-04 21:46:56	2006-07-04 22:48:54	t
296	187	140	2006-07-02 19:34:59	2006-07-02 21:34:59	t
298	211	140	2006-07-02 19:51:21	2006-07-02 21:51:21	t
260	31	132	2006-06-26 23:16:11	2006-06-26 23:16:49	t
249	150	132	2006-06-26 21:37:22	2006-06-26 21:37:22	t
258	155	132	2006-06-26 21:37:22	2006-06-26 22:09:21	t
257	190	132	2006-06-26 21:37:22	2006-06-26 21:37:22	t
279	72	136	2006-06-29 21:03:25	2006-06-29 22:00:00	t
278	150	136	2006-06-29 21:00:00	2006-06-29 22:00:00	t
283	188	137	2006-06-30 21:32:54	2006-07-01 00:19:58	t
284	150	137	2006-06-30 23:25:04	2006-07-01 00:19:58	t
285	188	138	2006-07-01 11:05:40	2006-07-01 13:05:40	t
300	167	140	2006-07-02 20:38:34	2006-07-02 22:38:34	t
318	171	142	2006-07-04 20:55:16	2006-07-04 21:24:19	t
281	190	134	2006-06-29 22:30:00	2006-06-30 00:21:39	t
282	206	134	2006-06-29 22:32:37	2006-06-29 23:05:49	t
280	24	134	2006-06-29 22:30:00	2006-06-29 22:30:00	t
288	188	138	2006-07-01 13:36:12	2006-07-01 15:36:12	t
333	116	147	2006-07-08 19:57:38	2006-07-08 21:57:38	t
327	42	143	2006-07-06 22:16:54	2006-07-06 22:21:38	t
303	123	140	2006-07-02 21:03:44	2006-07-02 23:03:44	t
295	188	140	2006-07-02 19:34:23	2006-07-02 23:05:42	t
310	167	145	2006-07-03 21:30:00	2006-07-03 21:30:00	t
311	76	145	2006-07-03 21:30:00	2006-07-03 21:30:00	t
286	111	138	2006-07-01 11:17:08	2006-07-01 14:42:32	t
289	190	138	2006-07-01 14:51:12	2006-07-01 14:51:44	t
287	160	138	2006-07-01 13:13:52	2006-07-01 14:06:22	t
276	156	129	2006-06-27 23:40:05	2006-06-28 00:57:23	t
271	38	129	2006-06-27 21:23:33	2006-06-28 00:57:23	t
268	153	129	2006-06-27 21:18:23	2006-06-28 00:57:23	t
269	178	129	2006-06-27 21:18:23	2006-06-27 23:15:28	t
263	167	129	2006-06-27 21:18:23	2006-06-27 23:42:07	t
272	177	129	2006-06-27 21:25:27	2006-06-27 23:25:27	t
273	31	129	2006-06-27 21:30:32	2006-06-27 23:30:32	t
270	24	129	2006-06-27 21:18:31	2006-06-27 22:20:15	t
267	154	129	2006-06-27 21:18:23	2006-06-27 21:44:47	t
264	150	129	2006-06-27 21:18:23	2006-06-27 21:18:23	t
266	155	129	2006-06-27 21:18:23	2006-06-27 21:18:23	t
274	133	129	2006-06-27 22:55:31	2006-06-28 00:55:31	t
265	142	129	2006-06-27 21:18:23	2006-06-27 21:18:23	t
291	135	139	2006-07-01 20:29:38	2006-07-01 22:29:38	t
330	39	144	2006-07-08 13:02:24	2006-07-08 15:02:24	t
334	167	147	2006-07-08 20:41:53	2006-07-08 22:41:53	t
302	215	140	2006-07-02 20:48:59	2006-07-03 00:21:57	t
331	5	144	2006-07-08 13:14:24	2006-07-08 15:14:24	t
307	155	140	2006-07-02 23:06:07	2006-07-03 00:21:57	t
328	61	143	2006-07-06 22:45:34	2006-07-06 23:11:02	t
316	123	142	2006-07-04 20:36:44	2006-07-04 20:48:08	t
417	222	160	2006-07-18 21:00:00	2006-07-18 22:35:04	t
418	230	160	2006-07-18 21:00:00	2006-07-18 22:37:18	t
370	203	153	2006-07-13 22:00:53	2006-07-14 00:00:53	t
412	213	160	2006-07-18 21:00:00	2006-07-18 23:42:38	t
308	188	140	2006-07-02 23:20:00	2006-07-03 00:21:57	t
345	5	150	2006-07-10 21:45:00	2006-07-10 23:37:26	t
306	209	140	2006-07-02 22:19:43	2006-07-03 00:21:57	t
346	171	150	2006-07-10 21:45:00	2006-07-10 23:41:31	t
294	63	140	2006-07-02 19:30:57	2006-07-03 00:21:57	t
304	206	140	2006-07-02 21:26:48	2006-07-02 23:43:00	t
305	42	140	2006-07-02 21:36:22	2006-07-02 23:13:51	t
293	61	140	2006-07-02 19:24:03	2006-07-02 23:34:17	t
347	123	150	2006-07-10 21:45:00	2006-07-11 00:30:00	t
343	61	150	2006-07-10 21:45:00	2006-07-11 00:30:00	t
344	155	150	2006-07-10 21:45:00	2006-07-11 00:30:00	t
339	5	148	2006-07-09 20:05:40	2006-07-09 20:30:00	t
338	155	148	2006-07-09 19:45:00	2006-07-09 19:45:00	t
337	167	148	2006-07-09 19:45:00	2006-07-09 19:45:00	t
348	55	150	2006-07-10 21:49:58	2006-07-10 22:07:50	t
349	76	150	2006-07-10 22:04:09	2006-07-11 00:04:09	t
372	19	153	2006-07-13 22:18:44	2006-07-14 00:18:44	t
312	42	145	2006-07-03 21:39:06	2006-07-03 22:00:00	t
309	123	145	2006-07-03 21:30:00	2006-07-03 22:00:00	t
373	209	153	2006-07-13 22:45:43	2006-07-14 00:45:43	t
408	153	159	2006-07-17 21:00:00	2006-07-17 22:56:36	t
340	5	149	2006-07-09 21:00:00	2006-07-09 21:00:00	t
341	209	149	2006-07-09 22:22:21	2006-07-09 22:51:19	t
342	42	149	2006-07-09 23:22:39	2006-07-09 23:34:50	t
405	213	159	2006-07-17 21:00:00	2006-07-17 22:37:43	t
407	150	159	2006-07-17 21:00:00	2006-07-18 00:00:00	t
406	76	159	2006-07-17 21:00:00	2006-07-17 22:07:31	t
352	155	151	2006-07-11 21:00:00	2006-07-11 22:29:38	t
355	63	151	2006-07-11 21:00:00	2006-07-11 22:59:37	t
359	188	151	2006-07-11 23:03:11	2006-07-12 00:15:00	t
360	107	151	2006-07-11 23:19:23	2006-07-12 00:15:00	t
357	148	151	2006-07-11 21:14:14	2006-07-11 22:24:12	t
353	171	151	2006-07-11 21:00:00	2006-07-11 21:00:00	t
367	223	152	2006-07-13 20:54:35	2006-07-13 21:46:51	t
354	167	151	2006-07-11 21:00:00	2006-07-11 21:00:00	t
363	123	152	2006-07-13 20:38:05	2006-07-13 21:46:51	t
356	209	151	2006-07-11 21:07:24	2006-07-11 23:07:24	t
366	142	152	2006-07-13 20:49:54	2006-07-13 20:50:01	t
362	190	152	2006-07-13 20:38:05	2006-07-13 20:41:33	t
365	171	152	2006-07-13 20:40:19	2006-07-13 20:44:03	t
364	123	153	2006-07-13 21:48:55	2006-07-13 22:35:50	t
368	157	153	2006-07-13 21:48:55	2006-07-13 23:44:47	t
416	154	160	2006-07-18 21:00:00	2006-07-19 00:00:32	t
419	153	160	2006-07-18 21:00:00	2006-07-19 00:27:18	t
415	155	160	2006-07-18 21:00:00	2006-07-18 21:00:00	t
395	63	158	2006-07-16 19:30:00	2006-07-16 21:18:48	t
378	217	156	2006-07-15 11:00:24	2006-07-15 13:00:24	t
380	100	156	2006-07-15 12:03:28	2006-07-15 14:03:28	t
396	156	158	2006-07-16 19:30:00	2006-07-16 21:18:55	t
385	221	157	2006-07-15 21:07:04	2006-07-15 23:07:04	t
386	55	157	2006-07-15 21:12:18	2006-07-15 23:12:18	t
397	223	158	2006-07-16 19:30:00	2006-07-16 21:21:08	t
377	188	156	2006-07-15 11:00:00	2006-07-15 15:20:00	t
398	188	158	2006-07-16 19:30:00	2006-07-16 21:25:03	t
394	213	158	2006-07-16 19:30:00	2006-07-16 23:20:04	t
382	217	156	2006-07-15 14:34:26	2006-07-15 15:20:00	t
403	81	158	2006-07-16 23:49:04	2006-07-17 01:04:18	t
383	135	156	2006-07-15 14:35:42	2006-07-15 15:20:00	t
375	213	156	2006-07-15 11:00:00	2006-07-15 11:00:00	t
379	136	156	2006-07-15 11:04:02	2006-07-15 12:15:02	t
376	39	156	2006-07-15 11:00:00	2006-07-15 11:00:00	t
404	42	158	2006-07-16 23:51:10	2006-07-17 01:28:54	t
389	171	157	2006-07-15 22:35:21	2006-07-15 23:21:13	t
390	64	157	2006-07-15 22:42:03	2006-07-15 23:21:13	t
388	188	157	2006-07-15 22:23:17	2006-07-15 23:21:13	t
421	209	160	2006-07-18 21:12:21	2006-07-18 21:15:51	t
420	171	160	2006-07-18 21:00:00	2006-07-18 21:00:00	t
414	167	160	2006-07-18 21:00:00	2006-07-18 21:00:00	t
399	123	158	2006-07-16 19:58:16	2006-07-16 21:58:16	t
400	118	158	2006-07-16 20:28:53	2006-07-16 22:28:53	t
401	217	158	2006-07-16 21:13:26	2006-07-16 23:13:26	t
402	217	158	2006-07-16 23:40:14	2006-07-17 01:40:14	t
393	190	158	2006-07-16 19:30:00	2006-07-16 19:30:00	t
392	89	158	2006-07-16 19:30:00	2006-07-16 19:30:00	t
485	230	169	2006-07-25 20:30:00	2006-07-25 21:05:00	t
447	39	164	2006-07-22 10:54:22	2006-07-22 12:54:22	t
422	188	160	2006-07-18 21:53:58	2006-07-18 23:53:58	t
423	76	160	2006-07-18 21:55:49	2006-07-18 23:55:49	t
493	167	170	2006-07-25 21:20:00	2006-07-25 23:16:36	t
426	156	160	2006-07-18 22:23:04	2006-07-19 00:23:04	t
473	87	167	2006-07-24 21:00:00	2006-07-24 22:30:00	t
475	188	167	2006-07-24 21:25:57	2006-07-24 22:30:00	t
455	213	166	2006-07-23 19:10:00	2006-07-23 20:03:34	t
465	188	166	2006-07-23 21:13:41	2006-07-23 23:13:41	t
467	217	166	2006-07-23 22:38:30	2006-07-24 00:34:22	t
477	230	168	2006-07-24 23:00:00	2006-07-25 00:43:48	t
457	123	166	2006-07-23 19:10:00	2006-07-23 22:54:57	t
469	31	166	2006-07-23 23:27:21	2006-07-24 01:27:21	t
479	31	168	2006-07-24 23:35:54	2006-07-25 00:45:00	t
459	155	166	2006-07-23 19:10:00	2006-07-23 19:11:01	t
463	222	166	2006-07-23 20:15:20	2006-07-24 02:01:42	t
461	165	166	2006-07-23 19:44:54	2006-07-23 23:07:12	t
504	167	171	2006-07-27 20:45:00	2006-07-27 22:36:40	t
510	135	171	2006-07-27 21:11:30	2006-07-27 23:11:30	t
495	234	170	2006-07-25 21:23:28	2006-07-25 23:23:28	t
506	200	171	2006-07-27 20:47:41	2006-07-28 00:23:35	t
433	223	161	2006-07-20 21:00:00	2006-07-20 21:30:00	t
434	63	161	2006-07-20 21:00:00	2006-07-20 21:30:00	t
435	107	161	2006-07-20 21:00:00	2006-07-20 21:30:00	t
437	230	161	2006-07-20 21:00:00	2006-07-20 21:30:00	t
438	154	161	2006-07-20 21:00:00	2006-07-20 21:30:00	t
439	55	161	2006-07-20 21:00:00	2006-07-20 21:30:00	t
440	225	161	2006-07-20 21:00:00	2006-07-20 21:30:00	t
432	188	161	2006-07-20 21:00:00	2006-07-20 21:30:00	t
430	222	161	2006-07-20 21:00:00	2006-07-20 21:00:00	t
448	60	164	2006-07-22 12:12:47	2006-07-22 13:39:18	t
472	217	167	2006-07-24 21:00:00	2006-07-24 22:30:00	t
490	188	169	2006-07-25 20:30:00	2006-07-25 21:05:00	t
456	238	166	2006-07-23 19:10:00	2006-07-23 21:37:42	t
466	156	166	2006-07-23 22:08:25	2006-07-24 00:08:25	t
492	223	169	2006-07-25 20:37:18	2006-07-25 21:05:00	t
444	167	163	2006-07-20 21:58:24	2006-07-20 23:58:24	t
445	230	163	2006-07-20 22:20:53	2006-07-21 00:20:53	t
446	156	163	2006-07-20 22:58:47	2006-07-21 00:58:47	t
429	230	163	2006-07-20 21:45:00	2006-07-20 22:19:19	t
436	107	163	2006-07-20 21:45:00	2006-07-20 22:49:12	t
441	55	163	2006-07-20 21:45:00	2006-07-20 23:05:28	t
442	153	163	2006-07-20 21:45:00	2006-07-21 01:00:00	t
443	150	163	2006-07-20 21:45:00	2006-07-21 01:00:00	t
431	188	163	2006-07-20 21:45:00	2006-07-21 01:00:00	t
428	222	163	2006-07-20 21:45:00	2006-07-21 01:00:00	t
476	155	168	2006-07-24 23:00:00	2006-07-25 00:40:04	t
470	61	166	2006-07-23 23:34:16	2006-07-24 01:34:16	t
462	135	166	2006-07-23 19:51:48	2006-07-23 22:18:07	t
464	42	166	2006-07-23 21:12:33	2006-07-23 22:50:26	t
458	132	166	2006-07-23 19:10:00	2006-07-23 19:23:36	t
460	89	166	2006-07-23 19:10:00	2006-07-23 19:22:30	t
488	225	169	2006-07-25 20:30:00	2006-07-25 20:37:45	t
474	188	168	2006-07-24 23:00:00	2006-07-25 00:45:00	t
478	154	168	2006-07-24 23:00:00	2006-07-25 00:45:00	t
484	222	169	2006-07-25 20:30:00	2006-07-25 20:34:21	t
508	34	171	2006-07-27 20:50:14	2006-07-27 23:56:57	t
514	34	171	2006-07-27 23:10:27	2006-07-27 23:56:57	t
507	5	171	2006-07-27 20:49:36	2006-07-27 22:49:36	t
509	221	171	2006-07-27 20:52:36	2006-07-27 22:52:36	t
496	153	170	2006-07-25 21:25:54	2006-07-26 00:35:00	t
486	222	170	2006-07-25 21:20:00	2006-07-26 00:35:00	t
503	230	171	2006-07-27 20:45:00	2006-07-27 22:34:38	t
487	230	170	2006-07-25 21:20:00	2006-07-26 00:35:00	t
489	188	170	2006-07-25 21:20:00	2006-07-26 00:35:00	t
501	215	170	2006-07-25 22:50:25	2006-07-26 00:35:00	t
505	206	171	2006-07-27 20:45:00	2006-07-27 22:19:46	t
513	39	171	2006-07-27 21:22:02	2006-07-27 23:46:17	t
502	222	171	2006-07-27 20:45:00	2006-07-28 00:35:00	t
512	188	171	2006-07-27 21:19:29	2006-07-28 00:35:00	t
497	150	170	2006-07-25 21:26:08	2006-07-25 23:35:39	t
494	61	170	2006-07-25 21:21:23	2006-07-25 21:24:50	t
531	225	174	2006-07-31 21:00:00	2006-07-31 22:28:11	t
532	123	174	2006-07-31 21:00:00	2006-07-31 22:33:02	t
533	167	174	2006-07-31 21:00:00	2006-07-31 23:39:40	t
530	150	174	2006-07-31 21:00:00	2006-08-01 00:15:00	t
536	255	174	2006-07-31 21:44:28	2006-08-01 00:15:00	t
540	107	174	2006-08-01 00:01:26	2006-08-01 00:15:00	t
534	200	174	2006-07-31 21:00:00	2006-07-31 22:31:00	t
537	135	174	2006-07-31 21:46:37	2006-07-31 22:07:22	t
535	221	174	2006-07-31 21:11:19	2006-07-31 22:05:43	t
538	107	174	2006-07-31 21:56:38	2006-07-31 23:56:38	t
539	247	174	2006-07-31 21:58:34	2006-07-31 23:58:34	t
521	255	173	2006-07-30 19:57:40	2006-07-30 23:58:39	t
525	42	173	2006-07-30 23:43:31	2006-07-31 01:43:31	t
522	217	173	2006-07-30 20:48:30	2006-07-30 22:48:30	t
524	56	173	2006-07-30 23:42:46	2006-07-31 01:42:46	t
526	61	173	2006-07-30 23:56:53	2006-07-31 01:56:53	t
517	56	173	2006-07-30 19:30:00	2006-07-30 21:28:33	t
516	247	173	2006-07-30 19:30:00	2006-07-31 02:00:00	t
519	5	173	2006-07-30 19:51:41	2006-07-31 00:20:08	t
518	200	173	2006-07-30 19:30:00	2006-07-31 00:46:43	t
523	136	173	2006-07-30 21:15:03	2006-07-30 21:22:34	t
515	222	173	2006-07-30 19:30:00	2006-07-30 19:30:00	t
520	223	173	2006-07-30 19:56:42	2006-07-30 20:01:38	t
582	247	181	2006-08-05 12:34:27	2006-08-05 15:45:00	t
584	217	181	2006-08-05 13:38:36	2006-08-05 15:45:00	t
570	225	180	2006-08-03 21:07:07	2006-08-03 21:35:00	t
590	217	187	2006-08-05 23:29:27	2006-08-06 01:29:27	t
586	258	186	2006-08-05 19:30:00	2006-08-05 19:30:00	t
594	242	182	2006-08-06 19:30:00	2006-08-06 21:13:04	t
572	155	179	2006-08-03 22:00:00	2006-08-03 23:43:39	t
574	234	179	2006-08-03 22:00:00	2006-08-03 23:46:59	t
568	150	179	2006-08-03 22:00:00	2006-08-04 00:45:00	t
566	200	179	2006-08-03 22:00:00	2006-08-03 22:00:44	t
576	61	179	2006-08-03 22:13:46	2006-08-03 23:19:18	t
596	200	182	2006-08-06 19:30:00	2006-08-06 19:36:21	t
592	258	182	2006-08-06 19:30:00	2006-08-06 21:02:23	t
600	51	182	2006-08-06 22:51:30	2006-08-06 23:10:17	t
598	72	182	2006-08-06 21:22:03	2006-08-06 22:21:28	t
549	76	175	2006-08-01 20:40:00	2006-08-01 21:40:00	t
556	160	175	2006-08-01 20:46:20	2006-08-01 21:40:00	t
552	251	175	2006-08-01 20:40:00	2006-08-01 21:40:00	t
553	244	175	2006-08-01 20:40:00	2006-08-01 21:40:00	t
554	223	175	2006-08-01 20:40:00	2006-08-01 21:40:00	t
545	150	175	2006-08-01 20:40:00	2006-08-01 21:40:00	t
551	225	175	2006-08-01 20:40:00	2006-08-01 20:40:00	t
543	222	175	2006-08-01 20:40:00	2006-08-01 20:40:00	t
547	167	175	2006-08-01 20:40:00	2006-08-01 20:40:00	t
548	167	178	2006-08-01 22:00:00	2006-08-01 22:23:00	t
555	123	178	2006-08-01 22:00:00	2006-08-01 22:43:51	t
550	247	178	2006-08-01 22:00:00	2006-08-01 23:45:24	t
559	251	178	2006-08-01 22:00:00	2006-08-01 23:49:39	t
560	244	178	2006-08-01 22:00:00	2006-08-01 23:49:56	t
561	225	178	2006-08-01 22:00:00	2006-08-01 23:52:19	t
546	150	178	2006-08-01 22:00:00	2006-08-02 00:15:39	t
557	222	178	2006-08-01 22:00:00	2006-08-02 00:43:31	t
562	243	178	2006-08-01 22:23:10	2006-08-02 00:45:00	t
558	221	178	2006-08-01 22:00:00	2006-08-01 22:00:00	t
563	76	178	2006-08-01 22:55:58	2006-08-01 23:43:39	t
585	156	181	2006-08-05 14:24:39	2006-08-05 15:45:00	t
581	258	181	2006-08-05 11:00:00	2006-08-05 13:06:09	t
583	160	181	2006-08-05 13:08:09	2006-08-05 14:32:34	t
593	56	182	2006-08-06 19:30:00	2006-08-06 22:46:18	t
591	247	187	2006-08-05 23:33:43	2006-08-06 01:33:43	t
587	257	186	2006-08-05 20:40:54	2006-08-05 20:45:00	t
601	56	182	2006-08-06 22:58:41	2006-08-07 00:15:00	t
571	251	180	2006-08-03 21:07:34	2006-08-03 21:35:00	t
569	234	180	2006-08-03 21:05:00	2006-08-03 21:35:00	t
565	200	180	2006-08-03 21:05:00	2006-08-03 21:05:00	t
567	150	180	2006-08-03 21:05:00	2006-08-03 21:05:00	t
575	258	179	2006-08-03 22:00:11	2006-08-04 00:00:11	t
577	76	179	2006-08-03 22:38:49	2006-08-04 00:38:49	t
573	222	179	2006-08-03 22:00:00	2006-08-03 22:00:00	t
599	255	182	2006-08-06 21:55:27	2006-08-06 23:14:56	t
595	213	182	2006-08-06 19:30:00	2006-08-06 19:30:00	t
597	220	182	2006-08-06 19:32:19	2006-08-06 19:39:44	t
669	258	191	2006-08-13 19:30:00	2006-08-13 19:30:00	t
684	167	192	2006-08-14 21:00:00	2006-08-14 22:34:45	t
662	136	189	2006-08-12 15:58:38	2006-08-12 16:25:00	t
654	200	189	2006-08-12 11:00:00	2006-08-12 11:00:00	t
686	239	192	2006-08-14 21:13:54	2006-08-14 23:00:00	t
683	150	192	2006-08-14 21:00:00	2006-08-14 21:56:44	t
685	257	192	2006-08-14 21:00:00	2006-08-14 22:36:19	t
682	258	192	2006-08-14 21:00:00	2006-08-14 23:00:00	t
687	153	192	2006-08-14 21:19:03	2006-08-14 23:00:00	t
657	5	189	2006-08-12 13:11:26	2006-08-12 13:16:02	t
659	258	189	2006-08-12 15:39:54	2006-08-12 15:56:52	t
652	265	188	2006-08-10 21:22:48	2006-08-10 23:22:48	t
644	76	188	2006-08-10 21:00:00	2006-08-10 21:24:38	t
650	234	188	2006-08-10 21:00:00	2006-08-10 21:00:00	t
646	258	188	2006-08-10 21:00:00	2006-08-10 21:00:00	t
648	55	188	2006-08-10 21:00:00	2006-08-10 21:00:00	t
649	167	188	2006-08-10 21:00:00	2006-08-11 00:07:51	t
651	1	188	2006-08-10 21:03:21	2006-08-10 22:48:13	t
605	200	183	2006-08-07 21:00:00	2006-08-07 22:28:54	t
608	188	183	2006-08-07 21:00:00	2006-08-07 22:43:08	t
609	239	183	2006-08-07 21:00:00	2006-08-07 22:48:50	t
610	150	183	2006-08-07 21:00:00	2006-08-07 23:10:13	t
613	251	183	2006-08-07 21:46:26	2006-08-07 23:46:26	t
617	23	183	2006-08-07 22:04:52	2006-08-08 00:04:52	t
618	150	183	2006-08-07 23:18:25	2006-08-08 00:25:00	t
606	258	183	2006-08-07 21:00:00	2006-08-08 00:25:00	t
616	247	183	2006-08-07 21:54:05	2006-08-08 00:25:00	t
614	24	183	2006-08-07 21:46:33	2006-08-08 00:25:00	t
615	2	183	2006-08-07 21:49:04	2006-08-07 21:57:09	t
611	31	183	2006-08-07 21:07:37	2006-08-07 21:40:26	t
612	32	183	2006-08-07 21:17:12	2006-08-07 21:24:49	t
607	225	183	2006-08-07 21:00:00	2006-08-07 21:00:00	t
645	244	188	2006-08-10 21:00:00	2006-08-10 21:00:00	t
653	222	188	2006-08-10 21:27:40	2006-08-11 00:18:41	t
647	251	188	2006-08-10 21:00:00	2006-08-10 21:00:00	t
655	188	189	2006-08-12 11:00:00	2006-08-12 11:00:00	t
691	150	192	2006-08-14 22:53:39	2006-08-14 23:00:00	t
688	266	192	2006-08-14 21:20:27	2006-08-14 23:00:00	t
689	39	192	2006-08-14 21:25:57	2006-08-14 22:23:01	t
665	258	193	2006-08-12 19:30:00	2006-08-12 19:30:00	t
672	244	191	2006-08-13 19:30:00	2006-08-13 21:19:43	t
677	156	191	2006-08-13 20:36:25	2006-08-13 22:36:25	t
670	217	191	2006-08-13 19:30:00	2006-08-13 21:22:01	t
678	244	191	2006-08-13 21:53:29	2006-08-13 23:53:29	t
667	245	191	2006-08-13 19:30:00	2006-08-13 22:40:15	t
671	75	191	2006-08-13 19:30:00	2006-08-13 23:06:04	t
675	56	191	2006-08-13 19:30:00	2006-08-13 23:59:54	t
668	266	191	2006-08-13 19:30:00	2006-08-13 19:30:00	t
676	235	191	2006-08-13 19:30:52	2006-08-13 21:36:37	t
681	255	191	2006-08-13 22:56:25	2006-08-13 23:34:45	t
679	167	191	2006-08-13 22:13:58	2006-08-13 22:14:10	t
674	55	191	2006-08-13 19:30:00	2006-08-13 23:33:29	t
666	257	190	2006-08-12 18:58:59	2006-08-12 19:40:00	t
661	123	190	2006-08-12 18:15:00	2006-08-12 18:15:00	t
664	258	190	2006-08-12 18:15:00	2006-08-12 18:15:00	t
778	150	201	2006-08-22 00:30:47	2006-08-22 02:30:47	f
820	258	205	2006-08-26 19:30:00	2006-08-26 19:30:00	t
832	245	207	2006-08-27 19:30:00	2006-08-27 20:01:40	t
748	249	200	2006-08-20 19:40:44	2006-08-20 21:40:44	t
724	258	198	2006-08-19 19:30:00	2006-08-19 19:30:00	t
754	223	200	2006-08-20 22:32:36	2006-08-21 00:32:36	t
742	258	200	2006-08-20 19:30:00	2006-08-20 19:30:00	t
790	209	202	2006-08-22 23:19:34	2006-08-22 23:20:00	t
784	259	202	2006-08-22 21:08:34	2006-08-22 22:02:33	t
736	249	199	2006-08-19 21:00:52	2006-08-19 21:55:00	t
730	136	199	2006-08-19 20:45:00	2006-08-19 20:45:00	t
838	274	207	2006-08-27 19:39:15	2006-08-27 23:00:13	t
826	239	206	2006-08-26 21:00:00	2006-08-26 21:00:00	t
713	244	195	2006-08-17 21:00:00	2006-08-17 22:21:24	t
714	234	195	2006-08-17 21:00:00	2006-08-17 22:34:37	t
715	103	195	2006-08-17 21:00:00	2006-08-18 00:00:00	t
716	255	195	2006-08-17 21:23:23	2006-08-17 23:23:23	t
772	273	201	2006-08-21 21:42:40	2006-08-21 23:42:40	t
712	123	195	2006-08-17 21:00:00	2006-08-18 00:00:00	t
760	273	201	2006-08-21 21:00:00	2006-08-21 21:03:19	t
766	244	201	2006-08-21 21:00:00	2006-08-21 22:41:43	t
802	76	203	2006-08-24 23:29:54	2006-08-25 00:30:00	t
718	109	195	2006-08-17 22:18:52	2006-08-18 00:00:00	t
719	244	195	2006-08-17 22:34:25	2006-08-18 00:00:00	t
717	222	195	2006-08-17 21:31:28	2006-08-18 00:00:00	t
720	61	195	2006-08-17 22:43:37	2006-08-17 22:54:22	t
796	155	203	2006-08-24 21:00:00	2006-08-24 21:00:00	t
808	103	204	2006-08-26 12:14:43	2006-08-26 14:14:43	t
814	39	204	2006-08-26 14:14:00	2006-08-26 14:15:00	t
861	217	209	2006-08-29 21:00:00	2006-08-29 22:38:29	f
873	234	212	2006-08-31 21:00:00	2006-08-31 22:51:43	f
874	272	212	2006-08-31 21:07:24	2006-09-01 00:20:00	f
897	245	216	2006-09-03 19:30:00	2006-09-03 20:55:44	f
870	217	209	2006-08-30 00:19:04	2006-08-30 00:20:00	f
872	244	212	2006-08-31 21:00:00	2006-08-31 21:12:11	f
858	258	209	2006-08-29 21:00:00	2006-08-30 00:20:00	f
877	160	212	2006-08-31 23:05:18	2006-08-31 23:20:46	f
871	167	212	2006-08-31 21:00:00	2006-08-31 21:00:00	f
867	257	209	2006-08-29 23:10:50	2006-08-30 00:20:00	f
868	188	209	2006-08-29 23:19:01	2006-08-30 00:20:00	f
886	270	213	2006-09-02 19:30:00	2006-09-02 20:00:00	f
869	249	209	2006-08-29 23:43:21	2006-08-30 00:20:00	f
899	170	216	2006-09-03 19:30:00	2006-09-03 21:02:34	f
862	244	209	2006-08-29 21:00:00	2006-08-29 21:00:00	f
863	33	209	2006-08-29 21:02:23	2006-08-29 22:53:48	f
864	39	209	2006-08-29 21:29:58	2006-08-29 22:52:10	f
859	103	209	2006-08-29 21:00:00	2006-08-29 22:49:18	f
866	103	209	2006-08-29 22:36:12	2006-08-29 22:49:18	f
860	222	209	2006-08-29 21:00:00	2006-08-29 23:02:21	f
888	217	213	2006-09-02 19:30:00	2006-09-02 19:30:00	f
889	234	213	2006-09-02 19:30:00	2006-09-02 19:33:15	f
875	76	212	2006-08-31 21:09:09	2006-08-31 23:09:09	f
887	170	213	2006-09-02 19:30:00	2006-09-02 19:30:00	f
851	249	208	2006-08-28 21:13:26	2006-08-28 23:13:26	t
853	123	208	2006-08-28 21:55:32	2006-08-28 23:55:32	t
846	270	208	2006-08-28 21:00:00	2006-08-28 21:08:08	t
850	257	208	2006-08-28 21:00:00	2006-08-28 22:30:10	t
849	244	208	2006-08-28 21:00:00	2006-08-28 23:39:09	t
856	76	208	2006-08-28 22:56:43	2006-08-29 00:20:00	t
854	272	208	2006-08-28 21:57:32	2006-08-29 00:20:00	t
847	258	208	2006-08-28 21:00:00	2006-08-28 23:35:32	t
855	258	208	2006-08-28 22:08:34	2006-08-28 23:35:32	t
848	103	208	2006-08-28 21:00:00	2006-08-28 21:00:00	t
876	5	212	2006-08-31 22:04:03	2006-09-01 00:04:03	f
895	275	216	2006-09-03 19:30:00	2006-09-03 19:30:00	f
900	244	216	2006-09-03 19:30:00	2006-09-03 19:30:00	f
865	272	209	2006-08-29 21:39:13	2006-08-29 23:39:13	f
878	2	214	2006-09-02 11:01:11	2006-09-02 13:01:11	t
879	234	214	2006-09-02 12:32:59	2006-09-02 13:41:42	t
881	249	214	2006-09-02 13:37:28	2006-09-02 14:30:00	t
883	148	214	2006-09-02 13:46:49	2006-09-02 14:30:00	t
884	100	214	2006-09-02 14:05:33	2006-09-02 14:30:00	t
880	171	214	2006-09-02 13:07:56	2006-09-02 13:41:03	t
896	272	216	2006-09-03 19:30:00	2006-09-03 19:30:00	f
898	270	216	2006-09-03 19:30:00	2006-09-03 19:30:00	f
901	167	216	2006-09-03 19:30:00	2006-09-03 19:30:00	f
890	217	215	2006-09-02 20:30:00	2006-09-02 20:30:00	f
891	234	215	2006-09-02 20:30:00	2006-09-02 20:30:00	f
892	257	215	2006-09-02 20:43:53	2006-09-02 21:37:40	f
885	270	215	2006-09-02 20:30:00	2006-09-02 20:30:00	f
927	123	222	2006-09-05 21:00:00	2006-09-05 21:17:55	t
933	257	222	2006-09-05 21:00:00	2006-09-05 22:47:05	t
931	284	222	2006-09-05 21:00:00	2006-09-06 00:20:00	t
937	188	222	2006-09-05 21:31:43	2006-09-06 00:20:00	t
905	111	216	2006-09-03 19:32:41	2006-09-03 21:32:41	f
906	119	216	2006-09-03 19:51:17	2006-09-03 21:51:17	f
902	274	216	2006-09-03 19:30:00	2006-09-03 21:27:39	f
904	283	216	2006-09-03 19:31:30	2006-09-03 22:27:38	f
903	238	216	2006-09-03 19:30:00	2006-09-03 21:28:23	f
907	152	216	2006-09-03 19:51:49	2006-09-03 20:36:37	f
929	155	222	2006-09-05 21:00:00	2006-09-05 21:00:00	t
935	40	222	2006-09-05 21:12:31	2006-09-05 22:56:34	t
939	45	222	2006-09-05 22:51:02	2006-09-05 23:04:56	t
934	167	222	2006-09-05 21:00:00	2006-09-05 22:53:06	t
928	283	222	2006-09-05 21:00:00	2006-09-06 00:20:00	t
938	103	222	2006-09-05 22:33:11	2006-09-06 00:20:00	t
930	272	222	2006-09-05 21:00:00	2006-09-05 21:00:00	t
932	222	222	2006-09-05 21:00:00	2006-09-05 23:34:09	t
936	55	222	2006-09-05 21:30:42	2006-09-05 22:34:16	t
911	52	218	2006-09-04 15:42:57	2006-09-04 16:00:00	t
910	284	218	2006-09-04 13:30:00	2006-09-04 13:30:00	t
914	123	219	2006-09-04 21:00:00	2006-09-04 22:01:30	t
913	170	219	2006-09-04 21:00:00	2006-09-04 21:53:10	t
915	283	219	2006-09-04 21:00:00	2006-09-04 22:10:52	t
921	257	219	2006-09-04 21:41:15	2006-09-04 22:45:00	t
923	222	219	2006-09-04 21:42:12	2006-09-04 22:45:00	t
925	55	219	2006-09-04 22:12:27	2006-09-04 22:45:00	t
920	85	219	2006-09-04 21:15:43	2006-09-04 22:45:00	t
919	8	219	2006-09-04 21:00:00	2006-09-04 22:45:00	t
916	243	219	2006-09-04 21:00:00	2006-09-04 22:45:00	t
917	76	219	2006-09-04 21:00:00	2006-09-04 22:45:00	t
926	243	219	2006-09-04 23:40:40	2006-09-05 01:40:40	f
1562	207	270	2006-10-16 21:32:13	2006-10-16 23:32:13	t
1558	52	270	2006-10-16 21:00:00	2006-10-16 22:06:27	t
1583	175	271	2006-10-17 21:11:25	2006-10-17 23:11:25	t
1115	303	237	2006-09-18 21:00:00	2006-09-18 22:29:58	t
1117	217	237	2006-09-18 21:00:00	2006-09-18 22:57:10	t
995	284	227	2006-09-10 19:30:00	2006-09-10 20:58:57	f
996	288	227	2006-09-10 19:30:00	2006-09-10 21:00:41	f
1178	157	240	2006-09-23 11:43:20	2006-09-23 13:43:20	t
1181	171	240	2006-09-23 15:51:27	2006-09-23 15:55:00	t
1507	213	265	2006-10-14 21:00:00	2006-10-14 22:38:52	t
1000	284	227	2006-09-10 21:26:17	2006-09-10 23:20:00	f
988	123	227	2006-09-10 19:30:00	2006-09-10 19:30:00	f
1266	282	248	2006-09-30 12:18:31	2006-09-30 13:40:32	f
994	272	227	2006-09-10 19:30:00	2006-09-10 19:30:00	f
993	257	227	2006-09-10 19:30:00	2006-09-10 19:30:00	f
992	170	227	2006-09-10 19:30:00	2006-09-10 19:30:00	f
999	221	227	2006-09-10 20:29:46	2006-09-10 20:59:35	f
991	76	227	2006-09-10 19:30:00	2006-09-10 19:30:00	f
997	283	227	2006-09-10 19:30:00	2006-09-10 21:57:02	f
1487	235	263	2006-10-14 12:07:12	2006-10-14 15:38:20	t
1078	284	234	2006-09-16 19:37:39	2006-09-16 20:15:00	t
1082	234	234	2006-09-16 19:56:27	2006-09-16 20:15:00	t
1076	299	234	2006-09-16 19:30:00	2006-09-16 19:30:00	t
1066	284	233	2006-09-16 11:00:00	2006-09-16 11:00:00	t
1068	54	233	2006-09-16 11:30:58	2006-09-16 11:33:10	t
1096	140	236	2006-09-17 19:30:00	2006-09-17 20:32:42	t
1102	280	236	2006-09-17 19:30:00	2006-09-17 21:27:39	t
1100	175	236	2006-09-17 19:30:00	2006-09-17 19:30:00	t
985	272	226	2006-09-09 22:56:27	2006-09-09 23:15:00	f
1094	234	236	2006-09-17 19:30:00	2006-09-17 20:22:22	t
1098	257	236	2006-09-17 19:30:00	2006-09-17 19:30:00	t
982	288	226	2006-09-09 20:30:00	2006-09-09 20:30:00	f
1106	282	236	2006-09-17 20:29:48	2006-09-17 21:24:18	t
1104	152	236	2006-09-17 19:34:35	2006-09-17 21:34:35	t
1482	40	263	2006-10-14 11:00:27	2006-10-14 13:05:26	t
1190	284	241	2006-09-23 19:30:00	2006-09-23 19:30:00	f
1510	152	265	2006-10-14 21:00:00	2006-10-14 21:18:09	t
945	288	223	2006-09-07 21:00:00	2006-09-07 22:30:06	t
951	55	223	2006-09-07 21:08:07	2006-09-07 23:08:07	t
952	287	223	2006-09-07 21:09:56	2006-09-07 23:09:56	t
953	123	223	2006-09-07 21:20:33	2006-09-07 23:20:33	t
946	155	223	2006-09-07 21:00:00	2006-09-07 22:30:38	t
947	257	223	2006-09-07 21:00:00	2006-09-07 22:39:48	t
949	148	223	2006-09-07 21:00:00	2006-09-07 22:56:56	t
942	258	223	2006-09-07 21:00:00	2006-09-07 23:46:18	t
956	243	223	2006-09-07 22:17:32	2006-09-08 00:17:32	t
941	283	223	2006-09-07 21:00:00	2006-09-08 00:30:00	t
954	272	223	2006-09-07 21:23:00	2006-09-08 00:30:00	t
948	244	223	2006-09-07 21:00:00	2006-09-08 00:10:51	t
950	81	223	2006-09-07 21:02:11	2006-09-08 00:18:28	t
957	142	223	2006-09-07 23:06:02	2006-09-07 23:31:46	t
943	103	223	2006-09-07 21:00:00	2006-09-07 21:00:00	t
944	222	223	2006-09-07 21:00:00	2006-09-07 22:04:14	t
955	61	223	2006-09-07 22:03:38	2006-09-07 22:56:42	t
1086	243	235	2006-09-16 20:45:00	2006-09-16 20:52:09	t
1080	280	235	2006-09-16 20:45:00	2006-09-16 20:45:00	t
1054	299	232	2006-09-14 21:01:16	2006-09-14 23:01:16	t
1058	257	232	2006-09-14 21:48:44	2006-09-14 23:48:44	t
1052	152	232	2006-09-14 21:00:00	2006-09-14 22:50:59	t
1050	283	232	2006-09-14 21:00:00	2006-09-15 00:40:00	t
1064	299	232	2006-09-14 23:55:00	2006-09-15 00:40:00	t
975	275	226	2006-09-09 20:30:00	2006-09-09 20:30:00	f
983	235	226	2006-09-09 21:22:55	2006-09-09 21:44:53	f
969	123	226	2006-09-09 20:30:00	2006-09-09 20:30:00	f
984	119	226	2006-09-09 22:15:21	2006-09-09 22:16:14	f
971	170	226	2006-09-09 20:30:00	2006-09-09 20:30:00	f
978	283	226	2006-09-09 20:30:00	2006-09-09 20:30:00	f
1048	284	232	2006-09-14 21:00:00	2006-09-15 00:19:42	t
1060	284	232	2006-09-14 22:57:25	2006-09-15 00:19:42	t
1018	170	230	2006-09-12 21:00:00	2006-09-12 22:29:44	t
1020	155	230	2006-09-12 21:00:00	2006-09-12 22:31:17	t
1026	81	230	2006-09-12 21:00:00	2006-09-12 22:43:16	t
1032	55	230	2006-09-12 21:00:00	2006-09-12 22:59:59	t
1036	170	230	2006-09-12 22:33:01	2006-09-12 23:50:00	t
1038	284	230	2006-09-12 23:08:51	2006-09-12 23:50:00	t
1040	45	230	2006-09-12 23:31:33	2006-09-12 23:50:00	t
1022	244	230	2006-09-12 21:00:00	2006-09-12 21:00:00	t
1028	230	230	2006-09-12 21:00:00	2006-09-12 21:56:02	t
1030	258	230	2006-09-12 21:00:00	2006-09-12 22:43:15	t
960	258	229	2006-09-09 11:40:39	2006-09-09 13:02:37	f
1024	222	230	2006-09-12 21:00:00	2006-09-12 22:43:11	t
1044	175	232	2006-09-14 21:00:00	2006-09-14 21:00:00	t
1046	244	232	2006-09-14 21:00:00	2006-09-14 21:00:00	t
998	249	227	2006-09-10 20:27:00	2006-09-10 22:27:00	f
1062	258	232	2006-09-14 23:13:26	2006-09-15 00:19:04	t
1056	61	232	2006-09-14 21:39:55	2006-09-14 23:52:10	t
1084	234	235	2006-09-16 20:45:00	2006-09-16 20:45:00	t
980	5	225	2006-09-09 19:59:37	2006-09-09 20:15:00	f
1088	221	235	2006-09-16 22:03:27	2006-09-16 22:51:56	t
1318	248	252	2006-10-02 21:00:00	2006-10-02 21:27:19	t
1324	200	252	2006-10-02 22:51:54	2006-10-02 23:45:00	t
979	249	225	2006-09-09 19:45:00	2006-09-09 20:15:00	f
1257	160	247	2006-09-28 21:56:47	2006-09-28 22:50:00	t
977	284	225	2006-09-09 19:45:00	2006-09-09 19:45:00	f
976	275	225	2006-09-09 19:45:00	2006-09-09 19:45:00	f
968	123	225	2006-09-09 19:45:00	2006-09-09 19:45:00	f
973	257	225	2006-09-09 19:45:00	2006-09-09 19:45:00	f
1231	308	244	2006-09-25 21:52:37	2006-09-25 23:52:37	t
1187	257	241	2006-09-23 19:30:00	2006-09-23 19:30:00	f
1225	283	244	2006-09-25 21:00:00	2006-09-26 00:00:00	t
1234	76	244	2006-09-25 22:42:06	2006-09-26 00:00:00	t
1237	152	244	2006-09-25 23:56:26	2006-09-26 00:00:00	t
1205	301	242	2006-09-23 21:20:43	2006-09-23 22:02:33	f
1202	175	242	2006-09-23 21:00:00	2006-09-23 21:00:00	f
1199	170	242	2006-09-23 21:00:00	2006-09-23 21:00:00	f
1196	267	242	2006-09-23 21:00:00	2006-09-23 21:00:00	f
1254	170	247	2006-09-28 21:00:00	2006-09-28 21:00:00	t
1551	207	270	2006-10-16 21:00:00	2006-10-16 21:23:30	t
1004	230	228	2006-09-11 21:00:00	2006-09-11 21:58:24	t
1012	150	228	2006-09-11 21:12:21	2006-09-11 22:00:00	t
1013	61	228	2006-09-11 21:47:27	2006-09-11 22:00:00	t
1010	188	228	2006-09-11 21:00:00	2006-09-11 22:00:00	t
1003	272	228	2006-09-11 21:00:00	2006-09-11 22:00:00	t
1008	123	228	2006-09-11 21:00:00	2006-09-11 22:00:00	t
1005	283	228	2006-09-11 21:00:00	2006-09-11 22:00:00	t
1009	244	228	2006-09-11 21:00:00	2006-09-11 21:00:17	t
1007	258	228	2006-09-11 21:00:00	2006-09-11 21:01:32	t
1011	39	228	2006-09-11 21:12:16	2006-09-11 21:17:12	t
1006	103	228	2006-09-11 21:00:00	2006-09-11 21:02:15	t
1834	66	296	2006-11-09 19:08:08	2006-11-09 21:08:08	f
1429	317	260	2006-10-09 21:00:00	2006-10-09 21:05:02	t
1446	279	261	2006-10-10 21:00:00	2006-10-10 21:04:16	t
1179	136	240	2006-09-23 13:51:09	2006-09-23 14:42:39	t
1451	59	261	2006-10-10 21:00:00	2006-10-10 22:23:13	t
1321	275	252	2006-10-02 21:40:49	2006-10-02 21:46:02	t
1014	188	231	2006-09-11 22:30:00	2006-09-12 00:15:00	t
1015	284	231	2006-09-11 22:34:31	2006-09-12 00:15:00	t
1083	249	234	2006-09-16 19:57:08	2006-09-16 20:15:00	t
1260	142	247	2006-09-28 22:47:54	2006-09-28 22:49:27	t
1270	76	248	2006-09-30 14:32:55	2006-09-30 14:40:00	f
1258	221	247	2006-09-28 21:57:17	2006-09-28 22:50:00	t
1255	206	247	2006-09-28 21:00:00	2006-09-28 21:00:00	t
1101	301	236	2006-09-17 19:30:00	2006-09-17 21:17:18	t
1093	238	236	2006-09-17 19:30:00	2006-09-17 21:27:33	t
1079	280	234	2006-09-16 19:47:19	2006-09-16 19:53:15	t
1075	170	234	2006-09-16 19:30:00	2006-09-16 19:30:00	t
1107	52	236	2006-09-17 21:21:25	2006-09-17 22:00:00	t
1108	249	236	2006-09-17 21:23:43	2006-09-17 22:00:00	t
1097	123	236	2006-09-17 19:30:00	2006-09-17 19:30:00	t
1065	123	233	2006-09-16 11:00:00	2006-09-16 11:05:58	t
1073	240	233	2006-09-16 15:05:43	2006-09-16 15:30:00	t
1067	299	233	2006-09-16 11:00:00	2006-09-16 11:00:00	t
1069	270	233	2006-09-16 12:30:52	2006-09-16 13:41:49	t
1095	299	236	2006-09-17 19:30:00	2006-09-17 19:30:00	t
1047	230	232	2006-09-14 21:00:00	2006-09-14 22:26:01	t
1049	155	232	2006-09-14 21:00:00	2006-09-14 22:32:17	t
1043	123	232	2006-09-14 21:00:00	2006-09-14 23:11:31	t
1019	288	230	2006-09-12 21:00:00	2006-09-12 22:30:14	t
1021	284	230	2006-09-12 21:00:00	2006-09-12 22:31:39	t
1025	234	230	2006-09-12 21:00:00	2006-09-12 22:38:46	t
1027	257	230	2006-09-12 21:00:00	2006-09-12 22:46:42	t
1023	283	230	2006-09-12 21:00:00	2006-09-12 23:50:00	t
1035	272	230	2006-09-12 21:54:55	2006-09-12 23:50:00	t
1039	55	230	2006-09-12 23:17:39	2006-09-12 23:50:00	t
1033	287	230	2006-09-12 21:16:58	2006-09-12 23:16:58	t
1041	257	230	2006-09-12 23:46:24	2006-09-12 23:50:00	t
1029	206	230	2006-09-12 21:00:00	2006-09-12 21:00:00	t
1037	222	230	2006-09-12 22:41:01	2006-09-12 22:43:11	t
1031	61	230	2006-09-12 21:00:00	2006-09-12 21:16:40	t
1055	132	232	2006-09-14 21:10:31	2006-09-14 23:11:07	t
1057	222	232	2006-09-14 21:40:07	2006-09-14 23:40:07	t
1059	234	232	2006-09-14 21:51:36	2006-09-14 23:51:36	t
1051	243	232	2006-09-14 21:00:00	2006-09-15 00:40:00	t
1053	44	232	2006-09-14 21:00:00	2006-09-15 00:40:00	t
1045	170	232	2006-09-14 21:00:00	2006-09-15 00:20:45	t
1061	170	232	2006-09-14 23:05:19	2006-09-15 00:20:45	t
1063	43	232	2006-09-14 23:35:17	2006-09-15 00:15:28	t
1099	170	236	2006-09-17 19:30:00	2006-09-17 19:30:00	t
1103	293	236	2006-09-17 19:32:23	2006-09-17 21:32:23	t
1105	281	236	2006-09-17 19:35:10	2006-09-17 21:35:10	t
1211	170	243	2006-09-24 19:30:00	2006-09-24 20:45:52	t
1087	52	235	2006-09-16 21:26:15	2006-09-16 23:26:15	t
1085	284	235	2006-09-16 20:45:00	2006-09-16 20:45:00	t
1077	299	235	2006-09-16 20:45:00	2006-09-16 20:45:00	t
1081	170	235	2006-09-16 20:45:00	2006-09-16 20:45:00	t
1209	275	243	2006-09-24 19:30:00	2006-09-24 19:30:00	t
1130	303	238	2006-09-19 21:00:00	2006-09-19 21:42:35	t
1134	222	238	2006-09-19 21:00:00	2006-09-19 22:35:33	t
1136	284	238	2006-09-19 21:00:00	2006-09-19 22:38:35	t
1138	257	238	2006-09-19 21:00:00	2006-09-19 22:41:55	t
1142	155	238	2006-09-19 21:24:49	2006-09-19 23:24:49	t
1144	152	238	2006-09-19 21:58:16	2006-09-19 23:58:16	t
1133	283	238	2006-09-19 21:00:00	2006-09-20 00:15:00	t
1116	170	237	2006-09-18 21:00:00	2006-09-18 22:40:02	t
1113	283	237	2006-09-18 21:00:00	2006-09-19 00:15:00	t
1123	284	237	2006-09-18 22:18:42	2006-09-19 00:15:00	t
1119	188	237	2006-09-18 21:21:07	2006-09-19 00:15:00	t
1126	288	237	2006-09-18 23:02:43	2006-09-19 00:15:00	t
1127	170	237	2006-09-18 23:30:00	2006-09-19 00:15:00	t
1124	13	237	2006-09-18 22:24:06	2006-09-18 22:57:34	t
1122	15	237	2006-09-18 21:57:52	2006-09-18 23:09:38	t
1135	234	238	2006-09-19 21:00:00	2006-09-19 22:37:55	t
1146	284	238	2006-09-19 22:51:34	2006-09-20 00:15:00	t
1147	132	238	2006-09-19 23:32:53	2006-09-20 00:15:00	t
1125	19	237	2006-09-18 22:37:50	2006-09-18 22:48:09	t
1114	244	237	2006-09-18 21:00:00	2006-09-18 21:00:00	t
1141	150	238	2006-09-19 21:21:58	2006-09-20 00:15:00	t
1111	299	237	2006-09-18 21:00:00	2006-09-18 21:00:00	t
1118	258	237	2006-09-18 21:18:10	2006-09-18 21:56:47	t
1132	175	238	2006-09-19 21:00:00	2006-09-19 21:00:00	t
1137	244	238	2006-09-19 21:00:00	2006-09-19 21:00:00	t
1120	61	237	2006-09-18 21:48:55	2006-09-18 22:53:02	t
1112	167	237	2006-09-18 21:00:00	2006-09-18 21:00:00	t
1121	152	237	2006-09-18 21:57:48	2006-09-18 23:57:48	t
1203	26	242	2006-09-23 21:02:12	2006-09-23 23:08:50	f
1143	299	238	2006-09-19 21:50:14	2006-09-19 23:28:27	t
1148	272	238	2006-09-19 23:34:06	2006-09-19 23:45:09	t
1140	258	238	2006-09-19 21:17:10	2006-09-19 23:28:29	t
1131	170	238	2006-09-19 21:00:00	2006-09-19 21:00:00	t
1139	269	238	2006-09-19 21:00:31	2006-09-19 23:00:31	t
1145	81	238	2006-09-19 22:04:58	2006-09-20 00:04:58	t
1185	275	241	2006-09-23 19:30:00	2006-09-23 20:15:00	f
1213	234	243	2006-09-24 19:30:00	2006-09-24 19:30:00	t
1200	156	241	2006-09-23 19:31:26	2006-09-23 20:15:00	f
1194	217	241	2006-09-23 19:30:00	2006-09-23 19:30:00	f
1188	170	241	2006-09-23 19:30:00	2006-09-23 19:30:00	f
1814	7	294	2006-11-05 19:30:00	2006-11-05 21:16:37	t
1322	299	252	2006-10-02 21:54:52	2006-10-02 23:45:00	t
1197	217	242	2006-09-23 21:00:00	2006-09-23 21:00:00	f
1191	188	242	2006-09-23 21:00:00	2006-09-23 21:00:00	f
1488	118	263	2006-10-14 12:33:13	2006-10-14 14:33:13	t
1288	152	250	2006-09-30 20:40:33	2006-09-30 22:40:33	f
1606	152	273	2006-10-19 22:41:24	2006-10-19 23:30:00	f
1319	285	252	2006-10-02 21:04:44	2006-10-02 21:04:56	t
1775	325	290	2006-11-02 21:02:25	2006-11-02 23:02:25	t
1310	308	251	2006-10-01 19:47:07	2006-10-01 21:47:07	f
1835	143	296	2006-11-09 19:08:41	2006-11-09 21:08:41	f
1430	279	260	2006-10-09 21:00:00	2006-10-09 21:34:58	t
1725	123	285	2006-10-29 19:30:00	2006-10-29 20:37:51	t
1157	251	239	2006-09-21 21:00:00	2006-09-21 22:32:09	t
1149	234	239	2006-09-21 21:00:00	2006-09-21 22:46:58	t
1159	217	239	2006-09-21 21:00:00	2006-09-21 22:50:56	t
1151	299	239	2006-09-21 21:00:00	2006-09-22 00:30:00	t
1169	188	239	2006-09-21 23:10:42	2006-09-22 00:30:00	t
1161	175	239	2006-09-21 21:09:55	2006-09-21 21:18:43	t
1165	16	239	2006-09-21 22:12:38	2006-09-21 23:18:39	t
1171	19	239	2006-09-21 23:14:46	2006-09-21 23:43:23	t
1153	244	239	2006-09-21 21:00:00	2006-09-21 21:00:00	t
1160	44	239	2006-09-21 21:09:41	2006-09-21 21:11:27	t
1162	223	239	2006-09-21 21:11:49	2006-09-21 23:11:49	t
1156	288	239	2006-09-21 21:00:00	2006-09-21 22:29:58	t
1158	155	239	2006-09-21 21:00:00	2006-09-21 22:34:28	t
1163	171	239	2006-09-21 21:19:08	2006-09-22 00:30:00	t
1173	132	239	2006-09-21 23:56:41	2006-09-22 00:30:00	t
1164	222	239	2006-09-21 21:54:07	2006-09-22 00:30:00	t
1155	284	239	2006-09-21 21:00:00	2006-09-22 00:30:00	t
1152	257	239	2006-09-21 21:00:00	2006-09-21 21:00:00	t
1150	170	239	2006-09-21 21:00:00	2006-09-21 21:00:00	t
1172	45	239	2006-09-21 23:40:15	2006-09-22 00:00:15	t
1168	142	239	2006-09-21 22:53:18	2006-09-21 23:10:30	t
1154	283	239	2006-09-21 21:00:00	2006-09-21 21:00:00	t
1844	154	297	2006-11-11 12:42:03	2006-11-11 14:42:03	f
1484	322	263	2006-10-14 11:22:55	2006-10-14 13:22:55	t
1259	275	247	2006-09-28 22:14:42	2006-09-28 22:50:00	t
1180	82	240	2006-09-23 14:39:35	2006-09-23 15:55:00	t
1177	284	240	2006-09-23 11:00:00	2006-09-23 11:00:00	t
1256	284	247	2006-09-28 21:00:00	2006-09-28 21:00:00	t
1607	170	273	2006-10-19 22:57:55	2006-10-19 23:30:00	f
1447	123	261	2006-10-10 21:00:00	2006-10-10 22:12:44	t
1192	267	241	2006-09-23 19:30:00	2006-09-23 20:15:00	f
1575	326	271	2006-10-17 21:00:00	2006-10-17 22:33:00	t
1571	118	271	2006-10-17 21:00:00	2006-10-17 21:00:00	t
1755	78	288	2006-10-30 21:00:00	2006-10-30 22:33:52	f
1464	308	261	2006-10-10 23:02:34	2006-10-11 00:25:00	t
1452	284	261	2006-10-10 21:00:00	2006-10-10 21:00:00	t
1323	59	252	2006-10-02 22:48:51	2006-10-02 23:45:00	t
1204	152	242	2006-09-23 21:05:02	2006-09-23 23:05:02	f
1195	270	241	2006-09-23 19:30:00	2006-09-23 19:30:00	f
1198	296	241	2006-09-23 19:30:00	2006-09-23 19:30:00	f
1189	188	241	2006-09-23 19:30:00	2006-09-23 19:30:00	f
1320	170	252	2006-10-02 21:21:06	2006-10-02 21:22:30	t
1221	152	243	2006-09-24 21:23:31	2006-09-24 23:15:00	t
1186	275	242	2006-09-23 21:00:00	2006-09-23 21:00:00	f
1201	286	242	2006-09-23 21:00:00	2006-09-23 21:00:00	f
1273	75	249	2006-09-30 19:30:00	2006-09-30 19:45:42	f
1317	75	252	2006-10-02 21:00:00	2006-10-02 21:06:33	t
1460	318	261	2006-10-10 21:25:43	2006-10-10 23:43:33	t
1239	152	246	2006-09-26 21:00:00	2006-09-26 21:46:11	t
1241	257	246	2006-09-26 21:00:00	2006-09-26 22:30:22	t
1215	56	243	2006-09-24 19:47:10	2006-09-24 23:15:00	t
1244	217	246	2006-09-26 21:00:00	2006-09-26 22:37:56	t
1214	301	243	2006-09-24 19:30:00	2006-09-24 19:30:00	t
1245	26	246	2006-09-26 21:00:00	2006-09-26 22:41:49	t
1247	155	246	2006-09-26 21:00:00	2006-09-26 22:54:10	t
1242	222	246	2006-09-26 21:00:00	2006-09-27 00:01:04	t
1210	257	243	2006-09-24 19:30:00	2006-09-24 19:30:00	t
1217	150	243	2006-09-24 20:09:42	2006-09-24 22:15:13	t
1212	267	243	2006-09-24 19:30:00	2006-09-24 19:30:47	t
1216	248	243	2006-09-24 20:01:53	2006-09-24 22:01:53	t
1218	308	243	2006-09-24 20:30:51	2006-09-24 22:30:51	t
1243	284	246	2006-09-26 21:00:00	2006-09-27 00:30:00	t
1240	283	246	2006-09-26 21:00:00	2006-09-27 00:30:00	t
1253	275	246	2006-09-26 23:17:26	2006-09-27 00:30:00	t
1251	16	246	2006-09-26 22:47:05	2006-09-26 23:14:18	t
1238	170	246	2006-09-26 21:00:00	2006-09-26 23:42:57	t
1248	170	246	2006-09-26 21:39:05	2006-09-26 23:42:57	t
1252	51	246	2006-09-26 22:49:32	2006-09-26 23:10:08	t
1228	55	244	2006-09-25 21:00:00	2006-09-25 21:00:00	t
1223	165	244	2006-09-25 21:00:00	2006-09-25 21:48:29	t
1235	188	244	2006-09-25 22:46:07	2006-09-26 00:00:00	t
1232	275	244	2006-09-25 22:07:39	2006-09-26 00:00:00	t
1229	5	244	2006-09-25 21:07:51	2006-09-25 22:49:43	t
1230	123	244	2006-09-25 21:11:26	2006-09-25 23:11:26	t
1224	26	244	2006-09-25 21:00:00	2006-09-25 22:56:25	t
1236	26	244	2006-09-25 23:11:18	2006-09-26 00:00:00	t
1226	230	244	2006-09-25 21:00:00	2006-09-25 23:04:41	t
1233	257	244	2006-09-25 22:08:49	2006-09-25 23:33:02	t
1227	167	244	2006-09-25 21:00:00	2006-09-25 21:00:00	t
1456	322	261	2006-10-10 21:01:59	2006-10-11 00:18:57	t
1691	103	282	2006-10-28 11:12:59	2006-10-28 14:10:55	f
1250	116	246	2006-09-26 22:26:23	2006-09-26 22:37:15	t
1284	275	249	2006-09-30 19:57:44	2006-09-30 20:00:00	f
1246	251	246	2006-09-26 21:00:00	2006-09-26 21:00:00	t
1249	221	246	2006-09-26 22:08:09	2006-09-26 23:15:05	t
1748	220	288	2006-10-30 21:00:00	2006-10-30 21:00:00	f
1278	284	249	2006-09-30 19:30:00	2006-09-30 20:00:00	f
1579	59	271	2006-10-17 21:00:00	2006-10-17 23:54:30	t
1749	293	288	2006-10-30 21:00:00	2006-10-30 21:00:00	f
2014	78	311	2006-11-25 11:47:43	2006-11-25 13:47:43	f
1280	267	249	2006-09-30 19:30:00	2006-09-30 20:00:00	f
1276	238	249	2006-09-30 19:30:00	2006-09-30 19:30:00	f
1279	257	249	2006-09-30 19:30:00	2006-09-30 19:30:00	f
1275	170	249	2006-09-30 19:30:00	2006-09-30 19:30:00	f
1277	308	249	2006-09-30 19:30:00	2006-09-30 19:30:00	f
1281	267	250	2006-09-30 20:30:00	2006-09-30 21:11:58	f
1287	262	250	2006-09-30 20:30:00	2006-09-30 22:17:24	f
1564	13	270	2006-10-16 23:14:03	2006-10-16 23:26:32	t
1621	325	277	2006-10-22 19:30:46	2006-10-22 20:30:00	t
1622	234	277	2006-10-22 19:33:48	2006-10-22 20:30:00	t
1505	284	264	2006-10-14 19:30:00	2006-10-14 19:30:00	f
1502	275	264	2006-10-14 19:30:00	2006-10-14 19:30:00	f
1308	76	251	2006-10-01 19:30:00	2006-10-01 21:19:16	f
1493	75	264	2006-10-14 19:30:00	2006-10-14 19:33:20	f
1293	240	250	2006-09-30 22:40:44	2006-09-30 23:30:00	f
1285	275	250	2006-09-30 20:30:00	2006-09-30 20:30:00	f
1291	235	250	2006-09-30 21:55:59	2006-09-30 22:52:28	f
1282	280	250	2006-09-30 20:30:00	2006-09-30 20:30:00	f
1283	170	250	2006-09-30 20:30:00	2006-09-30 20:30:00	f
1286	75	250	2006-09-30 20:30:00	2006-09-30 20:30:00	f
1289	63	250	2006-09-30 21:15:35	2006-09-30 21:20:52	f
1626	5	277	2006-10-22 20:25:11	2006-10-22 20:30:00	t
1552	170	270	2006-10-16 21:00:00	2006-10-16 21:00:00	t
1307	156	251	2006-10-01 19:30:00	2006-10-01 21:18:14	f
1299	170	251	2006-10-01 19:30:00	2006-10-01 21:57:20	f
1662	86	280	2006-10-24 21:19:36	2006-10-24 23:19:36	t
1836	328	296	2006-11-09 20:25:17	2006-11-09 22:25:17	f
1497	217	264	2006-10-14 19:30:00	2006-10-14 19:32:46	f
1311	160	251	2006-10-01 20:14:25	2006-10-01 22:00:00	f
1783	66	291	2006-11-04 14:48:17	2006-11-04 15:20:00	t
1309	44	251	2006-10-01 19:33:40	2006-10-01 22:00:00	f
1306	283	251	2006-10-01 19:30:00	2006-10-01 22:00:00	f
1301	284	251	2006-10-01 19:30:00	2006-10-01 22:00:00	f
1300	287	251	2006-10-01 19:30:00	2006-10-01 22:00:00	f
1305	230	251	2006-10-01 19:30:00	2006-10-01 19:30:00	f
1304	257	251	2006-10-01 19:30:00	2006-10-01 19:30:00	f
1302	155	251	2006-10-01 19:30:00	2006-10-01 20:28:47	f
1303	222	251	2006-10-01 19:30:00	2006-10-01 19:30:00	f
1312	52	251	2006-10-01 20:36:25	2006-10-01 21:29:44	f
1298	118	251	2006-10-01 19:30:00	2006-10-01 19:30:00	f
1297	251	251	2006-10-01 19:30:00	2006-10-01 19:30:00	f
1500	213	264	2006-10-14 19:30:00	2006-10-14 20:10:00	f
1779	51	291	2006-11-04 12:07:29	2006-11-04 12:31:13	t
1688	156	282	2006-10-28 11:00:14	2006-10-28 13:00:14	f
1363	31	256	2006-10-07 12:44:56	2006-10-07 14:25:47	f
1480	267	263	2006-10-14 11:00:00	2006-10-14 11:00:00	t
1485	160	263	2006-10-14 11:30:48	2006-10-14 14:47:17	t
1660	322	280	2006-10-24 21:00:00	2006-10-24 22:43:35	t
1598	284	273	2006-10-19 21:00:00	2006-10-19 21:00:00	f
1450	170	261	2006-10-10 21:00:00	2006-10-10 22:21:59	t
1459	277	261	2006-10-10 21:09:57	2006-10-10 23:09:57	t
1463	316	261	2006-10-10 23:02:13	2006-10-11 00:25:00	t
1461	31	261	2006-10-10 22:06:28	2006-10-11 00:06:28	t
1455	275	261	2006-10-10 21:00:00	2006-10-11 00:25:00	t
1457	2	261	2006-10-10 21:05:20	2006-10-10 22:08:19	t
1453	34	261	2006-10-10 21:00:00	2006-10-10 21:00:00	t
1393	164	258	2006-10-07 21:01:08	2006-10-07 23:01:08	f
1395	223	258	2006-10-07 21:36:39	2006-10-07 23:36:39	f
1448	257	261	2006-10-10 21:00:00	2006-10-10 21:00:00	t
1650	257	280	2006-10-24 21:00:00	2006-10-24 21:00:00	t
1623	316	277	2006-10-22 19:40:55	2006-10-22 20:30:00	t
1655	155	280	2006-10-24 21:00:00	2006-10-24 22:24:46	t
1635	332	279	2006-10-23 21:00:00	2006-10-23 22:27:11	t
1638	200	279	2006-10-23 21:00:00	2006-10-23 21:00:00	t
1613	2	274	2006-10-21 11:49:05	2006-10-21 13:49:05	t
1612	284	274	2006-10-21 11:00:00	2006-10-21 11:00:00	t
1611	319	274	2006-10-21 11:00:00	2006-10-21 11:00:00	t
1692	322	282	2006-10-28 12:44:06	2006-10-28 14:44:06	f
1771	319	290	2006-11-02 21:00:00	2006-11-02 21:00:00	t
1699	316	282	2006-10-28 13:44:25	2006-10-28 15:44:25	f
1754	52	288	2006-10-30 21:00:00	2006-10-30 21:00:00	f
1391	152	258	2006-10-07 20:40:00	2006-10-07 22:32:18	f
1396	320	258	2006-10-07 22:32:53	2006-10-08 00:00:00	f
1325	275	254	2006-10-03 21:00:00	2006-10-03 21:19:08	t
1330	217	254	2006-10-03 21:00:00	2006-10-03 22:44:59	t
1332	152	254	2006-10-03 21:00:00	2006-10-03 22:53:06	t
1331	283	254	2006-10-03 21:00:00	2006-10-04 00:30:00	t
1339	156	254	2006-10-03 23:00:41	2006-10-04 00:30:00	t
1335	170	254	2006-10-03 21:36:27	2006-10-03 23:36:27	t
1336	282	254	2006-10-03 21:57:49	2006-10-03 23:57:49	t
1337	275	254	2006-10-03 21:58:20	2006-10-03 23:58:20	t
1341	275	254	2006-10-04 00:01:07	2006-10-04 00:30:00	t
1338	75	254	2006-10-03 22:26:36	2006-10-04 00:26:36	t
1329	284	254	2006-10-03 21:00:00	2006-10-04 00:15:23	t
1340	284	254	2006-10-03 23:10:44	2006-10-04 00:15:23	t
1333	230	254	2006-10-03 21:12:27	2006-10-03 22:58:09	t
1334	29	254	2006-10-03 21:31:49	2006-10-03 22:55:18	t
1326	257	254	2006-10-03 21:00:00	2006-10-04 00:02:14	t
1327	270	254	2006-10-03 21:00:00	2006-10-03 21:00:00	t
1328	222	254	2006-10-03 21:00:00	2006-10-03 23:12:33	t
1398	315	258	2006-10-07 23:26:32	2006-10-08 00:00:00	f
1750	307	288	2006-10-30 21:00:00	2006-10-30 21:00:00	f
1404	296	259	2006-10-08 19:30:00	2006-10-08 19:48:50	t
1390	287	258	2006-10-07 20:40:00	2006-10-07 20:40:00	f
1381	275	258	2006-10-07 20:40:00	2006-10-07 20:40:00	f
1387	217	258	2006-10-07 20:40:00	2006-10-07 20:40:00	f
1392	238	258	2006-10-07 20:40:00	2006-10-07 20:40:00	f
1389	26	258	2006-10-07 20:40:00	2006-10-07 20:40:00	f
1374	279	258	2006-10-07 20:40:00	2006-10-07 20:40:00	f
1377	267	258	2006-10-07 20:40:00	2006-10-07 20:40:00	f
1382	75	258	2006-10-07 20:40:00	2006-10-07 20:40:00	f
1411	59	259	2006-10-08 19:30:00	2006-10-08 21:17:46	t
1644	335	279	2006-10-23 21:03:42	2006-10-23 21:06:20	t
1641	293	279	2006-10-23 21:00:00	2006-10-23 21:00:00	t
1632	316	279	2006-10-23 21:00:00	2006-10-23 21:00:00	t
1756	152	288	2006-10-30 21:00:00	2006-10-30 21:00:00	f
1568	331	271	2006-10-17 21:00:00	2006-10-17 22:03:42	t
1576	328	271	2006-10-17 21:00:00	2006-10-18 00:10:20	t
1587	206	271	2006-10-17 21:55:28	2006-10-17 22:35:07	t
1559	325	270	2006-10-16 21:00:00	2006-10-16 23:21:59	t
1553	118	270	2006-10-16 21:00:00	2006-10-16 21:00:00	t
1565	123	271	2006-10-17 21:00:00	2006-10-17 21:00:00	t
1514	52	265	2006-10-14 22:41:12	2006-10-15 00:41:12	t
1409	284	259	2006-10-08 19:30:00	2006-10-08 19:30:00	t
1420	2	259	2006-10-08 21:07:40	2006-10-08 21:25:30	t
1418	26	259	2006-10-08 20:31:31	2006-10-08 21:37:42	t
1412	230	259	2006-10-08 19:30:00	2006-10-08 19:33:47	t
1410	234	259	2006-10-08 19:30:00	2006-10-08 19:30:00	t
1407	257	259	2006-10-08 19:30:00	2006-10-08 19:30:00	t
1408	300	259	2006-10-08 19:30:00	2006-10-08 19:30:00	t
1406	222	259	2006-10-08 19:30:00	2006-10-08 19:30:00	t
1415	277	259	2006-10-08 20:15:33	2006-10-08 22:15:33	t
1416	318	259	2006-10-08 20:16:02	2006-10-08 22:16:02	t
1417	75	259	2006-10-08 20:21:52	2006-10-08 22:21:52	t
1419	275	259	2006-10-08 20:48:24	2006-10-08 22:48:24	t
1413	217	259	2006-10-08 19:46:01	2006-10-08 21:35:11	t
1508	318	265	2006-10-14 21:00:00	2006-10-14 21:00:00	t
1405	267	259	2006-10-08 19:30:00	2006-10-08 23:00:00	t
1421	5	259	2006-10-08 22:06:57	2006-10-08 23:00:00	t
1511	170	265	2006-10-14 21:00:00	2006-10-14 21:00:00	t
1503	188	265	2006-10-14 21:00:00	2006-10-14 21:00:00	t
1572	325	271	2006-10-17 21:00:00	2006-10-17 23:56:10	t
1584	148	271	2006-10-17 21:12:57	2006-10-17 23:12:57	t
1530	308	266	2006-10-15 19:37:40	2006-10-15 20:10:00	t
1518	59	266	2006-10-15 19:30:00	2006-10-15 20:10:00	t
1522	322	266	2006-10-15 19:30:00	2006-10-15 20:10:00	t
1526	267	266	2006-10-15 19:30:00	2006-10-15 20:10:00	t
1580	51	271	2006-10-17 21:00:00	2006-10-17 21:00:00	t
1589	132	271	2006-10-17 22:45:14	2006-10-18 00:12:06	t
2094	359	318	2006-12-02 14:29:26	2006-12-02 16:00:00	f
1663	279	279	2006-10-24 21:19:40	2006-10-24 23:19:40	f
1537	322	268	2006-10-15 20:34:01	2006-10-15 22:34:17	t
1534	155	268	2006-10-15 20:30:00	2006-10-15 22:20:31	t
1540	267	268	2006-10-15 21:07:16	2006-10-15 22:50:00	t
1347	257	255	2006-10-05 21:00:00	2006-10-05 22:17:14	t
1352	315	255	2006-10-05 21:47:34	2006-10-05 23:20:00	t
1356	281	255	2006-10-05 23:08:45	2006-10-05 23:20:00	t
1348	170	255	2006-10-05 21:00:00	2006-10-05 23:20:00	t
1353	155	255	2006-10-05 21:54:14	2006-10-05 23:20:00	t
1355	230	255	2006-10-05 22:13:52	2006-10-05 23:20:00	t
1351	284	255	2006-10-05 21:00:00	2006-10-05 21:00:00	t
1346	26	255	2006-10-05 21:00:00	2006-10-05 21:29:09	t
1350	279	255	2006-10-05 21:00:00	2006-10-05 21:01:36	t
1349	103	255	2006-10-05 21:00:00	2006-10-05 21:00:00	t
1837	76	296	2006-11-09 21:32:05	2006-11-09 23:32:05	f
1784	152	291	2006-11-04 14:51:20	2006-11-04 15:20:00	t
1899	319	302	2006-11-14 21:00:00	2006-11-14 21:00:00	t
1780	2	291	2006-11-04 12:54:53	2006-11-04 14:54:53	t
1727	287	285	2006-10-29 19:30:00	2006-10-29 20:45:00	t
1481	326	263	2006-10-14 11:00:00	2006-10-14 11:00:00	t
1454	325	261	2006-10-10 21:00:00	2006-10-10 22:51:02	t
1462	19	261	2006-10-10 22:37:18	2006-10-10 23:12:41	t
1449	222	261	2006-10-10 21:00:00	2006-10-10 21:00:00	t
1458	315	261	2006-10-10 21:07:36	2006-10-10 23:07:36	t
1386	217	257	2006-10-07 19:47:57	2006-10-07 20:10:00	f
1388	26	257	2006-10-07 20:08:10	2006-10-07 20:10:00	f
1375	267	257	2006-10-07 19:40:00	2006-10-07 20:10:00	f
1594	322	273	2006-10-19 21:00:00	2006-10-19 23:05:36	f
1604	19	273	2006-10-19 22:21:18	2006-10-19 23:30:00	f
1609	188	273	2006-10-19 23:28:59	2006-10-19 23:30:00	f
1599	213	273	2006-10-19 21:00:00	2006-10-19 21:02:08	f
1384	320	257	2006-10-07 19:40:00	2006-10-07 20:10:00	f
1504	267	264	2006-10-14 19:30:00	2006-10-14 20:10:00	f
1689	189	282	2006-10-28 11:00:54	2006-10-28 13:00:54	f
1385	156	257	2006-10-07 19:40:00	2006-10-07 20:10:00	f
1378	284	257	2006-10-07 19:40:00	2006-10-07 19:40:00	f
1380	275	257	2006-10-07 19:40:00	2006-10-07 19:40:00	f
1379	234	257	2006-10-07 19:40:00	2006-10-07 19:40:00	f
1373	170	257	2006-10-07 19:40:00	2006-10-07 19:40:00	f
1376	188	257	2006-10-07 19:40:00	2006-10-07 19:40:00	f
1383	75	257	2006-10-07 19:40:00	2006-10-07 19:40:00	f
1772	118	290	2006-11-02 21:00:00	2006-11-02 21:56:01	t
1661	217	280	2006-10-24 21:00:00	2006-10-24 22:48:21	t
1359	285	256	2006-10-07 11:00:00	2006-10-07 12:37:36	f
1499	170	264	2006-10-14 19:30:00	2006-10-14 19:30:00	f
1624	170	277	2006-10-22 19:42:22	2006-10-22 20:30:00	t
1365	287	256	2006-10-07 13:36:21	2006-10-07 14:45:00	f
1369	188	256	2006-10-07 14:12:02	2006-10-07 14:45:00	f
1366	315	256	2006-10-07 13:55:43	2006-10-07 14:45:00	f
1367	285	256	2006-10-07 13:57:22	2006-10-07 14:45:00	f
1362	275	256	2006-10-07 11:24:48	2006-10-07 12:44:24	f
1364	33	256	2006-10-07 12:45:56	2006-10-07 12:47:58	f
1360	257	256	2006-10-07 11:00:00	2006-10-07 11:00:00	f
1358	317	256	2006-10-07 11:00:00	2006-10-07 11:03:49	f
1619	284	277	2006-10-22 19:30:00	2006-10-22 19:30:34	t
1614	39	274	2006-10-21 12:19:03	2006-10-21 14:19:03	t
1667	42	280	2006-10-24 23:17:28	2006-10-25 00:45:00	t
1656	284	280	2006-10-24 21:00:00	2006-10-24 21:00:00	t
1664	2	280	2006-10-24 21:29:42	2006-10-24 21:32:53	t
1651	293	280	2006-10-24 21:00:00	2006-10-24 23:22:14	t
1639	33	279	2006-10-23 21:00:00	2006-10-23 22:37:35	t
1902	51	302	2006-11-14 21:34:49	2006-11-14 21:44:41	t
1633	287	279	2006-10-23 21:00:00	2006-10-23 21:04:18	t
1636	257	279	2006-10-23 21:00:00	2006-10-23 21:00:00	t
1554	322	270	2006-10-16 21:00:00	2006-10-17 00:12:06	t
1560	240	270	2006-10-16 21:02:52	2006-10-16 23:02:52	t
1550	318	270	2006-10-16 21:00:00	2006-10-16 21:00:00	t
1434	316	260	2006-10-09 21:00:00	2006-10-09 22:37:45	t
1556	152	270	2006-10-16 21:00:00	2006-10-16 21:00:00	t
1557	328	270	2006-10-16 21:00:00	2006-10-16 21:00:00	t
1512	322	265	2006-10-14 21:11:07	2006-10-14 23:11:07	t
1439	248	260	2006-10-09 21:00:00	2006-10-09 22:59:00	t
1427	75	260	2006-10-09 21:00:00	2006-10-09 23:27:40	t
1442	31	260	2006-10-09 22:37:24	2006-10-09 23:35:00	t
1441	275	260	2006-10-09 21:31:17	2006-10-09 23:35:00	t
1435	284	260	2006-10-09 21:00:00	2006-10-09 21:00:00	t
1433	164	260	2006-10-09 21:00:00	2006-10-09 21:00:00	t
1437	299	260	2006-10-09 21:00:00	2006-10-09 21:00:00	t
1431	257	260	2006-10-09 21:00:00	2006-10-09 21:00:00	t
1428	170	260	2006-10-09 21:00:00	2006-10-09 21:00:00	t
1440	315	260	2006-10-09 21:11:01	2006-10-09 23:11:01	t
1438	52	260	2006-10-09 21:00:00	2006-10-09 21:00:00	t
1436	223	260	2006-10-09 21:00:00	2006-10-09 21:00:00	t
1432	308	260	2006-10-09 21:00:00	2006-10-09 21:00:00	t
1515	322	265	2006-10-14 23:14:02	2006-10-15 01:14:02	t
1567	318	271	2006-10-17 21:00:00	2006-10-18 00:23:58	t
1509	267	265	2006-10-14 21:00:00	2006-10-14 21:00:00	t
1581	315	271	2006-10-17 21:01:40	2006-10-17 23:01:40	t
1585	89	271	2006-10-17 21:27:15	2006-10-17 23:27:15	t
1577	284	271	2006-10-17 21:00:00	2006-10-17 23:55:02	t
1590	15	271	2006-10-17 23:15:46	2006-10-18 00:14:19	t
1573	155	271	2006-10-17 21:00:00	2006-10-17 21:00:00	t
1569	222	271	2006-10-17 21:00:00	2006-10-17 21:00:00	t
1642	52	279	2006-10-23 21:00:00	2006-10-23 23:46:51	t
1711	75	283	2006-10-28 19:30:00	2006-10-28 20:15:00	f
1708	316	283	2006-10-28 19:30:00	2006-10-28 19:30:00	f
1826	213	295	2006-11-06 21:00:00	2006-11-06 22:21:22	t
1751	188	288	2006-10-30 21:00:00	2006-10-30 21:00:00	f
1831	314	295	2006-11-06 21:06:14	2006-11-06 21:54:21	t
2076	76	316	2006-11-28 20:30:00	2006-11-28 22:12:47	f
1891	118	301	2006-11-13 21:30:00	2006-11-13 23:09:20	f
2056	354	314	2006-11-26 21:11:37	2006-11-26 23:11:37	f
2085	371	316	2006-11-28 22:15:41	2006-11-28 23:45:00	f
1528	31	266	2006-10-15 19:35:26	2006-10-15 20:10:00	t
1532	160	266	2006-10-15 19:46:06	2006-10-15 20:10:00	t
1529	316	266	2006-10-15 19:37:20	2006-10-15 20:10:00	t
1533	170	266	2006-10-15 19:55:48	2006-10-15 20:10:00	t
1527	296	266	2006-10-15 19:34:31	2006-10-15 20:10:00	t
1531	330	266	2006-10-15 19:45:50	2006-10-15 20:10:00	t
1516	213	266	2006-10-15 19:30:00	2006-10-15 20:10:00	t
1524	155	266	2006-10-15 19:30:00	2006-10-15 20:10:00	t
1517	284	266	2006-10-15 19:30:00	2006-10-15 20:10:00	t
1523	328	266	2006-10-15 19:30:00	2006-10-15 20:10:00	t
1525	217	266	2006-10-15 19:30:00	2006-10-15 20:10:00	t
1519	206	266	2006-10-15 19:30:00	2006-10-15 19:32:33	t
1521	318	266	2006-10-15 19:30:00	2006-10-15 19:30:00	t
1520	222	266	2006-10-15 19:30:00	2006-10-15 19:30:00	t
2081	155	316	2006-11-28 20:39:45	2006-11-28 22:08:14	f
2091	66	318	2006-12-02 12:03:40	2006-12-02 12:38:11	f
1852	326	298	2006-11-11 20:00:00	2006-11-11 20:00:00	f
1897	207	301	2006-11-13 23:43:54	2006-11-14 00:45:00	f
1542	281	268	2006-10-15 21:56:17	2006-10-15 22:50:00	t
1539	5	268	2006-10-15 20:39:32	2006-10-15 21:06:39	t
1536	40	268	2006-10-15 20:30:48	2006-10-15 20:31:36	t
1538	13	268	2006-10-15 20:38:57	2006-10-15 22:38:57	t
1541	164	268	2006-10-15 21:25:12	2006-10-15 22:50:00	t
1535	213	268	2006-10-15 20:30:00	2006-10-15 21:55:57	t
1856	118	299	2006-11-11 21:30:00	2006-11-11 21:52:29	f
2080	284	316	2006-11-28 20:38:54	2006-11-28 20:40:13	f
1827	66	295	2006-11-06 21:00:00	2006-11-06 22:39:14	t
1832	207	295	2006-11-06 23:26:17	2006-11-06 23:55:00	t
1600	59	273	2006-10-19 21:00:00	2006-10-19 22:43:42	f
1690	203	282	2006-10-28 11:01:57	2006-10-28 13:01:57	f
1811	123	294	2006-11-05 19:30:00	2006-11-05 19:31:38	t
1738	86	286	2006-10-29 21:00:45	2006-10-29 22:40:00	f
1741	188	286	2006-10-29 21:17:39	2006-10-29 22:40:00	f
1658	234	280	2006-10-24 21:00:00	2006-10-24 22:37:59	t
1625	334	277	2006-10-22 19:43:09	2006-10-22 20:30:00	t
1620	326	277	2006-10-22 19:30:00	2006-10-22 20:30:00	t
1637	279	279	2006-10-23 21:00:00	2006-10-23 22:29:56	t
1631	334	279	2006-10-23 21:00:00	2006-10-23 22:38:06	t
1646	13	279	2006-10-23 23:10:13	2006-10-24 00:30:00	t
1615	76	274	2006-10-21 13:53:02	2006-10-21 14:35:00	t
1610	213	274	2006-10-21 11:00:00	2006-10-21 11:00:00	t
1578	322	271	2006-10-17 21:00:00	2006-10-17 22:42:37	t
1570	170	271	2006-10-17 21:00:00	2006-10-17 22:46:20	t
1574	213	271	2006-10-17 21:00:00	2006-10-17 23:43:45	t
1555	238	270	2006-10-16 21:00:00	2006-10-16 21:00:00	t
1561	280	270	2006-10-16 21:07:04	2006-10-17 00:07:10	t
1591	284	271	2006-10-17 23:53:06	2006-10-17 23:55:02	t
1566	257	271	2006-10-17 21:00:00	2006-10-17 21:00:00	t
1582	269	271	2006-10-17 21:07:48	2006-10-17 23:07:48	t
1586	330	271	2006-10-17 21:47:31	2006-10-17 23:47:31	t
1588	152	271	2006-10-17 22:24:05	2006-10-18 00:24:05	t
1643	322	279	2006-10-23 21:00:00	2006-10-23 21:06:15	t
1634	213	279	2006-10-23 21:00:00	2006-10-23 21:00:00	t
1649	325	280	2006-10-24 21:00:00	2006-10-24 22:18:24	t
1654	59	280	2006-10-24 21:00:00	2006-10-24 22:32:16	t
1640	274	279	2006-10-23 21:00:00	2006-10-23 21:00:00	t
1659	152	280	2006-10-24 21:00:00	2006-10-24 22:41:45	t
1666	19	280	2006-10-24 22:35:58	2006-10-24 23:14:51	t
1647	334	280	2006-10-24 21:00:00	2006-10-24 22:41:43	t
1648	275	280	2006-10-24 21:00:00	2006-10-24 23:06:08	t
1657	188	280	2006-10-24 21:00:00	2006-10-25 00:45:00	t
1652	123	280	2006-10-24 21:00:00	2006-10-24 21:00:00	t
1769	66	290	2006-11-02 21:00:00	2006-11-02 21:05:07	t
1665	293	280	2006-10-24 22:34:06	2006-10-24 23:22:14	t
1743	78	286	2006-10-29 21:23:24	2006-10-29 22:40:00	f
1745	325	286	2006-10-29 22:24:23	2006-10-29 22:40:00	f
1653	222	280	2006-10-24 21:00:00	2006-10-24 21:00:00	t
1744	1	286	2006-10-29 22:01:59	2006-10-29 22:06:17	f
1737	152	286	2006-10-29 21:00:02	2006-10-29 21:03:53	f
1770	287	290	2006-11-02 21:00:00	2006-11-02 21:23:45	t
1773	152	290	2006-11-02 21:00:00	2006-11-02 22:36:34	t
1758	54	288	2006-10-30 22:00:50	2006-10-30 23:40:00	f
1746	339	288	2006-10-30 21:00:00	2006-10-30 21:00:00	f
1776	316	290	2006-11-02 21:53:33	2006-11-02 22:51:31	t
1815	118	294	2006-11-05 19:30:00	2006-11-05 21:22:12	t
1752	66	288	2006-10-30 21:00:00	2006-10-30 21:00:00	f
1818	42	294	2006-11-05 20:08:12	2006-11-05 21:28:01	t
1820	45	294	2006-11-05 20:38:07	2006-11-05 22:13:45	t
1715	66	283	2006-10-28 19:30:00	2006-10-28 20:15:00	f
1713	328	283	2006-10-28 19:30:00	2006-10-28 19:30:00	f
1710	75	284	2006-10-28 21:00:00	2006-10-28 21:34:43	f
1716	86	284	2006-10-28 21:00:00	2006-10-28 22:13:53	f
1859	319	299	2006-11-11 21:30:00	2006-11-11 21:30:00	f
1842	111	297	2006-11-11 11:30:00	2006-11-11 11:30:00	f
2053	56	314	2006-11-26 19:58:06	2006-11-26 21:58:06	f
1900	222	302	2006-11-14 21:00:00	2006-11-14 21:00:00	t
2057	152	314	2006-11-26 21:28:59	2006-11-26 23:28:59	f
1719	78	284	2006-10-28 21:00:00	2006-10-29 00:30:00	f
1717	325	284	2006-10-28 21:00:00	2006-10-28 21:00:00	f
1720	293	284	2006-10-28 21:36:00	2006-10-28 23:16:13	f
1714	328	284	2006-10-28 21:00:00	2006-10-28 21:00:00	f
1868	154	300	2006-11-12 19:30:00	2006-11-12 21:05:04	f
2075	369	316	2006-11-28 20:30:00	2006-11-28 21:00:18	f
1888	281	301	2006-11-13 21:30:00	2006-11-13 22:42:01	f
1696	279	282	2006-10-28 13:10:02	2006-10-28 16:00:00	f
1890	143	301	2006-11-13 21:30:00	2006-11-13 21:30:00	f
1893	314	301	2006-11-13 22:05:34	2006-11-13 23:09:35	f
1685	293	282	2006-10-28 11:00:00	2006-10-28 16:00:00	f
1684	319	282	2006-10-28 11:00:00	2006-10-28 11:00:00	f
1705	148	282	2006-10-28 15:27:51	2006-10-28 15:32:27	f
1702	152	282	2006-10-28 15:11:15	2006-10-28 15:53:20	f
1729	59	285	2006-10-29 19:30:00	2006-10-29 20:45:00	t
1887	220	301	2006-11-13 21:30:00	2006-11-13 21:30:00	f
1730	156	285	2006-10-29 19:30:00	2006-10-29 20:45:00	t
1674	231	281	2006-10-26 21:00:00	2006-10-26 22:33:13	f
1732	152	285	2006-10-29 19:30:00	2006-10-29 20:45:00	t
1731	234	285	2006-10-29 19:30:00	2006-10-29 20:45:00	t
1726	78	285	2006-10-29 19:30:00	2006-10-29 20:45:00	t
1671	66	281	2006-10-26 21:00:00	2006-10-26 21:41:33	f
1676	152	281	2006-10-26 21:00:00	2006-10-26 22:42:59	f
1735	222	285	2006-10-29 20:10:30	2006-10-29 20:45:00	t
1736	217	285	2006-10-29 20:20:15	2006-10-29 20:45:00	t
1681	188	281	2006-10-26 21:41:34	2006-10-26 23:00:00	f
1682	189	281	2006-10-26 22:47:37	2006-10-26 23:00:00	f
1675	284	281	2006-10-26 21:00:00	2006-10-26 21:00:00	f
1678	322	281	2006-10-26 21:00:00	2006-10-26 21:00:00	f
1680	325	281	2006-10-26 21:00:00	2006-10-26 21:15:24	f
1673	155	281	2006-10-26 21:00:00	2006-10-26 21:00:00	f
1679	319	281	2006-10-26 21:00:00	2006-10-26 21:00:00	f
1672	293	281	2006-10-26 21:00:00	2006-10-26 21:00:00	f
1677	118	281	2006-10-26 21:00:00	2006-10-26 21:00:00	f
1797	275	292	2006-11-04 19:45:00	2006-11-04 20:15:00	f
1728	284	285	2006-10-29 19:30:00	2006-10-29 19:30:00	t
1796	284	292	2006-11-04 19:45:00	2006-11-04 19:45:00	f
1799	156	292	2006-11-04 19:45:00	2006-11-04 19:45:00	f
1733	155	285	2006-10-29 19:30:00	2006-10-29 19:30:00	t
1793	325	292	2006-11-04 19:45:00	2006-11-04 19:45:00	f
1791	213	292	2006-11-04 19:45:00	2006-11-04 19:45:00	f
1790	215	292	2006-11-04 19:45:00	2006-11-04 19:45:00	f
1788	66	292	2006-11-04 19:45:00	2006-11-04 19:45:00	f
1800	78	293	2006-11-04 21:45:00	2006-11-04 22:16:43	f
1895	293	301	2006-11-13 22:43:37	2006-11-13 23:37:46	f
1803	340	293	2006-11-04 21:45:00	2006-11-04 21:45:00	f
1806	188	293	2006-11-04 21:47:39	2006-11-04 23:25:35	f
1878	354	300	2006-11-12 19:42:01	2006-11-12 21:42:01	f
1886	355	301	2006-11-13 21:30:00	2006-11-13 21:30:00	f
1892	66	301	2006-11-13 21:30:00	2006-11-13 21:30:00	f
1872	31	300	2006-11-12 19:30:00	2006-11-12 21:15:41	f
2048	319	314	2006-11-26 19:30:00	2006-11-26 21:06:10	f
1833	319	296	2006-11-09 18:22:39	2006-11-09 20:22:39	f
1778	157	291	2006-11-04 11:20:39	2006-11-04 11:34:33	t
2078	359	316	2006-11-28 20:35:31	2006-11-28 23:45:00	f
1795	316	292	2006-11-04 19:45:00	2006-11-04 19:45:00	f
1768	143	290	2006-11-02 21:00:00	2006-11-02 21:04:26	t
1774	322	290	2006-11-02 21:00:00	2006-11-02 21:00:00	t
1830	152	295	2006-11-06 21:00:00	2006-11-06 21:00:00	t
1759	200	288	2006-10-30 22:17:26	2006-10-30 22:22:05	f
1753	322	288	2006-10-30 21:00:00	2006-10-30 21:00:00	f
1747	187	288	2006-10-30 21:00:00	2006-10-30 21:00:00	f
1829	322	295	2006-11-06 21:00:00	2006-11-06 21:00:00	t
1828	340	295	2006-11-06 21:00:00	2006-11-06 21:00:00	t
1983	360	308	2006-11-20 21:15:00	2006-11-20 21:49:38	f
1843	123	297	2006-11-11 11:56:56	2006-11-11 12:01:41	f
1981	279	308	2006-11-20 21:15:00	2006-11-20 22:21:05	f
1816	59	294	2006-11-05 19:30:00	2006-11-05 21:28:42	t
1812	213	294	2006-11-05 19:30:00	2006-11-05 21:42:43	t
1813	154	294	2006-11-05 19:30:00	2006-11-06 00:15:00	t
1823	213	294	2006-11-05 22:15:59	2006-11-06 00:15:00	t
1824	66	294	2006-11-05 23:44:32	2006-11-06 00:15:00	t
1822	19	294	2006-11-05 22:15:10	2006-11-05 23:37:51	t
1807	148	293	2006-11-04 21:58:03	2006-11-04 23:58:03	f
1819	40	294	2006-11-05 20:30:22	2006-11-05 23:35:27	t
1821	217	294	2006-11-05 20:47:12	2006-11-05 22:47:12	t
1808	152	293	2006-11-04 22:01:49	2006-11-05 00:00:00	f
1798	275	293	2006-11-04 21:45:00	2006-11-04 21:45:00	f
1802	215	293	2006-11-04 21:45:00	2006-11-04 21:45:00	f
1801	220	293	2006-11-04 21:45:00	2006-11-04 21:45:00	f
1805	337	293	2006-11-04 21:45:00	2006-11-04 21:46:05	f
1804	240	293	2006-11-04 21:45:00	2006-11-04 21:49:42	f
1854	188	298	2006-11-11 20:00:00	2006-11-11 20:00:00	f
1849	75	298	2006-11-11 20:00:00	2006-11-11 20:00:00	f
1865	59	300	2006-11-12 19:30:00	2006-11-12 20:57:24	f
1876	156	300	2006-11-12 19:30:00	2006-11-12 21:25:57	f
1857	354	299	2006-11-11 21:30:00	2006-11-11 21:53:09	f
1896	151	301	2006-11-13 23:12:16	2006-11-14 00:45:00	f
1894	299	301	2006-11-13 22:06:21	2006-11-13 22:06:59	f
1885	279	301	2006-11-13 21:30:00	2006-11-13 21:30:00	f
1873	355	300	2006-11-12 19:30:00	2006-11-12 21:15:57	f
1860	314	299	2006-11-11 22:01:55	2006-11-12 00:45:00	f
1861	340	299	2006-11-11 22:27:29	2006-11-11 22:46:29	f
1848	347	299	2006-11-11 21:30:00	2006-11-11 21:30:00	f
1889	354	301	2006-11-13 21:30:00	2006-11-13 21:45:44	f
1855	355	299	2006-11-11 21:30:00	2006-11-11 21:30:00	f
1858	66	299	2006-11-11 21:30:00	2006-11-11 21:30:00	f
2092	143	318	2006-12-02 12:05:25	2006-12-02 12:38:14	f
2007	143	310	2006-11-21 22:18:08	2006-11-22 00:18:08	t
2003	222	310	2006-11-21 21:00:00	2006-11-21 21:03:17	t
2008	66	310	2006-11-21 22:18:33	2006-11-21 22:28:00	t
1875	222	300	2006-11-12 19:30:00	2006-11-13 00:30:00	f
1877	118	300	2006-11-12 19:41:14	2006-11-12 21:41:14	f
1879	281	300	2006-11-12 19:45:11	2006-11-12 21:45:11	f
1881	86	300	2006-11-12 22:57:43	2006-11-13 00:30:00	f
2009	326	310	2006-11-21 23:38:10	2006-11-22 00:35:00	t
1989	213	308	2006-11-20 21:15:00	2006-11-20 23:03:07	f
1871	284	300	2006-11-12 19:30:00	2006-11-12 19:30:00	f
1867	143	300	2006-11-12 19:30:00	2006-11-12 23:09:50	f
1874	257	300	2006-11-12 19:30:00	2006-11-12 19:30:00	f
1870	152	300	2006-11-12 19:30:00	2006-11-13 00:13:41	f
1869	167	300	2006-11-12 19:30:00	2006-11-12 19:30:00	f
1866	66	300	2006-11-12 19:30:00	2006-11-12 23:09:46	f
1908	359	303	2006-11-16 21:00:00	2006-11-16 22:38:22	t
1904	325	302	2006-11-14 22:33:22	2006-11-14 22:48:25	t
1905	32	302	2006-11-14 22:33:41	2006-11-14 22:48:57	t
1901	269	302	2006-11-14 21:00:55	2006-11-14 23:30:47	t
1898	354	302	2006-11-14 21:00:00	2006-11-14 22:09:59	t
1907	257	303	2006-11-16 21:00:00	2006-11-16 21:00:00	t
1906	319	303	2006-11-16 21:00:00	2006-11-16 21:00:00	t
1909	45	303	2006-11-16 23:25:00	2006-11-16 23:29:57	t
2004	155	310	2006-11-21 21:00:00	2006-11-21 21:00:00	t
1996	207	308	2006-11-20 22:39:40	2006-11-21 00:39:40	f
1992	30	308	2006-11-20 21:23:38	2006-11-20 22:44:15	f
1994	275	308	2006-11-20 22:25:00	2006-11-20 23:53:41	f
2005	223	310	2006-11-21 21:00:00	2006-11-21 22:35:19	t
1987	339	308	2006-11-20 21:15:00	2006-11-20 21:15:00	f
1986	66	308	2006-11-20 21:15:00	2006-11-20 21:15:00	f
2082	66	316	2006-11-28 21:32:51	2006-11-28 22:04:35	f
2002	319	310	2006-11-21 21:00:00	2006-11-21 21:00:00	t
2088	66	317	2006-11-30 22:15:16	2006-12-01 00:00:00	f
2084	78	316	2006-11-28 21:46:20	2006-11-28 23:15:07	f
2052	234	314	2006-11-26 19:50:50	2006-11-27 00:30:00	f
2086	31	316	2006-11-28 22:30:05	2006-11-28 23:19:20	f
2049	284	314	2006-11-26 19:30:00	2006-11-26 19:30:00	f
2054	15	314	2006-11-26 20:05:51	2006-11-26 21:26:03	f
2012	293	311	2006-11-25 11:00:00	2006-11-25 11:00:00	f
2011	360	311	2006-11-25 11:00:00	2006-11-25 11:00:00	f
2046	373	314	2006-11-26 19:30:00	2006-11-26 19:30:00	f
1920	281	304	2006-11-18 12:17:06	2006-11-18 14:17:06	t
2097	156	319	2006-12-02 20:00:00	2006-12-02 20:50:00	f
1918	359	304	2006-11-18 11:00:00	2006-11-18 12:51:12	t
1913	339	304	2006-11-18 11:00:00	2006-11-18 11:00:00	t
2051	177	314	2006-11-26 19:30:20	2006-11-26 23:39:39	f
2095	369	319	2006-12-02 20:00:00	2006-12-02 20:00:00	f
2060	177	314	2006-11-26 22:43:15	2006-11-26 23:39:39	f
1919	160	304	2006-11-18 12:16:38	2006-11-18 13:16:29	t
1921	316	304	2006-11-18 12:33:42	2006-11-18 13:15:47	t
2047	222	314	2006-11-26 19:30:00	2006-11-26 19:30:00	f
2099	78	319	2006-12-02 20:00:00	2006-12-02 20:00:00	f
2038	354	312	2006-11-25 20:01:05	2006-11-25 20:15:00	f
2036	293	312	2006-11-25 19:56:39	2006-11-25 20:15:00	f
2105	213	320	2006-12-02 21:15:00	2006-12-02 21:16:39	f
2030	213	312	2006-11-25 19:30:00	2006-11-25 19:30:00	f
2034	151	312	2006-11-25 19:30:00	2006-11-25 19:30:00	f
2040	275	313	2006-11-25 21:00:00	2006-11-25 21:00:00	f
2074	373	316	2006-11-28 20:30:00	2006-11-28 21:13:08	f
2083	275	316	2006-11-28 21:45:20	2006-11-28 23:45:00	f
2055	118	314	2006-11-26 21:10:00	2006-11-26 23:10:00	f
2006	275	310	2006-11-21 21:01:22	2006-11-21 23:13:44	t
2001	359	310	2006-11-21 21:00:00	2006-11-21 23:15:35	t
2087	373	316	2006-11-28 23:22:22	2006-11-28 23:45:00	f
2079	257	316	2006-11-28 20:35:34	2006-11-28 20:45:01	f
1988	314	308	2006-11-20 21:15:00	2006-11-20 23:41:02	f
1936	143	305	2006-11-18 19:30:00	2006-11-18 19:30:00	t
1946	275	305	2006-11-18 19:30:00	2006-11-18 19:30:00	t
1945	314	305	2006-11-18 19:30:00	2006-11-18 19:30:00	t
1930	359	305	2006-11-18 19:30:00	2006-11-18 19:30:00	t
1934	354	305	2006-11-18 19:30:00	2006-11-18 19:46:34	t
1941	343	305	2006-11-18 19:30:00	2006-11-18 19:30:00	t
1926	75	305	2006-11-18 19:30:00	2006-11-18 19:30:00	t
1935	66	305	2006-11-18 19:30:00	2006-11-18 19:39:42	t
1993	369	308	2006-11-20 21:43:50	2006-11-20 23:43:50	f
1990	177	308	2006-11-20 21:15:00	2006-11-20 21:15:00	f
1991	236	308	2006-11-20 21:18:08	2006-11-20 23:49:29	f
1995	188	308	2006-11-20 22:38:41	2006-11-21 00:38:41	f
2077	293	316	2006-11-28 20:32:55	2006-11-28 22:10:41	f
1982	359	308	2006-11-20 21:15:00	2006-11-20 21:16:10	f
2050	369	314	2006-11-26 19:30:00	2006-11-27 00:11:45	f
2059	251	314	2006-11-26 22:21:58	2006-11-26 22:30:54	f
2098	61	319	2006-12-02 20:00:00	2006-12-02 20:00:00	f
2089	45	317	2006-11-30 23:29:29	2006-11-30 23:36:04	f
2093	19	318	2006-12-02 12:54:36	2006-12-02 13:13:14	f
1951	356	306	2006-11-18 21:30:00	2006-11-18 22:10:25	t
1953	314	306	2006-11-18 23:14:24	2006-11-18 23:26:40	t
1943	207	306	2006-11-18 21:30:00	2006-11-18 21:30:00	t
1952	78	306	2006-11-18 21:30:00	2006-11-18 21:30:00	t
1948	360	306	2006-11-18 21:30:00	2006-11-18 21:30:00	t
1950	355	306	2006-11-18 21:30:00	2006-11-18 21:30:00	t
2073	207	315	2006-11-27 22:49:25	2006-11-28 00:45:00	f
2067	372	315	2006-11-27 21:00:00	2006-11-27 21:00:00	f
2071	26	315	2006-11-27 21:00:00	2006-11-27 21:00:00	f
2069	314	315	2006-11-27 21:00:00	2006-11-27 21:03:42	f
2066	371	315	2006-11-27 21:00:00	2006-11-27 22:11:31	f
2068	359	315	2006-11-27 21:00:00	2006-11-27 21:00:00	f
2064	369	315	2006-11-27 21:00:00	2006-11-27 21:09:24	f
2070	293	315	2006-11-27 21:00:00	2006-11-27 21:00:00	f
2065	360	315	2006-11-27 21:00:00	2006-11-27 21:29:05	f
2072	307	315	2006-11-27 21:00:00	2006-11-27 21:09:21	f
2031	215	312	2006-11-25 19:30:00	2006-11-25 19:30:00	f
2027	369	312	2006-11-25 19:30:00	2006-11-25 19:30:00	f
2033	343	312	2006-11-25 19:30:00	2006-11-25 19:30:00	f
2035	355	313	2006-11-25 21:00:00	2006-11-25 22:21:11	f
2106	240	320	2006-12-02 21:15:00	2006-12-02 23:11:52	f
2108	152	320	2006-12-02 23:19:17	2006-12-03 00:55:00	f
2045	359	313	2006-11-25 21:00:00	2006-11-25 21:05:30	f
2041	369	313	2006-11-25 21:00:00	2006-11-25 21:00:00	f
2037	293	313	2006-11-25 21:00:00	2006-11-25 21:00:00	f
2043	360	313	2006-11-25 21:00:00	2006-11-25 21:00:00	f
2103	372	320	2006-12-02 21:15:00	2006-12-02 21:15:00	f
2109	359	320	2006-12-02 23:44:50	2006-12-02 23:59:11	f
2104	339	320	2006-12-02 21:15:00	2006-12-02 21:47:59	f
2107	383	320	2006-12-02 21:15:00	2006-12-03 00:01:46	f
2101	207	320	2006-12-02 21:15:00	2006-12-02 21:15:00	f
2100	360	320	2006-12-02 21:15:00	2006-12-02 21:15:00	f
2112	325	321	2006-12-03 19:14:50	2006-12-03 19:41:59	f
2111	59	321	2006-12-03 19:05:22	2006-12-03 19:42:01	f
2110	123	321	2006-12-03 18:58:37	2006-12-03 19:42:03	f
2114	40	321	2006-12-03 20:33:29	2006-12-03 22:33:29	f
2115	5	321	2006-12-03 21:54:51	2006-12-03 23:54:51	f
2117	326	321	2006-12-03 22:03:51	2006-12-04 00:03:51	f
2116	61	321	2006-12-03 22:03:03	2006-12-04 00:43:21	f
2113	374	321	2006-12-03 19:47:24	2006-12-04 01:11:52	f
1969	66	307	2006-11-19 20:16:33	2006-11-19 22:16:33	t
1970	143	307	2006-11-19 20:17:08	2006-11-19 22:17:08	t
1971	326	307	2006-11-19 20:18:56	2006-11-19 22:18:56	t
1975	59	307	2006-11-19 21:06:50	2006-11-19 23:06:50	t
1973	354	307	2006-11-19 20:35:59	2006-11-19 23:24:42	t
1961	354	307	2006-11-19 19:30:00	2006-11-19 19:59:16	t
1957	75	307	2006-11-19 19:30:00	2006-11-19 20:02:22	t
1966	78	307	2006-11-19 19:30:00	2006-11-19 21:21:46	t
1965	177	307	2006-11-19 19:30:00	2006-11-19 21:30:47	t
1960	359	307	2006-11-19 19:30:00	2006-11-19 21:42:06	t
1959	369	307	2006-11-19 19:30:00	2006-11-19 21:45:15	t
1962	319	307	2006-11-19 19:30:00	2006-11-19 22:00:59	t
1977	177	307	2006-11-19 22:03:59	2006-11-19 23:25:00	t
1978	369	307	2006-11-19 22:31:39	2006-11-19 23:25:00	t
1979	299	307	2006-11-19 22:33:07	2006-11-19 23:25:00	t
1980	152	307	2006-11-19 22:55:21	2006-11-19 23:25:00	t
1967	284	307	2006-11-19 19:30:00	2006-11-19 19:30:00	t
1963	123	307	2006-11-19 19:30:00	2006-11-19 19:30:00	t
1964	155	307	2006-11-19 19:30:00	2006-11-19 19:30:00	t
1974	222	307	2006-11-19 20:59:31	2006-11-19 22:53:55	t
1976	52	307	2006-11-19 21:51:56	2006-11-19 22:28:55	t
1968	55	307	2006-11-19 19:30:00	2006-11-19 20:27:26	t
\.


--
-- Name: dkp_adjustments_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dkp_adjustments
    ADD CONSTRAINT dkp_adjustments_id_key UNIQUE (id);


--
-- Name: dungeon_bosses_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeon_bosses
    ADD CONSTRAINT dungeon_bosses_id_key UNIQUE (id);


--
-- Name: dungeon_bosses_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeon_bosses
    ADD CONSTRAINT dungeon_bosses_name_key UNIQUE (name);


--
-- Name: dungeon_loot_types_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeon_loot_types
    ADD CONSTRAINT dungeon_loot_types_id_key UNIQUE (id);


--
-- Name: dungeon_loot_types_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeon_loot_types
    ADD CONSTRAINT dungeon_loot_types_name_key UNIQUE (name);


--
-- Name: dungeons_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeons
    ADD CONSTRAINT dungeons_id_key UNIQUE (id);


--
-- Name: dungeons_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeons
    ADD CONSTRAINT dungeons_name_key UNIQUE (name);


--
-- Name: items_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_id_key UNIQUE (id);


--
-- Name: items_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_name_key UNIQUE (name);


--
-- Name: loot_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY loot
    ADD CONSTRAINT loot_id_key UNIQUE (id);


--
-- Name: raid_kills_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY raid_kills
    ADD CONSTRAINT raid_kills_id_key UNIQUE (id);


--
-- Name: raids_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY raids
    ADD CONSTRAINT raids_id_key UNIQUE (id);


--
-- Name: toon_classes_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toon_classes
    ADD CONSTRAINT toon_classes_id_key UNIQUE (id);


--
-- Name: toon_classes_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toon_classes
    ADD CONSTRAINT toon_classes_name_key UNIQUE (name);


--
-- Name: toon_ranks_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toon_ranks
    ADD CONSTRAINT toon_ranks_id_key UNIQUE (id);


--
-- Name: toon_ranks_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toon_ranks
    ADD CONSTRAINT toon_ranks_name_key UNIQUE (name);


--
-- Name: toons_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toons
    ADD CONSTRAINT toons_id_key UNIQUE (id);


--
-- Name: toons_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toons
    ADD CONSTRAINT toons_name_key UNIQUE (name);


--
-- Name: users_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_name_key UNIQUE (name);


--
-- Name: waitlist_requests_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY waitlist_requests
    ADD CONSTRAINT waitlist_requests_id_key UNIQUE (id);


--
-- Name: attendance_raid_toon_key; Type: INDEX; Schema: public; Owner: mdg; Tablespace: 
--

CREATE UNIQUE INDEX attendance_raid_toon_key ON attendance USING btree (raid_id, toon_id);


--
-- Name: attendance_raid_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT attendance_raid_id_fkey FOREIGN KEY (raid_id) REFERENCES raids(id);


--
-- Name: attendance_toon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT attendance_toon_id_fkey FOREIGN KEY (toon_id) REFERENCES toons(id);


--
-- Name: dkp_adjustments_toon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY dkp_adjustments
    ADD CONSTRAINT dkp_adjustments_toon_id_fkey FOREIGN KEY (toon_id) REFERENCES toons(id);


--
-- Name: dungeon_bosses_dungeon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY dungeon_bosses
    ADD CONSTRAINT dungeon_bosses_dungeon_id_fkey FOREIGN KEY (dungeon_id) REFERENCES dungeons(id);


--
-- Name: dungeons_loot_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY dungeons
    ADD CONSTRAINT dungeons_loot_type_fkey FOREIGN KEY (loot_type) REFERENCES dungeon_loot_types(id);


--
-- Name: items_dungeon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_dungeon_id_fkey FOREIGN KEY (dungeon_id) REFERENCES dungeons(id);


--
-- Name: loot_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY loot
    ADD CONSTRAINT loot_item_id_fkey FOREIGN KEY (item_id) REFERENCES items(id);


--
-- Name: loot_raid_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY loot
    ADD CONSTRAINT loot_raid_id_fkey FOREIGN KEY (raid_id) REFERENCES raids(id);


--
-- Name: loot_toon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY loot
    ADD CONSTRAINT loot_toon_id_fkey FOREIGN KEY (toon_id) REFERENCES toons(id);


--
-- Name: raid_kills_boss_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY raid_kills
    ADD CONSTRAINT raid_kills_boss_id_fkey FOREIGN KEY (boss_id) REFERENCES dungeon_bosses(id);


--
-- Name: raid_kills_raid_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY raid_kills
    ADD CONSTRAINT raid_kills_raid_id_fkey FOREIGN KEY (raid_id) REFERENCES raids(id);


--
-- Name: raids_dungeon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY raids
    ADD CONSTRAINT raids_dungeon_id_fkey FOREIGN KEY (dungeon_id) REFERENCES dungeons(id);


--
-- Name: toons_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY toons
    ADD CONSTRAINT toons_class_id_fkey FOREIGN KEY (class_id) REFERENCES toon_classes(id);


--
-- Name: toons_rank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY toons
    ADD CONSTRAINT toons_rank_id_fkey FOREIGN KEY (rank_id) REFERENCES toon_ranks(id);


--
-- Name: waitlist_requests_raid_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY waitlist_requests
    ADD CONSTRAINT waitlist_requests_raid_id_fkey FOREIGN KEY (raid_id) REFERENCES raids(id);


--
-- Name: waitlist_requests_toon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mdg
--

ALTER TABLE ONLY waitlist_requests
    ADD CONSTRAINT waitlist_requests_toon_id_fkey FOREIGN KEY (toon_id) REFERENCES toons(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: pgsql
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM pgsql;
GRANT ALL ON SCHEMA public TO pgsql;
GRANT ALL ON SCHEMA public TO mdg;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

