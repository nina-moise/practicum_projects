-- QL-запросы к дашборду TED-конференции
-----------------------------------------

-- QL-TOP-10 профессий с ФИО спикера
select substr(sp.speaker_occupation,1,40) as Сфера_деятельности,
       substr(sp.speaker_name,1,25) as Имя,
       cast(sum(coalesce(t.applause_count,0)) as varchar) as Аплодисменты
from ted.talks as t
join ted.events as e on e.conf_id=t.event_id
join ted.speakers as sp on sp.author_id=t.speaker_id
  where 
      case -- страна
        when length({{par_country}}::varchar)=0 then TRUE
        else e.country in {{par_country}}
      end AND
      case --конференция
        when length({{par_event_name}}::varchar)=0 then TRUE
        else e.event_name in {{par_event_name}}
      end AND
      case --тема
        when length({{par_tag}}::varchar)=0 then TRUE
        else t.main_tag in {{par_tag}}
      end AND
      -- фильм
      film_date::date 
      between {{par_film_record_from}} and {{par_film_record_to}}
group by  sp.speaker_occupation,
          sp.speaker_name     
order by sp.speaker_occupation;

-- QL-TOP-10 смешных
select concat(t.title,', ',sp.speaker_name,', ',e.event_name) as info,
       sum (t.laughter_count) as Смех
from ted.talks as t
join ted.events as e on e.conf_id=t.event_id
join ted.speakers as sp on sp.author_id=t.speaker_id
  where t.laughter_count is not NULL and 
      case -- страна
        when length({{par_country}}::varchar)=0 then TRUE
        else e.country in {{par_country}}
      end AND
      case --конференция
        when length({{par_event_name}}::varchar)=0 then TRUE
        else e.event_name in {{par_event_name}}
      end AND
      case --тема
        when length({{par_tag}}::varchar)=0 then TRUE
        else t.main_tag in {{par_tag}}
      end AND
      -- фильм
      film_date::date between {{par_film_record_from}} and {{par_film_record_to}}
 group by concat(t.title,', ',sp.speaker_name,', ',e.event_name)
 order by Смех desc
limit 10;

-- QL-ТОП-20 тэгов
select t.main_tag as тэг, sum(t.views_count) as Просмотров
from ted.talks as t
join ted.events as e on e.conf_id=t.event_id
where t.main_tag is not null and 
      case -- страна
        when length({{par_country}}::varchar)=0 then TRUE
        else e.country in {{par_country}}
      end AND
      case --конференция
        when length({{par_event_name}}::varchar)=0 then TRUE
        else e.event_name in {{par_event_name}}
      end AND
      case --тема
        when length({{par_tag}}::varchar)=0 then TRUE
        else t.main_tag in {{par_tag}}
      end AND
      -- фильм
      film_date::date between {{par_film_record_from}} and {{par_film_record_to}}
group by t.main_tag
order by Просмотров desc
limit 20;