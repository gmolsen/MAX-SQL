/* declare @uname varchar(20)
	declare @pword varchar(16)
	set @uname = 'gmolsen'
	set @pword = 'password' */

--stored procedure used to validate login info
Create procedure ValidateLogin
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