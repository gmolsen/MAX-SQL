--destroys, then recreates database
use master
drop database if exists PRSDB
create database PRSDB
use PRSDB
go --locks in previous data entry
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
go
/* create index IX_Username 
	on [User](UserName, Password) 
indexes are typically used to make SQL databases run faster, but
they tend to take more time to update, alter, etc. */

/* unique indexes prevents identical data
	from being entered into the same column, in this case it prohibits
	using a username that has been taken already */
create unique index IUX_Username 
	on [User](UserName) 
go
--creating an account
insert into [USER]
	(UserName, Password, FirstName, LastName, Phone, Email, IsReviewer,
	 IsAdmin)
	 values
	 ('gmolsen', 'password', 'Greg', 'Olsen', '5135627943', 'gmolsenvideo@gmail.com', '1',
	 '1') 
go
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
	Name varchar(255) not null,
	Address varchar(255) not null default ' ',
	City varchar(255) not null default ' ',
	[State] varchar(2) not null default ' ',
	Zip varchar(5) not null default ' ',
	Phone varchar(12) not null default ' ',
	Email varchar (75) not null default ' ',
	IsPreapproved bit default 0 not null,
	Active bit not null default 1,
	DateCreated datetime not null default getdate(),
	DateUpdated datetime,
	UpdatedByUser int foreign key references [Vendor] (id) 
) 

go

create unique index IUX_Code
	on Vendor(Code) 

go

insert into Vendor
	(Code, Name, Address, City, State, Zip, Phone, Email)
	 values
	 ('THRN', 'Thorne Research', 'P.O. Box 25', 'Dover', 'ID', '83825', '208-263-1337', 'info@thorne.com') 
go
insert into Vendor
	(Code, Name, Address, City, State, Zip, Phone, Email)
	 values
	 ('FVR', 'Favorite Vapors', '311 Ludlow Avenue', 'Cincinnati', 'OH', '45220', '513-446-7417', 'favoritevapors@gmail.com') 
go
insert into Vendor
	(Code, Name, Address, City, State, Zip, Phone, Email)
	 values
	('KGR', 'Kroger', '4777 Kenard Ave', 'Cincinnati', 'OH', '45232', '513-681-7650', 'info@kroger.com')
go
