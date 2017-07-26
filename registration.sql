create or replace procedure registration(
passport_1 in number,
flight_1 in number)
is 
flag1 varchar(10);
flag2 varchar(10);
name varchar(10);
r varchar(10);
begin
	--проверка по паспорту(control)
	select case
	when exists
	(select * from control where passport_cl=passport_1 and flight_cl=flight_1)
	then 'Y'
	else 'N'
	end into flag1
	from dual;

	if flag1='N' then
	        --пользователя нет в базе данных	
		DBMS_OUTPUT.PUT_LINE('error: ou do not have a database(control)');
		return;	
	end if;	


	--проверка прошел ли регистрацию
	select registration into r
	from control
	where passport_cl=passport_1;

	if r='yes' then
		DBMS_OUTPUT.PUT_LINE('! Client has already registered!');
	else
		r:='yes';
		update control 
		set registration=r
		where passport_cl=passport_1;
		DBMS_OUTPUT.PUT_LINE('Succesful operation');
	end if;	

	
end registration;

/
