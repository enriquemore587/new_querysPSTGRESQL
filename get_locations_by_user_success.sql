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

SELECT cw.get_locations_by_user_success('4b49902f-9433-440a-a042-246b36230221', TRUE);
