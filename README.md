# Noir ZK Proof for Data Deletion Request (Simplified "Right to be Forgotten")

This project demonstrates a Zero-Knowledge proof using Noir for a simplified data deletion request mechanism, inspired by concepts like GDPR's "Right to be Forgotten." The goal is to allow a user to cryptographically prove their authenticated request to delete specific data linked to them, generating a unique request nullifier, without revealing their core secret identity during the request verification process.

## Core Concept

A user wishes to request the deletion of a specific piece of data identified by `data_id`.
1.  The user has a private `user_secret`.
2.  They generate a `user_identity_commitment = hash(user_secret, identity_blinding_factor)`. This commitment is known to the service provider and links the request to the user.
3.  They generate a `deletion_request_nullifier = hash(user_secret, data_id, request_epoch)`. This nullifier is unique for a given user, data item, and epoch, preventing replay or duplicate processing of the same request.

The ZK circuit allows the user to prove:
*   They correctly computed their `user_identity_commitment` (proving they know the `user_secret`).
*   They correctly computed the `deletion_request_nullifier` for the specified `data_id` and `request_epoch`.

A service provider receiving this proof can:
1.  Verify the ZK proof.
2.  Confirm the `user_identity_commitment` belongs to a valid user in their system.
3.  Check if the `deletion_request_nullifier` has already been processed.
4.  If all checks pass, proceed with deleting the data associated with `data_id` for that user and mark the nullifier as processed.

This provides a verifiable and privacy-respecting way to handle data deletion requests.

## Project Structure