/*QUESTION 1: We want to reward our users who have been around the longest.  
Find the 5 oldest users.*/

SELECT * FROM users ORDER BY created_at ASC LIMIT 5;

/* QUESTION 2:What day of the week do most users register on?
We need to figure out when to schedule an ad campgain*/

-- Solution 1
SELECT DAYNAME(created_at) DAY,
COUNT(*) FROM users
GROUP BY DAYNAME(created_at) 
ORDER BY 2 DESC;

-- Solution 2
SELECT date_format(created_at,"%W") DAY,
COUNT(*) FROM users
GROUP BY date_format(created_at,"%W")
ORDER BY 2 DESC;

/* QUESTION 3:To target inactive users in an email_id campaign, 
find the users who have never posted a photo*/

-- Solution 1
SELECT * FROM users WHERE id !=ALL
(SELECT DISTINCT user_id FROM photos);

-- Solution 2
SELECT * FROM users WHERE id NOT IN
(SELECT DISTINCT user_id FROM photos);

/* QUESTION 4:Suppose you are running a contest to find out who got most likes on a photo. 
find out who won.*/

-- Solution 1
SELECT p.user_id,u.username,l.photo_id,COUNT(DISTINCT l.user_id) "No of likes"
FROM likes l INNER JOIN photos p 
ON p.id=l.photo_id 
INNER JOIN  users u 
ON u.id=p.user_id
GROUP BY p.user_id,l.photo_id
ORDER BY 4 DESC LIMIT 1;

-- Solution 2
SELECT u.id,u.username,a.num_of_likes FROM users u
INNER JOIN photos p ON p.user_id=u.id
INNER JOIN 
(SELECT photo_id,count(*) num_of_likes FROM likes 
GROUP BY photo_id ORDER BY count(*) DESC LIMIT 1)a
ON a.photo_id=p.id;
/*QUESTION 5: Number of users never posted*/

-- Solution 1 Noncorrelated subquery
SELECT COUNT(id) "Number of users never posted" FROM users 
WHERE id NOT IN (SELECT DISTINCT user_id FROM photos);

-- Solution 2 Co-related subquery
SELECT COUNT(u.id) "Number of users never posted" FROM users u WHERE NOT EXISTS
(SELECT 1 FROM photos p WHERE p.user_id=u.id);


/* QUESTION 6:  Percentage of users commented on all photos and Percentage of users 
not commented on any photo*/

SELECT ROUND(
(SELECT COUNT(*)  FROM (
SELECT user_id FROM comments GROUP BY user_id 
HAVING COUNT(*)=(SELECT COUNT(*) FROM photos)) A )*100/(SELECT COUNT(*) FROM users),2)
 "% users commented on all photos",
ROUND(
(SELECT COUNT(id) as cnt  FROM users 
WHERE id NOT IN (SELECT DISTINCT user_id FROM comments))*100/(SELECT COUNT(*) FROM users),2) 
"% users never commented in any photo";


/*QUESTION 7:A brand wants to know which hashtag  to use on a  post and find the top 5 most used hashtags*/
SELECT t.tag_name,count(*) times_used FROM 
photo_tags p INNER JOIN tags t ON t.id=p.tag_id 
GROUP BY t.tag_name ORDER BY count(*) DESC LIMIT 5;


/*QUESTION 8:Find the users who have created instagramid in MAY and select top 5 newest joinees from it */

SELECT * FROM users WHERE 
MONTHNAME(created_at)='may' 
ORDER BY created_at DESC LIMIT 5;

/*QUESTION 9:To find out if there are any bots, find users who have liked every single photo in the site.*/

SELECT u.username FROM likes l 
INNER JOIN users u ON u.id=l.user_id
GROUP BY u.username 
HAVING COUNT(*)=(SELECT COUNT(*) FROM photos);

 /*QUESTION 10:Can you help me find the users whose name starts with c and ends with any number and have posted
 the photos as well as liked photos?*/

SELECT * FROM users u WHERE u.username 
REGEXP '^c.*[0-9]$' AND 
0<(SELECT COUNT(*) FROM photos where user_id=u.id) 
AND 0<(SELECT COUNT(*) FROM likes where user_id=u.id);

/*QUESTION 11:Demonstrate the top 30 usernames to the company who posted photos in the range of 3 to 5*/

SELECT * FROM users u  WHERE 
(SELECT COUNT(*) FROM photos WHERE user_id=u.id) 
BETWEEN 3 AND 5 LIMIT 30;



