

Declare @TID int
/*******************************************************************************************************
Name
		[UI].[SyncGetClientCredentials]   
Purpose
		To get the clients credentials i.e. UserName,Password,SeverName and DatabaseName of  that perticular Client
Params
		@TID 
History
		2022-06-20 SP created

*******************************************************************************************************/

ALTER PROCEDURE [UI].[SyncGetClientCredentials] @TID int	-- TO Sync clients credentials
AS
BEGIN
	SELECT * FROM dbo.ClientCredentials WHERE TenantID = @TID
END

/*******************************************************************************************************
Name
		[UI].[SyncNextQueued]
		
Purpose
		To get the next queued record from source table in which QueueStatus is Queued & IsRequeued  
	

Params
		@TID 

History
		2022-06-20 SP created

*******************************************************************************************************/

ALTER PROCEDURE [UI].[SyncNextQueued]	-- Get Next Queued data
AS
	
BEGIN
	SET @TID		=(SELECT TenantID FROM DesignSyncProcessQueue WHERE QueueStatus = 2)
	SELECT TOP 1 *	FROM DesignSyncProcessQueue 
	WHERE			(QueueStatus = 1 AND TenantId!=@TID) OR (QueueStatus = 4 AND IsRequeued = 1 AND TenantId!=@TID) 
	ORDER BY		QueueID
END

/*******************************************************************************************************
Name
		[UI].[SyncUpdateQueueStatus]
		
Purpose
		To change the Queuestatus 

Params
		@QID and @QStatus 

History
		2022-06-20 SP created

*******************************************************************************************************/

ALTER PROCEDURE [UI].[SyncUpdateQueueStatus] @QID INT ,@QStatus INT	-- Update Queue status 
AS
BEGIN
	UPDATE	DesignSyncProcessQueue
	SET		QueueStatus = @QStatus			WHERE QueueID = @QID
END


/*******************************************************************************************************
Name
		[UI].[SyncEnableTableProperties]
		
Purpose
		To Enable Table Identities of required tables

History
		2022-06-20 SP created

*******************************************************************************************************/

ALTER PROCEDURE [UI].[SyncEnableTableProperties]	-- To enable table properties
AS
BEGIN
	SET IDENTITY_INSERT [UI].[FormDesign]				OFF
	SET IDENTITY_INSERT [UI].[FormDesignVersion]		OFF
	SET IDENTITY_INSERT [UI].[FormDesignType]			OFF
	SET IDENTITY_INSERT [UI].[FormDesignGroup]			OFF
	SET IDENTITY_INSERT [UI].[FormDesignGroupMapping]	OFF
	SET IDENTITY_INSERT [UI].[FormDesignMapping]		OFF
	SET IDENTITY_INSERT [UI].[DocumentRule]				OFF
	SET IDENTITY_INSERT [UI].[DocumentRuleEventMap]		OFF
END


--Foreign Key Constraint 
ALTER TABLE [UI].[FormDesignGroupMapping]
	ADD CONSTRAINT	FK_FormDesignGroupMapping_FormDesignGroupMapping FOREIGN KEY(FormID)
	REFERENCES		UI.FormDesign(FormID)
GO

ALTER TABLE [UI].[FormDesignGroupMapping]
	ADD CONSTRAINT	FK_FormDesignGroupMapping_FormDesignGroup		 FOREIGN KEY(FormDesignGroupID)
	REFERENCES		UI.FormDesignGroup(FormDesignGroupID)
GO