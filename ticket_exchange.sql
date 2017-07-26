create or replace procedure ticket_exchange(
passport_1 in number,
quantitu_1 in number,
flight_1 in number, --его меняем
flight_2 in number) --на этот
is
flag1 varchar(10);
flag2 varchar(10);
flag3 varchar(10);
i number;
i2 number;
name varchar(10);
begin
	--проверка: вдруг меняют один рейс на тот же
	if flight_1=flight_2 then	
		DBMS_OUTPUT.PUT_LINE('flight1 eq flight2');
		RETURN;	
	end if;
	
        --проверка по паспорту клиента
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
		RETURN;	
	end if;	

	--считываем количество  билетов у пользователя вообще
	select ticket_num into i 
	from client
	where  passport=passport_1;

	--если количество билетов меньше,чем у него есть, то выводим ошибку
	if i<quantitu_1 then
		DBMS_OUTPUT.PUT_LINE('error: client had not so many tickets');
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


	--проверка  второго рейса в таблице ticket
	select case
	when exists
	(select * from ticket where flight=flight_2)
	then 'Y'
	else 'N'
	end into flag2
	from dual;

	--если у пользователя нету рейса в control, то сорян
	if flag2='N' then
		DBMS_OUTPUT.PUT_LINE('error:there is not such flight(second)');
		return;
	end if;

	--считываем количество  билетов - хватит ли их(ticket)
	select quantity into i 
	from ticket
	where  flight=flight_2;

	--если количество билетов меньше,чем вообще
	if i<quantitu_1 then
		DBMS_OUTPUT.PUT_LINE('error: flight had not so many tickets');
		return;
	end if;

	--считываем количество  билетов - хватит ли их(control)
	select tick_num into i2
	from control
	where  flight_cl=flight_1 and passport_cl=passport_1;

	--если количество билетов меньше,чем у него есть, то выводим ошибку
	if i2<quantitu_1 then
		DBMS_OUTPUT.PUT_LINE('error: flight had not so many tickets');
		return;
	end if;

	--если все хорошо 

	--увеличили билеты второму рейсу (ticket)
	update ticket		
	set quantity=quantitu_1+quantity
	where flight=flight_1;
	
	--увеличваем билеты ко второму рейсу нашему пользователю ( control)
	--проверяем есть ли уже у пользователя билеты на этот рейс
	select case
	when exists
	(select * from control where passport_cl=passport_1 and flight_cl=flight_2)
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
		(passport_1,flight_2,0,'-','no',quantitu_1);
	else
		--если уже есть билеты на рейс, то добавляем к количеству , которое было
		update control
		set tick_num=tick_num+quantitu_1
		where passport_cl=passport_1 and flight_cl=flight_2;			
	end if;		


	--уменьшаем количество билетов первому рейсу(control)

	
	if i2=quantitu_1 then
	--если билетов одинаковое количество, то просто удаляем запись
		delete from control
		where passport_1=passport_cl and flight_cl=flight_1;
	else
		update control
		set tick_num=tick_num-quantitu_1
		where passport_1=passport_cl and flight_cl=flight_1;
	end if;
	

	--убавляем (ticket)
	update ticket
	set quantity=quantity-quantitu_1
	where flight=flight_2;

	DBMS_OUTPUT.PUT_LINE('Succesful operation');
	commit;	
end ticket_exchange;
/
