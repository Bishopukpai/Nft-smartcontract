# NFT Marketplace 

A fully functional NFT Marketplace smart contract deployed on ethereum testnet (Sepolia). This application allows users, to mint, list and trade nfts. 

**Deployed Contract address:** 0x078101bC59Ec52547C0a5E270b1695e84151861C

**EtherScan link:** https://sepolia.etherscan.io/address/0x078101bC59Ec52547C0a5E270b1695e84151861C

## Technologies used

### Blockchain
- Ethereum

### Smart Contract language
- Solidity
### Development tools
- Hardhat
- Ethers.js
### Storage
- IPFS

## Features
- NFT Minting
- NFT Listing for sale
- NFT Purchase
- NFT Sales

## Getting Started with testing

### Clone the repo
- In your terminal (Integrated Visual Studio Code terminal or command prompt), run:  

`git clone https://github.com/Bishopukpai/Nft-smartcontract.git`

- Navigate into the cloned repository with:

`cd Nft-smartcontract` 

- Then install all dependencies with:

`npm install`

### Interact with the smart contract

There two ways you can interact with this smart contract. You can either redeploy the smart contract or you can use the deployed contract's address.

**Option A:** **Use the already deployed contract's address**

- Go to https://remix.ethereum.org/ in your browser
- Navigate into the file explorer tab
  
<img width="1436" height="776" alt="Screenshot 2025-11-10 003909" src="https://github.com/user-attachments/assets/cbcaa14e-c743-4c7b-9df0-2b86899cfd6b" />

- Then select `contracts` folder
- Then click on the create new file icon
- Then enter the name of the file (NftMarketplace.sol) and save the file
- Copy the code from the `Nftmarketplace.sol` inside the `contracts` folder in the cloned repository and paste it inside the `NftMarketplace.sol` file in the Remix IDE
- Now you can compile and start testing the smart contract
  - Go to the Deploy and Run contracts tab
    <img width="1442" height="745" alt="Screenshot 2025-11-10 005138" src="https://github.com/user-attachments/assets/690a0efd-f6c4-4b4c-ba7e-b8da75a9c2dc" />
  - Under the `ENVIRONMENTS` Section, select Browser Extension -> Inject Provider -> Metamask
  - In the `At Address` input box, paste the deployed contract address [0x078101bC59Ec52547C0a5E270b1695e84151861C]
    
  - Click on the Compile button at the top of your Remix IDE's workspace
    
    <img width="1442" height="722" alt="Screenshot 2025-11-10 005759" src="https://github.com/user-attachments/assets/510ca1c1-4b56-4da7-99d3-ee7af2f41315" />
  - Or if this does not work, Go to the compiler tab in your Remix IDE, Select the right compiler version (the same version with your smart contract). Then Click on the `Compile NftMarketplace.sol` button. This will compile your smart contract and you will be able to click on the `At Address` button to deploy your smart contract. Check under the deployed Contract section in the Deploy and run tab and you will see your deployed contract

    <img width="431" height="821" alt="Screenshot 2025-11-10 010648" src="https://github.com/user-attachments/assets/b448c19a-4248-4807-b8b9-0d3cf7af8575" />.
  - You can start interacting with the smart contract.

**Option B:** **Reploy the smart contract to get another deployed address**

If you like you can redeploy the smart contract to another address. To do this:

  - Create a `.env` file in the root of the cloned repository. Your `.env` file should be in the level with your `hardhat.config.js` file
    <img width="1480" height="842" alt="Screenshot 2025-11-10 011659" src="https://github.com/user-attachments/assets/4e047c42-0ca9-43c3-b5d6-ac8ebbc34821" />
  - Then add these variables in it
    - PRIVATE_KEY=your_sepolia_wallet_private_key
    - INFURA_PROJECT_ID=your_infura_project_id.
  
  **Note: Do not Use real wallet private key, to avoid spending real ethers. Also do not share your private key with the public by pushing the `.env` file with other codes to Github. Always add your `.env` file in the gitignore file**

  - Deploy the smart contract by running `npx hardhat run scripts/deploy.js --network Sepolia`. And your smart contract will be deployed.
  - Follow the steps in option A, but replace the ddeployed Address with yours. Now you can start Interacting with the smart contract.
      
**Minting NFTs**
- Locate the createToken() function under the deployed smart contract section
  <img width="697" height="746" alt="Screenshot 2025-11-10 144551" src="https://github.com/user-attachments/assets/5e318663-663a-484d-8690-e7fe58f0c833" />
- Enter a random string as the tokenURI and then the token price in wei (preferrably 10000000000000000 wei)
- Then set the transaction value to be 15000000000000000( Ensure that you have 0.0015 Eth in your Sepolia wallet)
  <img width="1431" height="613" alt="Screenshot 2025-11-10 145317" src="https://github.com/user-attachments/assets/55c15687-e67a-485a-a8ba-92a39e32e1bb" />

- Click on `transact`. This will create the NFT token and place in the market for sale. You can see the newly created NFT token, by calling the `fetchItemsListed` function

**Selling NFTs**
To sell your NFT:
- Locate the `createMarketSale` function
- Enter 1 as the tokenId
- Click on transact and the nft gets sold. You will get a confirmation of this transaction in your meta mask wallet.

<img width="977" height="886" alt="Screenshot 2025-11-10 145723" src="https://github.com/user-attachments/assets/0b9694a2-fd28-4f98-b11f-c46ae835a0bd" />
