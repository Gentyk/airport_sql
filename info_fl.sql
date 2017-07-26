create or replace function info_fl(
flight_1 in number
) RETURN SYS_REFCURSOR
is
flag1 varchar2(10);
rc SYS_REFCURSOR;
begin
	--проверка рейса(flight_air)
	select case
	when exists
	(select * from flight_air where flight_a=flight_1)
	then 'Y'
	else 'N'
	end into flag1
	from dual;

	--если рейса не существует, то предупрежение с ошибкой
	if flag1='N' then
		open rc for 
		select client.surname
		from control
		inner join client on client.passport=control.passport_cl
		where control.flight_cl>0;
	return rc;
	end if;

	

--если надо вывести обо всем
	
	open rc for 
		select flight_air.flight_a,technic.t_a_t,staff.num_p,staff.num_b,technic.sleeve
		from flight_air
		inner join technic on flight_air.flight_a=technic.flight_th		
		inner join staff on flight_air.flight_a=staff.flight_s
		where flight_air.flight_a=flight_1;
	return rc;
	
end;
/


