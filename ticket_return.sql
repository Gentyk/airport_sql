create or replace procedure ticket_return(
passport_1 in number,
flight_1 in number,
quantitu_1 in number)
is
flag1 varchar(10);
flag2 varchar(10);
flag3 varchar(10);
i number;
name varchar(10);
begin
        --проверка по паспорту
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
	end if;	

	--проверка рейса
	select case
	when exists
	(select * from ticket where flight=flight_1)
	then 'Y'
	else 'N'
	end into flag2
	from dual;

	--если рейса не существует, то предупрежение с ошибкой
	if flag2='N' then
		DBMS_OUTPUT.PUT_LINE('error:there is not such flight');
		return;
	end if;


	--проверка рейса в таблице control  для данного пользователя
	select case
	when exists
	(select * from control where flight_cl=flight_1 and passport_cl=passport_1)
	then 'Y'
	else 'N'
	end into flag2
	from dual;

	--если у пользователя нету рейса в control, то сорян
	if flag2='N' then
		DBMS_OUTPUT.PUT_LINE('error:there is not such flight(first)');
		return;
	end if;

	--считываем количество  билетов у пользователя
	select ticket_num into i 
	from client
	where  passport=passport_1;

	--если количество билетов меньше,чем у него есть, то выводим ошибку
	if i<quantitu_1 then
		DBMS_OUTPUT.PUT_LINE('error: client had not so many tickets');
		return;
	end if;

        --считываем количество  билетов - хватит ли их(control)
	select tick_num into i
	from control
	where  flight_cl=flight_1 and passport_cl=passport_1;

	--если количество билетов меньше,чем у него есть, то выводим ошибку
	if i<quantitu_1 then
		DBMS_OUTPUT.PUT_LINE('error: flight had not so many tickets');
		return;
	end if;











	--если все хорошо и пользователь есть в базе данных
	--уменьшаем количество билетов в control
	if i=quantitu_1 then
	--если билетов одинаковое количество, то просто удаляем запись
		delete from control
		where passport_1=passport_cl and flight_cl=flight_1;
	else
		update control
		set tick_num=tick_num-quantitu_1
		where passport_1=passport_cl and flight_cl=flight_1;
	end if; 

	
	--уменьшили билеты клиенту(client)
	update client		
	set ticket_num=ticket_num-quantitu_1
	where passport=passport_1;

	--увеличили количество билетов в таблице билеты
	update ticket
	set quantity=quantity+quantitu_1
	where flight=flight_1;
		
	--уменьшаем расстояние налета
	--проверка по паспорту в бонусах
	select case
	when exists
	(select * from bonus where passport_b=passport_1)
	then 'Y'
	else 'N'
	end into flag1
	from dual;

	if flag1='Y' then
		--увеличиваем расстояние налета
		update bonus
		set miles=miles-quantitu_1*5000
		where passport_b=passport_1;
	end if;	
	
	
	commit;	
end ticket_return;
/
