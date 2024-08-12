pragma solidity ^0.8.24;

import "./TournamentFactory.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TournamentManagement is Ownable(msg.sender){

    address payable withdrawWallet;
    uint totalAwards;
    uint tournamentCount;
    mapping (uint tournamentId => address) tournaments;

    event creatTournament(uint tournamentId);
    event _withdrawAward(address tournament);
    event join( address tournament, address player);

    constructor() {
        withdrawWallet = payable(msg.sender);
    }

    function setWithdrawWallet(address payable _withdrawWallet) public onlyOwner{
        withdrawWallet = _withdrawWallet;
    }

    function createNewTournament(string memory name, uint timeStart, uint timeEnd, uint fee, uint award) public onlyOwner{
        totalAwards += award;
        tournamentCount++;
        require(address(this).balance >= totalAwards, "Not enough token to creat award");
        TournamentFactory newTournament = new TournamentFactory(name, timeStart, timeEnd, fee, award);
        tournaments[tournamentCount] = address(newTournament);
        emit creatTournament(tournamentCount);
    }

    function editTournament(uint tournamentId, string memory newName, uint newTimeStart, uint newTimeEnd, uint newFee, uint newAward) public onlyOwner{
        uint award;
        address tournament = tournaments[tournamentId];
        (,,,,award) = TournamentFactory(tournament).tournament();
        totalAwards = totalAwards + newAward - award;
        require(address(this).balance >= totalAwards, "Not enough token to creat award");
        TournamentFactory(tournament).setTournament(newName, newTimeStart, newTimeEnd, newFee, newAward);
    }

    function setManagerTournament(uint tournamentId, address manager) public onlyOwner{
        address tournament = tournaments[tournamentId];
        TournamentFactory(tournament).setManager(manager);
    }

    function setRefereeTournament(uint tournamentId, address referee) public onlyTournamentManager(tournamentId){
        address tournament = tournaments[tournamentId];
        TournamentFactory(tournament).setReferee(referee);
    }

    function joinTournament(uint tournamentId, uint randomNumber ) public payable{
        address tournament = tournaments[tournamentId];
        uint fee;
        (,,,fee,) = TournamentFactory(tournament).tournament();
        require(msg.value == fee, "transfer value did not match with fee");
        TournamentFactory(tournament).setPlayer(msg.sender, randomNumber);
        emit join(tournament, msg.sender);
    }

    function setMatch(uint tournamentId, uint32 player1, uint32 player2) public onlyTournamentManager(tournamentId){
        address tournament = tournaments[tournamentId];
        TournamentFactory(tournament).setMatch(player1, player2);
    }

    function setGame(uint tournamentId, uint matchId, uint32 [] memory moves, uint8 result) public onlyTournamentManager(tournamentId){
        address tournament = tournaments[tournamentId];
        TournamentFactory(tournament).setGame(matchId, moves, result);
    }

    function setWinnerTournament(uint tournamentId, address referee) public {
        address tournament = tournaments[tournamentId];
        require(TournamentFactory(tournament).hasRole(keccak256("REFEREE_ROLE"), msg.sender), "Only referee can do this function");
        TournamentFactory(tournament).setReferee(referee);
    }    

    function withdrawAward(uint tournamentId, address winner) public onlyOwner{
        address tournament = tournaments[tournamentId];
        require(TournamentFactory(tournament).winner() != address(0), "This tournament did not have winner");
        require(TournamentFactory(tournament).winner() == winner, "This address are not winner of this tournament");
        uint award;
        (,,,,award) = TournamentFactory(tournament).tournament();
        totalAwards -= award;
        payable(winner).transfer(award);
        emit _withdrawAward(tournament);
    }

    function withdrawTournamentFee(uint amout) public onlyOwner{
        require(address(this).balance >= amout + totalAwards,"Contract balance has to be more than total award");
        withdrawWallet.transfer(amout);
    }

    receive() external payable { }
    fallback() external payable {}

    modifier onlyTournamentManager(uint tournamentId){
        require(TournamentFactory(tournaments[tournamentId]).hasRole(keccak256("MANAGER_ROLE"), msg.sender), "Only manager can do this function");
        _;
    }
}
