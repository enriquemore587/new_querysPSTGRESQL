CREATE
OR REPLACE FUNCTION cw.update_user_data_from_admin (
	IN in_user_id VARCHAR,
	IN in_rfc VARCHAR,
	IN in_num_client VARCHAR,
	IN in_email VARCHAR,
	IN in_name VARCHAR,
	IN in_name2 VARCHAR,
	IN in_last_name VARCHAR,
	IN in_last_name2 VARCHAR,
	IN in_profile VARCHAR,
	OUT status VARCHAR
) AS $$
DECLARE v_id VARCHAR;
BEGIN
	-- se utiliza para admin de banco en admin-panel/edit-user
	UPDATE cw.user_personal_data SET
	rfc = in_rfc,
	name = in_name,
	name2 = in_name2,
	last_name = in_last_name,
	last_name2 = in_last_name2
	WHERE "id" = in_user_id::uuid;

	UPDATE cw.users SET
	id_profile = (SELECT "id" FROM cw.profiles WHERE description = in_profile)::INTEGER,
	mail = in_email,
	num_client = in_num_client
	WHERE "id" = in_user_id::uuid;
	status:= 'success';
	--raise notice 'Value: %', v_id;
	status = 'success';
END;
$$ LANGUAGE 'plpgsql';

SELECT cw.update_user_data_from_admin(
	'41343e72-a624-4850-aed1-515395f12cec',							--in_user_id VARCHAR,
	'VEAE940421',																				--in_rfc VARCHAR,
	'420041700100235',																	--in_num_client INTEGER,
	'enrique.vergara@atreva.mx',												--in_email VARCHAR,
	'JOSE',																							--in_name VARCHAR,
	'ENRIQUE',																					--in_name2 VARCHAR,
	'VERGARA',																					--in_last_name VARCHAR,
	'MORALES',																					--in_last_name2 VARCHAR,
	'USUARIO'																						--in_profile VARCHAR,
);