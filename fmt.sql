CREATE OR REPLACE FUNCTION FMT(n NUMERIC) RETURN VARCHAR
AS BEGIN
	RETURN (
		TRANSLATE (
			REGEXP_REPLACE(
				REGEXP_REPLACE(
					n::VARCHAR,
					'\..*$',
					''
				 ),
				'(\d)(?=(?:[0-9]{3})+\b)',
				'\1,'
			),
			' .#,',
			TO_CHAR(1,'D9G')
		)
	);
END;

CREATE OR REPLACE FUNCTION FMT(n NUMERIC, d INTEGER) RETURN VARCHAR
AS BEGIN
	RETURN (
		TRANSLATE (
			REGEXP_REPLACE(
				REGEXP_REPLACE(
					n::VARCHAR,
					'\..*$',
					''
				),
				'(\d)(?=(?:[0-9]{3})+\b)',
				'\1,'
			) ||
			CASE 
				WHEN d > 0 THEN 
					LTRIM(
						TO_CHAR(
							ABS(
								n-TRUNC(n)
							),
							'9.' || REPEAT('9', d)
						)
					)
				ELSE
					''
			END ,
			' .#,',
			TO_CHAR(1,'D9G')
		)
	);
END;

CREATE OR REPLACE FUNCTION FMT(n NUMERIC, d INTEGER, f VARCHAR) RETURN VARCHAR
AS BEGIN
	RETURN (
		TRANSLATE (
			CASE
				WHEN f IS NULL OR UPPER(f) = 'N' THEN
					REGEXP_REPLACE(
						REGEXP_REPLACE(
							n::VARCHAR,
							'\..*$',
							''
						),
						'(\d)(?=(?:[0-9]{3})+\b)',
						'\1,'
					) ||
					CASE
						WHEN d > 0 THEN
							LTRIM(
								TO_CHAR(
									ABS(
										n-TRUNC(n)
									),
									'9.' || REPEAT('9', d)
								)
							)
						ELSE
							''
					END
				WHEN UPPER(f) = 'P' THEN
					REGEXP_REPLACE(
						REGEXP_REPLACE(
							(100.0 * n)::VARCHAR,
							'\..*$',
							''
						),
						'(\d)(?=(?:[0-9]{3})+\b)',
						'\1,'
					) ||
					CASE
						WHEN d > 0 THEN
							LTRIM(
								TO_CHAR(
									ABS(
										100.0 * n - TRUNC(100.0 * n)
									),
									'9.' || REPEAT('9', d)
								)
							) ||
							'%'
						ELSE
							'%'
					END
				WHEN UPPER(f) = 'T' THEN
					REGEXP_REPLACE(
						REGEXP_REPLACE(
							(1000.0 * n)::VARCHAR,
							'\..*$',
							''
						),
						'(\d)(?=(?:[0-9]{3})+\b)',
						'\1,'
					) ||
					CASE
						WHEN d > 0 THEN
							LTRIM(
								TO_CHAR(
									ABS(
										1000.0 * n - TRUNC(1000.0 * n)
									),
									'9.' || REPEAT('9', d)
								)
							) ||
							'‰'
						ELSE
							'‰'
					END
				ELSE
					'Invalid format'
			END ,
			' .#,',
			TO_CHAR(1,'D9G')
		)
	);
END;
