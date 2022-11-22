
Declare	    @Count					Int =	0
Declare		@FormVersionIDCount		Int	=	0
Declare		@FormDesignVersionID	Varchar(max)
Declare		@M						Nvarchar(max)

declare		@FormDesignVersionIDList	Table (	FormDesignID		Int  NULL, FormDesignVersionID Int  NULL	 )
declare		@ForminstanceVersionIDList	Table (	FormDesignVersionID Int  NULL	 )
declare     @formdesignid1  int
--declare     @formdesignid2  int
--declare     @formdesignid3  int
--declare     @formdesignid4  int
--declare     @formdesignid5  int
--declare     @formdesignid6  int
--declare     @formdesignid7  int
--declare     @formdesignid8  int
--declare     @formdesignid9  int
--declare     @formdesignid10  int





set @formdesignid1=(select min(formid)from ui.FormDesign where FormName='CostShares')
--set @formdesignid2=(select min(formid) from ui.FormDesign where FormName='SystemConfiguration')
--set @formdesignid3=(select min(formid) from ui.FormDesign where FormName='States')
--set @formdesignid4=(select min(formid) from ui.FormDesign where FormName='StandardServices')
--set @formdesignid5=(select min(formid) from ui.FormDesign where FormName='Limits')
--set @formdesignid6=(select min(formid) from ui.FormDesign where FormName='Services')
--set @formdesignid7=(select min(formid) from ui.FormDesign where FormName='Networks')
--set @formdesignid8=(select min(formid) from ui.FormDesign where FormName='QHP')
--set @formdesignid9=(select min(formid) from ui.FormDesign where FormName='CostShares')
--set @formdesignid10=(select min(formid) from ui.FormDesign where FormName='CommercialCOB')



-- if we want to delete whole form design with thier version then we need to pass formdesignid and set formdesignversionid as null
-- if we want to delete only formdesign version not form design then we need to pass only formdesignversionid and set formdesignid as null

Insert Into @FormDesignVersionIDList	   (	FormDesignID,FormDesignVersionID) values (@formdesignid1, NULL	 )
--Insert Into @FormDesignVersionIDList	   (	FormDesignID,FormDesignVersionID) values (@formdesignid2, NULL	 )
--Insert Into @FormDesignVersionIDList	   (	FormDesignID,FormDesignVersionID) values (@formdesignid3, NULL	 )
--Insert Into @FormDesignVersionIDList	   (	FormDesignID,FormDesignVersionID) values (@formdesignid4, NULL	 )
--Insert Into @FormDesignVersionIDList	   (	FormDesignID,FormDesignVersionID) values (@formdesignid5, NULL	 )
--Insert Into @FormDesignVersionIDList	   (	FormDesignID,FormDesignVersionID) values (@formdesignid6, NULL	 )
--Insert Into @FormDesignVersionIDList	   (	FormDesignID,FormDesignVersionID) values (@formdesignid7, NULL	 )
--Insert Into @FormDesignVersionIDList	   (	FormDesignID,FormDesignVersionID) values (@formdesignid8, NULL	 )
--Insert Into @FormDesignVersionIDList	   (	FormDesignID,FormDesignVersionID) values (@formdesignid9, NULL	 )
--Insert Into @FormDesignVersionIDList	   (	FormDesignID,FormDesignVersionID) values (@formdesignid10, NULL	 )






