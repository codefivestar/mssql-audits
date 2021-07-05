----------------------------------------------------------------------------------------------------------
--Autor          : Hidequel Puga
--Fecha          : 2021-07-05
--Descripción    : Database security audit for DML
--Ref            : https://solutioncenter.apexsql.com/es/auditoria-de-seguridad-de-bases-de-datos-sql-server/
----------------------------------------------------------------------------------------------------------

USE [master]
GO

CREATE SERVER AUDIT [Audit ALI_WRKBGDBA DML] -- Audit [Dbname] DML
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
	, AUDIT_GUID  = '928b1094-b02b-437d-a5c7-8266af853b59'
)
ALTER SERVER AUDIT [Audit ALI_WRKBGDBA DML] WITH (STATE = ON)
GO

USE [ALI_WRKBGDBA]
GO

CREATE DATABASE AUDIT SPECIFICATION [DatabaseAuditSpecification-20210705-144545]
FOR SERVER AUDIT [Audit ALI_WRKBGDBA DML]
ADD (INSERT ON OBJECT::[dba].[ADMIN_CONFIG] BY [public]),
ADD (SELECT ON OBJECT::[dba].[ADMIN_CONFIG] BY [public]),
ADD (UPDATE ON OBJECT::[dba].[ADMIN_CONFIG] BY [public]),
ADD (DELETE ON OBJECT::[dba].[ADMIN_CONFIG] BY [public])

GO
