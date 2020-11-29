# Database Testing: tSQLt unit testing and Azure DevOps

Please [view and download ](https://github.com/Gwayaboy/DatabaseTesting/blob/main/0%20-%20Content/DatabateTestingWorkshop.pdf) Slide deck

## Agenda

1. **SQL Server Testing**
    - Core Concepts
    - SSMS, tSQLt & additional tooling
2. **Azure Pipeline Integration**
    - Understanding CI/CD Flow for SQL Automated SQL Server tests
    - Azure Pipeline Demo


## Module 1: SQL Server Testing with tSQLT

  ### Pre-requisites
    
1. Local or remote (on Azure VM or on-premises) access to a SQL Server instance with administrator rights  
2. [SQL Server Management Studio (SSMS)](https://aka.ms/ssmsfullsetup)    
3. [Git Bash](https://git-scm.com/download/win) and (optionally) [  Redgate's sql tool belt 28 day trial version ](https://www.red-gate.com/products/sql-development/sql-test/trial/) for SSMS (choose SQL Test & SQL Source control)

  #### Exercise 1: Implementing your first tSQLt unit test

  1. Clone this repository to get you started using gitbash or redgate's SQL Source Control at https://github.com/Gwayaboy/DatabaseTesting.git to your local dev folder (for example ```C:\dev```)
      - Click on the "Clone or download" button
      - Clone the repository direclty with SSMS and  SQL Source Control       
        or
      - (If you have git bash) navigate to your local dev folder (```cd /c/dev/```), copy and execute execute the following command :
        ```bash        
        git clone https://github.com/Gwayaboy/DatabaseTesting.git
        ```        
      - Alternatively [download as a zip file](https://github.com/Gwayaboy/DatabaseTesting/archive/main.zip) to your local drive 

  2. Set up customer management database
        
        From you local dev folder go to ```\DatabaseTesting\1 - tSQlt_UnitTests\01 - Setup DB```, open and execute the following scripts:

        - [Database Setup.sql](https://github.com/Gwayaboy/DatabaseTesting/blob/main/1%20-%20tSQlt_UnitTests/01%20-%20Setup%20DB/Database%20Setup.sql)
        - [Populate Data.sql](https://github.com/Gwayaboy/DatabaseTesting/blob/main/1%20-%20tSQlt_UnitTests/01%20-%20Setup%20DB/Populate%20Data.sql)
    
  3. Install tSQLt on customer management database
        - Download and unzip [latest tSQLt release (tSQLt_V1.0.7597.5637)](http://tsqlt.org/download/tsqlt/)
        - Open and run PrepareServer.sql and tSQLt.class to install tSQLt against your CustomerManagement Database 

  4. Our requirement is to Report contacts and avegare duration
        ```Gherkin            
            Feature: Prioritise customer engagements
                As a Business Analyst 
                I want to be able to report on number of contacts and duration 
                So that I can generate average (mean) contact time and prioritise customer engagement appropriately

            Scenario: Report for each contact type how many contacts and duration 

            Example Output:
                | InteractionType | Occurence | TotalTimeinMinutes | 
                |-----------------|-----------|--------------------|
                | Meeting         | 150       | 500000             | 
                | Introduction    | 200       | 20450              | 
                | Phone Call      | 200       | 20450              | 
        ```

        We will need to create a view that aggregates the data as above 

  5. First let's write a failing testto check the RptContactTypes view exists.
        
        a) Let's create our ```RptContactTypes``` TestClass with our first ```[test to check RptContactTypes exists]```
                
    
        - With SQL Test
        
            Select Customer management, right click and select new Test
        ![](https://demosta.blob.core.windows.net/images/CreatetSQLtTestWithSQLTest.png)

        Or
        - in SSMS directly type and execute the following statement:
            ```TSQL
                EXEC tSQLt.NewTestClass @ClassName = N'RptContactTypes' 
                GO
                CREATE PROCEDURE [RptContactTypes].[test to check RptContactTypes exists]
                AS
                BEGIN
                    --Assemble

                    --Act
                    
                    --Assert            
                    EXEC tSQLt.Fail 'Not implemented yet'
                END;    
            ```

        - You will in  either case have procedure squeletton as above
        - _Please note our test name include the name of database object under test._
        
        - _Each test name starts with test as a tSQLt naming convention for discovering new tests_

        b) Let's alter our test and add our assertion to check  RptContactTypes objects exists with
            
        ```TSQL
            ALTER PROCEDURE  [RptContactTypes].[test to check RptContactTypes exists]     
            AS
            BEGIN                      
                --Assert
                EXEC tSQLt.AssertObjectExists @ObjectName = N'dbo.RptContactTypes', 
                    @Message = N'The object dbo.RptContactTypes does not exist.' 
            END;  
        ```
        c) submit procedure changes and execute the test with SQL Test or by typing and executingt in SSMS
        
        ```TSQL
        EXEC tSQLt.Run '[RptContactTypes].[test to check    RptContactTypes exists]'
        ```

        d) We have a failing specification which we are going to statisfy by creating the simplest View

        ```TSQL
        CREATE VIEW dbo.RptContactTypes AS
        SELECT '' AS InteractionTypeText,
            0 AS Occurrences,
            0 AS TotalTimeMins

        GO	 
        ``` 
        e) create the view and run the same test which should pass now.

        ![](https://demosta.blob.core.windows.net/images/FirstPassingTest.PNG)           
    
  6. Let's build on a more useful test that will go through the followings steps

        - Data table to be returned
        - Expected set of data
        - Capture output of object under test
        - Assert they are the same
        - Verify our assertion are met

        a) following on steps 5. a) & b) create a new ```[test to check routine outputs correct data in table given normal input data]``` in the same ```RptContactTypes``` TestClass 

        b) In the assemble or arrange section, Let's create a table to hold the expected data
        
        _PLease note that each test runs in own transaction so any object_

        ```TSQL
        --Assemble
        IF object_id('RptContactTypes.Expected') IS NOT NULL
        DROP TABLE RptContactTypes.Expected

        CREATE TABLE RptContactTypes.Expected 
        (
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
        ```

        c) Next we will specify in the Act section the data will be retrieving from our actual view

        ```TSQL
        --Act
        SELECT * INTO RptContactTypes.Actual FROM dbo.RptContactTypes

        ```

        





            





