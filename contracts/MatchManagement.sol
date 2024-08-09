pragma solidity 0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MatchManagement is Ownable(msg.sender){
    struct Match{
        uint32 player1;
        uint32 player2;
        Result matchResult;
    }
    enum Result{
        Win,
        Draw,
        Lost
    }

    mapping (uint16 matchId => Match) public matches;
    mapping (uint32 position => Result []) public playerResults;

    function setMatch(uint16 matchId, uint32 player1, uint32 player2, uint8 result) external onlyOwner {
        require(matches[matchId].player1 == 0,"Match have aldready existed");
        require(result <= uint8(Result.Lost),"Wrong type of result");
        require(player1 != player2,"Overlap position");
        matches[matchId] = Match(player1, player2, Result(result));
        playerResults[player1].push(Result(result));
        playerResults[player2].push(Result(uint8(Result.Lost) - result));
    }
}