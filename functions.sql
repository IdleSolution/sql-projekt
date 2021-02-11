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
