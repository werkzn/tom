/*1. Создать таблицу exam с полями
     идентификатор экзамена, автоинкрементируемый, запрещает NULL
     наименование экзамена
     даты экзамена
*/
create table  exam 
(
exam_id serial unique not null,
exam_name varchar,
exam_date date
);

--2. Удалить ограничение уникальности с поля идентификатора
alter table exam 
drop constraint exam_exam_id_key;

--3. Добавить ограничение первичного ключа на поле идентификатора
alter table exam 
add primary key (exam_id);

/*4. Создать таблицу person с полями
	идентификатор личности (простой int первичный ключ)
	имя
	фамилия
*/
create table person
(
person_id int primary key,
first_name varchar(36),
last_nama varchar(36)
);

/*5. Создать таблицу паспорта с полями
 	идентификатор паспорта (простой int первичный ключ)
 	серийный номер, запрещает NULL
 	регистрация
 	ссылка на идентификатор личности (внешний ключ)
 */
create table passport 
(
passport_id int primary key,
serial_number varchar(20) not null,
registration_date date,
person_id int, 
constraint fk_person_id foreign key(person_id) references person(person_id)
);

--6. Добавить колонку веса в таблицу teacher с ограничением, проверяющим вес (больше 0, но меньше 100)
alter table teacher 
add column weight int constraint chk_teacher_weight check (weight >0 and weight <100);

--7. Убедиться, что ограничение на вес работает (вставить невалидное значение)
insert into teacher 
(first_name, last_name, birth_date, phone, title, weight)
values
('John', 'Malkovich', '1987-03-25', '45678901', 'boss', -50);

/*8. Создать таблицу student с полями
	идентификатор (автоинкремент)
	полное имя
	курс (по умолчанию 1)
*/
create table student
( 
student_id int generated always as identity not null,
full_name varchar(64),
grade int default 1
);

--9. Вставить запись в таблицу студентов и убедиться, что ограничение работает
insert into student
(full_name)
values
('Lacey Stivens');

--10. Удалить ограничение по умолчанию из таблицы student
alter table student 
alter column grade
drop default;

--11. Подключиться к nordwind и добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
alter table products
add constraint chk_unit_price check (unit_price >0);

--12. Навесить автоинкрементируемый счетчик на поле product_id таблицы products. Счетчик должен начинаться с числа следующего за максимальным значением по этому столбцу
alter table products 
alter column product_id 
add generated always as identity (restart with 78);

--13. Произвести вставку в products (не вставляя идентификатор явно) и убедиться, что автоинкремент работает
insert into products 
(product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued)
values
('test product', 1, 1, '1.5', 2.5, 6, 1, 1, 0)
returning product_id;



