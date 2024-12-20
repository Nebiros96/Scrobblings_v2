USE [musica_julian]
GO
/****** Object:  StoredProcedure [dbo].[cleaning_scrobblings]    Script Date: 16/10/2024 8:34:20 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Limpieza de datos
Se ejecuta la limpieza de datos principalmente para:
 1. Eliminar nombre del artista dentro del campo "Song"
 2. Evitar errores de lectura en caracteres no latinos (ej, alfabeto cirilico)
 3. Eliminar espacios en blanco tanto al comienzo como al final del string
 */
-- Creamos procedimiento almacenado para solo ejecutar
ALTER PROCEDURE [dbo].[cleaning_scrobblings] 
AS
BEGIN
	-- Burzum
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Black Spells of Destruction', 'Black Spell of Destruction')
		WHERE Artist='Burzum'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Channeling the Power of Souls into a New God', 'Channelling the Power of Souls Into a New God')
		WHERE Artist='Burzum' AND Album='Burzum';
	UPDATE Clean_LastfmData
		SET Song = REPLACE(REPLACE(Song, 'Burzum ',''),';','')
		WHERE Artist='Burzum'
	-- Proclamation
	UPDATE Clean_LastfmData
		SET Song = REPLACE(REPLACE(Song, 'Proclamation ',''),';','')
		WHERE Artist='Proclamation'
	-- 1349
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, '1349 ','')
		WHERE Artist='1349'
	-- Abigor
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'ABIGOR ','')
		WHERE Artist='Abigor'
	-- Bathory
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Bathory ','')
		WHERE Artist='Bathory'
	-- Inquisition
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Inquisition ','')
		WHERE Artist='Inquisition'
	-- Marduk
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Marduk ','')
		WHERE Artist='Marduk'
	-- Сыны Севера
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, N'Сыны Севера (Syny Severa) ','')
		WHERE Artist LIKE N'Сыны%'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Syny Severa ','')
		WHERE Artist LIKE N'Сыны%'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, N'Нет! (Net!)',N'Нет!')
		WHERE Artist LIKE N'Сыны%'
	-- System of a Down
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'System of a Down ','')
		WHERE Artist = 'System of a Down'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'ADD','A.D.D. (American Dream Denial)')
		WHERE Artist = 'System of a Down'
	UPDATE Clean_LastfmData
		SET Album = REPLACE(Album, 'Steal This Album','Steal This Album!')
		WHERE Artist = 'System of a Down'
	UPDATE Clean_LastfmData
		SET Album = REPLACE(Album, 'Steal This Album!!','Steal This Album!')
		WHERE Artist = 'System of a Down'
	UPDATE Clean_LastfmData
		SET Album = REPLACE(Album, 'System Of A Down (Bonus Pack)','System of a Down')
		WHERE Artist = 'System of a Down'
	UPDATE Clean_LastfmData
		SET	Song = REPLACE(Song, 'System Of A Down  ', '')
		WHERE Artist = 'System of a Down'
	UPDATE Clean_LastfmData
		SET	Song = REPLACE(Song, 'System Of  A Down   ', '')
		WHERE Artist = 'System of a Down'
	UPDATE Clean_LastfmData
		SET	Song = REPLACE(Song, 'System of a down ', '')
		WHERE Artist = 'System of a Down'
	-- Rompeprop
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'ROMPEPROP - ','')
		WHERE Artist = 'Rompeprop'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, '03-Embryoyo','Embryoyo')
		WHERE Artist = 'Rompeprop'
	-- Archgoat 
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Archgoat ','')
		WHERE Artist = 'Archgoat'
	-- Destroyer 666
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist,'Destroyer 666', 'Deströyer 666')
		WHERE Artist = 'Destroyer 666'
	-- Satanic Warmaster
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 20, LEN(Song))
		WHERE Artist='Satanic Warmaster' AND Song LIKE 'Satanic Warmaster%'
	-- Urgehal
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 11, LEN(Song))
		WHERE Artist='Urgehal' AND Song LIKE 'Urgehal%'
	-- Horna
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 6, LEN(Song))
		WHERE Artist='Horna' AND Song LIKE 'Horna%'
	-- Nargaroth
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 10, LEN(Song))
		WHERE Artist='Nargaroth' AND Song LIKE 'Nargaroth%'
	UPDATE Clean_LastfmData
		SET Song = COALESCE(NULLIF(Song,''),'Nargaroth')
		WHERE Artist = 'Nargaroth'
	-- Tsjuder
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 9, LEN(Song))
		WHERE Artist='Tsjuder' AND Song LIKE 'Tsjuder%'
	-- Judas Iscariot
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 18, LEN(Song))
		WHERE Artist='Judas Iscariot' AND Song LIKE 'Judas Iscariot%'
	-- Armagedda
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 12, LEN(Song))
		WHERE Artist='Armagedda' AND Song LIKE 'Armagedda%'
	-- Barbatos
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 11, LEN(Song))
		WHERE Artist='Barbatos' AND Song LIKE 'Barbatos%'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Jpn)   Satanik beer','Satanik Beer')
		WHERE Artist = 'Barbatos'
	-- Dark Funeral
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 14, LEN(Song))
		WHERE Artist='Dark Funeral' AND Song LIKE 'Dark Funeral%'
	-- Darkthrone
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 13, LEN(Song))
		WHERE Artist='Darkthrone' AND Song LIKE 'Darkthrone%'
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, -7, LEN(Song))
		WHERE Artist='Darkthrone' AND Song LIKE '%Studio'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Inn I De Dype Skogens Fabn','Inn I De Dype Skogens Favn')
		WHERE Artist = 'Darkthrone'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Inn I De Dype Skogens Favn ','Inn I De Dype Skogens Favn')
		WHERE Artist = 'Darkthrone'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Inn I De Dype Skogens Favn','Inn I De Dype Skogers Favn')
		WHERE Artist = 'Darkthrone'
	UPDATE Clean_LastfmData
		SET Album = COALESCE(NULLIF(Album,''),'Quintessence')
		WHERE Artist = 'Darkthrone'
		AND Song = 'Quintessence'
	-- Wolfnacht
	UPDATE Clean_LastfmData
		SET Album = REPLACE(Album, 'Toten fur W.O.T.A.N','Töten für W.O.T.A.N.')
		WHERE Artist = 'Wolfnacht'
	-- Anorexia Nervosa
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 18, LEN(Song))
		WHERE Artist='Anorexia Nervosa' AND Song LIKE 'Anorexia Nervosa%'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Dirge And Requiem For My Sister Whore','Dirge & Requiem for My Sister Whore')
		WHERE Artist = 'Anorexia Nervosa'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Ordo Ab Chaos The Scarlet Communion','Ordo Ab Chao: The Scarlet Communion')
		WHERE Artist = 'Anorexia Nervosa'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Ordo Ab Chao : The Scarlet Communion','Ordo Ab Chao: The Scarlet Communion')
		WHERE Artist = 'Anorexia Nervosa'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Châtiment de la rose','Chatiment de la Rose')
		WHERE Artist = 'Anorexia Nervosa'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Das Ist Zum Erschiessen Schon','Das Ist Zum Erschiessen Schön')
		WHERE Artist = 'Anorexia Nervosa'
	UPDATE Clean_LastfmData
		SET Album = COALESCE(NULLIF(Album,''),'New Obscurantis Order')
		WHERE Artist = 'Anorexia Nervosa'
	-- Sarcófago
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'Sarcofago','Sarcófago')
		WHERE Artist = 'Sarcofago'
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 11, LEN(Song))
		WHERE Artist='Sarcófago' AND Song LIKE 'Sarcofago%'
	UPDATE Clean_LastfmData
		SET Album = REPLACE(Album, 'INRI','I.N.R.I.')
		WHERE Artist = 'Sarcófago'
	-- Brujería
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'Brujeria','Brujería')
		WHERE Artist = 'Brujeria'
	-- Drudkh
	UPDATE Clean_LastfmData
		SET Song = SUBSTRING(Song, 9, LEN(Song))
		WHERE Artist='Drudkh' AND Song LIKE 'Drudkh%'
	UPDATE Clean_LastfmData
		SET Album = REPLACE(Album, 'Betrayed by the Sun / Hagringar',N'Зраджені сонцем / Hägringar')
		WHERE Artist = 'Drudkh'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Betrayed by the Sun / Hagringar',N'Зраджені сонцем / Hägringar')
		WHERE Artist = 'Drudkh'
	UPDATE Clean_LastfmData
		SET Album = REPLACE(Album, N'Зраджені Сонцем',N'Зраджені сонцем / Hägringar')
		WHERE Artist = 'Drudkh'
	UPDATE Clean_LastfmData
		SET Album = REPLACE(Album, N'Зраджені сонцем / Hägringar / Hägringar',N'Зраджені сонцем / Hägringar')
		WHERE Artist = 'Drudkh'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'His Twenty-Fourth Spring','His Twenty Fourth Spring')
		WHERE Artist = 'Drudkh'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, N'Glare of Autumn - Відблиски Осені','Glare of Autumn')
		WHERE Artist = 'Drudkh'
	-- Deicide
	UPDATE Clean_LastfmData
		SET Album = REPLACE(Album, 'Deicide (Reissue)','Deicide')
		WHERE Artist = 'Deicide'
	-- Luna
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'Luna', N'Луна')
		WHERE Artist = 'Luna'
	-- Monethochka
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'MONETOCHKA', N'Монеточка')
		WHERE Artist = 'MONETOCHKA'
	-- Grechka
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'Grechka', N'Гречка')
		WHERE Artist = 'Grechka'
	-- Мы 
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'My', N'Мы')
		WHERE Artist = 'My'
	-- Свидание
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'Svidaniye', N'Свидание')
		WHERE Artist = 'Svidaniye'
	-- Metallica
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, ' - Remastered', '')
		WHERE Artist = 'Metallica'
	UPDATE Clean_LastfmData
		SET	Song = REPLACE(Song, 'Metallica - ', '')
		WHERE Artist = 'Metallica'
	UPDATE Clean_LastfmData
		SET	Song = REPLACE(Song, 'Metallica  ', '')
		WHERE Artist = 'Metallica'
	-- ICE (estandarización de nombre)
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'Imperial Crystalline Entombment I.C.E', 'Imperial Crystalline Entombment')
		WHERE Artist = 'Imperial Crystalline Entombment I.C.E'
	-- Mirele por Mirèle
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'Mirele', 'Mirèle')
		WHERE Artist = 'Mirele'
	-- Eliminamos caraceteres innecesarios en los nombres de las canciones
	UPDATE Clean_LastfmData
		SET Song = REPLACE(REPLACE(Song, '[HQ]', ''), '(Full Demo)', '')
		WHERE Song LIKE '%[HQ]%' OR Song LIKE '%(Full Demo)%'
	-- Canciones de Drudkh 
	UPDATE Clean_LastfmData
		SET Song = REPLACE(REPLACE(Song, 'Cursed Sons Pt. 1', 'Cursed Sons I'), 'Cursed Sons Pt. 2','Cursed Sons II')
		WHERE Artist = 'Drudkh'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(REPLACE(Song, 'Dishonour Pt. 1', 'Dishonour I'), 'Dishonour Pt. 2','Dishonour II')
		WHERE Artist = 'Drudkh'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Eternal Sun', N'Eternal Sun - Вiчне Сонце')
		WHERE Artist = 'Drudkh'
	UPDATE Clean_LastfmData
		SET Song = REPLACE(Song, 'Blood', N'Blood - Кров')
		WHERE Artist = 'Drudkh'
		AND CHARINDEX(N'Blood - Кров', Song) = 0
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'EDIONDO', 'Ediöndö')
		WHERE Artist = 'EDIONDO'
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'Rompeprop / Tu Carne', 'Rompeprop')
		WHERE Artist = 'Rompeprop / Tu Carne'
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'Basshunter feat. DJ Mental Theos Bazzheadz', 'Basshunter')
		WHERE Artist = 'Basshunter feat. DJ Mental Theos Bazzheadz'
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'AronChupa Little Sis Nora', 'AronChupa')
		WHERE Artist = 'AronChupa Little Sis Nora'
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'FUCK OF AND DIE', 'Fuck Off And Die!')
		WHERE Artist = 'FUCK OF AND DIE'
	UPDATE Clean_LastfmData
		SET Artist = REPLACE(Artist, 'Wu-Tang Clan Raekwon Ol'' Dirty Bastard Method Man', 'Wu-Tang Clan')
		WHERE Artist = 'Wu-Tang Clan Raekwon Ol'' Dirty Bastard Method Man';

	-- Arreglamos nombre de artistas
	UPDATE Clean_LastfmData
		SET Artist = CASE 
						WHEN Artist = 'Pest' AND Album LIKE '%Buried%' THEN 'Pest (GER)' ELSE Artist END 
	-- Eliminamos posibles L-Strings en el nombre de las canciones
	UPDATE Clean_LastfmData
	SET Song = LTRIM(Song);

	-- Eliminamos fechas cuyos campos sean NULL para evitar ruido en PBI
	DELETE FROM Clean_LastfmData WHERE Fecha IS NULL
END