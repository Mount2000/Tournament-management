pragma solidity ^0.8.24;
contract TournamentFactory{
    string public name;
    uint public timeStart;
    uint public timeEnd;
    mapping (address => bool) managers;

    constructor(){
        managers[msg.sender] = true;
    }

    function setManager(address manager, bool isManager) external onlyManager{
        managers[manager] = isManager;
    }

    function setTournament(string memory _name, uint _timeStart, uint _timeEnd) external onlyManager{
        require(_timeStart > block.timestamp, "Tournament has to start at the future");
        require(_timeEnd > _timeStart, "Tournament has to end after start");
        name = _name;
        timeStart = _timeStart;
        timeEnd = _timeEnd;
    }
    function getTournament() public view returns(string memory, uint, uint){
        return (name, timeStart, timeEnd);
    }
    modifier onlyManager{
        require(managers[msg.sender], "Only manager can impliment this fuction");
        _;
    }
}