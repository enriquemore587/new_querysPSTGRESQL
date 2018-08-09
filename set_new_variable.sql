CREATE
OR REPLACE FUNCTION cw.set_new_variable (
	IN in_variable_name VARCHAR,
	IN in_category_variable INTEGER,
	IN in_calc_show BOOLEAN,
	OUT status VARCHAR
) AS $$
DECLARE v_fix_id INTEGER;

DECLARE v_sort INTEGER;

BEGIN
	
	-- CREACIÓN DE LA VARIABLE (SE NECESITA EL NÚMERO DE ORDEN EN LA TABLA VARRIABLES_FIX)
	SELECT MAX(sort) INTO v_sort FROM cw.variables_fix;
	v_sort = v_sort + 1;

	SELECT MAX("id") INTO v_fix_id FROM cw.variables_fix;
	v_fix_id = v_fix_id + 1;

	INSERT INTO cw.variables_fix (id, "name" ,category_id, calc_show, sort)
	VALUES (v_fix_id, in_variable_name, in_category_variable, in_calc_show, v_sort);

	status = 'successful';
	
--raise notice 'Value: %', deletedContactId;


END ; 
$$ LANGUAGE 'plpgsql';


SELECT cw.set_new_variable(
	'Ingreso BRUTO',		--in_variable_name
	2,									--in_category_variable 2 = perfil, 1 = buro
	TRUE
);