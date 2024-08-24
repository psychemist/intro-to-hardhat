const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("AreaCalculatorModuleV3", (m) => {
  const areaCalculator = m.contract("AreaCalculator");
  return { areaCalculator };
});


// const { ethers } = require("hardhat");

// async function main() {
//     const AreaCalculator = await ethers.getContractFactory("AreaCalculator");
//     console.log("Deploying AreaCalculator...");
//     const areaCalculator = await AreaCalculator.deploy();
//     await areaCalculator.deployed();
//     console.log("AreaCalculator deployed to:", areaCalculator.address);
// }

// main()
//     .then(() => process.exit(0))
//     .catch((error) => {
//         console.error(error);
//         process.exit(1);
//     });