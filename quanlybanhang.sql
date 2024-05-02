# Bài 1: Tạo CSDL [20 điểm]:
create schema QUANLYBANHANG;
use QUANLYBANHANG;
create table CUSTOMERS
(
    customer_id varchar(4) primary key not null,
    name        varchar(100)           not null,
    email       varchar(100)           not null unique,
    phone       varchar(25)            not null unique,
    address     varchar(255)           not null
);
create table ORDERS
(
    order_id     varchar(4) primary key not null,
    customer_id  varchar(4)             not null,
    order_date   date                   not null,
    total_amount double                 not null
);
create table PRODUCTS
(
    product_id  varchar(4) primary key not null,
    name        varchar(255)           not null,
    description text,
    price       double                 not null,
    status      bit(1)                 not null
);
create table ORDERS_DETAILS
(
    order_id   varchar(4) not null,
    product_id varchar(4) not null,
    quantity   int(11)    not null,
    price      double     not null,
    primary key (order_id, product_id)
);
alter table ORDERS
    add constraint fk_orders_customer_id
        foreign key (customer_id) references CUSTOMERS (customer_id);
alter table ORDERS_DETAILS
    add constraint fk_orders_details_order_id
        foreign key (order_id) references ORDERS (order_id),
    add constraint fk_orders_details_product_id
        foreign key (product_id) references PRODUCTS (product_id);
# Bài 2: Thêm dữ liệu [20 điểm]:
# Thêm dữ liệu vào các bảng như sau :
# - Bảng CUSTOMERS [5 điểm] :`
insert into CUSTOMERS(customer_id, name, email, phone, address)
values ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
       ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
       ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '9047257844', 'Mộc Châu Sơn La'),
       ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
       ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');
# - Bảng PRODUCTS [5 điểm]:
insert into PRODUCTS(product_id, name, description, price, status)
values ('P001', 'Iphone 13 ProMax', 'Bản 512GB, xanh lá', '22999999', 1),
       ('P002', 'Dell Vostro V3510', 'Core i5, Ram 8GB', '14999999', 1),
       ('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', '28999999', 1),
       ('P004', 'Apple Watch Ultra', 'Titanium Alpime Loop Small', '18999999', 1),
       ('P005', 'Airpods 2 2022', 'Spatial Audio', '4090000', 1);
# + bảng ORDERS [5 điểm]:
insert into ORDERS(order_id, customer_id, total_amount, order_date)
values ('H001', 'C001', 52999997, '2023-02-22'),
       ('H002', 'C001', 80999997, '2023-03-11'),
       ('H003', 'C002', 54359998, '2023-01-22'),
       ('H004', 'C003', 102999995, '2023-03-14'),
       ('H005', 'C003', 80999997, '2022-03-12'),
       ('H006', 'C004', 110449994, '2023-02-01'),
       ('H007', 'C004', 79999996, '2023-03-29'),
       ('H008', 'C005', 29999998, '2023-02-14'),
       ('H009', 'C005', 28999999, '2023-01-10'),
       ('H010', 'C005', 149999994, '2023-04-01');
# + bảng Orders_details [5 điểm]:
insert into ORDERS_DETAILS(order_id, product_id, price, quantity)
values ('H001', 'P002', '14999999', 1),
       ('H001', 'P004', '18999999', 2),
       ('H002', 'P001', '22999999', 1),
       ('H002', 'P003', '28999999', 2),
       ('H003', 'P004', '18999999', 2),
       ('H003', 'P005', '4090000', 4),
       ('H004', 'P002', '14999999', 3),
       ('H004', 'P003', '28999999', 2),
       ('H005', 'P001', '22999999', 1),
       ('H005', 'P003', '28999999', 2),
       ('H006', 'P005', '4090000', 5),
       ('H006', 'P002', '14999999', 6),
       ('H007', 'P004', '18999999', 3),
       ('H007', 'P001', '22999999', 1),
       ('H008', 'P002', '14999999', 2),
       ('H009', 'P003', '28999999', 1),
       ('H010', 'P003', '28999999', 2),
       ('H010', 'P001', '22999999', 4);
# Bài 3: Truy vấn dữ liệu [30 điểm]:
# 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
# [4 điểm]
select name, email, phone, address
from customers;
# 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
# thoại và địa chỉ khách hàng). [4 điểm]
select name, phone, address
from customers
         join ORDERS O on customers.customer_id = O.customer_id
where month(order_date) = 3
  and year(order_date) = 2023
