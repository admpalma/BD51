-- Functions
create or replace FUNCTION calc_number_ratings(attraction NUMBER) RETURN NUMBER
IS
numberOfRatings NUMBER;
BEGIN
SELECT count(rating)
INTO numberOfRatings
FROM reviews inner join attractions using (attraction_id)
WHERE attraction = attraction_id;
RETURN numberOfRatings;
END calc_number_ratings;
/

create or replace FUNCTION calc_ratings(attraction NUMBER) RETURN NUMBER
IS
totalRatings NUMBER;
BEGIN
SELECT sum(rating)
INTO totalRatings
FROM reviews inner join attractions using (attraction_id)
WHERE attraction = attraction_id;
RETURN totalRatings;
END calc_ratings;
/

-- Queries

-- Quais as avaliacoes escritas em portugues cujo rating seja maior ou igual que 3,
-- dizendo para cada avaliacao a atracao, o comentario e o nome do autor?
select attraction_name, review_text, tourist_name
from reviews inner join tourists using (tourist_id) inner join attractions using (attraction_id)
where language = 'portugues' and rating >= 3;

select * from reviews where language = 'portugues';

-- Insert this visit to test next query
insert into visits(arrival_time, departure_time, tourist_id, attraction_id)
values (timestamp '2019-07-01 15:03:30', timestamp '2019-10-01 15:04:30', 9 ,seq_attr_id.currval);

-- Quais os turistas que tiveram uma estadia de mais de 4 dias no hotel X,
-- para cada turista mencionando o nome, a nacionalidade, o NIF e a data de nascimento?
select tourist_name as "Name", nationality, nif, birth_date
from tourists inner join visits using(tourist_id) 
              inner join hotels using(attraction_id)
              inner join attractions using(attraction_id)
where attraction_name = 'Palacio do Governador' and departure_time - arrival_time >= interval '4' day;

select distinct tourist_name, attraction_name
from visits inner join tourists using(tourist_id) inner join attractions using(attraction_id);

select * from hotels inner join attractions using(attraction_id) inner join visits using (attraction_id);

-- Quais sao os museus que estao abertos 'a noite?
select distinct attraction_name
from museums inner join attractions using(attraction_id) inner join schedules_of using(attraction_id)
where schedules_of.opening_time <= timestamp '0001-01-01 20:00:00' and
    schedules_of.closing_time >= timestamp '0001-01-01 23:00:00';


-- For each attraction name, what is the average ratings of that attraction?
select attraction_name, calc_ratings(attraction_id) / calc_number_ratings(attraction_id) as "Average Rating"
from attractions
order by "Average Rating" desc;

select attraction_name, avg(rating) as averageRating
from attractions inner join reviews using (attraction_id)
group by attraction_name
order by averageRating desc;

-- Quais os nomes e localizacoes das atracoes cuja avaliacao geral e igual ou superior a 4?
select attraction_name, latitude, longitude
from attractions
where (calc_ratings(attraction_id) / calc_number_ratings(attraction_id)) >= 4;


-- Quais as atracoes visitadas por todos os turistas que ja visitaram a atracao X,
-- dizendo para cada atracao o nome, a classificacao geral, o contacto telefonico e o website?
select distinct attraction_name,attraction_phone, attraction_website
from visits X, attractions A
where not exists (
    (select tourist_id
    from visits inner join attractions using(attraction_id) where attraction_name = 'Restaurante Fake News II')
    minus
    (select Y.tourist_id
    from visits Y
    where X.attraction_id = Y.attraction_id)
) and X.attraction_id = A.attraction_id and attraction_name != 'Restaurante Fake News II';
