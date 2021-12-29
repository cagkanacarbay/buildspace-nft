async function main() {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    let txn = await nftContract.makeAnEpicNFT({value: hre.ethers.utils.parseEther("0.01")});
    await txn.wait();

    txn = await nftContract.makeAnEpicNFT();
    await txn.wait()
};
  
async function runMain() {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();