group by name, phone, address;
# 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
# tháng và tổng doanh thu ). [4 điểm]
select month(order_date) Tháng, sum(total_amount) 'Doanh Thu'
from orders
group by month(order_date)
order by month(order_date);
# 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
# hàng, địa chỉ , email và số điên thoại). [4 điểm]
select name, address, email, phone
from customers
where customer_id not in (select customer_id from orders where year(order_date) = 2023 and month(order_date) = 3);
# 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
# sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]
select p.product_id 'Mã Sản Phẩm', name 'Tên Sản Phẩm', sum(OD.quantity) 'Số lượng bán ra'
from PRODUCTS p
         join ORDERS_DETAILS OD on p.product_id = OD.product_id
         join ORDERS O on OD.order_id = O.order_id
where year(order_date) = 2023
  and month(order_date) = 3
group by p.product_id, name;
# 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
# tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]
select c.customer_id, name, sum(total_amount) 'Tổng mức chi tiêu'
from customers c
         join ORDERS O on c.customer_id = O.customer_id
group by c.customer_id, name
order by sum(total_amount) desc;
# 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
# tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]
select name 'Tên KH', ORDERS.total_amount 'Tổng tiền', order_date 'Ngày Đặt', sum(quantity) 'Số lượng sản phẩm'
from orders
         join CUSTOMERS C on orders.customer_id = C.customer_id
         join ORDERS_DETAILS OD on orders.order_id = OD.order_id
group by name, ORDERS.total_amount, order_date
having sum(quantity) >= 5;
#     Bài 4: Tạo View, Procedure [30 điểm]:
# 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
# tiền và ngày tạo hoá đơn . [3 điểm]
create view VIEW_ORDERSDETAIL as
select name, phone, address, total_amount, order_date
from ORDERS_DETAILS
         join ORDERS O on ORDERS_DETAILS.order_id = O.order_id
         join CUSTOMERS C on O.customer_id = C.customer_id
group by name, phone, address, total_amount, order_date;
select *
from VIEW_ORDERSDETAIL;
# 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
# số đơn đã đặt. [3 điểm]
create view VIEW_CUSTOMERDETAIL as
select name, address, phone, count(O.customer_id) 'Số đơn đã đặt'
from customers
         join ORDERS O on customers.customer_id = O.customer_id
group by name, address, phone;
select *
from VIEW_CUSTOMERDETAIL;
# 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
# bán ra của mỗi sản phẩm.
create view VIEW_PRODUCTDETAIL as
select name, description, PRODUCTS.price, sum(quantity) 'Số lượng đã bán'
from products
         join ORDERS_DETAILS OD on products.product_id = OD.product_id
group by name, description, PRODUCTS.price;
select *
from VIEW_PRODUCTDETAIL;
# 4. Đánh Index cho trường `phone` và `email` của bảng Customer. [3 điểm]
create index index_phone on CUSTOMERS (phone);
create index index_email on CUSTOMERS (email);
# 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]
DELIMITER $$
create procedure PROC_GETCUSTOMERDETAIL(customerId_in varchar(4))
begin
    select * from customers where customer_id = customerId_in;
end $$
DELIMITER ;
call PROC_GETCUSTOMERDETAIL('C001');
# 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]
DELIMITER $$
create procedure PROC_GETALLPRODUCT()
begin
    select * from products;
end $$
DELIMITER ;
call PROC_GETALLPRODUCT();
# 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]
DELIMITER $$
create procedure PROC_GETLISTORDERS(customerId_in varchar(4))
begin
    select * from orders where customer_id = customerId_in;
end $$
DELIMITER ;
call PROC_GETLISTORDERS('C001');
# 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
# tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]
DELIMITER $$
create procedure PROC_INSERTORDERS(order_id_in varchar(4), customerId_in varchar(4), total_amount_in double,
                                   order_date_in date)
begin
    insert into orders(order_id, customer_id, order_date, total_amount)
    values (order_id_in, customerId_in, order_date_in, total_amount_in);
    select * from orders where order_id = order_id_in;
end $$
DELIMITER ;
# 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
# thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm]
DELIMITER $$
create procedure PROC_GETTOTALSALE(start_date date, end_date date)
begin
    select name, sum(quantity) 'Số lượng bán ra'
    from products
             join ORDERS_DETAILS OD on products.product_id = OD.product_id
             join ORDERS O on OD.order_id = O.order_id
    where order_date between start_date and end_date
    group by name;
end $$
DELIMITER ;
call PROC_GETTOTALSALE('2022-03-12','2023-02-14');
# 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
# giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. [3 điểm]
DELIMITER $$
create procedure PROC_GETTOTALSALEINMONTH(month_in int, year_in int)
begin
    select name, sum(quantity) 'Số lượng bán ra'
    from products
             join ORDERS_DETAILS OD on products.product_id = OD.product_id
             join ORDERS O on OD.order_id = O.order_id
    where year(order_date)=year_in and month(order_date) = month_in
    group by name
    order by sum(quantity) desc ;
end $$
DELIMITER ;
call PROC_GETTOTALSALEINMONTH(3,2023);