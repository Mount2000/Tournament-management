pragma solidity ^0.8.24;

import {Ownable} from "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "./TournamentFactory.sol";

contract TournamentManagement is Ownable(msg.sender){
    struct User{
        uint id;
        mapping(address => bool) isPlayer;
        mapping(address => uint) position;
    }
    mapping(address => User) users;
    event creatTournament(address tournament, string name,uint timeStart,uint timeEnd, uint fee, uint award);
    event updateTournament(address tournament, string name, uint timeStart, uint timeEnd, uint fee, uint award);

    function creatNewTournament(string memory name, uint timeStart, uint timeEnd, uint fee, uint award) public onlyOwner{
        TournamentFactory newTournament = new TournamentFactory();
        tournament.setTournament(name, timeStart, timeEnd, fee, award);
        emit creatTournament(address(newTournament), name, timeStart, timeEnd, fee, award);
    }

    function editTournament(address tournament, string memory name, uint timeStart, uint timeEnd, uint fee, uint award) public onlyOwner{
        TournamentFactory(tournament).setTournament(name, timeStart, timeEnd, fee, award);
        emit updateTournament(tournament, name, timeStart, timeEnd, fee, award);
    }

    function setManagerTournament(address tournament, address manager, bool isManager) public onlyOwner{
        TournamentFactory(tournament).setManager(manager, isManager);
    }

    function getTournament(address tournament) public view returns(string memory, uint, uint){
        return(TournamentFactory(tournament).getTournament());
    }

    function joinTournament(address tournament) payable public{
        uint fee = TournamentFactory(tournament).getFee();
        uint overFee = msg.value - fee;
        require(msg.value >= fee, "do not enough fee to join");
        users[msg.sender].isPlayer[tournament] = true;
        if(overFee != 0){
            payable(msg.sender).transfer(overFee);
        }
    }
}