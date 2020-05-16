drop table hotels cascade constraints;
drop table food_types cascade constraints;
drop table restaurants cascade constraints;
drop table guides cascade constraints;
drop table museums cascade constraints;
drop table belongs_to cascade constraints;
drop table serves cascade constraints;
drop table tourist_speaks cascade constraints;
drop table reviews cascade constraints;
drop table visits cascade constraints;
drop table tourists cascade constraints;
drop table languages cascade constraints;
drop table pictures cascade constraints;
drop table employee_speaks cascade constraints;
drop table attractions cascade constraints;
drop table schedules cascade constraints;
drop table schedules_of cascade constraints;
drop sequence seq_tour_id;
drop sequence seq_attr_id;
drop sequence seq_pic_id;
drop view attr_hotels;
drop view attr_museums;
drop view attr_restaurants;


create table attractions(
    latitude number(8,5) not null,
    longitude number(8,5) not null,
    attraction_id number(11,0),
    attraction_name varchar2(30) not null,
    attraction_descr varchar2(530) not null,
    attraction_phone varchar2(13) not null,
    attraction_website varchar2(2000) not null,
    constraint pk_attraction primary key(attraction_id),
    constraint latitudeLimit check(latitude <= 90 and latitude >= -90),
    constraint longitudeLimit check(longitude <= 180 and longitude >= -180)
);

create sequence seq_attr_id
start with 1
increment by 1;

create table pictures(
    picture_id number(11,0),
    picture_descr varchar2(230),
    picture_date timestamp(6) not null,
    photographer varchar2(30),
    attraction_id number(11,0) not null,
    constraint pk_picture primary key(picture_id),
    constraint fk_picture foreign key(attraction_id) references attractions(attraction_id)
    on delete cascade
);

create sequence seq_pic_id
start with 1
increment by 1;

create table languages(
    language varchar2(20),
    constraint pk_language primary key(language)
);

create table employee_speaks(
    attraction_id number(11,0),
    language varchar2(20),
    constraint fk_empSpeakAtr foreign key(attraction_id) references attractions (attraction_id)
    on delete cascade,
    constraint fk_empSpeakLang foreign key(language) references languages(language),
    constraint pk_empSpeak primary key (language, attraction_id)
);

create table tourists(
    tourist_id number(11,0),
    tourist_name varchar2(30) not null,
    birth_date date not null,
    NIF char(9) not null,
    nationality varchar2(20) not null,
    constraint pk_tourist primary key(tourist_id),
    constraint uniqueNIF unique(NIF)
);

create sequence seq_tour_id
start with 1
increment by 1;

create table visits(
    arrival_time timestamp,
    departure_time timestamp not null,
    tourist_id number(11,0),
    attraction_id number(11,0),
    constraint fk_visitTourist foreign key(tourist_id) references tourists(tourist_id)
    on delete cascade,
    constraint fk_visitAtr foreign key(attraction_id) references attractions(attraction_id)
    on delete cascade,
    constraint pk_visit primary key(arrival_time, tourist_id, attraction_id),
    constraint departAfterArrival check(departure_time - arrival_time  > interval '0' second)
);

create table reviews(
    review_date date,
    rating number(1,0) not null,
    review_text varchar2(230),
    language varchar2(20) not null,
    arrival_time timestamp,
    tourist_id number(11,0),
    attraction_id number(11,0),
    constraint fk_reviewLang foreign key(language) references languages(language),
    constraint fk_reviewVisit foreign key(arrival_time, tourist_id, attraction_id)
        references visits(arrival_time, tourist_id, attraction_id)
        on delete cascade,
    constraint pk_review primary key(arrival_time, tourist_id, attraction_id, review_date),
    constraint ratingLimit check(rating >= 1 and rating <= 5),
    constraint reviewAfterArrival check(review_date - arrival_time > interval '0' second)
);

create table tourist_speaks(
    tourist_id number(11,0),
    language varchar2(20),
    constraint fk_tSpeakTourist foreign key (tourist_id) references tourists(tourist_id)
    on delete cascade,
    constraint fk_tSpeakLang foreign key (language) references languages(language),
    constraint pk_tSpeak primary key(language, tourist_id)
);

