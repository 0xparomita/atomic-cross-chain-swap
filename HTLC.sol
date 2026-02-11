// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title HTLC
 * @dev Hashed Timelock Contract for secure cross-chain asset swaps.
 */
contract HTLC {
    struct Swap {
        address sender;
        address receiver;
        uint256 amount;
        bytes32 hashlock; // sha256 hash of the secret
        uint256 timelock; // UNIX timestamp
        bool claimed;
        bool refunded;
    }

    mapping(bytes32 => Swap) public swaps;

    event LogOpen(bytes32 indexed id, address indexed sender, address indexed receiver, uint256 amount, bytes32 hashlock, uint256 timelock);
    event LogClaim(bytes32 indexed id, bytes32 secret);
    event LogRefund(bytes32 indexed id);

    function open(
        bytes32 _id,
        address _receiver,
        bytes32 _hashlock,
        uint256 _timelock,
        address _token,
        uint256 _amount
    ) external {
        require(swaps[_id].sender == address(0), "Swap ID already exists");
        require(_timelock > block.timestamp, "Timelock must be in future");

        IERC20(_token).transferFrom(msg.sender, address(this), _amount);

        swaps[_id] = Swap({
            sender: msg.sender,
            receiver: _receiver,
            amount: _amount,
            hashlock: _hashlock,
            timelock: _timelock,
            claimed: false,
            refunded: false
        });

        emit LogOpen(_id, msg.sender, _receiver, _amount, _hashlock, _timelock);
    }

    function claim(bytes32 _id, bytes32 _secret, address _token) external {
        Swap storage swap = swaps[_id];

        require(swap.hashlock == sha256(abi.encodePacked(_secret)), "Invalid secret");
        require(!swap.claimed, "Already claimed");
        require(!swap.refunded, "Already refunded");

        swap.claimed = true;
        IERC20(_token).transfer(swap.receiver, swap.amount);

        emit LogClaim(_id, _secret);
    }

    function refund(bytes32 _id, address _token) external {
        Swap storage swap = swaps[_id];

        require(block.timestamp >= swap.timelock, "Timelock not expired");
        require(!swap.claimed, "Already claimed");
        require(!swap.refunded, "Already refunded");

        swap.refunded = true;
        IERC20(_token).transfer(swap.sender, swap.amount);

        emit LogRefund(_id);
    }
}
