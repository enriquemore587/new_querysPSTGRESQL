CREATE OR REPLACE FUNCTION "cw"."set_credit_request_approved"
(
		IN "in_request_id" INTEGER,
		IN "in_mensualidad" FLOAT,
		IN "in_plazo" INTEGER,
		IN "in_linea_aprobada" FLOAT,
		IN "in_tasa" FLOAT, 
		OUT "status" VARCHAR
)
  RETURNS "pg_catalog"."varchar" AS $BODY$ 
DECLARE v_code VARCHAR;
BEGIN
	status = '0';
	UPDATE cw.user_credit_request 
	SET mensualidad_final = in_mensualidad, plazo_final = in_plazo, linea_aprobada_final = in_linea_aprobada, tasa_final = in_tasa
	WHERE "id" = in_request_id;
	status = 'success';
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;