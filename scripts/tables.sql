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

create table languages(
    language varchar2(20),
    constraint pk_language primary key(language)
);

create table employee_speaks(
    attraction_id number(11,0),
    language varchar2(20),
    constraint fk_empSpeakAtr foreign key(attraction_id) references attractions (attraction_id)
    on delete cascade,
    constraint fk_empSpeakLang foreign key(language) references languages(language)
    on delete cascade,
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

create table visits(
    arrival_time timestamp,
    departure_time timestamp not null,
    tourist_id number(11,0),
    attraction_id number(11,0),
    constraint fk_visitTourist foreign key(tourist_id) references tourists(tourist_id)
    on delete cascade,
    constraint fk_visitAtr foreign key(attraction_id) references attractions(attraction_id)
    on delete cascade,
    constraint pk_ primary key(arrival_time, tourist_id, attraction_id),
    constraint departAfterArrival check(arrival_time - departure_time > interval '0' second)
);

create table reviews(
    review_date date,
    rating number(1,0) not null,
    review_text varchar2(230),
    language varchar2(20) not null,
    arrival_time timestamp,
    tourist_id number(11,0),
    attraction_id number(11,0),
    constraint fk_reviewLang foreign key(language) references languages(language)
    on delete cascade,
    constraint fk_reviewVisit foreign key(arrival_time, tourist_id, attraction_id)
        references visits(arrival_time, tourist_id, attraction_id)
        on delete cascade,
    constraint pk_review primary key(arrival_time, tourist_id, attraction_id, review_date),
    constraint ratingLimit check(rating >= 1 and rating <= 5)
);

create table tourist_speaks(
    tourist_id number(11,0),
    language varchar2(20),
    constraint fk_tSpeakTourist foreign key (tourist_id) references tourists(tourist_id)
    on delete cascade,
    constraint fk_tSpeakLang foreign key (language) references languages(language)
    on delete cascade,
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
    constraint fk_serveFood foreign key(food_type) references food_types(food_type)
    on delete cascade,
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
    constraint fk_guideLang foreign key(language) references languages(language)
    on delete cascade,
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
        references schedules(start_date, end_date, opening_time, closing_time)
        on delete cascade,
    constraint fk_scheduleOfAtr foreign key(attraction_id) references attractions(attraction_id)
    on delete cascade,
    constraint pk_scheduleOf primary key(start_date, end_date, opening_time, closing_time, attraction_id)
);

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


create sequence seq_tour_id
start with 1
increment by 1;

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Jose Mortagua', '1987-05-13', '983763234', 'portugues(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'portugues');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Jacques Francois', '1978-01-30', '756283947', 'frances(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'alemao');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Monica Wright', '1995-09-10', '576039003', 'ingles(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'chines');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Fei Wei Wei', '1976-04-25', '352857337', 'chines(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'chines');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Park Jimin', '1995-10-13', '462362718', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Kim Taehyung', '1995-12-30', '656646477', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');


insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Vance Stevenson', '1987-07-07', '222288882', 'americano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Vivian Ybarra', '1977-09-15', '465823745', 'italiano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'italiano');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Leocadia Banderas', '1968-02-19', '111888444', 'espanhol(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'espanhol');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'italiano');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Zac Baldwin', '2001-08-29', '444888222', 'americano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Valerie Bourdoix', '1998-03-19', '123987654', 'frances(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Artur Banderas', '1962-11-12', '342764777', 'espanhol(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'espanhol');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Sebastian Bourdoix', '1992-02-01', '342634294', 'frances(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Chrollo Lucilfer', '1992-07-30', '666000666', 'ingles(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Jeon Jungkook', '1997-09-01', '111111111', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');


insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Kim Seokjin', '1992-12-04', '192129921', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Kim Namjoon', '1994-09-12', '252525124', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Min Yoongi', '1993-03-09', '666455545', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');


insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Jung Hoseok', '1994-02-18', '666055545', 'coreano(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'coreano');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'japones');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'chines');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Marcela Souza', '1987-07-20', '616055005', 'portugues(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'portugues');


insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Chica Silva', '2003-08-21', '616033005', 'espanhol(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'espanhol');


insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Alexandre Souza', '1987-03-10', '616075005', 'portugues(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'portugues');

insert into tourists(tourist_id, tourist_name, birth_date, NIF, nationality) values(seq_tour_id.nextval, 'Andre Santos', '2001-04-30', '010000022', 'portugues(a)');

insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'portugues');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'ingles');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'frances');
insert into tourist_speaks(tourist_id, language) values (seq_tour_id.currval, 'russo');

create sequence seq_attr_id
start with 1
increment by 1;

create sequence seq_pic_id
start with 1
increment by 1;

insert into attractions(latitude, longitude, attraction_id, attraction_name, attraction_descr, attraction_phone, attraction_website) values(38.69158, -9.21597, seq_attr_id.nextval, 'Torre de Belem',
'Construida estrategicamente na margem norte do rio Tejo entre 1514 e 1520, sob orientacao de Francisco de Arruda, a Torre de Belem e uma das joias da arquitetura do reinado de D. Manuel I.
O monumento faz uma sintese entre a torre de menagem de tradicao medieval e o baluarte, mais largo, com a sua casamata onde se dispunham os primeiros dispositivos aptos para resistir ao fogo de artilharia. [+]',
'+351213620034', 'http://www.torrebelem.pt/');

insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2010-01-31 09:26:50', null, seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2015-05-31 10:30:54', null, seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval,'Torre de Belem, perfil, noite', '2019-06-01 23:03:30','Joao Bravo' , seq_attr_id.currval);

