
--1a
SELECT * FROM dealer CROSS JOIN client;

--1b
select dealer_id1,client_id1, dealer_name, client_name,city, priority, sell.id,date,amount from
(select dealer.id as dealer_id1,client.id as client_id1, dealer.name as dealer_name, client.name as client_name, city,priority from dealer
inner join client on dealer_id=dealer.id) as arr inner join
sell on dealer_id1 = sell.dealer_id and sell.client_id = client_id1;

--1c
select dealer.name, client.name
from dealer inner join client
on dealer.location = client.city;

--1d
select sell.id, amount , client.name, client.city from
sell inner join client 
on 100<=amount and amount <=500 and client_id = client.id;

--1e
SELECT d.id, d.name, count(c.id) as num
FROM dealer d LEFT OUTER JOIN client c
ON d.id = c.dealer_id
GROUP BY d.id, d.name;

--1f
select dealer.name, client.name, charge from
client inner join dealer 
on dealer.id= dealer_id;


--1g
select client.name, client.city, dealer.name, charge
from dealer inner join client
on charge > 0.12 and dealer_id= dealer.id;

--1h
SELECT c.name, c.city,s.id,s.date,s.amount,d.name,d.charge 
FROM client c LEFT OUTER JOIN sell s ON c.id = s.client_id
    LEFT OUTER JOIN dealer d on d.id = s.dealer_id;
--1i

SELECT c.name, c.priority,d.name,s.id,s.amount
FROM client c RIGHT OUTER JOIN dealer d ON d.id=c.dealer_id
    LEFT OUTER JOIN sell s ON s.client_id= c.id
WHERE s.amount>=2000 AND c.priority IS NOT NULL;

--2a
create temp view dater as
    SELECT date,count(distinct client_id) clients,sum(amount) as total,avg(amount)
    from sell
    group by date;

select * from dater;
--drop view dater;

--2b
create view top_5 as
select  * from 
(select date, sum(amount) as tt
from sell inner join client 
on client.id= sell.client_id
group by date) as tab
order by tt DESC
limit 5;
select * from top_5;
--drop view top_5;

--2c
create view sales as
 select dealer.name, count(sell.id), avg(amount), sum(amount)
 from dealer 
inner join sell on dealer.id = sell.dealer_id
 group by dealer.name;
 select * from sales;
--drop view sales;

--2dcreate view deal_charge as
create view dater1 as
 select location, sum(amount)*(dealer.charge)
 from dealer 
 inner join sell  on dealer.id = sell.dealer_id
 group by location,charge;
 select * from dater1;
--drop view dater1;

--2e
 create view location_sales as
 select location, count(sell.id), sum(amount) as summ1, avg(amount)
 from dealer 
 inner join sell  on dealer.id = sell.dealer_id
 group by location, charge;
 select * from location_sales;
--drop view location_sales;

--2f 
create view city_sell as
 select city, count(sell.id), sum(amount) as summ2, avg(amount)
 from client 
 inner join sell on client.id = sell.client_id
 group by city;
select * from city_sell;
--drop view city_sell;
--2g
CREATE VIEW Expences AS
    SELECT *
    FROM location_sales
        INNER JOIN city_sell on location_sell.location = city_sell.city
    WHERE city_sell.summ2>location_sell.summ1;
select * from Expences;
--drop view Expences;








