CREATE OR REPLACE FUNCTION "cw"."get_list_solicitantes_for_director_bank"(
		IN "in_bank_id" INTEGER,
		OUT "users_list" json
)
AS $BODY$
DECLARE
    u_row cw.user_credit_request%ROWTYPE;
DECLARE
    upd_row cw.user_personal_data%ROWTYPE;
DECLARE
    user_row cw.users%ROWTYPE;
DECLARE temp_text TEXT;
DECLARE temp_row TEXT;
BEGIN

		temp_text:= '[';
		temp_row := '';
		-- RETORNA LISTA DE USUARIOS PARA LA TABLA DEL FRONT EN EL MODULO DE AUDITORIAS
		FOR u_row IN SELECT * FROM "cw"."user_credit_request"
		WHERE bank_id = in_bank_id ORDER BY request_date DESC
    LOOP
		SELECT * INTO upd_row FROM cw.user_personal_data WHERE "id"=u_row.user_id;
		SELECT * INTO user_row FROM cw.users WHERE "id"=u_row.user_id;
		raise notice 'u_row: %', u_row;
			temp_row := '{"id":"'||u_row.user_id||'",'
				||'"numero":"'|| (user_row.num_client)||'",'
				||'"nombre":"'|| (upd_row.name)||' '||(upd_row.last_name)||' '||(upd_row.last_name2)||'",'
				||'"gender":"'|| (upper(upd_row.gender))||'",'
				||'"level_study":"'|| (SELECT description FROM cw.level_studies WHERE id = upd_row.level_study)||'",'
				||'"occupation":"'|| (SELECT "name" FROM cw.occupations WHERE id = upd_row.ocupations_id)||'",'
				||'"ingreso_declarado":'|| (u_row.ingreso_declarado)||','
				||'"approved":'|| (u_row.approved)||'},';
			temp_text:= temp_text||temp_row;
    END LOOP;
		
    temp_text:= temp_text||']';
		temp_text:= replace(temp_text, ',]', ']');
		--raise notice 'temp_text: %', temp_text;
	SELECT temp_text::json into users_list;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;

SELECT cw.get_list_solicitantes_for_director_bank(5);