CREATE TRIGGER ArchiwizujPostyUpdate
ON Posty
AFTER UPDATE 
AS
IF UPDATE(Treść) BEGIN
    INSERT INTO Posty_Archiwum VALUES (Treść, Id_Autora, Id_Grupy, Ilość_Polubień, Data_Dodania, GETDATE(), 'edycja') 
    SELECT Treść, Id_Autora, Id_Grupy, Ilość_Polubień, Data_Dodania
    FROM Updated 
END
GO

--------------------------------------------------------------------------------

CREATE TRIGGER ArchiwizujPostyDelete
ON Posty
INSTEAD OF DELETE 
AS

DECLARE @DeletedID INT
SET @DeletedID = (
    SELECT Id FROM Deleted
)

IF ((SELECT COUNT (*) FROM Posty P WHERE P.Id = @DeletedID) = 0) BEGIN
    ROLLBACK
    RAISERROR('Nie istnieje post który próbowano usunąć', 16, 1)
END

IF ((SELECT COUNT (*) FROM Posty P WHERE P.Id = @DeletedID) > 1) BEGIN
    ROLLBACK
    RAISERROR('Można usunąć tylko jeden post naraz', 16, 1)
END

DELETE FROM Posty
WHERE Id = @DeletedID

INSERT INTO Posty_Archiwum VALUES (Treść, Id_Autora, Id_Grupy, Ilość_Polubień, Data_Dodania, GETDATE(), 'usunięcie') 
SELECT Treść, Id_Autora, Id_Grupy, Ilość_Polubień, Data_Dodania
FROM Deleted 

GO
