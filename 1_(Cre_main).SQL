DROP TABLE IF EXISTS Constants CASCADE;
DROP SEQUENCE IF EXISTS Constants_ConstantID_seq;
DROP TABLE IF EXISTS protocol CASCADE;
DROP SEQUENCE IF EXISTS protocol_protocolid_seq;
DROP TABLE IF EXISTS n_role CASCADE;
DROP TABLE IF EXISTS userrights CASCADE;
DROP SEQUENCE IF EXISTS userrights_userrightid_seq;
DROP TABLE IF EXISTS userroles CASCADE;
DROP SEQUENCE IF EXISTS userroles_ur_id_seq;
DROP TABLE IF EXISTS users CASCADE;
DROP SEQUENCE IF EXISTS users_userid_seq;
DROP TABLE IF EXISTS n_StructType CASCADE;
DROP TABLE IF EXISTS n_property CASCADE;
DROP SEQUENCE IF EXISTS n_property_propertyID_seq;
DROP TABLE IF EXISTS propertyvariants CASCADE;
DROP SEQUENCE IF EXISTS propertyvariants_variantId_seq;
DROP TABLE IF EXISTS testproperty CASCADE;
DROP SEQUENCE IF EXISTS testproperty_testpropertyid_seq;
DROP TABLE IF EXISTS Test CASCADE;
DROP SEQUENCE IF EXISTS Test_TestID_seq;
DROP TABLE IF EXISTS TestData CASCADE;
DROP SEQUENCE IF EXISTS TestData_TestDataID_seq;
DROP TABLE IF EXISTS TestDevice CASCADE;
DROP SEQUENCE IF EXISTS TestDevice_TestDeviceID_seq;
DROP TABLE IF EXISTS TestFile CASCADE;
DROP SEQUENCE IF EXISTS TestFile_TestFileID_seq;
DROP TABLE IF EXISTS VPM CASCADE;
DROP SEQUENCE IF EXISTS VPM_VPMID_seq;
DROP TABLE IF EXISTS Channel CASCADE;
DROP SEQUENCE IF EXISTS Channel_ChannelID_seq;
DROP TABLE IF EXISTS ChannelStruct CASCADE;
DROP SEQUENCE IF EXISTS ChannelStruct_ChannelStructID_seq;
DROP TABLE IF EXISTS Device CASCADE;
DROP SEQUENCE IF EXISTS Device_DeviceID_seq;
DROP TABLE IF EXISTS DeviceChannel CASCADE;
DROP SEQUENCE IF EXISTS DeviceChannel_DevicechannelID_seq;
DROP TABLE IF EXISTS Devicecontent CASCADE;
DROP SEQUENCE IF EXISTS Devicecontent_ID_seq;
DROP TABLE IF EXISTS DeviceType CASCADE;
DROP SEQUENCE IF EXISTS DeviceType_DeviceTypeID_seq;
DROP TABLE IF EXISTS DeviceTypecontent CASCADE;
DROP SEQUENCE IF EXISTS DeviceTypecontent_ID_seq;
DROP TABLE IF EXISTS n_polygon CASCADE;
DROP SEQUENCE IF EXISTS n_polygon_polygonid_seq;

CREATE SEQUENCE Constants_ConstantID_seq INCREMENT 1 START 1;

CREATE TABLE Constants ( 
	ConstantID bigint DEFAULT nextval(('Constants_ConstantID_seq'::text)::regclass) NOT NULL,
	ConstName char(20) NOT NULL,    --  Имя константы Должно быть уникально 
	ConstFullName varchar(50),    --  полное имя константы 
	ConstValue varchar(50)    --  Значение константы. Хранится в текстовом виде. преобразуется при обработке  
);
COMMENT ON TABLE Constants
    IS 'Таблица настроек и констант';
COMMENT ON COLUMN Constants.ConstName
    IS 'Имя константы Должно быть уникально';
COMMENT ON COLUMN Constants.ConstFullName
    IS 'полное имя константы';
COMMENT ON COLUMN Constants.ConstValue
    IS 'Значение константы. Хранится в текстовом виде. преобразуется при обработке ';

CREATE SEQUENCE protocol_protocolid_seq INCREMENT 1 START 1;

CREATE TABLE protocol ( 
	protocolid bigint DEFAULT nextval(('protocol_protocolid_seq'::text)::regclass) NOT NULL,
	object varchar(50),    --  Наименование объекта - произвольное имя 
	typ varchar(50),    --  тип события объекта 
	text varchar(250),    --  Описание действия с объектом (события) 
	fio varchar(50),    --  Фамилия пользователя, кто произвел действие 
	useros varchar(50),    --  Имя пользователя операционной системы 
	station varchar(50),    --  Имя станции в ОС 
	dat timestamp DEFAULT now(),    --  Дата события 
	typeobjid integer,    --  Тип объекта (typeObjects) 1 - Полигоны ... 
	objid bigint    --  id конкретного объекта выбранного типа (typeobjid) 
);
COMMENT ON TABLE protocol
    IS 'Протокол (Журнал) работы пользователей.';
COMMENT ON COLUMN protocol.object
    IS 'Наименование объекта - произвольное имя';
COMMENT ON COLUMN protocol.typ
    IS 'тип события объекта';
COMMENT ON COLUMN protocol.text
    IS 'Описание действия с объектом (события)';
COMMENT ON COLUMN protocol.fio
    IS 'Фамилия пользователя, кто произвел действие';
COMMENT ON COLUMN protocol.useros
    IS 'Имя пользователя операционной системы';
COMMENT ON COLUMN protocol.station
    IS 'Имя станции в ОС';
COMMENT ON COLUMN protocol.dat
    IS 'Дата события';
COMMENT ON COLUMN protocol.typeobjid
    IS 'Тип объекта (typeObjects) 1 - Полигоны ...';
COMMENT ON COLUMN protocol.objid
    IS 'id конкретного объекта выбранного типа (typeobjid)';

CREATE TABLE n_role ( 
	roleid bigint NOT NULL,    --  Первичный ключ 
	rolename varchar(50)    --  Название роли 
);
COMMENT ON TABLE n_role
    IS 'Таблица ролей для пользователей системы. Не имет интерфейса. Не редактируется  
 Базовые роли: 1 -оператор 2 - разработчик ВПМ 4 - менеджер 5 - администратор';
