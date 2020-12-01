# Database Testing: tSQLt unit testing and Azure DevOps

Please [view and download ](https://github.com/Gwayaboy/DatabaseTesting/blob/main/0%20-%20Content/DatabateTestingWorkshop.pdf) Slide deck

## Agenda

1. **SQL Server Testing**
    - Core Concepts
    - SSMS, tSQLt & additional tooling
2. **Azure Pipeline Integration**
    - Understanding CI/CD Flow for SQL Automated SQL Server tests
    - Azure Pipeline Demo


## Module 1: SQL Server Testing with tSQLt

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
        
    
  3. Install tSQLt on customer management database
        - Download and unzip [latest tSQLt release (tSQLt_V1.0.7597.5637)](http://tsqlt.org/download/tsqlt/)
        - Open and run PrepareServer.sql and tSQLt.class to install tSQLt against your CustomerManagement Database 

  4. Our requirement is to Report contacts frequenct and their average duration
        ```Gherkin            
            Feature: Prioritise customer engagements
                As a Business Analyst 
                I want to be able to report on number of contacts and duration 
                So that I can generate average (mean) contact time and prioritise customer engagement appropriately

            Scenario: Report for each contact type how many contacts and duration 

            Example Output:
                | InteractionType | Occurences | TotalTimeinMinutes | 
                |-----------------|------------|--------------------|
                | Meeting         | 150        | 500000             | 
                | Introduction    | 200        | 20450              | 
                | Phone Call      | 200        | 20450              | 
        ```

        We will need to create a view that aggregates the data as above 

  5. First let's write a failing test to check the RptContactTypes view exists.
        
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
        SELECT '' AS InteractionType,
            0 AS Occurrences,
            0 AS TotalTimeInMinutes

        GO	 
        ``` 
        e) create the view and run the same test which should pass now.

        ![](https://demosta.blob.core.windows.net/images/FirstPassingTest.PNG)           

#### Exercise 2: Implementing another tSQLt unit test
    
  1. Let's build on a more useful test that will go through the followings steps

        - Data table to be returned
        - Expected set of data
        - Capture output of object under test
        - Assert they are the same
        - Verify our assertion are met

        a) following on steps 5. a) & b) create a new ```[test to check routine outputs correct data in table given normal input data]``` in the same ```RptContactTypes``` TestClass 

        b) In the assemble or arrange section, Let's create a fake ```InteractionType``` and ```Interaction```  tables to hold the expected data 
        
        Although there's no data in the Customer Management we are still isolating test data with ```tSQLt.FakeTable```
        
        _PLease note that each test runs in own transaction so any object created will be rollbacked_
        

        ```TSQL
        --Assemble        

        EXEC tSQLt.FakeTable @TableName = N'dbo.InteractionType'
  
        EXEC tSQLt.FakeTable @TableName = N'dbo.Interaction'
            
        INSERT dbo.InteractionType
                ( InteractionTypeID, InteractionTypeText )
        VALUES	 (1,'Introduction'),
                (2,'Phone Call (Outbound)'),
                (3,'Complaint'),
                (4,'Sale'),
                (5,'Meeting')

        INSERT dbo.Interaction
                (InteractionTypeID,
                InteractionStartDT,
                InteractionEndDT)
        VALUES  ( 
                5 , -- Meeting
                CONVERT(DATETIME,'2013-01-03 09:00:00',120),
                CONVERT(DATETIME,'2013-01-03 09:30:00',120) 
                )
                ,( 
                5 , -- Meeting
                CONVERT(DATETIME,'2013-01-02 09:00:00',120),
                CONVERT(DATETIME,'2013-01-02 10:30:00',120) 
                )
                ,( 
                2 , -- Phone Call (Outbound)
                CONVERT(DATETIME,'2013-01-03 09:01:00',120),
                CONVERT(DATETIME,'2013-01-03 09:13:00',120) 
                )
                
        IF object_id('RptContactTypes.Expected') IS NOT NULL
        DROP TABLE RptContactTypes.Expected
        
        CREATE TABLE RptContactTypes.Expected (
        InteractionType varchar(100),
        Occurrences INT,
        TotalTimeInMinutes int
        )

        INSERT RptContactTypes.Expected VALUES 
        ('Meeting',2,120), 
        ('Phone Call (Outbound)',1,12)
        ```

        c) Next we will specify in the Act section the data will be retrieving from our actual view

        ```TSQL
        --Act
        SELECT * INTO RptContactTypes.Actual FROM dbo.RptContactTypes

        ```

        d) Lastly let's assert both expected and actual data are the same

        ```TSQL
        --Assert
        EXEC tSQLt.AssertEqualsTable 
            @Expected = N'RptContactTypes.Expected', 
            @Actual = N'RptContactTypes.Actual', 
            @FailMsg = N'The expected data was not returned.' 

        ```

        e) Update the test SP and run both tests in the ```RptContactTypes``` TestClass
        
         
        ```TSQL
        EXEC tSQLt.Run '[RptContactTypes]'
        ```

        Our first test will still pass while our second will fail as expected as we need to implement our view. 

        **To avoid false negative, please make sure your test fails for the expected reasons with a similar message below**

        ```TSQL        
        [RptContactTypes].[test to check routine outputs correct data in table given normal input data] failed: (Failure) 
        The expected data was not returned.
        |_m_|InteractionType      |Occurrences|TotalTimeInMinutes|
        +---+---------------------+-----------+------------------+
        |<  |Meeting              |2          |120               |
        |<  |Phone Call (Outbound)|1          |12                |
        |>  |                     |0          |0                 |
        ``` 

        f) Let's alter our view with the following query to satisfy our tests

        ```TSQL
        ALTER VIEW [dbo].[RptContactTypes] AS
        SELECT  IT.InteractionTypeText AS InteractionType,
                COUNT(*) Occurrences,
                SUM(DATEDIFF(MI,InteractionStartDT,InteractionEndDT)) TotalTimeInMinutes
        FROM dbo.Interaction I 
        INNER JOIN dbo.InteractionType IT 
            ON IT.InteractionTypeID = I.InteractionTypeID
        GROUP BY IT.InteractionTypeText

        ```

        d) Run both tests in the ```RptContactTypes``` TestClass which now should both pass

        ```TSQL
        EXEC tSQLt.Run '[RptContactTypes]'
        ```

        e) We should bewriting additional tests  to check additional all scenarios such as no data in interaction table.
        For brievity we won't write these additional tests within  ```RptContactTypes``` TestClass, but we can expect the Assemble section of these tests to be following the same common steps:
          - Create Fake InteractionType & Interaction Tables
          - Create Expected data table structure

        **Conveniently tSQLt supports a set up routine that will be run before each test within the a Testclass**


        the setup stored procedure encourages us to refactor our tests to increase readibility and allowing test to focus on relevant arrange.
        
        In our case the SetUp stored procedure will look as below:

        ```TSQL
        CREATE PROCEDURE RptContactTypes.SetUp AS

        --Isolate from the Interaction and InteractionType tables:
        EXEC tSQLt.FakeTable @TableName = N'dbo.InteractionType'
        
        EXEC tSQLt.FakeTable @TableName = N'dbo.Interaction'
            
        INSERT dbo.InteractionType
                ( InteractionTypeID, InteractionType )
        VALUES	 (1,'Introduction')
                    ,(2,'Phone Call (Outbound)')
                    ,(3,'Complaint')
                    ,(4,'Sale')
                    ,(5,'Meeting')

        --Set Up Expected Data Table

        IF object_id('RptContactTypes.Expected') IS NOT NULL
        DROP TABLE RptContactTypes.Expected

        CREATE TABLE RptContactTypes.Expected (
            InteractionType varchar(100),
            Occurrences INT,
            TotalTimeInMinutes int
            )
        ```

        f) we can then refactor our second test to be be much more focused as follow:

        ```TSQL
        ALTER PROCEDURE [RptContactTypes].[test to check routine outputs correct data in table given normal input data]
        AS
        BEGIN
        --Assemble 
        --Insert test data into Interaction table (Faked in Setup Routine)  

        INSERT dbo.Interaction
                ( InteractionTypeID ,
                InteractionStartDT ,
                InteractionEndDT 
                )
        VALUES  ( 
                5 , -- Meeting
                CONVERT(DATETIME,'2013-01-03 09:00:00',120),
                CONVERT(DATETIME,'2013-01-03 09:30:00',120) 
                )
                ,( 
                5 , -- Meeting
                CONVERT(DATETIME,'2013-01-02 09:00:00',120),
                CONVERT(DATETIME,'2013-01-02 10:30:00',120) 
                )
                ,( 
                2 , -- Phone Call (Outbound)
                CONVERT(DATETIME,'2013-01-03 09:01:00',120),
                CONVERT(DATETIME,'2013-01-03 09:13:00',120) 
                )

        --Insert Expected Values

        INSERT RptContactTypes.Expected VALUES 
            ('Meeting',2,120), 
            ('Phone Call (Outbound)',1,12)

        --Act
        SELECT * INTO RptContactTypes.Actual FROM dbo.RptContactTypes

        
        --Assert
        EXEC tSQLt.AssertEqualsTable @Expected = N'RptContactTypes.Expected', -- nvarchar(max)
            @Actual = N'RptContactTypes.Actual', -- nvarchar(max)
            @FailMsg = N'The expected data was not returned.' -- nvarchar(max)
        
        
        END;
        ```

#### Exercise 3: Cross database testing

1. Let's create 2 databases with a view in the first database that depends on the a table on the second one.

    ```TSQL
    USE master
    GO
    CREATE DATABASE test_tsqlt_1
    GO
    USE test_tsqlt_1
    GO
    CREATE TABLE test_tsqlt_1.dbo.phys_src (
        col1 int NOT NULL,
        col2 nvarchar(MAX) NOT null)
    
    ```
    Then in test_tsqlt_2 I created the following cross database view
    ```TSQL
    USE master
    GO
    CREATE DATABASE test_tsqlt_2
    GO
    USE test_tsqlt_2
    GO
    CREATE VIEW dbo.view_src AS
    SELECT * FROM test_tsqlt_1.dbo.phys_src
    ```

    
    **Please note that tSQLt needs to be installed on both database as it doesn't support natively cross database**

2. Open and run PrepareServer.sql and tSQLt.class to install tSQLt against both test_tsqlt_1 and test_tsqlt_2 Databases 

3. In test_tsqlt_2, let's now create a ```crossDB``` TestClass and a ```test cross database view``` test

    ```TSQL
    USE test_tsqlt_2
    GO
    EXEC tSQLt.NewTestClass @ClassName = N'CrossDB' 
    GO
    CREATE PROCEDURE [CrossDB].[test cross database view]
    AS
    BEGIN
        --Assemble

        --Act
        
        --Assert            
        EXEC tSQLt.Fail 'Not implemented yet'
    END;    
    ```

4. let's go through our Assemble or Arrange section

    - the ```test_tsqlt_2.dbo.view_src``` is our database object under test.
    - that view takes a dependency on ```test_tsqlt_1.dbo.phys_src``` which we want to isolate from
    - create a fake table of ```test_tsqlt_1.dbo.phys_src``` which we then can populate with test data
    
    ```TSQL
    --Assemble
    EXEC test_tsqlt_1.tSQLt.FakeTable @TableName = N'phys_src'; 

    INSERT INTO test_tsqlt_1.dbo.phys_src (col1, col2)
    VALUES	
    (1,N'Some Value' ),
    (2,N'Another Value' );

    SELECT * INTO #Expected FROM test_tsqlt_1.dbo.phys_src;
    ``` 

    - This is good start but we are carrying the **bad practice of hard-coding database names into the tests which can quickly become a maintenance nightmare**
    - a better practice will be to create [synonyms](https://docs.microsoft.com/en-us/sql/relational-databases/synonyms/synonyms-database-engine?view=sql-server-ver15) to introdyce layer in between dependencies and only test against one database
    
    - Now synomyms are not fully supported in tSQLt but an intermediary solution would be generate views in the with stored procedure in the first database that takes a second database name
    - The stored procedure can loops through all tables in that second database and creates corresponding views in the first database.



## Module 2: Running tSQLT within Azure Pipelines

 #### Set up your Azure DevOps Organisation

  1.	Use or [create](https://signup.live.com) your personal Microsoft Account (MSA)      
  2.	[Create a free Azure DevOps organization](https://dev.azure.com/)  associated with your MSA

  3. Create a New Project by clicking on the top right corning New Project button 

  4. Set its visibility to public and name it DatabaseTesting 

  5. optionally provide with a description such as _```"Run tSQlt tests within CI"`
