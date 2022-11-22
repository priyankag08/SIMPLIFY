/*
Name:
	[UI].[SpDMLDocumentRuleTargetType]

Purpose:
	To maintain records for DML operation performed on table UI.[DocumentRuleTargetType] using CDC

Assumption:
	There must be single DML operation on table at a time

History:
	Created on  06/10/2022 by Priyanka Gaikwad
	Modified on ---------
*/

CREATE OR ALTER PROC [UI].[SpDMLDocumentRuleTargetType]
AS

BEGIN
 SET NOCOUNT ON;
    --Local variables declaration
	DECLARE @Operation	int

	--Check if records inserted, updated or deleted
	Set @Operation = (Select Top 1  __$operation From [cdc].[UI_DocumentRuleTargetType_CT])

	IF @Operation = 1	-- Delete
	BEGIN
			Insert Into [Trgr].[DocumentRuleTargetType]
				(			DocumentRuleTargetTypeID,			DocumentRuleTargetTypeCode,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select  [cdc].[UI_DocumentRuleTargetType_CT].DocumentRuleTargetTypeID, [cdc].[UI_DocumentRuleTargetType_CT].	DocumentRuleTargetTypeCode, [cdc].[UI_DocumentRuleTargetType_CT].DisplayText, [cdc].[UI_DocumentRuleTargetType_CT].	[Description], [cdc].[UI_DocumentRuleTargetType_CT].	AddedBy, [cdc].[UI_DocumentRuleTargetType_CT].	AddedDate, [cdc].[UI_DocumentRuleTargetType_CT].	UpdatedBy, [cdc].[UI_DocumentRuleTargetType_CT].	UpdatedDate, [cdc].[UI_DocumentRuleTargetType_CT].	IsActive, [cdc].[UI_DocumentRuleTargetType_CT].	MigrationID, [cdc].[UI_DocumentRuleTargetType_CT].	IsMigrated, [cdc].[UI_DocumentRuleTargetType_CT].IsMigrationOverriden, [cdc].[UI_DocumentRuleTargetType_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_DocumentRuleTargetType_CT] Where __$operation = @Operation
	END
	
	IF @Operation = 3 -- Update Record(Need before update and after update details)
	BEGIN
			Insert Into [Trgr].[DocumentRuleTargetType]
			(			DocumentRuleTargetTypeID,			DocumentRuleTargetTypeCode,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
			Select  [cdc].[UI_DocumentRuleTargetType_CT].DocumentRuleTargetTypeID, [cdc].[UI_DocumentRuleTargetType_CT].	DocumentRuleTargetTypeCode, [cdc].[UI_DocumentRuleTargetType_CT].DisplayText, [cdc].[UI_DocumentRuleTargetType_CT].	[Description], [cdc].[UI_DocumentRuleTargetType_CT].	AddedBy, [cdc].[UI_DocumentRuleTargetType_CT].	AddedDate, [cdc].[UI_DocumentRuleTargetType_CT].	UpdatedBy, [cdc].[UI_DocumentRuleTargetType_CT].	UpdatedDate, [cdc].[UI_DocumentRuleTargetType_CT].	IsActive, [cdc].[UI_DocumentRuleTargetType_CT].	MigrationID, [cdc].[UI_DocumentRuleTargetType_CT].	IsMigrated, [cdc].[UI_DocumentRuleTargetType_CT].IsMigrationOverriden, [cdc].[UI_DocumentRuleTargetType_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_DocumentRuleTargetType_CT] Where __$operation = @Operation
			
			Insert Into [Trgr].[DocumentRuleTargetType]
			(			DocumentRuleTargetTypeID,			DocumentRuleTargetTypeCode,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
			Select  [cdc].[UI_DocumentRuleTargetType_CT].DocumentRuleTargetTypeID, [cdc].[UI_DocumentRuleTargetType_CT].	DocumentRuleTargetTypeCode, [cdc].[UI_DocumentRuleTargetType_CT].DisplayText, [cdc].[UI_DocumentRuleTargetType_CT].	[Description], [cdc].[UI_DocumentRuleTargetType_CT].	AddedBy, [cdc].[UI_DocumentRuleTargetType_CT].	AddedDate, [cdc].[UI_DocumentRuleTargetType_CT].	UpdatedBy, [cdc].[UI_DocumentRuleTargetType_CT].	UpdatedDate, [cdc].[UI_DocumentRuleTargetType_CT].	IsActive, [cdc].[UI_DocumentRuleTargetType_CT].	MigrationID, [cdc].[UI_DocumentRuleTargetType_CT].	IsMigrated, [cdc].[UI_DocumentRuleTargetType_CT].IsMigrationOverriden, [cdc].[UI_DocumentRuleTargetType_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_DocumentRuleTargetType_CT] Where __$operation = @Operation+1
	END

	IF @Operation = 2 -- Insert
	BEGIN
			Insert Into [Trgr].[DocumentRuleTargetType]
				(				DocumentRuleTargetTypeID,			DocumentRuleTargetTypeCode,				DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select  [cdc].[UI_DocumentRuleTargetType_CT].	DocumentRuleTargetTypeID, [cdc].[UI_DocumentRuleTargetType_CT].	DocumentRuleTargetTypeCode, [cdc].[UI_DocumentRuleTargetType_CT].	DisplayText, [cdc].[UI_DocumentRuleTargetType_CT].	[Description], [cdc].[UI_DocumentRuleTargetType_CT].AddedBy, [cdc].[UI_DocumentRuleTargetType_CT].	AddedDate, [cdc].[UI_DocumentRuleTargetType_CT].UpdatedBy, [cdc].[UI_DocumentRuleTargetType_CT].UpdatedDate, [cdc].[UI_DocumentRuleTargetType_CT].	IsActive, [cdc].[UI_DocumentRuleTargetType_CT].	MigrationID, [cdc].[UI_DocumentRuleTargetType_CT].	IsMigrated, [cdc].[UI_DocumentRuleTargetType_CT].	IsMigrationOverriden, [cdc].[UI_DocumentRuleTargetType_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_DocumentRuleTargetType_CT] Where __$operation = @Operation
	END 

END
