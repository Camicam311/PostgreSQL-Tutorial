
-- basic statement--
SELECT *
FROM students;

-- which Weasley's are at Hogwarts right now? --
SELECT *
FROM students 
WHERE last_name = 'Weasley';

-- order the Weasleys by their years, descending-- 
SELECT first_name, last_name, year
FROM students
WHERE last_name = 'Weasley'
ORDER BY year DESC;

-- find the older Weasleys (year 5 or above) --
SELECT first_name, last_name, year
FROM students
WHERE last_name = 'Weasley' 
AND year
BETWEEN 5 AND 7;

-- who are we uncertain of their year or house -- 
SELECT * 
FROM students 
WHERE year IS NULL
OR house_id IS NULL;


-- find professors whose names start with s -- 
SELECT * 
FROM professors
WHERE prof_name LIKE 'S%';

-- how many people are in Dumbledore's Army? --
SELECT COUNT(*)
FROM dums_army;

-- how many female and male students? - 
SELECT sex, COUNT(*)
FROM students
GROUP BY sex;

-- which house has more than 10 students in it? -- 
SELECT house_id
FROM students
GROUP BY house_id
HAVING COUNT(first_name) > 10;

-- inner join syntax --
SELECT *
FROM table1
INNER JOIN table2
USING (id);

-- left join syntax -- 
SELECT *
FROM table1
LEFT JOIN table2
USING (id);

-- right join syntax -- 
SELECT *
FROM table1
RIGHT JOIN table2
USING (id);

-- full join syntax -- 
SELECT *
FROM table1
FULL JOIN table2
USING (id);

-- cross join syntax--
SELECT *
FROM table1
CROSS JOIN table2;

-- INNER JOIN professors and classes --
SELECT *
FROM professors
INNER JOIN classes
USING (prof_id);

-- which teacher teaches Defense Against the Dark Arts? --
SELECT prof_name
FROM professors
INNER JOIN classes
USING (prof_id)
WHERE class_name = 'Defense Against the Dark Arts';

-- how many students are in Gryffindor? --
SELECT COUNT(*)
FROM students AS s
INNER JOIN houses AS h
ON s.house_id = h.house_id
WHERE house_name = 'Gryffindor';

-- students LEFT JOIN blood_line --
SELECT *
FROM students
LEFT JOIN blood_line
USING (student_id);

-- are all Slytherins purebloods? -- 
SELECT first_name, blood_type, house_name
FROM students
LEFT JOIN blood_line
USING (student_id)
INNER JOIN houses
USING (house_id)
WHERE house_name = 'Slytherin' AND
	(blood_type != 'pure' 
	OR blood_type ISNULL);

-- equivalent--
SELECT first_name, blood_type, house_name
FROM blood_line
RIGHT JOIN students
USING (student_id)
INNER JOIN houses
USING (house_id)
WHERE house_name = 'Slytherin' AND
	(blood_type != 'pure'
	OR blood_type ISNULL);

-- how many teachers are classified as new, some experience, and much experience --
SELECT COUNT(*),
	CASE WHEN num_years>0 AND num_years<=5 THEN 'new'
	WHEN num_years>5 AND num_years<=15 THEN 'some experience'
	ELSE 'much experience' END
	AS experience_level
FROM professors
GROUP BY experience_level;

-- which professors taught for longer than the average? --
SELECT prof_name
FROM professors
WHERE num_years >
	(SELECT AVG(num_years)
	FROM professors);

-- union dums_array with inquisitorial_squad -- 
SELECT *
FROM dums_army
UNION
SELECT *
FROM inquisitorial_squad);

-- who is not in Dumbledore's Army nor in the Inquisitorial Squad? --
SELECT first_name, last_name
FROM students
WHERE student_id NOT IN 
	(SELECT student_id
	FROM dums_army
	UNION
	SELECT student_id
	FROM inquisitorial_squad);

-- which class is Harry taking but not Hermione? -- 
SELECT class_id, class_name
FROM classes
INNER JOIN enrollment
USING (class_id)
WHERE student_id = 1
EXCEPT
SELECT class_id, class_name
FROM classes
INNER JOIN enrollment
USING (class_id)
WHERE student_id = 3;

-- how many students are in each house? --
SELECT house_name,
	(SELECT COUNT(*)
	FROM students
	WHERE houses.house_id = students.house_id) AS num_students
FROM houses;

-- how many students are enrolled in each class? --
SELECT class_name, subquery.num_students
FROM classes,
	(SELECT class_id, COUNT(student_id) AS num_students
	FROM enrollment
	GROUP BY class_id) AS subquery
WHERE classes.class_id = subquery.class_id;
