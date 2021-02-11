CREATE OR ALTER PROCEDURE DodajAdresOsobie(
    @IdOsoby INT, 
    @Województwo VARCHAR(19), 
    @Miasto VARCHAR(30), 
    @Ulica VARCHAR(30),
    @KodPocztowy VARCHAR(6))
AS

DECLARE @IdAdresu INT
SET @IdAdresu = (SELECT Id FROM Adresy WHERE Województwo = @Województwo AND Miasto = @Miasto AND Ulica = @Ulica)

IF(@IdAdresu IS NULL)
BEGIN
    DECLARE @LastId INT
    SET @LastId = (SELECT MAX(id) FROM Adresy)
    IF(@LastId IS NULL)
    BEGIN
        SET @LastId = 0
    END
    ELSE
    BEGIN
        SET @LastId = @LastId + 1
    END

    INSERT INTO Adresy VALUES(@LastId, @Województwo, @Miasto, @Ulica, @KodPocztowy)

    UPDATE d
    SET d.Id_Adresu = @LastId
    FROM Dane_Osobowe d
END
ELSE
BEGIN
    UPDATE d
    SET d.Id_Adresu = @IdAdresu
    FROM Dane_Osobowe d
END
GO

------------------------------------------

CREATE OR ALTER PROCEDURE DodajAdresWydarzeniu(
    @IdWydarzenia INT, 
    @Województwo VARCHAR(19), 
    @Miasto VARCHAR(30), 
    @Ulica VARCHAR(30),
    @KodPocztowy VARCHAR(6))
AS

DECLARE @IdAdresu INT
SET @IdAdresu = (SELECT Id FROM Adresy WHERE Województwo = @Województwo AND Miasto = @Miasto AND Ulica = @Ulica)

IF(@IdAdresu IS NULL)
BEGIN
    DECLARE @LastId INT
    SET @LastId = (SELECT MAX(id) FROM Adresy)
    IF(@LastId IS NULL)
    BEGIN
        SET @LastId = 0
    END
    ELSE
    BEGIN
        SET @LastId = @LastId + 1
    END

    INSERT INTO Adresy VALUES(@LastId, @Województwo, @Miasto, @Ulica, @KodPocztowy)

    UPDATE w
    SET w.Id_Adresu = @LastId
    FROM Wydarzenia w
END
ELSE
BEGIN
    UPDATE w
    SET w.Id_Adresu = @IdAdresu
    FROM Wydarzenia w
END
GO

CREATE OR ALTER PROCEDURE DodajZnajomych(
    @IdWysyłającego INT,
    @IdPrzyjmującego INT
)
AS