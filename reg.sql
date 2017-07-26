create or replace procedure reg(
name_1 in varchar,--имя
passport_1 in number,--паспорт
dat in varchar,--дата
mai in varchar,--мэил
flight_1 in number,--рейс
num_bil in number,--количество билетов
l_w in number,
l_h in varchar
)
is 
flag1 varchar(10);
i integer;
begin
        --проверка по паспорту
	select case
	when exists
	(select * from client where passport=passport_1)
	then 'Y'
	else 'N'
	end into flag1
	from dual;

	if flag1='Y' then
	--если все хорошо и пользователя нет в базе данных	
		DBMS_OUTPUT.PUT_LINE('error: client is a database');
		DBMS_OUTPUT.PUT_LINE('please reqister');
		return;		
	end if;	
		
	--проверка рейса
	select case
	when exists
	(select * from ticket where flight=flight_1)
	then 'Y'
	else 'N'
	end into flag1
	from dual;

	--если рейса не существует, то предупрежение с ошибкой
	if flag1='N' then
		DBMS_OUTPUT.PUT_LINE('error:there is not such flight');
		return;
	end if;

	--считываем количество доступных билетов на рейс
	select quantity into i 
	from ticket
	where flight=flight_1;

	--если количество рейсов меньше, то выводим ошибку
	if i<num_bil then
		DBMS_OUTPUT.PUT_LINE('error: no such number of flights');
		return;
	end if;
	
--если все хорошо, то заполняем
	--client
	insert into client
	(surname,passport,date_birth,email,bonus,ticket_num)
	values
	(name_1,passport_1,dat,mai,'no',num_bil);

	--control
	INSERT INTO control(
		passport_cl,
		flight_cl,
		luggage_weight,
		luggage_hand,
		registration,
		tick_num
		) values
		(passport_1,flight_1,l_w,l_h,'no',num_bil);

	i:=5000*num_bil;
	--bonus
	insert into bonus
	(passport_b,email_b,miles,card_num,card)
	values
	(passport_1,mai,i,(select max(card_num) from bonus)+1,'begin');
	

--вычитаем из билетов

	update ticket
	set quantity=quantity-num_bil
	where flight=flight_1;


	DBMS_OUTPUT.PUT_LINE('all good');


end reg;
/
