## Session 3: Watering the Roots - Solidity Smart Contracts

In this session, we learn Solidity by building a blockchain game called `LiskGarden`.

### Hardhat Setup

We are now using Hardhat for professional smart contract development. The project has been initialized with Hardhat, and the `hardhat.config.ts` file is configured for Lisk Sepolia.

### `LiskGarden.sol`

This is a simple blockchain game where you can plant, water, and harvest a plant. The contract is located in the `contracts` directory.

### Compiling and Deploying with Hardhat

1.  **Compilation:** To compile the contracts, run:

    ```bash
    npx hardhat compile
    ```

2.  **Deployment:** To deploy the `LiskGarden` contract to the Lisk Sepolia testnet, you need to create a deployment script in the `ignition/modules` directory. Let's create a `deploy.ts` file in `ignition/modules`.

    ```typescript
    import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

    const LiskGardenModule = buildModule("LiskGardenModule", (m) => {
      const liskGarden = m.contract("LiskGarden");

      return { liskGarden };
    });

    export default LiskGardenModule;
    ```

    Then, run the deployment script:

    ```bash
    npx hardhat ignition deploy ignition/modules/deploy.ts --network liskSepolia
    ```

    The contract address will be printed to the console.

### Frontend for `LiskGarden`

A new frontend page `lisk-garden.html` and `lisk-garden.js` are created in the `frontend` directory to interact with the `LiskGarden` contract. This page allows you to:

*   Plant a seed.
*   Water your plant.
*   Harvest your plant.
*   See the status of your plant.

To use it, you need to:

1.  Deploy the `LiskGarden` contract and get its address.
2.  Copy the ABI from `artifacts/contracts/LiskGarden.sol/LiskGarden.json` and the contract address into `frontend/lisk-garden.js`.
3.  Open `frontend/lisk-garden.html` in your browser.
