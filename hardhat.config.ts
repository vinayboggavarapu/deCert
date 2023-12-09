require("@nomicfoundation/hardhat-toolbox");
require("hardhat-dependency-compiler");
require("dotenv").config();

module.exports = {
  solidity: "0.8.10",
  // dependencyCompiler: {
  //   paths: ["anon-aadhaar-contracts/contracts"],
  // },
  networks: {
    SepoliaETH: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.NEXT_PUBLIC_ALCHEMY_API_KEY}`,
      accounts: [`${process.env.NEXT_PUBLIC_SepoliaETH_PRIVATE_KEY}` || ""],
    },
  },
};
