-- начальное заполнение каналов GPS  и видео

-- очистка каналов

Delete from channelstruct;
Delete from channel;

DROP SEQUENCE IF EXISTS channel_channelid_seq;
CREATE SEQUENCE channel_channelid_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE channel_channelid_seq
  OWNER TO assa;
  
DROP SEQUENCE IF EXISTS channelstruct_channelstructid_seq;
CREATE SEQUENCE channelstruct_channelstructid_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE channelstruct_channelstructid_seq
  OWNER TO assa;

-- добавление данных в таблицу channel
-- канал GPS (id=1)  и канал видео (id=2)
INSERT INTO channel (channelcode, channelname, channeldescript)
 VALUES ('Тип_1',  'GPS_1', 'Kанал описания данных GPS (по примеру закзчика)' ),
        ('Тип_2',  'VIDEO_1', 'Канал описания структуры видео (по примеру заказчика)');

 
-- добавление данных в таблицу channelstruct для GPS
INSERT INTO channelstruct (channelid, structtype, structorder, structname, structdescript)
 VALUES ( 1, 9, 1, 'Framenumber1', 'номер кадра ведущего'),
		( 1, 9, 2, 'Framenumber2', 'номер кадра ведомого'),
		( 1, 8, 3, 'UTChour', 'часы'),
		( 1, 8, 4, 'UTCmin',  'минуты'),
		( 1, 8, 5, 'UTCsec',  'секунды'),
		( 1, 8, 6, 'UTCms',   'миллисекунды'),
		( 1, 8, 7, 'UTCyy',    'год'),
		( 1, 8, 8, 'UTCmm',   'месяц'),
		( 1, 8, 9, 'UTCdd',   'день'),
		( 1, 7,10, 'Posfix',  'номер кадра ведущего'),
		( 1, 7,11, 'status',  'A-данные валидны, V - нет'),
		( 1, 7,12, 'SatUsed', '[GGA]используется спутников'),
		( 1, 1,13, 'HDOP',    '   '),
		( 1, 1,14, 'Lat',     'широта Южная– отрицательная, градус'),
		( 1, 1,15, 'Lon',     'долгота. Западная- отрицательная'),
		( 1, 1,16, 'Alt',     'высота'),
		( 1, 1,17, 'Speed',   'скорость миль/час'),
		( 1, 1,18, 'Course',  'курс в градусах');
 
 -- добавление данных в таблицу channelstruct для видео
INSERT INTO channelstruct (channelid, structtype, structorder, structname, structdescript) 
   VALUES 
		(2, 7, 1, 'format',       ' форомат файла'),
		(2, 7, 2, 'Videoformat',  ' '),
		(2, 3, 3, 'BitRate',      ' '),
		(2, 8, 4, 'Width',        'пикселов по горизонтали'),
		(2, 8, 5, 'Height',       'пикселов по вертикали'),
		(2, 7, 6, 'FrameRate',    ' '),
		(2, 8, 7, 'samplerate',   'частота дискретизации аудиодорожки'),
		(2, 9, 8, 'duration',     'продолжительность видео в миллисекундах'),
		(2, 7, 9, 'videocodec',   'название кодека видео'),
		(2, 7,10, 'audiocodec',   'название кодека ацдио');
		


		

