-- USE master
-- GO
-- IF EXISTS (SELECT *
-- FROM sys.databases
-- WHERE NAME = 'DATAVERSE')
-- BEGIN
--     ALTER DATABASE DATAVERSE SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--     DROP DATABASE DATAVERSE;
-- END
-- GO
-- CREATE DATABASE DATAVERSE
-- GO

-- IF EXISTS (SELECT *
-- FROM sys.server_principals
-- WHERE name = 'web')
-- DROP LOGIN web
-- GO
-- CREATE LOGIN web WITH PASSWORD=   N'Kenapa03,'
-- GO
-- USE DATAVERSE;
-- GO
-- CREATE USER web FOR LOGIN web
-- GO
-- GRANT EXEC,SELECT, DELETE, INSERT,UPDATE ON DATABASE::DATAVERSE TO web
-- GO

CREATE TABLE [dbo].[SUMBER_DAYA_ALAM]
(
    Id INT NOT NULL PRIMARY KEY,
    NamaKomoditi NVARCHAR(20) NOT NULL,
    NamaEnglish NVARCHAR(20) NOT NULL,
    Jenis NVARCHAR(20) NOT NULL,
);

CREATE TABLE [dbo].[KEGUNAAN]
(
    Id INT NOT NULL,
    Kegunaan NVARCHAR(40) NOT NULL,
    FOREIGN KEY (Id) REFERENCES SUMBER_DAYA_ALAM(Id),
    PRIMARY KEY (Id, Kegunaan),
);


CREATE TABLE [dbo].[KEHUTANAN]
(
    Id INT NOT NULL,
    FOREIGN KEY (Id) REFERENCES [dbo].[SUMBER_DAYA_ALAM](Id),
    Famili NVARCHAR(20) NOT NULL,
    KesesuaianEkologis NVARCHAR(20) NOT NULL,
    KepadatanKayu SMALLINT NOT NULL,
    PERTUMBUHAN SMALLINT NOT NULL,
);

CREATE TABLE [dbo].[PERKEBUNAN]
(
    Id INT NOT NULL,
    FOREIGN KEY (Id) REFERENCES [dbo].[SUMBER_DAYA_ALAM](Id),
    Famili NVARCHAR(20) NOT NULL,
    SuhuOptimal FLOAT NOT NULL,
    WaktuPanen INT NOT NULL,
    JenisTanaman NVARCHAR(20) NOT NULL,
);

CREATE TABLE [dbo].[PERTAMBANGAN]
(
    Id INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (Id) REFERENCES [dbo].[SUMBER_DAYA_ALAM](Id),
    IdGolongan NVARCHAR(20) NOT NULL,
    Asal NVARCHAR(20) NOT NULL,
    Golongan NVARCHAR(25) NOT NULL,
);

CREATE TABLE [dbo].[MINERAL]
(
    Id INT NOT NULL,
    FOREIGN KEY (Id) REFERENCES [dbo].[PERTAMBANGAN](Id),
    Kilau NVARCHAR(20) NOT NULL,
    KlasifikasiMineral NVARCHAR(20) NOT NULL,
    KekerasanMohs FLOAT NOT NULL,
    SistemKristal NVARCHAR(20) NOT NULL,
);

CREATE TABLE [dbo].[TANAH]
(
    Id INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (Id) REFERENCES [dbo].[PERTAMBANGAN](Id),
    Ukuran FLOAT NOT NULL,
    JenisTanah NVARCHAR(20) NOT NULL,
);

CREATE TABLE [dbo].[KANDUNGAN_TANAH]
(
    Id INT NOT NULL,
    FOREIGN KEY (Id) REFERENCES [dbo].[TANAH](Id),
    Kandungan NVARCHAR(20) NOT NULL,
    PRIMARY KEY (Id, Kandungan),
);

CREATE TABLE [dbo].[MINYAK_BUMI]
(
    Id INT NOT NULL,
    FOREIGN KEY (Id) REFERENCES [dbo].[PERTAMBANGAN](Id),
    TitikDidih SMALLINT NOT NULL,
    JumlahAtom SMALLINT NOT NULL,
);

