import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const TournamentModule = buildModule("Tournament", (m) => {
  const tournament = m.contract("TournamentManagement", []);

  return { tournament };
});

export default TournamentModule;
