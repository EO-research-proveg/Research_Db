/* Export insights from Campaign Monitor as CSV
OPEN IN Office Calc - save as CSV (excel does not put "" around all text values only if there is a space. 
so there are lots of import errors because of commas used in value fields.
Run this script.
The problem remaining is how to connect to this file.
EO 26.3.2019

*/

USE db328878_45 ;

/* IF EXIST Table Newsletters */

TRUNCATE Newsletters;


													
/* LOAD DATA LOW_PRIORITY LOCAL INFILE 'C:\\Users\\eolli\\Downloads\\NewsletterList.txt' 
          INTO TABLE `Proveg_test1`.`Newsletters` 
			 FIELDS TERMINATED BY ',' 
			 OPTIONALLY ENCLOSED BY '"' 
			 LINES TERMINATED BY '\r\n' 
			 (`campaign_name`, 
			  `date_sent_text`,
			  `recipients`, 
			  `opens`, 
			  `clicks`, 
			  `bounces`, 
			  `unsubscribes`, 
			  `complaints`);
*/

TRUNCATE TABLE `Newsletters`;

/*
LOAD DATA LOW_PRIORITY LOCAL INFILE '\\\\VEBUFILER01\\KPIImpact\\KPI-Impact\\Public Information\\Newsletter_list_LibreOff.csv' 
                      INTO TABLE `Proveg_test1`.`Newsletters` 
							 FIELDS TERMINATED BY ',' 
							 OPTIONALLY ENCLOSED BY '"' 
							 LINES TERMINATED BY '\r\n' 
							 IGNORE 1 LINES (
							 `newsletter_type`, `newsletter_name`, `campaign_name`, `sent_weekday`, `sent_date`, `date_sent_text`, `time_sent`, 
							 `article_1_topic`, `article_1_link`, `article_2_topic`, `article_2_link`, `article_3_topic`, `article_3_link`, 
							 `article_4_topic`, `article_4_link`, `article_5_topic`, `article_5_link`, `article_6_topic`, `article_6_link`, `note`) ;

*/

LOAD DATA LOW_PRIORITY LOCAL INFILE '\\\\VEBUFILER01\\KPIImpact\\KPI-Impact\\Public Information\\Newsletter_list_LibreOff.csv' 
          INTO TABLE `Proveg_test1`.`Newsletters` 
			 FIELDS TERMINATED BY ',' 
			 OPTIONALLY ENCLOSED BY '"' 
			 LINES TERMINATED BY '\r\n' 
			 IGNORE 1 LINES 
			 (`newsletter_type`, `newsletter_name`, `campaign_name`, `sent_weekday`, `sent_date`, `date_sent_text`,`time_sent`, 
			   `recipients`,`Open_rate`,`Opens`,`Click_rate`,`Clicks`,`Bounce_rate`,`Bounces`,`Unsubscribe_rate`,`Unsubscribes`,`Complaint_rate`,`Complaints`,
			   `Article_1_topic`,`Article_1_link`,`Article_1_clicks`,`Article_2_topic`,`Article_2_link`,`Article_2_clicks`,
				`Article_3_topic`,`Article_3_link`,`Article_3_clicks`,`Article_4_topic`,`Article_4_link`,`Article_4_clicks`,
				`Article_5_topic`,`Article_5_link`,`Article_5_clicks`,`Note`) ;
				
SHOW WARNINGS;

DELETE FROM Newsletters
 WHERE campaign_name = '';							

SELECT * 
  FROM Newsletters
  ORDER BY newsletter_id;
  
SELECT *
FROM Newsletters
WHERE date_sent_text NOT REGEXP '^[0-9]{2} [a-z]{3} [0-9]{4}$';


/* ALTER TABLE Newsletters_copy
 MODIFY COLUMNS sent_date FORMAT ('%d %b %Y'); */

/*
UPDATE Newsletters
 SET  sent_date = STR_TO_DATE(date_sent_text, '%d %b %Y') 
  WHERE NOT ISNULL(date_sent_text); 

UPDATE Newsletters_copy
 SET  sent_weekday = DATE_FORMAT(sent_date, '%a') 
  WHERE NOT ISNULL(sent_date); 
*/

UPDATE Newsletters
 SET  open_rate = opens/(recipients - bounces)  
  WHERE recipients <> 0; 
  
UPDATE Newsletters
 SET  click_rate = clicks/opens 
  WHERE opens <> 0; 
  
UPDATE Newsletters
 SET  bounce_rate = bounces/recipients 
  WHERE clicks <> 0; 

UPDATE Newsletters
 SET  unsubscribe_rate = unsubscribes/(recipients - bounces)
  WHERE clicks <> 0; 
  
UPDATE Newsletters
 SET  complaint_rate = complaints/(recipients - bounces)
  WHERE clicks <> 0; 
  

 

SELECT newsletter_type, COUNT(newsletter_type)
    FROM Newsletters
	 GROUP BY newsletter_type
	 ;

SELECT newsletter_type, COUNT(newsletter_type) , YEAR(sent_date) as year_sent
    FROM Newsletters
	 GROUP BY newsletter_type, year_sent
	 ;
	 
SELECT COUNT(campaign_name) 
    FROM Newsletters
	 ;
	 
  
