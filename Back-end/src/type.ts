// src/types.ts


export interface TransactionDetails {
    to: string;
    value: string; // Amount in ETH
    gasLimit?: number; // Optional
    gasPrice?: string; // Optional, in gwei
}
export interface user {
    address: string;
    uri: string;
}