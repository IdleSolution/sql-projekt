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
