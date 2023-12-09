import "@nomiclabs/hardhat-ethers";
const { ethers } = require("hardhat");

async function main() {
  const verifier = await ethers.deployContract("Verifier");
  await verifier.waitForDeployment();

  const _verifierAddress = verifier.getAddress();

  const appId = BigInt(`${process.env.NEXT_PUBLIC_APP_ID}`);

  const anonAadhaarVerifier = await ethers.deployContract(
    "AnonAadhaarVerifier",
    [_verifierAddress, appId]
  );
  await anonAadhaarVerifier.waitForDeployment();

  const _anonAadhaarVerifierAddress = anonAadhaarVerifier.getAddress();

  const deCert = await ethers.deployContract("DeCert", [
    _anonAadhaarVerifierAddress,
  ]);

  await deCert.waitForDeployment();

  console.log(`Vote contract deployed to ${await deCert.getAddress()}`);
}

// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
