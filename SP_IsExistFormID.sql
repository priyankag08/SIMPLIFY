USE [eBS4_INT_QA2]
GO
/****** Object:  StoredProcedure [dbo].[SP_IsExistFormID]    Script Date: 9/22/2022 6:10:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER   proc [dbo].[SP_IsExistFormID] (@FID int)
as
begin
declare @flag int
if exists (select FormID from UI.FormDesign where FormID=@FID)
begin
    set @flag = 1
end
else
begin
    set @flag = 0
end



select @flag



end