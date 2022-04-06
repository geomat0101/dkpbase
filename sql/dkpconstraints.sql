--
-- Name: dkp_adjustments_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dkp_adjustments
    ADD CONSTRAINT dkp_adjustments_id_key UNIQUE (id);


ALTER INDEX public.dkp_adjustments_id_key OWNER TO mdg;

--
-- Name: dungeon_bosses_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeon_bosses
    ADD CONSTRAINT dungeon_bosses_id_key UNIQUE (id);


ALTER INDEX public.dungeon_bosses_id_key OWNER TO mdg;

--
-- Name: dungeon_bosses_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeon_bosses
    ADD CONSTRAINT dungeon_bosses_name_key UNIQUE (name);


ALTER INDEX public.dungeon_bosses_name_key OWNER TO mdg;

--
-- Name: dungeon_loot_types_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeon_loot_types
    ADD CONSTRAINT dungeon_loot_types_id_key UNIQUE (id);


ALTER INDEX public.dungeon_loot_types_id_key OWNER TO mdg;

--
-- Name: dungeon_loot_types_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeon_loot_types
    ADD CONSTRAINT dungeon_loot_types_name_key UNIQUE (name);


ALTER INDEX public.dungeon_loot_types_name_key OWNER TO mdg;

--
-- Name: dungeons_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeons
    ADD CONSTRAINT dungeons_id_key UNIQUE (id);


ALTER INDEX public.dungeons_id_key OWNER TO mdg;

--
-- Name: dungeons_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY dungeons
    ADD CONSTRAINT dungeons_name_key UNIQUE (name);


ALTER INDEX public.dungeons_name_key OWNER TO mdg;

--
-- Name: items_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_id_key UNIQUE (id);


ALTER INDEX public.items_id_key OWNER TO mdg;

--
-- Name: items_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_name_key UNIQUE (name);


ALTER INDEX public.items_name_key OWNER TO mdg;

--
-- Name: loot_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY loot
    ADD CONSTRAINT loot_id_key UNIQUE (id);


ALTER INDEX public.loot_id_key OWNER TO mdg;

--
-- Name: raid_kills_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY raid_kills
    ADD CONSTRAINT raid_kills_id_key UNIQUE (id);


ALTER INDEX public.raid_kills_id_key OWNER TO mdg;

--
-- Name: raids_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY raids
    ADD CONSTRAINT raids_id_key UNIQUE (id);


ALTER INDEX public.raids_id_key OWNER TO mdg;

--
-- Name: toon_classes_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toon_classes
    ADD CONSTRAINT toon_classes_id_key UNIQUE (id);


ALTER INDEX public.toon_classes_id_key OWNER TO mdg;

--
-- Name: toon_classes_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toon_classes
    ADD CONSTRAINT toon_classes_name_key UNIQUE (name);


ALTER INDEX public.toon_classes_name_key OWNER TO mdg;

--
-- Name: toon_ranks_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toon_ranks
    ADD CONSTRAINT toon_ranks_id_key UNIQUE (id);


ALTER INDEX public.toon_ranks_id_key OWNER TO mdg;

--
-- Name: toon_ranks_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toon_ranks
    ADD CONSTRAINT toon_ranks_name_key UNIQUE (name);


ALTER INDEX public.toon_ranks_name_key OWNER TO mdg;

--
-- Name: toons_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toons
    ADD CONSTRAINT toons_id_key UNIQUE (id);


ALTER INDEX public.toons_id_key OWNER TO mdg;

--
-- Name: toons_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY toons
    ADD CONSTRAINT toons_name_key UNIQUE (name);


ALTER INDEX public.toons_name_key OWNER TO mdg;

--
-- Name: users_name_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_name_key UNIQUE (name);


ALTER INDEX public.users_name_key OWNER TO mdg;

--
-- Name: waitlist_requests_id_key; Type: CONSTRAINT; Schema: public; Owner: mdg; Tablespace: 
--

ALTER TABLE ONLY waitlist_requests
    ADD CONSTRAINT waitlist_requests_id_key UNIQUE (id);


ALTER INDEX public.waitlist_requests_id_key OWNER TO mdg;

--
-- Name: attendance_raid_toon_key; Type: INDEX; Schema: public; Owner: mdg; Tablespace: 
--

CREATE UNIQUE INDEX attendance_raid_toon_key ON attendance USING btree (raid_id, toon_id);


ALTER INDEX public.attendance_raid_toon_key OWNER TO mdg;

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
-- Name: public; Type: ACL; Schema: -; Owner: mdg
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM mdg;
GRANT ALL ON SCHEMA public TO mdg;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

