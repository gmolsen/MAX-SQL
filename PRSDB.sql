--destroys, then recreates database
use master
drop database if exists PRSDB
create database PRSDB
use PRSDB
go
--creating table for user data
create table [User] (
	ID int not null primary key identity (1,1),
	Username varchar(20) not null,
	Password varchar(16) not null,
	FirstName varchar(20) not null,
	LastName varchar(20) not null,
	Phone varchar(12) not null,
	Email varchar(75) not null,
	IsReviewer bit not null default 0,
	IsAdmin bit not null default 0,
	Active bit not null default 1,
	DateCreated datetime not null default getdate(),
	DateUpdated datetime,
	UpdatedByUser int foreign key references [User] (id) 
) 

/* create index IX_Username 
	on [User](UserName, Password) 
indexes are typically used to make SQL databases run faster, but
they tend to take more time to update, alter, etc. */

/* unique indexes prevents identical data
	from being entered into the same column, in this case it prohibits
	using a username that has been taken already */
create unique index IUX_Username 
	on [User](UserName) 

--creating an account
insert into [USER]
	(UserName, Password, FirstName, LastName, Phone, Email, IsReviewer,
	 IsAdmin)
	 values
	 ('gmolsen', 'password', 'Greg', 'Olsen', '5135627943', 'gmolsenvideo@gmail.com', '1',
	 '1') 

insert into [USER]
	(UserName, Password, FirstName, LastName, Phone, Email, IsReviewer,
	 IsAdmin)
	 values
	 ('gmolsen1', 'password', 'Greg', 'Olsen', '5135627943', 'gmolsenvideo@gmail.com', '1',
	 '1') 
go
create table Vendor (
	ID int not null primary key identity (1,1),
	Code varchar(10) not null,
	Name varchar(255) not null default '',
	Address varchar(255) not null default '',
	City varchar(255) default '',
	State varchar(2) default '',
	Zip varchar(5) default '',
	Phone varchar(12) default '',
	Email varchar(75) default '',
	IsPreApproved bit default '',
	Active bit not null default 1,
	DateCreated datetime not null default getdate(),
	DateUpdated datetime,
	UpdatedByUser int foreign key references [User] (id)
)
go
insert into Vendor
	(Code, Name)
	 values
	 ('THRN', 'Thorne Research') 

insert into Vendor
	(Code, Name)
	 values
	 ('FVR', 'Favorite Vapors') 

insert into Vendor
	(Code, Name)
	 values
	 ('AMZ', 'Amazon') 
go 


create table Product (
	ID int not null primary key identity (1,1),
	VendorID int foreign key references [Vendor] (id),
	PartNumber varchar(50) not null,
	Name varchar(150) not null default '',
	Price decimal(10,2) not null default '',
	Unit varchar(255) default '',
	PhotoPath varchar(255),
	Active bit not null default 1,
	DateCreated datetime not null default getdate(),
	DateUpdated datetime,
	UpdatedByUser int foreign key references [User] (id)
)
go
insert into Product
	(VendorID, PartNumber, Name, Price, Unit)
	 values
	 ('1', '0998', 'Basic B-Complex', '18.87', '60 Capsules') 

insert into Product
	(VendorID, PartNumber, Name, Price, Unit)
	 values
	 ('1', '2482', 'Zinc Picolinate 50mg', '12.34', '180 capsules') 

insert into Product
	(VendorID, PartNumber, Name, Price, Unit)
	 values
	 ('2', '8347', 'Charlie"s Chalkdust Head Bangin" Boogie', '30.00', '60mL Bottle') 

insert into Product
	(VendorID, PartNumber, Name, Price, Unit)
	 values
	 ('2', '2363', 'Smok TFV8', '50.50', '1') 

insert into Product
	(VendorID, PartNumber, Name, Price, Unit)
	 values
	 ('3', '8923', 'Fidget Cube', '21.65', '1') 

insert into Product
	(VendorID, PartNumber, Name, Price, Unit)
	 values
	 ('3', '2093', 'Hellman"s Mayonnaise', '0.25', '64oz.') 
go

create table [status] (
	ID int not null primary key identity(1,1),
	Description varchar(20) not null,
	Active bit not null default 1,
	DateCreated datetime not null default getdate(),
	DateUpdated datetime,
	UpdatedByUser int foreign key references [User] (id)
)
go

insert into [Status]
	(Description)
	 values
	 ('New') 

insert into [Status]
	(Description)
	 values
	 ('Review') 

insert into [Status]
	(Description)
	 values
	 ('Approved') 

insert into [Status]
	(Description)
	 values
	 ('Rejected') 

insert into [Status]
	(Description)
	 values
	 ('Revise') 
go

create table PurchaseRequest (
	ID int not null primary key identity (1,1),
	UserID int foreign key references [User] (id),
	Description varchar(100) not null default '',
	Justification varchar(255) not null default '',
	DateNeeded date not null default DateAdd(day,7,getdate()),
	DeliveryMode varchar(25) not null default 'UPS',
	StatusID int default '1' foreign key references [Status] (id),
	Total decimal(10,2) not null default '0',
	SubmittedDate datetime not null default getdate(),
	Active bit not null default 1,
	ReasonForRejection varchar(100) default '',
	DateCreated datetime not null default getdate(),
	DateUpdated datetime,
)
go

insert into PurchaseRequest
	(UserID, Description, Justification)
	 values
	 ('1', 'Fidget Cube.', 'I have severe ADHD and I need a fidget cube to play with.') 
go

create table PurchaseRequestLineItem (
	ID int not null primary key identity (1,1),
	PurchaseRequestID int foreign key references [PurchaseRequest] (id),
	ProductID	int foreign key references [Product] (id),
	Quantity	INT default '1',
	Active bit not null default 1,
	DateCreated datetime not null default getdate(),
	DateUpdated datetime,
	UpdatedByUser int foreign key references [User] (id)
)


/*s declare @uname varchar(20)
	declare @pword varchar(16)
	set @uname = 'gmolsen'
	set @pword = 'password' */

--stored procedure used to validate login info
go
create procedure ValidateLogin
	@UserName varchar(20),
	@Password varchar(16)
as
	begin
		if exists (select * from [User] where UserName = @UserName and Password = @Password)
			begin
				print 'The user is valid!'
			end
			else
			begin
				print 'The username/password combination is invalid.'
			end
end
go
--logging in using login info in database 
exec ValidateLogin @UserName = 'gmolsen', @Password = 'password'
go
--logging in using login info not in database
exec ValidateLogin @UserName = 'gmolsen', @Password = 'password1'
go

--add in @vendorID specific tie thing
/* creates variable that adds time to
current date
declare @now datetime
	set @now = getdate()
	DateAdd(day, 7, @now) */

select * from [user]
select * from vendor
select * from product
select * from status
select * from purchaserequest