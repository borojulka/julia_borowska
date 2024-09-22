--1. Wstęp. Analiza tabeli.
select * from all_seasons as2
where player_height> 0 and player_weight> 0 and gp>0;
--Wniosek: Tabela zawiera 12 844 rekordy. W przypadku wzrostu zawodnika, wagi zawodnika oraz liczby rozegranych meczy zastosowano warunek, że muszą być one większe od 0. Warunek ten nie zmienił liczby rekordów w tabeli. 

--2.Wstępna analiza danych.
--2.1 Ilość unikalnych graczy.
select distinct player_name,country
from all_seasons as2;
--Wniosek: W latach 1996-2023 w lidze NBA wystąpiło 2559 graczy. Pokazuje to, jak trudne i wymagające jest dostanie się do tej ligi.

--2.2 Średni wzrost zawodnika w podziale na sezony (analiza trendu).
select avg(player_height) as avarage_player_height, season 
from all_seasons as2
group by season
order by season; 
--Wniosek: W latach 1996-2018 średni wzrost zawodnika występującego w lidze NBA wynosił ponad 2m. Od 2019 roku systematycznie waha się on między 198 cm a 199cm.

--2.3 Średnia waga zawodnika w podziale na sezony (analiza trendu).
select avg(player_weight) as avarage_player_weight, season 
from all_seasons as2
group by season
order by season; 
--Wniosek: Do 2015 roku średnia waga zawodnika NBA wynosiła ponad 100kg, z kolei od sezonu 2016-2017 oscyluje poniżej tej wartości.

--2.4 Średnie BMI w podziale na sezony (analiza trendu).
alter table all_seasons
add column BMI INT;
alter table all_seasons 
alter column bmi type FLOAT;

update all_seasons 
set BMI= player_weight /((player_height / 100) * (player_height / 100));

select avg(bmi) as avarage_player_bmi, season 
from all_seasons as2
group by season
order by season; 
--Wniosek: Średnie BMI zawodnika oscyluje w granicach 24, przez cały badany okres.

--2.5 Analiza wskaźnika BMI. 
alter table all_seasons 
add column bmi_ranges varchar(20);

update all_seasons 
set bmi_ranges =
	case
		when bmi < 18.500 then 'underweight'
		when bmi >= 18.500 and bmi <= 24.999 then 'healthy weight'
		when bmi >=25.000 then 'overweight'
	end;

select bmi_ranges, season, count(player_name) as no_of_players
from all_seasons as2 
group by season, bmi_ranges
order by season asc, bmi_ranges asc;
--Wniosek: Sezony 2006-2007, 2008-2009, 2009-2010,2010-2011 były jedynymi sezonami w historii ligi NBA, kiedy zawodników z nadwagą było więcej niż tych ze zdrową masą ciała.  W pozostałych sezonach przeważali zawodnicy ze zdrową masą ciała. 
--Co ciekawe, w żadnym z analizowanych sezonów, nie wystąpił zawodnik posiadający zbyt niską masę ciała.

--2.5.1 Kraj pochodzenia a skłonności do bycia overweight.
select country, count(player_name) as no_of_overweight_players
from all_seasons as2 
where bmi_ranges = 'overweight'
group by country
order by no_of_overweight_players desc;
--Wniosek: Ponadto, według tej analizy na 3 Polaków, którzy wystepowali w lidza NBA, wszyscy byli overweighted.

--2.6 Średnia wieku koszykarza w NBA w poszczególnych sezonach.
select avg(age) as average_age, season 
from all_seasons as2 
group by season 
order by season asc;
--Wnioski: W sezonie 2020-2021 występowali najmłodsi zawodnicy, z kolei w sezonie 1999-2000-najstarsi, Ogólnie średnia wieku koszykarza charakteryzuje się trendem malejącym.

--3.Analiza wpływu cech fizycznych na wydajność zawodnika
--3.1 Korelacja między wagą zawodnika a liczbą rozegranych meczy.
select corr(player_weight, gp) as weight_games_corr
from all_seasons as2;
0.022827550081647965
--Wniosek: Wartość 0.0228 oznacza, że waga zawodnika i liczba rozegranych meczy nie są ze sobą istotnie powiązane. Korelacja dodatnia sugeruje, że teoretycznie, gdy waga zawodnika rośnie, liczba meczów może nieznacznie rosnąć, ale ten efekt jest minimalny i prawdopodobnie nieistotny w praktyce.

--3.2 Korelacja między wzrostem zawodnika a liczbą rozegranych meczy.
select corr(player_height, gp) as height_games_corr
from all_seasons as2;
0.004962855425824285
--Wniosek: Wynik ten sugeruje brak istotnej korelacji między wzrostem a liczbą rozegranych meczy.

