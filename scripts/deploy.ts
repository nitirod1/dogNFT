import { ethers } from "hardhat";

async function main() {

  const DogNFT = await ethers.getContractFactory("DogNFT");
  const dogNFT = await DogNFT.deploy();
  await dogNFT.deployed();

  console.log("dogNFT deployed to:", dogNFT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
