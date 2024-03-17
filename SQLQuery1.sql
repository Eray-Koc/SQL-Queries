-- 26. Stokta bulunmayan �r�nlerin �r�n listesiyle birlikte tedarik�ilerin ismi ve ileti�im numaras�n� (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak i�in bir sorgu yaz�n.
select p.ProductName, s.CompanyName, s.Phone from Products p
inner join Suppliers s on p.SupplierID = s.SupplierID
where p.UnitsInStock = 0
-- 27. 1998 y�l� mart ay�ndaki sipari�lerimin adresi, sipari�i alan �al��an�n ad�, �al��an�n soyad�
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName, o.ShipAddress FROM Orders o
INNER JOIN Employees e ON e.EmployeeID = o.EmployeeID
WHERE YEAR(o.OrderDate) = 1998 AND MONTH(o.OrderDate) = 03;
--28. 1997 y�l� �ubat ay�nda ka� sipari�im var?
select count(*) from Orders o where YEAR(o.OrderDate) = 1997 and MONTH(o.OrderDate) = 2
--29. London �ehrinden 1998 y�l�nda ka� sipari�im var?
select count(*) from Orders o where year(o.OrderDate) = 1998 and o.ShipCity = 'London'
--30. 1997 y�l�nda sipari� veren m��terilerimin contactname ve telefon numaras�
select c.ContactName, c.Phone from Orders o 
inner join Customers c on c.CustomerID = o.CustomerID
where YEAR(o.OrderDate) = 1997
--31. Ta��ma �creti 40 �zeri olan sipari�lerim
select * from Orders where Freight > 40
--32. Ta��ma �creti 40 ve �zeri olan sipari�lerimin �ehri, m��terisinin ad�
select o.ShipCity, c.CompanyName, o.Freight from Orders o
inner join Customers c on c.CustomerID = o.CustomerID
where Freight > 39
--33. 1997 y�l�nda verilen sipari�lerin tarihi, �ehri, �al��an ad� -soyad� ( ad -soyad birle�ik olacak ve b�y�k harf),
select o.OrderDate, o.ShipCity, upper(e.FirstName + e.LastName)  from Orders o
inner join Employees e on e.EmployeeID = o.EmployeeID
where YEAR(o.OrderDate) = 1997
--34. 1997 y�l�nda sipari� veren m��terilerin contactname i, ve telefon numaralar� ( telefon format� 2223322 gibi olmal� )
 SELECT DISTINCT ContactName,
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', ''), '.', '') AS formatted_phone
FROM customers
LEFT JOIN orders ON orders.CustomerID = customers.CustomerID
WHERE year(OrderDate) = 1997;
--35. Sipari� tarihi, m��teri contact name, �al��an ad, �al��an soyad
select o.OrderDate, c.ContactName, e.FirstName, e.LastName from Orders o
inner join Customers c on c.CustomerID = o.CustomerID
inner join Employees e on e.EmployeeID = o.EmployeeID
--36. Geciken sipari�lerim?
select * from Orders where RequiredDate < ShippedDate
--37. Geciken sipari�lerimin tarihi, m��terisinin ad�
select o.ShippedDate, c.CompanyName from Orders o
inner join Customers c on c.CustomerID = o.CustomerID
where RequiredDate < ShippedDate
--38. 10248 nolu sipari�te sat�lan �r�nlerin ad�, kategorisinin ad�, adedi
select p.ProductName, c.CategoryName, od.Quantity from [Order Details] od
inner join Products p on p.ProductID = od.ProductID
inner join Categories c on c.CategoryID = p.CategoryID
where od.OrderID = 10248
--39. 10248 nolu sipari�in �r�nlerinin ad� , tedarik�i ad�
select p.ProductName, s.CompanyName from [Order Details] od
inner join Products p on p.ProductID = od.ProductID
inner join Suppliers s on s.SupplierID = p.SupplierID
where od.OrderID = 10248
--40. 3 numaral� ID ye sahip �al��an�n 1997 y�l�nda satt��� �r�nlerin ad� ve adeti
select p.ProductName, od.Quantity, o.EmployeeID, year(o.OrderDate) from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
inner join Products p on p.ProductID = od.ProductID
where year(o.OrderDate) = 1997 and o.EmployeeID = 3
-- 41. 1997 y�l�nda bir defasinda en �ok sat�� yapan �al��an�m�n ID,Ad soyad
select top 1 od.OrderID, sum(Quantity) TotalSale, e.EmployeeID, e.FirstName, e.LastName from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
inner join Employees e on e.EmployeeID = o.EmployeeID
where year(o.OrderDate) = 1997 group by od.OrderID, e.EmployeeID, e.FirstName, e.LastName order by sum(Quantity) desc
--42. 1997 y�l�nda en �ok sat�� yapan �al��an�m�n ID,Ad soyad ****
select e.EmployeeID, e.FirstName, e.LastName from Employees e 
where e.EmployeeID = (select top 1 o.EmployeeID from Orders o where year(o.OrderDate) = 1997 group by o.EmployeeID order by count(*) desc)
--43. En pahal� �r�n�m�n ad�,fiyat� ve kategorisin ad� nedir?
select p.ProductName, c.CategoryName, P.UnitPrice from Products p
inner join Categories c on c.CategoryID = p.CategoryID
where p.ProductID =(select top 1 p.ProductID from Products p order by p.UnitPrice desc)
--44. Sipari�i alan personelin ad�,soyad�, sipari� tarihi, sipari� ID. S�ralama sipari� tarihine g�re
select e.FirstName, e.LastName, o.OrderDate, o.OrderID from Orders o
inner join Employees e on e.EmployeeID = o.EmployeeID
order by o.OrderDate
--45. SON 5 sipari�imin ortalama fiyat� ve orderid nedir?
select top 5 o.OrderID, avg(UnitPrice * Quantity) from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
group by o.OrderID, o.OrderDate
order by o.OrderDate desc
--46. Ocak ay�nda sat�lan �r�nlerimin ad� ve kategorisinin ad� ve toplam sat�� miktar� nedir?
select p.ProductName, c.CategoryName, od.Quantity from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.ProductID = od.ProductID
inner join Categories c on c.CategoryID = p.CategoryID
where month(o.OrderDate) = 1
--47. Ortalama sat�� miktar�m�n �zerindeki sat��lar�m nelerdir?
select * from [Order Details] where Quantity > (select avg(Quantity) from [Order Details])
--48. En �ok sat�lan �r�n�m�n(adet baz�nda) ad�, kategorisinin ad� ve tedarik�isinin ad�
select p.ProductName, c.CategoryName, s.CompanyName from Products p
inner join Categories c on c.CategoryID = p.CategoryID
inner join Suppliers s on s.SupplierID = p.SupplierID
where p.ProductID = (select top 1 od.ProductID from [Order Details] od order by od.Quantity desc)
--49. Ka� �lkeden m��terim var
select count(distinct c.Country) from Customers c
--50. 3 numaral� ID ye sahip �al��an (employee) son Ocak ay�ndan BUG�NE toplamda ne kadarl�k �r�n satt�?
select o.EmployeeID, sum(od.Quantity * od.UnitPrice) from Orders o 
inner join [Order Details] od on od.OrderID = o.OrderID
where o.EmployeeID = 3 and 
year(o.OrderDate) = (select top 1 year(o.OrderDate) from Orders o order by year(o.OrderDate) desc)
group by o.EmployeeID
--51. 10248 nolu sipari�te sat�lan �r�nlerin ad�, kategorisinin ad�, adedi
select od.OrderID, p.ProductName, c.CategoryName, od.Quantity from [Order Details] od
inner join Products p on p.ProductID = od.ProductID 
inner join Categories c on c.CategoryID = p.CategoryID
where od.OrderID = 10248
--52. 10248 nolu sipari�in �r�nlerinin ad� , tedarik�i ad�
select od.OrderID ,p.ProductName, s.CompanyName from [Order Details] od
inner join Products p on p.ProductID = od.ProductID
inner join Suppliers s on s.SupplierID = p.SupplierID
where od.OrderID = 10248
--53. 3 numaral� ID ye sahip �al��an�n 1997 y�l�nda satt��� �r�nlerin ad� ve adeti
select p.ProductName, sum(od.Quantity) from Orders o
inner join [Order Details] od on o.OrderID = od.OrderID
inner join Products p on p.ProductID = od.ProductID
where o.EmployeeID = 3 and year(o.OrderDate) = 1997 group by p.ProductName
--54. 1997 y�l�nda bir defasinda en �ok sat�� yapan �al��an�m�n ID,Ad soyad
select top 1 od.OrderID, sum(Quantity) TotalSale, e.EmployeeID, e.FirstName, e.LastName from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
inner join Employees e on e.EmployeeID = o.EmployeeID
where year(o.OrderDate) = 1997 group by od.OrderID, e.EmployeeID, e.FirstName, e.LastName order by sum(Quantity) desc
--55. 1997 y�l�nda en �ok sat�� yapan �al��an�m�n ID,Ad soyad ****
select e.EmployeeID, e.FirstName, e.LastName from Employees e where e.EmployeeID = (select top 1 o.EmployeeID from Orders o where year(o.OrderDate) = 1997 group by o.EmployeeID order by count(*) desc)
--56. En pahal� �r�n�m�n ad�,fiyat� ve kategorisin ad� nedir?
select p.ProductName, p.UnitPrice, c.CategoryName from Products p
inner join Categories c on c.CategoryID = p.CategoryID
where p.ProductID = (select top 1 ProductID from Products order by UnitPrice desc)
--57. Sipari�i alan personelin ad�,soyad�, sipari� tarihi, sipari� ID. S�ralama sipari� tarihine g�re
select e.FirstName, e.LastName, o.OrderDate, o.OrderID from Orders o
inner join Employees e on e.EmployeeID = o.EmployeeID
order by o.OrderDate
--58. SON 5 sipari�imin ortalama fiyat� ve orderid nedir?
select top 5 o.OrderID, avg(UnitPrice) from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
group by o.OrderID, o.OrderDate
order by o.OrderDate desc
--59. Ocak ay�nda sat�lan �r�nlerimin ad� ve kategorisinin ad� ve toplam sat�� miktar� nedir?
select p.ProductName, c.CategoryName, od.Quantity from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.ProductID = od.ProductID
inner join Categories c on c.CategoryID = p.CategoryID
where month(o.OrderDate) = 1
--60. Ortalama sat�� miktar�m�n �zerindeki sat��lar�m nelerdir?
select * from [Order Details] where Quantity > (select avg(Quantity) from [Order Details])
--61. En �ok sat�lan �r�n�m�n(adet baz�nda) ad�, kategorisinin ad� ve tedarik�isinin ad�
select p.ProductName, c.CategoryName, s.CompanyName from Products p
inner join Categories c on c.CategoryID = p.CategoryID
inner join Suppliers s on s.SupplierID = p.SupplierID
where p.ProductID = (select top 1 od.ProductID from [Order Details] od order by od.Quantity desc)
--62. Ka� �lkeden m��terim var
select count(distinct c.Country) from Customers c
--63. Hangi �lkeden ka� m��terimiz var
select c.Country, count(*) from Customers c group by c.Country
--64. 3 numaral� ID ye sahip �al��an (employee) son Ocak ay�ndan BUG�NE toplamda ne kadarl�k �r�n satt�?
select o.EmployeeID, sum(od.Quantity * od.UnitPrice) from Orders o 
inner join [Order Details] od on od.OrderID = o.OrderID
where o.EmployeeID = 3 and 
year(o.OrderDate) = (select top 1 year(o.OrderDate) from Orders o order by year(o.OrderDate) desc)
group by o.EmployeeID
--65. 10 numaral� ID ye sahip �r�n�mden son 3 ayda ne kadarl�k ciro sa�lad�m?
select (od.Quantity * od.UnitPrice) from Orders o 
inner join [Order Details] od on od.OrderID = o.OrderID
where o.OrderDate >= DATEADD(month, -3, GETDATE()) and od.ProductID = 10
--66. Hangi �al��an �imdiye kadar toplam ka� sipari� alm��..?
select e.EmployeeID, e.FirstName, e.LastName, count(*) from Orders o
inner join Employees e on e.EmployeeID = o.EmployeeID
group by e.EmployeeID, e.FirstName, e.LastName
--67. 91 m��terim var. Sadece 89�u sipari� vermi�. Sipari� vermeyen 2 ki�iyi bulun
select o.OrderID, c.CustomerID from Orders o
right join Customers c on c.CustomerID = o.CustomerID
where OrderID is null
--68. Brazil�de bulunan m��terilerin �irket Ad�, TemsilciAdi, Adres, �ehir, �lke bilgileri
select CompanyName, ContactName, Address, City, Country	 from Customers where Country = 'Brazil'
--69. Brezilya�da olmayan m��teriler
select * from Customers where Country != 'Brazil'
--70. �lkesi (Country) YA Spain, Ya France, Ya da Germany olan m��teriler
select * from Customers where Country = 'Germany' or Country = 'France' or Country = 'Spain'
--71. Faks numaras�n� bilmedi�im m��teriler
Select * from Customers where Fax is null
--72. Londra�da ya da Paris�de bulunan m��terilerim
select * from Customers where City = 'London' or City = 'Paris'
--73. Hem Mexico D.F�da ikamet eden HEM DE ContactTitle bilgisi �owner� olan m��teriler
select * from Customers where ContactTitle = 'Owner' and Country like 'Mex%'
--74. C ile ba�layan �r�nlerimin isimleri ve fiyatlar�
select ProductName, UnitPrice from Products where ProductName like 'c%'
--75. Ad� (FirstName) �A� harfiyle ba�layan �al��anlar�n (Employees); Ad, Soyad ve Do�um Tarihleri
select e.FirstName, e.LastName, e.BirthDate from Employees e where e.FirstName like 'a%'
--76. �sminde �RESTAURANT� ge�en m��terilerimin �irket adlar�
select c.CompanyName from customers c where c.CompanyName like '%restaurant%'
--77. 50$ ile 100$ aras�nda bulunan t�m �r�nlerin adlar� ve fiyatlar�
select p.ProductName, p.UnitPrice from Products p where p.UnitPrice between 50 and 100
--78. 1 temmuz 1996 ile 31 Aral�k 1996 tarihleri aras�ndaki sipari�lerin (Orders), Sipari�ID (OrderID) ve Sipari�Tarihi (OrderDate) bilgileri
select o.OrderID, o.OrderDate from Orders o where o.OrderDate between '1996-07-01' and '1996-12-31'
--79. �lkesi (Country) YA Spain, Ya France, Ya da Germany olan m��teriler
select * from Customers where Country = 'Germany' or Country = 'France' or Country = 'Spain'
--80. Faks numaras�n� bilmedi�im m��teriler
Select * from Customers where Fax is null
--81. M��terilerimi �lkeye g�re s�ral�yorum:
select * from Customers order by Country
--82. �r�nlerimi en pahal�dan en ucuza do�ru s�ralama, sonu� olarak �r�n ad� ve fiyat�n� istiyoruz
select p.ProductName, p.UnitPrice from Products p order by p.UnitPrice desc
--83. �r�nlerimi en pahal�dan en ucuza do�ru s�ralas�n, ama stoklar�n� k���kten-b�y��e do�ru g�stersin sonu� olarak �r�n ad� ve fiyat�n� istiyoruz
SELECT ProductName, p.UnitPrice, p.UnitsInStock FROM products p
ORDER BY p.UnitPrice DESC, p.UnitsInStock ASC
--84. 1 Numaral� kategoride ka� �r�n vard�r..?
select Count(*) from Products where CategoryID = 1
--85. Ka� farkl� �lkeye ihracat yap�yorum..?
select count(distinct ShipCountry) from Orders
--86. a.Bu �lkeler hangileri..?
select distinct ShipCountry from Orders
--87. En Pahal� 5 �r�n
select top 5 * from Products p order by p.UnitPrice desc
--88. ALFKI CustomerID�sine sahip m��terimin sipari� say�s�..?
select count(*) from Orders where CustomerID = 'ALFKI'
--89. �r�nlerimin toplam maliyeti
select sum(UnitsInStock * UnitPrice) from Products
--90. �irketim, �imdiye kadar ne kadar ciro yapm��..?
select sum(od.Quantity * p.UnitPrice) from [Order Details] od
inner join products p on p.ProductID = od.ProductID
--91. Ortalama �r�n Fiyat�m
select avg(UnitPrice) from Products
--92. En Pahal� �r�n�n Ad�
select top 1 ProductName from Products order by UnitPrice desc
--93. En az kazand�ran sipari�
select top 1 o.OrderID, od.Quantity * od.Quantity from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
order by od.UnitPrice asc
--94. M��terilerimin i�inde en uzun isimli m��teri
select * from Customers c where len(CompanyName) = (select max(len(c.CompanyName)) from Customers c)
--95. �al��anlar�m�n Ad, Soyad ve Ya�lar�
select e.FirstName, e.LastName, year(GETDATE()) - year(e.BirthDate) as age from Employees e
--96. Hangi �r�nden toplam ka� adet al�nm��..?
select  od.ProductID, sum(od.Quantity) as quantity from [Order Details] od group by od.ProductID order by quantity desc
--97. Hangi sipari�te toplam ne kadar kazanm���m..?
select o.OrderID, sum(od.Quantity * od.UnitPrice) Price from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
group by o.OrderID
--98. Hangi kategoride toplam ka� adet �r�n bulunuyor..?
select c.CategoryName, count(*) from Products p
inner join Categories c on p.CategoryID = c.CategoryID
group by c.CategoryName
--99. 1000 Adetten fazla sat�lan �r�nler?
select  od.ProductID, sum(od.Quantity) as quant from [Order Details] od
group by od.ProductID having sum(od.Quantity) > 1000 order by quant desc

--100. Hangi M��terilerim hi� sipari� vermemi�..?
select o.OrderID, c.CustomerID from Orders o
right join Customers c on c.CustomerID = o.CustomerID
where o.OrderID is null