create table restaurants(
    attraction_id number(11,0),
    main_dish varchar2(50) not null,
    constraint fk_restaurantAtr foreign key(attraction_id) references attractions(attraction_id)
    on delete cascade,
    constraint pk_restaurant primary key(attraction_id)
);

create table food_types(
    food_type varchar(50),
    constraint pk_foodType primary key(food_type)
);

create table serves(
    food_type varchar(50),
    attraction_id number(11,0),
    constraint fk_serveFood foreign key(food_type) references food_types(food_type),
    constraint fk_serveRestaurant foreign key(attraction_id) references restaurants(attraction_id)
    on delete cascade,
    constraint pk_serve primary key(food_type, attraction_id)
);

create table hotels(
    attraction_id number(11,0),
    stars number(1,0) not null,
    hasPool char(1) default 'F',
    hasSpa char(1) default 'F',
    hasGym char(1) default 'F',
    constraint fk_hotelAtr foreign key(attraction_id) references attractions(attraction_id)
    on delete cascade,
    constraint pk_hotel primary key(attraction_id),
    constraint starsLimit check(stars<= 5 and stars >= 1),
    constraint booleanPool check(hasPool = 'F' or hasPool = 'T'),
    constraint booleanSpa check(hasSpa = 'F' or hasPool = 'T'),
    constraint booleanGym check(hasGym = 'F' or hasPool = 'T')
);

create table belongs_to(
    restaurant_id number(11,0),
    hotel_id number(11,0),
    constraint fk_belongToRestaurant foreign key(restaurant_id) references restaurants(attraction_id)
    on delete cascade,
    constraint fk_belongToHotel foreign key(hotel_id) references hotels(attraction_id)
    on delete cascade,
    constraint pk_belongTo primary key(restaurant_id, hotel_id)
);

create table museums(
    attraction_id number(11,0),
    theme varchar(50) not null,
    constraint fk_museumAtr foreign key(attraction_id) references attractions(attraction_id)
    on delete cascade,
    constraint pk_musuem primary key(attraction_id)
);

create table guides(
    language varchar(20),
    attraction_id number(11,0),
    constraint fk_guideLang foreign key(language) references languages(language),
    constraint fk_guideMuseum foreign key(attraction_id) references museums(attraction_id)
    on delete cascade,
    constraint pk_guide primary key (attraction_id, language)
);

create table schedules(
    start_date date,
    end_date date,
    opening_time timestamp,
    closing_time timestamp,
    constraint pk_schedule primary key(start_date, end_date, opening_time, closing_time)
);

create table schedules_of(
    start_date date,
    end_date date,
    opening_time timestamp,
    closing_time timestamp,
    attraction_id number(11,0),
    constraint fk_scheduleOfSch foreign key(start_date, end_date, opening_time, closing_time)
        references schedules(start_date, end_date, opening_time, closing_time),
    constraint fk_scheduleOfAtr foreign key(attraction_id) references attractions(attraction_id),
    constraint pk_scheduleOf primary key(start_date, end_date, opening_time, closing_time, attraction_id)
);

create or replace trigger insert_pictures
    before insert on pictures
    for each row
    begin
        select seq_pic_id.nextval
        into :new.picture_id
        from dual;
    end;
/

create or replace trigger insert_tourists
    before insert on tourists
    for each row
    begin
        select seq_tour_id.nextval
        into :new.tourist_id
        from dual;
    end;
/

create or replace trigger insert_attractions
    before insert on attractions
    for each row
    begin
        select seq_attr_id.nextval
        into :new.attraction_id
        from dual;
    end;
/

create or replace view attr_museums as
    select latitude,
        longitude,
        attraction_id,
        attraction_name,
        attraction_descr,
        attraction_phone,
        attraction_website,
        theme
    from attractions inner join museums using (attraction_id);

create or replace trigger insert_attr_museums
    instead of insert on attr_museums
    for each row
    declare new_attraction_id number;
    begin
        insert into attractions(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website)
        values (:new.latitude, :new.longitude, :new.attraction_name, :new.attraction_descr, :new.attraction_phone, :new.attraction_website)
        returning attraction_id into new_attraction_id;

        insert into museums(attraction_id, theme)
        values (new_attraction_id, :new.theme);
    end;
/

