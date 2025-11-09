// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// INTERNAL IMPORT FROM OPENZEPPELINE FOR NFT BUILDING
import "@openzeppelin/contracts/utils/Counters.sol";
//This package will helps us track how many items (nfts) are being created and sold on our platform
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

// Create the contract
contract NFTMarketplace is ERC721URIStorage{
    // Make use of the counter from Counter.sol
    using Counters for Counters.Counter;

    // Define state variables
    Counters.Counter private _tokenIds;// Gives each nft holder an identification
    Counters.Counter private _itemsSold;// keeps track of the number of tokens that are being sold
    uint256 listingPrice = 0.0015 ether; 

    // Create an address variable to allow owners (anyone that deploys the samrt contract) receive payment
    address payable owner;

    mapping(uint256 => MarketItem) private idMarketItem;

    // Define the struct for the market Item
    struct MarketItem {
        uint256 tokenId;
        address payable seller;// address of the nft creator
        address payable owner;
        uint256 price;
        bool sold; // This tracks if the nft has been sold or not
    }

    // This will triger an event whenever a buy or sell transaction happens on our platform
    event idMarketItemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    // Create a modifier that will allow only owners of this smart contract to modify the listing price of nfts
    // This modifier will be past to the updateListingPrice function to allow only contract owners to call it.
    modifier onlyOwner{
        // This ensures that the person calling this function is the owner of the smart contract
        require(msg.sender == owner, "Only contract owners can modify this listing price");
        _;
        // The underscore (_) above indicates that the modifier was satisfied and the function can be called
    }

    // This will assign a symbol to all the nfts in our platform
    constructor() ERC721("NFT Metavarse Token", "MYNFT"){
         owner = payable(msg.sender);
    }

    // This function will charge users certain amount for creating nfts on our platform
    function updateListingPrice(uint256 _listingPrice) public payable onlyOwner{
        listingPrice = _listingPrice;
    }

    // This function will allow us fetch the listing price
    // So that creators can know how much they will pay for creating nfts
    function getListingPrice() public view returns(uint256){
        return listingPrice;
    }

    // This function allows users to create nft token
    //Between createToken and createMarketItem which one should come first when interacting with
    //This smart contract on Remix IDE
    function createToken(string memory tokenURI, uint256 price) public payable returns(uint256){
        // This function takes the token url (tokenURI) of the nft and also the price of the nft that the creator want to assign to it

        // Whenever a user creates an nft, the token id needs to be increase
        // So, I called the increment() method on the tokenIds variable
        _tokenIds.increment();

        // This function assigns the current nuumber of tokenIds after increment to a new variable
        // This new token Id will be assigned to the nft that was just created
        uint256 newTokenId = _tokenIds.current();

        _mint(msg.sender, newTokenId);
            //The mint function will first check the address sending the nft
            // Then it will check if the tokenId already exists or not 
        
        // Then we can now set the new token's url
        _setTokenURI(newTokenId, tokenURI);

        createMarketItem(newTokenId, price);

        return newTokenId;
    }

    //This function will create the nft itself
    //It will also assign all the data of that nft to it
    //This function will receive two data (the token id and the nft's price)
    // This will be a private function because we are calling it internally 
    function createMarketItem(uint256 tokenId, uint256 price) private {
        //First we have to check that the nft price is greater zero
        require(price > 0, "Price must be greater that 0");

        //We also have to check that the msg.value  is equal to listing price
        //This is because we have to deduct our commission from the price of the nft
        // So the nft price must be greater or equal to our listing price

        require(msg.value == listingPrice, "NFT's price must be equal to platform's listing price");

        //Each Nft will have a unique Id that is stored inside the idMarketItem
       // We will use this by passing the id to find the nft.

       // Here we are calling a unique id for the nft and we are calling the struct (MarketItem) and updating the data
       idMarketItem[tokenId] = MarketItem(
            tokenId,
            payable(msg.sender),
            //This means that the nft or the money belonng to the contract
            payable(address(this)),
            price,
            //Clearly the nft has not been sold
            //So we set the sold status to false
            false
       );

       _transfer(msg.sender, address(this), tokenId);
    
   
       emit idMarketItemCreated(tokenId, msg.sender, address(this), price, false);
    }

    //FUNCTION FOR Token sales
    function resellToken(uint256 tokenId, uint price) public payable{
        require(idMarketItem[tokenId].owner == msg.sender, "Only Item owner can perform this operation");

        require(msg.value == listingPrice, "Price must be equal to or greater than listing price");

        idMarketItem[tokenId].sold = false;
        idMarketItem[tokenId].price = price;
        idMarketItem[tokenId].seller = payable(msg.sender);
        idMarketItem[tokenId].owner = payable(address(this));

        _itemsSold.decrement();

        _transfer(msg.sender, address(this), tokenId);

    }

    //Function to create item for market sale
    function createMarketSale(uint256 tokenId) public payable{
        uint256 price = idMarketItem[tokenId].price;

        require(msg.value == price, "Please submit the asking price in order to purchase this nft");

        idMarketItem[tokenId].owner = payable(msg.sender);
        idMarketItem[tokenId].sold = true;
        idMarketItem[tokenId].owner = payable(address(0));

        _itemsSold.increment(); 
        _transfer(address(this), msg.sender, tokenId);

        payable(owner).transfer(listingPrice);
        payable(idMarketItem[tokenId].seller).transfer(msg.value);

    }

    //FUNCTION TO GET UNSOLD NFT DATA
    function fetchMarketItem() public view returns(MarketItem[] memory){
        uint256 itemCount = _tokenIds.current();
        uint256 unSoldItemCount = _tokenIds.current() - _itemsSold.current();
        uint256 currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unSoldItemCount);
        for (uint256 i = 0; i < itemCount; i ++){
            if(idMarketItem[i + 1].owner == address(this)){
                uint256 currentId = i + 1;

                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;   
            }
        }
        return items;
    }

    function fetchMyNFT() public view returns(MarketItem[] memory){
        uint256 totalCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;


        for (uint256 i = 0; i < totalCount; i++){
            if(idMarketItem[i + 1].owner == msg.sender){
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);

        for (uint256 i = 0; i < totalCount; i ++){

            if(idMarketItem[i + 1].owner == msg.sender){
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    //SINGLE USER ITEMS
    function fetchItemsListed() public view returns (MarketItem[] memory){
        uint256 totalCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for(uint256 i = 0; i < totalCount; i ++){
            if(idMarketItem[i + 1].seller == msg.sender){
                itemCount += 1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        for(uint256 i = 0; i < totalCount; i ++) {
            if(idMarketItem[i + 1].seller  == msg.sender){
                uint256 currentId = i + 1;

                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }    
}