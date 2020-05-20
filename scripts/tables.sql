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
    constraint longitudeLimit check(longitude <= 180 and longitude >= -180),
    constraint uniquePhone unique(attraction_phone)
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
    on delete cascade deferrable
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
    on delete cascade deferrable,
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
        constraint fk_reviewTourist foreign key(tourist_id) references tourists(tourist_id),
    constraint fk_reviewAtr foreign key(attraction_id) references attractions(attraction_id),
    constraint pk_review primary key(arrival_time, tourist_id, attraction_id, review_date),
    constraint ratingLimit check(rating >= 1 and rating <= 5),
    constraint reviewAfterArrival check(review_date - arrival_time > interval '0' second)
);

create table tourist_speaks(
    tourist_id number(11,0),
    language varchar2(20),
    constraint fk_tSpeakTourist foreign key (tourist_id) references tourists(tourist_id)
    on delete cascade deferrable,
    constraint fk_tSpeakLang foreign key (language) references languages(language),
    constraint pk_tSpeak primary key(language, tourist_id)
);

create table restaurants(
    attraction_id number(11,0),
    main_dish varchar2(50) not null,
    constraint fk_restaurantAtr foreign key(attraction_id) references attractions(attraction_id)
    on delete cascade deferrable,
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
    on delete cascade deferrable,
    constraint pk_serve primary key(food_type, attraction_id)
);

create table hotels(
    attraction_id number(11,0),
    stars number(1,0) not null,
    hasPool char(1) default 'F',
    hasSpa char(1) default 'F',
    hasGym char(1) default 'F',
    constraint fk_hotelAtr foreign key(attraction_id) references attractions(attraction_id)
    on delete cascade deferrable,
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
    constraint oneHotelPerRestaurant unique(restaurant_id),
    constraint pk_belongTo primary key(restaurant_id, hotel_id)
);

create table museums(
    attraction_id number(11,0),
    theme varchar(50) not null,
    constraint fk_museumAtr foreign key(attraction_id) references attractions(attraction_id)
    on delete cascade deferrable,
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
        references schedules(start_date, end_date, opening_time, closing_time) deferrable,
    constraint fk_scheduleOfAtr foreign key(attraction_id) references attractions(attraction_id) on delete cascade deferrable,
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

-- Trigger to ensure attraction_id is read-only
create or replace trigger readOnlyAttractionId
before update of attraction_id on attractions
begin
    Raise_Application_Error (-20099, 'Attraction ID is read-only!');
end;
/

-- Trigger to ensure picture_id is read-only
create or replace trigger readOnlyPictureId
before update of picture_id on pictures
begin
    Raise_Application_Error (-20098, 'Picture ID is read-only!');
end;
/

-- Trigger to ensure attraction_id is read-only
create or replace trigger readOnlyTouristId
before update of tourist_id on tourists
begin
    Raise_Application_Error (-20097, 'Tourist ID is read-only!');
end;
/

--Trigger to ensure a tourist speaks at least one language
create or replace trigger TouristHasToSpeak
    after insert on tourists
    for each row
    declare counter number;
    begin
        select count(*)
        into counter
        from tourist_speaks
        where tourist_id = :new.tourist_id;
        if(counter < 1)
            then Raise_Application_Error (-20094, 'Tourist must speak at least one language');
        end if;
    end;
/

--Trigger to ensure an attraction's empployees speak at least one language
create or replace trigger employeesHaveToSpeak
    after insert on attractions
    for each row
    declare counter number;
    begin
        select count(*)
        into counter
        from employee_speaks
        where attraction_id = :new.attraction_id;
        if(counter < 1)
            then Raise_Application_Error (-20094, 'Attraction employees must speak at least one language');
        end if;
    end;
/

-- Procedure to insert tourist and making sure he speaks at least one language
create or replace procedure insert_tourist (
    tour_name in varchar2,
    birth in date,
    tour_NIF in char,
    tour_nationality in varchar2,
    languageSpoken in varchar2
)
    is tour_id number;
    begin
        select seq_tour_id.nextval
        into tour_id
        from dual;
        execute immediate 'set constraint fk_tSpeakTourist deferred';
        insert into tourist_speaks(tourist_id, language) values (tour_id, languageSpoken);
        insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality)
        values (tour_id,tour_name, birth, tour_NIF, tour_nationality);
        commit;
    end;
/