--Missing schedule

insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'frances');

insert into museums(attraction_id, theme) values(seq_attr_id.currval, 'Torre de Belem (tema)');

insert into guides(language, attraction_id) values ('portugues', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('ingles', seq_attr_id.currval);

insert into attractions(latitude, longitude, attraction_id, attraction_name, attraction_descr, attraction_phone, attraction_website) values(38.69789, -9.20670, seq_attr_id.nextval, 'Mosteiro dos Jeronimos',
'Ligado simbolicamente aos mais importantes momentos da memoria nacional, o Mosteiro dos Jeronimos (ou Real Mosteiro de Santa Maria de Belem) foi fundado pelo rei D. Manuel I no inicio do seculo XVI. As obras iniciaram-se justamente no virar do seculo, lancando-se a primeira pedra na data simbolica de 6 de Janeiro (dia de Reis) de 1501 ou 1502.[+]', '+351213620034', 'http://www.mosteirojeronimos.pt/');

insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-10-21 12:26:40', 'John Miller', seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2018-12-23 15:06:10', null, seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-01-30 17:00:50', null, seq_attr_id.currval);

insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'frances');

insert into museums(attraction_id, theme) values(seq_attr_id.currval, 'Mosteiro dos Geronimos(tema)');

insert into guides(language, attraction_id) values ('portugues', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('ingles', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('espanhol', seq_attr_id.currval);


insert into attractions(latitude, longitude, attraction_id, attraction_name, attraction_descr, attraction_phone, attraction_website) values (38.72079, -9.11705, seq_attr_id.nextval, 'Museu Nacional do Azulejo', 'Atraves das suas atividades, o museu da a conhecer a historia do Azulejo em Portugal procurando chamar a atencao da sociedade para a necessidade e importancia da protecao daquela que e a express�o artistica diferenciadora da cultura portuguesa no mundo: o Azulejo.', '+351218100340' ,'http://www.museudoazulejo.pt/');

insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2020-01-01 12:31:12', null, seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-12-24 21:05:27', null, seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2000-06-10 10:28:31', 'Maria Jose', seq_attr_id.currval);

insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'frances');

insert into museums(attraction_id, theme) values(seq_attr_id.currval, 'Azulejo');

insert into guides(language, attraction_id) values ('portugues', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('ingles', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('espanhol', seq_attr_id.currval);
insert into guides(language, attraction_id) values ('frances', seq_attr_id.currval);


insert into attractions(latitude, longitude, attraction_id, attraction_name, attraction_descr, attraction_phone, attraction_website)
values (40.67611, 7.70694, seq_attr_id.nextval,'Casa da Insua','Perfeitamente integrado num Palacete Barroco do sec. XVIII,
onde cada sala e cada recanto nos transportam para a historia dos seus proprietarios e para momentos da historia de Portugal e do Brasil,
o Parador Casa da Insua conjuga passado e presente, com detalhes que fazem os seus visitantes sentir-se como parte dessa historia.',
'+351232640110', 'https://montebelohotels.com/parador-casa-insua/pt/home');

insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-12-24 15:05:23', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-12-24 15:09:30', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-12-24 15:20:49', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-12-24 15:34:45', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-12-24 16:02:02', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-12-24 21:59:37', 'Joseph Walks', seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-12-09 07:03:05', null, seq_attr_id.currval);


insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'frances');

insert into hotels(attraction_id, stars, hasPool, hasSpa, hasGym) values(seq_attr_id.currval, 5, 'T', 'F', 'F');


insert into attractions(latitude, longitude, attraction_id, attraction_name, attraction_descr, attraction_phone, attraction_website) values(38.69491, -9.21472, seq_attr_id.nextval, 'Palacio do Governador','Nao e apenas mais um hotel em Lisboa. E o Palacio do Governador, com 60 quartos, todos diferentes, junto ao rio Tejo, em pleno centro historico de Belem, numa das zonas mais bonitas e emblematicas da capital. Este emblematico hotel de charme faz reviver um legado historico impar, ao mesmo tempo que enaltece a qualidade, exclusividade e requinte.', '+351213007009', 'https://www.palaciogovernador.com/');

insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-03-29 11:12:05', null, seq_attr_id.currval);
insert into pictures(picture_id, picture_descr, picture_date, photographer, attraction_id) values(seq_pic_id.nextval, null, '2019-05-18 17:23:12', null, seq_attr_id.currval);


insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'chines');

insert into hotels(attraction_id, stars, hasPool, hasSpa, hasGym) values(seq_attr_id.currval, 5, 'T', 'T', 'T');

insert into attractions(latitude, longitude, attraction_id, attraction_name,
attraction_descr, attraction_phone, attraction_website) values(38.69491, -9.21472, seq_attr_id.nextval,
'Restaurante e Bar Anfora','Uma anfora guarda a mais pura essencia das coisas e liberta-as do que nao e primordial.
E este, tambem, o principio do restaurante do Palacio do Governador, em que cada prato servido acentua nao mais que o essencial:
o sabor trazido pelos melhores produtos da terra e do mar.', '+351212467800', 'https://www.palaciogovernador.com/restaurante-e-bar.html');

insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'portugues');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'ingles');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'espanhol');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'frances');
insert into employee_speaks(attraction_id, language) values (seq_attr_id.currval, 'alemao');

insert into restaurants(attraction_id, main_dish) values(seq_attr_id.currval, 'O mais Portugues de Portugal');

--needs fixing vvv currval-1??
insert into belongs_to(restaurant_id, hotel_id) values(seq_attr_id.currval, seq_attr_id.currval -1);