COMMENT ON COLUMN n_role.roleid
    IS 'Первичный ключ';
COMMENT ON COLUMN n_role.rolename
    IS 'Название роли';

CREATE SEQUENCE userrights_userrightid_seq INCREMENT 1 START 1;

CREATE TABLE userrights ( 
	userrightid bigint DEFAULT nextval(('userrights_userrightid_seq'::text)::regclass) NOT NULL,
	userid bigint,
	typeobjid integer,    --  Тип объекта 1 - полигон 2-прибор 3 - испытание 4 -временной интервал 
	objid bigint,    --  id соответствующего объекта =0 - Доступ по-умолчанию 
	rights boolean DEFAULT FALSE,    --  Права на объект 0 - запрещено 1 - разрешено 
	datfrom timestamp,    --  Период ограничения с... если typeobjid=1..3 - ограничение по времени на выбранны тип объектов если typeobjid=4 - ограничение по времени на все 
	datto timestamp,    --  Период ограничения по 
	Lastupdate varchar(50)
);
COMMENT ON COLUMN userrights.typeobjid
    IS 'Тип объекта 1 - полигон 2-прибор 3 - испытание 4 -временной интервал';
COMMENT ON COLUMN userrights.objid
    IS 'id соответствующего объекта =0 - Доступ по-умолчанию';
COMMENT ON COLUMN userrights.rights
    IS 'Права на объект 0 - запрещено 1 - разрешено';
COMMENT ON COLUMN userrights.datfrom
    IS 'Период ограничения с... если typeobjid=1..3 - ограничение по времени на выбранны тип объектов если typeobjid=4 - ограничение по времени на все';
COMMENT ON COLUMN userrights.datto
    IS 'Период ограничения по';

CREATE SEQUENCE userroles_ur_id_seq INCREMENT 1 START 1;

CREATE TABLE userroles ( 
	ur_id bigint DEFAULT nextval(('userroles_ur_id_seq'::text)::regclass) NOT NULL,
	userid bigint NOT NULL,
	roleid bigint NOT NULL,    --  Ссылка на таблицу "Роли" 
	lastupdate varchar(80)
);
COMMENT ON COLUMN userroles.roleid
    IS 'Ссылка на таблицу "Роли"';

CREATE SEQUENCE users_userid_seq INCREMENT 1 START 1;

CREATE TABLE users ( 
	userid bigint DEFAULT nextval(('users_userid_seq'::text)::regclass) NOT NULL,
	fio varchar(50),    --  Фамилия и инициалы  
	firma varchar(50),    --  Организация. Дополнительный необязательный параметр. Заполняется по необходимости 
	primech varchar(250),
	login varchar(20),    --  Имя входа 
	pwd varchar(50),    --  Хэш пароля 
	tel varchar(100),    --  телефон 
	address varchar(100),    --  адрес 
	email varchar(100),
	Lastupdate varchar(80),
	isgroup boolean,    --  Признак группы ??? 
	isactive integer,
	parentid bigint    --  Ссылка на группу ??? Нужно ли? 
);
COMMENT ON COLUMN users.fio
    IS 'Фамилия и инициалы ';
COMMENT ON COLUMN users.firma
    IS 'Организация. Дополнительный необязательный параметр. Заполняется по необходимости';
COMMENT ON COLUMN users.login
    IS 'Имя входа';
COMMENT ON COLUMN users.pwd
    IS 'Хэш пароля';
COMMENT ON COLUMN users.tel
    IS 'телефон';
COMMENT ON COLUMN users.address
    IS 'адрес';
COMMENT ON COLUMN users.isgroup
    IS 'Признак группы ???';
COMMENT ON COLUMN users.parentid
    IS 'Ссылка на группу ??? Нужно ли?';

CREATE TABLE n_StructType ( 
	StructTypeID bigint NOT NULL,    --  Первичный ключ 
	TypeName varchar(10),    --  Имя типа данных  
	FieldName varchar(20)    --  Имя поля таблицы TestData, соответствующее типу данных: 1 - Double- DataDouble 2- Bool - DataBool ..... 
);
COMMENT ON TABLE n_StructType
    IS 'Нормативная таблица  соответствия типов данных система АССА и полей таблицы TestData для записи данных соответствующих типов. Таблица не имеет интерфейса и не редактируется пользователем Структура канала  ссылается на таблицу, указывая тип данных.';
COMMENT ON COLUMN n_StructType.StructTypeID
    IS 'Первичный ключ';
COMMENT ON COLUMN n_StructType.TypeName
    IS 'Имя типа данных ';
COMMENT ON COLUMN n_StructType.FieldName
    IS 'Имя поля таблицы TestData, соответствующее типу данных: 1 - Double- DataDouble 2- Bool - DataBool .....';

CREATE SEQUENCE n_property_propertyID_seq INCREMENT 1 START 1;

CREATE TABLE n_property ( 
	propertyID bigint DEFAULT nextval(('n_property_propertyID_seq'::text)::regclass) NOT NULL,
	propertyname char(50),
	propertytype integer,    --  Ссылка на перечисление типов свойств Нужно для корректного отображения Пока 4 типа 
	multiplicity boolean DEFAULT False,    --  Множественность: может/нет быть несколько значений этого свойства  у одного испытания 
	propertydescript varchar(250),    --  Текстовое описание свойства 
	disabled boolean DEFAULT False,
	lastupdate char(80)
);
COMMENT ON TABLE n_property
    IS 'справочник видов свойств Содержит имена свойств (тэгов). Заполняется администратором  Если свойство уже используется в каком то испытании - нельзя его поменять';
COMMENT ON COLUMN n_property.propertytype
    IS 'Ссылка на перечисление типов свойств Нужно для корректного отображения Пока 4 типа';
COMMENT ON COLUMN n_property.multiplicity
    IS 'Множественность: может/нет быть несколько значений этого свойства  у одного испытания';
COMMENT ON COLUMN n_property.propertydescript
    IS 'Текстовое описание свойства';

CREATE SEQUENCE propertyvariants_variantId_seq INCREMENT 1 START 1;

