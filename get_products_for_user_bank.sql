CREATE
OR REPLACE FUNCTION cw.get_products_for_user_bank (
IN in_bank_id INTEGER
)
RETURNS TABLE (
id INTEGER,
description VARCHAR
)
AS $$
	BEGIN
			RETURN QUERY
			SELECT pro.ID, pro.description FROM cw.products AS pro WHERE pro.bank_id = in_bank_id;
	END $$ LANGUAGE plpgsql;

SELECT cw.get_products_for_user_bank(5);