CREATE
OR REPLACE FUNCTION cw.create_registry_login (
	IN in_user_id VARCHAR,
	OUT status VARCHAR
) AS $$
DECLARE v_id VARCHAR;
BEGIN
	-- FUNCIÓN PARA REGISTRAR INICIOS DE SESION
		INSERT INTO cw.sessions (user_id, date_session) VALUES (in_user_id::uuid, now());
	status = 'success';
END;
$$ LANGUAGE 'plpgsql';

SELECT cw.create_registry_login('d5abd3b1-05e4-4c6f-ad7f-7c6d3c378706');