CREATE TABLE propertyvariants ( 
	variantId bigint DEFAULT nextval(('propertyvariants_variantId_seq'::text)::regclass) NOT NULL,
	propertyId bigint,    --  Ссылка на  свойство. Для чего значение 
	number integer,    --  номер элемента в списке. Используется для показа в нужном порядке  
	variantname varchar(50)
);
COMMENT ON TABLE propertyvariants
    IS 'Таблица предопределенных значений  - список. Используется только для типа свойства "список"';
COMMENT ON COLUMN propertyvariants.propertyId
    IS 'Ссылка на  свойство. Для чего значение';
COMMENT ON COLUMN propertyvariants.number
    IS 'номер элемента в списке. Используется для показа в нужном порядке ';

CREATE SEQUENCE testproperty_testpropertyid_seq INCREMENT 1 START 1;

CREATE TABLE testproperty ( 
	testpropertyid bigint DEFAULT nextval(('testproperty_testpropertyid_seq'::text)::regclass) NOT NULL,
	testid bigint,    --  ссылка на испытание 
	propertyid bigint,    --  Ссылка на вид свойства 
	testpropertyvalue varchar(50)    --  значение свойства. Хранится в виде строки Если это значение из списка - хранится это значение 
);
COMMENT ON TABLE testproperty
    IS 'Таблица свойств испытания';
COMMENT ON COLUMN testproperty.testid
    IS 'ссылка на испытание';
COMMENT ON COLUMN testproperty.propertyid
    IS 'Ссылка на вид свойства';
COMMENT ON COLUMN testproperty.testpropertyvalue
    IS 'значение свойства. Хранится в виде строки Если это значение из списка - хранится это значение';

CREATE SEQUENCE Test_TestID_seq INCREMENT 1 START 1;

CREATE TABLE Test ( 
	TestID bigint DEFAULT nextval(('Test_TestID_seq'::text)::regclass) NOT NULL,
	polygonid bigint NOT NULL,    --  Место проведения испытаний - ссылка на полигон 
	TestName varchar(150) NOT NULL,    --  Название испытания 
	TestDate date DEFAULT now()::date NOT NULL,    --  Дата испытания/ Умолчание - текущая дата 
	TestDescript varchar(850),    --  Краткое словесное описание испытания 
	TestStatus integer,    --  Служебное поле. Статус испытания  1 - готово для анализа - все данные занесены 0 - не готово, не все данные занесены.  не может использоваться    
	LastUpdate varchar(80),    --  Служебное поле.Последнее изменение Кто -когда-откуда 
	TS timestamp
);
COMMENT ON TABLE Test
    IS 'Таблица Испытаний. Здесь описаны испытания ';
COMMENT ON COLUMN Test.polygonid
    IS 'Место проведения испытаний - ссылка на полигон';
COMMENT ON COLUMN Test.TestName
    IS 'Название испытания';
COMMENT ON COLUMN Test.TestDate
    IS 'Дата испытания/ Умолчание - текущая дата';
COMMENT ON COLUMN Test.TestDescript
    IS 'Краткое словесное описание испытания';
COMMENT ON COLUMN Test.TestStatus
    IS 'Служебное поле. Статус испытания  1 - готово для анализа - все данные занесены 0 - не готово, не все данные занесены.  не может использоваться   ';
COMMENT ON COLUMN Test.LastUpdate
    IS 'Служебное поле.Последнее изменение Кто -когда-откуда';

CREATE SEQUENCE TestData_TestDataID_seq INCREMENT 1 START 1;

CREATE TABLE TestData ( 
	TestDataID bigint DEFAULT nextval(('TestData_TestDataID_seq'::text)::regclass) NOT NULL,    --  Первичный ключ 
	Testid bigint NOT NULL,    --  Ссылка на заголовок испытания 
	DeviceID bigint,    --  Ссылка на таблицу "Приборы испытания"  . Указывает на прибор испытания, с которого получены данные  
	ChannelID bigint,    --  Ссылка на канал прибора испытания: из какого канала этого прибора поступило данное 
	ChannelOrder integer,    --  Номер канала в приборе. Номер формируется из связной таблицы "прибор-канал", и позволяет однозначно задавать данные конкретного канала в испытании  
	ChannelStructID bigint,    --  Позиция  элемента  в структуре канала  Описывает, какой это элемент из структуры канала. Позволяет по структуре определить физический смысл и тип величины 
	DataPortionNumber integer DEFAULT 1,    --  Номер порции данных (1,2,3......) Присваивается при записи данных  
	DataDouble double precision,    --  Данные типа Double 
	DataInteger integer,
	DataReal real,
	DataBool boolean,    --  Данные типа Boolean 
	DataDatetime timestamp,
	DataMask double precision,    --  Данные типа Mask преобразованные по коэффициентам описания канала 
	DataMaskCode varchar(6),    --  Для данных тип=Mask    храним код, который нужно рабирать (до преобразования). для остальных NULL. - не используется Считаем, что максимальное значение занимает не более 6 байт (48 бит) 
	DataString varchar(50),    --  Поле для строковых данных.  Здесь же записывается имя файла для неструктурированных данных неизвестной структуры ( Тип данных = STREAM)  Для других типов  данных NULL не используется. В поле хранится путь и имя файла, где лежат эти неструктурированные  данные для текущей порции данных. Используется, если свой файл привязывается к каждой порции данных. Напрример, к каждому значению времени (структурированное данное канала) привязывается фотокадр - (неструктурированное данное  канала) 
	DataLong bigint,    --  Данные типа  Long - большие целые числа 
	DataVal varchar(100)    --  Оставлено временно для синхронизации со старой версией Значение измеряемой величины в виде строки. 
);
COMMENT ON TABLE TestData
    IS 'Таблица данных испытаний, полученных с прибора  Данные расположены пакетами (порциями). Каждая поряция представляет собой однотипный по структуре набор данных, полученных с прибора.  (Deviceid - channelId - ChannelOrderNumber ) уникальный ключ данных конкретного  канала прибора Может быть одна порция, а может быть несколько порций данных. Например, данные получаемыек с интервалом в 5 минут:  каждая порция - это набор данных в определенный момент времени. А каждая следующая порция  - набор тех же данных,  но полученных  через 5 минут после предудущей порции.';
