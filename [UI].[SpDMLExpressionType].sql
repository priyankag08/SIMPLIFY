
/*
Name:
	[UI].[SpDMLExpressionType]

Purpose:
	To maintain records for DML operation performed on table UI.[ExpressionType] using CDC

Assumption:
	There must be single DML operation on table at a time

History:
	Created on  22/09/2022 by priyanka gaikwad
	Modified on ---------
*/

CREATE OR ALTER PROC [UI].[SpDMLExpressionType]
AS

BEGIN
 SET NOCOUNT ON;
	--Local variables declaration
	DECLARE @Operation	int
	

	--Check if records inserted, updated or deleted
	Set @Operation = (Select Top 1  __$operation From [cdc].[UI_ExpressionType_CT])	
	
	IF @Operation = 1 -- For Delete
	BEGIN
			Insert Into [Trgr].[ExpressionType]
				(			ExpressionTypeID,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select  [cdc].[UI_ExpressionType_CT].ExpressionTypeID, [cdc].[UI_ExpressionType_CT].	DisplayText, [cdc].[UI_ExpressionType_CT].	[Description], [cdc].[UI_ExpressionType_CT].	AddedBy, [cdc].[UI_ExpressionType_CT].	AddedDate, [cdc].[UI_ExpressionType_CT].	UpdatedBy, [cdc].[UI_ExpressionType_CT].	UpdatedDate, [cdc].[UI_ExpressionType_CT].	IsActive, [cdc].[UI_ExpressionType_CT].	MigrationID, [cdc].[UI_ExpressionType_CT].	IsMigrated, [cdc].[UI_ExpressionType_CT].IsMigrationOverriden, [cdc].[UI_ExpressionType_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_ExpressionType_CT] Where __$operation = @Operation 
	END
	
	IF @Operation = 3 -- Update Record(Need before update and after update details)
	BEGIN
			Insert Into [Trgr].[ExpressionType]
				(			ExpressionTypeID,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
			Select  [cdc].[UI_ExpressionType_CT].ExpressionTypeID, [cdc].[UI_ExpressionType_CT].	DisplayText, [cdc].[UI_ExpressionType_CT].	[Description], [cdc].[UI_ExpressionType_CT].	AddedBy, [cdc].[UI_ExpressionType_CT].	AddedDate, [cdc].[UI_ExpressionType_CT].	UpdatedBy, [cdc].[UI_ExpressionType_CT].	UpdatedDate, [cdc].[UI_ExpressionType_CT].	IsActive, [cdc].[UI_ExpressionType_CT].	MigrationID, [cdc].[UI_ExpressionType_CT].	IsMigrated, [cdc].[UI_ExpressionType_CT].IsMigrationOverriden, [cdc].[UI_ExpressionType_CT].MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_ExpressionType_CT] Where __$operation = @Operation 


			Insert Into [Trgr].[ExpressionType]
				(			ExpressionTypeID,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
			Select  [cdc].[UI_ExpressionType_CT].ExpressionTypeID, [cdc].[UI_ExpressionType_CT].	DisplayText, [cdc].[UI_ExpressionType_CT].	[Description], [cdc].[UI_ExpressionType_CT].	AddedBy, [cdc].[UI_ExpressionType_CT].	AddedDate, [cdc].[UI_ExpressionType_CT].	UpdatedBy, [cdc].[UI_ExpressionType_CT].	UpdatedDate, [cdc].[UI_ExpressionType_CT].	IsActive, [cdc].[UI_ExpressionType_CT].	MigrationID, [cdc].[UI_ExpressionType_CT].	IsMigrated, [cdc].[UI_ExpressionType_CT].IsMigrationOverriden, [cdc].[UI_ExpressionType_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_ExpressionType_CT] Where __$operation = @Operation+1 
	END

	IF @Operation = 2 --For Insert
	BEGIN
			Insert Into [Trgr].[ExpressionType]
				(				ExpressionTypeID,			DisplayText,			[Description],			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsActive,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select  [cdc].[UI_ExpressionType_CT].	ExpressionTypeID, [cdc].[UI_ExpressionType_CT].	DisplayText, [cdc].[UI_ExpressionType_CT].	[Description], [cdc].[UI_ExpressionType_CT].AddedBy, [cdc].[UI_ExpressionType_CT].	AddedDate, [cdc].[UI_ExpressionType_CT].UpdatedBy, [cdc].[UI_ExpressionType_CT].UpdatedDate, [cdc].[UI_ExpressionType_CT].	IsActive, [cdc].[UI_ExpressionType_CT].	MigrationID, [cdc].[UI_ExpressionType_CT].	IsMigrated, [cdc].[UI_ExpressionType_CT].	IsMigrationOverriden, [cdc].[UI_ExpressionType_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_ExpressionType_CT] Where __$operation = @Operation
	END
END