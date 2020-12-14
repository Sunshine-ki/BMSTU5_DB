CREATE TABLE IF NOT EXISTS users_json
(
    doc JSON
);

INSERT INTO users_json
SELECT * FROM users_import;

SELECT * FROM users_json;
