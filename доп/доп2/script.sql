CREATE TABLE IF NOT EXISTS EmplVisits
(
    department VARCHAR(16),
	fio VARCHAR(16),
	dt DATE,
	status VARCHAR(32)
);

SELECT * FROM EmplVisits;

SELECT department, fio, dt as date_from, dt as date_to, status FROM EmplVisits;

CREATE OR REPLACE FUNCTION get_interval()
RETURNS TABLE
(
    department VARCHAR(16),
	fio VARCHAR(16),
	date_from DATE,
	date_to DATE,
	status VARCHAR(32)
)
AS $$
# return value
rv = plpy.execute(f"SELECT department, fio, dt as date_from, dt as date_to, status FROM EmplVisits");
res = []

curr_status = rv[0]["status"]
curr_fio = rv[0]["fio"]
res.append(rv[0])

for i in range(len(rv)):
    if rv[i]["status"] != curr_status or rv[i]["fio"] != curr_fio:
        res[-1]["date_to"] = rv[i - 1]["date_from"]
        res.append(rv[i])
        curr_status = rv[i]["status"]
        curr_fio = rv[i]["fio"]

res[-1]["date_to"] = rv[-1]["date_from"]
return res
$$ LANGUAGE plpython3u;

SELECT * FROM get_interval();
