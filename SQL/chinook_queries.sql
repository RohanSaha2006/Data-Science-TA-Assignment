-- 1. List the top 5 customers by total purchase amount.
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    ROUND(SUM(i.Total), 2) AS TotalPurchaseAmount
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
GROUP BY 
    c.CustomerId,
    c.FirstName,
    c.LastName
ORDER BY 
    TotalPurchaseAmount DESC
LIMIT 5;

-- 2. Find the most popular genre in terms of total tracks sold.
SELECT 
    g.Name AS Genre,
    COUNT(il.InvoiceLineId) AS TracksSold
FROM 
    Genre g
JOIN 
    Track t ON g.GenreId = t.GenreId
JOIN 
    InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY 
    g.GenreId, g.Name
ORDER BY 
    TracksSold DESC
LIMIT 1;

-- 3. Retrieve all employees who are managers along with their subordinates.
SELECT 
    m.EmployeeId AS ManagerId,
    m.FirstName || ' ' || m.LastName AS ManagerName,
    e.EmployeeId AS SubordinateId,
    e.FirstName || ' ' || e.LastName AS SubordinateName,
    e.Title AS SubordinateTitle
FROM 
    Employee e
JOIN 
    Employee m ON e.ReportsTo = m.EmployeeId
ORDER BY 
    ManagerId, SubordinateId;

-- 4. For each artist, find their most sold album.
WITH AlbumSales AS (
    SELECT
        ar.ArtistId,
        ar.Name AS ArtistName,
        al.AlbumId,
        al.Title AS AlbumTitle,
        COUNT(il.InvoiceLineId) AS SalesCount,
        RANK() OVER (PARTITION BY ar.ArtistId ORDER BY COUNT(il.InvoiceLineId) DESC) AS SalesRank
    FROM
        Artist ar
    JOIN
        Album al ON ar.ArtistId = al.ArtistId
    JOIN
        Track t ON al.AlbumId = t.AlbumId
    JOIN
        InvoiceLine il ON t.TrackId = il.TrackId
    GROUP BY
        ar.ArtistId, ar.Name, al.AlbumId, al.Title
)
SELECT
    ArtistId,
    ArtistName,
    AlbumId,
    AlbumTitle,
    SalesCount
FROM
    AlbumSales
WHERE
    SalesRank = 1
ORDER BY
    SalesCount DESC;

-- 5. Write a query to get monthly sales trends in the year 2013.
SELECT
    strftime('%Y-%m', i.InvoiceDate) AS Month,
    COUNT(i.InvoiceId) AS NumberOfSales,
    ROUND(SUM(i.Total), 2) AS TotalSales,
    ROUND(AVG(i.Total), 2) AS AverageSaleValue
FROM
    Invoice i
WHERE
    strftime('%Y', i.InvoiceDate) = '2013'
GROUP BY
    Month
ORDER BY
    Month;