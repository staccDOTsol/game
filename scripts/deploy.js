const { ethers } = require( "hardhat" );

async function main() {

  const Lock = await ethers.getContractFactory("Game");
  const lock = await Lock.deploy((10 * 10 ** 15).toString());

  await lock.deployed();
  console.log(`burp to ${lock.address}`);
  const aa = await ethers.getContractFactory("SomeTeam")
  const AA = await aa.deploy(lock.address, "RED", "RED");

  const BB = await ethers.getContractFactory("SomeTeam")
  const bb = await BB.deploy(lock.address, "B", "B");

  const CC = await ethers.getContractFactory("SomeTeam")
  const cc = await CC.deploy(lock.address, "G", "G");

  const DD = await ethers.getContractFactory("SomeTeam")
  const dd = await DD.deploy(lock.address, "Y", "Y");
  await dd.deployed();
await lock.setTeams(AA.address, bb.address, cc.address, dd.address)

  console.log(`burp to ${lock.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
