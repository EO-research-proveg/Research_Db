/* An attempt to design a database structure for events */
/* EO 5/3/2019   */


USE db328878_45 ;

DROP TABLE IF EXiSTS Proveg_events ;

CREATE TABLE Proveg_events (
	proveg_event_id INTEGER NOT NULL AUTO_INCREMENT,
	event_id INT NOT NULL,
	cost_center_id INT NOT NULL,
	responsible_person INT NOT NULL,
	ProVeg_role VARCHAR(255) NOT NULL,
	PRIMARY KEY (proveg_event_id)
);


/* This is kind of the master list of relevant events proveg is aware of and considers participating at */

DROP TABLE IF EXiSTS Events_by_others;
CREATE TABLE Events_by_others (
	event_by_others_id INT NOT NULL,
	event_id INT NOT NULL,
	participation_status VARCHAR(50),
	organizer VARCHAR(255),
	participation VARCHAR(255) NOT NULL,
	link_to_info VARCHAR(255) NOT NULL,
	PRIMARY KEY (event_by_others_id)
);

DROP TABLE IF EXiSTS All_events;
CREATE TABLE All_events (
	event_id INT NOT NULL AUTO_INCREMENT,
	event_type VARCHAR(255) NOT NULL ,
	event_startdate DATE NOT NULL ,
	event_enddate DATE NOT NULL ,
	event_country VARCHAR(255) ,
	event_city VARCHAR(255) ,
	event_name VARCHAR(255) NOT NULL ,
	event_location VARCHAR(255) ,
	PRIMARY KEY (event_id)
);

DROP TABLE IF EXiSTS Personel;
CREATE TABLE Personel (
	person_id INT NOT NULL AUTO_INCREMENT,
	person_firstname VARCHAR(255) NOT NULL,
	person_lastname VARCHAR(255) NOT NULL ,
	ProVeg_type VARCHAR(255) NOT NULL,
	Proveg_dept VARCHAR(255) ,
	proveg_employee BINARY NOT NULL DEFAULT 1,
	PRIMARY KEY (person_id)
);

/* employers have different roles=: speaker, responsible organizer, workshop facilitator, chef etc */
DROP TABLE IF EXiSTS Engagements ;
CREATE TABLE Engagements (
	task_id INT NOT NULL AUTO_INCREMENT,
	person_id INT NOT NULL,
	role_type VARCHAR(255) NOT NULL,
	PRIMARY KEY (task_id)
);


/* One big event consists of many smaller subevents */
DROP TABLE IF EXiSTS Subevents ;
CREATE TABLE Subevents (
	id INT NOT NULL AUTO_INCREMENT,
	starttime DATETIME NOT NULL,
	endtime DATETIME NOT NULL,
	status DATETIME NOT NULL,
	activity_type VARCHAR(255) NOT NULL,
	title VARCHAR(255) NOT NULL,
	topic TEXT NOT NULL,
	parent_event INT NOT NULL,
	responsible_person INT NOT NULL,
	audience_type VARCHAR(255),
	audience_nbr VARCHAR(255) NOT NULL,
	PRIMARY KEY (id)
);

/* speaker, organizier, chef, facilitator, */
DROP TABLE IF EXiSTS Roles ;
CREATE TABLE Roles (
	role_id INTEGER NOT NULL AUTO_INCREMENT,
	role_name VARCHAR(100) NOT NULL,
	PRIMARY KEY (role_id)
);

/*Workshop, cooking workshop, meeting, networking event, etc What did ProVeg DO at an subevent */
DROP TABLE IF EXiSTS Activities;
CREATE TABLE Activities (
	activity_type VARCHAR(100) NOT NULL,
	activity_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (activity_type)
);


/* It would be smart to keep track of what kind of role ProVeg had in arranging different events */
CREATE TABLE Event_cooprerations (
	cooperation_id INT NOT NULL AUTO_INCREMENT,
	proveg_role VARCHAR (255) NOT NULL,
	PRIMARY KEY (cooperation_id)
);


/* Consulting is more of a process than an event. Perhaps a series of events */
CREATE TABLE Consulting (
	consulting_id INT NOT NULL
);



/* After the constraints are added it is difficult to drop tables, without removing the constraints first. */
/* In some ways it might be better to add the constraints into the forms... but if forms are automatically created it might not work */

ALTER TABLE Proveg_events ADD CONSTRAINT proveg_events_fk0 FOREIGN KEY (event_id) REFERENCES all_events(event_id);

ALTER TABLE Proveg_events ADD CONSTRAINT proveg_events_fk1 FOREIGN KEY (responsible_person) REFERENCES Personel(person_id);

ALTER TABLE Events_by_others ADD CONSTRAINT Events_by_others_fk0 FOREIGN KEY (event_id) REFERENCES all_events(event_id);

ALTER TABLE Engagements ADD CONSTRAINT engagements_fk0 FOREIGN KEY (person_id) REFERENCES Personel(person_id);

ALTER TABLE Engagements ADD CONSTRAINT engagements_fk1 FOREIGN KEY (role_type) REFERENCES roles(role_id);

ALTER TABLE Subevents ADD CONSTRAINT subevents_fk0 FOREIGN KEY (activity_type) REFERENCES activities(activity_type);

ALTER TABLE Subevents ADD CONSTRAINT subevents_fk1 FOREIGN KEY (parent_event) REFERENCES all_events(event_id);

ALTER TABLE Subevents ADD CONSTRAINT subevents_fk2 FOREIGN KEY (responsible_person) REFERENCES engagements(task_id);

