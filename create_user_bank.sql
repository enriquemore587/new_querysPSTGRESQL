CREATE
OR REPLACE FUNCTION cw.create_user_bank (
	IN in_email VARCHAR,
	IN in_pwd VARCHAR,
	IN in_bank_id INTEGER,
	IN in_user_name VARCHAR,
	IN in_user_name2 VARCHAR,
	IN in_user_last_name VARCHAR,
	IN in_user_last_name2 VARCHAR,
	OUT status VARCHAR
) AS $$
DECLARE v_id VARCHAR;
BEGIN

	-- se crea un nuevo usuario en la BD
	INSERT INTO cw.users (mail, pwd, id_profile, registration) VALUES (in_email, in_pwd, 4, now()) RETURNING "id" INTO v_id;

	-- SE CREA RELACION DEL USUARIO A UN BANCO
	INSERT INTO cw.users_bank (bank_id, user_id) VALUES(in_bank_id, v_id::uuid);

	-- INSERTO NOMBRE DEL USUARIO DEL BANCO
	INSERT INTO cw.user_personal_data ("id", "name", "name2", "last_name", "last_name2") 
				VALUES(v_id::uuid, UPPER(in_user_name), UPPER(in_user_name2), UPPER(in_user_last_name), UPPER(in_user_last_name2));

	--SE INSERTAN LAS VARIABLES POR DEFAULT DEL BANCO
	INSERT INTO cw.bank_variables (bank_id, var_fix_id) SELECT
		in_bank_id,
		ID
	FROM
		cw.variables_fix
	ORDER BY
		sort ASC ; 

	-- SE ESTABLECEN LOS PARAMETROS POR DEFAULT
	UPDATE cw.bank_variables SET "range" = '1-99'  WHERE var_fix_id = 7 AND bank_id = in_bank_id;

	--	SE ESTABLECEN LAS VARIABLES PARA EL ÁRBOL
	INSERT INTO cw.bank_follow_variables (bank_id, variable_id) SELECT
		in_bank_id,
		bv. ID
	FROM
		cw.bank_variables AS bv
	INNER JOIN cw.variables_fix AS vf ON bv.var_fix_id = vf. ID
	WHERE
		bv.bank_id = in_bank_id
	ORDER BY
		vf.sort ;
	--raise notice 'Value: %', v_id;
	status = 'success';
END;
$$ LANGUAGE 'plpgsql';

SELECT cw.create_user_bank('enrique2@enrique.com', '123', 12, 'Ronaldo', '', 'de Assis', 'Moreira');


--SELECT cw.delete_a_score_bank(6);