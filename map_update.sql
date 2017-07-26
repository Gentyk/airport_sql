create or replace procedure map_update(
passport_1 in number)
is
flag1 varchar(10);
flag2 varchar(10);
card1 varchar(10);
i number;
name varchar(10);
begin
        --проверка по паспорту в общей базе клиента: чтобы направить на регистрацию в случае ошибки
	select case
	when exists
	(select * from client where passport=passport_1)
	then 'Y'
	else 'N'
	end into flag1
	from dual;

	if flag1='N' then
	        --пользователя нет в базе данных	
		DBMS_OUTPUT.PUT_LINE('error: ou do not have a database');
		DBMS_OUTPUT.PUT_LINE('please reqister');
		return;	
	end if;	

        --проверка по паспорту в общей таблице бонусов
	select case
	when exists
	(select * from bonus where passport_b=passport_1)
	then 'Y'
	else 'N'
	end into flag1
	from dual;

	if flag1='N' then
	        --пользователя нет в	
		DBMS_OUTPUT.PUT_LINE('error: ou do not have card');
		return;	
	end if;

	
	--считываем количество милей
	select miles into i 
	from bonus
	where passport_b=passport_1;

	if i<10000 then
		card1:='begin';
	end if;

	if i>=10000 and i<50000 then
		card1:='silver';
	end if;

	if i>=50000 then
		card1:='gold';
	end if;

	--изменяем карту
	update bonus		
	set card=card1
	where passport_b=passport_1;

	DBMS_OUTPUT.PUT_LINE('Succesful operation');		


end map_update;
/
