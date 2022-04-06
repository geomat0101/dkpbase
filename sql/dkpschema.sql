--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: mdg
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
-- Name: dungeon_loot_types; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE dungeon_loot_types (
    id serial NOT NULL,
    name text NOT NULL,
    shortdesc text NOT NULL
);


ALTER TABLE public.dungeon_loot_types OWNER TO mdg;

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
-- Name: toon_classes; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE toon_classes (
    id serial NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.toon_classes OWNER TO mdg;

--
-- Name: toon_ranks; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE toon_ranks (
    id serial NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.toon_ranks OWNER TO mdg;

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
-- Name: users; Type: TABLE; Schema: public; Owner: mdg; Tablespace: 
--

CREATE TABLE users (
    id serial NOT NULL,
    name text NOT NULL,
    email text,
    "password" text,
    admin integer DEFAULT 100 NOT NULL
);


ALTER TABLE public.users OWNER TO mdg;

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
-- Name: view_loot; Type: VIEW; Schema: public; Owner: mdg
--

CREATE VIEW view_loot AS
    SELECT l.id, l.raid_id, d.name AS dungeon, r.raid_date, l.toon_id, t.name AS toon_name, l.item_id, i.name AS item_name, i.value AS default_value, l.value FROM loot l, toons t, items i, raids r, dungeons d WHERE ((((l.toon_id = t.id) AND (l.item_id = i.id)) AND (l.raid_id = r.id)) AND (r.dungeon_id = d.id));


ALTER TABLE public.view_loot OWNER TO mdg;

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
