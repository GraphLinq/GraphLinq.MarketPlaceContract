require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});


const MAIN_NET_PRIVATE_KEY = "";
const ROPSTEN_PRIVATE_KEY = "";

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    mainnet: {
      url: `https://mainnet.infura.io/v3/f565a35af5f84cbdb50d07b954725a9b`,
      accounts: [`0x${MAIN_NET_PRIVATE_KEY}`],
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/f565a35af5f84cbdb50d07b954725a9b`,
      accounts: [`0x${ROPSTEN_PRIVATE_KEY}`],
    },
  }
};
