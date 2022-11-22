/*
Name:
	[UI].[SpDMLPropertyRuleMap]

Purpose:
	To maintain records for DML operation performed on table UI.[PropertyRuleMap] using CDC

Assumption:
	There must be single DML operation on table at a time

History:
	Created on  22/09/2022 by priyanka gaikwad
	Modified on ---------
*/

EXEC [UI].[SpDMLPropertyRuleMap]
CREATE OR ALTER PROC [UI].[SpDMLPropertyRuleMap]
AS
BEGIN
 SET NOCOUNT ON;
    --Local variables declaration
	DECLARE @Operation	int, @iTrgtProp VARCHAR(255), @dTrgtProp VARCHAR(255), @frmDesignVersionId int, @username nvarchar(50)
	
	--Check if records inserted, deleted or updated
	Set @Operation = (Select Top 1  __$operation From [cdc].[UI_PropertyRuleMap_CT])	

	IF @Operation = 1 -- For Delete
	BEGIN
			Insert Into [Trgr].[PropertyRuleMap]
				(			PropertyRuleMapID,			RuleID,			UIElementID,			TargetPropertyID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsCustomRule,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,					DMLOperation,				OperationDate	)
			Select  [cdc].[UI_PropertyRuleMap_CT].PropertyRuleMapID, [cdc].[UI_PropertyRuleMap_CT].	RuleID, [cdc].[UI_PropertyRuleMap_CT].UIElementID, [cdc].[UI_PropertyRuleMap_CT].	TargetPropertyID, [cdc].[UI_PropertyRuleMap_CT].	AddedBy, [cdc].[UI_PropertyRuleMap_CT].	AddedDate, [cdc].[UI_PropertyRuleMap_CT].	UpdatedBy, [cdc].[UI_PropertyRuleMap_CT].	UpdatedDate, [cdc].[UI_PropertyRuleMap_CT].	IsCustomRule, [cdc].[UI_PropertyRuleMap_CT].	MigrationID, [cdc].[UI_PropertyRuleMap_CT].	IsMigrated, [cdc].[UI_PropertyRuleMap_CT].IsMigrationOverriden, [cdc].[UI_PropertyRuleMap_CT].	MigrationDate, 4 as	DMLOperation, getdate() as	OperationDate
			From [cdc].[UI_PropertyRuleMap_CT] Where __$operation=@Operation

	END
	
	IF @operation = 2 -- For Insert
	BEGIN
					Insert Into [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
					[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
					Select ISNULL(ui.FormID,0),ISNULL(i.UIElementID,0),ui.Label + ' field added as target for '+ r.RuleName +' for ' + t.TargetPropertyName + ' rule type',
					i.AddedBy , GETDATE(), i.AddedBy , GETDATE(), ui.UIElementName, ui.Label , ISNULL(fdvui.FormDesignVersionID,0)
					From inserted i JOIN UI.UIElement ui ON ui.UIElementID=i.UIElementID
					JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
					JOIN UI.[Rule] r ON r.RuleID=i.RuleID JOIN UI.TargetProperty t ON t.TargetPropertyID=i.TargetPropertyID  ;

					UPDATE ui.FormDesignVersionActivityLog SET UIElementID = (SELECT Top 1 ISNULL(i.UIElementID,0) From inserted i INNER JOIN UI.UIElement ui ON ui.UIElementID=i.UIElementID),
					FormDesignVersionId = (SELECT Top 1 ISNULL(fdvui.FormDesignVersionID,0)
					From [cdc].[UI_PropertyRuleMap_CT] i JOIN UI.UIElement ui ON ui.UIElementID=i.UIElementID
					JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID)
					Where ActivityLoggerID = ISNULL((SELECT TOP 1 ActivityLoggerID From dbo.ActivityLogForRM),0);
					
					TRUNCATE TABLE dbo.ActivityLogForRM;
	END;

	IF @Operation = 3 -- Update Record(Need before update and after update details)
	BEGIN
					Insert Into [Trgr].[PropertyRuleMap]
						(			PropertyRuleMapID,			RuleID,			UIElementID,			TargetPropertyID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsCustomRule,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
					Select  [cdc].[UI_PropertyRuleMap_CT].PropertyRuleMapID, [cdc].[UI_PropertyRuleMap_CT].	RuleID, [cdc].[UI_PropertyRuleMap_CT].UIElementID, [cdc].[UI_PropertyRuleMap_CT].	TargetPropertyID, [cdc].[UI_PropertyRuleMap_CT].	AddedBy, [cdc].[UI_PropertyRuleMap_CT].	AddedDate, [cdc].[UI_PropertyRuleMap_CT].	UpdatedBy, [cdc].[UI_PropertyRuleMap_CT].	UpdatedDate, [cdc].[UI_PropertyRuleMap_CT].	IsCustomRule, [cdc].[UI_PropertyRuleMap_CT].	MigrationID, [cdc].[UI_PropertyRuleMap_CT].	IsMigrated, [cdc].[UI_PropertyRuleMap_CT].IsMigrationOverriden, [cdc].[UI_PropertyRuleMap_CT].	MigrationDate, 2 as	DMLOperation, getdate() as	OperationDate
					From [cdc].[UI_PropertyRuleMap_CT] Where __$operation=@Operation

					Select @dTrgtProp =ISNULL(tp.TargetPropertyName,'None') From [cdc].[UI_PropertyRuleMap_CT] d inner join UI.TargetProperty tp ON tp.TargetPropertyID=d.TargetPropertyID
					Select @iTrgtProp =ISNULL(tp.TargetPropertyName,'None') From [cdc].[UI_PropertyRuleMap_CT] i inner join UI.TargetProperty tp ON tp.TargetPropertyID=i.TargetPropertyID
					
					Insert Into [Trgr].[PropertyRuleMap]
						(			PropertyRuleMapID,			RuleID,			UIElementID,			TargetPropertyID,			AddedBy,			AddedDate,			UpdatedBy,			UpdatedDate,			IsCustomRule,			MigrationID,			IsMigrated,			IsMigrationOverriden,			MigrationDate,		DMLOperation,				OperationDate	)
					Select  [cdc].[UI_PropertyRuleMap_CT].PropertyRuleMapID, [cdc].[UI_PropertyRuleMap_CT].	RuleID, [cdc].[UI_PropertyRuleMap_CT].UIElementID, [cdc].[UI_PropertyRuleMap_CT].	TargetPropertyID, [cdc].[UI_PropertyRuleMap_CT].	AddedBy, [cdc].[UI_PropertyRuleMap_CT].	AddedDate, [cdc].[UI_PropertyRuleMap_CT].	UpdatedBy, [cdc].[UI_PropertyRuleMap_CT].	UpdatedDate, [cdc].[UI_PropertyRuleMap_CT].	IsCustomRule, [cdc].[UI_PropertyRuleMap_CT].MigrationID, [cdc].[UI_PropertyRuleMap_CT].	IsMigrated, [cdc].[UI_PropertyRuleMap_CT].IsMigrationOverriden, [cdc].[UI_PropertyRuleMap_CT].	MigrationDate, 3 as	DMLOperation, getdate() as	OperationDate
					From [cdc].[UI_PropertyRuleMap_CT] Where __$operation=@Operation+1

			 IF (@dTrgtProp<>@iTrgtProp)
				BEGIN
					Insert Into [UI].[FormDesignVersionActivityLog] ([FormDesignID], [UIElementID], [Description], 
					[AddedBy],[AddedDate],[UpdatedBy],[UpdatedLast], [UIElementName], [Label], [FormDesignVersionId])
					Select ISNULL(ui.FormID,0),ISNULL(ui.UIElementID,0),
					'Rule type changed from '+ @dTrgtProp  + ' to '+ @iTrgtProp + ' for element '+ ui.Label ,
					ISNULL(i.AddedBy, d.AddedBy) , i.AddedDate , ISNULL(i.UpdatedBy, d.UpdatedBy) , GETDATE(), ui.UIElementName, ui.Label, ISNULL(fdvui.FormDesignVersionID,0)
					From [cdc].[UI_PropertyRuleMap_CT] d inner join [cdc].[UI_PropertyRuleMap_CT] i ON d.PropertyRuleMapID=i.PropertyRuleMapID inner join UI.UIElement ui ON ui.UIElementID=d.UIElementID 
					JOIN ui.FormDesignVersionUIElementMap fdvui ON fdvui.UIElementID = ui.UIElementID
					JOIN UI.[Rule] r ON r.RuleID=i.RuleID JOIN UI.TargetProperty t ON t.TargetPropertyID=d.TargetPropertyID
				END;
	End
End 
