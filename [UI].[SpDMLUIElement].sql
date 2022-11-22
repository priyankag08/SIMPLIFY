USE [eBS4_INT_QA2]
GO
/****** Object:  Trigger [UI].[DML_Trgr_UIElement]    Script Date: 10/4/2022 12:05:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER trigger [UI].[DML_Trgr_UIElement]
 on [UI].[UIElement]
AFTER INSERT,UPDATE,DELETE
As
Begin
 SET NOCOUNT ON;
    --Local Variables declaration
	declare @Operation	int,@inserted int, @deleted	int,@iLabel VARCHAR(1000),@dLabel VARCHAR(1000),@iEnabled bit, @dEnabled bit, @iVisible bit, @dVisible bit,
	@iSequence int, @dSequence int, @iReqValidation bit, @dReqValidation bit, @iDatatype NVARCHAR(50), @dDatatype NVARCHAR(50), @iGeneratedName NVARCHAR(100),
	@dGeneratedName NVARCHAR(100), @iCheckDuplicate bit, @dCheckDuplicate bit, @iAllowGlobalUpdates bit, @dAllowGlobalUpdates bit, @iViewType NVARCHAR(50),
	@dViewType NVARCHAR(50), @iExtProp NVARCHAR(MAX), @dExtProp NVARCHAR(MAX), @dIsSameSectionRuleSrc bit,@iIsSameSectionRuleSrc bit, @iIsStandard bit, @dIsStandard bit, @iHasCustomRule bit,
	@dHasCustomRule bit, @iMDMName NVARCHAR(1000), @dMDMName NVARCHAR(1000), @iHelpText NVARCHAR(1000), @dHelpText NVARCHAR(1000)

	select @inserted=inserted.UIElementID from INSERTED
	select @deleted=deleted.UIElementID from DELETED

	--Check if record is inserted deleted or updated
	set @Operation = CASE WHEN @inserted IS NULL THEN 4 WHEN  @deleted IS NULL THEN 1 ELSE 3 END

	if @Operation = 4 -- For deleted record
	Begin
			insert into [Trgr].[UIElement]
				(			UIElementID,			UIElementName,			Label,			ParentUIElementID,			IsContainer,			[Enabled],			Visible,			[Sequence],			RequiresValidation,			HelpText,			AddedBy,			AddedDate,			IsActive,			FormID,			UIElementDataTypeID,			UpdatedBy,			UpdatedDate,			HasCustomRule,			CustomRule,			GeneratedName,			DataSourceElementDisplayModeID,			CheckDuplicate,			AllowGlobalUpdates,			ViewType,			ExtendedProperties,			IsSameSectionRuleSource,			IsStandard,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			select  Deleted.UIElementID, Deleted.	UIElementName, Deleted.	Label, Deleted.	ParentUIElementID, Deleted.	IsContainer, Deleted.	[Enabled], Deleted.	Visible, Deleted.	[Sequence], Deleted.RequiresValidation, Deleted.HelpText, Deleted.	AddedBy, Deleted.	AddedDate, Deleted.	IsActive, Deleted.	FormID, Deleted.UIElementDataTypeID, Deleted.	UpdatedBy, Deleted.	UpdatedDate, Deleted.	HasCustomRule, Deleted.	CustomRule, Deleted.GeneratedName, Deleted.	DataSourceElementDisplayModeID, Deleted.CheckDuplicate, Deleted.AllowGlobalUpdates, Deleted.ViewType, Deleted.	ExtendedProperties, Deleted.IsSameSectionRuleSource, Deleted.	IsStandard, Deleted.MigrationID, Deleted.	IsMigrated, Deleted.IsMigrationOverriden, Deleted.	MigrationDate, @Operation as	DMLOperation, getdate() as	OperationDate
			from deleted
	End
	else
	Begin
			if @Operation = 3 -- For updated
			Begin
					insert into [Trgr].[UIElement]
						(			UIElementID,			UIElementName,			Label,			ParentUIElementID,			IsContainer,			[Enabled],			Visible,			[Sequence],			RequiresValidation,			HelpText,			AddedBy,			AddedDate,			IsActive,			FormID,			UIElementDataTypeID,			UpdatedBy,			UpdatedDate,			HasCustomRule,			CustomRule,			GeneratedName,			DataSourceElementDisplayModeID,			CheckDuplicate,			AllowGlobalUpdates,			ViewType,			ExtendedProperties,			IsSameSectionRuleSource,			IsStandard,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
					select  Deleted.UIElementID, Deleted.	UIElementName, Deleted.	Label, Deleted.	ParentUIElementID, Deleted.	IsContainer, Deleted.	[Enabled], Deleted.	Visible, Deleted.	[Sequence], Deleted.RequiresValidation, Deleted.HelpText, Deleted.	AddedBy, Deleted.	AddedDate, Deleted.	IsActive, Deleted.	FormID, Deleted.UIElementDataTypeID, Deleted.	UpdatedBy, Deleted.	UpdatedDate, Deleted.	HasCustomRule, Deleted.	CustomRule, Deleted.GeneratedName, Deleted.	DataSourceElementDisplayModeID, Deleted.CheckDuplicate, Deleted.AllowGlobalUpdates, Deleted.ViewType, Deleted.	ExtendedProperties, Deleted.IsSameSectionRuleSource, Deleted.	IsStandard, Deleted.MigrationID, Deleted.	IsMigrated, Deleted.IsMigrationOverriden, Deleted.	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
					from deleted

	select @dLabel =ISNULL(Label,''), @dEnabled =ISNULL([Enabled],0), @dVisible =ISNULL(Visible,0) , @dSequence =ISNULL([Sequence],0),
	@dReqValidation =ISNULL(RequiresValidation,0),@dGeneratedName =ISNULL(GeneratedName,''), @dCheckDuplicate =ISNULL(CheckDuplicate,0) ,
	@dAllowGlobalUpdates =ISNULL(AllowGlobalUpdates,0), @dExtProp =ISNULL(ExtendedProperties,''), @dIsSameSectionRuleSrc =ISNULL(IsSameSectionRuleSource,0),
	 @dIsStandard =ISNULL(IsStandard,0), @dHasCustomRule =ISNULL(HasCustomRule,0),@dMDMName =ISNULL(MDMName,''),@dHelpText=ISNULL(HelpText,'')   from deleted
	
	select @iLabel =ISNULL(Label,''), @iEnabled =ISNULL([Enabled],0) ,@iVisible =ISNULL(Visible,0),@iSequence =ISNULL([Sequence],0),
	@iReqValidation =ISNULL(RequiresValidation,0), @iGeneratedName =ISNULL(GeneratedName,''), @iCheckDuplicate =ISNULL(CheckDuplicate,0),
	@iAllowGlobalUpdates =ISNULL(AllowGlobalUpdates,0), @iExtProp =ISNULL(ExtendedProperties,''), @iIsSameSectionRuleSrc =ISNULL(IsSameSectionRuleSource,0),
	@iIsStandard =ISNULL(IsStandard,0) ,@iHasCustomRule =ISNULL(HasCustomRule,0),@iMDMName =ISNULL(MDMName,'') ,@iHelpText=ISNULL(HelpText,'')  from inserted

	select @dDatatype = ISNULL(DisplayText,'None') from deleted d inner join [UI].[ApplicationDataType] AD
	                     ON AD.ApplicationDataTypeID=d.UIElementDataTypeID
	select @iDatatype =ISNULL(DisplayText,'None') from inserted i inner join [UI].[ApplicationDataType] AD
	                     ON AD.ApplicationDataTypeID=i.UIElementDataTypeID

	select @dViewType = CASE ISNULL(ViewType,0) WHEN 1 THEN 'Folder View' WHEN 2 THEN 'SOT View' WHEN 3 THEN
	'Both' WHEN 4 THEN 'None' WHEN 5 THEN 'Summary View' ELSE 'None' END from deleted
	select @iViewType =CASE ISNULL(ViewType,0) WHEN 1 THEN 'Folder View' WHEN 2 THEN 'SOT View' WHEN 3 THEN
	'Both' WHEN 4 THEN 'None' WHEN 5 THEN 'Summary View' ELSE 'None' END from inserted

	 If (@dLabel<>@iLabel)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			'Label for element is changed from '+ ISNULL(d.Label,'None') + ' to '+ ISNULL(i.Label,'None')  ,			
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label	, ISNULL(fdvui.FormDesignVersionID,0)	 
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID 
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	 If (@dEnabled<>@iEnabled)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),					
			CASE ISNULL(@dEnabled,0) WHEN 0 THEN cast(i.Label as varchar(MAX)) + ' is enabled ' 
			ELSE cast(i.Label as varchar(MAX)) + ' is disabled ' END  ,
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy), GETDATE(), i.UIElementName, i.Label, ISNULL(fdvui.FormDesignVersionID,0)		 
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	 If (@dVisible<>@iVisible)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			CASE ISNULL(@dVisible,0) WHEN 0 THEN cast(i.Label as varchar(MAX)) + ' is visible ' 
		    ELSE cast(i.Label as varchar(MAX)) + ' is hidden ' END  ,
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label	, ISNULL(fdvui.FormDesignVersionID,0)	 
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	 If (@dSequence<>@iSequence)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			'Sequence for element '+ i.Label +' is changed from '+ CAST(ISNULL(d.[Sequence],0) AS VARCHAR(MAX)) + ' to '+ CAST(ISNULL(i.[Sequence],0) AS VARCHAR(MAX))  ,			
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label, ISNULL(fdvui.FormDesignVersionID,0)	 
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;
			 
	 If (@dReqValidation<>@iReqValidation)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			CASE ISNULL(@dReqValidation,0) WHEN 0 THEN ' Is Required validation is applied for element '+ i.Label 
			ELSE ' Is Required validation is removed for element '+ i.Label  END  ,
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label	, ISNULL(fdvui.FormDesignVersionID,0) 
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	 If (@dDatatype<>@iDatatype)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			'Datatype for element '+ i.Label +' is changed from ' + @dDatatype + ' to '+ @iDatatype  ,			
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy), GETDATE(), i.UIElementName, i.Label		, ISNULL(fdvui.FormDesignVersionID,0) 
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	 If (@dGeneratedName<>@iGeneratedName)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			'Generated Name for element '+ i.Label +' is changed from '+ ISNULL(d.GeneratedName,'None')  + ' to '+ ISNULL(i.GeneratedName,'None')   ,			
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label, ISNULL(fdvui.FormDesignVersionID,0)	 
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	 If (@dCheckDuplicate<>@iCheckDuplicate)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			CASE ISNULL(@dCheckDuplicate,0) WHEN 0 THEN ' Check duplicate is applied for element '+ i.Label 
		    ELSE ' Check duplicate is removed for element '+ i.Label  END  ,
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label	, ISNULL(fdvui.FormDesignVersionID,0) 
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	 If (@dAllowGlobalUpdates<>@iAllowGlobalUpdates)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			CASE ISNULL(@dAllowGlobalUpdates,0) WHEN 0 THEN ' Allow global update is applied for element '+ i.Label 
		    ELSE ' Allow global update is removed for element '+ i.Label  END  ,
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label, ISNULL(fdvui.FormDesignVersionID,0)
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	 If (@dViewType<>@iViewType)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			'Viewtype for element '+ i.Label +' is changed from '+ @dViewType + ' to '+ @iViewType ,			
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label	, ISNULL(fdvui.FormDesignVersionID,0) 
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	 If (@dExtProp <> @iExtProp)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			'Extended properties for element '+ i.Label +' is changed from '+ ISNULL(d.ExtendedProperties,'None')  + ' to '+ ISNULL(i.ExtendedProperties,'None')   ,			
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label	 , ISNULL(fdvui.FormDesignVersionID,0)
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	 If (@dIsSameSectionRuleSrc <> @iIsSameSectionRuleSrc)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			'Same section rule for element '+ i.Label +' is changed from '+ CAST((CASE ISNULL(d.IsSameSectionRuleSource,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS VARCHAR(MAX)) + ' to '+ CAST((CASE ISNULL(i.IsSameSectionRuleSource,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS VARCHAR(MAX))  ,			
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label	, ISNULL(fdvui.FormDesignVersionID,0)	 
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	 If (@dIsStandard <> @iIsStandard)
	      BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			CASE ISNULL(@dIsStandard,0) WHEN 0 THEN ' Element '+ i.Label + ' is changed to Standard element '
		    ELSE ' Element '+ i.Label + ' is changed to Non-Standard element '  END  ,
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label, ISNULL(fdvui.FormDesignVersionID,0)
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	      END;

	  If (@dHasCustomRule<>@iHasCustomRule)
	       BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			'HasChildPopup for element '+ i.Label +' is changed from '+ CAST((CASE ISNULL(d.HasCustomRule,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS VARCHAR(MAX)) + ' to '+ CAST( (CASE ISNULL(i.HasCustomRule,0) WHEN 0 THEN 'No' ELSE 'Yes' END) AS VARCHAR(MAX))  ,			
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy) , GETDATE(), i.UIElementName, i.Label , ISNULL(fdvui.FormDesignVersionID,0)
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	       END;

	  If (@dMDMName<>@iMDMName)
	       BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			'MDM Name for element '+ i.Label +' is changed from '+ ISNULL(d.MDMName,'None')  + ' to '+ ISNULL(i.MDMName,'None')   ,			
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy, i.AddedBy), GETDATE(), i.UIElementName, i.Label , ISNULL(fdvui.FormDesignVersionID,0)
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	       END;

	  If (@dHelpText<>@iHelpText)
	       BEGIN
			INSERT INTO [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
			[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
			SELECT ISNULL(i.FormID,0),ISNULL(i.UIElementID,0),		
			'Help Text for element '+ i.Label +' is changed from '+ ISNULL(d.HelpText,'None')  + ' to '+ ISNULL(i.HelpText,'None')   ,			
			i.AddedBy , i.AddedDate , ISNULL(i.UpdatedBy,i.AddedBy) , GETDATE(), i.UIElementName, i.Label , ISNULL(fdvui.FormDesignVersionID,0)
			FROM deleted d inner join inserted i ON d.UIElementID=i.UIElementID
			JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = i.UIElementID; ;
	       END;


		   --UPDATE ui.FormDesignVersionActivityLog SET UpdatedBy = (Select TOP 1 ISNULL(i.UpdatedBy,i.AddedBy) from inserted i)
		   --WHERE ActivityLoggerID = ISNULL((SELECT TOP 1 ActivityLoggerID From dbo.ActivityLogForRM),0);			
	    --   TRUNCATE TABLE dbo.ActivityLogForRM;
   End
			
			insert into [Trgr].[UIElement]
				(			UIElementID,			UIElementName,			Label,			ParentUIElementID,			IsContainer,			[Enabled],			Visible,			[Sequence],			RequiresValidation,			HelpText,			AddedBy,			AddedDate,			IsActive,			FormID,			UIElementDataTypeID,			UpdatedBy,			UpdatedDate,			HasCustomRule,			CustomRule,			GeneratedName,			DataSourceElementDisplayModeID,			CheckDuplicate,			AllowGlobalUpdates,			ViewType,			ExtendedProperties,			IsSameSectionRuleSource,			IsStandard,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			select  Inserted.UIElementID, Inserted.	UIElementName, Inserted.	Label, Inserted.	ParentUIElementID, Inserted.	IsContainer, Inserted.	[Enabled], Inserted.	Visible, Inserted.	[Sequence], Inserted.RequiresValidation, Inserted.HelpText, Inserted.	AddedBy, Inserted.	AddedDate, Inserted.	IsActive, Inserted.	FormID, Inserted.UIElementDataTypeID, Inserted.	UpdatedBy, Inserted.	UpdatedDate, Inserted.	HasCustomRule, Inserted.	CustomRule, Inserted.GeneratedName, Inserted.	DataSourceElementDisplayModeID, Inserted.CheckDuplicate, Inserted.AllowGlobalUpdates, Inserted.ViewType, Inserted.	ExtendedProperties, Inserted.IsSameSectionRuleSource, Inserted.	IsStandard, Inserted.MigrationID, Inserted.	IsMigrated, Inserted.IsMigrationOverriden, Inserted.	MigrationDate, @Operation as	DMLOperation, getdate() as	OperationDate
			from inserted
	End
End
