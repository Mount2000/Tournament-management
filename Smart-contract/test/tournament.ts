import {
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import {ethers} from "hardhat";

describe("Tournament", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployOneYearLockFixture() {
    const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    const JAN_1ST_2030 = 1893456000;
    const JAN_1ST_2031 = JAN_1ST_2030 + ONE_YEAR_IN_SECS;
    
    // Deploy VRF Random

    const VRF = await ethers.getContractFactory("VRF");
    const vrf = await VRF.deploy("100000000000000000", "1000000000", "4152793772500397");
    // Deploy TournamentManagement

    // const Tournament = await ethers.getContractFactory("TournamentManagement");
    // const tournament = await Tournament.deploy("1242512",String(vrf.target), "0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae");

    return {vrf, JAN_1ST_2030, JAN_1ST_2031};
  }

  describe("Creat new tournament", function () {
    it("Should set the right tournament", async function () {
      const {vrf, JAN_1ST_2030, JAN_1ST_2031 } = await loadFixture(deployOneYearLockFixture);
      const tx = await vrf.createSubscription();
      await vrf.on("SubscriptionCreated", (e)=>{console.log(e);
      })

        // Extract events from the receipt
      // console.log(receipt)
      expect( await vrf.createSubscription()).to.emit(vrf, "x");
    });

  });})

// async function test(){
//   const VRF = await ethers.getContractFactory("VRF");
//     const vrf = await VRF.deploy("100000000000000000", "1000000000", "4152793772500397");
//     const subID = await vrf.createSubscription()
//     console.log(subID)
// }