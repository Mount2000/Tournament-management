pragma solidity ^0.8.24;

import {Ownable} from "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "./TournamentFactory.sol";

contract TournamentManagement is Ownable(msg.sender){
    mapping(address => TournamentFactory) tournamentFactories;
    event creatTournament(address tournament, string name,uint timeStart,uint timeEnd);
    event updateTournament(address tournament, string name, uint timeStart, uint timeEnd);

    function creatNewTournament(string memory name, uint timeStart, uint timeEnd) public onlyOwner{
        TournamentFactory tournament = new TournamentFactory();
        tournament.setTournament(name, timeStart, timeEnd);
        tournamentFactories[address(tournament)] = tournament;
        emit creatTournament(address(tournament), name, timeStart, timeEnd);
        console.log(address(tournament));
    }

    function editTournament(address tournament, string memory name, uint timeStart, uint timeEnd) public onlyOwner{
        tournamentFactories[tournament].setTournament(name, timeStart, timeEnd);
        emit updateTournament(tournament, name, timeStart, timeEnd);
    }

    function setManagerTournament(address tournament, address manager, bool isManager) public onlyOwner{
        tournamentFactories[tournament].setManager(manager, isManager);
    }

    function getTournament(address tournament) public view returns(string memory, uint, uint){
        return(tournamentFactories[tournament].getTournament());
    }
}