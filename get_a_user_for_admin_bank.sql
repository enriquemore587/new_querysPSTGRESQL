CREATE OR REPLACE FUNCTION "cw"."get_a_user_for_admin_bank"(
		IN "in_user_id" varchar,
		OUT "data_user" json
)
AS $BODY$
DECLARE
    user_row cw.user_personal_data%ROWTYPE;
DECLARE
    u_row cw.users%ROWTYPE;
DECLARE temp_text TEXT;
DECLARE request_id INTEGER;

BEGIN

	
	SELECT * INTO user_row FROM cw.user_personal_data AS upd WHERE upd."id" = in_user_id::uuid;

	SELECT * INTO u_row FROM cw.users AS upd WHERE upd."id" = in_user_id::uuid;

	IF user_row.rfc IS NULL THEN
			user_row.rfc := 'NO DATA';
	END IF;
	IF u_row.num_client IS NULL THEN
			u_row.num_client := 'NO DATA';
	END IF;
	IF user_row.name IS NULL THEN
			user_row.name := 'NO DATA';
	END IF;
	IF user_row.name2 IS NULL THEN
			user_row.name2 := '';
	END IF;
	IF user_row.last_name IS NULL THEN
			user_row.last_name := 'NO DATA';
	END IF;
	IF user_row.last_name2 IS NULL THEN
			user_row.last_name2 := 'NO DATA';
	END IF;
	IF u_row.mail IS NULL THEN
			u_row.mail := 'NO DATA';
	END IF;
	
	SELECT '{"rfc": "'||user_row.rfc||
	'", "num_client": "'||u_row.num_client||
	'", "email": "'||u_row.mail||
	'", "name": "'||user_row.name||
	'", "name2": "'||user_row.name2||
	'", "last_name": "'||user_row.last_name||
	'", "last_name2": "'||user_row.last_name2||
	'", "profile": "'||(SELECT description FROM cw.profiles WHERE "id" = u_row.id_profile)::TEXT||
	'"}' into temp_text;

	SELECT temp_text::json INTO data_user;
	--raise notice 'data_user: %', data_user;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

SELECT cw.get_a_user_for_admin_bank('41343e72-a624-4850-aed1-515395f12cec');