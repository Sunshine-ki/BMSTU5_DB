
select * from lab_08_nifi.device;

INSERT INTO lab_08_nifi.device(id, company, year_of_issue, color, price)
VALUES(1000, 'OOO coral', 2020, 'blue', 10000);

select *
from lab_08_nifi.device
order by  id;

delete from lab_08_nifi.device where id < 100;

-- {
--     "id": 1,
--     "company": "OOO First",
--     "year_of_issue": 2000,
--     "color": "blue",
--     "price": 10000
-- }
