CREATE OR ALTER VIEW IlośćKomentarzyPost AS
SELECT P.Id, P.Treść, P.Ilość_Polubień, ISNULL(A.IlośćKomentarzy,0) AS IlośćKomentarzy
FROM Posty P
LEFT JOIN (
    SELECT K.Id_Postu, COUNT(*) IlośćKomentarzy 
    FROM Komentarze K
    GROUP BY K.Id_Postu
) A ON A.Id_Postu = P.Id
GO

-----

CREATE OR ALTER VIEW TrwająceWydarzeniaSzczegóły AS
SELECT W.Nazwa_Wydarzenia, W.Opis, Z.Ścieżka, A.Miasto, A.Ulica
FROM Wydarzenia W
LEFT JOIN Zdjęcia Z ON Z.Id = W.Id_Zdjęcia
LEFT JOIN Adresy A ON A.Id = W.Id_Adresu 
WHERE Godzina_Rozpoczęcia <= GETDATE() AND Godzina_Zakończenia >= GETDATE()
GO

---------

CREATE OR ALTER VIEW ŚredniaWiekuWGrupach AS
SELECT G.Nazwa, G.Opis, AV.ŚredniWiek
FROM Grupy G
INNER JOIN (
    SELECT GC.Id_Grupy, AVG(YEAR(GETDATE()) - YEAR(DO.Urodziny)) AS ŚredniWiek
    FROM Grupy_Członkowie GC
    INNER JOIN Dane_Osobowe DO ON DO.Id_Konta = GC.Id_Konta
    GROUP BY Id_Grupy
) AV ON AV.Id_Grupy = G.Id
GO

-----------

CREATE OR ALTER VIEW IlośćOsóbPodJednymAdresem AS
SELECT DO.Imię, DO.Nazwisko, DO.Nr_Telefonu, AD.TenSamAdres, AD.Id_Adresu
FROM Dane_Osobowe DO
INNER JOIN (
    SELECT DO.Id_Adresu, COUNT (*) AS TenSamAdres
    FROM Dane_Osobowe DO
    GROUP BY Id_Adresu
) AD ON AD.Id_Adresu = DO.Id_Adresu 
GO

----------

