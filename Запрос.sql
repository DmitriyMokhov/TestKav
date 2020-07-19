--На какой улице больше всего объектов фотоателье и фотоуслуг
WITH 
CTE0 AS (
SELECT [Address] = REPLACE([Address],'город Зеленоград,','')
FROM [dbo].[org]
WHERE [Name] IN ('фотоателье','Фотоуслуги')
),
CTE1 AS (
SELECT street = TRIM(SUBSTRING([Address]
	,CHARINDEX(',',[Address])+1
	,IIF(CHARINDEX(',',[Address],CHARINDEX(',',[Address])+1) - CHARINDEX(',',[Address])>0
		,CHARINDEX(',',[Address],CHARINDEX(',',[Address])+1) - CHARINDEX(',',[Address])
		,LEN([Address])))
)
FROM CTE0
)
SELECT TOP (1) WITH TIES street, COUNT(street) CNT
FROM CTE1
GROUP BY street
ORDER BY CNT DESC

--В каких 5 районах Москвы наибольшее и наименьшее количество объектов в категории парикмахерские и косметические услуги
SELECT District, CNT
FROM 
	(SELECT TOP (5) WITH TIES District
		 ,COUNT(District) CNT
	FROM [dbo].[org]
	WHERE [Name] like '%косметич%' OR [Name] like '%парикмахер%'
	AND [District] NOT LIKE '%поселение%'
	GROUP BY District
	ORDER BY CNT DESC) T1
UNION ALL
SELECT District, CNT
FROM 
	(SELECT TOP (5) WITH TIES District
		 ,COUNT(District) CNT
	FROM [dbo].[org]
	WHERE [Name] like '%косметич%' OR [Name] like '%парикмахер%'
	AND [District] NOT LIKE '%поселение%'
	GROUP BY District
	ORDER BY CNT) T1
ORDER BY CNT DESC, DISTRICT

--В скольких районах Москвы отсутствуют объекты ремонта часов
SELECT COUNT(DISTINCT [District]) CNT FROM [dbo].[org] 
WHERE [District] NOT LIKE '%поселение%'
AND [District] NOT IN (
	SELECT DISTINCT [District]
	FROM [dbo].[org]
	WHERE [Name] LIKE '%Ремонт%часов%'
)
