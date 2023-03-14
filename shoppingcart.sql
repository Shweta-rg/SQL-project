DROP TABLE shoppingcart;
CREATE TABLE `shoppingcart` (
	`item_code` INT(11) NOT null,
	`quantity` INT(11) NOT NULL,
	`customerNumber` INT(11) NOT NULL,
	`cart_id` INT(11) NOT null,
	`cart_status` VARCHAR(10) NOT NULL DEFAULT 'draft',
	UNIQUE INDEX `customerNumber_cart_id` (`customerNumber`, `cart_id`)
)


CREATE PROCEDURE pinsertshopping(IN custNum INT ,IN Qty INT, IN item_code VARCHAR(20))
BEGIN
DECLARE @cart_id INT

/*Check if Customer Exist*/
if( NOT EXISTS(SELECT 1 FROM Customer WHERE customerNumber = @custNum  ))
{
   print 'Customer Not Available'
   EXIT 
   
   /* update into shopping cart*/
}

/*Check if Item Exist*/
DECLARE @AvailQty INT 

SELECT @AvailQty = quantityInStock FROM products WHERE ItemCode = @Item_code 

if(@AvailQty IS NULL))
{
   print 'Item Code Not Avilable'
   EXIT 
   
   /* update into shopping cart*/
}
if(@AvailQty < @Qty )
{
  print 'Item Qty not available'
}
/*
-- first time putting item 
 a) FIRST TIME ever just AFTER creating customer record 
 
b) FIRST TIME AFTER completing the LAST ORDER

c) Cart has already been drafted previously AND customer IS adding OR updating item
*/
SELECT @cart_id = cart_id 
FROM shoppingcart
WHERE  customernumber = @custNum AND cart_status='draft'



if(@cart_id IS NOT NULL)
{


   IF @Qty = 0
   BEGIN 
    DELETE FROM shoppingcart WHERE cart_id = @cart_id AND item_code = @item_code 
   END 
  
  IF EXISTS(SELECT 1
				FROM shoppingcart
				WHERE cart_id = @cart_id AND item_code = @item_code )

   /* update into shopping cart*/
	BEGIN 
	
	   UPDATE shoppingcart
   	SET Qty = @qty
   	WHERE  cart_id = @cart_id AND item_code = @item_code 
	END 
   ELSE
	BEGIN  
	    INSERT INTO shopingcart(cart_id, customernumber,
		 VALUES (@cart_id)
   
   END 
}
ELSE 
{
  /*customer is adding item first time in cartt/

   /* insert into shopping cart*/
   SELECT @cart_id = MAX(IFNULL(cart_id,0)) + 1  
   FROM shoppingcart
   
	    INSERT INTO shopingcart(item_code, quantity, customerNumber, cart_id, cart_status)
		 
       VALUES(item_code,Qty,custNum )
}


}

/*
if(shoppingcart.col1=products.productCode)
{
if(shoppingcart.col2<products.quantityInStock)
{
INSERT INTO shoppingcart(col1,col2,col3,cart_id)
VALUES(item_code,quantity,customerNumber,cart_id);
UPDATE products
SET products.quantityInStock=products.quantityInStock-shoppingcart.col2;
}
ELSE 'limited quantity available';
end if
}
ELSE "product not available';
end if;
}ELSE "setup account first";
END if

end

*/

IF EXISTS( SELECT item_code 
FROM shoppingcart 
INNER JOIN products ON products.item_code = shopptingcart.item_code 
WHERE cart_id = @cart_id AND products.quantityavailable < shoppingcart.qty )
 print 'Order cannot be placed, item out of stock'
