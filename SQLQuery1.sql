-- 26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletiþim numarasýný (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazýn.
select p.ProductName, s.CompanyName, s.Phone from Products p
inner join Suppliers s on p.SupplierID = s.SupplierID
where p.UnitsInStock = 0
-- 27. 1998 yýlý mart ayýndaki sipariþlerimin adresi, sipariþi alan çalýþanýn adý, çalýþanýn soyadý
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName, o.ShipAddress FROM Orders o
INNER JOIN Employees e ON e.EmployeeID = o.EmployeeID
WHERE YEAR(o.OrderDate) = 1998 AND MONTH(o.OrderDate) = 03;
--28. 1997 yýlý þubat ayýnda kaç sipariþim var?
select count(*) from Orders o where YEAR(o.OrderDate) = 1997 and MONTH(o.OrderDate) = 2
--29. London þehrinden 1998 yýlýnda kaç sipariþim var?
select count(*) from Orders o where year(o.OrderDate) = 1998 and o.ShipCity = 'London'
--30. 1997 yýlýnda sipariþ veren müþterilerimin contactname ve telefon numarasý
select c.ContactName, c.Phone from Orders o 
inner join Customers c on c.CustomerID = o.CustomerID
where YEAR(o.OrderDate) = 1997
--31. Taþýma ücreti 40 üzeri olan sipariþlerim
select * from Orders where Freight > 40
--32. Taþýma ücreti 40 ve üzeri olan sipariþlerimin þehri, müþterisinin adý
select o.ShipCity, c.CompanyName, o.Freight from Orders o
inner join Customers c on c.CustomerID = o.CustomerID
where Freight > 39
--33. 1997 yýlýnda verilen sipariþlerin tarihi, þehri, çalýþan adý -soyadý ( ad -soyad birleþik olacak ve büyük harf),
select o.OrderDate, o.ShipCity, upper(e.FirstName + e.LastName)  from Orders o
inner join Employees e on e.EmployeeID = o.EmployeeID
where YEAR(o.OrderDate) = 1997
--34. 1997 yýlýnda sipariþ veren müþterilerin contactname i, ve telefon numaralarý ( telefon formatý 2223322 gibi olmalý )
 SELECT DISTINCT ContactName,
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', ''), '.', '') AS formatted_phone
FROM customers
LEFT JOIN orders ON orders.CustomerID = customers.CustomerID
WHERE year(OrderDate) = 1997;
--35. Sipariþ tarihi, müþteri contact name, çalýþan ad, çalýþan soyad
select o.OrderDate, c.ContactName, e.FirstName, e.LastName from Orders o
inner join Customers c on c.CustomerID = o.CustomerID
inner join Employees e on e.EmployeeID = o.EmployeeID
--36. Geciken sipariþlerim?
select * from Orders where RequiredDate < ShippedDate
--37. Geciken sipariþlerimin tarihi, müþterisinin adý
select o.ShippedDate, c.CompanyName from Orders o
inner join Customers c on c.CustomerID = o.CustomerID
where RequiredDate < ShippedDate
--38. 10248 nolu sipariþte satýlan ürünlerin adý, kategorisinin adý, adedi
select p.ProductName, c.CategoryName, od.Quantity from [Order Details] od
inner join Products p on p.ProductID = od.ProductID
inner join Categories c on c.CategoryID = p.CategoryID
where od.OrderID = 10248
--39. 10248 nolu sipariþin ürünlerinin adý , tedarikçi adý
select p.ProductName, s.CompanyName from [Order Details] od
inner join Products p on p.ProductID = od.ProductID
inner join Suppliers s on s.SupplierID = p.SupplierID
where od.OrderID = 10248
--40. 3 numaralý ID ye sahip çalýþanýn 1997 yýlýnda sattýðý ürünlerin adý ve adeti
select p.ProductName, od.Quantity, o.EmployeeID, year(o.OrderDate) from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
inner join Products p on p.ProductID = od.ProductID
where year(o.OrderDate) = 1997 and o.EmployeeID = 3
-- 41. 1997 yýlýnda bir defasinda en çok satýþ yapan çalýþanýmýn ID,Ad soyad
select top 1 od.OrderID, sum(Quantity) TotalSale, e.EmployeeID, e.FirstName, e.LastName from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
inner join Employees e on e.EmployeeID = o.EmployeeID
where year(o.OrderDate) = 1997 group by od.OrderID, e.EmployeeID, e.FirstName, e.LastName order by sum(Quantity) desc
--42. 1997 yýlýnda en çok satýþ yapan çalýþanýmýn ID,Ad soyad ****
select e.EmployeeID, e.FirstName, e.LastName from Employees e 
where e.EmployeeID = (select top 1 o.EmployeeID from Orders o where year(o.OrderDate) = 1997 group by o.EmployeeID order by count(*) desc)
--43. En pahalý ürünümün adý,fiyatý ve kategorisin adý nedir?
select p.ProductName, c.CategoryName, P.UnitPrice from Products p
inner join Categories c on c.CategoryID = p.CategoryID
where p.ProductID =(select top 1 p.ProductID from Products p order by p.UnitPrice desc)
--44. Sipariþi alan personelin adý,soyadý, sipariþ tarihi, sipariþ ID. Sýralama sipariþ tarihine göre
select e.FirstName, e.LastName, o.OrderDate, o.OrderID from Orders o
inner join Employees e on e.EmployeeID = o.EmployeeID
order by o.OrderDate
--45. SON 5 sipariþimin ortalama fiyatý ve orderid nedir?
select top 5 o.OrderID, avg(UnitPrice * Quantity) from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
group by o.OrderID, o.OrderDate
order by o.OrderDate desc
--46. Ocak ayýnda satýlan ürünlerimin adý ve kategorisinin adý ve toplam satýþ miktarý nedir?
select p.ProductName, c.CategoryName, od.Quantity from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.ProductID = od.ProductID
inner join Categories c on c.CategoryID = p.CategoryID
where month(o.OrderDate) = 1
--47. Ortalama satýþ miktarýmýn üzerindeki satýþlarým nelerdir?
select * from [Order Details] where Quantity > (select avg(Quantity) from [Order Details])
--48. En çok satýlan ürünümün(adet bazýnda) adý, kategorisinin adý ve tedarikçisinin adý
select p.ProductName, c.CategoryName, s.CompanyName from Products p
inner join Categories c on c.CategoryID = p.CategoryID
inner join Suppliers s on s.SupplierID = p.SupplierID
where p.ProductID = (select top 1 od.ProductID from [Order Details] od order by od.Quantity desc)
--49. Kaç ülkeden müþterim var
select count(distinct c.Country) from Customers c
--50. 3 numaralý ID ye sahip çalýþan (employee) son Ocak ayýndan BUGÜNE toplamda ne kadarlýk ürün sattý?
select o.EmployeeID, sum(od.Quantity * od.UnitPrice) from Orders o 
inner join [Order Details] od on od.OrderID = o.OrderID
where o.EmployeeID = 3 and 
year(o.OrderDate) = (select top 1 year(o.OrderDate) from Orders o order by year(o.OrderDate) desc)
group by o.EmployeeID
--51. 10248 nolu sipariþte satýlan ürünlerin adý, kategorisinin adý, adedi
select od.OrderID, p.ProductName, c.CategoryName, od.Quantity from [Order Details] od
inner join Products p on p.ProductID = od.ProductID 
inner join Categories c on c.CategoryID = p.CategoryID
where od.OrderID = 10248
--52. 10248 nolu sipariþin ürünlerinin adý , tedarikçi adý
select od.OrderID ,p.ProductName, s.CompanyName from [Order Details] od
inner join Products p on p.ProductID = od.ProductID
inner join Suppliers s on s.SupplierID = p.SupplierID
where od.OrderID = 10248
--53. 3 numaralý ID ye sahip çalýþanýn 1997 yýlýnda sattýðý ürünlerin adý ve adeti
select p.ProductName, sum(od.Quantity) from Orders o
inner join [Order Details] od on o.OrderID = od.OrderID
inner join Products p on p.ProductID = od.ProductID
where o.EmployeeID = 3 and year(o.OrderDate) = 1997 group by p.ProductName
--54. 1997 yýlýnda bir defasinda en çok satýþ yapan çalýþanýmýn ID,Ad soyad
select top 1 od.OrderID, sum(Quantity) TotalSale, e.EmployeeID, e.FirstName, e.LastName from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
inner join Employees e on e.EmployeeID = o.EmployeeID
where year(o.OrderDate) = 1997 group by od.OrderID, e.EmployeeID, e.FirstName, e.LastName order by sum(Quantity) desc
--55. 1997 yýlýnda en çok satýþ yapan çalýþanýmýn ID,Ad soyad ****
select e.EmployeeID, e.FirstName, e.LastName from Employees e where e.EmployeeID = (select top 1 o.EmployeeID from Orders o where year(o.OrderDate) = 1997 group by o.EmployeeID order by count(*) desc)
--56. En pahalý ürünümün adý,fiyatý ve kategorisin adý nedir?
select p.ProductName, p.UnitPrice, c.CategoryName from Products p
inner join Categories c on c.CategoryID = p.CategoryID
where p.ProductID = (select top 1 ProductID from Products order by UnitPrice desc)
--57. Sipariþi alan personelin adý,soyadý, sipariþ tarihi, sipariþ ID. Sýralama sipariþ tarihine göre
select e.FirstName, e.LastName, o.OrderDate, o.OrderID from Orders o
inner join Employees e on e.EmployeeID = o.EmployeeID
order by o.OrderDate
--58. SON 5 sipariþimin ortalama fiyatý ve orderid nedir?
select top 5 o.OrderID, avg(UnitPrice) from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
group by o.OrderID, o.OrderDate
order by o.OrderDate desc
--59. Ocak ayýnda satýlan ürünlerimin adý ve kategorisinin adý ve toplam satýþ miktarý nedir?
select p.ProductName, c.CategoryName, od.Quantity from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.ProductID = od.ProductID
inner join Categories c on c.CategoryID = p.CategoryID
where month(o.OrderDate) = 1
--60. Ortalama satýþ miktarýmýn üzerindeki satýþlarým nelerdir?
select * from [Order Details] where Quantity > (select avg(Quantity) from [Order Details])
--61. En çok satýlan ürünümün(adet bazýnda) adý, kategorisinin adý ve tedarikçisinin adý
select p.ProductName, c.CategoryName, s.CompanyName from Products p
inner join Categories c on c.CategoryID = p.CategoryID
inner join Suppliers s on s.SupplierID = p.SupplierID
where p.ProductID = (select top 1 od.ProductID from [Order Details] od order by od.Quantity desc)
--62. Kaç ülkeden müþterim var
select count(distinct c.Country) from Customers c
--63. Hangi ülkeden kaç müþterimiz var
select c.Country, count(*) from Customers c group by c.Country
--64. 3 numaralý ID ye sahip çalýþan (employee) son Ocak ayýndan BUGÜNE toplamda ne kadarlýk ürün sattý?
select o.EmployeeID, sum(od.Quantity * od.UnitPrice) from Orders o 
inner join [Order Details] od on od.OrderID = o.OrderID
where o.EmployeeID = 3 and 
year(o.OrderDate) = (select top 1 year(o.OrderDate) from Orders o order by year(o.OrderDate) desc)
group by o.EmployeeID
--65. 10 numaralý ID ye sahip ürünümden son 3 ayda ne kadarlýk ciro saðladým?
select (od.Quantity * od.UnitPrice) from Orders o 
inner join [Order Details] od on od.OrderID = o.OrderID
where o.OrderDate >= DATEADD(month, -3, GETDATE()) and od.ProductID = 10
--66. Hangi çalýþan þimdiye kadar toplam kaç sipariþ almýþ..?
select e.EmployeeID, e.FirstName, e.LastName, count(*) from Orders o
inner join Employees e on e.EmployeeID = o.EmployeeID
group by e.EmployeeID, e.FirstName, e.LastName
--67. 91 müþterim var. Sadece 89’u sipariþ vermiþ. Sipariþ vermeyen 2 kiþiyi bulun
select o.OrderID, c.CustomerID from Orders o
right join Customers c on c.CustomerID = o.CustomerID
where OrderID is null
--68. Brazil’de bulunan müþterilerin Þirket Adý, TemsilciAdi, Adres, Þehir, Ülke bilgileri
select CompanyName, ContactName, Address, City, Country	 from Customers where Country = 'Brazil'
--69. Brezilya’da olmayan müþteriler
select * from Customers where Country != 'Brazil'
--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müþteriler
select * from Customers where Country = 'Germany' or Country = 'France' or Country = 'Spain'
--71. Faks numarasýný bilmediðim müþteriler
Select * from Customers where Fax is null
--72. Londra’da ya da Paris’de bulunan müþterilerim
select * from Customers where City = 'London' or City = 'Paris'
--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müþteriler
select * from Customers where ContactTitle = 'Owner' and Country like 'Mex%'
--74. C ile baþlayan ürünlerimin isimleri ve fiyatlarý
select ProductName, UnitPrice from Products where ProductName like 'c%'
--75. Adý (FirstName) ‘A’ harfiyle baþlayan çalýþanlarýn (Employees); Ad, Soyad ve Doðum Tarihleri
select e.FirstName, e.LastName, e.BirthDate from Employees e where e.FirstName like 'a%'
--76. Ýsminde ‘RESTAURANT’ geçen müþterilerimin þirket adlarý
select c.CompanyName from customers c where c.CompanyName like '%restaurant%'
--77. 50$ ile 100$ arasýnda bulunan tüm ürünlerin adlarý ve fiyatlarý
select p.ProductName, p.UnitPrice from Products p where p.UnitPrice between 50 and 100
--78. 1 temmuz 1996 ile 31 Aralýk 1996 tarihleri arasýndaki sipariþlerin (Orders), SipariþID (OrderID) ve SipariþTarihi (OrderDate) bilgileri
select o.OrderID, o.OrderDate from Orders o where o.OrderDate between '1996-07-01' and '1996-12-31'
--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müþteriler
select * from Customers where Country = 'Germany' or Country = 'France' or Country = 'Spain'
--80. Faks numarasýný bilmediðim müþteriler
Select * from Customers where Fax is null
--81. Müþterilerimi ülkeye göre sýralýyorum:
select * from Customers order by Country
--82. Ürünlerimi en pahalýdan en ucuza doðru sýralama, sonuç olarak ürün adý ve fiyatýný istiyoruz
select p.ProductName, p.UnitPrice from Products p order by p.UnitPrice desc
--83. Ürünlerimi en pahalýdan en ucuza doðru sýralasýn, ama stoklarýný küçükten-büyüðe doðru göstersin sonuç olarak ürün adý ve fiyatýný istiyoruz
SELECT ProductName, p.UnitPrice, p.UnitsInStock FROM products p
ORDER BY p.UnitPrice DESC, p.UnitsInStock ASC
--84. 1 Numaralý kategoride kaç ürün vardýr..?
select Count(*) from Products where CategoryID = 1
--85. Kaç farklý ülkeye ihracat yapýyorum..?
select count(distinct ShipCountry) from Orders
--86. a.Bu ülkeler hangileri..?
select distinct ShipCountry from Orders
--87. En Pahalý 5 ürün
select top 5 * from Products p order by p.UnitPrice desc
--88. ALFKI CustomerID’sine sahip müþterimin sipariþ sayýsý..?
select count(*) from Orders where CustomerID = 'ALFKI'
--89. Ürünlerimin toplam maliyeti
select sum(UnitsInStock * UnitPrice) from Products
--90. Þirketim, þimdiye kadar ne kadar ciro yapmýþ..?
select sum(od.Quantity * p.UnitPrice) from [Order Details] od
inner join products p on p.ProductID = od.ProductID
--91. Ortalama Ürün Fiyatým
select avg(UnitPrice) from Products
--92. En Pahalý Ürünün Adý
select top 1 ProductName from Products order by UnitPrice desc
--93. En az kazandýran sipariþ
select top 1 o.OrderID, od.Quantity * od.Quantity from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
order by od.UnitPrice asc
--94. Müþterilerimin içinde en uzun isimli müþteri
select * from Customers c where len(CompanyName) = (select max(len(c.CompanyName)) from Customers c)
--95. Çalýþanlarýmýn Ad, Soyad ve Yaþlarý
select e.FirstName, e.LastName, year(GETDATE()) - year(e.BirthDate) as age from Employees e
--96. Hangi üründen toplam kaç adet alýnmýþ..?
select  od.ProductID, sum(od.Quantity) as quantity from [Order Details] od group by od.ProductID order by quantity desc
--97. Hangi sipariþte toplam ne kadar kazanmýþým..?
select o.OrderID, sum(od.Quantity * od.UnitPrice) Price from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
group by o.OrderID
--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select c.CategoryName, count(*) from Products p
inner join Categories c on p.CategoryID = c.CategoryID
group by c.CategoryName
--99. 1000 Adetten fazla satýlan ürünler?
select  od.ProductID, sum(od.Quantity) as quant from [Order Details] od
group by od.ProductID having sum(od.Quantity) > 1000 order by quant desc

--100. Hangi Müþterilerim hiç sipariþ vermemiþ..?
select o.OrderID, c.CustomerID from Orders o
right join Customers c on c.CustomerID = o.CustomerID
where o.OrderID is null