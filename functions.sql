--------------------
CREATE OR ALTER FUNCTION PostyZGrupyXPoY (@X INT, @Y DATETIME)
RETURNS TABLE
AS
RETURN (
    SELECT P.Id, P.Treść, P.Ilość_Polubień 
    FROM Posty P
    WHERE P.Id_Grupy = @X AND P.Data_dodania >= @Y
)
GO
------------------
