--1. Создать таблицу teacher с полями teacher_id serial, first_name varchar, last_name varchar, birthday date, phone varchar, title varchar
create table teacher
(
teacher_id serial,
first_name varchar,
last_name varchar,
birthday date,
phone varchar,
title varchar
);

--2. Добавить в таблицу колонку middle_name varchar
alter table teacher
add column middle_name varchar;

--3. Удалить колонку middle_name
alter table teacher 
drop column middle_name;

--4. Переименовать колонку birthday в birth_date
alter table teacher 
rename column birthday to birth_date;

--5. Изменить тип данных колонки phone на varchar(32)
alter table teacher 
alter column phone set data type varchar(32);

--6. Создать таблицу exam с полями exam_id serial, exam_name varchar(256), exam_date date
create table exam 
(
exam_id serial,
exam_name varchar(256),
exam_date date
);

--7. Вставить три любых записи с учетом автогенерации идентификатора
insert into exam (exam_name, exam_date)
values
	('math', '2024-02-28'),
	('geography', '2024-03-01'),
	('science', '2024-03-04');

--8. Посредством полной выборки убедиться, что данные были сгенерированы с автоинкрементом
select * from exam;

--9. Удалить все данные из таблицы exam со сбросом автоинкремента
truncate table exam restart identity;

