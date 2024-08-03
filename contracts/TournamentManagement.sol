pragma solidity ^0.8.24;

import {Ownable} from "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "node_modules/@chainlink/contracts/src/v0.8/vrf/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import "hardhat/console.sol";
import "./TournamentFactory.sol";

contract TournamentManagement is VRFConsumerBaseV2Plus{

    bytes32 s_keyHash;
    address Coordinator;
    uint s_subscriptionId;
    uint s_randomWords;
    uint s_requestId;

    address payable withdrawWallet;
    uint totalAwards;


    event creatTournament(address tournament);
    event ReturnedRandomness(uint256 randomWords);
    event _withdrawAward(address tournament);

    constructor( bytes32 _keyHash, address _Coordinator, uint _SubscriptionID ) VRFConsumerBaseV2Plus(Coordinator){
        s_keyHash = _keyHash;
        Coordinator = _Coordinator;
        s_subscriptionId = _SubscriptionID;
        withdrawWallet = payable(msg.sender);
    }

    function creatNewTournament(string memory name, uint timeStart, uint timeEnd, uint fee, uint award) public onlyOwner{
        totalAwards += award;
        require(address(this).balance >= totalAwards, "Not enough token to creat award");
        TournamentFactory newTournament = new TournamentFactory(name, timeStart, timeEnd, fee, award);
        emit creatTournament(address(newTournament));
    }

    function editTournament(address tournament, string memory name, uint timeStart, uint timeEnd, uint fee, uint award) public onlyOwner{
        TournamentFactory(tournament).setTournament(name, timeStart, timeEnd, fee, award);
    }

    function setManagerTournament(address tournament, address manager) public onlyOwner{
        TournamentFactory(tournament).setManager(manager);
    }

    function setRefereeTournament(address tournament, address referee) public onlyTournamentManager(tournament){
        TournamentFactory(tournament).setReferee(referee);
    }

    function joinTournament(address tournament, address player) public payable onlyOwner{
        uint fee;
        (,,,fee,)= TournamentFactory(tournament).tournament();
        require(msg.value == fee, "transfer value did not match with fee");
        requestRandomWords();
        TournamentFactory(tournament).setPlayer(player, s_randomWords);
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

    function setWithdrawWallet(address payable _withdrawWallet) public onlyOwner{
        withdrawWallet = _withdrawWallet;
    }

    function withdrawTournamentFee(uint amout) public onlyOwner{
        require(address(this).balance >= amout + totalAwards,"Contract balance has to be more than total award");
        withdrawWallet.transfer(amout);
    }

    // get an array random words
    function requestRandomWords() internal {
        // Will revert if subscription is not set and funded.
        s_requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: 3,
                callbackGasLimit: 100000,
                numWords: 1,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
    }

    // get value and assign first element of random array to s_randomWords
    function fulfillRandomWords(
        uint256 /* requestId */,
        uint256[] calldata randomWords
    ) internal override {
        s_randomWords = randomWords[0]%1000;
        emit ReturnedRandomness(s_randomWords);
    }

    receive() external payable { }
    fallback() external payable {}

    modifier onlyTournamentManager(address tournament){
        require(TournamentFactory(tournament).hasRole(keccak256("MANAGER_ROLE"), msg.sender), "Only manager can do this function");
        _;
    }
}
