CREATE PROCEDURE [RptContactTypes].[test to check routine outputs correct data in table given normal input data]
AS
BEGIN
  --Assemble 
IF object_id('RptContactTypes.Expected') IS NOT NULL
DROP TABLE RptContactTypes.Expected

CREATE TABLE RptContactTypes.Expected (
	InteractionTypeText varchar(100),
	Occurrences INT,
	TotalTimeMins int
	)

  INSERT RptContactTypes.Expected VALUES 
	('Complaint',206,78411),
	('Introduction',214,77837),
	('Meeting',190,69050),
	('Sale',202,75175),
	('Phone Call (Outbound)',188,64839)

  --Act
SELECT * INTO RptContactTypes.Actual FROM dbo.RptContactTypes

  
  --Assert
  EXEC tSQLt.AssertEqualsTable @Expected = N'RptContactTypes.Expected', -- nvarchar(max)
      @Actual = N'RptContactTypes.Actual', -- nvarchar(max)
      @FailMsg = N'The expected data was not returned.' -- nvarchar(max)
  
  
END;