COMMENT ON COLUMN TestData.TestDataID
    IS 'Первичный ключ';
COMMENT ON COLUMN TestData.Testid
    IS 'Ссылка на заголовок испытания';
COMMENT ON COLUMN TestData.DeviceID
    IS 'Ссылка на таблицу "Приборы испытания"  . Указывает на прибор испытания, с которого получены данные ';
COMMENT ON COLUMN TestData.ChannelID
    IS 'Ссылка на канал прибора испытания: из какого канала этого прибора поступило данное';
COMMENT ON COLUMN TestData.ChannelOrder
    IS 'Номер канала в приборе. Номер формируется из связной таблицы "прибор-канал", и позволяет однозначно задавать данные конкретного канала в испытании ';
COMMENT ON COLUMN TestData.ChannelStructID
    IS 'Позиция  элемента  в структуре канала  Описывает, какой это элемент из структуры канала. Позволяет по структуре определить физический смысл и тип величины';
COMMENT ON COLUMN TestData.DataPortionNumber
    IS 'Номер порции данных (1,2,3......) Присваивается при записи данных ';
COMMENT ON COLUMN TestData.DataDouble
    IS 'Данные типа Double';
COMMENT ON COLUMN TestData.DataBool
    IS 'Данные типа Boolean';
COMMENT ON COLUMN TestData.DataMask
    IS 'Данные типа Mask преобразованные по коэффициентам описания канала';
COMMENT ON COLUMN TestData.DataMaskCode
    IS 'Для данных тип=Mask    храним код, который нужно рабирать (до преобразования). для остальных NULL. - не используется Считаем, что максимальное значение занимает не более 6 байт (48 бит)';
COMMENT ON COLUMN TestData.DataString
    IS 'Поле для строковых данных.  Здесь же записывается имя файла для неструктурированных данных неизвестной структуры ( Тип данных = STREAM)  Для других типов  данных NULL не используется. В поле хранится путь и имя файла, где лежат эти неструктурированные  данные для текущей порции данных. Используется, если свой файл привязывается к каждой порции данных. Напрример, к каждому значению времени (структурированное данное канала) привязывается фотокадр - (неструктурированное данное  канала)';
COMMENT ON COLUMN TestData.DataLong
    IS 'Данные типа  Long - большие целые числа';
COMMENT ON COLUMN TestData.DataVal
    IS 'Оставлено временно для синхронизации со старой версией Значение измеряемой величины в виде строки.';

CREATE SEQUENCE TestDevice_TestDeviceID_seq INCREMENT 1 START 1;

CREATE TABLE TestDevice ( 
	TestDeviceID bigint DEFAULT nextval(('TestDevice_TestDeviceID_seq'::text)::regclass) NOT NULL,    --  Уникальный первичный ключ 
	TestID bigint NOT NULL,    --  Ссылка на испытание, в котором участвует данный прибор 
	DeviceID bigint NOT NULL,    --  Ссылка на прибор 
	devicedescript varchar(250) DEFAULT 0,    --  Текстовое описание использования прибора в испытании 
	lastupdate varchar(80)
);
COMMENT ON TABLE TestDevice
    IS 'Таблица Приборы испытания  Cвязная таблица содежит данные о приборах каждого испытания. содержит ссылку на (испытание - прибор) ';
COMMENT ON COLUMN TestDevice.TestDeviceID
    IS 'Уникальный первичный ключ';
COMMENT ON COLUMN TestDevice.TestID
    IS 'Ссылка на испытание, в котором участвует данный прибор';
COMMENT ON COLUMN TestDevice.DeviceID
    IS 'Ссылка на прибор';
COMMENT ON COLUMN TestDevice.devicedescript
    IS 'Текстовое описание использования прибора в испытании';

CREATE SEQUENCE TestFile_TestFileID_seq INCREMENT 1 START 1;

CREATE TABLE TestFile ( 
	TestFileID bigint DEFAULT nextval(('TestFile_TestFileID_seq'::text)::regclass) NOT NULL,    --  Уникальный первичный ключ 
	Testid bigint NOT NULL,    --  Ссылка на  испытание 
	DeviceID bigint,    --  Ссылка на прибор,  с которого получен поток 
	Channelid bigint,    --  Ссылка на канал прибора, с которым связан текущий файл данных  
	ChannelOrder integer,    --  Номер канала в приборе. Номер формируется из связной таблицы "прибор-канал", и позволяет однозначно задавать данные конкретного канала в испытании  
	InternalFileName varchar(50),    --  Внутренне имя файла (в накопителе системы ACCA , куда кладется исходный файл данных)  Для имени используется GUID 
	ExternalFileName varchar(100),    --  Имя файла, в котором поступают исходные данные (внешнее) 
	md5Sum varchar(128) NOT NULL,    --  Контрольная сумма файла. Вычисляется при записи файла в хранилище по алгоритму md5 
	FileDescript varchar(500),    --  Дополнительное текстовое описание  файла данных. Неструктурировано. 
	LastUpdate varchar(80)    --  Служебное поле.Последнее изменение Кто -когда-откуда 
);
COMMENT ON TABLE TestFile
    IS 'Таблица прикрепленных файлов. В ней описаны файлы, пришедчие с канала  прибора в  испытании и даны ссылки на мeсто расположения этих файлов,  Файл привязан не к каждой порции данных канала, а является общим для всех порций данных . Это используется для хранения неструктурированных  - потоковых данных, которые хранятся в виде отдельного файла. Это может быть файл видеопотока, звуовой файл и т.п. Например, каждая порция данных содержит время и координату, а файл данных содержит видеопоток.';
COMMENT ON COLUMN TestFile.TestFileID
    IS 'Уникальный первичный ключ';
COMMENT ON COLUMN TestFile.Testid
    IS 'Ссылка на  испытание';
COMMENT ON COLUMN TestFile.DeviceID
    IS 'Ссылка на прибор,  с которого получен поток';
COMMENT ON COLUMN TestFile.Channelid
    IS 'Ссылка на канал прибора, с которым связан текущий файл данных ';
