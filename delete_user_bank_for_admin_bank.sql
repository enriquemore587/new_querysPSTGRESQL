CREATE
OR REPLACE FUNCTION cw.delete_user_bank_for_admin_bank (
	IN in_user_id VARCHAR,
	OUT status VARCHAR
) AS $$
DECLARE v_id VARCHAR;
DECLARE resp_status INTEGER;
BEGIN

	DELETE FROM cw.user_personal_data WHERE "id" = in_user_id::uuid;

	DELETE FROM cw.users_bank WHERE "user_id" = in_user_id::uuid;

	DELETE FROM cw.users WHERE "id" = in_user_id::uuid;

	status = 'success';
END;
$$ LANGUAGE 'plpgsql';

SELECT cw.delete_user_bank_for_admin_bank('70d78f0b-5ddc-40bf-a36a-2fcd9ae1c659');
