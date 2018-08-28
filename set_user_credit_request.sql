CREATE OR REPLACE FUNCTION "cw"."set_user_credit_request"(
		IN "in_user_id" varchar, 
		IN "in_bank_id" int4, 
		IN "in_requested_amount" float8, 
		IN "in_monthly_payment" float8, 
		IN "in_ingreso_declarado" float8, 
		IN "in_plazo_solicitado" float8, 
		IN "in_test" bool, 
		OUT "status" int4, 
		OUT "data_user" json
)
  RETURNS "pg_catalog"."record" AS $BODY$
DECLARE
    user_row cw.user_personal_data%ROWTYPE;

DECLARE
    imss_row cw.imss_products%ROWTYPE;

DECLARE temp_text TEXT;
DECLARE request_id INTEGER;
BEGIN
	IF in_test is NOT TRUE 
	THEN
		INSERT INTO cw.user_credit_request (
		user_id,
		bank_id,
		requested_amount,
		monthly_payment,
		request_date,
		ingreso_declarado,
		plazo_solicitado
		)
		VALUES
		(
		in_user_id::uuid,
		in_bank_id,
		in_requested_amount,
		in_monthly_payment,
		now(),
		in_ingreso_declarado,
		in_plazo_solicitado
		) RETURNING id INTO status;
	END IF;
	--status := 0;
	
	SELECT * INTO user_row FROM cw.user_personal_data AS upd WHERE upd."id" = in_user_id::uuid;
	
	SELECT * INTO imss_row FROM cw.imss_products AS imss WHERE imss.user_id = in_user_id::uuid;

	IF user_row IS NULL  THEN
		SELECT '{"status": "user_personal_data"}'::json into data_user;
	ELSEIF imss_row IS NULL THEN
		SELECT '{"status": "no imss_products"}'::json into data_user;
	ELSE
		--SELECT '{"status": "OK information"}'::json into data_user;

		
		raise notice 'imss_row: %', imss_row;
		raise notice 'user_row: %', user_row;
			
		SELECT '{"gender": "'||user_row.gender::TEXT||
		'", "nationality": "'||user_row.nationality::TEXT||
		'", "birthdate": "'||user_row.birthdate::TEXT||
		'", "civil_status" : "'||user_row.civil_status::TEXT||
		'", "ocupation_id":'||user_row.ocupations_id ||
		', "ingreso_bruto":'||imss_row.ingreso_bruto ||
		', "last_deposit":'||imss_row.last_deposit ||
		', "nss": "'||imss_row.nss
		||'"}' into temp_text;
		SELECT temp_text::json INTO data_user;
		status = 0;
	END IF;
	

END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

SELECT cw.set_user_credit_request('41343e72-a624-4850-aed1-515395f12cec',5,10000,2600,50000,24,TRUE);