COMMENT ON COLUMN TestFile.ChannelOrder
    IS 'Номер канала в приборе. Номер формируется из связной таблицы "прибор-канал", и позволяет однозначно задавать данные конкретного канала в испытании ';
COMMENT ON COLUMN TestFile.InternalFileName
    IS 'Внутренне имя файла (в накопителе системы ACCA , куда кладется исходный файл данных)  Для имени используется GUID';
COMMENT ON COLUMN TestFile.ExternalFileName
    IS 'Имя файла, в котором поступают исходные данные (внешнее)';
COMMENT ON COLUMN TestFile.md5Sum
    IS 'Контрольная сумма файла. Вычисляется при записи файла в хранилище по алгоритму md5';
COMMENT ON COLUMN TestFile.FileDescript
    IS 'Дополнительное текстовое описание  файла данных. Неструктурировано.';
COMMENT ON COLUMN TestFile.LastUpdate
    IS 'Служебное поле.Последнее изменение Кто -когда-откуда';

CREATE SEQUENCE VPM_VPMID_seq INCREMENT 1 START 1;

CREATE TABLE VPM ( 
	VPMID bigint DEFAULT nextval(('VPM_VPMID_seq'::text)::regclass) NOT NULL,
	VPMName varchar(50),    --  Текстовое имя ВПМ  - название  ВПМ для вывода списков 
	VPMDescript varchar(500),    --  Текстовое описание ВПМ. 
	VPMstatus integer DEFAULT 0,    --  Статус  ВПМ: 0 - требует регистрации, 1 - зарегистрирован, 2 - заблокирован, и т.п. 
	datestatus date,    --  Дата последнего  изменения статуса ВПМ 
	dateversion date,    --  Дата изменения версии ВПМ 
	manifest text,    --  Текст манифеста, в котором хранятся параметры и зависимости ВПМ 
	PackageFileName text,    --  Имя файла- пакета ВПМ 
	LastUpdate varchar(80)
);
COMMENT ON TABLE VPM
    IS 'Справочник ВПМ Содержит список ВПМ, которые либо уже зарегистрированы в ASSA, либо разработаны и планируются к регистрации. У ВПМ есть реквизит статус, который и показывает, в каком состоянии находится VPM.   Каждый VPM  представляет собой пакет (Zip файл), который содержит dll модуль ВПМ, список необходимых зависимостей,  дополнительные характеристики ВПМ (автор, код, тип , номер версии и т.п.) которые хранятся в манифесте  пакета. VPM содержит описание того, что он делает. Это описание доступно пользователю при выборе нужного ему VPM  Текстовое описание и манифест хранятся в таблице VPM.  Сам модуль хранится в хранилище АССА, куда он помещается после регистрации..';
COMMENT ON COLUMN VPM.VPMName
    IS 'Текстовое имя ВПМ  - название  ВПМ для вывода списков';
COMMENT ON COLUMN VPM.VPMDescript
    IS 'Текстовое описание ВПМ.';
COMMENT ON COLUMN VPM.VPMstatus
    IS 'Статус  ВПМ: 0 - требует регистрации, 1 - зарегистрирован, 2 - заблокирован, и т.п.';
COMMENT ON COLUMN VPM.datestatus
    IS 'Дата последнего  изменения статуса ВПМ';
COMMENT ON COLUMN VPM.dateversion
    IS 'Дата изменения версии ВПМ';
COMMENT ON COLUMN VPM.manifest
    IS 'Текст манифеста, в котором хранятся параметры и зависимости ВПМ';
COMMENT ON COLUMN VPM.PackageFileName
    IS 'Имя файла- пакета ВПМ';

CREATE SEQUENCE Channel_ChannelID_seq INCREMENT 1 START 1;

CREATE TABLE Channel ( 
	ChannelID bigint DEFAULT nextval(('Channel_ChannelID_seq'::text)::regclass) NOT NULL,    --  Уникальный первичный ключ 
	ChannelCode varchar(20),    --  внешний Код канала. Может использоваться в будущем для дополнительной идентификации пользователями при взаимодействии с другими системами. Пока не используется 
	ChannelName varchar(50) NOT NULL,    --  Имя канала. Отражает физический смысл данных, передаваемых в этом канале. Например: коордитнаты и время, Скорость и координаты 
	ChannelDescript varchar(250),    --  Текстовое описание канала 
	LastUpdate varchar(80),    --  Служебное поле.Последнее изменение Кто -когда-откуда  
	TS timestamp    --  Метка последнего изменения 
);
COMMENT ON TABLE Channel
    IS 'Таблица Канал информации';
COMMENT ON COLUMN Channel.ChannelID
    IS 'Уникальный первичный ключ';
COMMENT ON COLUMN Channel.ChannelCode
    IS 'внешний Код канала. Может использоваться в будущем для дополнительной идентификации пользователями при взаимодействии с другими системами. Пока не используется';
COMMENT ON COLUMN Channel.ChannelName
    IS 'Имя канала. Отражает физический смысл данных, передаваемых в этом канале. Например: коордитнаты и время, Скорость и координаты';
COMMENT ON COLUMN Channel.ChannelDescript
    IS 'Текстовое описание канала';
COMMENT ON COLUMN Channel.LastUpdate
    IS 'Служебное поле.Последнее изменение Кто -когда-откуда ';
COMMENT ON COLUMN Channel.TS
    IS 'Метка последнего изменения';

CREATE SEQUENCE ChannelStruct_ChannelStructID_seq INCREMENT 1 START 1;

