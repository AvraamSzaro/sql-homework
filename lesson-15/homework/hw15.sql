--1
select
	*
from employees
where salary=(select MIN(salary) from employees);
--2
select
	*
from products
where price>(select AVG(price) from products)
--alternative popular way
SELECT id, product_name, price
FROM (
    SELECT *,
           AVG(price) OVER() AS avg_price
    FROM products
) t
WHERE price > avg_price;
--3
select
	e.id,
	e.name
from employees2 e
where e.department_id in(
	select d.id
	from departments d
	where d.id in(
		select d2.id
		from departments d2
		where d.department_name='Sales'
	)
);
--4
select
	*
from customers c
where c.customer_id not in (select customer_id from orders o)
--5
select *
from products2 p
where price=(
	select MAX(price)
	from products2
	where category_id = p.category_id
);
--6
SELECT e.id, e.name, e.salary, d.department_name
FROM employees6 e
JOIN departments d ON d.id = e.department_id
WHERE e.department_id IN (
  SELECT TOP 1 WITH TIES department_id
  FROM employees6
  GROUP BY department_id
  ORDER BY AVG(salary) DESC
);
--7
SELECT *
FROM employees7 e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees7 e2
    WHERE e2.department_id = e.department_id
);
--8
select 
	*
from grades g
join students s on g.student_id=s.student_id
where g.grade = (
	select MAX(grade)
	from grades g2 
	where g2.course_id = g.course_id
	);
--9
SELECT p.id, p.product_name, p.price, p.category_id
FROM products3 p
WHERE p.price = (
  SELECT MIN(t.price)
  FROM (
    SELECT DISTINCT TOP (3) p2.price
    FROM products3 p2
    WHERE p2.category_id = p.category_id
    ORDER BY p2.price DESC
  ) AS t
);
--10
select * from employees4
where salary > (
	select AVG(salary)
	from employees4
) AND
	salary < (
	select MAX(salary)
	from employees4
);

