create table if not exists product(
	name text primary key
);

create table if not exists category(
	name text primary key
);
	
create table if not exists product_category_link(
	product_name text references product,
	category_name text references category,
	constraint product_category_uniq unique(product_name, category_name)
);

insert into product(name)
values('product_1'), ('product_2'), ('product_3')
on conflict do nothing;

insert into category(name)
values('category_1'), ('category_2'), ('category_3')
on conflict do nothing;

insert into product_category_link(category_name, product_name)
values('category_1', 'product_1'), ('category_1', 'product_2'), ('category_2', 'product_2'), ('category_3', 'product_1')
on conflict do nothing;

-- с повторяющимися значениями продуктов в первой колонке
select product.name as product_name, category_name
from product
left join product_category_link on product_category_link.product_name = product.name;

-- без повторяющихся значений продуктов в первой колонке
select product.name as product_name, category_names
from product
join lateral (
	select string_agg(distinct category_name, ',') as category_names
	from product_category_link
	where product_category_link.product_name = product.name
) as l on true
