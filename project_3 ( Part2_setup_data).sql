show databases;
use project_2;


# USERS
create table users (
	user_id int,
    created_at varchar(30),
    company_id int,
    language varchar(30),
    activated_at varchar(30),
    state varchar(30)
);

show variables like 'secure_file_priv';

load data infile 'C:/ProgramData/MySQL/MySQL Server 9.0/Uploads/users.csv'
into table users
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from users;

alter table users add column temp_created_at datetime;
update users set temp_created_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');
alter table users drop column created_at;
alter table users change column temp_created_at created_at datetime;

alter table users add column temp_activated_at datetime;
update users set temp_activated_at = STR_TO_DATE(activated_at, '%d-%m-%Y %H:%i');
alter table users drop column activated_at;
alter table users change column temp_activated_at activated_at datetime;


# EVENTS
create table events (
	user_id int,
    occurred_at varchar(30),
    event_type varchar(50),
    event_name varchar(30),
    location varchar(40),
    device varchar(200),
    usr_type int
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 9.0/Uploads/events.csv'
into table events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from events;

alter table events add column temp_occurred_at datetime;
update events set temp_occurred_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');
alter table events drop column occurred_at;
alter table events change column temp_occurred_at occurred_at datetime;


# email_events

create table email_events (
	user_id int,
    occurred_at varchar(30),
    action varchar(100),
    user_type int
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 9.0/Uploads/email_events.csv'
into table email_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from email_events;

alter table email_events add column temp_occurred_at datetime;
update email_events set temp_occurred_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');
alter table email_events drop column occurred_at;
alter table email_events change column temp_occurred_at occurred_at datetime;