-- Trigger to ensure an attraction has at least one picture
create or replace trigger attractionHasPicture
    after insert on attractions
    for each row
    declare counter number;
    begin
        select count(*) into counter
        from pictures
        where attraction_id = :new.attraction_id;
        if(counter = 0)
            then Raise_Application_Error (-20093, 'Attraction must have at least one picture!');
        end if;
    end;
/

-- Trigger to ensure an attraction has at least one picture
create or replace trigger attractionHasSchedule
    after insert on attractions
    for each row
    declare counter number;
    begin
        select count(*) into counter
        from schedules_of
        where attraction_id = :new.attraction_id;
        if(counter = 0)
            then Raise_Application_Error (-20088, 'Attraction must have at least one picture!');
        end if;
    end;
/

-- Procedure to insert an attraction with at least one picture
create or replace procedure insert_attraction (
    lat in number,
    lon in number,
    attr_name in varchar2,
    attr_descr in varchar2,
    attr_phone in varchar2,
    attr_website in varchar2,
    pic_descr in varchar2,
    pic_date in timestamp,
    pic_photographer in varchar2,
    attr_id in number,
    empl_lang in varchar2,
    attr_start_date in date,
    attr_end_date in date,
    attr_opening_time in timestamp,
    attr_closing_time in timestamp
)
    is counter number;
    begin

        execute immediate 'set constraint fk_picture, fk_empSpeakAtr, fk_scheduleOfSch, fk_scheduleOfAtr deferred';

        insert into pictures(picture_descr, picture_date, photographer, attraction_id)
        values (pic_descr, pic_date, pic_photographer, attr_id);

        insert into employee_speaks(attraction_id, language) values(attr_id, empl_lang);


     	insert into schedules_of(start_date, end_date, opening_time, closing_time, attraction_id) values (attr_start_date, attr_end_date, attr_opening_time, attr_closing_time, attr_id);

        insert into attractions(latitude, longitude, attraction_id, attraction_name, attraction_descr, attraction_phone, attraction_website)
        values (lat, lon, attr_id, attr_name, attr_descr, attr_phone, attr_website);

        commit;
    end;
/

-- Procedure to insert museums
create or replace procedure insert_museum (
    lat in number,
    lon in number,
    attr_name in varchar2,
    attr_descr in varchar2,
    attr_phone in varchar2,
    attr_website in varchar2,
    pic_descr in varchar2,
    pic_date in timestamp,
    pic_photographer in varchar2,
    m_theme in varchar2,
    empl_lang in varchar2,
    attr_start_date in date,
    attr_end_date in date,
    attr_opening_time in timestamp,
    attr_closing_time in timestamp
)
 is attr_id number;
    begin
        select seq_attr_id.nextval
        into attr_id
        from dual;

        execute immediate 'set constraint fk_museumAtr deferred';

        insert into museums(attraction_id, theme) values (attr_id, m_theme);

        insert_attraction (lat, lon, attr_name, attr_descr, attr_phone, attr_website, pic_descr, pic_date, pic_photographer, attr_id, empl_lang, attr_start_date, attr_end_date, attr_opening_time, attr_closing_time);

        commit;
    end;
/

-- Procedure to insert hotels
create or replace procedure insert_hotel (
    lat in number,
    lon in number,
    attr_name in varchar2,
    attr_descr in varchar2,
    attr_phone in varchar2,
    attr_website in varchar2,
    pic_descr in varchar2,
    pic_date in timestamp,
    pic_photographer in varchar2,
    h_stars in varchar2,
    h_pool in char,
    h_spa in char,
    h_gym in char,
    empl_lang in varchar2,
    attr_start_date in date,
    attr_end_date in date,
    attr_opening_time in timestamp,
    attr_closing_time in timestamp
)
 is attr_id number;
    begin
        select seq_attr_id.nextval
        into attr_id
        from dual;

        execute immediate 'set constraint fk_hotelAtr deferred';

        insert into hotels(attraction_id, stars, hasPool, hasSpa, hasGym) values (attr_id, h_stars, h_pool, h_spa, h_gym);

        insert_attraction (lat, lon, attr_name, attr_descr, attr_phone, attr_website, pic_descr, pic_date, pic_photographer, attr_id, empl_lang, attr_start_date, attr_end_date, attr_opening_time, attr_closing_time);

        commit;
    end;
/


