/***********************************************************************************************************************
																													   	
 created by: dan gallagher, daniel.gallagher@parks.nyc.gov, innovation & performance management         											   
 modified by: <modifier name>																						   			          
 created date:  <mm/dd/yyyy>																							   
 modified date: <mm/dd/yyyy>																							   
											       																	   
 project: <project name>	
 																							   
 tables used: <database>.<schema>.<table name1>																							   
 			  <database>.<schema>.<table name2>																								   
 			  <database>.<schema>.<table name3>				
			  																				   
 description: <lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       ut has tota ullamcorper, vis at aeque omnium. est sint purto at, verear inimicus at has. ad sed dicat       
	       iudicabit. has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. his ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
set ansi_nulls on;
go

set quoted_identifier on;
go

create table crowdsdb.dbo.tbl_dpr_patrol_audit(patrol_id int foreign key references crowdsdb.dbo.tbl_dpr_patrol(patrol_id),
											   encounter_timestamp datetime, 
											   encounter_datetime datetime, 
											   site_id nvarchar(30) foreign key references crowdsdb.dbo.tbl_ref_park_sites(site_id),
											   location_adddesc nvarchar(1000), 
											   park_division nvarchar(80), 
											   visit_reason nvarchar(80),
											   firstname_1 nvarchar(80), 
											   lastname_1 nvarchar(80), 
											   firstname_2 nvarchar(80), 
											   lastname_2 nvarchar(80), 
											   firstname_3 nvarchar(80), 
											   lastname_3 nvarchar(80), 
											   patrol_method nvarchar(30), 
											   encounter_type nvarchar(80), 
											   closed_amenity nvarchar(100), 
											   closed_patroncount int, 
											   closed_education bit, 
											   closed_outcome bit,
											   closed_summonsissued bit,
											   closed_pdassist bit,
											   closed_pdcontact bit,
											   closed_comments nvarchar(1000),
											   sd_summonsissued bit, 
											   sd_pdassist bit, 
											   sd_pdcontact bit, 
											   sd_comments nvarchar(1000), 
											   sd_patronscomplied int, 
											   sd_patronsnocomply int, 
											   sd_amenity nvarchar(100), 
											   summonscount_a01 int, 
											   summonscount_a03 int, 
											   summonscount_a04 int, 
											   summonscount_a22 int, 
											   other_summonstype nvarchar(500), 
											   other_summonscount int, 
											   borough nvarchar(13),
											   closed_outcome_spec nvarchar(100),
											   sd_outcome_spec nvarchar(100));