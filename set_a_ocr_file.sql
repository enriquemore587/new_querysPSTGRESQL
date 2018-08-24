CREATE
OR REPLACE FUNCTION cw.set_a_ocr_file (
	IN in_ocr_process_id INTEGER,
	IN in_location VARCHAR,
	IN in_success BOOLEAN,
	IN in_user_id VARCHAR,
	OUT status INTEGER,
	OUT ruta VARCHAR
) AS $$
DECLARE var_id INTEGER;
BEGIN

			ruta = 'no rute';		--	SE RETORNA CUANDO LA RESPUESTA FUE INCORRECTA O ES CORRECTA LA RESPUESTA DE OCR POR PRIMERA VEZ
			IF in_success is TRUE THEN	--	RESPUESTA OCR CORRECTA

						IF NOT EXISTS ( SELECT 1 FROM cw.ocr_files AS b WHERE b.ocr_process_id = in_ocr_process_id AND b.success IS TRUE AND b.user_id = in_user_id::uuid ) THEN

										INSERT INTO cw.ocr_files (ocr_process_id, "location", create_at, success, user_id) VALUES (in_ocr_process_id, in_location, now(), in_success, in_user_id::uuid);

						ELSE

										SELECT b.id INTO var_id FROM cw.ocr_files AS b WHERE b.ocr_process_id = in_ocr_process_id AND b.success IS TRUE AND b.user_id = in_user_id::uuid;
										SELECT b."location" INTO ruta FROM cw.ocr_files AS b WHERE b.ocr_process_id = in_ocr_process_id AND b.success IS TRUE AND b.user_id = in_user_id::uuid;

										UPDATE cw.ocr_files SET create_at = now(), "location" = in_location WHERE "id" = var_id;
						END IF;

			ELSE		--	RESPUESTA OCR INCORRECTA

						INSERT INTO cw.ocr_files (ocr_process_id, "location", create_at, success, user_id) VALUES (in_ocr_process_id, in_location, now(), in_success, in_user_id::uuid);

			END IF;

			status = 0;
			--SELECT cw.set_a_ocr_file( 2, 'my ubication', TRUE, '2be57054-1ab1-4aab-a442-665592700037');

END ; 
$$ LANGUAGE 'plpgsql';

SELECT cw.set_a_ocr_file( 2, 'my ubication', TRUE, '2be57054-1ab1-4aab-a442-665592700037');