-- Trigger to ensure a restaurant has at least one food type
create or replace trigger restaurantHasFoodType
    after insert on restaurants
    for each row
    declare counter number;
    begin
        select count(*) into counter
        from serves
        where attraction_id = :new.attraction_id;
        if(counter = 0)
            then Raise_Application_Error (-20092, 'Restaurant must serve at least one food type!');
        end if;
    end;
/

-- Procedure to insert restaurant
create or replace procedure insert_restaurant (
    lat in number,
    lon in number,
    attr_name in varchar2,
    attr_descr in varchar2,
    attr_phone in varchar2,
    attr_website in varchar2,
    pic_descr in varchar2,
    pic_date in timestamp,
    pic_photographer in varchar2,
    r_dish in varchar2,
    r_food_type in varchar2,
    empl_lang in varchar2,
    attr_start_date in date,
    attr_end_date in date,
    attr_opening_time in timestamp,
    attr_closing_time in timestamp
)
 is attr_id number;
    begin
        select seq_attr_id.nextval
        into attr_id
        from dual;

        execute immediate 'set constraint fk_restaurantAtr, fk_serveRestaurant deferred';

        insert into serves(attraction_id, food_type) values(attr_id, r_food_type);

        insert into restaurants(attraction_id, main_dish) values (attr_id, r_dish);

        insert_attraction (lat, lon, attr_name, attr_descr, attr_phone, attr_website, pic_descr, pic_date, pic_photographer, attr_id, empl_lang, attr_start_date, attr_end_date, attr_opening_time, attr_closing_time);

        commit;
    end;
/

-- Trigger to ensure attraction has at least one picture on picture deletion
create or replace trigger lastPicture
    after delete on pictures
    declare picNum number;
    attrNum number;
    begin
        select count(distinct attraction_id)
        into picNum
        from pictures;
        select count(distinct attraction_id)
        into attrNum
        from attractions;

        if(picNum != attrNum)
            then Raise_Application_Error(-20096, 'Attraction must always have at least one picture!');
        end if;
    end;
/

-- Trigger to delete schedule if no attraction has it and ensure attraction has at least one
create or replace trigger lastScheduleOf
    after delete on schedules_of
    declare schedNum number;
    attrNum number;
    begin
        select count(distinct attraction_id)
        into schedNum
        from schedules_of;
        select count(distinct attraction_id)
        into attrNum
        from attractions;

        if(schedNum != attrNum)
            then Raise_Application_Error(-20095, 'Attraction must always have at least one schedule!');
        else
            delete from schedules
            where (start_date, end_date, opening_time, closing_time) in (
                select * from schedules
                minus
                select distinct start_date, end_date, opening_time, closing_time
                from schedules_of);
        end if;
    end;
/

create or replace trigger insert_schedules_of
    before insert on schedules_of
    for each row
    declare counter number;
    begin
        select count(*)
        into counter
        from schedules
        where start_date = :new.start_date
        and end_date = :new.end_date
        and opening_time = :new.opening_time
        and closing_time = :new.closing_time;

        if(counter < 1)
         then insert into schedules(start_date, end_date, opening_time, closing_time)
         values (:new.start_date, :new.end_date, :new.opening_time, :new.closing_time);
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

call insert_tourist('Jose Mortagua', date '1987-05-13', '983763234', 'portugues(a)', 'portugues');

call insert_tourist('Jacques Francois', date '1978-01-30', '756283947', 'frances(a)', 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'alemao');

call insert_tourist('Monica Wright', date '1995-09-10', '576039003', 'ingles(a)', 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'chines');

call insert_tourist('Fei Wei Wei', date '1976-04-25', '352857337', 'chines(a)', 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'chines');

call insert_tourist('Park Jimin', date '1995-10-13', '462362718', 'coreano(a)', 'coreano');

call insert_tourist('Kim Taehyung', date '1995-12-30', '656646477', 'coreano(a)', 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');


call insert_tourist('Vance Stevenson', date '1987-07-07', '222288882', 'americano(a)', 'ingles');

call insert_tourist('Vivian Ybarra', date '1977-09-15', '465823745', 'italiano(a)', 'italiano');

call insert_tourist('Leocadia Banderas', date '1968-02-19', '111888444', 'espanhol(a)', 'espanhol');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'italiano');

call insert_tourist('Zac Baldwin', date '2001-08-29', '444888222', 'americano(a)', 'ingles');

