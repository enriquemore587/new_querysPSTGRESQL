CREATE
OR REPLACE FUNCTION cw.get_user_for_formaliza (
	IN in_folio VARCHAR,
	IN in_search_mode VARCHAR,	--rfc, curp, folio
	IN in_id_bank INTEGER,
	OUT data_user json
) AS $$
DECLARE
    user_row cw.user_personal_data%ROWTYPE;
DECLARE
    user_address_row cw.user_address%ROWTYPE;
DECLARE
    user_credit_request_row cw.user_credit_request%ROWTYPE;
DECLARE temp_text TEXT;
DECLARE v_state VARCHAR;
BEGIN

	IF in_search_mode = 'folio' THEN


		SELECT * INTO user_row FROM cw.user_personal_data WHERE "id" = (SELECT user_id FROM cw.user_credit_request WHERE folio = in_folio);
		raise notice 'folio user_row: %', user_row;
		SELECT '{"nombre":"'||user_row.name::TEXT||' '||user_row.name2::TEXT
		||'", "paterno":"'||user_row.last_name::TEXT
		||'","materno":"'||user_row.last_name2::TEXT
		||'","rfc":"'||user_row.rfc::TEXT
		||'","curp":"'||user_row.curp::TEXT
		||'","user_id":"'||user_row.id::TEXT
		||'",'
		INTO temp_text;



		SELECT * INTO user_address_row FROM cw.user_address WHERE id = user_row.id::uuid;
		raise notice 'folio user_address_row: % id %', user_address_row,user_row.id;
		-- obtiene estado

		temp_text =  temp_text||'"direccion":'||'"'||user_address_row.street::TEXT
		
		||'no. '||user_address_row.ext::TEXT||', '||user_address_row.colony::TEXT||', '||user_address_row.cp::TEXT||
		', '||(SELECT descripcion from cw.municipalities WHERE id_states = user_address_row.state::INTEGER AND id = user_address_row.municipality::INTEGER)||
		', '||(SELECT descripcion from cw.states WHERE id = user_address_row.state::INTEGER)||
		
		'",';

		SELECT * INTO user_credit_request_row FROM cw.user_credit_request WHERE folio = in_folio;
		temp_text = temp_text||'"status_request": '||user_credit_request_row.approved||', "monto": '||user_credit_request_row.linea_aprobada_final::TEXT||', "plazo":'||user_credit_request_row.plazo_final::TEXT||', "tasa":'||user_credit_request_row.tasa_final::TEXT||', "mensualidad": '||user_credit_request_row.mensualidad_final::TEXT||', "producto": "PENSIONADOS"}';
		raise notice 'user_credit_request_row.linea_aprobada_final: %', user_credit_request_row.linea_aprobada_final;

	ELSIF in_search_mode = 'curp' THEN


		SELECT * INTO user_row FROM cw.user_personal_data WHERE curp = in_folio;
		--SELECT * INTO user_row FROM cw.user_personal_data WHERE "id" = (SELECT user_id FROM cw.user_credit_request WHERE folio = in_folio);
		raise notice 'curp user_row: % folio %', user_row,in_folio;
		SELECT '{"nombre":"'||user_row.name::TEXT||' '||user_row.name2::TEXT
		||'", "paterno":"'||user_row.last_name::TEXT
		||'","materno":"'||user_row.last_name2::TEXT
		||'","rfc":"'||user_row.rfc::TEXT
		||'","curp":"'||user_row.curp::TEXT
		||'","user_id":"'||user_row.id::TEXT
		||'",'
		INTO temp_text;

		SELECT * INTO user_address_row FROM cw.user_address WHERE id = user_row.id::uuid;
		raise notice 'curp user_address_row: % folio % id %', user_address_row,in_folio, user_row.id;
		-- obtiene estado
		

		temp_text =  temp_text||'"direccion":'||'"'||user_address_row.street::TEXT
		
		||'no. '||user_address_row.ext::TEXT||', '||user_address_row.colony::TEXT||', '||user_address_row.cp::TEXT||
		', '||(SELECT descripcion from cw.municipalities WHERE id_states = user_address_row.state::INTEGER AND id = user_address_row.municipality::INTEGER)||
		', '||(SELECT descripcion from cw.states WHERE id = user_address_row.state::INTEGER)||
		
		'",';
		
		-- extrae datos del credito
		SELECT * INTO user_credit_request_row FROM cw.user_credit_request WHERE user_id = user_row."id"::uuid AND bank_id = in_id_bank ORDER BY request_date DESC LIMIT 1;

		temp_text = temp_text||'"status_request": '||user_credit_request_row.approved||', "monto": '||user_credit_request_row.linea_aprobada_final::TEXT||', "plazo":'||user_credit_request_row.plazo_final::TEXT||', "tasa":'||user_credit_request_row.tasa_final::TEXT||', "mensualidad": '||user_credit_request_row.mensualidad_final::TEXT||', "producto": "PENSIONADOS"}';
		raise notice 'user_credit_request_row.linea_aprobada_final: %', user_credit_request_row.linea_aprobada_final;

		raise notice 'user_credit_request_row: %', user_credit_request_row;


	ELSIF in_search_mode = 'rfc' THEN

		SELECT * INTO user_row FROM cw.user_personal_data WHERE rfc = in_folio;
		raise notice 'rfc: %', user_row;
		SELECT '{"nombre":"'||user_row.name::TEXT||' '||user_row.name2::TEXT
		||'", "paterno":"'||user_row.last_name::TEXT
		||'","materno":"'||user_row.last_name2::TEXT
		||'","rfc":"'||user_row.rfc::TEXT
		||'","curp":"'||user_row.curp::TEXT
		||'","user_id":"'||user_row.id::TEXT
		||'",'
		INTO temp_text;

		SELECT * INTO user_address_row FROM cw.user_address WHERE id = user_row.id::uuid;

		-- obtiene estado
		

		temp_text =  temp_text||'"direccion":'||'"'||user_address_row.street::TEXT
		
		||'no. '||user_address_row.ext::TEXT||', '||user_address_row.colony::TEXT||', '||user_address_row.cp::TEXT||
		', '||(SELECT descripcion from cw.municipalities WHERE id_states = user_address_row.state::INTEGER AND id = user_address_row.municipality::INTEGER)||
		', '||(SELECT descripcion from cw.states WHERE id = user_address_row.state::INTEGER)||
		
		'",';
		
		SELECT * INTO user_credit_request_row FROM cw.user_credit_request WHERE user_id = user_row."id"::uuid AND bank_id = in_id_bank ORDER BY request_date DESC LIMIT 1;

		temp_text = temp_text||'"status_request": '||user_credit_request_row.approved||', "monto": '||user_credit_request_row.linea_aprobada_final::TEXT||', "plazo":'||user_credit_request_row.plazo_final::TEXT||', "tasa":'||user_credit_request_row.tasa_final::TEXT||', "mensualidad": '||user_credit_request_row.mensualidad_final::TEXT||', "producto": "PENSIONADOS"}';
		raise notice 'user_credit_request_row.linea_aprobada_final: %', user_credit_request_row.linea_aprobada_final;
		raise notice 'user_address_row: %', user_address_row;

	END IF;

	
	SELECT temp_text::json INTO data_user;

END;
$$ LANGUAGE 'plpgsql';

--SELECT cw.get_user_for_formaliza('8e62c052-f181-f0e3-9ddd-273f319c9c12', 'folio', 5);
SELECT cw.get_user_for_formaliza('VEAE940421', 'rfc', 5);
--SELECT cw.get_user_for_formaliza('HERC810615HDFRMR03', 'curp', 7);