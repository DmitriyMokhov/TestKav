CREATE TABLE [stg].[org]
(
	global_id bigint,
	[Name] varchar(200) null,
	IsNetObject varchar(20) null,
	OperatingCompany varchar(200) null,
	TypeService varchar(200) null,
	AdmArea varchar(200) null,
	District varchar(200) null,
	[Address] varchar(2000) null,
	PublicPhone varchar(50) null,
	hsh binary(16) null
)