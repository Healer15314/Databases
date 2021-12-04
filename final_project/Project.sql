create table Finance(
ID int primary key not null,
cur_budget numeric not null,
date_time timestamp default current_timestamp not null);

create table Outcome(
supplier_out numeric not null,
dealer_payment numeric not null,
Finance_id integer not null references  Finance(ID) );

create table Income (
Transaction_id int primary key not null,
sale numeric not null,
options_pay numeric not null,
month varchar(15) not null,
Finance_id int not null references Finance(id));

create table Man_plant(
ID int primary key not null,
location varchar(25) not null);

create table Supplier(
ID int primary key not null,
location varchar(25) not null,
Man_plant_id int not null references Man_plant(ID));

create table Part(
Type varchar(25) primary key not null,
Quantity int not null,
Date_given date not null,
Supplier_id int not null references Supplier(ID));

create table Dealer(
ID int primary key not null,
location varchar(23) not null,
Man_plant_id int not null references Man_plant(ID));

create table Customer(
ID int primary key not null,
name varchar(25) not null,
gender char not null,
income_range numeric not null,
Dealer_id int not null references Dealer(ID));

create table Model(
ID int primary key not null,
body_style varchar(25) not null,
engine_power numeric not null,
seats_num int not null);


create table Brand(
ID int primary key not null,
budget numeric not null,
unit_sales numeric not null);

create table Vehicle(
VIN int primary key not null,
status varchar(25) not null,
date_of_man date not null,
date_of_sale date not null,
Dealer_id int not null references Dealer(ID));


create table Options(
ID integer primary key not null,
transmission varchar(15) not null,
add_seats integer not null,
cruise_control boolean not null,
engine numeric not null,
Vehicle_VIN int references Vehicle(VIN));

create table client_choice(
Vehicle_VIN int not null references Vehicle(VIN),
Brand_id int not null references Brand(ID),
Model_id int not null references Model(ID));

create table payment_info(
Income_id int not null references Income(Transaction_id),
Vehicle_VIN int not null references Vehicle(VIN));

INSERT INTO Finance(ID,cur_budget,date_time)  VALUES (101,0,now());

CREATE OR REPLACE FUNCTION update_finance()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	UPDATE finance
SET    cur_budget = cur_budget + new.sale + new. options_pay;
UPDATE brand
SET  budget = budget + new.sale + new.options_pay
where new.brand_id = id;
UPDATE brand
SET  unit_sale = new.sale + new.options_pay
where new.brand_id = id and (ew.sale + new.options_pay)>unt_sale;


	RETURN NEW;
END;
$$

CREATE TRIGGER income_update
 BEFORE INSERT
  ON Income
  FOR EACH ROW
  EXECUTE PROCEDURE update_finance();

alter table brand 
add column name varchar(30) not null;

INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id , brand_id) VALUES (11, 150, 25, 'February',101,90);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (2, 120, 25, 'March',101,90);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (3, 150, 5, 'April',101,91);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (4, 150, 40, 'April',101,92);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (5, 150, 66, 'January',101,91);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (6, 1165, 25, 'April',101,93);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (7, 778, 2, 'June',101,90);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (8, 998, 29, 'June',101,91);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (9, 567, 25, 'June',101,93);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (10, 7, 2, 'June',101,92);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (24,7, 2, 'January',101,93);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (12,87, 2, 'July',101,90);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (13,46, 2, 'July',101,91);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (14,89, 2, 'August',101,91);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (15, 7, 2, 'September',101,93);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (16,15, 2, 'October',101,92);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (17, 7, 2, 'October',101,90);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (18, 7, 2, 'October',101,90);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (19,456,2, 'November',101,91);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (20,555,2, 'November',101,93);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (21,69, 2, 'November',101,91);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (22,77, 2, 'December',101,90);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id, brand_id)  VALUES (23, 7, 2, 'December',101,92);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id , brand_id) VALUES (25, 150, 25, 'February',101,90);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id , brand_id) VALUES (26, 10, 25, 'March',101,90);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id , brand_id) VALUES (27, 56, 25, 'April',101,90);
INSERT INTO Income(Transaction_id, sale, options_pay, Month, Finance_id , brand_id) VALUES (28, 15, 25, 'June',101,90);



INSERT INTO Brand (id, budget , unit_sales,name) values (90,0,0, 'Mazeratti');
INSERT INTO Brand (id, budget , unit_sales,name) values (91,0,0,'Kia');
INSERT INTO Brand (id, budget , unit_sales,name) values (92,0,0,'Toyota');
INSERT INTO Brand (id, budget , unit_sales,name) values (93,0,0,'Jet');


