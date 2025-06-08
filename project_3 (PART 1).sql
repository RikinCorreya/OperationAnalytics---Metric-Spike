create database project_2;
use project_2;
create table job_data (
	ds date,
    job_id int,
    actor_id int,
    event varchar(20),
    language varchar(20),
    time_spent int,
    org char(1)
);
insert into job_data (ds, job_id, actor_id, event, language, time_spent, org) values 
( '2020-11-30', 21	,1001	,'skip'	,'English'	,15	,'A'),
( '2020-11-30', 22	,1006	,'transfer'	,'Arabic'	,25	,'B'),
( '2020-11-29', 23	,1003	,'decision'	,'Persian'	,20	,'C'),
( '2020-11-28', 23	,1005	,'transfer'	,'Persian'	,22	,'D'),
( '2020-11-28', 25	,1002	,'decision'	,'Hindi'	,11	,'B'),
( '2020-11-27', 11	,1007	,'decision'	,'French'	,104 ,'D'),
( '2020-11-26', 23	,1004	,'skip'	,'Persian'	,56	,'A'),
( '2020-11-25', 20	,1003	,'transfer'	,'Italian'	,45	,'C')
;
drop table job_data;
select * from job_data;
#                                  CASE-STUDY 1
# TASK A - Jobs Reviewed Over Time:                                                             RIKIN CORREYA
# Objective - Calculate the number of jobs reviewed per hour for each day in November 2020.
# Task -  Write an SQL query to calculate the number of jobs reviewed per hour for each day 
#         in November 2020.

select count( distinct job_id) / (sum(time_spent)/3600) as jobs_reviewed_per_hour, date(ds) as November_Date, dayname(ds) as Day from job_data 
where month(ds)=11 group by date(ds), dayname(ds) order by jobs_reviewed_per_hour desc; 

# Every differenet day of november is grouped and the no of jobs is extracted for that date by
# calculating ( total number of unique jobs looked upon / total time spend by different
# users to review the different jobs that day) 



# TASK B - Throughput Analysis                                                                       RIKIN CORREYA
# Objective - Calculate the 7-day rolling average of throughput (number of events per second).
# Task - Write an SQL query to calculate the 7-day rolling average of throughput. Additionally, explain whether you prefer using the daily metric or 
#        the 7-day rolling average for throughput, and why.

with throughput as(
	select round(count( event ) / (sum(time_spent)),3) as events_per_second, ds from job_data 
    group by ds
),
rolling_average_throughput as(
	select 
    ds, events_per_second,
    round(avg(events_per_second) over ( order by ds
								  rows between 6 preceding and current row),3)
						   as rolling_average_7days
	from throughput
)
select ds,events_per_second, rolling_average_7days from  rolling_average_throughput;

# Can be easily done in one query as below, but the abve query using CTE systematically is more appealing to a layman.
select round(count( event ) / (sum(time_spent)),3) as events_per_second, ds, round(avg(round(count( event ) / (sum(time_spent)),3)) over ( order by ds
								  rows between 6 preceding and current row),3)
						   as rolling_average_7days
from job_data group by ds;


# TASK C - Language Share Analysis                                                                   RIKIN CORREYA
# Objective - Calculate the percentage share of each language in the last 30 days.
# Task -  Write an SQL query to calculate the percentage share of each language over the last 30 days.
with total as (
	select ds, language , count(language) over() as t from job_data  order by ds,language
    # where (current_date()-ds) between 0 and 30
),
ratio_language_used as (
	select language , count(language)/t as tl from total group by language 
),
percentage as (
	select  language, round((tl*100),2) as p
	from ratio_language_used
)
select *  from percentage;


# TASK D - Duplicate Rows Detection                                     RIKIN CORREYA
# Objective -  Identify duplicate rows in the data.
# Task - Write an SQL query to display duplicate rows from the job_data table.

select * from (
	select *, row_number() over (partition by ds,job_id,actor_id,language,time_spent,org) as duplicate_rows 
    from job_data
) as a 
where duplicate_rows>1;





