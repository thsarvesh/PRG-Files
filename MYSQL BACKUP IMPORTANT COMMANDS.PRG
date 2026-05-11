tasklist | findstr /I "mysqld" &&&CONFIRM THE SERVICE NAME


taskkill /PID XXXX /F  &&&TERMINATE SERVICE


mysqld --skip-grant-tables --skip-networking &&SKIP GRAND ACCESS DATA


USE mysql;
UPDATE user SET password=PASSWORD('NewPassword123') WHERE User='root';
FLUSH PRIVILEGES; &&NEW USER PASSWORD SET