create or replace function month_brand(mon varchar(30))
returns table(
count bigint , month varchar, name varchar)
language plpgsql
as
$$   
begin
   return query
		select count(brand_id), brand.name, income.month
		from brand inner join income on brand.id = income.brand_id
									   group by brand.name, income.month
									  	 	having income.month = mon
											order by count desc
											limit 2;
end;
$$;

select * from month_brand('October');

select count(brand.id), brand.name
from brand inner join income on income.brand_id = brand.id
group by name
order by count desc
limit 2;


create or replace function month_brand11(mon varchar(30))
returns table(
sum numeric,name varchar,month varchar)
language plpgsql
as
$$   
begin
   return query
		select sum(income.sale), brand.name,income.month
			from brand inner join income on brand.id= income.brand_id
				group by brand.name, income.month
					having income.month = mon
						order by sum desc
							limit 2;
end;
$$;

select * from month_brand1('October');



select sum(income.sale + income.options_pay), brand.name 
from brand inner join income on income.brand_id = brand.id
group by name
order by sum desc
limit 2;



select name, unit_sales from brand;
order by unit_sales desc
limit 2;

select customer.name,customer.gender, customer.income_range,income.sale,income.options_pay, income.month
from customer inner join dealer on dealer.id = customer.dealer_id
	inner join vehicle on vehicle.dealer_id =  dealer.id
		inner join payment_info on vehicle.vin =  payment_info.vehicle_vin
			inner join income on income.transaction_id = payment_info.income_id;


alter table part
add column Vehicle_VIN int not null references Vehicle(VIN);


INSERT INTO  Man_plant(id, location) VALUES (8708, 'Almaty');
INSERT INTO Man_plant (id, location) VALUES (8709, 'Shymkent');

INSERT INTO dealer(id, location,man_plant_id) VALUES (60, 'Almaty',8708);
INSERT INTO dealer(id, location,man_plant_id) VALUES (61, 'Astana',8708);
INSERT INTO dealer(id, location,man_plant_id) VALUES (62, 'Atyrau',8709);
INSERT INTO dealer(id, location,man_plant_id) VALUES (63, 'Semey',8709);

insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5007,'at dealer','2012-12-05','2040-01-01',60);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5001,'sold','2012-09-05','2012-11-03',61);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5002,'at dealer','2012-12-05','2040-01-01',62);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5003,'sold','2012-06-23','2012-06-29',60);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5004,'at dealer','2012-11-03','2040-01-01',63);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5005,'sold','2012-04-04','2012-05-01',61);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5006,'at dealer','2012-11-11','2040-01-01',62);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5000,'at dealer','2012-12-05','2013-01-05',60)
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5008,'at dealer','2012-06-09','2040-01-01',60);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5009,'sold','2012-01-01','2012-03-26',61);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5010,'at dealer','2011-11-11','2040-01-01',62);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5011,'sold','2012-06-23','2012-07-29',60);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5012,'at dealer','201-09-25','2040-01-01',63);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5013,'sold','2012-12-12','2013-01-01',61);
insert into vehicle(vin,status,date_of_man,date_of_sale,dealer_id) values (5014,'at dealer','2011-06-11','2040-01-01',62);

insert into supplier(id,location,man_plant_id) values (55,'Almaty',8708);
insert into supplier(id,location,man_plant_id) values (56, 'Shymkent',8709);
insert into supplier(id,location,man_plant_id) values (57,'Issyk',8708);
insert into supplier(id,location,man_plant_id) values (58,'Almaty',8709);


insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('engine cover', 10, '2012-05-19',56,5002);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('strut brace', 1, '2012-01-19',57,5004);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('air intake', 25, '2012-02-19',56,5006);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('beam', 60, '2012-03-19',58,5014);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('toe link', 15, '2012-04-19',56,5003);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('roof rail', 20, '2012-06-19',55,5001);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('cross rail', 80, '2012-05-19',56,5010);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('rockers', 90, '2012-07-19',57,5010);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('door handle', 100, '2012-08-19',56,5005);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('brake light', 90, '2012-09-19',55,5012);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('bonnet', 50, '2012-10-19',58,5013);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('bumper', 50, '2012-10-19',57,5013);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('mirror', 50, '2012-10-19',58,5008);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('wheel', 50, '2012-10-19',56,5003);
insert into part(type,quantity,Date_given,Supplier_id,vehicle_vin) values ('seats', 50, '2012-10-19',55,5001);