call insert_tourist('Valerie Bourdoix', date '1998-03-19', '123987654', 'frances(a)', 'frances');

call insert_tourist('Artur Banderas', date '1962-11-12', '342764777', 'espanhol(a)', 'espanhol');

call insert_tourist('Sebastian Bourdoix', date '1992-02-01', '342634294', 'frances(a)', 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

call insert_tourist('Chrollo Lucilfer', date '1992-07-30', '666000666', 'ingles(a)', 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');

call insert_tourist('Jeon Jungkook', date '1997-09-01', '111111111', 'coreano(a)', 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');


call insert_tourist('Kim Seokjin', date '1992-12-04', '192129921', 'coreano(a)', 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

call insert_tourist('Kim Namjoon', date '1994-09-12', '252525124', 'coreano(a)', 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
call insert_tourist('Min Yoongi', date '1993-03-09', '666455545', 'coreano(a)', 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');


call insert_tourist('Jung Hoseok', date '1994-02-18', '666055545', 'coreano(a)', 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'chines');

call insert_tourist('Marcela Souza', date '1987-07-20', '616055005', 'portugues(a)', 'portugues');

call insert_tourist('Chica Silva', date '2003-08-21', '616033005', 'espanhol(a)', 'espanhol');

call insert_tourist('Alexandre Souza', date '1987-03-10', '616075005', 'portugues(a)', 'portugues');

call insert_tourist('Andre Santos', date '2001-04-30', '010000022', 'portugues(a)', 'portugues');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'russo');

-- To number to fix stupid sql developer bug
call insert_museum(to_number('0,5'), to_number('-20,5'), 'Torre de Belem',
'Construida estrategicamente na margem norte do rio Tejo entre 1514 e 1520, sob orientacao de Francisco de Arruda, a Torre de Belem e uma das joias da arquitetura do reinado de D. Manuel I.
O monumento faz uma sintese entre a torre de menagem de tradicao medieval e o baluarte, mais largo, com a sua casamata onde se dispunham os primeiros dispositivos aptos para resistir ao fogo de artilharia. [+]',
'+351213620034', 'http://www.torrebelem.pt/', null, timestamp '2010-01-31 09:26:50', null, 'Torre de Belem (tema)', 'portugues', date '2001-04-30', date '2001-05-30', timestamp '1997-06-01 10:00:00', timestamp '1997-06-01 12:00:00');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2015-05-31 10:30:54', null, seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values('Torre de Belem, perfil, noite', timestamp '2019-06-01 23:03:30','Joao Bravo' , seq_attr_id.currval);

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

call insert_museum(to_number('38,69789'), to_number('-9,20670'), 'Mosteiro dos Jeronimos',
'Ligado simbolicamente aos mais importantes momentos da memoria nacional, o Mosteiro dos Jeronimos (ou Real Mosteiro de Santa Maria de Belem) foi fundado pelo rei D. Manuel I no inicio do seculo XVI. As obras iniciaram-se justamente no virar do seculo, lancando-se a primeira pedra na data simbolica de 6 de Janeiro (dia de Reis) de 1501 ou 1502.[+]',
'+351213620035', 'http://www.mosteirojeronimos.pt/', null, timestamp '2019-10-21 12:26:40', 'John Miller', 'Mosteiro dos Jerónimos(tema)', 'portugues', date '2001-04-29', date '2001-05-29', timestamp '1997-06-01 10:00:00', timestamp '1997-06-01 12:00:00');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2018-12-23 15:06:10', null, seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-01-30 17:00:50', null, seq_attr_id.currval);

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

call insert_museum(to_number('38,72079'), to_number('-9,11705'), 'Museu Nacional do Azulejo',
'Atraves das suas atividades, o museu da a conhecer a historia do Azulejo em Portugal procurando chamar a atencao da sociedade para a necessidade e importancia da protecao daquela que e a express�o artistica diferenciadora da cultura portuguesa no mundo: o Azulejo.',
'+351218100340' ,'http://www.museudoazulejo.pt/', null, timestamp '2020-01-01 12:31:12', null, 'Azulejo(tema)', 'portugues', date '2001-04-28', date '2001-05-28', timestamp '1997-06-01 10:00:00', timestamp '1997-06-01 12:00:00');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 21:05:27', null, seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2000-06-10 10:28:31', 'Maria Jose', seq_attr_id.currval);

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

call insert_hotel (to_number('40,67611'), to_number('7,70694'), 'Casa da Insua', 'Perfeitamente integrado num Palacete Barroco do sec. XVIII, onde cada sala e cada recanto nos transportam para a historia dos seus proprietarios e para momentos da historia de Portugal e do Brasil, o Parador Casa da Insua conjuga passado e presente, com detalhes que fazem os seus visitantes sentir-se como parte dessa historia.',
'+351232640110', 'https://montebelohotels.com/parador-casa-insua/pt/home', null, timestamp '2019-12-24 15:05:23', 'Joseph Walks', 5, 'T', 'F', 'F', 'portugues', date '2001-04-27', date '2001-05-27', timestamp '1997-06-01 10:00:00', timestamp '1997-06-01 12:00:00');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 15:09:30', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 15:20:49', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 15:34:45', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 16:02:02', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-24 21:59:37', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-09 07:03:05', null, seq_attr_id.currval);

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

call insert_hotel (to_number('38,69491'), to_number('-9,21472'), 'Palacio do Governador',
'Nao e apenas mais um hotel em Lisboa. E o Palacio do Governador, com 60 quartos, todos diferentes, junto ao rio Tejo, em pleno centro historico de Belem, numa das zonas mais bonitas e emblematicas da capital. Este emblematico hotel de charme faz reviver um legado historico impar, ao mesmo tempo que enaltece a qualidade, exclusividade e requinte.',
'+351213007009', 'https://www.palaciogovernador.com/', null, timestamp '2019-03-29 11:12:05', null, 5, 'T', 'T', 'T', 'portugues', date '2001-04-26', date '2001-05-26', timestamp '1997-06-01 10:00:00', timestamp '1997-06-01 12:00:00');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-05-18 17:23:12', null, seq_attr_id.currval);

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

call insert_restaurant (to_number('38,69491'), to_number('-9,21472'), 'Restaurante e Bar Anfora',
'Uma anfora guarda a mais pura essencia das coisas e liberta-as do que nao e primordial.
E este, tambem, o principio do restaurante do Palacio do Governador, em que cada prato servido acentua nao mais que o essencial:
o sabor trazido pelos melhores produtos da terra e do mar.',
'+351212467800', 'https://www.palaciogovernador.com/restaurante-e-bar.html', null, timestamp '2019-12-09 07:03:05', null, 'O mais Portugues de Portugal', 'Portugues', 'portugues', date '2001-04-25', date '2001-05-25', timestamp '1997-06-01 10:00:00', timestamp '1997-06-01 12:00:00');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-19 07:03:05', null, seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-11-19 07:03:05', null, seq_attr_id.currval);

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

call insert_restaurant (to_number('40,69491'), to_number('-7,21472'), 'Restaurante Fake News I',
'Neste restaurante falso come-se comida verdadeira.',
'+351212487800', 'https://www.fake1.com/restaurante-e-bar.html', null, timestamp '2019-12-09 07:03:05', null, 'Bacalhau à Lagareiro', 'Peixe', 'portugues', date '2001-04-23', date '2001-05-23', timestamp '1997-06-01 10:00:00', timestamp '1997-06-01 12:00:00');

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

call insert_restaurant (to_number('42,69491'), to_number('-7,21472'), 'Restaurante Fake News II',
'Neste restaurante falso tambem se come comida verdadeira.',
'+351212467801', 'https://www.fake2.com/restaurante-e-bar.html', null, timestamp '2019-12-09 07:03:05', null, 'Salmao', 'Sushi', 'portugues', date '2001-04-22', date '2001-05-22', timestamp '1997-06-01 10:00:00', timestamp '1997-06-01 12:00:00');

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

call insert_restaurant (to_number('40,69491'), to_number('-7,21472'), 'Restaurante Fake News III',
'Este restaurante falso é melhor que os outros.',
'+351212587800', 'https://www.fake3.com/restaurante-e-bar.html', null, timestamp '2019-12-09 07:03:05', null, 'Pizza de Pepperoni', 'Pizzaria', 'portugues', date '2001-04-29', date '2001-05-29', timestamp '1997-06-01 10:00:00', timestamp '1997-06-01 12:00:00');

insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-12-19 07:03:05', null, seq_attr_id.currval);
insert into pictures(picture_descr, picture_date, photographer, attraction_id) values(null, timestamp '2019-11-19 07:03:05', null, seq_attr_id.currval);

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
