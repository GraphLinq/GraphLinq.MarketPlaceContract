async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Token = await ethers.getContractFactory("MarketPlaceGraphLinqGateway");
    const token = await Token.deploy("0xccbb043f94c49be8d448582cab9158cdfc57a0a1", "0xeB4A6F3d8154A18aD312692eCFE4eeF8Fde66439");

    console.log("Token address:", token.address);
}
  
main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});