CREATE OR REPLACE FUNCTION cw.get_profiles_for_admin_bank ()
RETURNS TABLE (
id INTEGER,
description VARCHAR
)
AS $$
	BEGIN
			RETURN QUERY
				SELECT po.id::INTEGER, po.description from cw.profiles AS po WHERE po.type = 4 and po.id != 7;
	END $$ LANGUAGE plpgsql;

SELECT cw.get_profiles_for_admin_bank();