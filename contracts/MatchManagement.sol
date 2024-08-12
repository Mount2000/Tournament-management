pragma solidity 0.8.24;

contract MatchManagement{
    struct Game{
        uint32 [] moves; // moves history of match
        uint8 result; //Did not play = default(0), player1 win = 1; draw = 2, player2 win = 3
    }

    uint public matchCount;
    struct Match{
        uint32 player1; // player with the white pieces
        uint32 player2; //player with the black pieces
        Game [] games;
        uint32 winner;
    }

    mapping(uint matchId => Match) public matches;

    function _setGame(uint matchId, uint32 [] memory moves, uint8 result) internal {
        require(matches[matchId].winner == 0, "Match already has the winner");
        require(result > 0 && result <= 3,"Wrong type of result");
        matches[matchId].games.push(Game(moves, result));
        if(result == 1){
            matches[matchId].winner = matches[matchId].player1;
        }if(result == 3){
            matches[matchId].winner = matches[matchId].player2;
        }
    }

    function _setMatch(uint32 _player1, uint32 _player2) internal {
        matchCount++;
        require(_player1 != 0 || _player2 != 0, "Player position can not be zero");
        require(_player1 != _player2,"Overlap position");
        matches[matchCount].player1 = _player1;
        matches[matchCount].player2 = _player2;
        //set winner of match if do not have opponent
        if(_player1 == 0){
            matches[matchCount].winner = _player2;
        }
        if(_player2 == 0){
            matches[matchCount].winner = _player1;
        }
    }
}