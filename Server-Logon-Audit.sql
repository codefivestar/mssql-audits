----------------------------------------------------------------------------------------------------------
--Autor          : Hidequel Puga
--Fecha          : 2021-07-05
--Descripción    : How to Create a SQL Server Logon Trigger
--Ref            : https://www.netwrix.com/how_to_create_sql_server_logon_trigger.html?utm_source=content&utm_medium=guide&utm_campaign=sql-server-security-best-practices&cID=7010g000000n6xk
----------------------------------------------------------------------------------------------------------

USE [master]
GO

CREATE DATABASE [LogonAudit] /* Creates db for storing audit data */

USE [LogonAudit]
GO

CREATE TABLE [dbo].[LogonAuditing] /* Creates table for logons inside db */
(
	  SessionId   INT
	, LogonTime   DATETIME
	, HostName    VARCHAR(50)
	, ProgramName VARCHAR(500)
	, LoginName   VARCHAR(50)
	, ClientHost  VARCHAR(50)
)
GO

CREATE TRIGGER [LogonAuditTrigger] /* Creates trigger for logons */
ON ALL SERVER
FOR LOGON 
AS
BEGIN

	DECLARE @LogonTriggerData XML
		  , @EventTime        DATETIME
		  , @LoginName        VARCHAR(50)
		  , @ClientHost       VARCHAR(50)
		  , @LoginType        VARCHAR(50)
		  , @HostName         VARCHAR(50)
		  , @AppName          VARCHAR(500);

	SET @LogonTriggerData = eventdata();
	SET @EventTime        = @LogonTriggerData.value('(/EVENT_INSTANCE/PostTime)[1]', 'datetime');
	SET @LoginName        = @LogonTriggerData.value('(/EVENT_INSTANCE/LoginName)[1]', 'varchar(50)');
	SET @ClientHost       = @LogonTriggerData.value('(/EVENT_INSTANCE/ClientHost)[1]', 'varchar(50)');
	SET @HostName         = HOST_NAME();
	SET @AppName          = APP_NAME();

	INSERT INTO [LogonAudit].[dbo].[LogonAuditing] 
	(
		  SessionId
		, LogonTime
		, HostName
		, ProgramName
		, LoginName
		, ClientHost
	)
	SELECT @@spid
		 , @EventTime
		 , @HostName
		 , @AppName
		 , @LoginName
		 , @ClientHost;
END
GO


