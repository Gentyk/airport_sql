create or replace procedure buy_ticket(
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
	--если все хорошо и пользователя нет в базе данных	
		DBMS_OUTPUT.PUT_LINE('error: ou do not have a database');
		DBMS_OUTPUT.PUT_LINE('please reqister');
		return;		
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

	--считываем количество доступных билетов на рейс
	select quantity into i 
	from ticket
	where flight=flight_1;

	--если количество рейсов меньше, то выводим ошибку
	if i<quantitu_1 then
		DBMS_OUTPUT.PUT_LINE('error: no such number of flights');
		return;
	end if;

	--если все хорошо и пользователь есть в базе данных
	--увеличили билеты клиенту
	update client		
	set ticket_num=ticket_num+quantitu_1
	where passport=passport_1;

	--уменьшаем количество билетов в таблице билеты
	update ticket
	set quantity=quantity-quantitu_1
	where flight=flight_1;
	
	--проверяем есть ли уже у пользователя билеты на этот рейс
	select case
	when exists
	(select * from control where passport_cl=passport_1 and flight_cl=flight_1)
	then 'Y'
	else 'N'
	end into flag3
	from dual;

	if flag3='N' then
		--если пользователя нету, то создаем запись новую для этого пользователя
		INSERT INTO control(
		passport_cl,
		flight_cl,
		luggage_weight,
		luggage_hand,
		registration,
		tick_num
		) values
		(passport_1,flight_1,0,'-','no',quantitu_1);
	else
		--если уже есть билеты на рейс, то добавляем к количеству , которое было
		update control
		set tick_num=tick_num+quantitu_1
		where passport_cl=passport_1 and flight_cl=flight_1;			
	end if;		

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
		set miles=miles+quantitu_1*5000
		where passport_b=passport_1;
	end if;	
		
	DBMS_OUTPUT.PUT_LINE('Succesful operation');
 	
	commit;	
end buy_ticket;
/
