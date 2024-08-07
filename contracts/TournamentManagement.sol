pragma solidity ^0.8.24;

import "./TournamentFactory.sol";

contract TournamentManagement {

    address payable withdrawWallet;
    uint totalAwards;

    event creatTournament(address tournament);
    event _withdrawAward(address tournament);
    event join( address tournament, address player);

    constructor() {
        withdrawWallet = payable(msg.sender);
    }

    function setWithdrawWallet(address payable _withdrawWallet) public onlyOwner{
        withdrawWallet = _withdrawWallet;
    }

    function creatNewTournament(string memory name, uint timeStart, uint timeEnd, uint fee, uint award) public onlyOwner{
        totalAwards += award;
        require(address(this).balance >= totalAwards, "Not enough token to creat award");
        TournamentFactory newTournament = new TournamentFactory(name, timeStart, timeEnd, fee, award);
        emit creatTournament(address(newTournament));
    }

    function editTournament(address tournament, string memory newName, uint newTimeStart, uint newTimeEnd, uint newFee, uint newAward) public onlyOwner{
        uint award;
        (,,,,award) = TournamentFactory(tournament).tournament();
        totalAwards = totalAwards + newAward - award;
        require(address(this).balance >= totalAwards, "Not enough token to creat award");
        TournamentFactory(tournament).setTournament(newName, newTimeStart, newTimeEnd, newFee, newAward);
    }

    function setManagerTournament(address tournament, address manager) public onlyOwner{
        TournamentFactory(tournament).setManager(manager);
    }

    function setRefereeTournament(address tournament, address referee) public onlyTournamentManager(tournament){
        TournamentFactory(tournament).setReferee(referee);
    }

    function _joinTournament(address tournament ) public payable{
        uint fee;
        (,,,fee,) = TournamentFactory(tournament).tournament();
        require(msg.value == fee, "transfer value did not match with fee");
        emit join(tournament, msg.sender);
    }

    function joinTournament(address tournament, address player, uint randomNumber) public onlyOwner{
        TournamentFactory(tournament).setPlayer(player, randomNumber);
    }

    function setWinnerTournament(address tournament, address referee) public {
        require(TournamentFactory(tournament).hasRole(keccak256("REFEREE_ROLE"), msg.sender), "Only referee can do this function");
        TournamentFactory(tournament).setReferee(referee);
    }    

    function withdrawAward(address tournament, address winner) public onlyOwner{
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

    modifier onlyTournamentManager(address tournament){
        require(TournamentFactory(tournament).hasRole(keccak256("MANAGER_ROLE"), msg.sender), "Only manager can do this function");
        _;
    }
}
