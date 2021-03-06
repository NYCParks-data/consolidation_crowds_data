/***********************************************************************************************************************
																													   	
 Created By: Dan Gallagher, daniel.gallagher@parks.nyc.gov, Innovation & Performance Management         											   
 Modified By: <Modifier Name>																						   			          
 Created Date:  <MM/DD/YYYY>																							   
 Modified Date: <MM/DD/YYYY>																							   
											       																	   
 Project: <Project Name>	
 																							   
 Tables Used: <Database>.<Schema>.<Table Name1>																							   
 			  <Database>.<Schema>.<Table Name2>																								   
 			  <Database>.<Schema>.<Table Name3>				
			  																				   
 Description: <Lorem ipsum dolor sit amet, legimus molestiae philosophia ex cum, omnium voluptua evertitur nec ea.     
	       Ut has tota ullamcorper, vis at aeque omnium. Est sint purto at, verear inimicus at has. Ad sed dicat       
	       iudicabit. Has ut eros tation theophrastus, et eam natum vocent detracto, purto impedit appellantur te	   
	       vis. His ad sonet probatus torquatos, ut vim tempor vidisse deleniti.>  									   
																													   												
***********************************************************************************************************************/
use crowdsdb
go

set ansi_nulls on;
go

set quoted_identifier on;
go

create or alter view dbo.vw_ref_park_areas_opendata as
	select reported_as, 
		   gispropnum, 
		   site_id as park_area_id, 
		   site_desc as park_area_desc, 
		   site_loc as park_area_loc, 
		   park_borough, 
		   park_district, 
		   police_precinct, 
		   police_boro_com, 
		   communityboard,
		   case when shape is null then geometry::STGeomFromText('MULTIPOLYGON EMPTY', 2263)
				else shape
		   end as shape
	from crowdsdb.dbo.tbl_ref_park_sites
	where shape is not null