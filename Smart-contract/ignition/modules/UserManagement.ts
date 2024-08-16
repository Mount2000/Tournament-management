import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const UserManagementModule = buildModule("UserManagement", (m) => {
  const userManagement = m.contract("UserManagement", []);

  return { userManagement };
});

export default UserManagementModule;
