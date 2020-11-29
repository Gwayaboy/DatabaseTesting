ALTER VIEW [dbo].[RptContactTypes] AS
SELECT  IT.InteractionTypeText,
		COUNT(*) Occurrences,
		SUM(DATEDIFF(MI,InteractionStartDT,InteractionEndDT)) TotalTimeMins
 FROM dbo.Interaction I 
 INNER JOIN dbo.InteractionType IT 
	ON IT.InteractionTypeID = I.InteractionTypeID
GROUP BY IT.InteractionTypeText

