--EXECUTE sp_configure 'show advanced options', 1;
-- GO -- To update the currently configured value for advanced options. 
--RECONFIGURE;
-- GO -- To enable the feature.
-- EXECUTE sp_configure 'xp_cmdshell', 1; 
-- GO -- To update the currently configured value for this feature.
--  RECONFIGURE;
--  GO 

---EXEC FolderCopyADF @FolderID= 33479, @IsMasterList = 1

CREATE OR ALTER PROCEDURE FolderCopyADF(
@FolderID INT, @IsMasterList bit)--,  SQLOutput  NVARCHAR(MAX) OUT) 
AS 
	BEGIN
		IF OBJECT_ID('Temp.CreateFolder_List ') IS NOT NULL
			Begin
				Drop Table Temp.CreateFolder_List 
			End
		Create Table Temp.CreateFolder_List 
		(
		ID Int Identity(1,1) ,
		FolderID		int not null,
		IsMasterList	Bit,
		Isproceed bit Constraint DF_CreateFolder_IsProceed default(0)
		)

	
		If OBJECT_ID('Temp.FolderQuery') Is Not Null
		Begin
			Drop Table Temp.FolderQuery
		End	
Create Table Temp.FolderQuery
(
	ID Int Identity(1,1) primary key,
	FolderID Int,
	QueryType varchar(100),
	SqlQuery Nvarchar(max)
)


Declare @Folder_List table					(FolderID int Not Null,IsMasterList Bit)
Declare	@AddedBy							varchar(10)		=	'Superuser'
Declare @FolderIDCount						Int				=	0
--Declare @FolderID							Int 
Declare @FolderversionCount					Int				=	0
Declare	@FolderVersionID					Int
Declare	@ForminstanceID						Int
Declare	@ForminstanceCount					Int				=	0
Declare @sql								nvarchar(max)
Declare @FileLocation						nvarchar(max)		--=	'E:\Import\'
Declare @ServerName							varchar(50)		=	@@servername
Declare @FieldTerminator					varchar(10)		=	'	'
Declare @Formdata							nvarchar(max)
Declare	@AccountName						Varchar(200)
Declare	@FormID								Int				=	NULL
Declare	@FormName							Varchar(400)	=   NULL
Declare	@FormDesignVersionID				Int				=	NULL
Declare	@FormDesignGroupID					Int				=	NULL
Declare	@GroupName							varchar(500)	=   NULL
Declare @Effectivedate						Datetime		=	NULL
Declare @DBName								Varchar(max)	=	DB_Name()
Declare @SrcFolderVersionCount				Int				=	0
Declare @SrcForminstanceCount				Int				=	0
Declare @ForminstanceDatamapCount			Int				=	0
Declare @AccountFolderMapCount				Int				=	0
Declare @AccountProductMapCount				Int				=	0
Declare @FolderVersionWorkFlowStateCount	Int				=	0
Declare @WorkFlowStateFolderVersionMapCount	Int				=	0
Declare @WorkFlowStateUserMapCount			Int				=	0
--Declare @IsMasterList						Bit				=	0
Declare @CategoryID							Int				=   NULL
Declare @CategoryName						Varchar(400)	=	NULL
Declare @ConsortiumID						Int				=	NULL
Declare @ConsortiumName						Varchar(400)	=	NULL
Declare @FormInstancename					Varchar(200)	=	NULL
Declare @AnchorDocumentID					Int				=	NULL

--select * from Fldr.Folder where FolderID = 33479
Insert Into @Folder_List values 
(@FolderID,@IsMasterList)