CREATE TABLE ChannelStruct ( 
	ChannelStructID bigint DEFAULT nextval(('ChannelStruct_ChannelStructID_seq'::text)::regclass) NOT NULL,
	ChannelID bigint NOT NULL,
	StructType bigint NOT NULL,    --  Тип элемента во входном канале: по классификатору ValueType. I\ F\ .М - mask, S -stream   Ссылка на n_structtype 
	StructOrder integer DEFAULT 1,    --  Номер элемента во входном  канале (1, 2....) 
	StructCode char(10),    --  Внешний уникальный код величины/ Уникальность должна быть внутри канала. Создается автоматически Резерв на будущее. сейчас не используется 
	StructName varchar(50),    --  Название величины (может повторяться) 
	StructDescript varchar(250),    --  Текстовое описание величины. По нему пользователь сможет выбрать, какая величина его интересует 
	BStart integer,    --  C какого бита начинается величина из битового поля. Для типа MASK. Для остальных типов не используется 
	BFinish integer,    --  По какой бит берется величина из битового поля. Для типа MASK. Для остальных типов не используется 
	Bkoef1 real,    --  множитель Используется для битового поля. Для остальных NULL  
	Bkoef2 real,    --  сдвиг/ Используется для битового поля. Для остальных NULL  
	Fpath char(50),    --  Путь к содержимому файла. Используется для неструктурированного данного (Тип =stream). Эта информация не разбирается и не анализируется. Она только кладется и берется. 
	LastUpdate varchar(80)    --  Служебное поле.Последнее изменение Кто -когда-откуда 
);
COMMENT ON TABLE ChannelStruct
    IS 'Элементы канала Описана структура канала, его элементы и тип этих элементов. Тип каждого элемента  берется из перечисления ';
COMMENT ON COLUMN ChannelStruct.StructType
    IS 'Тип элемента во входном канале: по классификатору ValueType. I\ F\ .М - mask, S -stream   Ссылка на n_structtype';
COMMENT ON COLUMN ChannelStruct.StructOrder
    IS 'Номер элемента во входном  канале (1, 2....)';
COMMENT ON COLUMN ChannelStruct.StructCode
    IS 'Внешний уникальный код величины/ Уникальность должна быть внутри канала. Создается автоматически Резерв на будущее. сейчас не используется';
COMMENT ON COLUMN ChannelStruct.StructName
    IS 'Название величины (может повторяться)';
COMMENT ON COLUMN ChannelStruct.StructDescript
    IS 'Текстовое описание величины. По нему пользователь сможет выбрать, какая величина его интересует';
COMMENT ON COLUMN ChannelStruct.BStart
    IS 'C какого бита начинается величина из битового поля. Для типа MASK. Для остальных типов не используется';
COMMENT ON COLUMN ChannelStruct.BFinish
    IS 'По какой бит берется величина из битового поля. Для типа MASK. Для остальных типов не используется';
COMMENT ON COLUMN ChannelStruct.Bkoef1
    IS 'множитель Используется для битового поля. Для остальных NULL ';
COMMENT ON COLUMN ChannelStruct.Bkoef2
    IS 'сдвиг/ Используется для битового поля. Для остальных NULL ';
COMMENT ON COLUMN ChannelStruct.Fpath
    IS 'Путь к содержимому файла. Используется для неструктурированного данного (Тип =stream). Эта информация не разбирается и не анализируется. Она только кладется и берется.';
COMMENT ON COLUMN ChannelStruct.LastUpdate
    IS 'Служебное поле.Последнее изменение Кто -когда-откуда';

CREATE SEQUENCE Device_DeviceID_seq INCREMENT 1 START 1;

CREATE TABLE Device ( 
	DeviceID bigint DEFAULT nextval(('Device_DeviceID_seq'::text)::regclass) NOT NULL,
	DeviceTypeID bigint NOT NULL,    --  Ссылка на тип прибора 
	DeviceName varchar(50),    --  Название прибора 
	DeviceSerialnumber char(20),    --  Уникальный  внешний код. Например, заводской серийный номер прибора.  Уникальность поддерживается внутри приборов одного типа. Внутри приборов одного типа Этот параметрт уникальный 
	DeviceDescript varchar(250),    --  Текстовое описание 
	RegUserID integer,    --  Автор регистрации прибора в системе АССА 
	RegDate date,    --  Дата регистрации прибора в системе АССА 
	IsActive boolean DEFAULT TRUE,
	LastUpdate varchar(80)    --  Служебное поле. Строка последнего изменения Кто -когда-откуда 
);
COMMENT ON COLUMN Device.DeviceTypeID
    IS 'Ссылка на тип прибора';
COMMENT ON COLUMN Device.DeviceName
    IS 'Название прибора';
COMMENT ON COLUMN Device.DeviceSerialnumber
    IS 'Уникальный  внешний код. Например, заводской серийный номер прибора.  Уникальность поддерживается внутри приборов одного типа. Внутри приборов одного типа Этот параметрт уникальный';
COMMENT ON COLUMN Device.DeviceDescript
    IS 'Текстовое описание';
COMMENT ON COLUMN Device.RegUserID
    IS 'Автор регистрации прибора в системе АССА';
COMMENT ON COLUMN Device.RegDate
    IS 'Дата регистрации прибора в системе АССА';
COMMENT ON COLUMN Device.LastUpdate
    IS 'Служебное поле. Строка последнего изменения Кто -когда-откуда';

CREATE SEQUENCE DeviceChannel_DevicechannelID_seq INCREMENT 1 START 1;

CREATE TABLE DeviceChannel ( 
	DevicechannelID bigint DEFAULT nextval(('DeviceChannel_DevicechannelID_seq'::text)::regclass) NOT NULL,    --  Уникальный ID 
	DeviceTypeID bigint,    --  Ссылка на тип прибора в который входит канал 
	ChannelID bigint,    --  Ссылка на канал.  
	ChannelOrder integer    --  Номер канала в списке каналов прибора 
);
COMMENT ON TABLE DeviceChannel
    IS 'Связная таблица соответствия каналов и типов приборов: Содержит список соответствий каналов, входящих в  тип прибора и типов прибоа, использующих канал.';
COMMENT ON COLUMN DeviceChannel.DevicechannelID
    IS 'Уникальный ID';
COMMENT ON COLUMN DeviceChannel.DeviceTypeID
    IS 'Ссылка на тип прибора в который входит канал';
COMMENT ON COLUMN DeviceChannel.ChannelID
    IS 'Ссылка на канал. ';
COMMENT ON COLUMN DeviceChannel.ChannelOrder
    IS 'Номер канала в списке каналов прибора';

CREATE SEQUENCE Devicecontent_ID_seq INCREMENT 1 START 1;

