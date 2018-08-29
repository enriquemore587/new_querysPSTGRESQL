-- borra la variable a todos los bancos
CREATE
OR REPLACE FUNCTION "cw"."delete_variable" (
	IN in_id_var_fix INTEGER,
	OUT status INTEGER
) RETURNS "pg_catalog"."int4" AS $BODY$
BEGIN
	UPDATE cw.bank_follow_variables
			SET short = short - 1 
	WHERE bank_id in ( SELECT bank_id FROM cw.bank_variables WHERE var_fix_id =  in_id_var_fix )
	AND personal_variable_id IS NOT NULL;

	DELETE FROM
	cw.bank_follow_variables WHERE variable_id IN 
		( SELECT ID FROM cw.bank_variables WHERE var_fix_id = in_id_var_fix );
	DELETE FROM cw.bank_variables WHERE var_fix_id = in_id_var_fix;
	DELETE FROM cw.variables_fix WHERE ID = in_id_var_fix ;
	
	status = 0;
END;
$BODY$ LANGUAGE 'plpgsql' VOLATILE COST 100;

SELECT
	cw.delete_variable (18);

