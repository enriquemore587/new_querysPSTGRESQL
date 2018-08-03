CREATE
OR REPLACE FUNCTION cw.get_users_list ()
RETURNS TABLE (
id VARCHAR,
mail VARCHAR,
registration TIMESTAMP
)
AS $$
	BEGIN
			RETURN QUERY
			SELECT u."id"::VARCHAR , u.mail, u.registration::TIMESTAMP
			FROM cw.users AS u 
			WHERE u.id_profile = 3
			AND
			u."id" in (SELECT ocrF.user_id::uuid FROM  cw.ocr_files AS ocrF)
			ORDER BY u.mail LIMIT 50;
	END $$ LANGUAGE plpgsql;

SELECT cw.get_users_list();