CREATE TABLE Devicecontent ( 
	ID bigint DEFAULT nextval(('Devicecontent_ID_seq'::text)::regclass) NOT NULL,    --  Уникальный первичный ключ 
	DeviceID bigint,    --  Ссылк на прибор, который является композитом 
	DevicecontentID bigint,    --  Ссылка на прибор, входящий в композит. Для каждого композита может быть несколько записей 
	ContentNumber integer,    --  Номер прибора - части в списке состава композита. Номер присваивается автоматически при добавлении нового прибора в состав композита. Максимальный номер - показывает количество приборов  в составе композита Используется для контроля истории изменений этого элемента в списке приборов прибора-клмпозита 
	ContentDate date    --  Дата включения прибора в состав приборов композита. Она может меняться при замене одного прибора на другой того же типа в составе одного и того же композита. 
);
COMMENT ON TABLE Devicecontent
    IS 'Связная таблица, описывающая вхождение одних приборов, в состав других. Для составных приборов (композитов)  содержит список приборов, входящих в его состав. По столбцу DeviceIO можно ообрать приборы композиты По столбцу DeviceContentID можно отобрать приборы, входящие в состав других приборов';
COMMENT ON COLUMN Devicecontent.ID
    IS 'Уникальный первичный ключ';
COMMENT ON COLUMN Devicecontent.DeviceID
    IS 'Ссылк на прибор, который является композитом';
COMMENT ON COLUMN Devicecontent.DevicecontentID
    IS 'Ссылка на прибор, входящий в композит. Для каждого композита может быть несколько записей';
COMMENT ON COLUMN Devicecontent.ContentNumber
    IS 'Номер прибора - части в списке состава композита. Номер присваивается автоматически при добавлении нового прибора в состав композита. Максимальный номер - показывает количество приборов  в составе композита Используется для контроля истории изменений этого элемента в списке приборов прибора-клмпозита';
COMMENT ON COLUMN Devicecontent.ContentDate
    IS 'Дата включения прибора в состав приборов композита. Она может меняться при замене одного прибора на другой того же типа в составе одного и того же композита.';

CREATE SEQUENCE DeviceType_DeviceTypeID_seq INCREMENT 1 START 1;

CREATE TABLE DeviceType ( 
	DeviceTypeID bigint DEFAULT nextval(('DeviceType_DeviceTypeID_seq'::text)::regclass) NOT NULL,
	DCIM char(16) NOT NULL,    --  Внешний уникальный код типа прибора 
	DevTypeName varchar(50),    --  Наименование типа прибора. Не повторяется 
	DevTypeDescript varchar(250),    --  Текстовое описание типа прибора 
	LastUpdate varchar(80)    --  Служебное поле.Последнее изменение Кто -когда-откуда 
);
COMMENT ON TABLE DeviceType
    IS 'Тип прибора. Классификатор, объединяющий группу одинаковых по структуре приборов. У всех приборов одного типа - одинаковая структура: одинаковая иерархия и набор каналов. Приборы одного типа отличаются серийными номерами, именами  и описаниями У всех приборов приборов одного типа одинаковый DCIM';
COMMENT ON COLUMN DeviceType.DCIM
    IS 'Внешний уникальный код типа прибора';
COMMENT ON COLUMN DeviceType.DevTypeName
    IS 'Наименование типа прибора. Не повторяется';
COMMENT ON COLUMN DeviceType.DevTypeDescript
    IS 'Текстовое описание типа прибора';
COMMENT ON COLUMN DeviceType.LastUpdate
    IS 'Служебное поле.Последнее изменение Кто -когда-откуда';

CREATE SEQUENCE DeviceTypecontent_ID_seq INCREMENT 1 START 1;

CREATE TABLE DeviceTypecontent ( 
	ID bigint DEFAULT nextval(('DeviceTypecontent_ID_seq'::text)::regclass) NOT NULL,
	DeviceTypeID bigint,    --  Ссылка на тип прибора, для которого описывается состав 
	ContDevtypeID bigint,    --  Ссылка на тип прибора, который входит в состав текущего 
	contentNumber integer
);
COMMENT ON TABLE DeviceTypecontent
    IS 'Связная таблица: список других типов приборов, входящих в текущий тип. Может отсутствовать. Нужна если в состав прибора входят другие приборы. Если другой прибор входит в текущий , то всей структурой позволяет описать вложенную структуру приборов.';
COMMENT ON COLUMN DeviceTypecontent.DeviceTypeID
    IS 'Ссылка на тип прибора, для которого описывается состав';
COMMENT ON COLUMN DeviceTypecontent.ContDevtypeID
    IS 'Ссылка на тип прибора, который входит в состав текущего';

CREATE SEQUENCE n_polygon_polygonid_seq INCREMENT 1 START 1;

CREATE TABLE n_polygon ( 
	polygonid bigint DEFAULT nextval(('n_polygon_polygonid_seq'::text)::regclass) NOT NULL,
	polygonname varchar(150) NOT NULL,    --  Имя полигона 
	address varchar(200),
	primech varchar(200),    --  Произвольный текст 
	Lastupdate varchar(80)
);
COMMENT ON TABLE n_polygon
    IS 'Справочник полигонов - мест проведения испытаний. Каждое испытание проводится на определенном полигоне';
COMMENT ON COLUMN n_polygon.polygonname
    IS 'Имя полигона';
COMMENT ON COLUMN n_polygon.primech
    IS 'Произвольный текст';


ALTER TABLE Constants ADD CONSTRAINT PK_Constants 
	PRIMARY KEY (ConstantID);


ALTER TABLE protocol ADD CONSTRAINT PK_protocol 
	PRIMARY KEY (protocolid);


ALTER TABLE n_role ADD CONSTRAINT PK_n_role 
	PRIMARY KEY (roleid);


ALTER TABLE userrights ADD CONSTRAINT PK_userright 
	PRIMARY KEY (userrightid);


ALTER TABLE userroles ADD CONSTRAINT PK_userroles 
	PRIMARY KEY (ur_id);


ALTER TABLE users ADD CONSTRAINT PK_users 
	PRIMARY KEY (userid);


ALTER TABLE n_StructType ADD CONSTRAINT PK_n_StructType 
	PRIMARY KEY (StructTypeID);


ALTER TABLE n_property ADD CONSTRAINT PK_n_property 
	PRIMARY KEY (propertyID);