--3.3 Korelacja między wagą zawodnika a liczbą zdobytych punktów na mecz.
select corr(player_weight, pts) as weight_pts_corr
from all_seasons as2;
-0.025022904113259328
--Wniosek: brak istotniej korelacji między wybranymi zmiennymi.

--3.4 Korelacja między wzrostem zawodnika a liczbą zdobytych punktów na mecz.
select corr(player_height, pts) as height_pts_corr
from all_seasons as2; 
-0.05528425121434217
--Wniosek: brak istotniej korelacji między wybranymi zmiennymi.

--3.5 Korelacja między wagą zawodnika a liczbą asyst na mecz.
select corr(player_weight, ast) as weight_ast_corr
from all_seasons as2; 
-0.37167547739327567
--Wniosek: korelacja miedzy tymi dwoma zmiennymi jest dość silna, dodatnia. Oznacza to, że wraz ze wzrostem wagi zawodnika rośnie jego skuteczność w rozdawaniu asyst na mecz. Jest to jednak zbyt małą korelacja, aby nazwać ją regułą.

--3.6 Korelacja między wzrostem zawodnika a liczbą asyst na mecz.
select corr(player_height, ast) as height_ast_corr
from all_seasons as2; 
-0.4427806169617119
--Wniosek: W tym przypadku występuje ujemna korelacja. Co oznacza, że im wyższy jest zawodnik, tym mniej asyst zdobywa w ciągu meczu. To sugeruje, że wyżsi zawodnicy są mniej skłonni lub mają mniejsze możliwości rozdawania asyst, co może być związane z ich rolą na boisku (np. wyżsi zawodnicy mogą częściej grać na pozycjach, gdzie rozgrywanie piłki i asystowanie nie jest główną funkcją).

--3.7 Korelacja między wagą zawodnika a liczbą zbiórek na mecz.
select corr(player_weight, reb) as weight_reb_corr
from all_seasons as2; 
0.43811193285290545
--Wniosek: Korelacja jest dość silna- oznacza to, że waga zawodnika oraz liczb zbiórek na mecz są ze sobą istotnie, dodatnio powiązane.

--3.8 Korelacja między wzrostem zawodnika a liczbą zbiórek na mecz.
select corr(player_height, reb) as height_reb_corr
from all_seasons as2; 
0.42422048139274304
--Wniosek: Jest to dość silna, dodatnia korelacja, która sugeruje, że im wyższy jest zawodnik, tym więcej zbiórek na mecz będzie w stanie "zebrać".


--4. Analiza związku między wiekiem zawodnika i liczby rozegranych meczy oraz zdobytych punktów na mecz.
--4.1 Korelacja między wiekiem zawodnika a liczbą rozegranych meczy.
select corr(age, gp) as age_gp_corr
from all_seasons as2; 
0.057442430097100844
--Wniosek: brak istotniej korelacji między tymi dwoma zmiennymi.

--4.2 Korelacja między wiekiem zawodnika a liczbą zdobytych punktów na mecz.
select corr(age, pts) as age_pts_corr
from all_seasons as2; 
0.011353234342826476
--Wniosek: brak istotniej korelacji między wybranymi zmiennymi.


--5. Optymalna waga i wzrost zawodnika.
--5.1 Jaki wzrost i jaka waga ma najwięcej zbiórek ofensywnych - zawodnicy na atak.
select player_height, player_weight, sum(oreb_pct) as offensive_rebounds
from all_seasons as2
group by player_height, player_weight 
order by offensive_rebounds desc
limit 10;
--Wniosek: wszyscy powyżej 2m, Wszyscy powyżej 100kg, między 106 a 120 kg.

--5.2 Jaki wzrost i jaka waga ma najwięcej zbiórek defensywnych - zawodnicy na obrone.
select player_height, player_weight, sum(dreb_pct) as deffensive_rebounds
from all_seasons as2
group by player_height, player_weight 
order by deffensive_rebounds desc
limit 10;
--Wniosek: wzrost powyzej 2m, waga miedzy 106 a 113kg

--5.3 Jaki wzrost i jaka waga utrzymuje najlepszy stosunek net rating przez całą karierę. 
select player_height, player_weight, sum(net_rating) as net_rating_overall
from all_seasons as2
group by player_height, player_weight 
order by net_rating_overall desc
limit 10;
--Wniosek: wzrost 187-210cm, waga 78-120kg- brak zasady.

--5.4 Jaki wzrost i jaka waga pozwala zawodnikom najczęściej trafiać z odległości 6.75 metra od kosza. (rzuty za 3 punkty)
select player_height, player_weight, sum(ts_pct) as true_shooting_percantage
from all_seasons as2
group by player_height, player_weight 
order by true_shooting_percantage desc
limit 10;
--Wniosek: wzrost 109-210cm; waga 86-108kg.

