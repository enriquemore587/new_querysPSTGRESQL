CREATE OR REPLACE FUNCTION cw.get_down_reasons_for_admin_bank ()
RETURNS TABLE (
id INTEGER,
description VARCHAR
)
AS $$
	BEGIN
			RETURN QUERY
				SELECT dr.id::INTEGER, dr.description FROM cw.down_reasons AS dr;
	END $$ LANGUAGE plpgsql;

SELECT cw.get_down_reasons_for_admin_bank();