ALTER TABLE propertyvariants ADD CONSTRAINT PK_propertyvariants 
	PRIMARY KEY (variantId);


ALTER TABLE testproperty ADD CONSTRAINT PK_testproperty 
	PRIMARY KEY (testpropertyid);


ALTER TABLE Test ADD CONSTRAINT PK_Test 
	PRIMARY KEY (TestID);


ALTER TABLE TestData ADD CONSTRAINT PK_TestData 
	PRIMARY KEY (TestDataID);


ALTER TABLE TestDevice ADD CONSTRAINT PK_TestDevice 
	PRIMARY KEY (TestDeviceID);


ALTER TABLE TestFile ADD CONSTRAINT PK_TestFile 
	PRIMARY KEY (TestFileID);


ALTER TABLE VPM ADD CONSTRAINT PK_VPM 
	PRIMARY KEY (VPMID);


ALTER TABLE Channel ADD CONSTRAINT PK_Channel 
	PRIMARY KEY (ChannelID);


ALTER TABLE ChannelStruct ADD CONSTRAINT PK_Channelctruct 
	PRIMARY KEY (ChannelStructID);


ALTER TABLE Device ADD CONSTRAINT PK_Device 
	PRIMARY KEY (DeviceID);


ALTER TABLE DeviceChannel ADD CONSTRAINT PK_DeviceChannel 
	PRIMARY KEY (DevicechannelID);


ALTER TABLE Devicecontent ADD CONSTRAINT PK_Devicecontent 
	PRIMARY KEY (ID);


ALTER TABLE DeviceType ADD CONSTRAINT PK_DeviceType 
	PRIMARY KEY (DeviceTypeID);


ALTER TABLE DeviceTypecontent ADD CONSTRAINT PK_DeviceTypecontent 
	PRIMARY KEY (ID);


ALTER TABLE n_polygon ADD CONSTRAINT PK_polygon 
	PRIMARY KEY (polygonid);



ALTER TABLE n_property
	ADD CONSTRAINT UQ_n_property_propertyname UNIQUE (propertyname);
ALTER TABLE Channel
	ADD CONSTRAINT UQ_Channel_ChannelName UNIQUE (ChannelName);
ALTER TABLE DeviceType
	ADD CONSTRAINT UQ_DeviceType_DCIM UNIQUE (DCIM);
ALTER TABLE n_polygon
	ADD CONSTRAINT UQ_n_polygon_polygonname UNIQUE (polygonname);

ALTER TABLE userrights ADD CONSTRAINT FK_userrights_users 
	FOREIGN KEY (userid) REFERENCES users (userid);

ALTER TABLE userroles ADD CONSTRAINT FK_userroles_n_role 
	FOREIGN KEY (roleid) REFERENCES n_role (roleid);

ALTER TABLE userroles ADD CONSTRAINT FK_userroles_users 
	FOREIGN KEY (userid) REFERENCES users (userid);

ALTER TABLE propertyvariants ADD CONSTRAINT FK_propertyvariants_n_property 
	FOREIGN KEY (propertyId) REFERENCES n_property (propertyID);

ALTER TABLE testproperty ADD CONSTRAINT FK_testproperty_Test 
	FOREIGN KEY (testid) REFERENCES Test (TestID);

ALTER TABLE testproperty ADD CONSTRAINT FK_testproperty_n_property 
	FOREIGN KEY (propertyid) REFERENCES n_property (propertyID);

ALTER TABLE Test ADD CONSTRAINT FK_Test_n_polygon 
	FOREIGN KEY (polygonid) REFERENCES n_polygon (polygonid);

ALTER TABLE TestData ADD CONSTRAINT FK_TestData_Device 
	FOREIGN KEY (DeviceID) REFERENCES Device (DeviceID);

ALTER TABLE TestData ADD CONSTRAINT FK_TestData_Test 
	FOREIGN KEY (Testid) REFERENCES Test (TestID);

ALTER TABLE TestDevice ADD CONSTRAINT FK_TestDevice_Device 
	FOREIGN KEY (DeviceID) REFERENCES Device (DeviceID);

ALTER TABLE TestDevice ADD CONSTRAINT FK_TestDevice_Test 
	FOREIGN KEY (TestID) REFERENCES Test (TestID);

ALTER TABLE TestFile ADD CONSTRAINT FK_TestFile_Device 
	FOREIGN KEY (DeviceID) REFERENCES Device (DeviceID);

ALTER TABLE TestFile ADD CONSTRAINT FK_TestFile_Test 
	FOREIGN KEY (Testid) REFERENCES Test (TestID);

ALTER TABLE ChannelStruct ADD CONSTRAINT FK_ChannelStruct_Channel 
	FOREIGN KEY (ChannelID) REFERENCES Channel (ChannelID);

ALTER TABLE Device ADD CONSTRAINT FK_Device_DeviceType 
	FOREIGN KEY (DeviceTypeID) REFERENCES DeviceType (DeviceTypeID);

ALTER TABLE DeviceChannel ADD CONSTRAINT FK_DeviceChannel_Channel 
	FOREIGN KEY (ChannelID) REFERENCES Channel (ChannelID);

ALTER TABLE DeviceChannel ADD CONSTRAINT FK_DeviceChannel_DeviceType 
	FOREIGN KEY (DeviceTypeID) REFERENCES DeviceType (DeviceTypeID);

ALTER TABLE Devicecontent ADD CONSTRAINT FK_DevicecontentID1_Device 
	FOREIGN KEY (DeviceID) REFERENCES Device (DeviceID);

ALTER TABLE Devicecontent ADD CONSTRAINT FK_DevicecontentID_Device 
	FOREIGN KEY (DevicecontentID) REFERENCES Device (DeviceID);

ALTER TABLE DeviceTypecontent ADD CONSTRAINT FK_DeviceType_DeviceType 
	FOREIGN KEY (DeviceTypeID) REFERENCES DeviceType (DeviceTypeID);

ALTER TABLE DeviceTypecontent ADD CONSTRAINT FK_DeviceTypecontent_DeviceType 
	FOREIGN KEY (ContDevtypeID) REFERENCES DeviceType (DeviceTypeID);
