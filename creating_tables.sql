DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS blood_line CASCADE;
DROP TABLE IF EXISTS dums_army
 CASCADE;
DROP TABLE IF EXISTS houses CASCADE;
DROP TABLE IF EXISTS professors
 CASCADE;
DROP TABLE IF EXISTS classes CASCADE;
DROP TABLE IF EXISTS enrollment


 CASCADE;
DROP TABLE IF EXISTS inquisitorial_squad CASCADE;

CREATE TABLE houses (

	house_id INT PRIMARY KEY,

	house_name VARCHAR(50)
);



CREATE TABLE students (
	
	student_id INT PRIMARY KEY,
	
	first_name VARCHAR(50),
	
	last_name VARCHAR(50),
	
	sex VARCHAR(1),
	year INT,

	house_id INT REFERENCES houses (house_id)

);



CREATE TABLE blood_line (

	student_id INT REFERENCES students(student_id),

	mother VARCHAR(50),

	father VARCHAR(50),

	blood_type VARCHAR(50)

);


CREATE TABLE dums_army (

	student_id INT REFERENCES students(student_id),

	house_id INT REFERENCES houses(house_id)

);



CREATE TABLE inquisitorial_squad (

	student_id INT REFERENCES students(student_id),

	house_id INT REFERENCES houses(house_id)

);



CREATE TABLE professors (

	prof_id INT PRIMARY KEY,

	prof_name VARCHAR(50),

	num_years INT

);



CREATE TABLE classes (

	class_id INT PRIMARY KEY,

	class_name VARCHAR(50),

	prof_id INT REFERENCES professors(prof_id)

);




CREATE TABLE enrollment (

	class_id INT REFERENCES classes(class_id)
,
	student_id INT REFERENCES students(student_id)
);

