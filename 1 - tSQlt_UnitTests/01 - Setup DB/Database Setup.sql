/* Create Customer Management database */
USE master
GO
CREATE DATABASE CustomerManagement
GO
USE CustomerManagement
GO

CREATE TABLE dbo.Customer (
CustomerID INT IDENTITY(1,1) PRIMARY KEY,
Forename VARCHAR(100),
Surname VARCHAR(100),
KnownAs VARCHAR(100),
PhoneNumber VARCHAR(20)
)
GO

CREATE TABLE dbo.Staff(
StaffID INT IDENTITY(1,1) PRIMARY KEY,
Forename VARCHAR(100),
Surname VARCHAR(100),
KnownAs VARCHAR(100)
)
GO

CREATE TABLE dbo.InteractionType (
InteractionTypeID INT IDENTITY(1,1) PRIMARY KEY,
InteractionTypeText VARCHAR(100)
)
GO

CREATE TABLE dbo.Interaction (
InteractionID INT IDENTITY(1,1) PRIMARY KEY,
StaffID INT NOT NULL,
CustomerID INT NOT NULL,
InteractionTypeID INT NOT NULL,
InteractionStartDT DATETIME NOT NULL,
InteractionEndDT DATETIME NOT NULL,
StaffNotes VARCHAR(MAX) NOT NULL
)
GO

ALTER TABLE dbo.Interaction 
	ADD CONSTRAINT chkInteractionsEndAfterStart 
		CHECK (InteractionEndDt > InteractionStartDt );
GO

ALTER TABLE dbo.Interaction
ADD CONSTRAINT FK_Interaction_Staff FOREIGN KEY (StaffID)
    REFERENCES dbo.Staff (StaffID) ;
GO

ALTER TABLE dbo.Interaction
ADD CONSTRAINT FK_Interaction_Customer FOREIGN KEY (CustomerID)
    REFERENCES dbo.Customer (CustomerID) ;

GO

ALTER TABLE dbo.Interaction
ADD CONSTRAINT FK_Interaction_InteractionType FOREIGN KEY (InteractionTypeID)
    REFERENCES dbo.InteractionType (InteractionTypeID) ;

GO
