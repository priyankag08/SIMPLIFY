USE [eBS4_INT_QA2]
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_QueuedFailed_Record]    Script Date: 7/21/2022 1:14:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER procedure [dbo].[SP_Get_QueuedFailed_Record]
as
SELECT TOP 1 * FROM DesignSyncProcessQueue WHERE (QueueStatus = 1) OR (QueueStatus = 4 AND IsRequeued = 1)


select * from [dbo].[DesignSyncProcessQueue]