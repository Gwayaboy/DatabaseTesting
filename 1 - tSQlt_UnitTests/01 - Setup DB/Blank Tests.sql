EXEC tSQLt.NewTestClass @ClassName = N'ChecktSQLt' -- nvarchar(max)
GO

CREATE PROC ChecktSQLt.[test blank test] AS

GO

EXEC tSQLt.RunAll

GO
/* Run the code above, and we can see that the empty test passes,
 which is not the desired result.*/

alter PROC ChecktSQLt.[test blank test] AS

EXEC tSQLt.Fail 'My test is not yet written!'

GO

EXEC tSQLt.RunAll