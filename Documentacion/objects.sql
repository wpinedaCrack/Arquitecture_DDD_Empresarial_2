
 
 CREATE TABLE [dbo].[Users](
	[UserId] [int] NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
 
 
CREATE TABLE [dbo].[Categories](
	[CategoryID] [int] NOT NULL,
	[CategoryName] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Picture] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


INSERT INTO Categories (CategoryID, CategoryName, Description, Picture)
VALUES 
(1, 'Category 1', 'Description for category 1', CAST(NEWID() AS VARBINARY(16))),
(2, 'Category 2', 'Description for category 2', CAST(NEWID() AS VARBINARY(16))),
(3, 'Category 3', 'Description for category 3', CAST(NEWID() AS VARBINARY(16))),
(4, 'Category 4', 'Description for category 4', CAST(NEWID() AS VARBINARY(16))),
(5, 'Category 5', 'Description for category 5', CAST(NEWID() AS VARBINARY(16)));


GO






CREATE TABLE [dbo].[Customers](
	[CustomerId] [nvarchar](50) NOT NULL,
	[CompanyName] [nvarchar](100) NOT NULL,
	[ContactName] [nvarchar](100) NULL,
	[ContactTitle] [nvarchar](50) NULL,
	[Address] [nvarchar](255) NULL,
	[City] [nvarchar](50) NULL,
	[Region] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](20) NULL,
	[Country] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO








CREATE PROCEDURE CustomersInsert
(
	@CustomerID nchar (5) ,
	@CompanyName nvarchar (40) ,
	@ContactName nvarchar (30) NULL ,
	@ContactTitle nvarchar (30) NULL ,
	@Address nvarchar (60) NULL ,
	@City nvarchar (15) NULL ,
	@Region nvarchar (15) NULL ,
	@PostalCode nvarchar (10) NULL ,
	@Country nvarchar (15) NULL ,
	@Phone nvarchar (24) NULL ,
	@Fax nvarchar (24) NULL
)
AS
BEGIN

    INSERT INTO Customers (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax)
    VALUES(@CustomerID, @CompanyName, @ContactName, @ContactTitle, @Address, @City, @Region, @PostalCode, @Country, @Phone, @Fax)

END
GO

CREATE PROCEDURE CustomersUpdate
(
	@CustomerID nchar (5) ,
	@CompanyName nvarchar (40) ,
	@ContactName nvarchar (30) NULL ,
	@ContactTitle nvarchar (30) NULL ,
	@Address nvarchar (60) NULL ,
	@City nvarchar (15) NULL ,
	@Region nvarchar (15) NULL ,
	@PostalCode nvarchar (10) NULL ,
	@Country nvarchar (15) NULL ,
	@Phone nvarchar (24) NULL ,
	@Fax nvarchar (24) NULL
)
AS
BEGIN

    UPDATE Customers
        SET
        CompanyName=@CompanyName,
        ContactName=@ContactName,
        ContactTitle=@ContactTitle,
        Address=@Address,
        City=@City,
        Region=@Region,
        PostalCode=@PostalCode,
        Country=@Country,
        Phone=@Phone,
        Fax=@Fax
    WHERE CustomerID=@CustomerID

END
GO

CREATE PROCEDURE CustomersDelete
(
	@CustomerID nchar (5)
)
AS
BEGIN

    DELETE Customers
    WHERE CustomerID=@CustomerID

END
GO

CREATE PROCEDURE CustomersList
AS
BEGIN

    SELECT CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax
    FROM Customers

END
GO

CREATE PROCEDURE CustomersGetByID
(
    @CustomerID nchar (5)
)
AS
BEGIN

    SELECT CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax
    FROM Customers
    WHERE CustomerID=@CustomerID

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
    [LastName] [varchar](50) NOT NULL,
    [UserName] [varchar](50) NOT NULL,
    [Password] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [PK_Users] PRIMARY KEY NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE PROCEDURE UsersGetByUserAndPassword
(
    @UserName varchar(50),
    @Password varchar(50)
)
AS
BEGIN
    SELECT UserId, FirstName, LastName, UserName, NULL as Password
    FROM Users
    WHERE UserName = @UserName and Password = @Password
END


GO


CREATE PROCEDURE [dbo].[CustomersListWithPagination]
(
    @PageNumber int,
    @PageSize int
)
AS
BEGIN

    SELECT CustomerId, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax
    FROM Customers
    ORDER BY CustomerID
    OFFSET (@PageNumber-1)*@PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY
END
GO

 