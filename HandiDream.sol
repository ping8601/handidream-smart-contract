pragma solidity ^0.8.0;

contract HandiDream {
    struct Producer {
        address producerAddress;
        string name;
        string country;
        string tribe;
        bool isAuthenticated;
    }

    struct Product {
        uint256 id;
        string name;
        string description;
        string material;
        Producer producer;
    }

    // Mapping of trusted producers by their Ethereum address
    mapping(address => Producer) private trustedProducers;

    // Mapping from product ID to Product for easy access
    mapping(uint256 => Product) public products;

    // Counter for product IDs
    uint256 public productCount;

    // Event to emit when a new producer is added
    event ProducerAdded(address indexed producerAddress);

    // Event to emit when a new product is created
    event ProductCreated(uint256 indexed productId);

    // Modifier to check if the caller is an authenticator
    modifier onlyAuthenticator() {
        require(msg.sender == owner, "Only authenticator can perform this action");
        _;
    }

    // Address of the contract owner (Authenticator)
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Function to add a producer
    function addProducer(address _producerAddress, string memory _name, string memory _country, string memory _tribe) public onlyAuthenticator {
        trustedProducers[_producerAddress] = Producer({
            producerAddress: _producerAddress,
            name: _name,
            country: _country,
            tribe: _tribe,
            isAuthenticated: true
        });
        emit ProducerAdded(_producerAddress);
    }

    // Function to create a new product
    function createProduct(string memory _name, string memory _description, string memory _material, address _producerAddress) public returns (uint256) {
        require(trustedProducers[_producerAddress].isAuthenticated, "Producer is not authenticated");

        uint256 newProductId = productCount++;
        products[newProductId] = Product({
            id: newProductId,
            name: _name,
            description: _description,
            material: _material,
            producer: trustedProducers[_producerAddress]
        });
        emit ProductCreated(newProductId);
        return newProductId;
    }

    // Function to get product information by ID
    function getProductInfo(uint256 _productId) public view returns (Product memory) {
        require(_productId < productCount, "Product ID does not exist");
        return products[_productId];
    }
}
