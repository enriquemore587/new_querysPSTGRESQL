CREATE
OR REPLACE FUNCTION cw.set_a_uuid_files_user(
	IN in_user_id_new VARCHAR,
	IN in_user_id_old VARCHAR,
	OUT status INTEGER
) AS $$
DECLARE var_id INTEGER;
BEGIN

			UPDATE cw.ocr_files SET user_id = in_user_id_new::uuid WHERE user_id = in_user_id_old::uuid;

status = 0;

END ; 
$$ LANGUAGE 'plpgsql';

SELECT cw.set_a_uuid_files_user('2be57054-1ab1-4aab-a442-665592700037', '2be57054-1ab1-4aab-a442-665592700038');