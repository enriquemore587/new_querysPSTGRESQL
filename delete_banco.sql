CREATE
OR REPLACE FUNCTION cw.delete_banco (
	IN in_bank_id INTEGER,
	OUT status VARCHAR
) AS $$
DECLARE item_id uuid[];
DECLARE
    lista  uuid[] := ARRAY( SELECT user_id FROM cw.users_bank WHERE bank_id = in_bank_id);

BEGIN
	-- ELIMINO DE BANCK_FOLLOW_VARIABLES

	DELETE FROM cw.bank_follow_variables WHERE bank_id = in_bank_id;

	DELETE FROM cw.bank_custom_variables WHERE bank_id = in_bank_id;

	DELETE FROM cw.bank_variables WHERE bank_id = in_bank_id;

	DELETE FROM cw.score_bank WHERE bank_id = in_bank_id;

	DELETE FROM cw.icc_bank WHERE bank_id = in_bank_id;

	DELETE FROM cw.users WHERE "id" IN (SELECT user_id FROM cw.users_bank WHERE bank_id = in_bank_id);
/*
	DELETE FROM cw.user_personal_data WHERE "id" IN (SELECT user_id FROM cw.users_bank WHERE bank_id = in_bank_id);

	DELETE FROM cw.downs WHERE user_id IN (SELECT user_id FROM cw.users_bank WHERE bank_id = in_bank_id)
															OR responsible_user_id IN (SELECT user_id FROM cw.users_bank WHERE bank_id = in_bank_id);

	DELETE FROM cw.users WHERE "id" IN (SELECT user_id FROM cw.users_bank WHERE bank_id = in_bank_id);

	FOREACH item_id SLICE 1 IN ARRAY lista
   LOOP
			DELETE FROM cw.users_bank WHERE user_id = item_id[1];

			DELETE FROM cw.user_personal_data WHERE "id" = item_id[1];

			DELETE FROM cw.downs WHERE user_id = item_id[1] OR responsible_user_id = item_id[1];

			DELETE FROM cw.users WHERE "id" = item_id[1];
   END LOOP;
*/
	status = 'success';

END;
$$ LANGUAGE 'plpgsql';

SELECT cw.delete_banco(5);