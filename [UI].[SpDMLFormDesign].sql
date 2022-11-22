/*
Name:
	[UI].[SpDMLFormDesign]

Purpose:
	To maintain records for DML operation performed on table UI.FormDesign using CDC

Assumption:
	There must be single DML operation on table at a time

History:
	Created on  22/09/2022 by priyanka gaikwad
	Modified on 02/11/2022 by priyanka gaikwad
*/

CREATE OR ALTER PROCEDURE [UI].[SpDMLFormDesign]
AS
BEGIN
 SET NOCOUNT ON;
	--Local variables declaration
	Declare @Operation	int,@Count int
	
	
	Set @Count = (Select Count(*) from [cdc].[UI_FormDesign_CT])

	While (@Count>0)
	BEGIN
	--Check if records inserted, updated or deleted
	Set @Operation = (Select Top 1  __$operation From [cdc].[UI_FormDesign_CT])

	IF @Operation = 3   -- Update Record(Need before update and after update details)
	BEGIN
			Insert Into [Trgr].[FormDesign]
			(			FormID,			FormName,			DisplayText,			IsActive,
			Abbreviation,			TenantID,			AddedBy,			AddedDate,			
			UpdatedBy,			UpdatedDate,			IsMasterList,			DocumentDesignTypeID,			[Sequence],			DocumentLocationID,			IsAliasDesignMasterList,			UsesAliasDesignMasterList,			IsSectionLock,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select Top(1) [cdc].[UI_FormDesign_CT].FormID, [cdc].[UI_FormDesign_CT].FormName, [cdc].[UI_FormDesign_CT].	DisplayText, [cdc].[UI_FormDesign_CT].	IsActive, [cdc].[UI_FormDesign_CT].
			Abbreviation, [cdc].[UI_FormDesign_CT].	TenantID, [cdc].[UI_FormDesign_CT].	AddedBy, [cdc].[UI_FormDesign_CT].	AddedDate, [cdc].[UI_FormDesign_CT].	UpdatedBy,
			[cdc].[UI_FormDesign_CT].	UpdatedDate, [cdc].[UI_FormDesign_CT].	IsMasterList, [cdc].[UI_FormDesign_CT].	DocumentDesignTypeID, 
			[cdc].[UI_FormDesign_CT].[Sequence], [cdc].[UI_FormDesign_CT].DocumentLocationID, [cdc].[UI_FormDesign_CT].IsAliasDesignMasterList,
			[cdc].[UI_FormDesign_CT].UsesAliasDesignMasterList, [cdc].[UI_FormDesign_CT].	IsSectionLock, [cdc].[UI_FormDesign_CT].	MigrationID, 
			[cdc].[UI_FormDesign_CT].IsMigrated, [cdc].[UI_FormDesign_CT].IsMigrationOverriden, [cdc].[UI_FormDesign_CT].	MigrationDate, 2 as
			DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_FormDesign_CT] Where __$operation=@Operation

			Insert Into [Trgr].[FormDesign]
			(			FormID,			FormName,			DisplayText,			IsActive,
			Abbreviation,			TenantID,			AddedBy,			AddedDate,			
			UpdatedBy,			UpdatedDate,			IsMasterList,			DocumentDesignTypeID,			[Sequence],			DocumentLocationID,			IsAliasDesignMasterList,			UsesAliasDesignMasterList,			IsSectionLock,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select Top(1) [cdc].[UI_FormDesign_CT].FormID, [cdc].[UI_FormDesign_CT].FormName, [cdc].[UI_FormDesign_CT].	DisplayText, [cdc].[UI_FormDesign_CT].	IsActive, [cdc].[UI_FormDesign_CT].
			Abbreviation, [cdc].[UI_FormDesign_CT].	TenantID, [cdc].[UI_FormDesign_CT].	AddedBy, [cdc].[UI_FormDesign_CT].	AddedDate, [cdc].[UI_FormDesign_CT].	UpdatedBy,
			[cdc].[UI_FormDesign_CT].	UpdatedDate, [cdc].[UI_FormDesign_CT].	IsMasterList, [cdc].[UI_FormDesign_CT].	DocumentDesignTypeID, 
			[cdc].[UI_FormDesign_CT].[Sequence], [cdc].[UI_FormDesign_CT].DocumentLocationID, [cdc].[UI_FormDesign_CT].IsAliasDesignMasterList,
			[cdc].[UI_FormDesign_CT].UsesAliasDesignMasterList, [cdc].[UI_FormDesign_CT].	IsSectionLock, [cdc].[UI_FormDesign_CT].	MigrationID, 
			[cdc].[UI_FormDesign_CT].IsMigrated, [cdc].[UI_FormDesign_CT].IsMigrationOverriden, [cdc].[UI_FormDesign_CT].	MigrationDate, 3 as
			DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_FormDesign_CT] Where __$operation=(@Operation+1)
			Delete Top(2) From [cdc].[UI_FormDesign_CT]
			Set @Count = @Count-2
	END
	
			IF @Operation = 2 --insert
			Begin
					Insert Into [Trgr].[FormDesign]
					(			FormID,			FormName,			DisplayText,			IsActive,			Abbreviation,			TenantID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsMasterList,			DocumentDesignTypeID,			[Sequence],			DocumentLocationID,			IsAliasDesignMasterList,			UsesAliasDesignMasterList,			IsSectionLock,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
					Select Top(1) [cdc].[UI_FormDesign_CT].FormID, [cdc].[UI_FormDesign_CT].FormName, [cdc].[UI_FormDesign_CT].	DisplayText,
					[cdc].[UI_FormDesign_CT].	IsActive, [cdc].[UI_FormDesign_CT].	Abbreviation, [cdc].[UI_FormDesign_CT].	TenantID, [cdc].[UI_FormDesign_CT].	AddedBy,
					[cdc].[UI_FormDesign_CT].	AddedDate, [cdc].[UI_FormDesign_CT].	UpdatedBy, [cdc].[UI_FormDesign_CT].	UpdatedDate, [cdc].[UI_FormDesign_CT].	IsMasterList, 
					[cdc].[UI_FormDesign_CT].	DocumentDesignTypeID, [cdc].[UI_FormDesign_CT].	[Sequence], [cdc].[UI_FormDesign_CT].DocumentLocationID, 
					[cdc].[UI_FormDesign_CT].IsAliasDesignMasterList, [cdc].[UI_FormDesign_CT].	UsesAliasDesignMasterList, [cdc].[UI_FormDesign_CT].	IsSectionLock, 
					[cdc].[UI_FormDesign_CT].	MigrationID, [cdc].[UI_FormDesign_CT].	IsMigrated, [cdc].[UI_FormDesign_CT].IsMigrationOverriden,
					[cdc].[UI_FormDesign_CT].	MigrationDate, 1 as	DMLOperation, getdate() as	OperationDate
					From [cdc].[UI_FormDesign_CT] Where __$operation=@Operation
					Delete Top(1) From [cdc].[UI_FormDesign_CT]
					Set @Count = @Count-1
			END

			IF @Operation = 1  --deletion of record
			BEGIN
					Insert Into [Trgr].[FormDesign]
					(				FormID,				FormName,			DisplayText,			IsActive,			Abbreviation,			TenantID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsMasterList,			DocumentDesignTypeID,			[Sequence],				DocumentLocationID,				IsAliasDesignMasterList,			UsesAliasDesignMasterList,			IsSectionLock,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
					Select Top(1)  [cdc].[UI_FormDesign_CT].	FormID, [cdc].[UI_FormDesign_CT].	FormName, [cdc].[UI_FormDesign_CT].	DisplayText, [cdc].[UI_FormDesign_CT].	IsActive, [cdc].[UI_FormDesign_CT].	Abbreviation, [cdc].[UI_FormDesign_CT].	TenantID, [cdc].[UI_FormDesign_CT].	AddedBy, [cdc].[UI_FormDesign_CT].	AddedDate, [cdc].[UI_FormDesign_CT].UpdatedBy, [cdc].[UI_FormDesign_CT].UpdatedDate, [cdc].[UI_FormDesign_CT].	IsMasterList, [cdc].[UI_FormDesign_CT].	DocumentDesignTypeID, [cdc].[UI_FormDesign_CT].	[Sequence], [cdc].[UI_FormDesign_CT].	DocumentLocationID, [cdc].[UI_FormDesign_CT].	IsAliasDesignMasterList, [cdc].[UI_FormDesign_CT].	UsesAliasDesignMasterList,
					[cdc].[UI_FormDesign_CT].IsSectionLock, [cdc].[UI_FormDesign_CT].MigrationID,
					[cdc].[UI_FormDesign_CT].	IsMigrated, [cdc].[UI_FormDesign_CT].	IsMigrationOverriden,
					[cdc].[UI_FormDesign_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
					From [cdc].[UI_FormDesign_CT] Where __$operation=@Operation
					Delete Top(1) From [cdc].[UI_FormDesign_CT]
					Set @Count = @Count-1
	END
END
END