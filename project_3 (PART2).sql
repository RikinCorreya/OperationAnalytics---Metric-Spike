                              
#                                                              PART 2

# TASK A - Weekly User Engagement                                               RIKIN CORREYA  
# Objective: Measure the activeness of users on a weekly basis.
# Task: Write an SQL query to calculate the weekly user engagement.
select count(event_name) as no_of_events, week(occurred_at) as week_no from  events
where event_type <> 'signup_flow'
group by week_no;




# TASK B - User Growth Analysis                                                      RIKIN CORREYA
# Objective: Analyze the growth of users over time for a product.
# Task: Write an SQL query to calculate the user growth for the product.

select month(created_at) as month_no, year(created_at) as year_created, count(user_id) as no_of_acc_created from users
group by year_created, month_no ;


# TASK C - Weekly Retention Analysis                                                                     RIKIN CORREYA
# Objective: Analyze the retention of users on a weekly basis after signing up for a product.
# Your Task: Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.


# Shows how many users came back for engagement every week after activating their account
select
	distinct timestampdiff(week, a.activated_at, b.occurred_at) as week_period_after_signing_up , count(distinct a.user_id) as no_of_users_retended,
    round(count(distinct a.user_id)*100/lag(count(distinct a.user_id), 1) over(),2) as percentage_retained
from
    (select user_id, activated_at from users) a
inner join
    (select user_id, occurred_at from events) b  
on a.user_id = b.user_id
group by week_period_after_signing_up
order by week_period_after_signing_up ;

# Shows how many different weeks a user has done some engagement after activating their accound
 SELECT
     a.user_id, count( distinct TIMESTAMPDIFF(week, a.activated_at, b.occurred_at)) AS no_of_weeks_rentended 
FROM
    (SELECT user_id, activated_at FROM users) a
INNER JOIN
    (SELECT user_id, occurred_at FROM events) b
ON a.user_id = b.user_id
group by a.user_id
order by no_of_weeks_rentended desc
;





# TASK D - Weekly Engagement Per Device                                                                     RIKIN CORREYA
# Objective: Measure the activeness of users on a weekly basis per device.
# Task: Write an SQL query to calculate the weekly engagement per device.

select distinct week(occurred_at) as week_no, 
count(event_name) over(partition by device, week(occurred_at)) as no_of_engagements, device
from events 
order by week_no;

/* the bottom one lide code gives us the output of TOTAL_USERS_USING_A_SPECIFIC_DEVICE_PER_WEEK  
    while the above code provides WEEKLY_PER_USER_PER_DEVICE_ENGAGEMENT which is more specific to every user */
select count(distinct user_id) as no_of_users, device, week(occurred_at) as week_number from events group by 2,3 order by week_number ;


# TASK E - Email Engagement Analysis                                                                       RIKIN CORREYA
# Objective: Analyze how users are engaging with the email service.
# Task: Write an SQL query to calculate the email engagement metrics.

/* As there was no specified metric asked to query, I have just quried TOTAL_ENGAGEMENTS as a general email service engagement
   IF Indivitual events have to be analysed as well like weekly_digest, email_open, etc, we can just add more columns in the same way.*/

select  week(occurred_at) as week_number, count(distinct user_id) as no_of_users,
count(action) as no_of_engagement, (count(action) - lag(count(action),1) over(order by week(occurred_at))) as growth_email_engagements  
from email_events 
group by week_number
order by week_number ;



