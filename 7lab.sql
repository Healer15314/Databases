--1
	--We can use clob(character large object)-object is a large collection of character data
	--for text and e.t.c.
	-- and blob(binary large object)- object is a large collection of uninterpreted binary data.
	-- for image, videos
	--2
	--Roles are created by users (usually administrators) and are used to group together privileges or other roles.
	-- They are a means of facilitating the granting of multiple privileges or roles to users.
	--A user privilege is a right to execute a particular type of SQL statement,
	-- or a right to access another user's object
	--User is someone who can log in and is a member of one or more groups


Create role administrator;
Create role support;
Create role accountant;	
grant select on trans to accountant;
grant select on cust to support;
grant select, update,   on acc to administrator;
create user Arman with password 'SIUUU';
create user Tleusher;
create user Ronaldo;
grant accountant to Arman,Tleusher;
grant support to Ronaldo;
grant administrator to Arman;
alter role support createrole;
revoke select on trans from accountant;

--3
ALTER TABLE customers
ALTER COLUMN birth_date SET NOT NULL,
ALTER COLUMN name SET NOT NULL;

ALTER TABLE accounts
ALTER COLUMN customer_id SET NOT NULL,
ALTER COLUMN currency SET NOT NULL;

ALTER TABLE transactions
ALTER COLUMN date SET NOT NULL,
ALTER COLUMN status SET NOT NULL;

--4
create domain ir as varchar(3);
ALTER TABLE 
accounts ALTER column currency TYPE ir;
--5
create unique index index1 on accounts (customer_id,currency);
insert into accounts values ('AB111',695,'KZT',10,0); ---should be error

--5.2
create index find_accounts on accounts(currency,balance);
create index find_by_sender on transactions(src_account);
create index find_by_recipient on transactions(dst_account);

--6
do
$$
begin
	insert into transactions values (5,now(),'AB0000','NK1111',50,'init');
	begin
		update accounts set balance = balance - 50 where account_id = 'AB10203';
		update accounts set balance = balance + 50 where account_id = 'NK90123';
update transactions set status = 'commited' where id = 5;	
exception
	 when others then 
		update transactions set status = 'rollback' where id = 5;
end;
end $$;


ALTER TABLE accounts ADD CONSTRAINT limit_check CHECK (balance > "limit");

do
$$
begin 
update accounts set balance = balance + 50 where account_id = 'AB0000';
commit; end $$;

do 
$$ begin 
	update accounts set balance = balance + 50 where account_id = 'AB0000';
rollback; commit;
end $$;
