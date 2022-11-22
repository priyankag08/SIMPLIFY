USE [eBS4_INT_QA2]
GO
/****** Object:  Trigger [UI].[DML_Trgr_FormDesign]    Script Date: 9/7/2022 3:06:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure sp_DML_FormDesign
AS 
Begin
-----------------------------------------------------------------------------------
--select * from cdc.UI_FormDesign_CT
Begin
 SET NOCOUNT ON;

	declare @Operation	int;
	declare @inserted	int;
	declare @deleted	int;

	select @inserted=inserted.FormID from cdc.UI_FormDesign_CT        /*INSERTED */
	select @deleted=deleted.FormID from cdc.UI_FormDesign_CT

	set @Operation = CASE WHEN @inserted IS NULL THEN 4 WHEN  @deleted IS NULL THEN 1 ELSE 3 END
	
	if @Operation = 4
	Begin
			insert into [Trgr].[FormDesign]
			output inserted
				(			FormID,			FormName,			DisplayText,			IsActive,
				Abbreviation,			TenantID,			AddedBy,			AddedDate,			
				UpdatedBy,			UpdatedDate,			IsMasterList,			DocumentDesignTypeID,			[Sequence],			DocumentLocationID,			IsAliasDesignMasterList,			UsesAliasDesignMasterList,			IsSectionLock,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			select  Deleted.FormID, Deleted.FormName, Deleted.	DisplayText, Deleted.	IsActive, Deleted.
			Abbreviation, Deleted.	TenantID, Deleted.	AddedBy, Deleted.	AddedDate, Deleted.	UpdatedBy,
			Deleted.	UpdatedDate, Deleted.	IsMasterList, Deleted.	DocumentDesignTypeID, Deleted.
			[Sequence], Deleted.DocumentLocationID, Deleted.IsAliasDesignMasterList, Deleted.
			UsesAliasDesignMasterList, Deleted.	IsSectionLock, Deleted.	MigrationID, Deleted.
			IsMigrated, Deleted.IsMigrationOverriden, Deleted.	MigrationDate, @Operation as
			DMLOperation, getdate() as	OperationDate


			from deleted
	End
	else
	Begin
			if @Operation = 3
			Begin
					insert into [Trgr].[FormDesign]
						(			FormID,			FormName,			DisplayText,			IsActive,			Abbreviation,			TenantID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsMasterList,			DocumentDesignTypeID,			[Sequence],			DocumentLocationID,			IsAliasDesignMasterList,			UsesAliasDesignMasterList,			IsSectionLock,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
					select  Deleted.FormID, Deleted.FormName, Deleted.	DisplayText, Deleted.	IsActive, Deleted.	Abbreviation, Deleted.	TenantID, Deleted.	AddedBy, Deleted.	AddedDate, Deleted.	UpdatedBy, Deleted.	UpdatedDate, Deleted.	IsMasterList, Deleted.	DocumentDesignTypeID, Deleted.	[Sequence], Deleted.DocumentLocationID, Deleted.IsAliasDesignMasterList, Deleted.	UsesAliasDesignMasterList, Deleted.	IsSectionLock, Deleted.	MigrationID, Deleted.	IsMigrated, Deleted.IsMigrationOverriden, Deleted.	MigrationDate, @Operation as	DMLOperation, getdate() as	OperationDate
					from deleted
			End

			insert into [Trgr].[FormDesign]
				(				FormID,				FormName,			DisplayText,			IsActive,			Abbreviation,			TenantID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsMasterList,			DocumentDesignTypeID,			[Sequence],				DocumentLocationID,				IsAliasDesignMasterList,			UsesAliasDesignMasterList,			IsSectionLock,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			select  Inserted.	FormID, Inserted.	FormName, Inserted.	DisplayText, Inserted.	IsActive, Inserted.	Abbreviation, Inserted.	TenantID, Inserted.	AddedBy, Inserted.	AddedDate, Inserted.UpdatedBy, Inserted.UpdatedDate, Inserted.	IsMasterList, Inserted.	DocumentDesignTypeID, Inserted.	[Sequence], Inserted.	DocumentLocationID, Inserted.	IsAliasDesignMasterList, Inserted.	UsesAliasDesignMasterList, Inserted.IsSectionLock, Inserted.MigrationID, Inserted.	IsMigrated, Inserted.	IsMigrationOverriden, Inserted.	MigrationDate, @Operation as	DMLOperation, getdate() as	OperationDate
			from inserted
	End
End
------------------------------------------





ALTER Trigger [UI].[DML_Trgr_FormDesign]
 on [UI].[FormDesign]
AFTER INSERT,UPDATE,DELETE
As
Begin
 SET NOCOUNT ON;

	declare @Operation	int
	declare @inserted	int
	declare @deleted	int

	select @inserted=inserted.FormID from INSERTED 
	select @deleted=deleted.FormID from DELETED

	set @Operation = CASE WHEN @inserted IS NULL THEN 4 WHEN  @deleted IS NULL THEN 1 ELSE 3 END
	
	if @Operation = 4
	Begin
			insert into [Trgr].[FormDesign]
				(			FormID,			FormName,			DisplayText,			IsActive,			Abbreviation,			TenantID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsMasterList,			DocumentDesignTypeID,			[Sequence],			DocumentLocationID,			IsAliasDesignMasterList,			UsesAliasDesignMasterList,			IsSectionLock,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			select  Deleted.FormID, Deleted.FormName, Deleted.	DisplayText, Deleted.	IsActive, Deleted.	Abbreviation, Deleted.	TenantID, Deleted.	AddedBy, Deleted.	AddedDate, Deleted.	UpdatedBy, Deleted.	UpdatedDate, Deleted.	IsMasterList, Deleted.	DocumentDesignTypeID, Deleted.	[Sequence], Deleted.DocumentLocationID, Deleted.IsAliasDesignMasterList, Deleted.	UsesAliasDesignMasterList, Deleted.	IsSectionLock, Deleted.	MigrationID, Deleted.	IsMigrated, Deleted.IsMigrationOverriden, Deleted.	MigrationDate, @Operation as	DMLOperation, getdate() as	OperationDate
			from deleted
	End
	else
	Begin
			if @Operation = 3
			Begin
					insert into [Trgr].[FormDesign]
						(			FormID,			FormName,			DisplayText,			IsActive,			Abbreviation,			TenantID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsMasterList,			DocumentDesignTypeID,			[Sequence],			DocumentLocationID,			IsAliasDesignMasterList,			UsesAliasDesignMasterList,			IsSectionLock,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
					select  Deleted.FormID, Deleted.FormName, Deleted.	DisplayText, Deleted.	IsActive, Deleted.	Abbreviation, Deleted.	TenantID, Deleted.	AddedBy, Deleted.	AddedDate, Deleted.	UpdatedBy, Deleted.	UpdatedDate, Deleted.	IsMasterList, Deleted.	DocumentDesignTypeID, Deleted.	[Sequence], Deleted.DocumentLocationID, Deleted.IsAliasDesignMasterList, Deleted.	UsesAliasDesignMasterList, Deleted.	IsSectionLock, Deleted.	MigrationID, Deleted.	IsMigrated, Deleted.IsMigrationOverriden, Deleted.	MigrationDate, @Operation as	DMLOperation, getdate() as	OperationDate
					from deleted
			End

			insert into [Trgr].[FormDesign]
				(				FormID,				FormName,			DisplayText,			IsActive,			Abbreviation,			TenantID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsMasterList,			DocumentDesignTypeID,			[Sequence],				DocumentLocationID,				IsAliasDesignMasterList,			UsesAliasDesignMasterList,			IsSectionLock,			MigrationID,			IsMigrated,				IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			select  Inserted.	FormID, Inserted.	FormName, Inserted.	DisplayText, Inserted.	IsActive, Inserted.	Abbreviation, Inserted.	TenantID, Inserted.	AddedBy, Inserted.	AddedDate, Inserted.UpdatedBy, Inserted.UpdatedDate, Inserted.	IsMasterList, Inserted.	DocumentDesignTypeID, Inserted.	[Sequence], Inserted.	DocumentLocationID, Inserted.	IsAliasDesignMasterList, Inserted.	UsesAliasDesignMasterList, Inserted.IsSectionLock, Inserted.MigrationID, Inserted.	IsMigrated, Inserted.	IsMigrationOverriden, Inserted.	MigrationDate, @Operation as	DMLOperation, getdate() as	OperationDate
			from inserted
	End
End
