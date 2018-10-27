Create Database sheep
GO

Use sheep
GO


Create Schema ActiveHerd
Go

Create Table ActiveHerd.shepherd(
	ShepherdId int IDENTITY(1,1) PRIMARY KEY,
	LastName varchar(30),
	FirstName varchar(30),
	ShepardCertification char(1) NOT NULL
	);
GO

Create Table ActiveHerd.breed(
	BreedCategory varchar(30) PRIMARY KEY,
	BreedDescription varchar(200)
	);
GO

Create Table ActiveHerd.sheep(
	SheepId int IDENTITY(1,1) PRIMARY KEY,
	SheepName varchar (30),
	BreedCategory varchar(30) NOT NULL,
	Gender varchar(1) NOT NULL,
	ShepherdId int
	);
GO

Create Table ActiveHerd.shotList(
	ShotType varchar(30) PRIMARY KEY,
	shotDescription varchar(200),
	dayCycle varchar(30)
	);
GO

Create Table ActiveHerd.injectionList(
	InjectionType int IDENTITY(1,1) PRIMARY KEY,
	InjectionDescription varchar(200)
	);
GO

Create Table ActiveHerd.sheepShots(
	SheepId int, 
	ShotType varchar(30), 
	ShotDate Date, 
	InjectionType int
	);
GO


ALTER Table ActiveHerd.sheep Add Foreign Key (BreedCategory) References ActiveHerd.breed(BreedCategory);
ALTER Table ActiveHerd.sheep Add Foreign Key (ShepherdId) References ActiveHerd.shepherd(shepherdId);
ALTER Table ActiveHerd.sheepShots Add Foreign Key (SheepId) References ActiveHerd.sheep(SheepId)
ALTER Table ActiveHerd.sheepShots Add Foreign Key (ShotType) References ActiveHerd.shotList(ShotType)
ALTER Table ActiveHerd.sheepShots Add Foreign Key (InjectionType) References ActiveHerd.injectionList(InjectionType)

/******INSERT Into ActiveHerd.breed
Values ('Merino' , ' white-woolled,good-quality fine wool ,reasonable meat 
conformation. '),
 ('Dorper' , 'Big , sturdily built , black head and white body, grows very fast'),
 ('Dohne Merino', 'Hornless , good meat conformation , high quality wool')

 INSERT into ActiveHerd.ShotList
 Values ('Tetanus' ,'prevents tetanus ',NULL),
 ('Rabies','prevents rabies ',NULL),
 ('IBR-PI-3', 'prevents respiratory diseases',NULL)


 INSERT into ActiveHerd.Sheep
 Values ( 'Alex','Merino','Male',NULL),
		(  'Pat','Dorper','Male', NULL),
		( 'Ama' , 'Dohne Merino','Female' , NULL)


INSERT into ActiveHerd.InjectionList
Values ( ' Chlortetracyline' , 'Braod spectrum drug, 80mg(ewes)'),
	   ( 'Penicilin Procaine' , 'long acting penicilin , Injectable , 8 days'),
	   ( 'Sulfamethazine', 'oral antibiotic' )

INSERT into ActiveHerd.Shepherd
Values (  'Cho' , 'Alex','eeee'),
	   (  'Devos' ,'Luke','bbbb'),
	   ( ' Ritema', 'Brent','cccc')

insert into ActiveHerd.sheepShots (
    ShotID
    , ShotType
    , ShotDate
    , InjectionType)
        SELECT s.SheepID
        , h.ShotType
        ,getdate()
        ,(SELECT InjectionType From [ActiveHerd].InjectionList
            Where InjectionDescription = 'Oral Injection')
        FROM [ActiveHerd].sheep s, [ActiveHerd].shotlist h;  

/***SELECT * FROM ActiveHerd.Sheep
SELECT * FROM ActiveHerd.ShotList
SELECT * FROM ActiveHerd.InjectionList
SELECT * FROM ActiveHerd.breed

DELETE FROM ActiveHerd.Sheep;

DELETE FROM ActiveHerd.Sheep
WHERE ShepherdID = NULL;
						 ***/

