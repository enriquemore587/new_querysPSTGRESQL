CREATE OR REPLACE FUNCTION "cw"."set_a_check"
(
	IN "in_id_var_fix" int4, 
	IN "in_id_bank" int4, 
	IN "in_active" bool, 
	OUT "status" int4
)
  RETURNS "pg_catalog"."int4" AS $BODY$
DECLARE v_next_sort_follow INTEGER;
DECLARE v_var_id_banks_variable INTEGER;
BEGIN
	--	SE COMPRUEBA QUE EL BANCO EXISTA
IF NOT EXISTS ( SELECT 1 FROM cw.banks AS b WHERE b. ID = in_id_bank ) THEN
	status = 1100 ;
ELSE
/*	
		IF in_active = FALSE THEN
			SELECT INTO status cw.delete_a_bank_follow_variable(in_id_bank, in_id_var_fix);
		END IF;
*/
-----
				IF NOT EXISTS (SELECT 1 from cw.icc_bank WHERE bank_id = in_id_bank) THEN
					select * INTO status from cw.new_icc_for_bank(in_id_bank::INTEGER);
				END IF;
				IF NOT EXISTS (SELECT 1 from cw.score_bank WHERE bank_id = in_id_bank) THEN
					select * INTO status from cw.new_score_for_bank(in_id_bank::INTEGER);
				END IF;
-----
	IF EXISTS ( SELECT 1 FROM cw.bank_variables AS bv WHERE bv.bank_id = in_id_bank AND bv.var_fix_id = in_id_var_fix ) THEN
			
	UPDATE cw.bank_variables SET active = in_active
	WHERE bank_id = in_id_bank AND var_fix_id = in_id_var_fix;

	--	NO EXISTE REGISTRO EN LA TABLA => SE INSERTA UN NUEVO REGISTRO
	ELSIF NOT EXISTS ( SELECT 1 FROM cw.bank_variables AS bv WHERE bv.bank_id = in_id_bank AND bv.var_fix_id = in_id_var_fix ) THEN

		INSERT INTO cw.bank_variables ( bank_id, var_fix_id, active )
		VALUES ( in_id_bank, in_id_var_fix, in_active ) RETURNING id INTO v_var_id_banks_variable;

		--	OBTIENE EL EL SORT PARA VARIABLE DE TIPO FIX
		SELECT MAX(short) INTO v_next_sort_follow FROM "cw"."bank_follow_variables"
		WHERE bank_id = in_id_bank AND variable_id IS NOT NULL;

		v_next_sort_follow = v_next_sort_follow + 1;

		INSERT INTO cw.bank_follow_variables (bank_id, variable_id, short)
		VALUES (in_id_bank, v_var_id_banks_variable, v_next_sort_follow);

		UPDATE cw.bank_follow_variables
			SET short = short + 1 WHERE bank_id = in_id_bank AND personal_variable_id IS NOT NULL;

	END IF ;

	status = 0;
END IF ; 

--EXCEPTION WHEN OTHERS THEN
--status = 1200;
END ; 
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;