create or replace function def(dated1 date, dated2 date)
	returns table (
		VIN int,
		Date_def date,
		type varchar
	) 
	language plpgsql
as $$
begin
	return query 	
	select vehicle.vin, part.date_given,part.type
	from vehicle inner join part 
	on vehicle.vin = part.vehicle_vin and part.date_given between dated1 and dated2;
end;$$

select distinct * from def('2012-01-01','2012-05-11')

select vin, age(date_of_man, date_of_sale) as inventory_time,status
from vehicle 
where status = 'sold'
group by vin,inventory_time,status
order by inventory_time asc;

insert into model(id, body_style, engine_power, seats_num) values (1 , 'convertibles',3.5 , 6);
insert into model(id, body_style, engine_power, seats_num) values (2 , 'convertibles',3 , 6);
insert into model(id, body_style, engine_power, seats_num) values (3 , 'convertibles', 4, 6);
insert into model(id, body_style, engine_power, seats_num) values (4 , 'convertibles',2.5 , 6);
insert into model(id, body_style, engine_power, seats_num) values (5 , 'convertibles',1.5 , 6);
insert into model(id, body_style, engine_power, seats_num) values (6 , 'convertibles', 2 , 6);
insert into model(id, body_style, engine_power, seats_num) values (7 , 'hatchback',3.5 , 6);
insert into model(id, body_style, engine_power, seats_num) values (8 , 'hatchback',4  , 4);
insert into model(id, body_style, engine_power, seats_num) values (9 , 'hatchback',3 , 4);
insert into model(id, body_style, engine_power, seats_num) values (10 , 'hatchback',2.5 , 6);
insert into model(id, body_style, engine_power, seats_num) values (11 , 'hatchback', 2 , 4);
insert into model(id, body_style, engine_power, seats_num) values (12 , 'coupe',3.5 , 6);
insert into model(id, body_style, engine_power, seats_num) values (13 , 'coupe',4  , 4);
insert into model(id, body_style, engine_power, seats_num) values (14 , 'coupe',3 , 4);
insert into model(id, body_style, engine_power, seats_num) values (15 , 'coupe',2.5 , 6);
insert into model(id, body_style, engine_power, seats_num) values (16 , 'coupe', 2 , 4);

insert into client_choice(vehicle_vin,brand_id,model_id) values (5000,90,1);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5001,91,2);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5002,90,3);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5003,91,4);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5004,93,5);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5005,91,6);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5006,90,7);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5007,92,8);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5008,91,9);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5009,90,10);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5010,92,11);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5011,92,12);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5012,93,13);
insert into client_choice(vehicle_vin,brand_id,model_id) values (5013,93,14);

insert into payment_info(income_id,vehicle_vin) values (25,5000);
insert into payment_info(income_id,vehicle_vin) values (26,5002);
insert into payment_info(income_id,vehicle_vin) values (27,5003);
insert into payment_info(income_id,vehicle_vin) values (28,5001);
insert into payment_info(income_id,vehicle_vin) values (28,5004);


select income.month, vehicle.vin, model.body_style,income.sale,income.options_pay
from model inner join client_choice on model.id	= client_choice.model_id
	inner join vehicle on vehicle.vin = client_choice.vehicle_vin
		inner join payment_info on payment_info.vehicle_vin = vehicle.vin
			inner join income on income.transaction_id = payment_info.income_id
where model.body_style =  'convertibles'
order by income.sale + income.options_pay desc
limit 3;

insert into customer(id,name,gender,income_range,dealer_id) values (1,'Ibra','M',1555,60);
insert into customer(id,name,gender,income_range,dealer_id) values (2,'Yernar','M',155,62);
insert into customer(id,name,gender,income_range,dealer_id) values (3,'Yerlan','M',155,61);
insert into customer(id,name,gender,income_range,dealer_id) values (4,'Batyr','F',200,62);
insert into customer(id,name,gender,income_range,dealer_id) values (5,'Ulan','M',1566,60);
insert into customer(id,name,gender,income_range,dealer_id) values (6,'Sancho','F',260,62);
insert into customer(id,name,gender,income_range,dealer_id) values (7,'Ronaldo','M',131,61);
insert into customer(id,name,gender,income_range,dealer_id) values (8,'Messi','F',999,63);

select customer.name,customer.gender, customer.income_range,income.sale,income.options_pay, income.month
from customer inner join dealer on dealer.id = customer.dealer_id
	inner join vehicle on vehicle.dealer_id =  dealer.id
		inner join payment_info on vehicle.vin =  payment_info.vehicle_vin
			inner join income on income.transaction_id = payment_info.income_id;
