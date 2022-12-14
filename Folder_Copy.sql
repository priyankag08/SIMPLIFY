Declare @CurrentFolderID Int = 0
Declare @CurrentFolderVersionID int = 0
 Declare @CurrentFormInstanceID int = 0
 Declare @NewFormID int = 0
 Declare @NewFormDesignVersionID int = 0
 Declare @NewFormDesignGroupID int = 0
 Declare @FolderVersionCount int = 0
 Declare @ForminstanceCount int = 0
 Declare @ForminstanceDatamapCount int = 0
 Declare @AccountFolderMapCount int = 0
 Declare @AccountProductMapCount int = 0
 Declare @FolderVersionWorkFlowStateCount int = 0
 Declare @WorkFlowStateFolderVersionMapCount int = 0
 Declare @WorkFlowStateUserMapCount int = 0
 Declare @Formdata nvarchar(max)
 Declare @NewUserID Int
 Declare @NewCategoryID Int = NULL
 Declare @NewConsortiumID Int = NULL
 Declare @NewAnchorDocumentID Int = NULL
 Declare @Sql Nvarchar(4000)
Select @NewUserID=UserID From [Sec].[User] where UserName = 'Superuser'
If Object_ID('Tempdb..#FormInstancedataMap')IS Not Null Begin Drop Table #FormInstancedataMap End 
Create Table #FormInstancedataMap(FormData Nvarchar(max))
Begin Try 
Begin Transaction
Set @NewFormDesignGroupID = NULL
Select @CurrentFolderID=IDENT_CURRENT('Fldr.Folder')
 select @FolderVersionCount = COunt(1) from Fldr.FolderVersion where FolderID=@CurrentFolderID
 Select @ForminstanceCount = COunt(1)  from Fldr.FormInstance where FolderVersionID In(Select Distinct FolderVersionID from Fldr.FolderVersion where FolderID = @CurrentFolderID)
 Select @ForminstanceDatamapCount= count(1)  from Fldr.FormInstanceDataMap where FormInstanceID In(Select Distinct FormInstanceID from Fldr.FormInstance f inner Join Fldr.FolderVersion fv On F.FolderVersionID = fv.FolderVersionID  where FolderID = @CurrentFolderID)
 select @AccountFolderMapCount= COunt(1) from Accn.AccountFolderMap where FolderID=@CurrentFolderID
 select @AccountProductMapCount= Count(1) from Accn.AccountProductMap where FolderID=@CurrentFolderID
 Select @FolderVersionWorkFlowStateCount= Count(1)  from fldr.FolderVersionWorkFlowState f Inner Join Fldr.FolderVersion fv on f.FolderVersionID=fv.FolderVersionID where FolderID=@CurrentFolderID
 select @WorkFlowStateFolderVersionMapCount = Count(1) from fldr.WorkFlowStateFolderVersionMap where FolderID=@CurrentFolderID
 select @WorkFlowStateUserMapCount= Count(1)  from fldr.WorkFlowStateUserMap where FolderID=@CurrentFolderID
Select 'FolderVersionCount',0 as [Source],@FolderVersionCount as Destination
UNION
Select 'ForminstanceCount',0 As [Source],@ForminstanceCount as Destination
UNION
Select 'ForminstanceDatamapCount',0 as [Source],@ForminstanceDatamapCount as Destination
UNION
Select 'AccountFolderMapCount',0 as [Source],@AccountFolderMapCount as Destination
UNION
Select 'AccountProductMapCount',0 as [Source],@AccountProductMapCount as Destination
UNION
Select 'FolderVersionWorkFlowStateCount',0 as [Source],@FolderVersionWorkFlowStateCount as Destination
UNION
Select 'WorkFlowStateFolderVersionMapCount',0 as [Source],@WorkFlowStateFolderVersionMapCount as Destination
UNION
Select 'WorkFlowStateUserMapCount',0 as [Source],@WorkFlowStateUserMapCount as Destination
Set @CurrentFolderID = NULL 
Set @CurrentFolderVersionID = NULL 
Set @CurrentFormInstanceID = NULL 
Set @NewFormID = NULL 
Set @NewFormDesignVersionID = NULL 
Set @NewFormDesignGroupID = NULL 
Set @FolderVersionCount = 0 
Set @ForminstanceCount = 0 
Set @ForminstanceDatamapCount = 0 
Set @AccountFolderMapCount = 0 
Set @AccountProductMapCount = 0 
Set @FolderVersionWorkFlowStateCount = 0 
Set @WorkFlowStateFolderVersionMapCount = 0 
Set @WorkFlowStateUserMapCount = 0 
Set @Formdata = NULL 
Set @NewCategoryID = NULL 
Set @NewConsortiumID = NULL 
Commit TRANSACTION
End Try 
Begin Catch 
IF(@@ERROR > 0) Begin ROLLBACK TRANSACTION  End 
SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_SEVERITY() AS ErrorSeverity,ERROR_LINE() AS ErrorLine,ERROR_MESSAGE() AS ErrorMessage;
End Catch 
