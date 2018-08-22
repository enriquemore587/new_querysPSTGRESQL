CREATE
OR REPLACE FUNCTION cw.create_user_bank (
	IN in_email VARCHAR,
	IN in_pwd VARCHAR,
	IN in_bank_id INTEGER,
	IN in_user_name VARCHAR,
	IN in_user_name2 VARCHAR,
	IN in_user_last_name VARCHAR,
	IN in_user_last_name2 VARCHAR,
	IN in_rfc VARCHAR,
	OUT status VARCHAR
) AS $$
DECLARE v_id VARCHAR;
DECLARE resp_status INTEGER;
BEGIN

	-- se crea un nuevo usuario en la BD
	INSERT INTO cw.users (mail, pwd, id_profile, registration) VALUES (in_email, in_pwd, 7, now()) RETURNING "id" INTO v_id;

	-- SE CREA RELACION DEL USUARIO A UN BANCO
	INSERT INTO cw.users_bank (bank_id, user_id) VALUES(in_bank_id, v_id::uuid);

	-- INSERTO NOMBRE DEL USUARIO DEL BANCO
	INSERT INTO cw.user_personal_data ("id", "name", "name2", "last_name", "last_name2", rfc) 
				VALUES(v_id::uuid, UPPER(in_user_name), UPPER(in_user_name2), UPPER(in_user_last_name), UPPER(in_user_last_name2), UPPER(in_rfc));

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

	-- SE ESTABLECEN LOS PARAMETROS PARA ICC
	UPDATE cw.bank_variables SET "range" = '4-9'  WHERE var_fix_id = 3 AND bank_id = in_bank_id;

	--	SE ESTABLECEN LAS VARIABLES PARA EL ÁRBOL
	INSERT INTO cw.bank_follow_variables  (bank_id, variable_id, short) SELECT
		in_bank_id,
		bv. ID,
		vf.sort
	FROM
		cw.bank_variables AS bv
	INNER JOIN cw.variables_fix AS vf ON bv.var_fix_id = vf. ID
	WHERE
		bv.bank_id = in_bank_id
	ORDER BY
		vf.sort ;

	SELECT cw.new_icc_for_bank(in_bank_id) INTO resp_status;
	raise notice 'CREACCIÓN ICC: %', resp_status;

	SELECT cw.new_score_for_bank(in_bank_id) INTO resp_status;
	raise notice 'CREACCIÓN score: %', resp_status;

	status = 'success';
END;
$$ LANGUAGE 'plpgsql';

SELECT cw.create_user_bank('admin@atreva.mx', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 5, 'Ronaldo', '', 'de Assis', 'Moreira', 'MYRFC');
