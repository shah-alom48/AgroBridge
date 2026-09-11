# AgroBridge
 
AgroBridge is a desktop application (C# WinForms, ADO.NET, SQL Server) that connects
farmers directly with customers, removing middlemen from the agricultural supply chain.
 
## Features
- Role-based login system (Admin, Farmer, Customer)
- Farmer dashboard to add, update, remove, and view their own products
- Customer dashboard to browse products, manage cart, and place orders
- Admin panel to approve registered users and monitor sales
 
## My Contribution (Farmer Module)
I implemented the `Farmer` class (`Farmer.cs`), which handles all product-related
operations for a logged-in farmer using parameterized ADO.NET queries:
- **AddProduct** — inserts a new product linked to the farmer's ID
- **UpdateProduct** — dynamically updates only the fields the farmer changes
- **RemoveProduct** — deletes a product, restricted to the owning farmer
- **GetMyProducts** — retrieves the farmer's own product list with optional name filtering
 
This class is used by `FormFarmerHome.cs`, `FormAddProduct.cs`, `FormUpdateProduct.cs`,
`FormRmvProduct.cs`, and `FormViewProducts.cs`.
 
## Tech Stack
- C# (.NET Framework 4.7.2)
- Windows Forms
- SQL Server (AgroBridgeDB)
- ADO.NET (SqlConnection, SqlCommand, SqlDataAdapter)
 
## Database
Main tables: `RegistrationTable`, `FarmerTable`, `CustomerTable`, `ProductTable`,
`OrderTable`, `OrderDetailsTable`.