// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.17;

import "forge-std/Test.sol";
import "../src/Airdrop.sol";
import "../src/Token.sol";

contract AirdropTest is Test {
    uint256 constant AIRDROP_SIZE = 7000;
    Airdrop airdrop;
    Token token;
    address admin;
    address[] recipients;
    uint256[] amounts;

    uint256 constant _initial_supply = (10 ** 15) * (10 ** 18);

    constructor() {
        airdrop = new Airdrop();
        token = new Token();
        admin = _randomAddress();
        token.mint(admin, _initial_supply);

        recipients = new address[](AIRDROP_SIZE);
        amounts = new uint256[](AIRDROP_SIZE);

        for (uint256 i = 0; i < AIRDROP_SIZE; i++) {
            recipients[i] = _randomAddress();
            amounts[i] = 1;
        }
    }

    function _randomAddress() private view returns (address payable) {
        return payable(address(uint160(_randomUint256())));
    }

    function _randomUint256() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        block.number
                    )
                )
            );
    }

    function testAirdrop_airdropERC20() external {
        console.log(
            "[TEST]: Airdrops ERC20 tokens to recipients using assembly function"
        );
        vm.prank(admin);
        token.approve(address(airdrop), AIRDROP_SIZE);
        vm.prank(admin);
        airdrop.airdropERC20(token, recipients, amounts, AIRDROP_SIZE);
    }

    function testAirdrop_airdropETH() external {
        console.log(
            "[TEST]: Airdrops ETH to recipients using assembly function"
        );
        payable(admin).transfer(AIRDROP_SIZE);
        vm.prank(admin);
        airdrop.airdropETH{value: AIRDROP_SIZE}(recipients, amounts);
    }
}
