CREATE OR REPLACE FUNCTION cw.get_locations_by_user_success (IN in_user_id VARCHAR, IN in_success BOOLEAN)
RETURNS TABLE (
location VARCHAR,
ocr_process_id INTEGER,
description VARCHAR
)
AS $$
	BEGIN
			RETURN QUERY
				SELECT o."location", o.ocr_process_id, op.description
				FROM cw.ocr_files AS o
				INNER JOIN cw.ocr_process AS op ON op.id = o.ocr_process_id
				WHERE o.user_id = in_user_id::uuid AND o.success = in_success;
	END $$ LANGUAGE plpgsql;

SELECT cw.get_locations_by_user_success('c962bcad-5314-40ce-8a4a-d2b8cd1b4d87', TRUE);
