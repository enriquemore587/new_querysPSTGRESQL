CREATE
OR REPLACE FUNCTION cw.up_down_user_bank_for_admin_bank (
	IN in_user_id VARCHAR,
	IN in_up_down BOOLEAN,
	IN in_reason INTEGER,
	IN in_commentary VARCHAR,
	OUT status VARCHAR
) AS $$
DECLARE v_id VARCHAR;
DECLARE resp_status INTEGER;
BEGIN

	UPDATE cw.users 
		SET active = in_up_down
	WHERE "id" = in_user_id::uuid;

	INSERT INTO cw.downs ("id", reasons_id, commentary, active, date_action) VALUES(in_user_id::uuid, in_reason, in_commentary, in_up_down, now());
	status = 'success';
END;
$$ LANGUAGE 'plpgsql';

SELECT cw.up_down_user_bank_for_admin_bank('70d78f0b-5ddc-40bf-a36a-2fcd9ae1c659', TRUE,1,'por puto');
