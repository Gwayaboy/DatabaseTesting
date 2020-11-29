/* This script is not needed if you are following the steps in the module with SQL Test,
but if you do not have SQL Test installed then this script creates the test class used in the demos 

Note that this will remove any tests already in this class, if it exists!
*/
EXEC tSQLt.NewTestClass @ClassName = N'ChecktSQLt' -- nvarchar(max)
GO
