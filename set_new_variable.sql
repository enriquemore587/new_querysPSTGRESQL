CREATE
OR REPLACE FUNCTION cw.set_new_variable (
	IN in_variable_name VARCHAR,
	IN in_category_variable INTEGER,
	IN in_calc_show BOOLEAN,
--	IN in_range VARCHAR,
--	IN in_is_ok BOOLEAN,
--	IN in_var_array VARCHAR,
--	IN in_product_id INTEGER,
--	IN in_active BOOLEAN,
	--IN in_bank_id INTEGER,
	OUT status VARCHAR
) AS $$
DECLARE v_fix_id INTEGER;
--DECLARE v_var_id_banks_variable INTEGER;
DECLARE v_sort INTEGER;
--DECLARE v_next_sort_follow INTEGER;
--DECLARE c CURSOR FOR SELECT DISTINCT bank_id INTO banks_id FROM cw.bank_variables ORDER BY bank_id ASC;
BEGIN
	
	-- CREACIÓN DE LA VARIABLE (SE NECESITA EL NÚMERO DE ORDEN EN LA TABLA VARRIABLES_FIX)
	SELECT MAX(sort) INTO v_sort FROM cw.variables_fix;
	v_sort = v_sort + 1;

	SELECT MAX("id") INTO v_fix_id FROM cw.variables_fix;
	v_fix_id = v_fix_id + 1;

	INSERT INTO cw.variables_fix (id, "name" ,category_id, calc_show, sort)
	VALUES (v_fix_id, in_variable_name, in_category_variable, in_calc_show, v_sort);


	--	INSERT VARIABLE A TODOS LOS BANCOS REGISTRADOS
	--INSERT INTO cw.bank_variables ( bank_id, var_fix_id, "range", is_ok, var_array, product_id, active ) 
	--VALUES (in_bank_id, v_fix_id, in_range, in_is_ok, in_var_array, in_product_id, in_active) RETURNING id INTO v_var_id_banks_variable;

	--	OBTIENE EL EL SORT PARA VARIABLE DE TIPO FIX
--	SELECT MAX(short) INTO v_next_sort_follow FROM "cw"."bank_follow_variables"
--	WHERE bank_id = in_bank_id AND variable_id IS NOT NULL;

	--v_next_sort_follow = v_next_sort_follow + 1;

--	INSERT INTO cw.bank_follow_variables (bank_id, variable_id, short)
--	VALUES (in_bank_id, v_var_id_banks_variable, v_next_sort_follow);

--	UPDATE cw.bank_follow_variables
--		SET short = short + 1 WHERE bank_id = in_bank_id AND personal_variable_id IS NOT NULL;
		
	status = 'successful';
	
--raise notice 'Value: %', deletedContactId;


END ; 
$$ LANGUAGE 'plpgsql';


SELECT cw.set_new_variable(
	'Ingreso BRUTO',		--in_variable_name
	2,										--in_category_variable 2 = perfil, 1 = buro
	TRUE									--in_calc_show
--	'0-100',							--in_range
--	TRUE,									--in_is_ok
--	'', 									--in_var_array
--	1,										--in_product_id <=> IMSS => 1
--	FALSE,									--in_active
	--7											--in_bank_id
);