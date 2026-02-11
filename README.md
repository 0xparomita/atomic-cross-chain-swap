# Atomic Cross-Chain Swap (HTLC)

This repository provides a professional-grade Hashed Timelock Contract (HTLC) for executing atomic swaps. By using cryptographic hashes and time-based locks, two parties can trade assets across different chains (e.g., Ethereum to Polygon) with zero counterparty risk.

## Features
* **Hash-Lock Security:** Funds are locked using a SHA-256 hash. Only the party with the secret preimage can claim the funds.
* **Time-Lock Safety:** Includes an expiration mechanism. If the trade is not completed, the original owner can reclaim their assets.
* **Trustless Exchange:** Eliminates the need for escrow services or centralized exchanges.
* **Flat Structure:** Simplified layout for direct integration into cross-chain dApps.

## Workflow
1. **Setup:** Alice creates a secret and locks funds in the contract on Chain A using the hash of that secret.
2. **Participation:** Bob sees the lock and locks his funds on Chain B using the same hash.
3. **Claim:** Alice claims Bob's funds by revealing the secret.
4. **Completion:** Bob sees the revealed secret on-chain and uses it to claim Alice's funds.
