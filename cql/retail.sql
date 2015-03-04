/* assumption is that which it will be a mix of OLTP and OLAP schema */

CREATE KEYSPACE retail WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': '1'
};

USE retail;

CREATE TABLE locations(
	location_id UUID,
	store_id UUID,
	PRIMARY KEY(location_id, store_id)
);

CREATE TABLE stores(
	store_id UUID,
	store_address TEXT,
	store_phone_numbers set<TEXT>,
	store_hours set<TEXT>,
	tax_rate decimal,
	number_of_express_registers integer,
	number_of_full_registers integer,
	PRIMARY KEY(store_id)
);

CREATE TABLE brands(
	brand_id UUID PRIMARY KEY,
	name TEXT
);

/* details of product by product id */
CREATE TABLE products(
	product_id UUID,
	sale_price decimal,
	msrp decimal,
	-- savings = (msrp - sale_price) -- calculated column
    title TEXT,
    PRIMARY KEY(product_id, price)
) WITH CLUSTERING ORDER BY (price DESC)
;

/* employees by store */
CREATE TABLE employees(
	store_id UUID,
	employee_id UUID,
	name TEXT,
	last_initial TEXT,
	PRIMARY KEY( store_id, employee_id)
);

/* 
for each product sold on a register how much time it takes to scan using drawer closing time
also using the index we can run queries for a particular employeeid 
*/
CREATE TABLE registers(
	register_id UUID,
	product_id UUID,
	drawer_closing_time decimal,
	receipt_id UUID,
	scan_time TIMEUUID,
	store_id UUID,
	employee_id UUID,
	receipt_id UUID,
	PRIMARY KEY(register_id, product_id, drawer_closing_time)
);

create index idx_registers_employee_id on registers(employee_id)
;

/* which product sells the most and which store */
CREATE TABLE quantity_sold_by_product_id(
	store_id UUID, 
	product_id UUID,
	quantity_of_item COUNTER, 
	PRIMARY KEY((store_id, product_id))
);

/* details of which products sold by reciept number */
CREATE TABLE receipts(
	receipt_id UUID,
	product_id UUID,
	quantity_of_item decimal, 
	scan_time TIMEUUID,
	sale_price decimal,
	total_information TEXT,
	payment information TEXT,
	PRIMARY KEY((receipt_id, product_id), quantity_of_item, scan_time)
);
