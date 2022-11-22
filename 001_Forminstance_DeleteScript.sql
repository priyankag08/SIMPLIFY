
--- Delete data from all related tables of given ForminstanceID

declare @ForminstanceIDList Table (ForminstanceID Int)

Insert into @ForminstanceIDList (ForminstanceID) 
select fi.forminstanceid
from fldr.folder f
Inner join fldr.FolderVersion fv on f.folderid=fv.folderid
inner join fldr.forminstance fi on fv.folderversionid=fi.folderversionid
Inner join ui.formdesign fd on fd.formid=fi.formdesignid
where fd.DisplayText in(
'Cost Shares'
)
if exists ( select 1 from @ForminstanceIDList )

BEGIN TRY

	BEGIN TRANSACTION

			--- delete Data from fldr.FormInstanceActivityLog
			 
				delete		a
				from		fldr.FormInstanceActivityLog a 
				Where		a.FormInstanceID	in (select FormInstanceID from @ForminstanceIDList	)

			---delete Data  from Fldr.FormInstanceDataMap

				delete 		from		Fldr.FormInstanceDataMap 
				where		FormInstanceID	 in (select FormInstanceID from @ForminstanceIDList	)

			---delete Data from [Accn].[AccountProductMap]

				delete from [Accn].[AccountProductMap] 
				where		ForminstanceID		 in (select ForminstanceID from @ForminstanceIDList	)


		  

			---delete Data from  fldr.Journal

				delete from	 fldr.Journal 
				where		 ForminstanceID	in (select ForminstanceID from @ForminstanceIDList	)   

			---delete Data from [Fldr].[FormInstanceViewImpactLog]

				delete from [Fldr].[FormInstanceViewImpactLog] 
				where		ForminstanceID		in (select ForminstanceID from @ForminstanceIDList	) 
																		
			---delete Data from [Fldr].[FormInstance]

				delete from [Fldr].[FormInstance] 
				where		ForminstanceID		in (select ForminstanceID from @ForminstanceIDList	) 
				  
	

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
		
			IF @@ERROR > 0  
				Begin
					-- added to check if any delete satatement gets error out then rollback all transaction
					 ROLLBACK TRANSACTION;
				End

				
				SELECT  ERROR_NUMBER() AS ErrorNumber  
					   ,ERROR_SEVERITY() AS ErrorSeverity  
					   ,ERROR_LINE() AS ErrorLine  
					   ,ERROR_MESSAGE() AS ErrorMessage;  
		
END CATCH