CREATE OR REPLACE FUNCTION cw.get_bitacora_usuarios_for_admin_bank (IN in_bank_id INTEGER)
RETURNS TABLE (
id INTEGER,
nombre TEXT,
date_movement TIMESTAMP,
tipo_movimiento VARCHAR,
responsable TEXT
)
AS $$
	BEGIN
			RETURN QUERY

			(
			SELECT 	s."id"::INTEGER,
							(SELECT apd.name||' '||apd.last_name||' '||apd.last_name2::VARCHAR AS nombre
								FROM cw.user_personal_data AS apd
								WHERE apd."id" = s.user_id) AS nombre,
							--s.user_id::VARCHAR,
							s.date_session AS date_movement,
							'ACCESO' AS tipo_movimiento,
							(SELECT apd.name||' '||apd.last_name||' '||apd.last_name2::VARCHAR AS responsable
								FROM cw.user_personal_data AS apd
								WHERE apd."id" = s.user_id) AS responsable
			FROM cw.sessions as s
			WHERE s.user_id IN (SELECT ub.user_id FROM cw.users_bank AS ub WHERE ub.bank_id = in_bank_id)
			)
			UNION ALL
			(
			SELECT 	d."id"::INTEGER,
							(SELECT apd.name||' '||apd.last_name||' '||apd.last_name2::VARCHAR AS nombre
								FROM cw.user_personal_data AS apd
								WHERE apd."id" = d.user_id) AS nombre,
							--d.user_id::TEXT AS nombre,
							d.date_action AS date_movement,
						--(SELECT dr.description FROM cw.down_reasons AS dr WHERE dr.id = d.reasons_id) AS tipo_movimiento,
							CASE WHEN d.active IS TRUE THEN 'ALTA'::TEXT WHEN d.active IS FALSE THEN 'BAJA'::TEXT END::VARCHAR AS tipo_movimiento,
							(SELECT apd.name||' '||apd.last_name||' '||apd.last_name2::VARCHAR AS responsable
								FROM cw.user_personal_data AS apd
								WHERE apd."id" = d.responsible_user_id) AS responsable
			FROM cw.downs AS d
			WHERE d.user_id IN (SELECT ub.user_id FROM cw.users_bank AS ub WHERE ub.bank_id = in_bank_id)
			)
			ORDER BY date_movement DESC;

	END $$ LANGUAGE plpgsql;

SELECT cw.get_bitacora_usuarios_for_admin_bank(5);