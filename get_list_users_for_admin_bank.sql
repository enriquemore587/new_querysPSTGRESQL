CREATE OR REPLACE FUNCTION "cw"."get_list_users_for_admin_bank"(
		IN "in_bank_id" INTEGER,
		OUT "users_list" json
)
AS $BODY$
DECLARE
    u_row cw.users%ROWTYPE;
DECLARE temp_text TEXT;
DECLARE temp_row TEXT;
BEGIN

		temp_text:= '[';
		temp_row := '';
		-- RETORNA LISTA DE USUARIOS PARA LA TABLA DEL FRONT
		FOR u_row IN SELECT * FROM "cw"."users"
		WHERE "id" in (SELECT user_id FROM "cw"."users_bank" WHERE bank_id = in_bank_id) AND (id_profile = 4 OR id_profile = 6)
    LOOP
				IF u_row.num_client IS NULL THEN
						u_row.num_client := 'NO DATA';
				END IF;
				IF u_row.mail IS NULL THEN
						u_row.mail := 'NO DATA';
				END IF;
				IF u_row.registration IS NULL THEN
						u_row.registration := 'NO DATA';
				END IF;
				temp_row := '{"id":"'||u_row.id||'",'
				||'"mail":"'||u_row.mail||'",'
				||'"registration":"'||u_row.registration||'",'
				||'"profile":"'||(SELECT description FROM cw.profiles WHERE "id" = u_row.id_profile)||'",'
				||'"num_client":"'||u_row.num_client||'"},';
				--raise notice 'temp_row: %', temp_row;
				temp_text:= temp_text||temp_row;
				--raise notice 'temp_text: %', temp_text;
    END LOOP;
    temp_text:= temp_text||']';
		temp_text:= replace(temp_text, ',]', ']');
		raise notice 'temp_text: %', temp_text;

	SELECT temp_text::json into users_list;
	--raise notice 'data_user: %', data_user;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;

SELECT cw.get_list_users_for_admin_bank(5);