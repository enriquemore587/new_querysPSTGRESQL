CREATE
OR REPLACE FUNCTION cw.set_credit_request_result (
	IN in_request_id INTEGER,
	IN in_approved BOOLEAN,
	IN in_reason VARCHAR,
	IN in_data VARCHAR,
	OUT status VARCHAR
) AS $$
DECLARE v_code VARCHAR;
BEGIN
	status = '0';
	SELECT uuid_in(md5(random()::text || now()::text)::cstring) INTO v_code;
	UPDATE cw.user_credit_request SET approved = in_approved, reason = in_reason, folio = v_code WHERE "id" = in_request_id;
	INSERT INTO cw.history_credit_request VALUES (in_request_id,in_data);
	status = v_code;
END;
$$ LANGUAGE 'plpgsql';


--SELECT cw.set_credit_request_result(6);