CREATE TABLE [dbo].[WILAYAH]
(
    Id INT NOT NULL PRIMARY KEY,
    Kota NVARCHAR(30) NOT NULL,
    Provinsi NVARCHAR(30) NOT NULL,
    UnitGeografis NVARCHAR(30) NOT NULL,
);

CREATE TABLE [dbo].[PERUSAHAAN]
(
    Id INT NOT NULL PRIMARY KEY,
    Nama NVARCHAR(40) NOT NULL,
    Milik NVARCHAR(10) NOT NULL,
    Sektor NVARCHAR(20) NOT NULL,
    TahunBerdiri SMALLINT NOT NULL,
    Alamat NVARCHAR(300) NOT NULL,
    Izin NVARCHAR(100) NOT NULL,
    Jenis NVARCHAR(20) NOT NULL,
    IdWilayah INT NOT NULL,
    FOREIGN KEY (IdWilayah) REFERENCES [dbo].[WILAYAH](Id),
    IdInduk INT,
    FOREIGN KEY (IdInduk) REFERENCES [dbo].[PERUSAHAAN](Id),
);

CREATE TABLE [dbo].[TELEPON]
(
    Id INT NOT NULL,
    FOREIGN KEY (Id) REFERENCES [dbo].[PERUSAHAAN](Id),
    Telepon NVARCHAR(20) NOT NULL,
    PRIMARY KEY (Id, Telepon),
);

CREATE TABLE [dbo].[PERUSAHAAN_SWASTA]
(
    Id INT NOT NULL,
    FOREIGN KEY (Id) REFERENCES [dbo].[PERUSAHAAN](Id),
    IzinBerlaku DATE NOT NULL,
    IzinBerakhir DATE NOT NULl,
    idPerusahaanBeli INT,
    FOREIGN KEY (idPerusahaanBeli) REFERENCES [dbo].[PERUSAHAAN](Id),
    NamaOlahan NVARCHAR(20),
);

CREATE TABLE [dbo].[BERADA_DI]
(
    IdKota INT NOT NULL,
    FOREIGN KEY (IdKota) REFERENCES [dbo].[WILAYAH](Id),
    IdKomoditi INT NOT NULL,
    FOREIGN KEY (IdKomoditi) REFERENCES [dbo].[PERTAMBANGAN](Id),
    PejabatBertanggungJawab NVARCHAR(20) NOT NULL,
    Angka BIGINT NOT NULL,
    Satuan NVARCHAR(20) NOT NULL,
    PRIMARY KEY (IdKota, IdKomoditi, Angka),
);

CREATE TABLE [dbo].[MENGOLAH]
(
    IdKota INT NOT NULL,
    FOREIGN KEY (IdKota) REFERENCES [dbo].[WILAYAH](Id),
    IdKomoditi INT NOT NULL,
    FOREIGN KEY (IdKomoditi) REFERENCES [dbo].[SUMBER_DAYA_ALAM](Id),
    IdPerusahaan INT NOT NULL,
    FOREIGN KEY (IdPerusahaan) REFERENCES [dbo].[PERUSAHAAN](Id),
    PRIMARY KEY (IdKota, IdKomoditi, IdPerusahaan),
    Luas BIGINT NOT NULL,
    Longitude FLOAT NOT NULL,
    Latitude FLOAT NOT NULL,
    JenisPengolahan NVARCHAR(20) NOT NULL,
);

CREATE TABLE [dbo].[HASIL]
(
    IdKota INT NOT NULL,
    IdKomoditi INT NOT NULL,
    IdPerusahaan INT NOT NULL,
    FOREIGN KEY (IdKota, IdKomoditi, IdPerusahaan) REFERENCES MENGOLAH(IdKota, IdKomoditi, IdPerusahaan),
    Tahun SMALLINT NOT NULL,
    Angka BIGINT NOT NULL,
    Satuan NVARCHAR(20) NOT NULL,
    Pendapatan BIGINT NOT NULL,
    PRIMARY KEY (IdKota, IdKomoditi, IdPerusahaan, Tahun),
);




 
