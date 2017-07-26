--создание таблиц(без заполнения)

CREATE TABLE ticket(
flight integer,
time varchar2(5),
quantity integer,
price integer,
from_in varchar2(7),
PRIMARY KEY(flight)
);

CREATE TABLE client(
surname varchar2(10),
passport integer,
date_birth varchar2(10),
email varchar2(10),
bonus varchar2(3),
PRIMARY KEY(passport)
);

CREATE TABLE terminal(
flight_t integer,
terminal varchar2(1),
output integer,
type_technic varchar2(10),
floor integer,
PRIMARY KEY(flight_t));
  
CREATE TABLE bonus(
surname_b varchar2(10),
email_b varchar2(10),
miles integer,
card_num integer,
card varchar2(10),
PRIMARY KEY(card_num));

CREATE TABLE control(
surname_c varchar2(10),
flight_c integer,
luggage_weight integer,
luggage_hand varchar2(1),
registration varchar2(3),
PRIMARY KEY(surname_c));

CREATE TABLE technic(
flight_th integer,
bus integer,
sleeve varchar2(1),
cart integer,
no_ice varchar2(1),
PRIMARY KEY(flight_th));

CREATE TABLE air_park(
type_air varchar2(10),
num integer,
num_place integer,
num_number integer,
ststus varchar2(10),
PRIMARY KEY(type_air));

CREATE TABLE staff(
flight_s integer,
num_s integer,
num_p integer,
num_b integer,
num_oth integer,
PRIMARY KEY(flight_s));

CREATE TABLE flight_air(
flight_a integer,
from_a varchar2(3),
in_a varchar2(3),
days varchar2(7),
status_a varchar(10),
PRIMARY KEY(flight_a));

CREATE TABLE now_stat(
flight_ns integer,
time_ns varchar2(5),
status_ns varchar2(10),
type_ns integer,
output_ns integer,
PRIMARY KEY(flight_ns))
/
