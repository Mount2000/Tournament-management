/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import {
  Contract,
  ContractFactory,
  ContractTransactionResponse,
  Interface,
} from "ethers";
import type { Signer, ContractDeployTransaction, ContractRunner } from "ethers";
import type { NonPayableOverrides } from "../../common";
import type {
  MatchManagement,
  MatchManagementInterface,
} from "../../contracts/MatchManagement";

const _abi = [
  {
    inputs: [],
    name: "matchCount",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "matchId",
        type: "uint256",
      },
    ],
    name: "matches",
    outputs: [
      {
        internalType: "uint32",
        name: "player1",
        type: "uint32",
      },
      {
        internalType: "uint32",
        name: "player2",
        type: "uint32",
      },
      {
        internalType: "uint32",
        name: "winner",
        type: "uint32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;

const _bytecode =
  "0x608060405234801561001057600080fd5b50610209806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80634768d4ef1461003b57806379c4264b1461006d575b600080fd5b61005560048036038101906100509190610126565b61008b565b60405161006493929190610172565b60405180910390f35b6100756100e5565b60405161008291906101b8565b60405180910390f35b60016020528060005260406000206000915090508060000160009054906101000a900463ffffffff16908060000160049054906101000a900463ffffffff16908060020160009054906101000a900463ffffffff16905083565b60005481565b600080fd5b6000819050919050565b610103816100f0565b811461010e57600080fd5b50565b600081359050610120816100fa565b92915050565b60006020828403121561013c5761013b6100eb565b5b600061014a84828501610111565b91505092915050565b600063ffffffff82169050919050565b61016c81610153565b82525050565b60006060820190506101876000830186610163565b6101946020830185610163565b6101a16040830184610163565b949350505050565b6101b2816100f0565b82525050565b60006020820190506101cd60008301846101a9565b9291505056fea26469706673582212208bc14475f3f3782c126c8eb7492c8592cab7ae9aa2f5eedb5ca0c4c8cc3268ff64736f6c63430008180033";

type MatchManagementConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: MatchManagementConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class MatchManagement__factory extends ContractFactory {
  constructor(...args: MatchManagementConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override getDeployTransaction(
    overrides?: NonPayableOverrides & { from?: string }
  ): Promise<ContractDeployTransaction> {
    return super.getDeployTransaction(overrides || {});
  }
  override deploy(overrides?: NonPayableOverrides & { from?: string }) {
    return super.deploy(overrides || {}) as Promise<
      MatchManagement & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(runner: ContractRunner | null): MatchManagement__factory {
    return super.connect(runner) as MatchManagement__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): MatchManagementInterface {
    return new Interface(_abi) as MatchManagementInterface;
  }
  static connect(
    address: string,
    runner?: ContractRunner | null
  ): MatchManagement {
    return new Contract(address, _abi, runner) as unknown as MatchManagement;
  }
}
