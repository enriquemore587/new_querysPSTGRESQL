CREATE
OR REPLACE FUNCTION cw.get_histoy_cred_req (IN in_req_id INTEGER) RETURNS TABLE (ID INTEGER, CONTENT TEXT, reason VARCHAR, approved BOOLEAN) AS $$
BEGIN
	--in_req_id es id de banco
	RETURN QUERY SELECT
		h."id" :: INTEGER,
		h."content",
		ucr.reason,
		ucr.approved 
	FROM
		cw.history_credit_request AS h
	INNER JOIN cw.user_credit_request AS ucr ON ucr."id" = h."id"
	WHERE
		ucr.bank_id = in_req_id ;
	END $$ LANGUAGE plpgsql;

SELECT
	cw.get_histoy_cred_req (7);