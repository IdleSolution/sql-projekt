--------------------
CREATE OR ALTER FUNCTION PostyZGrupyPoDacie (@Id_Grupy INT, @Data DATETIME)
RETURNS TABLE
AS
RETURN (
    SELECT P.Id, P.Treść, P.Ilość_Polubień 
    FROM Posty P
    WHERE P.Id_Grupy = @Id_Grupy AND P.Data_dodania >= @Data
)
GO
------------------

CREATE OR ALTER FUNCTION StatusyUczestnictwaWydarzenia (@Id_Wydarzenia INT)
RETURNS @WydarzeniaStatusy TABLE 
(
    Id INT,
    Nazwa_Wydarzenia VARCHAR(100),
    Opis VARCHAR(MAX),
    Uczestnicy INT,
    Ludzie_którzy_odmówili INT,
    Brak_Odpowiedzi INT,
    Zainteresowani INT
)
AS
BEGIN

    DECLARE @Uczestnicy INT
    SET @Uczestnicy = (
        SELECT COUNT(*) 
        FROM Wydarzenia_Uczestnicy
        WHERE Status_Uczestnictwa = 'uczestniczy' AND Id_Wydarzenia = @Id_Wydarzenia
    )

    DECLARE @Ludzie_którzy_odmówili INT
    SET @Ludzie_którzy_odmówili = (
        SELECT COUNT(*) 
        FROM Wydarzenia_Uczestnicy
        WHERE Status_Uczestnictwa = 'odmówił' AND Id_Wydarzenia = @Id_Wydarzenia
    )

    DECLARE @Brak_Odpowiedzi INT
    SET @Brak_Odpowiedzi = (
        SELECT COUNT(*) 
        FROM Wydarzenia_Uczestnicy
        WHERE Status_Uczestnictwa = 'nie odpowiedział' AND Id_Wydarzenia = @Id_Wydarzenia
    )

    DECLARE @Zainteresowani INT
    SET @Zainteresowani = (
        SELECT COUNT(*) 
        FROM Wydarzenia_Uczestnicy
        WHERE Status_Uczestnictwa = 'zainteresowany' AND Id_Wydarzenia = @Id_Wydarzenia
    )

    INSERT INTO @WydarzeniaStatusy VALUES (Id, Nazwa_Wydarzenia, Opis, @Uczestnicy, @Ludzie_którzy_odmówili, @Brak_Odpowiedzi, @Zainteresowani)
    SELECT Id, Nazwa_Wydarzenia, Opis FROM Wydarzenia WHERE Id = @Id_Wydarzenia
    

    RETURN
END
GO


----------------------------------------------------

CREATE OR ALTER FUNCTION NajlepsiPosterzyWGrupie (@IdGrupy INT)
RETURNS @NajlepsiPosterzy TABLE
(
    Id_Konta INT,
    Imię VARCHAR(50),
    Nazwisko VARCHAR(50),
    Ilość_Polubień INT
)
AS
BEGIN

INSERT INTO @NajlepsiPosterzy VALUES(k.Id, d.Imię, d.Nazwisko, p.Ilość_Polubień)
SELECT TOP 5 k.Id, d.Imię, d.Naziwsko, p.Ilość_Polubień
FROM Posty p
INNER JOIN Konta k ON p.Id_Autora = k.Id
INNER JOIN Dane_Osobowe d ON k.Id = d.Id_Konta
WHERE p.Id_Grupy = @IdGrupy
GROUP BY p.Id_Autora
ORDER BY p.Ilość_Polubień DESC

RETURN

END
GO


----------------------------------------------------------

CREATE OR ALTER FUNCTION SzukajUżytkowników (@CiągZnakowy VARCHAR(255))
RETURNS @Użytkownicy TABLE
(
    Id_Konta INT,
    Imię VARCHAR(50),
    Nazwisko VARCHAR(50),
    Id_Zdjęcia_Profilowego INT
)
AS
BEGIN
DECLARE @PoczątekImienia VARCHAR(50)
DECLARE @PoczątekNazwiska VARCHAR(50)
SET @PoczątekImienia = (
    SELECT PARSENAME(REPLACE(@CiągZnakowy, ' ', '.'), 2)
)
SET @PoczątekNazwiska = (
    SELECT PARSENAME(REPLACE(@CiągZnakowy, ' ', '.'), 1)
)

IF(@PoczątekNazwiska IS NULL)
BEGIN
    SET @PoczątekNazwiska = ''
END

