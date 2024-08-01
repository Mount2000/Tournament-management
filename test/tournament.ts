import {
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployOneYearLockFixture() {
    const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    const JAN_1ST_2030 = 1893456000;
    const JAN_1ST_2031 = JAN_1ST_2030 + ONE_YEAR_IN_SECS;

    // Contracts are deployed using the first signer/account by default

    const Lock = await hre.ethers.getContractFactory("TournamentManagement");
    const lock = await Lock.deploy();

    return { lock, JAN_1ST_2030, JAN_1ST_2031};
  }

  describe("Deployment", function () {
    it("Should set the right JAN_1ST_2031", async function () {
      const { lock, JAN_1ST_2030, JAN_1ST_2031 } = await loadFixture(deployOneYearLockFixture);
      await lock.creatNewTournament('son', JAN_1ST_2030, JAN_1ST_2031 )
      const returnTournament = await lock.getTournament("0xa16e02e87b7454126e5e10d957a927a7f5b5d2be")
      const nameTournament = returnTournament[0]
      expect(nameTournament).to.equal('son')  
    });

  });})