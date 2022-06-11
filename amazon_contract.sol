pragma solidity 0.6.12;

contract amazon {
    uint  counter = 1;
    struct Product {
        string title; 
        string desc;
        uint productId ;
        address payable seller;
        uint price; // in wei
        address buyer;
        bool delivered; 
    }
    event registered(string title, uint productId, address seller);
    event bought(uint productId, address buyer);
    event delivered(uint productId);

    Product[] public products;
    // Product registration 
    function registerProduct (string memory _title, string memory _desc, uint _price) public{
        //Enter product details including the seller
        require (_price > 0, "Price should be greater than zero");
        Product memory tempProduct;
        tempProduct.title = _title;
        tempProduct.desc = _desc;
        tempProduct.price = _price * 10**18;
        tempProduct.seller = msg.sender;
        tempProduct.productId = counter; 
        products.push(tempProduct);
        counter++; // Adding to the counter
        emit registered(_title, tempProduct.productId, msg.sender);
    }
    // buyer buys the product 
    function buy (uint _productId) payable public {
        require (products[_productId - 1].price == msg.value, "Pay the exact price");
        require (products[_productId - 1].seller != msg.sender, "You cant buy your own product");
        products[_productId - 1].buyer = msg.sender;   
        emit bought(_productId, msg.sender);
    } 
    // buyer confirms delivery so money will be transferred to the seller
    function delivery (uint _productId) payable public {
        //Only buyer of the product should confirm delivery
        require( products[_productId - 1].buyer == msg.sender, "Only buyer can confirm delivery");
        products[_productId - 1].delivered = true;
        products[_productId - 1].seller.transfer(products[_productId - 1].price);
        emit delivered(_productId);
    }
}
