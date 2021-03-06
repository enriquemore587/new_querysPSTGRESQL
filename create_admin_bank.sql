CREATE
OR REPLACE FUNCTION cw.create_admin_bank (
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
	-- FUNCIÓN PARA LA CREACIÓN DE ADMINISTRADORES DE USUARIOS PARA LOS BANCOS.

	-- se crea un nuevo usuario en la BD
	INSERT INTO cw.users (mail, pwd, id_profile, registration) VALUES (in_email, in_pwd, 7, now()) RETURNING "id" INTO v_id;

	-- SE CREA RELACION DEL USUARIO A UN BANCO
	INSERT INTO cw.users_bank (bank_id, user_id) VALUES(in_bank_id, v_id::uuid);

	-- INSERTO NOMBRE DEL USUARIO DEL BANCO
	INSERT INTO cw.user_personal_data ("id", "name", "name2", "last_name", "last_name2") 
				VALUES(v_id::uuid, UPPER(in_user_name), UPPER(in_user_name2), UPPER(in_user_last_name), UPPER(in_user_last_name2));


	--raise notice 'Value: %', v_id;
	status = 'success';
END;
$$ LANGUAGE 'plpgsql';

SELECT cw.create_admin_bank('hsbcAdmin@atreva.mx', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 7, 'Jose', 'Enrique', 'Bautista', 'Garcia');