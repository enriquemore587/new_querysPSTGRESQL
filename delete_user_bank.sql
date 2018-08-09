CREATE
OR REPLACE FUNCTION cw.delete_user_bank (
	IN in_email VARCHAR,
	OUT status VARCHAR
) AS $$
DECLARE v_id VARCHAR;
DECLARE v_bank_id INTEGER;

BEGIN

	SELECT "id" into v_id FROM cw.users WHERE mail = in_email;

	SELECT bank_id INTO v_bank_id FROM cw.users_bank WHERE user_id = v_id::uuid;

	DELETE FROM cw.bank_follow_variables WHERE bank_id = v_bank_id;

	DELETE FROM cw.bank_custom_variables WHERE bank_id = v_bank_id;

	DELETE FROM cw.bank_variables WHERE bank_id = v_bank_id;

	DELETE FROM cw.users_bank WHERE bank_id = v_bank_id AND user_id = v_id::uuid;

	DELETE FROM cw.users WHERE id = v_id::uuid;

	raise notice 'Value1: % value2: %', v_id, v_bank_id;

	status = 'success';
END;
$$ LANGUAGE 'plpgsql';

SELECT cw.delete_user_bank('banco@atreva.mx');


--SELECT cw.delete_a_score_bank(6);