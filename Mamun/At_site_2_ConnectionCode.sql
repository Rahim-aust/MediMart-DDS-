DROP DATABASE LINK medimart_link;

CREATE DATABASE LINK medimart_link
 CONNECT TO SYSTEM IDENTIFIED BY "12345"
 USING '(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.195.19)
		 (PORT = 1521))
       )
       (CONNECT_DATA =
         (SID = XE)
       )
     )'
;  
