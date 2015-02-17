
-- обновление структуры БД до 1.2.5.0
--новые таблицы:
--  	testattribute  атрибуты испытания (для ВПМ)
--		deviceproperty свойства типа прибора
--изменения в таблицах:
--		n_property
--		  [+] признак свойства испытания
--		  [+] признак свойства прибора
--		  [+] признак обязательности свойства
--		constants
--		  [x] описание константы увеличено до 250	
--		channelstruct
--		  [-] удаляем ненужное поле

-- Запуск скрипта осуществляется в среде PostgreSQL 
-- через запуск pgSript (второй зеленый треугольник в меню) 

-- Проверка версии базы:
-- Если версия < 'x.x.x.x' - то выполнить.
-- Иначе - не выполнять.

DECLARE @NewDBVersion;
DECLARE @dver,@ResultRec; 

BEGIN
 set @NewDBVersion = '1.2.5.0';
 if not (SELECT CAST(translate(constvalue,'.','') AS int) FROM constants where LOWER(constname)= 'dbversion')
 begin
  print 'Ошибка. Нет записи версии БД в таблице constants!';
  break;
 end
 set @dver = SELECT CAST(translate('@NewDBVersion','.','') AS int) - CAST(translate(constvalue,'.','') AS int) 
	FROM constants where LOWER(constname)= 'dbversion';
 if cast(@dver as integer) <= 0
 begin
	print 'Скрипт предназначен для для более ранней версии БД,'; 
	print 'Скрипт возможно уже выполнялся для этой версии БД'; 
	break;
 end
 print ''; 
 print 'Начинаем выполнение';

--корректировка таблицы channelstuct 
-- удаляем поле fpath - это рудимент
 print 'удаляем поле channelstuct.fpath';
 ALTER TABLE channelstruct DROP COLUMN IF EXISTS  fpath;
	
	
--корректировка талицы N_property
 print 'Изменяем структуру n_property';
 ALTER TABLE n_property DROP COLUMN lastupdate;
 ALTER TABLE n_property ADD column  ismandatory boolean;      -- Является ли свойство обязательным для объекта. 
 ALTER TABLE n_property ADD column	istestusage boolean;      -- Используется \ нет в испытаниях 
 ALTER TABLE n_property ADD column	isdeviceusage boolean;    -- Используется \ нет свойство в приборах 
 ALTER TABLE n_property ADD COLUMN lastupdate char(80);
 --Все ранее введенные свойства - это свойства испытаний
 UPDATE n_property SET istestusage = true;

 print 'добавление таблицы deviceproperty';
 DROP TABLE IF EXISTS deviceproperty CASCADE;
 DROP SEQUENCE IF EXISTS deviceproperty_devicepropertyid_seq;
 CREATE SEQUENCE deviceproperty_devicepropertyid_seq INCREMENT 1 START 1;

 CREATE TABLE deviceproperty ( 
	devicepropertyid bigint DEFAULT nextval(('deviceproperty_devicepropertyid_seq'::text)::regclass) NOT NULL,
	devicetypeid bigint,    -- Ссылка на тип прибора 
	propertyid bigint,      -- Ссылка на свойство 
	devicepropertyvalue varchar(50)
 );
 COMMENT ON TABLE deviceproperty
    IS 'Заданные свойства типов приборов';
 COMMENT ON COLUMN deviceproperty.devicetypeid
    IS 'Ссылка на тип прибора';
 COMMENT ON COLUMN deviceproperty.propertyid
    IS 'Ссылка на свойство';

 ALTER TABLE deviceproperty ADD CONSTRAINT PK_deviceproperty 
	PRIMARY KEY (devicepropertyid);

 ALTER TABLE deviceproperty ADD CONSTRAINT FK_deviceproperty_DeviceType 
	FOREIGN KEY (devicetypeid) REFERENCES DeviceType (DeviceTypeID);

 ALTER TABLE deviceproperty ADD CONSTRAINT FK_deviceproperty_n_property 
	FOREIGN KEY (propertyid) REFERENCES n_property (propertyID);


--- добавление таблицы Testattribute
 print 'добавление таблицы Testattribute';
 DROP TABLE IF EXISTS testattribute CASCADE;
 DROP SEQUENCE IF EXISTS testattribute_testattributeid_seq;
 CREATE SEQUENCE testattribute_testattributeid_seq INCREMENT 1 START 1;

 CREATE TABLE testattribute ( 
	testattributeid bigint DEFAULT nextval(('testattribute_testattributeid_seq'::text)::regclass) NOT NULL,    -- Первичный ключ 
	testid bigint,    -- ссылка на испытание 
	name text,    -- имя атрибута 
	value text    -- Значение атрибута в виде сериализированной строки Для получения реального значения используется парсер 
 );
 COMMENT ON TABLE testattribute
    IS 'Таблица дополнительных атрибутов испытания. Заполняет и использууют таблицу ВПМ. Один ВПМ, (обычно, который записывает испытание),  может положить туда  дополнительную информацию об испытании. Другой ВПМ (обычно, который визуализирует испытание) считывает эту дополнительную информацию и использует ее.';
 COMMENT ON COLUMN testattribute.testattributeid
    IS 'Первичный ключ';
 COMMENT ON COLUMN testattribute.testid
    IS 'ссылка на испытание';
 COMMENT ON COLUMN testattribute.name
    IS 'имя атрибута';
 COMMENT ON COLUMN testattribute.value
    IS 'Значение атрибута в виде сериализированной строки Для получения реального значения используется парсер';

 ALTER TABLE testattribute ADD CONSTRAINT PK_testattribute 
	PRIMARY KEY (testattributeid);

 ALTER TABLE testattribute ADD CONSTRAINT FK_testattribute_Test 
	FOREIGN KEY (testid) REFERENCES Test (TestID);

 --корректирвка таблицы Constants
 print 'корректирвка таблицы Constants';	
 ALTER TABLE constants ALTER COLUMN constfullname TYPE varchar(250);	
	
 -- добавляем константы
 set @ResultRec = SELECT COUNT(*) FROM constants where UPPER(constname)= 'RESET_USER_SETTINGS';
 if cast(@ResultRec as integer) <= 0
   begin
	print 'добавляем константы';
	Insert INTO constants (constname,constfullname, constvalue)
	Values 
		('MAXREC_PREVIEW',  'Количество строк для предпросмотра данных', 512),
		('LVL_WARN_TEST',  'Предупреждение о большом объеме выборки по количеству выбранных испытаний', 100),       
		('LVL_WARN_ELM',   'Предупреждение о большом объеме выборки по количеству выбранных элементов', 20),       
		('RESET_USER_SETTINGS','Сброс настроек пользователя 0/1/2 не сбрасывать/версия/вход', '0');
		
	--Update constants set constvalue ='1' where constname= 'reset_user_settings';	
   end	
	
 --изменяем номер версии и сброс настроек
 print 'изменяем параметры констант';
 Update constants set constvalue ='@NewDBVersion' where LOWER(constname)= 'dbversion';
 Update constants set constvalue ='1'             where LOWER(constname)= 'reset_user_settings';
	
print 'Обновление базы данных завершено';
 
end
	