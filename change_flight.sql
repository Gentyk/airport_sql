create or replace procedure change_flight(
flight_1 in number,	
new_time in varchar,	
new_output in integer)	
as
flag1 varchar2(10);
s varchar2(5);
i integer;
begin

	
	--проверка рейса(ticket)
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

--вдруг ничего не надо менять
	if new_time='0' and new_output=0 then
		DBMS_OUTPUT.PUT_LINE('no need to change anything');
		return;
	
	end if;
      
--изменение времени:
	if new_time<>'0' then
	--проверка рейса(now_stat)
	select case
	when exists
	(select * from now_stat where flight_ns=flight_1)
	then 'Y'
	else 'N'
	end into flag1
	from dual;

	--если рейса не существует, то предупрежение с ошибкой
	if flag1='N' then
		DBMS_OUTPUT.PUT_LINE('error:there is not such flight(now_stat)');
	else
	
	--проверка: вдруг старое время равно новому
	select time_ns into s
	from now_stat
	where flight_ns=flight_1;
	
	--если равно новому, то предупреждение об этом
	if s=new_time then
		DBMS_OUTPUT.PUT_LINE('Do not change time,becouse new time eq old time');
	else	
		-- меняем время
		update now_stat
		set time_ns=new_time
		where flight_ns=flight_1;

		DBMS_OUTPUT.PUT_LINE('We send information about the transfer of the flight');
		DBMS_OUTPUT.PUT_LINE('Succesful operation');

	end if;
	end if;
	end if;
--изменение выхода
	if new_output!=0 then
	--проверка рейса(terminal)
	select case
	when exists
	(select * from terminal where flight_t=flight_1)
	then 'Y'
	else 'N'
	end into flag1
	from dual;

	--если рейса не существует, то предупрежение с ошибкой
	if flag1='N' then
		DBMS_OUTPUT.PUT_LINE('error:there is not such flight');
		return;
	end if;

	--проверка: вдруг старый выхлд равен новому
	select output into i
	from terminal
	where flight_t=flight_1;
	
	--если равно новому, то предупреждение об этом
	if new_output=i then
		DBMS_OUTPUT.PUT_LINE('Do not change output,becouse new output eq old output');
		return;	
	else	
		-- меняем выход
		update terminal
		set output=new_output
		where flight_t=flight_1;

		DBMS_OUTPUT.PUT_LINE('We send information about otput:');
		DBMS_OUTPUT.PUT_LINE(flight_1);
		DBMS_OUTPUT.PUT_LINE('Succesful operation');
	end if;
	end if;
end;
/
