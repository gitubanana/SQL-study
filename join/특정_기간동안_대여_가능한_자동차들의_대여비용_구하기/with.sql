WITH WANTED (CAR_ID, CAR_TYPE, DAILY_FEE) AS
(
    SELECT DISTINCT WANTED_CARS.CAR_ID, WANTED_CARS.CAR_TYPE, WANTED_CARS.DAILY_FEE
        FROM (
            SELECT CAR_ID, CAR_TYPE, DAILY_FEE
                FROM CAR_RENTAL_COMPANY_CAR
                WHERE CAR_TYPE IN ('세단', 'SUV')
        ) AS WANTED_CARS
        WHERE CAR_ID NOT IN (
            SELECT DISTINCT CAR_ID
                FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
                WHERE START_DATE <= '2022-11-01'
                    AND END_DATE >= '2022-11-01'
        )
)

SELECT WANTED.CAR_ID, WANTED.CAR_TYPE,
        ROUND(WANTED.DAILY_FEE * (1 - (PLAN.DISCOUNT_RATE / 100)) * 30) AS FEE
    FROM WANTED
    INNER JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN AS PLAN
        ON WANTED.CAR_TYPE = PLAN.CAR_TYPE
            AND PLAN.DURATION_TYPE = '30일 이상'
    HAVING FEE BETWEEN 500000 AND 2000000
    ORDER BY FEE DESC, CAR_TYPE ASC, CAR_ID DESC;