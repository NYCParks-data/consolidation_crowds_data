REM @echo off

REM Create the database
REM This file is in the gitignore file because it contains information about 
REM active directory groups. This line can be commented out if you choose to
REM create the database prior to running this script.
REM -------------------------------------------------------------------------
sqlcmd -S . -E -i create_db.sql

REM Run all the create table scripts
REM -------------------------------------------------------------------------
sqlcmd -S . -E -i tbl_ref_park_sites.sql

sqlcmd -S . -E -i tbl_ref_park_sites_audit.sql

sqlcmd -S . -E -i tbl_dpr_patrol.sql

sqlcmd -S . -E -i tbl_dpr_patrol_audit.sql

sqlcmd -S . -E -i tbl_dpr_ambassador.sql

sqlcmd -S . -E -i tbl_dpr_ambassador_audit.sql

sqlcmd -S . -E -i tbl_cw_ambassador.sql

sqlcmd -S . -E -i tbl_dpr_crowds.sql

sqlcmd -S . -E -i tbl_ref_precinct.sql

sqlcmd -S . -E -i tbl_ref_encounter_type.sql

REM Run the scripts to create the stored procedures
REM -------------------------------------------------------------------------

sqlcmd -S . -E -i sp_m_tbl_ref_park_sites.sql

REM Run the scripts to create the triggers
REM -------------------------------------------------------------------------

sqlcmd -S . -E -i trg_u_tbl_dpr_ambassador.sql

sqlcmd -S . -E -i trg_u_tbl_dpr_patrol.sql

sqlcmd -S . -E -i trg_u_tbl_ref_park_sites.sql

REM Run all the create view scripts
REM -------------------------------------------------------------------------

sqlcmd -S . -E -i vw_consolidated_socialdistancing.sql

sqlcmd -S . -E -i vw_consolidated_socialdistancing_opendata.sql

sqlcmd -S . -E -i vw_dpr_crowds_opendata.sql

sqlcmd -S . -E -i vw_dpr_ambassador_opendata.sql

sqlcmd -S . -E -i vw_cw_ambassador_opendata.sql

sqlcmd -S . -E -i vw_dpr_patrol_opendata.sql

sqlcmd -S . -E -i vw_ref_park_areas_opendata.sql

pause