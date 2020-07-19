CREATE PROCEDURE [dbo].[orgUpsert]
AS
BEGIN

UPDATE	stg.org
SET		hsh  =  HASHBYTES('MD5', 
						  CONVERT(NVARCHAR(100), ISNULL([Name]				,''))
					+'^'+ CONVERT(NVARCHAR(100), ISNULL(IsNetObject			,''))
					+'^'+ CONVERT(NVARCHAR(100), ISNULL(OperatingCompany	,''))
					+'^'+ CONVERT(NVARCHAR(100), ISNULL(TypeService			,''))
					+'^'+ CONVERT(NVARCHAR(100), ISNULL(AdmArea				,''))
					+'^'+ CONVERT(NVARCHAR(100), ISNULL(District			,''))
					+'^'+ CONVERT(NVARCHAR(100), ISNULL([Address]			,''))
					+'^'+ CONVERT(NVARCHAR(100), ISNULL(PublicPhone			,''))
					);


INSERT INTO dbo.org (global_id
					,[Name]				
					,IsNetObject			
					,OperatingCompany	
					,TypeService			
					,AdmArea				
					,District			
					,[Address]			
					,PublicPhone
					,hsh)
SELECT
	stg.global_id				
	,stg.[Name]				
	,stg.IsNetObject			
	,stg.OperatingCompany	
	,stg.TypeService			
	,stg.AdmArea				
	,stg.District			
	,stg.[Address]			
	,stg.PublicPhone	
	,stg.hsh		
FROM stg.org  stg
LEFT JOIN dbo.org  p
ON stg.global_id = p.global_id 
WHERE p.global_id IS NULL;

UPDATE p
SET 
p.[Name]				= stg.[Name]				
,p.IsNetObject			= stg.IsNetObject			
,p.OperatingCompany		= stg.OperatingCompany	
,p.TypeService			= stg.TypeService			
,p.AdmArea				= stg.AdmArea				
,p.District				= stg.District			
,p.[Address]			= stg.[Address]			
,p.PublicPhone			= stg.PublicPhone
,p.hsh					= stg.hsh			
FROM stg.org  stg
JOIN dbo.org  p
ON stg.global_id = p.global_id 
AND p.hsh <> stg.hsh;

END