create or replace trigger delete_attr_museums
    instead of delete on attr_museums
    for each row
    begin
        delete attractions
        where attractions.attraction_id = :old.attraction_id;
    end;
/

create or replace view attr_hotels as
    select latitude,
        longitude,
        attraction_id,
        attraction_name,
        attraction_descr,
        attraction_phone,
        attraction_website,
        stars,
        hasPool,
        hasSpa,
        hasGym
    from attractions inner join hotels using (attraction_id);

create or replace trigger insert_attr_hotels
    instead of insert on attr_hotels
    for each row
    declare new_attraction_id number;
    begin
        insert into attractions(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website)
        values (:new.latitude, :new.longitude, :new.attraction_name, :new.attraction_descr, :new.attraction_phone, :new.attraction_website)
        returning attraction_id into new_attraction_id;

        insert into hotels(attraction_id, stars, hasPool, hasSpa, hasGym)
        values(new_attraction_id, :new.stars, :new.hasPool, :new.hasSpa, :new.hasGym);
    end;
/

create or replace trigger delete_attr_hotels
    instead of delete on attr_hotels
    for each row
    begin
        delete attractions
        where attractions.attraction_id = :old.attraction_id;
    end;
/

create or replace view attr_restaurants as
    select latitude,
        longitude,
        attraction_id,
        attraction_name,
        attraction_descr,
        attraction_phone,
        attraction_website,
        main_dish
    from attractions inner join restaurants using (attraction_id);

create or replace trigger delete_attr_restaurants
    instead of delete on attr_restaurants
    for each row
    begin
        delete attractions
        where attractions.attraction_id = :old.attraction_id;
    end;
/

create or replace trigger insert_attr_restaurants
    instead of insert on attr_restaurants
    for each row
    declare new_attraction_id number;
    begin
        insert into attractions(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website)
        values (:new.latitude, :new.longitude, :new.attraction_name, :new.attraction_descr, :new.attraction_phone, :new.attraction_website)
        returning attraction_id into new_attraction_id;

        insert into restaurants(attraction_id, main_dish)
        values(new_attraction_id, :new.main_dish);
    end;
/

-- Trigger to make sure Review is written in the tourists language
create or replace trigger reviewInTouristLanguage
before insert on reviews
for each row
declare CountSpeaks number;
begin
	select count(*) into CountSpeaks from tourist_speaks t where t.tourist_id = :new.tourist_id and t.language = :new.language;

	if (CountSpeaks = 0)
		then Raise_Application_Error (-20100, 'Review is not written in a language the tourist speaks!');
	end if;
	end;
/

-- Add some languages
insert into languages(language) values('portugues');
insert into languages(language) values('ingles');
insert into languages(language) values('frances');
insert into languages(language) values('alemao');
insert into languages(language) values('espanhol');
insert into languages(language) values('italiano');
insert into languages(language) values('japones');
insert into languages(language) values('coreano');
insert into languages(language) values('chines');
insert into languages(language) values('russo');

-- Add some food types
insert into food_types(food_type) values('Marisco');
insert into food_types(food_type) values('Peixe');
insert into food_types(food_type) values('Vegetariano');
insert into food_types(food_type) values('Churrasco');
insert into food_types(food_type) values('Sushi');
insert into food_types(food_type) values('Asiatico');
insert into food_types(food_type) values('Buffet');
insert into food_types(food_type) values('Pizzaria');
insert into food_types(food_type) values('Portugues');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Jose Mortagua', date '1987-05-13', '983763234', 'portugues(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'portugues');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Jacques Francois', date '1978-01-30', '756283947', 'frances(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'alemao');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Monica Wright', date '1995-09-10', '576039003', 'ingles(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'chines');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Fei Wei Wei', date '1976-04-25', '352857337', 'chines(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'chines');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Park Jimin', date '1995-10-13', '462362718', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Kim Taehyung', date '1995-12-30', '656646477', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');


