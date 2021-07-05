----------------------------------------------------------------------------------------------------------
--Autor          : Hidequel Puga
--Fecha          : 2021-07-05
--Descripción    : Database security audit for DDL
--Ref            : https://solutioncenter.apexsql.com/es/auditoria-de-seguridad-de-bases-de-datos-sql-server/
----------------------------------------------------------------------------------------------------------

USE [master]
GO

CREATE SERVER AUDIT [Audit ALI_WRKBGDBA DDL] -- Audit [Dbname] DDL
TO FILE 
(	
	  FILEPATH           = N'C:\SQLAudits\'
	, MAXSIZE            = 20 MB
	, MAX_FILES          = 20
	, RESERVE_DISK_SPACE = ON
)
WITH
(	
	  QUEUE_DELAY = 1000
	, ON_FAILURE  = CONTINUE
	, AUDIT_GUID  = '928b1094-b02b-437d-a5c7-8266af853b57'
)
ALTER SERVER AUDIT [Audit ALI_WRKBGDBA DDL] WITH (STATE = ON)
GO

USE [ALI_WRKBGDBA]
GO

CREATE DATABASE AUDIT SPECIFICATION [ALI_WRKBGDBA Auditing]
FOR SERVER AUDIT [Audit ALI_WRKBGDBA DDL] 
      ADD (SCHEMA_OBJECT_ACCESS_GROUP)
	, ADD (SCHEMA_OBJECT_CHANGE_GROUP)
	, ADD (SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP)
	, ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP)
	, ADD (USER_CHANGE_PASSWORD_GROUP)
	, ADD (DATABASE_OBJECT_ACCESS_GROUP)
	, ADD (DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP)
	, ADD (DATABASE_OBJECT_PERMISSION_CHANGE_GROUP)
	, ADD (DATABASE_OPERATION_GROUP)
	, ADD (DATABASE_OWNERSHIP_CHANGE_GROUP)
	, ADD (DATABASE_PERMISSION_CHANGE_GROUP)
	, ADD (DATABASE_PRINCIPAL_IMPERSONATION_GROUP)
	, ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP)
GO



