AgroBridge
AgroBridge is a Windows Forms (C#, .NET Framework) desktop application that connects farmers directly with customers. Farmers list produce for sale, customers browse and buy it, and an admin approves new accounts and manages the product catalog.
Tech Stack
Language / UI: C#, Windows Forms (WinForms)
Database: Microsoft SQL Server (LocalDB/SQLEXPRESS instance, database AgroBridgeDB)
Data access: System.Data.SqlClient with parameterized SqlCommand queries
IDE: Visual Studio (.csproj-based project)
User Roles
The app supports three roles, chosen at registration and gated by an admin approval step:
Role
Home screen
What they can do
Farmer
FormFarmerHome
List, update, and remove their own products
Customer
FormCustomerHome
Browse/search products, manage a cart, place orders, view order history, view profile
Admin
FormAdminHome
Approve/reject registered users, manage the product catalog directly
Application Flow
FormWelcome – landing screen, entry point into the app.
FormLogin – username/password login; also links to FormReg (registration) and FormChangePass.
FormReg – new user signs up as Farmer or Customer; the record is inserted into RegistrationTable with Status = 0 (pending), plus a matching row in FarmerTable or CustomerTable.
FormRegisteredUsers (admin-only) – approves/rejects pending accounts by updating Status, or deletes a registration.
On successful login, the user is routed to their role's home form (FormFarmerHome, FormCustomerHome, or FormAdminHome).
From there:
Farmer → FormAddProduct, FormUpdateProduct, FormRmvProduct, FormViewProducts to manage listings.
Customer → FormCustomerHome (browse/search) → FormCustomerCart (review cart, checkout) → FormCustomerOrders (order history) / FormCustomerProfile (profile).
Admin → FormRegisteredUsers and product management forms.
Total forms in the running application: 16 — Form1, FormAddProduct, FormAdminHome, FormChangePass, FormCustomerCart, FormCustomerHome, FormCustomerOrders, FormCustomerProfile, FormFarmerHome, FormLogin, FormReg, FormRegisteredUsers, FormRmvProduct, FormUpdateProduct, FormViewProducts, FormWelcome.
Core Classes
Class
Responsibility
Customer.cs
Customer entity: loads/searches products, manages an in-memory cart (add/remove/clear)
Farmer.cs
Farmer entity: add, update, delete, and list a farmer's own products
Product.cs
Product data model (ProductID, ProductName, Price, Quantity, FarmerID)
CartItem.cs
Cart line-item model with a computed TotalPrice
Order.cs
Places an order inside a SQL transaction (inserts into OrderTable, decrements stock in ProductTable, rolls back on insufficient stock); also loads order history
Database Schema
AgroBridgeDB has 6 tables, referenced directly from the C# data-access code (no ORM):
RegistrationTable – login credentials, role, and approval status
CustomerTable – customer profile details
FarmerTable – farmer profile details
ProductTable – product listings, linked to FarmerTable
OrderTable – order headers, linked to CustomerTable
OrderDetailsTable – per-order line items, joined with ProductTable
A reconstructed CREATE TABLE script is available separately (AgroBridgeDB_schema.sql), rebuilt from the queries in code since no schema file ships with the project.
Known Issues / Limitations
Order.PlaceOrder() inserts into OrderTable but no code path writes to OrderDetailsTable, even though Order.GetOrdersByCustomer() reads from it via a JOIN — order history will show no line items until this is fixed.
FormLogin and FormChangePass build SQL with string concatenation instead of parameters, which is a SQL-injection risk (unlike the parameterized queries used elsewhere, e.g. in Order.cs).
Passwords are stored and compared as plain text in RegistrationTable (no hashing).
Running the Project
Open the solution in Visual Studio.
Create the AgroBridgeDB database on a local SQL Server / SQLEXPRESS instance and run the schema script.
Confirm the connection string (Data Source=.\SQLEXPRESS;Initial Catalog=AgroBridgeDB;Integrated Security=True;...) matches your local instance.
Build and run — the app starts at FormWelcome.
