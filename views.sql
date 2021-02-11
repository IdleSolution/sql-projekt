CREATE VIEW IlośćKomentarzyPost AS
SELECT P.Id, P.Treść, P.Ilość_Polubień, A.IlośćKomentarzy
FROM Posty P
INNER JOIN (
    SELECT K.Id_Postu, COUNT(*) IlośćKomentarzy 
    FROM Komentarze K
    GROUP BY K.Id_Postu
) A ON A.Id_Postu = P.Id
-----
