Create database MMS

create table Department (
	department_id varchar(10) PRIMARY KEY,
	department_name varchar(50) NOT NULL,
);

create table Position(
	position_id varchar(10) PRIMARY KEY,
	position_name varchar(50) NOT NULL,
);
Go

create table Staff(
	staff_id varchar(10) PRIMARY KEY,
	staff_name char(150) NOT NULL,
	staff_gender char(20) NOT NULL,
	staff_birth date NOT NULL,
	staff_phone nvarchar(20) NOT NULL,
	staff_email varchar(50) UNIQUE NOT NULL,
	staff_address nvarchar(200) NOT NULL,
	staff_hire_date date NOT NULL,
	staff_base_salary decimal(10, 2) NOT NULL,
	staff_CIC varchar(30) UNIQUE NOT NULL,
	staff_username nvarchar(100) UNIQUE NOT NULL,
	staff_password nvarchar(30) NOT NULL,
	staff_department_id varchar(10) NOT NULL,
	staff_position_id varchar(10) NOT NULL,
	FOREIGN KEY(staff_department_id) REFERENCES dbo.Department(department_id),
	FOREIGN KEY(staff_position_id) REFERENCES dbo.Position(position_id),
);
Go


create table ProductGroup(
	product_group_id varchar(10) PRIMARY KEY,
	product_group_name varchar(50) UNIQUE NOT NULL,
);
Go

create table Inventory(
	inventory_id varchar(10) PRIMARY KEY,
	inventory_status varchar(30) UNIQUE NOT NULL,
);

create table Product(
	product_id varchar(10) PRIMARY KEY,
	product_name nvarchar(200) UNIQUE NOT NULL,
	product_unit_price_sale decimal(10,2) NOT NULL,
	product_VAT decimal(10,2) NOT NULL,
	product_capital_price decimal(10,2) NOT NULL,
	product_stock_quantity int CONSTRAINT CK_StockQuantity CHECK (product_stock_quantity >= 0)  NOT NULL,
	product_image image NULL,
	product_note ntext NULL,
	product_group_id varchar(10) NOT NULL,
	product_status_id int NOT NULL,
	product_inventory_id varchar(10) NOT NULL,
	FOREIGN KEY(product_group_id) REFERENCES dbo.ProductGroup(product_group_id),
	FOREIGN KEY(product_inventory_id) REFERENCES dbo.Inventory(inventory_id),
);
Go

create table Customer(
	customer_id varchar(10) PRIMARY KEY,
	customer_gender varchar(20) NOT NULL,
	customer_birth date NOT NULL,
	customer_phone nvarchar(20) NOT NULL,
	customer_email varchar(50) NULL,
	customer_address nvarchar(150) NOT NULL,
	customer_CIC varchar(30) UNIQUE NOT NULL,
	customer_note text NULL,
);
Go

create table CustomerAdd(
	customer_id varchar(10),
	staff_id varchar(10),
	customer_day_start date NOT NULL,
	PRIMARY KEY (customer_id, staff_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
);
Go


create table Promotion(
	promotion_id varchar(10) PRIMARY KEY,
	promotion_name nvarchar(150) NOT NULL,
	promotion_start_date date NOT NULL,
	promotion_end_date date NOT NULL,
	promotion_discount_percent decimal NOT NULL,
	promotion_minimum_purchar decimal(10,2) NULL,
);
Go

create table ProductPromotion(
	product_id varchar(10),
	promotion_id varchar(10),
	PRIMARY KEY (promotion_id, product_id),
    FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
);

create table CustomerPromotion(
	customer_id varchar(10),
	promotion_id varchar(10),
	PRIMARY KEY (customer_id, promotion_id),
    FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
);
Go

create table Invoice(
	invoice_id BIGINT PRIMARY KEY,
	invoice_symbol varchar(10) NOT NULL,
	invoice_day_created datetime NOT NULL,
	invoice_customer_id varchar(10) NULL,
	invoice_staff_id varchar(10) NOT NULL,
	FOREIGN KEY (invoice_staff_id) REFERENCES Staff(staff_id),
    FOREIGN KEY (invoice_customer_id) REFERENCES Customer(customer_id),
);
Go

create table InvoiceDetail(
	invoice_id BIGINT,
	product_id varchar(10),
	invoice_sale_price decimal(10,2) NOT NULL,
	invoice_product_quantity numeric NOT NULL,
	invoice_total_money decimal(10 ,2) NOT NULL,
	PRIMARY KEY (invoice_id, product_id),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
);
Go

create table SupplierStatus(
	supplier_status_id int PRIMARY KEY,
	supplier_status varchar(30) UNIQUE NOT NULL,
);
Go

create table Supplier(
	supplier_id varchar(10) PRIMARY KEY,
	supplier_name nvarchar(150) NOT NULL,
	supplier_address nvarchar(150) NOT NULL,
	supplier_phone nvarchar(20) NOT NULL,
	supplier_email nvarchar(50) NOT NULL,
	supplier_bank_account nvarchar(50) NOT NULL,
	supplier_tax_code varchar(50) NOT NULL,
	supplier_note text,
	supplier_status_id int NOT NULL,
	FOREIGN KEY (supplier_status_id) REFERENCES SupplierStatus(supplier_status_id),
);
Go

create table SupplierAdd(
	supplier_id varchar(10),
	staff_id varchar(10),
	supplier_day_start date NOT NULL,
	PRIMARY KEY (supplier_id, staff_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
);
Go

create table Receipt(
	receipt_id varchar(10) PRIMARY KEY,
	receipt_symbol varchar(10) NOT NULL,
	receipt_date datetime NOT NULL,
	supplier_id varchar(10),
	staff_id varchar(10),
	FOREIGN KEY (staff_id) REFERENCES Staff(staff_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
);
Go

create table ReceiptDetail(
	receipt_id varchar(10),
	product_id varchar(10),
	receipt_entry_price decimal(10, 2) NOT NULL,
	receipt_entry_amount numeric NOT NULL,
	receipt_total_money decimal NOT NULL,
	PRIMARY KEY (receipt_id, product_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (receipt_id) REFERENCES Receipt(receipt_id),
);
Go

create table PaymentSlip(
	payment_slip_id varchar(10) PRIMARY KEY,
	payer_name char(50) NOT NULL,
	payment_reason text NOT NULL,
	payment_amount decimal NOT NULL,
	payment_amount_words ntext NOT NULL,
	staff_id varchar(10),
	receipt_id varchar(10),
	FOREIGN KEY (staff_id) REFERENCES Staff(staff_id),
    FOREIGN KEY (receipt_id) REFERENCES Receipt(receipt_id),
);
Go


