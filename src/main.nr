// src/main.nr
// ZK Proof for a Data Deletion Request (Simplified "Right to be Forgotten")

use dep::std::hash::pedersen_hash;

// This circuit allows a user to prove they are authorized to request deletion
// of a specific piece of data (identified by data_id) and correctly compute
// a nullifier for this request, without revealing their core secret directly.

fn main(
    // === Private Inputs ===
    // Known only to the user making the deletion request.
    user_secret: Field,                 // The user's core private secret.
    identity_blinding_factor: Field,    // Blinding factor for the user's identity commitment.

    // === Public Inputs ===
    // These are part of the request and are made public or known to the verifier (service provider).
    data_id: pub Field,                 // Identifier of the data to be deleted.
    request_epoch: pub Field,           // Current epoch for the request, for nullifier uniqueness.
    
    // The Prover claims these values, and the circuit verifies they are correctly derived
    // from the private inputs and other public inputs.
    claimed_user_identity_commitment: pub Field,
    claimed_deletion_request_nullifier: pub Field
) {
    // --- 1. Verify User Identity Commitment ---
    // The user proves they know the secret and blinding factor for their identity commitment.
    // This identity commitment would be known to the service provider.
    let computed_user_identity_commitment = pedersen_hash([user_secret, identity_blinding_factor]);
    constrain computed_user_identity_commitment == claimed_user_identity_commitment;

    // --- 2. Compute and Verify Deletion Request Nullifier ---
    // The nullifier is derived from the user's secret, the specific data_id, and the request_epoch.
    // This ensures that a unique nullifier is generated for each data deletion request
    // by a specific user for a specific data item in a given epoch.
    // The service provider would check if this nullifier has already been processed.
    let computed_deletion_request_nullifier = pedersen_hash([
        user_secret,
        data_id,
        request_epoch
    ]);
    constrain computed_deletion_request_nullifier == claimed_deletion_request_nullifier;

    // --- Optional External Action ---
    // An external system (e.g., service provider's backend or a smart contract) would:
    // 1. Verify this proof.
    // 2. Check that `claimed_user_identity_commitment` corresponds to an existing user.
    // 3. Check if `claimed_deletion_request_nullifier` has been used/processed before.
    // 4. If all checks pass, proceed with the data deletion associated with `data_id`
    //    for the user identified by `claimed_user_identity_commitment`, and mark the
    //    `claimed_deletion_request_nullifier` as processed.
    // 5. Optionally, a `request_commitment = hash(claimed_user_identity_commitment, data_id, request_epoch)`
    //    could be logged.

    // println("Data Deletion Request Proof Components Validated:");
    // println("  User Identity Commitment: {}", claimed_user_identity_commitment);
    // println("  Data ID for Deletion: {}", data_id);
    // println("  Deletion Request Nullifier: {}", claimed_deletion_request_nullifier);
    // println("  Request Epoch: {}", request_epoch);
}