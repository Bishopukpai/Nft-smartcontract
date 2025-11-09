const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFTMarketplace", function () {
  let nftMarketplace;
  let owner, addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();

    const NFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
    nftMarketplace = await NFTMarketplace.deploy();
    await nftMarketplace.deployed();
  });

  it("Should set the correct listing price", async function () {
    const price = await nftMarketplace.getListingPrice();
    expect(price).to.equal(ethers.utils.parseEther("0.0015"));
  });

  it("Should allow creating an NFT", async function () {
    const tokenURI = "https://my-nft.com/metadata/1";
    const price = ethers.utils.parseEther("0.01");

    await nftMarketplace.connect(addr1).createToken(tokenURI, price, {
      value: await nftMarketplace.getListingPrice()
    });

    const marketItems = await nftMarketplace.fetchMarketItem();
    expect(marketItems.length).to.equal(1);
    expect(marketItems[0].price).to.equal(price);
  });
});
