# HandiDream

HandiDream is a blockchain-based platform designed to authenticate and record products created by verified producers. This platform utilizes Ethereum smart contracts to ensure transparency and reliability in the tracking of genuine handmade products.

## Features

- Authenticate producers to ensure only verified products are listed.
- Create and retrieve detailed product information securely on the blockchain.
- Utilize events to log actions on the blockchain for transparency.

## Prerequisites

- Node.js and npm (Node Package Manager)
- Hardhat
- Ethereum Wallet (e.g., MetaMask)

## Setup and Installation

1. **Install dependencies:**

   ```bash
   npm init
   npm install --save-dev hardhat
   ```

2. **Set up Hardhat:**

   In the project directory, initialize Hardhat:

   ```bash
   npx hardhat init
   ```

   Then, install the necessary Hardhat toolbox for development:

   ```bash
   npm install --save-dev "hardhat@^2.18.2"
   npm install --save-dev @nomicfoundation/hardhat-toolbox
   ```

   Update hardhat.config.js:

   ```javascript
   require("@nomicfoundation/hardhat-toolbox");
      /** @type import('hardhat/config').HardhatUserConfig */
      module.exports = {
      solidity: "0.8.24",
   };
   ```

   Within the contracts directory, create the following smart contract named HandiDream.sol (https://github.com/ping8601/handidream-smart-contract/blob/main/HandiDream.sol).


3. **Compile the smart contract:**

   Ensure that the smart contract `HandiDream.sol` is in the `contracts` directory, then run:

   ```bash
   npx hardhat compile
   ```

## Interacting with the Smart Contract

Use the following command to open the console:

```bash
npx hardhat console
```

### Deploy the Smart Contract

Run the following command to require the ethers library in the Hardhat console:

```javascript
const { ethers } = require("hardhat");
```

Then, get contract factory and deploy the contract:
```javascript
const HandiDream = await ethers.getContractFactory("HandiDream");
const handiDream = await HandiDream.deploy();
```

### Get Signers

Get the signers (accounts) to interact with the contract:

```javascript
const [Alice, Bob] = await ethers.getSigners();
```

### Add a Producer

Assuming the sender is the authenticator, add a producer to the platform:

```javascript
await handiDream.addProducer(Bob.address, "Bob", "USA", "Navajo")
```

### Create a Product

Once a producer is added, they can create products:

```javascript
const tx  = await handiDream.createProduct("Handmade Vase", "Ceramic handmade vase.", "Ceramic", "https://example.jpg", Bob.address)
const txReceipt = await tx.wait();

const productCreatedEvent = txReceipt.logs.find(log => log.fragment.name === "ProductCreated");
const productId = productCreatedEvent.args[0];
```

### Retrieve Product Information

To get information about a specific product, use the `getProductInfo` function with the product ID as an argument:

```javascript
productInfo = await handiDream.getProductInfo(productId)
```