BEGIN TRY

	BEGIN TRANSACTION

			-- if we provide formid as well as formdesignversionID then do not perform anything

			If Exists( Select 1 From @FormDesignVersionIDList Where FormDesignID IS NOT NULL And FormDesignVersionID IS NOT NULL)

			BEGIN
				
				RAISERROR('Please Provide Either FormDesignID or FormDesignVersionID', 16, 1);

			END
			
			if exists ( select 1 from @FormDesignVersionIDList  where (FormDesignID IS NOT NULL) OR (FormDesignVersionID IS NOT NULL))

			Begin

				Truncate Table Temp.FormVersionList
				
				---Insert only those FormDesignVersionID data into temp table when we wanted to delete only formdesign Version not Formdesign

				Insert Into			Temp.FormVersionList(FormdesignID	, FormDesignVersionID    , UIElementID   ,RuleID  )
				Select	Distinct						 fv.FormDesignID, fv.FormDesignVersionID , f.UIElementID ,p.RuleID
				From				@FormDesignVersionIDList		 fv
				Inner Join			UI.FormDesignVersionUIElementMap f
				On					fv.FormdesignVersionID	= f.FormdesignversionID
				Left Join			UI.PropertyRuleMap				 p
				On					f.UIElementID			=	p.UIElementID
				Where				fv.FormDesignVersionID	is not null 


		    	---Here we insert FormDesign Version data into temp table when we wanted to delete  formdesign Version as well as their Formdesign

				Insert Into			Temp.FormVersionList( FormdesignID	 , FormDesignVersionID   , UIElementID    , RuleID  )
				Select Distinct							  fv.FormdesignID, f.FormDesignVersionID , fd.UIElementID , p.RuleID
				From				UI.FormDesignVersion		f
				Inner join			@FormDesignVersionIDList	fv
				On					f.FormDesignID			=	fv.FormDesignID
				Inner Join			UI.FormDesignVersionUIElementMap fd
				On					f.FormDesignVersionID	=	fd.FormDesignVersionID
				Left Join			UI.PropertyRuleMap			p
				On					fd.UIElementID			=	p.UIElementID
				Where				fv.FormDesignVersionID	Is NULL

			
				---Check if any formdesignversionID is present in fldr.forminstance (It Means that FormdesignVersionID is used in any folder version)
				
				Insert Into @ForminstanceVersionIDList(FormDesignVersionID)
				Select		Distinct				   f.FormDesignVersionID
				From		Temp.FormVersionList f
				Inner Join	Fldr.FormInstance	 fi
				On			f.FormDesignVersionID	=	fi.FormDesignVersionID

				Set	@Count	=	@@ROWCOUNT

			
				--- If any formdesignversionID is present in fldr.forminstance then we are not deleting any data releted to that formdesignversionID
				
				Delete		f
				From		Temp.FormVersionList f
				Inner Join	@ForminstanceVersionIDList fv
				On			f.FormDesignVersionID	=	fv.FormDesignVersionID

				
				Select @FormVersionIDCount	=	Count(1)
				From   Temp.FormVersionList
				
				
			
				IF(@FormVersionIDCount > 0)

				Begin

				---- once we get data for provided form design version then started deleting from below table for that version

						Delete		v
						From		UI.Validator			v
						Inner Join  Temp.FormVersionList	f
						on			v.UIElementID	=	f.UIElementID

						Delete		p
						From		UI.PropertyRuleMap   p
						Inner Join  Temp.FormVersionList f
						On			p.UIElementID	=	f.UIElementID
						And			p.RuleID		=	f.RuleID

				
						Delete		 a
						From		UI.AlternateUIElementLabel	a
						Inner Join  Temp.FormVersionList		f
						On			a.FormDesignVersionID			=	f.FormDesignVersionID

						Delete		 c
						From		UI.CalendarUIElement	c
						Inner Join  Temp.FormVersionList	f
						On			c.UIElementID			=	f.UIElementID


						Delete		 c
						From		UI.CheckBoxUIElement	c
						Inner Join  Temp.FormVersionList	f
						On			c.UIElementID			=	f.UIElementID

						Delete		 d
						From		UI.DropDownElementItem	d
						Inner Join  Temp.FormVersionList f
						On			d.UIElementID			=	f.UIElementID

						Delete		 d
						From		UI.DropDownUIElement	d
						Inner Join  Temp.FormVersionList	f
						On			d.UIElementID			=	f.UIElementID

						Delete		 r
						From		UI.RepeaterKeyUIElement	r
						Inner Join  Temp.FormVersionList	f
						On			r.UIElementID	=	f.UIElementID

						Delete		 r
						From		UI.RepeaterUIElement	r
						Inner Join  Temp.FormVersionList	f
						On			r.UIElementID			=	f.UIElementID

						Delete		 s
						From		UI.SectionUIElement		s
						Inner Join  Temp.FormVersionList	f
						On			s.UIElementID			=	f.UIElementID

						Delete		 t
						From		UI.TabUIElement			t
						Inner Join  Temp.FormVersionList	f
						On			t.UIElementID			=	f.UIElementID

						Delete		 t
						From		UI.TextBoxUIElement		t
						Inner Join  Temp.FormVersionList	f
						On			t.UIElementID			=	f.UIElementID

						Delete		 t
						From		UI.RadioButtonUIElement	t
						Inner Join  Temp.FormVersionList	f
						On			t.UIElementID			=	f.UIElementID

						Delete		 d
						From		UI.FormDesignVersionUIElementMap	d
						Inner Join  Temp.FormVersionList				f
						On			d.FormDesignVersionID	=	f.FormDesignVersionID

						
						Delete		d
						From		UI.DataSourceMapping	d
						Inner Join  Temp.FormVersionList	f
						On			d.FormDesignVersionID	=	f.FormDesignVersionID
						And			d.UIElementID			=	f.UIElementID
						Where	    f.FormDesignID			Is NULL
						

												
						Delete		d
						From		UI.DataSourceMapping	d
						Inner Join  Temp.FormVersionList	f
						On			d.FormDesignID	=	f.FormDesignID
						Where	    f.FormDesignID			Is Not NULL

						delete from UI.DataSourceMapping where datasourceid in(
						select d.datasourceid
						From		UI.DataSource	d
						Inner Join  Temp.FormVersionList	f
						On			d.FormDesignID			=	f.FormDesignID
						Where	    f.FormDesignID			Is Not NULL)
						


						Delete		d
						From		UI.DataSource	d
						Inner Join  Temp.FormVersionList	f
						On			d.FormDesignID			=	f.FormDesignID
						Where	    f.FormDesignID			Is Not NULL
						

						;With cteDocumentRule as
							( 
								Select		DocumentRuleID	
								From		UI.DocumentRule		    d
								Inner Join  Temp.FormVersionList	f
								On			d.FormDesignVersionID	=	f.FormDesignVersionID
								
							)
						
						Delete		d
						From		UI.DocumentRuleEventMap d
						Inner Join	cteDocumentRule c
						On			d.DocumentRuleID	=	c.DocumentRuleID	

						Delete		d
						From		UI.DocumentRule d
						Inner Join  Temp.FormVersionList	f
						On			d.FormDesignVersionID	=	f.FormDesignVersionID
						

						Delete		u
						From		sec.UserClaim  u
						Inner Join  Temp.FormVersionList	f
						On			u.ResourceID			=	f.UIElementID
						
						Delete		 u
						From		Rpt.FormDesignDataPath			u
						Inner Join  Temp.FormVersionList	f
						On			u.FormDesignVersionID	=	f.FormDesignVersionID

						Delete		 u
						From		ML.MasterListCascadeDocumentRule u
						Inner Join  Temp.FormVersionList	f
						On			u.TargetUIElementID		=	f.UIElementID

						Delete		u
						From		TmplRpt.TemplateReportFormDesignVersionMap u
						Inner join	Temp.FormVersionList	f
						on			u.FormDesignVersionID	=	f.FormDesignVersionID

						---Added on 0622
						Delete		u
						From		UI.FormDesignVersionTemplate u
						Inner join	Temp.FormVersionList	f
						on			u.FormDesignVersionID	=	f.FormDesignVersionID
						
						Delete		 u
						From		UI.UIElement			u
						Inner Join  Temp.FormVersionList	f
						On			u.UIElementID			=	f.UIElementID
		
						Delete		d
						From		UI.FormDesignVersion	d
						Inner Join  Temp.FormVersionList	f
						On			d.FormDesignVersionID	=	f.FormDesignVersionID

						
			
				END

				Set	@FormVersionIDCount	=	0
			
			End
			
		
			--- We check if form design id is not null means we wanted to delete form design 
	

			If Exists(select 1 from @FormDesignVersionIDList f Inner Join Temp.FormVersionList t on f.FormDesignID	=	t.FormDesignID
					   where f.FormDesignID is NOT NULL)

			Begin
				
			--	--- If data found for deleteing formdesign then delete record from below table

				IF Object_ID('Tempdb..#FormDesignGroupData')Is Not Null
				Begin
					Drop Table #FormDesignGroupData
				End

				Select		FormID , FormDesignGroupID 
				Into		#FormDesignGroupData 
				From		UI.FormDesignGroupMapping f
				Inner Join	Temp.FormVersionList		fv
				On			f.FormID	=	fv.FormDesignID
				Where		fv.FormDesignID	Is Not Null

				Delete		f 
				From		UI.FormDesignGroupMapping	f
				Inner Join	Temp.FormVersionList		fv
				On			f.FormID	=	fv.FormDesignID
				Where		fv.FormDesignID	Is Not Null

				Delete		f 
				From		UI.[Rule]	f
				Inner Join	Temp.FormVersionList		fv
				On			f.FormDesignID	=	fv.FormDesignID
				Where		fv.FormDesignID	Is Not Null


				--Delete		f 
				--From		UI.FormDesignGroup	f
				--Inner Join	#FormDesignGroupData		fv
				--On			f.FormDesignGroupID	=	fv.FormDesignGroupID
					
					--select * from 	UI.AlternateUIElementLabel where formdesignid in(2384,2441,2443,2536)	

						Delete f
					from UI.AlternateUIElementLabel    f
					Inner Join Temp.FormVersionList		fv
					On 			f.FormDesignID	=	fv.FormDesignID
				       Where		fv.FormDesignID	Is Not Null

				Delete		f
				From		UI.FormDesign				f
				Inner Join	Temp.FormVersionList		fv
				On			f.FormID	=	fv.FormDesignID
				Where		fv.FormDesignID	Is Not Null

			End

			--- display error message if Form version id is present in any folder version
			IF(@Count	> 0)

				Begin
								
						Set		 @M	=	'Cannot Delete FormdesignVersion Which are used by any Folder Version '
						Select   @M as Message, FormDesignVersionID From @ForminstanceVersionIDList
								

				End


				Set @Count				=	0
				set @FormVersionIDCount =   0

		-- commit only if all transactions are executed without any error
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



