pragma solidity ^0.8.24;
contract TournamentFactory{
    string public name;
    uint public timeStart;
    uint public timeEnd;
    uint public fee;
    uint public award;
    mapping (address => bool) managers;
    mapping (address => bool) players;

    constructor(){
        managers[msg.sender] = true;
    }

    function setManager(address manager, bool isManager) external onlyManager{
        managers[manager] = isManager;
    }

    function setTournament(string memory _name, uint _timeStart, uint _timeEnd, uint _fee, uint _award) external onlyManager{
        require(_timeStart > block.timestamp, "Tournament has to start at the future");
        require(_timeEnd > _timeStart, "Tournament has to end after start");
        name = _name;
        timeStart = _timeStart;
        timeEnd = _timeEnd;
        fee = _fee;
        award = _award;
    }

    function getTournament() public view returns(string memory, uint, uint){
        return (name, timeStart, timeEnd);
    }
    function getFee() public view returns(uint){
        return fee;
    }
    modifier onlyManager{
        require(managers[msg.sender], "Only manager can impliment this fuction");
        _;
    }
}