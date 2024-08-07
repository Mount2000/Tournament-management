pragma solidity ^0.8.24;

import {AccessControl} from "node_modules/@openzeppelin/contracts/access/AccessControl.sol";

contract TournamentFactory is AccessControl{
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant REFEREE_ROLE = keccak256("REFEREE_ROLE");
    bytes32 public constant PLAYER_ROLE = keccak256("PLAYER_ROLE");

    struct Tournament{
    string name;
    uint timeStart;
    uint timeEnd;
    uint fee;
    uint award;
    }
    Tournament public tournament;

    mapping(address => uint) public position;
    uint64 countPlayer;
    address public winner;

    event updateTournament(string name, uint timeStart, uint timeEnd, uint fee, uint award);
    event _winner(address player);
    constructor(string memory _name, uint _timeStart, uint _timeEnd, uint _fee, uint _award){
        _grantRole(MANAGER_ROLE, msg.sender);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        require(_timeStart > block.timestamp, "Tournament has to start at the future");
        require(_timeEnd > _timeStart, "Tournament has to end after start");
        tournament.name = _name;
        tournament.timeStart = _timeStart;
        tournament.timeEnd = _timeEnd;
        tournament.fee = _fee;
        tournament.award = _award;
        emit updateTournament(_name, _timeStart, _timeEnd, _fee, _award);
    }

    function setTournament(string memory _name, uint _timeStart, uint _timeEnd, uint _fee, uint _award) public onlyRole(DEFAULT_ADMIN_ROLE) onlyBeforTournamentStart{
        require(_timeStart > block.timestamp, "Tournament has to start at the future");
        require(_timeEnd > _timeStart, "Tournament has to end after start");
        tournament.name = _name;
        tournament.timeStart = _timeStart;
        tournament.timeEnd = _timeEnd;
        tournament.fee = _fee;
        tournament.award = _award;

        emit updateTournament(_name, _timeStart, _timeEnd, _fee, _award);
    }
    
    function setManager(address manager) external onlyRole(DEFAULT_ADMIN_ROLE){
        _grantRole(MANAGER_ROLE, manager);
    }

    function setReferee(address referee) external onlyRole(DEFAULT_ADMIN_ROLE){
        _grantRole(REFEREE_ROLE, referee);
    }

    function setPlayer(address player, uint randomNumber) external onlyRole(DEFAULT_ADMIN_ROLE) onlyBeforTournamentStart{
        require(!hasRole(PLAYER_ROLE, player),"This address is already player");
        countPlayer ++;
        _grantRole(PLAYER_ROLE, player);
        position[player] = countPlayer * 1000 + randomNumber;
    }

    function setWinner(address player) external onlyRole(DEFAULT_ADMIN_ROLE) onlyAfterTournamentEnd{
        winner = player;
        emit _winner(player);
    }

    modifier onlyBeforTournamentStart{
        require(tournament.timeStart > block.timestamp, "Tournament has aldready started");
        _;
    }
    modifier onlyAfterTournamentEnd{
        require(tournament.timeEnd < block.timestamp, "Tournament did not end");
        _;
    }
}