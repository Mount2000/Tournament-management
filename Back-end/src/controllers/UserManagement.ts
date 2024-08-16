import { ethers } from "ethers";
import { Request, Response, NextFunction } from 'express';
import "dotenv/config";
import { PinataSDK } from "pinata";
import axios from 'axios';
import FormData from 'form-data';
import User from "../models/userModel";
import { user } from "../type";
import connectDatabase from "../config/database";
import { UserInfo } from "os";
const provider = new ethers.JsonRpcProvider(process.env.AMOY_URL_RPC)
const contractAddress = '0x285f3892C16e7000845eA77d3D058477dDf6D6c5';
const contractABI = [
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        }
      ],
      "name": "OwnableInvalidOwner",
      "type": "error"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "account",
          "type": "address"
        }
      ],
      "name": "OwnableUnauthorizedAccount",
      "type": "error"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "previousOwner",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "OwnershipTransferred",
      "type": "event"
    },
    {
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "renounceOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "URI",
          "type": "string"
        },
        {
          "internalType": "address",
          "name": "user",
          "type": "address"
        }
      ],
      "name": "setUserURI",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "transferOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "name": "userURIs",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ];
const wallet = new ethers.Wallet(String(process.env.PRIVATE_KEY), provider);

export async function setUserInfor(req:Request){
  const contract = new ethers.Contract(contractAddress, contractABI, wallet)
  const userAddress : string = req.body.address;
  const infor: object = req.body.infor;
  const ipfsHash = await uploadObjectToIPFS(infor);
  if (ipfsHash){
  const tx = await contract.setUserURI(ipfsHash, userAddress);
  console.log(tx.hash);
  }
}
export async function getInforFromContract (req: Request, res: Response){
    const contract = new ethers.Contract(contractAddress, contractABI, provider)
    const address = req.body.address;
    const ipfsHash = await contract.userURIs(address);
    const data = await getFileFromIPFS(ipfsHash);
    const response = await insertUserToDB(address, data?.data);
    return res.status(200).json({
      success: response ? true : false,
      mes: response ? 'Added product to wishlist' : 'Some thing wrong'
  })
}

async function insertUserToDB(address: string, user:any){
  const userInfor = await User.findOne(user)
  if(userInfor){
    return false;
  }
  else{
    await User.create(user)
    return true;
  }
}

async function uploadObjectToIPFS(object: object) {
  try {
    
    const jsonString = JSON.stringify(object);
        
        // Create a FormData instance
        const form = new FormData();
        form.append('file', Buffer.from(jsonString), {
            filename: 'object.json',
            contentType: 'application/json'
        });

        // Make the POST request to Pinata
        const response = await axios.post('https://api.pinata.cloud/pinning/pinFileToIPFS', form, {
            headers: {
                ...form.getHeaders(),
                'pinata_api_key': process.env.PINATA_API_KEY,
                'pinata_secret_api_key': process.env.PINATA_SECRET_API_KEY
            }
        });

        return response.data.IpfsHash;
  } catch (error) {
    console.error('Error uploading object to IPFS:', error);
  }
};

async function getFileFromIPFS(IpfsHash: string){
  try {
    const pinata = new PinataSDK({
      pinataJwt: process.env.PINATA_JWT!,
      pinataGateway: process.env.GATEWAY_URL,
    });
    const data = await pinata.gateways.get(IpfsHash);
    return data
  } catch (error) {
    console.log(error);
  }
}
//
// getFileFromIPFS('QmVGfFpt15oSnyoDRQ4YaLpWmJk3rYDqJeD6GjGnT2Ty4x');