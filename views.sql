CREATE VIEW IlośćKomentarzyPost AS
SELECT P.Id, P.Treść, P.Ilość_Polubień, A.IlośćKomentarzy
FROM Posty P
INNER JOIN (
    SELECT K.Id_Postu, COUNT(*) IlośćKomentarzy 
    FROM Komentarze K
    GROUP BY K.Id_Postu
) A ON A.Id_Postu = P.Id
GO

-----

CREATE VIEW RozpoczęteWydarzeniaSzczegóły AS
SELECT W.Nazwa_Wydarzenia, W.Opis, Z.Ścieżka, A.Miasto, A.Ulica
FROM Wydarzenia W
INNER JOIN Zdjęcia Z ON Z.Id = W.Id_Zdjęcia
INNER JOIN Adresy A ON A.Id = W.Id_Adresu 
WHERE Godzina_Rozpoczęcia >= GETDATE() AND Godzina_Zakończenia <= GETDATE() 

---------
