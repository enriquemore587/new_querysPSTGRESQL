CREATE
OR REPLACE FUNCTION cw.get_general_information_user (
	IN in_user_id VARCHAR,
	OUT response json
) AS $$
DECLARE var_first_part TEXT ;
DECLARE var_second_part TEXT ;
BEGIN
	SELECT	'{"nombreCompleto": "' || upd.last_name || ' ' || upd.last_name2 || ' ' || upd."name" ||
					'", "nationality": ' || upd.nationality :: TEXT || ', "birthdate" : "' || upd.birthdate :: TEXT || '"' INTO var_first_part
	FROM cw.user_personal_data AS upd
	WHERE upd. ID = in_user_id :: uuid;

	raise notice '1.- Value1: %', var_first_part;
	IF var_first_part IS NOT NULL THEN
		SELECT
			var_first_part||', '||'"direccion": "' || u.street || ' #' || u.ext || ' Inte. ' || u."int" || ' ' || u.colony || ' C.P.' || u.cp || '"}' INTO var_second_part
		FROM
			cw.user_address AS u
		WHERE
			u. ID = in_user_id :: uuid ;
		
		IF var_second_part IS NULL THEN
			SELECT var_first_part||', "direccion": "SIN INFORMACIÓN"'||'}' INTO var_second_part;
		END IF;
		raise notice '1.1- Value2: %', var_second_part;
	ELSE
		SELECT
			'{"nombreCompleto": "SIN INFORMACIÓN", "nationality": 223, "birthdate" : "1981-06-15", "direccion": "' 
			|| u.street || ' #' || u.ext || ' Inte. ' || u."int" || ' ' || u.colony || ' C.P.' || u.cp || '"}' INTO var_second_part
		FROM cw.user_address AS u
		WHERE u. ID = in_user_id :: uuid ; 

		raise notice '2.1- Value2: %', var_second_part;

		IF var_second_part IS NULL THEN
			SELECT '{"nombreCompleto": "SIN INFORMACIÓN", "nationality": 223, "birthdate" : "1981-06-15", "direccion": "SIN INFORMACIÓN"}' INTO var_second_part;
		END IF;

		raise notice '2.2- Value2: %', var_second_part;

	END IF;
	
	SELECT var_second_part::json into response;

			
END ; $$ LANGUAGE 'plpgsql';

SELECT
	cw.get_general_information_user (
		'668b9bdd-624a-4ace-ac48-e20539def4d9'
	);

