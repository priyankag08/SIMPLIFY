/*
Name:
	[UI].[SpDMLDocumentRuleType]

Purpose:
	To maintain records for DML operation performed on table UI.[DocumentRuleType] using CDC

Assumption:
	There must be single DML operation on table at a time

History:
	Created on  22/09/2022 by priyanka gaikwad
	Modified on ---------
*/

CREATE OR ALTER PROCEDURE [UI].[SpDMLDocumentRuleType]
AS
BEGIN
 SET NOCOUNT ON;
	--Local variables declaration
	DECLARE @Operation	int

	--Check if records inserted, updated or deleted
	Set @Operation = (Select Top 1  __$operation From [cdc].[UI_DocumentRuleType_CT])

	IF @Operation = 3   -- Update Record(Need before update and after update details)
	BEGIN
			Insert Into [Trgr].[DocumentRuleType]
				(			DocumentRuleTypeID,			DocumentRuleTypeCode,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select  [cdc].[UI_DocumentRuleType_CT].DocumentRuleTypeID, [cdc].[UI_DocumentRuleType_CT].DocumentRuleTypeCode, [cdc].[UI_DocumentRuleType_CT].	DisplayText, [cdc].[UI_DocumentRuleType_CT].	[Description], [cdc].[UI_DocumentRuleType_CT].	AddedBy, [cdc].[UI_DocumentRuleType_CT].	AddedDate, [cdc].[UI_DocumentRuleType_CT].	UpdatedBy, [cdc].[UI_DocumentRuleType_CT].	UpdatedDate, [cdc].[UI_DocumentRuleType_CT].	IsActive, [cdc].[UI_DocumentRuleType_CT].	MigrationID, [cdc].[UI_DocumentRuleType_CT].	IsMigrated, [cdc].[UI_DocumentRuleType_CT].	IsMigrationOverriden, [cdc].[UI_DocumentRuleType_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_DocumentRuleType_CT] Where __$operation=@Operation

			Insert Into [Trgr].[DocumentRuleType]
				(			DocumentRuleTypeID,			DocumentRuleTypeCode,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select  [cdc].[UI_DocumentRuleType_CT].DocumentRuleTypeID, [cdc].[UI_DocumentRuleType_CT].DocumentRuleTypeCode, [cdc].[UI_DocumentRuleType_CT].	DisplayText, [cdc].[UI_DocumentRuleType_CT].	[Description], [cdc].[UI_DocumentRuleType_CT].	AddedBy, [cdc].[UI_DocumentRuleType_CT].	AddedDate, [cdc].[UI_DocumentRuleType_CT].	UpdatedBy, [cdc].[UI_DocumentRuleType_CT].	UpdatedDate, [cdc].[UI_DocumentRuleType_CT].	IsActive, [cdc].[UI_DocumentRuleType_CT].	MigrationID, [cdc].[UI_DocumentRuleType_CT].	IsMigrated, [cdc].[UI_DocumentRuleType_CT].	IsMigrationOverriden, [cdc].[UI_DocumentRuleType_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_DocumentRuleType_CT] Where __$operation=@Operation+1
	END
	
	IF @Operation = 2  -- For Insert
	BEGIN
			Insert Into [Trgr].[DocumentRuleType]
				(			DocumentRuleTypeID,			DocumentRuleTypeCode,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
			Select  [cdc].[UI_DocumentRuleType_CT].DocumentRuleTypeID, [cdc].[UI_DocumentRuleType_CT].DocumentRuleTypeCode, [cdc].[UI_DocumentRuleType_CT].	DisplayText, [cdc].[UI_DocumentRuleType_CT].	[Description], [cdc].[UI_DocumentRuleType_CT].	AddedBy, [cdc].[UI_DocumentRuleType_CT].	AddedDate, [cdc].[UI_DocumentRuleType_CT].	UpdatedBy, [cdc].[UI_DocumentRuleType_CT].	UpdatedDate, [cdc].[UI_DocumentRuleType_CT].	IsActive, [cdc].[UI_DocumentRuleType_CT].	MigrationID, [cdc].[UI_DocumentRuleType_CT].	IsMigrated, [cdc].[UI_DocumentRuleType_CT].	IsMigrationOverriden, [cdc].[UI_DocumentRuleType_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
			from [cdc].[UI_DocumentRuleType_CT] Where __$operation=@Operation
			END

	IF @Operation = 1  -- For Delete
	BEGIN
			Insert Into [Trgr].[DocumentRuleType]
				(			DocumentRuleTypeID,				DocumentRuleTypeCode,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select  [cdc].[UI_DocumentRuleType_CT].	DocumentRuleTypeID, [cdc].[UI_DocumentRuleType_CT].	DocumentRuleTypeCode, [cdc].[UI_DocumentRuleType_CT].	DisplayText, [cdc].[UI_DocumentRuleType_CT].	[Description], [cdc].[UI_DocumentRuleType_CT].AddedBy, [cdc].[UI_DocumentRuleType_CT].	AddedDate, [cdc].[UI_DocumentRuleType_CT].UpdatedBy, [cdc].[UI_DocumentRuleType_CT].UpdatedDate, [cdc].[UI_DocumentRuleType_CT].	IsActive, [cdc].[UI_DocumentRuleType_CT].	MigrationID, [cdc].[UI_DocumentRuleType_CT].	IsMigrated, [cdc].[UI_DocumentRuleType_CT].	IsMigrationOverriden, [cdc].[UI_DocumentRuleType_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_DocumentRuleType_CT]Where  __$operation=@Operation
	END
END