Truncate Table Temp.FolderQuery
Truncate Table Temp.CreateFolder_List


	---- Inserting data into temp table from table type for further processing

	Insert Into Temp.CreateFolder_List (FolderID,IsMasterList)
	Select		FolderID ,IsMasterList
	From		@Folder_List


	Select @FolderIDCount   =	@@ROWCOUNT

	While(@FolderIDCount > 0)
	Begin

		Select Top 1 @FolderID		=	Min(FolderID )
		from		Temp.CreateFolder_List 
		Where		Isproceed		=	0

		Select		@IsMasterList	=	IsmasterList
		From		Temp.CreateFolder_List
		Where		FolderID		=	@FolderID

		Insert Into Temp.FolderQuery( FolderID , SqlQuery)
	Select						  @folderID, 'Declare @CurrentFolderID Int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						 @FolderID,'Declare @CurrentFolderVersionID int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @CurrentFormInstanceID int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @NewFormID int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @NewFormDesignVersionID int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @NewFormDesignGroupID int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @FolderVersionCount int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @ForminstanceCount int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @ForminstanceDatamapCount int = 0'

		Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @AccountFolderMapCount int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @AccountProductMapCount int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @FolderVersionWorkFlowStateCount int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @WorkFlowStateFolderVersionMapCount int = 0'

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						@FolderID,' Declare @WorkFlowStateUserMapCount int = 0'

	Insert Into Temp.FolderQuery(FolderID,Sqlquery)
	Select						 @FolderID,' Declare @Formdata nvarchar(max)'

	
	Insert Into Temp.FolderQuery(FolderID,Sqlquery)
	Select						 @FolderID,' Declare @NewUserID Int'

	Insert Into Temp.FolderQuery(FolderID,Sqlquery)
	Select						 @FolderID,' Declare @NewCategoryID Int = NULL'

	Insert Into Temp.FolderQuery(FolderID,Sqlquery)
	Select						 @FolderID,' Declare @NewConsortiumID Int = NULL'

	Insert Into Temp.FolderQuery(FolderID,Sqlquery)
	Select						 @FolderID,' Declare @NewAnchorDocumentID Int = NULL'

	Insert Into Temp.FolderQuery(FolderID,Sqlquery)
	Select						 @FolderID,' Declare @Sql Nvarchar(4000)'

	Insert Into Temp.FolderQuery(FolderID,Sqlquery)
	Select						 @FolderID,' Declare @FilePath Nvarchar(4000) = '''+@FileLocation+''''

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						 @FolderID,'Select @NewUserID	= UserID From [Sec].[User] where UserName = '''+@AddedBy+''''

	Insert Into Temp.FolderQuery(FolderID,SqlQuery)
	Select						 @folderID,'If Object_ID(''Tempdb..#FormInstancedataMap'')IS Not Null Begin Drop Table #FormInstancedataMap End '

	Insert Into Temp.FolderQuery(FolderID,Sqlquery)
	Select						 @FolderID,'Create Table #FormInstancedataMap(FormData Nvarchar(max))'

		
		-- Generate Creating New Folder script
		insert Into Temp.FolderQuery( FolderID , SqlQuery )
		Select						 @FolderID ,'Begin Try '

		insert Into Temp.FolderQuery( FolderID , SqlQuery )
		Select						 @FolderID ,'Begin Transaction'

		select @FormDesignGroupID = FormDesignGroupId From Fldr.Folder where FolderID	=	@FolderID

		
		If(@FormDesignGroupID is Not Null or @FormDesignGroupID <> '')
		Begin
				Select @GroupName	=	GroupName From UI.FormdesignGroup where FormDesignGroupID	=	@FormDesignGroupID
				

				Insert Into Temp.FolderQuery( FolderID ,QueryType, SqlQuery)
				Select						  @FolderID,
											  'NewFormdesignGroupID',
											  'Select @NewFormDesignGroupID = [dbo].[GetFormDesignGroupID]('+Quotename(@GroupName,'''')+')'

	    End

			If (@GroupName Is Null Or @GroupName ='')
			Begin
				 
				Insert Into Temp.FolderQuery( FolderID ,QueryType, SqlQuery)
				Select						  @FolderID,
											  'NewFormdesignGroupID',
											  'Set @NewFormDesignGroupID = NULL'


			End

			Insert Into Temp.FolderQuery( FolderID ,QueryType, SqlQuery)
			Select						  @FolderID, 'Folder','Insert Into Fldr.Folder(IsPortfolio,Name, MarketSegmentID,PrimaryContent,PrimaryContentID,TenantID,AddedDate,AddedBy,ParentFolderId, FormDesignGroupId,IsFoundation,MasterListFormDesignID,StateName,LineofBusiness,FundingArrangement,Region,IsPackage,FolderType,QuoteID,IsCancel,MoveQuotetoAccount)Values('+
														   CONVERT(Varchar(10), IsPortfolio ) +','''+[Name] +''','''+MarketSegmentID+''','''+
															PrimaryContent +''','+'@NewUserID'+','+CONVERT(Varchar(10),TenantID)+','''+
																CONVERT(Varchar(20),Getdate(),111)+''', '''+@AddedBy +''','+
																Convert(Varchar(10),-1)
																+','+'@NewFormDesignGroupID'+','+Convert(Varchar(10),IsFoundation)
																+','+ISNULL(CONVERT(Varchar(10),MasterListFormDesignID),'''''')
																+','''+Isnull([StateName],'') +''','''+
																Isnull([LineofBusiness],'NULL') 
																+''','''+
																ISnull([FundingArrangement],'NULL') +''','''+
																Isnull([Region],'NULL') +''','''+
																Isnull(CONVERT(Varchar(10),IsPackage),'') +''','''+
																Isnull(CONVERT(Varchar(10),FolderType),'') +''','''+
																Isnull([QuoteID],'NULL') +''','''+
																Isnull(CONVERT(Varchar(10),IsCancel),'NULL') +''','+
																Isnull(CONVERT(Varchar(10),MoveQuotetoAccount),'''') +
																
																
															  ')'
				
			From		Fldr.Folder
			Where		FolderID	=	@FolderID

		
		
		
		---- Fetch cureent FoldeID

		Insert Into Temp.FolderQuery( FolderID ,QueryType, SqlQuery)
		Select						  @folderID,'Current Folder', 'Select	@CurrentFolderID	=	IDENT_CURRENT('+QUOTENAME('Fldr.Folder','''')+')'
						
						

		--- Generate insert script for  Inserting Data into Accn.AccountFolderMap table for newly created folder

		If(@IsMasterList = 0)

		Begin
		
			select		@AccountName	=	a.AccountName
			From		accn.Account a
			Inner join	Accn.AccountFolderMap m
			On			a.AccountID		=	m.AccountID
			where		FolderID		=	@folderID
														
			Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
			Select						 @FolderID,'AccountFolderMap','Insert Into	Accn.AccountFolderMap	( FolderID, AccountID )	Select  ' + '@CurrentFolderID'+',AccountID From	accn.Account where AccountName='''+Isnull(@AccountName,'NULL')+'''	'

		End						
		---	finding Number of  FolderVersions for provided folder
				
		If OBJECT_ID('Tempdb..#FolderVersionList') IS Not Null
		Begin

			Drop Table #FolderVersionList

		End
		
		Create Table #FolderVersionList(
										FolderVersionID int	,Isproceed   Bit Default(0)
										)

		Insert Into	#FolderVersionList	(FolderVersionID )							    
		
		Select							FolderVersionID 
		From							Fldr.FolderVersion 
		Where							FolderID	=	@FolderID
		And								FolderVersionStateID in(1,3)
		--and effectiveDate='2021-01-01 00:00:00.000'

				
		Select  @FolderversionCount =	@@ROWCOUNT
		
	
	
									
		While(@FolderversionCount > 0 )
		Begin
				Select	Top 1 @FolderVersionID	=	FolderVersionID
				From		  #FolderVersionList
				Where		  Isproceed			=	0
				Order By	  FolderVersionID Asc

				Select		  @CategoryID		=	CategoryID
				From		  [fldr].[Folderversion]
				Where		  FolderVersionID	= @FolderVersionID

				Select		  @CategoryName		=	FolderVersionCategoryName
				From		  [Fldr].[FolderVersionCategory]
				Where		  FolderVersionCategoryID	=	@CategoryID

				If(@CategoryName Is Not Null Or @CategoryName <> '')
				Begin
					 Insert Into Temp.FolderQuery( FolderID ,QueryType, SqlQuery)
					Select						  @FolderID,
												  'NewCategoryID',
												  'Select  @NewCategoryID = FolderVersionCategoryID from [Fldr].[FolderVersionCategory] where FolderVersionCategoryName = '''+Isnull(@CategoryName,NULL)+''' '
				End
				Else
				Begin
					 Insert Into Temp.FolderQuery( FolderID ,QueryType, SqlQuery)
					 Select						  @FolderID,
												  'NewCategoryID',
												  'Select  @NewCategoryID =NULL'
				End

				Select		@ConsortiumID	=	ConsortiumID
				From		[Fldr].[FolderVersion]
				Where		FolderVersionID	=	@FolderVersionID

				Select		@ConsortiumName	=	ConsortiumName
				From		[Fldr].[Consortium]
				Where		ConsortiumID	=	@ConsortiumID

				If( @ConsortiumName Is Not Null or @ConsortiumName <> '' )
				Begin

					Insert Into Temp.FolderQuery( FolderID ,QueryType, SqlQuery)
					Select						  @FolderID,
												  'NewConsortiumID',
												  'Select  @NewConsortiumID = ConsortiumID from [Fldr].[Consortium] where ConsortiumName = '+Isnull(@ConsortiumName,NULL)+' '

				End
				Else
				Begin

					 Insert Into Temp.FolderQuery( FolderID ,QueryType, SqlQuery)
					 Select						  @FolderID,
												  'NewConsortiumID',
												  'Select  @NewConsortiumID =NULL'
				End

				
				---- Generate Folderversion Insert script

				Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
				Select						@FolderID,'FolderVersion','Insert Into Fldr.FolderVersion (FolderID,EffectiveDate,WFStateID,FolderVersionNumber,VersionTypeID,IsActive,TenantID,AddedDate,AddedBy,Comments,FolderVersionStateID,ConsortiumID,CategoryID) Values('+
																		 '@CurrentFolderID'+'	, '''+
																		 Convert(varchar(20 ), EffectiveDate,111)+'''	, '+
																		 Convert(varchar(10),Isnull(WFStateID,-1)) +'		, '''+
																		 FolderVersionNumber+'''					, '+
																		 Convert(varchar(10),VersionTypeID)+'	, '+
																		 Convert(varchar(10),IsActive	)+'		, '+
																		 Convert(varchar(10),TenantID	)+'		, '''+
																		 Convert(varchar(20),Getdate(),111)+'''		, '''+
																		 @AddedBy+'''								, '''+
																		 Replace(Isnull(Comments,'NULL'),'''','')+'''				, '+
																		 Convert(varchar(10),FolderVersionStateID)+','+
																		'@NewConsortiumID'+', '+
																		'@NewCategoryID'
																		+')'

		    	From	Fldr.Folderversion
				Where	FolderversionID	=	@FolderVersionID
																			
									
				---- Fetch  cureent FoldeVersionID

				Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
				Select						 @FolderID,'CurrentFolderversionID','Select	@CurrentFolderVersionID	=	IDENT_CURRENT('+QUOTENAME('Fldr.FolderVersion','''')+')'
						
		
				

				---- Finding number of forminstance for  specific folderversion


				IF OBJECT_ID('tempdb..#FormInstanceList')IS NOT NULL
				Begin
					Drop Table #FormInstanceList
				End

				CREATE TABLE #FormInstanceList (
													FormInstanceID      int ,Isproceed Bit  default(0)
											    )

				Insert Into #FormInstanceList ( FormInstanceID )
				Select							FormInstanceID  
				From		Fldr.FormInstance
				Where		FolderVersionID		=	@FolderVersionID
				
				
				Select		@ForminstanceCount	=	@@ROWCOUNT
						  

		While(@ForminstanceCount > 0)

		 Begin

					Select Top 1	@ForminstanceID	=	FormInstanceID
					From			#FormInstanceList
					Where			Isproceed		=   0

					Select	@FormID					= FormDesignID	,
							@FormInstancename		= [Name]
					From	Fldr.Forminstance 	
					Where	ForminstanceID			=	@ForminstanceID

					
					

					If(@FormID is Not Null Or @FormID <> '')
					Begin

						Select @FormName	= [dbo].[GetFormName](@FormID)

						Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
						Select						 @FolderID,
													 'NewFormID',
													 'Select @NewFormID = [dbo].[GetFormID]('+Quotename(@FormName,'''')+') '
					End

					
					Select Top 1 @Effectivedate = EffectiveDate  From Fldr.FolderVersion where FolderID = @FolderID

					Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
					Select		@FolderID,
								'NewFormdesignversionID',
								'Select @NewFormDesignVersionID = [dbo].[GetFormDesignVersionID](@NewFormID,'''+Convert(Varchar(20),@EffectiveDate,111)+''')'

					Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
					Select		@FolderID,
								'NewFormdesignversionID',
								'IF (@NewFormDesignVersionID = NULL or @NewFormDesignVersionID = '''') 
								 Begin
										RAISERROR(''Formdesign Version is not presented for given formdesign and Effectivedate  '', 16, 1);
								 End'

				---- Generate Forminstance insert Script
				
					Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
					Select						@FolderID,'Forminstance','Insert Into Fldr.FormInstance (TenantID,AddedDate ,AddedBy,FolderVersionID,FormDesignID,FormDesignVersionID,Name,IsActive,ProductJsonHash,DOCID,AnchorDocumentID,FormInstanceMapTypeId) Values( '+
																		Convert(Varchar(10),TenantID)+'  ,'''+
																		Convert(Varchar(20),GETDATE(),111)+'''  ,'''+
																		@AddedBy+'''   ,'+
																		'@CurrentFolderVersionID'+'  ,'+
																		'@NewFormID'+'  ,'+
																		'@NewFormDesignVersionID'+'  ,'''+
																		ISNULL ([Name],'NULL')+''' ,'+
																		Convert(Varchar(10),IsActive)+' ,'''+
																		Isnull(ProductJsonHash,'NULL')+''','''+
																		Convert(Varchar(10),DOCID)+''' ,'+
																		Convert(Varchar(10),AnchorDocumentID)+' ,'+
																		--Convert(Varchar(10),FormInstanceMapTypeId)+
																		ISNULL (Convert(Varchar(10),FormInstanceMapTypeId),'''''')+
																		' )'
					From	Fldr.Forminstance 
					Where	ForminstanceID	=	@ForminstanceID
				
					Select @AnchorDocumentID = AnchordocumentID From Fldr.FormInstance where FormInstanceID = @ForminstanceID
					
				---- Fetch cureent ForminstanceID
					
					If(@ForminstanceID Is Not Null Or @ForminstanceID <> '')
					Begin
				
						Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
						Select						@FolderID,'CurrentForminstance','Select	@CurrentFormInstanceID	=	IDENT_CURRENT('+QUOTENAME('Fldr.FormInstance','''')+')'

						Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
						Select						@FolderID,'DocID','Exec [dbo].[UpdateFormInstanceDocID] @CurrentFormInstanceID,'''+@FormInstancename+''''

						If (@ForminstanceID = @AnchorDocumentID)
						Begin
							
							Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
							Select				@FolderID,'AnchordocumentID','Update Fldr.Forminstance set AnchordocumentID =Isnull(@CurrentFormInstanceID,0) where FormInstanceID =@CurrentFormInstanceID '
						End
						Else
						Begin

								Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
								Select				@FolderID,'AnchordocumentID','Select @NewAnchorDocumentID = ForminstanceID from fldr.forminstance f Inner Join  UI.FormDesign fv on f.FormDesignID = fv.FormID  where [Name] = '''+@FormInstancename+''' and FolderVersionID=@CurrentFolderVersionID and  fv.FormName=''CommercialMedicalAnchor'''

								Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
								Select				@FolderID,'AnchordocumentID','Update Fldr.Forminstance set AnchordocumentID =Isnull(@NewAnchorDocumentID,0) where FolderVersionID=@CurrentFolderVersionID and ForminstanceID =@CurrentFormInstanceID'
								
						End

					End
				

				----- Generate insert query of Accn.AccountProductMap table

					Insert Into Temp.FolderQuery( FolderID,QueryType , SqlQuery)
					Select						 @FolderID,'AccountProductMap' ,'Insert Into Accn.AccountProductMap(FolderID,FolderVersionID,ProductType,ProductID,TenantID,AddedDate,AddedBy,FormInstanceID,IsActive,ServiceGroup,ProductName,PlanCode,ANOCChartPlanType,RXBenefit,SNPType,IsthisaSpecialNeedsPlan,IsthisanEmployerGroupPlan,PlanType,PackagesML) Values( '+
																		'@CurrentFolderID'+','+
																		'@CurrentFolderVersionID'+','''+
																		productType +''','''+
																		ProductID +''','+
																		Convert(Varchar(10),TenantID) +','''+
																		COnvert(varchar(20),GETDATE(),111)+''','''+
																		@AddedBy +''','+
																		'@CurrentFormInstanceID'+','+
																		Convert(Varchar(10),IsActive)+','''+
																		Isnull(ServiceGroup,'NULL')+''','''+
																		Isnull(ProductName,'NULL')	+''','''+
																		Isnull(PlanCode,'NULL')+''','''+
																		Isnull(ANOCChartPlanType,'NULL')+''','''+
																		Isnull(RXBenefit,'NULL')+''','''+
																		Isnull(SNPType,'NULL')+''','''+
																		Isnull(IsthisaSpecialNeedsPlan,'NULL')+''','''+
																		Isnull(IsthisanEmployerGroupPlan,'NULL')+''','''+
																		Isnull(PlanType,'NULL')+''','''+
																		Isnull(PackagesML,'NULL')+'''
																		)'
					From		Accn.AccountProductMap
					Where		FolderVersionID	=	@FolderVersionID
					And			ForminstanceID	=	@ForminstanceID
					
					
				---- Generate Forminstancedatamap insert script	
									
					Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
					Select						 @folderID,'Forminstancedatamap','Insert Into Fldr.FormInstanceDataMap(FormInstanceID,ObjectInstanceID,CompressJsonData) Values(	'+
												'@CurrentForminstanceID'+','+
												 Convert(Varchar(20),ObjectInstanceID)+','+
												'NULL'+')'
					From		 Fldr.FormInstanceDataMap
					Where		 FormInstanceID		=	@ForminstanceID

							

				---- Export json for forminstanceid  into text file,inserting it into temp table and update that json into forminstancedatamap table
					
			Declare @FileName varchar(20) =''+convert(varchar(30),@forminstanceID)+'.json'

			IF object_id('Temp.Formdata') IS NOT NULL
				Begin

					DROP TABLE Temp.Formdata

				End




			Select  @FileLocation = dbo.Gzip(formdata) 
			--Into	Temp.Formdata
			From	Fldr.FormInstanceDataMap 
			Where	FormInstanceID		=	@ForminstanceID



					--SELECT @sql = '"C:\Program Files\Microsoft SQL Server\110\Tools\Binn\bcp.exe" ['+ @DBName +'].Temp.Formdata out '+Concat(@FileLocation,@FileName)+' -T -c '
					--EXEC Master..Xp_CMDShell @sql 

					--set @FileLocation = (select FormData from Temp.Formdata) -- where FormInstanceID = @ForminstanceID)

					--Insert Into Temp.FolderQuery(FolderID,SqlQuery)
					--Select						 @FolderID,' IF Object_ID(''Tempdb..#FormInstancedataMap'') Is Not null
					--										Begin '+'
					--											Drop Table #FormInstancedataMap
					--										End'

					----Insert Into Temp.FolderQuery(FolderID,SqlQuery)
					----Select						 @FolderID,' Truncate Table #FormInstancedataMap '

					----Insert Into Temp.FolderQuery(FolderID,Sqlquery)
					----Select						 @FolderID,'Select @Sql=''Bulk Insert #FormInstancedataMap From ''''''+@FilePath+''\'+@FileName+''''''''

					----Insert Into Temp.FolderQuery(FolderID,Sqlquery)
					----Select						 @FolderID,'Exec SP_Executesql @sql'

					----Insert Into Temp.FolderQuery(FolderID,Sqlquery)
					----Select						 @FolderID,'Select @Formdata = dbo.Unzip(Formdata) from #FormInstancedataMap '

					Insert Into Temp.FolderQuery(FolderID,Sqlquery)
					Select						 @FolderID,'Update fi Set FormData	=	''' + dbo.Unzip(@FileLocation) +''' From Fldr.FormInstanceDataMap fi Where  fi.ForminstanceID = @CurrentForminstanceID'
						
			
			 ----- Set Isproceed flag

					Update	fl
					Set		fl.Isproceed			=	1
					From	#FormInstanceList fl
					Where	FormInstanceID			=	@ForminstanceID

				
					Set		@ForminstanceCount	    =	@ForminstanceCount - 1
					Set		@ForminstanceID			=	NULL
					Set		@FormID					=	NULL
					Set		@FormInstancename		=	NULL
					Set		@FormName				=	NULL
					Set		@AnchorDocumentID		=	NULL
					
					
		End
				

				--- Generate FolderVersionWorkFlowState insert script

				Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
				Select						@FolderID,'FolderVersionWorkflow','Insert Into fldr.FolderVersionWorkFlowState(TenantID,IsActive,AddedDate,AddedBy,FolderVersionID,WFStateID,ApprovalStatusID,Comments,UserID) Values( '+
												Convert(varchar(10),TenantID)+','+
												Convert(varchar(10),IsActive)+','''+
												Convert(varchar(20),Getdate(),111)+''','''+
												@AddedBy+''','+
												'@CurrentFolderVersionID'+','+
												Convert(Varchar(10),WFStateID)+','+
												Convert(varchar(10),ApprovalStatusID)+','''+
												Isnull(Comments,'NULL')+''','+
											   '@NewUserID'+')'
				From		 fldr.FolderVersionWorkFlowState
				Where		 FolderVersionID	=	@FolderVersionID
													
				
				--- Generate WorkFlowStateFolderVersionMap insert script
				
				Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
				Select						@FolderID,'WorkflowstateFolderVersionmap','Insert Into fldr.WorkFlowStateFolderVersionMap(ApplicableTeamID,FolderID,FolderVersionID,AddedBy,AddedDate) Values('+
									 											Convert(varchar(10),ApplicableTeamID)+','+
																				'@CurrentFolderID'+','+
																				'@CurrentFolderVersionID'+','''+
																				@AddedBy+''','''+
																				Convert(varchar(20),getdate(),111)+''')'
				From		 fldr.WorkFlowStateFolderVersionMap
				Where		 FolderVersionID	=	@FolderVersionID
				
													 
				--- Generate WorkFlowStateUserMap insert script
				
				Insert Into Temp.FolderQuery(FolderID,QueryType,SqlQuery)
				Select						@FolderID,'Workflowstateusermap','Insert Into fldr.WorkFlowStateUserMap(UserID,WFStateID,FolderID,FolderVersionID,AddedBy,AddedDate,IsActive,TenantID,ApprovedWFStateID,ApplicableTeamID) Values('+
																		  Convert(varchar(10),UserID) +','+
																		  Convert(varchar(10),WFStateID)+','+
																		  '@CurrentFolderID'+','+
																		  '@CurrentFolderVersionID'+','''+
																		  @AddedBy +''','''+
																		  Convert(varchar(20),GETDATE(),111)+''','+
																		  Convert(varchar(10),IsActive)+','+
																		  Convert(varchar(10),TenantID)+','+
																		  Convert(varchar(10),ApprovedWFStateID)+','+
																		  Convert(varchar(10),ISNULL(ApplicableTeamID,-1))+')'
				From		fldr.WorkFlowStateUserMap
				Where		FolderVersionID	=	@FolderVersionID
													 
										
				
				Update		f
				Set			f.IsProceed				=	1
				From		#FolderVersionList  f
				Where		FolderVersionID			=	@FolderVersionID

			
				Set			@FolderversionCount     =	@FolderversionCount - 1
			
		
		End

		Select  @srcFolderVersionCount				=  COunt(1)  from Fldr.FolderVersion where FolderID=	@folderID		
		Select 	@SrcForminstanceCount				=  COunt(1)  from Fldr.FormInstance where FolderVersionID In(Select Distinct FolderVersionID from Fldr.FolderVersion where FolderID	=@folderID	)				
		Select	@ForminstanceDatamapCount			=  count(1)  from Fldr.FormInstanceDataMap where FormInstanceID	In(Select Distinct FormInstanceID from Fldr.FormInstance f inner Join Fldr.FolderVersion fv On F.FolderVersionID = fv.FolderVersionID  where FolderID = @folderID)				
		Select	@AccountFolderMapCount				=  COunt(1)  from Accn.AccountFolderMap where FolderID	= @folderID	
		Select	@AccountProductMapCount				=  Count(1)  from Accn.AccountProductMap where FolderID =	@folderID
		Select	@FolderVersionWorkFlowStateCount	=  Count(1)  from fldr.FolderVersionWorkFlowState f Inner Join Fldr.FolderVersion fv on f.FolderVersionID	=	fv.FolderVersionID where FolderID	=	@folderID
		Select	@WorkFlowStateFolderVersionMapCount	=  Count(1)  from fldr.WorkFlowStateFolderVersionMap where FolderID = @folderID
		Select	@WorkFlowStateUserMapCount			=  Count(1)  from fldr.WorkFlowStateUserMap where FolderID = @folderID
					
		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,' select @FolderVersionCount = COunt(1) from Fldr.FolderVersion where FolderID=@CurrentFolderID'

		
		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,' Select @ForminstanceCount = COunt(1)  from Fldr.FormInstance where FolderVersionID In(Select Distinct FolderVersionID from Fldr.FolderVersion where FolderID = @CurrentFolderID)'
				
		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,' Select @ForminstanceDatamapCount= count(1)  from Fldr.FormInstanceDataMap where FormInstanceID	In(Select Distinct FormInstanceID from Fldr.FormInstance f inner Join Fldr.FolderVersion fv On F.FolderVersionID = fv.FolderVersionID  where FolderID = @CurrentFolderID)'

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,' select @AccountFolderMapCount= COunt(1) from Accn.AccountFolderMap where FolderID	= @CurrentFolderID'

	
		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,' select @AccountProductMapCount= Count(1) from Accn.AccountProductMap where FolderID	=	@CurrentFolderID'
		
		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,' Select @FolderVersionWorkFlowStateCount= Count(1)  from fldr.FolderVersionWorkFlowState f Inner Join Fldr.FolderVersion fv on f.FolderVersionID	=	fv.FolderVersionID where FolderID	= @CurrentFolderID'

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,' select @WorkFlowStateFolderVersionMapCount = Count(1) from fldr.WorkFlowStateFolderVersionMap where FolderID = @CurrentFolderID'
		
		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,' select @WorkFlowStateUserMapCount= Count(1)  from fldr.WorkFlowStateUserMap where FolderID = @CurrentFolderID'

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID, 'Select ''FolderVersionCount'','+Convert(Varchar(10),@srcFolderVersionCount)+' as [Source],@FolderVersionCount as Destination' 

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,'UNION'

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID, 'Select ''ForminstanceCount'','+Convert(Varchar(10),@srcForminstanceCount)+' As [Source],@ForminstanceCount as Destination' 

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,'UNION'

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID, 'Select ''ForminstanceDatamapCount'','+Convert(Varchar(10),@ForminstanceDatamapCount)+' as [Source],@ForminstanceDatamapCount as Destination' 

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,'UNION'

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID, 'Select ''AccountFolderMapCount'','+Convert(Varchar(10),@AccountFolderMapCount)+' as [Source],@AccountFolderMapCount as Destination' 

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,'UNION'

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID, 'Select ''AccountProductMapCount'','+Convert(Varchar(10),@AccountProductMapCount)+' as [Source],@AccountProductMapCount as Destination' 

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,'UNION'

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID, 'Select ''FolderVersionWorkFlowStateCount'','+Convert(Varchar(10),@FolderVersionWorkFlowStateCount)+' as [Source],@FolderVersionWorkFlowStateCount as Destination' 

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,'UNION'

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID, 'Select ''WorkFlowStateFolderVersionMapCount'','+Convert(Varchar(10),@WorkFlowStateFolderVersionMapCount)+' as [Source],@WorkFlowStateFolderVersionMapCount as Destination' 

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID,'UNION'

		Insert Into Temp.FolderQuery(FolderID , SqlQuery )
		Select						 @FolderID, 'Select ''WorkFlowStateUserMapCount'','+Convert(Varchar(10),@WorkFlowStateUserMapCount)+' as [Source],@WorkFlowStateUserMapCount as Destination' 


		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @CurrentFolderID = NULL '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @CurrentFolderVersionID = NULL '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @CurrentFormInstanceID = NULL '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @NewFormID = NULL '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @NewFormDesignVersionID = NULL '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @NewFormDesignGroupID = NULL '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @FolderVersionCount = 0 '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @ForminstanceCount = 0 '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @ForminstanceDatamapCount = 0 '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @AccountFolderMapCount = 0 '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @AccountProductMapCount = 0 '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @FolderVersionWorkFlowStateCount = 0 '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @WorkFlowStateFolderVersionMapCount = 0 '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @WorkFlowStateUserMapCount = 0 '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @Formdata = NULL '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @NewCategoryID = NULL '

		Insert Into Temp.FolderQuery(FolderID,Sqlquery)
		Select						 @FolderID,'Set @NewConsortiumID = NULL '


		Update	c
		Set		c.IsProceed			=	1
		From	Temp.CreateFolder_List c
		Where	FolderID			=	@FolderID
	


		Set	@FolderID							=	NULL
		Set	@FolderVersionID					=	NULL
		Set	@ForminstanceID						=	NULL
		Set	@Formdata							=	NULL
		Set	@FormID								=	NULL
		Set	@FormDesignGroupID					=	NULL
		Set	@FormDesignVersionID				=	NULL
		set @GroupName							=	NULL
		set	@FormName							=	NULL
		Set @SrcFolderVersionCount				=	NULL
		Set	@SrcForminstanceCount				=	NULL
		Set	@ForminstanceDatamapCount			=	NULL
		Set	@AccountFolderMapCount				=	NULL
		Set	@AccountProductMapCount				=	NULL
		Set	@FolderVersionWorkFlowStateCount	=	NULL
		Set	@WorkFlowStateFolderVersionMapCount	=	NULL
		Set	@WorkFlowStateUserMapCount			=	NULL
		Set	@IsMasterList						=	NULL


		Set	@FolderIDCount			=	@FolderIDCount	-	1




		insert Into Temp.FolderQuery( FolderID , SqlQuery )
		Select						 @FolderID ,'Commit TRANSACTION'

		insert Into Temp.FolderQuery( FolderID , SqlQuery )
		Select						 @FolderID ,'End Try '

		insert Into Temp.FolderQuery( FolderID , SqlQuery )
		Select						 @FolderID ,'Begin Catch '

		Insert Into Temp.FolderQuery(FolderID,SqlQuery)
		Select						 @folderID,'IF(@@ERROR > 0) Begin ROLLBACK TRANSACTION  End '

		Insert Into Temp.FolderQuery(FolderID,SqlQuery)
		Select						 @folderID,'SELECT  ERROR_NUMBER() AS ErrorNumber  
														,ERROR_SEVERITY() AS ErrorSeverity  
														,ERROR_LINE() AS ErrorLine  
														,ERROR_MESSAGE() AS ErrorMessage; '
															
		insert Into Temp.FolderQuery( FolderID , SqlQuery )
		Select						 @FolderID ,'End Catch '
		
		insert Into Temp.FolderQuery( FolderID , SqlQuery )
		Select						 @FolderID ,'GO'
		
	End													
			
		Update t
		Set		Sqlquery	=	Replace (Sqlquery,'-1','NULL')
		From	Temp.FolderQuery t

		Update t
		Set		Sqlquery	=	Replace (Sqlquery,'''NULL''','NULL')
		From	Temp.FolderQuery t
			
		--Select * from Temp.FolderQuery order By 1 asc
		--Select SqlQuery from Temp.FolderQuery order By id asc
							  
							
		SET @sql = '' + (SELECT DISTINCT STUFF((
                                                    SELECT ' ' + SqlQuery
                                                    FROM temp.FolderQuery  (NOLOCK)
                                                    ORDER BY ID
                                                    FOR XML PATH('')
                                                    ), 1, 1, '')
                                                ) + ''


          sELECT @sql FOR XML PATH												
															
														
															
				--select dbo.Unzip(@FileLocation) FormData

				--exec FolderCopyADF
END