INSERT INTO @Użytkownicy VALUES(d.Id_Konta, d.Imię, d.Nazwisko, z.Id_Zdjęcia)
SELECT d.Id_Konta, d.Imię, d.Nazwisko, z.Id_Zdjęcia FROM Dane_Osobowe
INNER JOIN Zdjęcia_Profilowe z ON z.Id_Konta = d.Id_Konta
WHERE d.Imię LIKE @PoczątekImienia + '%' AND d.Nazwisko LIKE @PoczątekNazwiska + '%'

RETURN

END
GO

------

CREATE OR ALTER FUNCTION ListaZnajomych(@IdKonta INT)
RETURNS @Znajomi TABLE (
    Id_Znajomego INT,
    Imię VARCHAR(50),
    Nazwisko VARCHAR(50),
    Id_Zdjęcia_Profilowego INT
)
AS
BEGIN
    INSERT INTO @Znajomi VALUES (z.Id1, d.Imię, d.Nazwisko, zp.Id_Zdjęcia)
    SELECT z.Id1, d.Imię, d.Nazwisko, zp.Id_Zdjęcia
    FROM Znajomi z
    INNER JOIN Dane_Osobowe d ON d.Id_Konta = z.Id1
    INNER JOIN Zdjęcia_Profilowe zp ON zp.Id_Konca = d.Id_Konta
    WHERE z.Id2 = @IdKonta


    INSERT INTO @Znajomi VALUES (z.Id2, d.Imię, d.Nazwisko, zp.Id_Zdjęcia)
    SELECT z.Id2, d.Imię, d.Nazwisko, zp.Id_Zdjęcia
    FROM Znajomi z
    INNER JOIN Dane_Osobowe d ON d.Id_Konta = z.Id2
    INNER JOIN Zdjęcia_Profilowe zp ON zp.Id_Konca = d.Id_Konta
    WHERE z.Id1 = @IdKonta

    RETURN
END
GO


-------------------------------------------------

CREATE OR ALTER FUNCTION ZnajomiWGrupie (@IdKonta INT, @IdGrupy INT)
RETURNS @ZnajomiWGrupie TABLE (
    Id_Znajomego INT,
    Imię VARCHAR(50),
    Nazwisko VARCHAR(50),
    Id_Zdjęcia_Profilowego INT
)
AS
BEGIN
    DECLARE @ListaZnajomych TABLE (
        Id_Znajomego INT,
        Imię VARCHAR(50),
        Nazwisko VARCHAR(50),
        Id_Zdjęcia_Profilowego INT
    )
    SET @ListaZnajomych = dbo.ListaZnajomych(@IdKonta)

    DECLARE @ListaCzłonkówGrupy TABLE (
        Id_Członka INT
    )

    SET @ListaCzłonkówGrupy = (
        SELECT Id_Konta
        FROM Grupy_Członkowie
        WHERE Id_Grupy = @IdGrupy
    )

    INSERT INTO @ZnajomiWGrupie VALUES(lz.Id_Znajomego, lz.Imię, lz.Nazwisko, lz.Id_Zdjęcia)
    SELECT lz.Id_Znajomego, lz.Imię, lz.Nazwisko, lz.Id_Zdjęcia
    FROM @ListaZnajomych lz
    WHERE lz.Id_Znajomego IN (@ListaCzłonkówGrupy)

    RETURN
END
GO
------

CREATE OR ALTER FUNCTION UrodzinyZnajomych(@IdKonta INT)
RETURNS @ZnajomiZUrodzinami TABLE (
    Id_Znajomego INT,
    Imię VARCHAR(50),
    Nazwisko VARCHAR(50),
    Id_Zdjęcia_Profilowego INT
)
AS
BEGIN
    DECLARE @ListaZnajomych TABLE (
        Id_Znajomego INT,
        Imię VARCHAR(50),
        Nazwisko VARCHAR(50),
        Id_Zdjęcia_Profilowego INT
    )
    SET @ListaZnajomych = dbo.ListaZnajomych(@IdKonta)

    INSERT INTO @ZnajomiZUrodzinami VALUES(lz.Id_Znajomego, lz.Imię, lz.Nazwisko, lz.Id_Zdjęcia)
    SELECT lz.Id_Znajomego, lz.Imię, lz.Nazwisko, lz.Id_Zdjęcia
    FROM @ListaZnajomych lz
    INNER JOIN Dane_Osobowe d ON d.Id_Konta = lz.Id_Znajomego
    WHERE MONTH(d.Urodziny) = MONTH(GETDATE()) AND DAY(d.Urodziny) = DAY(GETDATE())

    RETURN
END
GO