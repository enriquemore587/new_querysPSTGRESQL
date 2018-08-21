CREATE
OR REPLACE FUNCTION cw.up_down_user_bank_for_admin_bank (
	IN in_user_id VARCHAR,
	IN in_up_down BOOLEAN,
	IN in_reason INTEGER,
	IN in_commentary VARCHAR,
	IN in_responsible_user_id VARCHAR,
	OUT status VARCHAR
) AS $$
DECLARE v_id VARCHAR;
DECLARE resp_status INTEGER;
BEGIN

	UPDATE cw.users 
		SET active = in_up_down
	WHERE "id" = in_user_id::uuid;

	INSERT INTO cw.downs ("user_id", reasons_id, commentary, active, date_action, responsible_user_id) VALUES(in_user_id::uuid, in_reason, in_commentary, in_up_down, now(), in_responsible_user_id::uuid);
	status = 'success';
END;
$$ LANGUAGE 'plpgsql';

SELECT cw.up_down_user_bank_for_admin_bank('0ba5d059-9ce6-419b-89e0-b935ba910ba9', TRUE,1,'por puto', '36d575cb-0180-4eab-99bd-dcf26e13d9e0');
