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

CREATE TRIGGER ArchiwizujPostyDelete
ON Posty
AFTER DELETE 
AS
INSERT INTO Posty_Archiwum VALUES (Treść, Id_Autora, Id_Grupy, Ilość_Polubień, Data_Dodania, GETDATE(), 'usunięcie') 
SELECT Treść, Id_Autora, Id_Grupy, Ilość_Polubień, Data_Dodania
FROM Deleted 
GO