insert into tourists(tourist_name, birth_date, NIF, nationality) values('Vance Stevenson', date '1987-07-07', '222288882', 'americano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Vivian Ybarra', date '1977-09-15', '465823745', 'italiano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'italiano');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Leocadia Banderas', date '1968-02-19', '111888444', 'espanhol(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'espanhol');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'italiano');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Zac Baldwin', date '2001-08-29', '444888222', 'americano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Valerie Bourdoix', date '1998-03-19', '123987654', 'frances(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Artur Banderas', date '1962-11-12', '342764777', 'espanhol(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'espanhol');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Sebastian Bourdoix', date '1992-02-01', '342634294', 'frances(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Chrollo Lucilfer', date '1992-07-30', '666000666', 'ingles(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Jeon Jungkook', date '1997-09-01', '111111111', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');


insert into tourists(tourist_name, birth_date, NIF, nationality) values('Kim Seokjin', date '1992-12-04', '192129921', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Kim Namjoon', date '1994-09-12', '252525124', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Min Yoongi', date '1993-03-09', '666455545', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');


insert into tourists(tourist_name, birth_date, NIF, nationality) values('Jung Hoseok', date '1994-02-18', '666055545', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'chines');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Marcela Souza', date '1987-07-20', '616055005', 'portugues(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'portugues');


insert into tourists(tourist_name, birth_date, NIF, nationality) values('Chica Silva', date '2003-08-21', '616033005', 'espanhol(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'espanhol');


insert into tourists(tourist_name, birth_date, NIF, nationality) values('Alexandre Souza', date '1987-03-10', '616075005', 'portugues(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'portugues');

insert into tourists(tourist_name, birth_date, NIF, nationality) values('Andre Santos', date '2001-04-30', '010000022', 'portugues(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'portugues');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'russo');

insert into attr_museums(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website, theme)
values (38.69158, -9.21597, 'Torre de Belem',
'Construida estrategicamente na margem norte do rio Tejo entre 1514 e 1520, sob orientacao de Francisco de Arruda, a Torre de Belem e uma das joias da arquitetura do reinado de D. Manuel I.
O monumento faz uma sintese entre a torre de menagem de tradicao medieval e o baluarte, mais largo, com a sua casamata onde se dispunham os primeiros dispositivos aptos para resistir ao fogo de artilharia. [+]',
'+351213620034', 'http://www.torrebelem.pt/', 'Torre de Belem (tema)');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2010-01-31 09:26:50', null, seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2015-05-31 10:30:54', null, seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values('Torre de Belem, perfil, noite', timestamp '2019-06-01 23:03:30','Joao Bravo' , seq_attr_id.currval);

--Missing schedule

insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'frances');

insert into guides(language, attraction_id) values ('portugues', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('ingles', seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 09:03:30', timestamp '2019-06-01 10:03:30', 2 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-02', 5, 'review Torre de Belem  tour2', 'frances', timestamp '2019-06-01 09:03:30', 2, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-05-01 09:03:30', timestamp '2019-05-01 12:03:30', 7 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-05-04', 3, 'review Torre de Belem tour7', 'ingles', timestamp '2019-05-01 09:03:30', 7, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-03 10:03:30', timestamp '2019-06-03 11:03:30', 15 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 4, 'review Torre de Belem tour15', 'coreano', timestamp '2019-06-03 10:03:30', 15, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-11 09:03:30', timestamp '2019-06-11 10:03:30', 6 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-12', 4, 'review Torre de Belem tour6', 'coreano', timestamp '2019-06-11 09:03:30', 6, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 15:03:30', timestamp '2019-06-01 15:04:30', 9 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 4, 'review Torre de Belem tour9', 'italiano', timestamp '2019-06-01 15:03:30', 9, seq_attr_id.currval);

insert into attr_museums(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website, theme)
values(38.69789, -9.20670, 'Mosteiro dos Jeronimos',
'Ligado simbolicamente aos mais importantes momentos da memoria nacional, o Mosteiro dos Jeronimos (ou Real Mosteiro de Santa Maria de Belem) foi fundado pelo rei D. Manuel I no inicio do seculo XVI. As obras iniciaram-se justamente no virar do seculo, lancando-se a primeira pedra na data simbolica de 6 de Janeiro (dia de Reis) de 1501 ou 1502.[+]',
'+351213620034', 'http://www.mosteirojeronimos.pt/', 'Mosteiro dos Geronimos(tema)');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-10-21 12:26:40', 'John Miller', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2018-12-23 15:06:10', null, seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-01-30 17:00:50', null, seq_attr_id.currval);

insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'frances');


insert into guides(language, attraction_id) values ('portugues', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('ingles', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('espanhol', seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 09:03:30', timestamp '2019-06-01 10:03:30', 1 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 4, 'review Mosteiro dos Geronimos tour1', 'portugues', timestamp '2019-06-01 09:03:30', 1, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-05-01 09:03:30', timestamp '2019-05-01 12:03:30', 6 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 2, 'review Mosteiro dos Geronimos tour6', 'japones', timestamp '2019-05-01 09:03:30', 6, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-03 10:03:30', timestamp '2019-06-03 11:03:30', 14 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 5, 'review Mosteiro dos Geronimos tour14', 'ingles', timestamp '2019-06-03 10:03:30', 14, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-11 09:03:30', timestamp '2019-06-11 10:03:30', 13 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-14', 2, 'review Mosteiro dos Geronimos tour13', 'ingles', timestamp '2019-06-11 09:03:30', 13, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 15:03:30', timestamp '2019-06-01 15:04:30', 8 ,seq_attr_id.currval);


insert into attr_museums(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website, theme)
values (38.72079, -9.11705, 'Museu Nacional do Azulejo',
'Atraves das suas atividades, o museu da a conhecer a historia do Azulejo em Portugal procurando chamar a atencao da sociedade para a necessidade e importancia da protecao daquela que e a express�o artistica diferenciadora da cultura portuguesa no mundo: o Azulejo.',
'+351218100340' ,'http://www.museudoazulejo.pt/', 'Azulejo');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2020-01-01 12:31:12', null, seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 21:05:27', null, seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2000-06-10 10:28:31', 'Maria Jose', seq_attr_id.currval);

insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'frances');

insert into guides(language, attraction_id) values ('portugues', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('ingles', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('espanhol', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('frances', seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 09:03:30', timestamp '2019-06-01 10:03:30', 2 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 3, 'review Azulejos tour2', 'frances', timestamp '2019-06-01 09:03:30', 2, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-05-01 09:03:30', timestamp '2019-05-01 12:03:30', 7 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-05-04', 5, 'review Azulejos tour7', 'ingles', timestamp '2019-05-01 09:03:30', 7, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-03 10:03:30', timestamp '2019-06-03 11:03:30', 15 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 4, 'review Azulejos tour15', 'coreano', timestamp '2019-06-03 10:03:30', 15, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-11 09:03:30', timestamp '2019-06-11 10:03:30', 6 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-14', 2, 'review Azulejos tour6', 'coreano', timestamp '2019-06-11 09:03:30', 6, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 15:03:30', timestamp '2019-06-01 15:04:30', 9 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 3, 'review Azulejos tour9', 'italiano', timestamp '2019-06-01 15:03:30', 9, seq_attr_id.currval);

insert into attr_hotels(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website, stars, hasPool, hasSpa, hasGym)
values (40.67611, 7.70694, 'Casa da Insua', 'Perfeitamente integrado num Palacete Barroco do sec. XVIII, onde cada sala e cada recanto nos transportam para a historia dos seus proprietarios e para momentos da historia de Portugal e do Brasil, o Parador Casa da Insua conjuga passado e presente, com detalhes que fazem os seus visitantes sentir-se como parte dessa historia.',
'+351232640110', 'https://montebelohotels.com/parador-casa-insua/pt/home', 5, 'T', 'F', 'F');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 15:05:23', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 15:09:30', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 15:20:49', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 15:34:45', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 16:02:02', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 21:59:37', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-09 07:03:05', null, seq_attr_id.currval);


insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'frances');

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 09:03:30', timestamp '2019-06-01 10:03:30', 2 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 5, 'review Casa Insua tour2', 'alemao', timestamp '2019-06-01 09:03:30', 2, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-05-01 09:03:30', timestamp '2019-05-01 12:03:30', 7 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-05-04', 5, 'review Casa Insua tour7', 'ingles', timestamp '2019-05-01 09:03:30', 7, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-03 10:03:30', timestamp '2019-06-03 11:03:30', 15 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 4, 'review Casa Insua tour15', 'coreano', timestamp '2019-06-03 10:03:30', 15, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-11 09:03:30', timestamp '2019-06-11 10:03:30', 6 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-14', 3, 'review Casa Insua tour6', 'japones', timestamp '2019-06-11 09:03:30', 6, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 15:03:30', timestamp '2019-06-01 15:04:30', 9 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 4, 'review Casa Insua tour9', 'italiano', timestamp '2019-06-01 15:03:30', 9, seq_attr_id.currval);


insert into attr_hotels(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website, stars, hasPool, hasSpa, hasGym)
values(38.69491, -9.21472, 'Palacio do Governador',
'Nao e apenas mais um hotel em Lisboa. E o Palacio do Governador, com 60 quartos, todos diferentes, junto ao rio Tejo, em pleno centro historico de Belem, numa das zonas mais bonitas e emblematicas da capital. Este emblematico hotel de charme faz reviver um legado historico impar, ao mesmo tempo que enaltece a qualidade, exclusividade e requinte.',
'+351213007009', 'https://www.palaciogovernador.com/', 5, 'T', 'T', 'T');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-03-29 11:12:05', null, seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-05-18 17:23:12', null, seq_attr_id.currval);


insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'chines');

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 09:03:30', timestamp '2019-06-01 10:03:30', 2 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 3, 'review Palacio tour2', 'frances', timestamp '2019-06-01 09:03:30', 2, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-05-01 09:03:30', timestamp '2019-05-01 12:03:30', 7 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-05-04', 3, 'review Palacio tour7', 'ingles', timestamp '2019-05-01 09:03:30', 7, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-03 10:03:30', timestamp '2019-06-03 11:03:30', 15 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 5, 'review Palacio tour15', 'coreano', timestamp '2019-06-03 10:03:30', 15, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-11 09:03:30', timestamp '2019-06-11 10:03:30', 6 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-14', 5, 'review Palacio tour6', 'coreano', timestamp '2019-06-11 09:03:30', 6, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 15:03:30', timestamp '2019-06-01 15:04:30', 9 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 5, 'review Palacio tour9', 'italiano', timestamp '2019-06-01 15:03:30', 9, seq_attr_id.currval);

insert into attr_restaurants(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website, main_dish)
values(38.69491, -9.21472, 'Restaurante e Bar Anfora',
'Uma anfora guarda a mais pura essencia das coisas e liberta-as do que nao e primordial.
E este, tambem, o principio do restaurante do Palacio do Governador, em que cada prato servido acentua nao mais que o essencial:
o sabor trazido pelos melhores produtos da terra e do mar.',
'+351212467800', 'https://www.palaciogovernador.com/restaurante-e-bar.html', 'O mais Portugues de Portugal');

insert into serves(food_type, attraction_id) values('Portugues', seq_attr_id.currval);

--needs fixing vvv currval-1??
insert into belongs_to(restaurant_id, hotel_id) values(seq_attr_id.currval, seq_attr_id.currval -1);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 09:03:30', timestamp '2019-06-01 10:03:30', 2 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 5, 'review Anfora tour2', 'alemao', timestamp '2019-06-01 09:03:30', 2, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-05-01 09:03:30', timestamp '2019-05-01 12:03:30', 7 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-05-04', 2, 'review Anfora tour7', 'ingles', timestamp '2019-05-01 09:03:30', 7, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-03 10:03:30', timestamp '2019-06-03 11:03:30', 15 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 4, 'review Anfora tour15', 'coreano', timestamp '2019-06-03 10:03:30', 15, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-11 09:03:30', timestamp '2019-06-11 10:03:30', 6 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-14', 3, 'review Anfora tour6', 'japones', timestamp '2019-06-11 09:03:30', 6, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 15:03:30', timestamp '2019-06-01 15:04:30', 9 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 4, 'review Anfora tour9', 'espanhol', timestamp '2019-06-01 15:03:30', 9, seq_attr_id.currval);

insert into attr_restaurants(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website, main_dish)
values(40.69491, -7.21472, 'Restaurante Fake News I',
'Neste restaurante falso come-se comida verdadeira.',
'+351212487800', 'https://www.fake1.com/restaurante-e-bar.html', 'Bacalhau à Lagareiro');

insert into serves(food_type, attraction_id) values('Peixe', seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 09:03:30', timestamp '2019-06-01 10:03:30', 2 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 3, 'review FAKE1 tour2', 'alemao', timestamp '2019-06-01 09:03:30', 2, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-05-01 09:03:30', timestamp '2019-05-01 12:03:30', 7 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-05-04', 3, 'review FAKE1 tour7', 'ingles', timestamp '2019-05-01 09:03:30', 7, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-03 10:03:30', timestamp '2019-06-03 11:03:30', 15 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 2, 'review FAKE1 tour15', 'japones', timestamp '2019-06-03 10:03:30', 15, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-11 09:03:30', timestamp '2019-06-11 10:03:30', 6 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-14', 4, 'review FAKE1 tour6', 'japones', timestamp '2019-06-11 09:03:30', 6, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 15:03:30', timestamp '2019-06-01 15:04:30', 9 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 3, 'review FAKE1 tour9', 'espanhol', timestamp '2019-06-01 15:03:30', 9, seq_attr_id.currval);

insert into attr_restaurants(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website, main_dish)
values(42.69491, -7.21472, 'Restaurante Fake News II',
'Neste restaurante falso tambem se come comida verdadeira.',
'+351212467800', 'https://www.fake2.com/restaurante-e-bar.html', 'Salmao');

insert into serves(food_type, attraction_id) values('Sushi', seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 09:03:30', timestamp '2019-06-01 10:03:30', 2 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 4, 'review FAKE2 tour2', 'alemao', timestamp '2019-06-01 09:03:30', 2, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-05-01 09:03:30', timestamp '2019-05-01 12:03:30', 7 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-05-04', 4, 'review FAKE2 tour7', 'ingles', timestamp '2019-05-01 09:03:30', 7, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-03 10:03:30', timestamp '2019-06-03 11:03:30', 15 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 5, 'review FAKE2 tour15', 'japones', timestamp '2019-06-03 10:03:30', 15, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-11 09:03:30', timestamp '2019-06-11 10:03:30', 6 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-14', 5, 'review FAKE2 tour6', 'japones', timestamp '2019-06-11 09:03:30', 6, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 15:03:30', timestamp '2019-06-01 15:04:30', 9 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 5, 'review FAKE2 tour9', 'espanhol', timestamp '2019-06-01 15:03:30', 9, seq_attr_id.currval);

insert into attr_restaurants(latitude, longitude, attraction_name, attraction_descr, attraction_phone, attraction_website, main_dish)
values(40.69491, -7.21472, 'Restaurante Fake News III',
'Este restaurante falso é melhor que os outros.',
'+351212587800', 'https://www.fake3.com/restaurante-e-bar.html', 'Pizza de Pepperoni');

insert into serves(food_type, attraction_id) values('Pizzaria', seq_attr_id.currval);


insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'frances');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'alemao');

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 09:03:30', timestamp '2019-06-01 10:03:30', 2 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 5, 'review FAKE3 tour2', 'frances', timestamp '2019-06-01 09:03:30', 2, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-05-01 09:03:30', timestamp '2019-05-01 12:03:30', 7 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-05-04', 3, 'review FAKE3 tour7', 'ingles', timestamp '2019-05-01 09:03:30', 7, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-03 10:03:30', timestamp '2019-06-03 11:03:30', 15 ,seq_attr_id.currval);

insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 4, 'review FAKE3 tour15', 'coreano', timestamp '2019-06-03 10:03:30', 15, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-11 09:03:30', timestamp '2019-06-11 10:03:30', 6 ,seq_attr_id.currval);

-- review in language constraint prevents this correctly
insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-14', 3, 'review FAKE3 tour6', 'japones', timestamp '2019-06-11 09:03:30', 6, seq_attr_id.currval);

insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-06-01 15:03:30', timestamp '2019-06-01 15:04:30', 9 ,seq_attr_id.currval);

-- review in language constraint prevents this correctly
insert into reviews(review_date, rating, review_text, language, arrival_time, tourist_id,  attraction_id)
values (date '2019-06-04', 3, 'review FAKE3 tour9', 'espanhol', timestamp '2019-06-01 15:03:30', 9, seq_attr_id.currval);

select * from tourist_speaks where tourist_id = 6;
