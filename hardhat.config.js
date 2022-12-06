require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
    solidity: {
        compilers: [
          {
            version: "0.8.9",
            settings: {
              optimizer: {
                enabled: true,
                runs: 5000,
                details: {
                  yul: true,
                  yulDetails: {
                    stackAllocation: true,
                    optimizerSteps: "dhfoDgvulfnTUtnIf"
                  }
                }              },
            },
          },
        ],
                  
    artifacts: './artifacts',
  },

  networks: {
    arbG: {      

        url:"https://arb-goerli.g.alchemy.com/v2/ZJpzOvIi5Z0K9uCxKITeC2xlWwdt6S-h",
        accounts:["0x" + process.env.arbkey],
      chainId: 421613
    },
    hardhat: {
      chainId: 5
    }
  }
};