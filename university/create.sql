--campus

--professor: object, varray 5

--units: varray 5 varchar2

--school

--department

--research-center

--faculty

--equipments: varray 3 varchar2 

--building

--office 

--classroom

--lab

--degree

--person

--staff

--student

--admin

--technician

--lecturer

--senior_lecturer

--associate_lecturer

--tutor

--enrolls_in

--BODY OF OFFICE -SONDOS

--subject

CREATE OR REPLACE TYPE Subject_T AS OBJECT 
(subj_id VARCHAR2(10),
subj_name VARCHAR2(50),
subj_credit VARCHAR2(10),
subj_prereq VARCHAR2(50), 
teach REF Lecturer_T,
 MEMBER PROCEDURE insert_subject
( new_subj_id IN VARCHAR2,
 new_subj_name IN VARCHAR2,

new_subj_credit IN VARCHAR2,
 new_subj_prereq IN VARCHAR2,
 new_pers_id IN VARCHAR2),
MEMBER PROCEDURE delete_subject)
/
CREATE TABLE Subject OF Subject_T 
(subj_id NOT NULL, PRIMARY KEY (subj_id));
CREATE TABLE Takes
(student REF Student_T,
subject REF Subject_T,
marks NUMBER);

CREATE OR REPLACE TYPE BODY Subject_T AS
MEMBER PROCEDURE
insert_subject( new_subj_id IN VARCHAR2,
new_subj_name IN VARCHAR2,
new_subj_credit IN VARCHAR2, 
new_subj_prereq IN VARCHAR2, 
new_pers_id IN VARCHAR2) 
IS lecturer_temp REF Lecturer_T;
BEGIN 
SELECT REF(a) INTO lecturer_temp FROM Lecturer a WHERE
a.pers_id = new_pers_id;
INSERT INTO Subject VALUES
(new_subj_id, new_subj_name, new_subj_credit, new_subj_prereq, lecturer_temp);
END insert_subject;

MEMBER PROCEDURE delete_subject IS
BEGIN 
DELETE FROM Subject
WHERE subj_id = self.subj_id;
END delete_subject;
END;
/
CREATE OR REPLACE PROCEDURE Insert_Takes
( new_pers_id IN Person.pers_id%TYPE,
new_subj_id IN Subject.subj_id%TYPE,
new_marks IN NUMBER) AS
student_temp REF Student_T;
subject_temp REF Subject_T;
BEGIN 
SELECT REF(a) INTO student_temp 
FROM Student a
WHERE a.pers_id = new_pers_id;
SELECT REF(b) INTO subject_temp FROM Subject b 
WHERE b.subj_id = new_subj_id;
INSERT INTO Takes VALUES (student_temp, subject_temp, new_marks);
 END Insert_Takes;
 /
CREATE OR REPLACE PROCEDURE Delete_Takes
( deleted_pers_id IN Person.pers_id%TYPE, deleted_subj_id IN Subject.subj_id%TYPE) AS
BEGIN 
DELETE FROM Takes 
WHERE Takes.student IN
(SELECT REF(a) FROM Student a WHERE a.pers_id = deleted_pers_id)
AND Takes.subject IN
(SELECT REF(b) FROM Subject b WHERE b.subj_id = deleted_subj_id);
END Delete_Takes;
/


--takes



