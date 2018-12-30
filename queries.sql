
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

-- which house has more than 10 characters in it? -- 
SELECT house_id
FROM students
GROUP BY house_id
HAVING COUNT(first_name) > 10;

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

-- are all Slytherins purebloods? -- 
SELECT first_name, blood_type, house_name
FROM students
LEFT JOIN blood_line
USING (student_id)
INNER JOIN houses
USING (house_id)
WHERE house_name = 'Slytherin' AND
	(blood_type != 'pure' 
	OR blood_type ISNULL)

-- equivalent--
SELECT first_name, blood_type, house_name
FROM blood_line
RIGHT JOIN students
USING (student_id)
INNER JOIN houses
USING (house_id)
WHERE house_name = 'Slytherin' AND 
	blood_type != 'pure'

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
WHERE student_id = 3

-- which classes are Hermione taking but not Harry? -- 
SELECT class_id, class_name
FROM classes
INNER JOIN enrollment
USING (class_id)
WHERE student_id = 3
EXCEPT
SELECT class_id, class_name
FROM classes
INNER JOIN enrollment
USING (class_id)
WHERE student_id = 1

-- which professors taught for longer than the average? --
SELECT prof_name 
FROM professors
WHERE num_years >
	(SELECT AVG(num_years)
	FROM professors);

-- how many teachers are classified as new, some experience, and much experience --
SELECT COUNT(*),
	CASE WHEN num_years>0 AND num_years<=5 THEN 'new'
	WHEN num_years>5 AND num_years<=15 THEN 'some experience'
	ELSE 'much experience' END
	AS experience_level
FROM professors
GROUP BY experience_level;

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


	