--5.5 Jaki wzrost oraz waga zawodnika utrzymuje najlepszy procent udanych asyst?
select player_height, player_weight, sum(ast_pct) as ast_percantage
from all_seasons as2
group by player_height, player_weight 
order by ast_percantage desc
limit 10;
--Wniosek: wzrost: 182-198cm, waga 79-99kg.
	
--6.Analiza wpływu miejsca urodzenia na karierę zawodnika.
--6.1 Wstępna analiza danych.
select country, count(player_name) as nations_in_nba
from all_seasons as2 
group by country
order by nations_in_nba desc;
--Wniosek: Najwięcej zawodników w lidze NBA w badanym okresie pochodziło w zatrważającej większości z USA.

--6.2 średnia liczba lat, jaką koszykarze z danego kraju grają w NBA
select player_name, country, 
	min(cast(substring(season,1,4) as int)) as first_season,
	max(cast(substring(season,1,4) as int)) as last_season,
	(max(cast(substring(season,1,4) as int)) - min(cast(substring(season,1,4) as int)) + 1) as years_in_NBA
from all_seasons as2 
group by player_name, country
order by years_in_NBA desc;

with years_in_NBA as (
	select player_name, country, (max(cast(substring(season,1,4) as int)) - min(cast(substring(season,1,4) as int)) + 1) as years_in_NBA
from all_seasons as2 
group by player_name, country
)
select country, avg(years_in_NBA) as average_years_in_NBA
from years_in_NBA 
group by country
order by average_years_in_NBA desc;

--6.3 Związek między krajem pochodzenia a rundą wyboru w drafcie.
select country, draft_round, count(player_name) as no_of_players
from all_seasons as2 
where draft_round <> 'Undrafted'
group by country, draft_round 
order by country, draft_round desc;

--6.4 Związek między krajem pochodzenia a liczbą rozegranych meczy
--6.5 Ilość obcokrajowców wybranych w drafcie w danym roku
select draft_year, count(player_name) as players_per_drafts
from all_seasons as2 
where country <> 'USA' and draft_year <> 'Undrafted'
group by draft_year
order by players_per_drafts;
--Wniosek: Najwięcej obcokrajowców, występowało w lidze NBA  w 2011- było ich wtedy 111. Stanowili więc oni około 1/4 wszystkich zawodników NBA we wspomnianym roku.
	
--7. Podsumowanie
--7.1 Koszykarze, którzy w swojej karierze zdobyli więcej punktów niż ogólna średnia liczba punktów w danym sezonie.
select season, avg(pts) as avg_pts_per_season
from all_seasons as2 
group by season
order by season;

with avg_pts_per_season as(
	select season, avg(pts) as avg_pts_per_season
	from all_seasons as2 
	group by season
	order by season
	)
select player_name, player_height, player_weight, as2.season, pts, avg_pts_per_season
from all_seasons as2
join avg_pts_per_season apps
on as2.season= apps.season
where as2.pts > apps.avg_pts_per_season
order by as2.season, as2.player_name;
--Wniosek: 5190 zawodników

--7.2 Koszykarze, którzy w swojej karierze posiadali więcej asyst niż ogólna średnia liczba asyst.
select season, avg(ast) as avg_ast_per_season
from all_seasons as2
group by season 
order by season;

with avg_ast_per_season as(
	select season, avg(ast) as avg_ast_per_season
	from all_seasons as2 
	group by season 
	order by season 
	)
select player_name, player_height, player_weight, as2.season, ast, avg_ast_per_season
from all_seasons as2 
join avg_ast_per_season aaps
on as2.season= aaps.season
where as2.ast> aaps.avg_ast_per_season
order by as2.season, as2.player_name;
--Wniosek: 4159 takich rekordów

--7.3 Koszykarze, którzy w swojej karierze posiadali więcej zbiórek niż ogólna średnia liczba zbiórek.
select season, avg(reb) as avg_reb_per_season
from all_seasons as2
group by season 
order by season;

with avg_reb_per_season as(
	select season, avg(reb) as avg_reb_per_season
	from all_seasons as2 
	group by season 
	order by season 
	)
select player_name, player_height, player_weight, as2.season, ast, avg_reb_per_season
from all_seasons as2 
join avg_reb_per_season aaps
on as2.season= aaps.season
where as2.ast> aaps.avg_reb_per_season
order by as2.season, as2.player_name;
--Wniosek: 1788 takich zawodników.

--7.4 Koszykarze, którzy przez całą karierę utrzymują dodatni stosunek net_rating.
select player_name
from all_seasons as2 
where net_rating >0
group by player_name
order by player_name;
--Wniosek: 1673 takich zawodników





