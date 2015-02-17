-- начальное заполнение пустой базы

-- добавление данных в таблицу ролей
INSERT INTO n_role (roleid,rolename)
 VALUES 
  (0,'Аналитик'),
  (1,'Оператор'),
  (2,'Разработчик ВПМ'),
  (4,'Менеджер'),
  (5,'Администратор');
 
 -- добавление пользователей
INSERT INTO users(fio, login, isactive)
    VALUES 
	('Майоров М.М.', 'major', 1),
	('Генералов Г.Г', 'gener', 1),
	('Прапорщиков П.П.','prapor', 1),
	('Операторов А.А.','oper', 1),
	('Разработкин В.В.', 'vpm', 1);
	
-- добавление ролей пользователям
INSERT INTO userroles(userid, roleid)
    VALUES 
	(1, 4),
	(2, 4),
	(3, 1),
	(4, 1),
	(5, 2);
	
	
-- заполнение нормативной таблицы типов данных
Insert INTO n_structtype (structtypeid, typename, fieldname)	
	VALUES	( 1, 'Double',	'Datadouble'),
			( 2, 'Bool',	'Databool'),
			( 3, 'Real',	'Datareal'),
			( 4, 'Datetime','Datadatetime'),
			( 5, 'Mask', 	'DataMaskcode'),
			( 6, 'Stream',	'DataStream'),
			( 7, 'String',	'DataString'),
			( 8, 'Integer',	'Datainteger'),
			( 9, 'Long',	'Datalong'),
			(10, 'Char',	'Datachar');
	
 -- добавление номера версии БД   
 INSERT INTO constants (constname,constvalue) VALUES('dbversion', '1.2.4.0')
	
 