-- SERVICIO PARA EL FLUJO DE IMSS DONDE REGISTRA DATOS DE SUS PAGOS, GENERO Y ESTADO CIVIL
CREATE OR REPLACE FUNCTION cw.set_imss_deposit (
IN in_user_id VARCHAR,
IN in_nss_number VARCHAR,
IN in_bruto FLOAT,
IN in_last_deposit FLOAT,
IN in_civil_status INTEGER,
IN in_gender VARCHAR,
OUT status VARCHAR
) AS $$
BEGIN
		IF NOT EXISTS (SELECT 1 from cw.user_personal_data as u WHERE u.id = in_user_id::uuid) THEN
				-- insert data of payments of pension
				INSERT INTO cw.imss_products
					( user_id, nss, ingreso_bruto, last_deposit )
				VALUES 
					( in_user_id::uuid, in_nss_number, in_bruto, in_last_deposit );
				status = 'SAVED';
		ELSE
			UPDATE cw.imss_products SET 
						user_id = in_user_id::uuid, 
						nss = in_nss_number, 
						ingreso_bruto = in_bruto, 
						last_deposit = in_last_deposit
			WHERE user_id = in_user_id::uuid;
			status = 'UPDATE';
		END IF;
	
		UPDATE cw.user_personal_data SET civil_status = in_civil_status , gender = in_gender WHERE id = in_user_id::uuid;

		
	

END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM cw.set_imss_deposit ('41343e72-a624-4850-aed1-515395f12cec', '12345678963', 150.50, 550.55, 1, 'H');