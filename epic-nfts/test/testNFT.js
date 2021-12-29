const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AwesomeSauce3Words", function () {
  it("Should mint new NFT for 0.01 ETH", async function () {
    const Contract = await ethers.getContractFactory("AwesomeSauce3Words");
    const contract = await Contract.deploy();
    await contract.deployed();

    contract.on("NewEpicNFTMinted", (address, itemId) => {
      console.log(address, itemId);
    });

    let txn = await contract.makeAnEpicNFT({value: hre.ethers.utils.parseEther("0.01")});
    await txn.wait();


  });
});
