CREATE
OR REPLACE FUNCTION cw.delete_a_score_bank (
	IN in_id_score INTEGER,
	OUT status INTEGER
) AS $$
BEGIN
	DELETE FROM cw.score_bank WHERE "id" = in_id_score;
	status = 0;
END;
$$ LANGUAGE 'plpgsql';


--SELECT cw.delete_a_score_bank(6);