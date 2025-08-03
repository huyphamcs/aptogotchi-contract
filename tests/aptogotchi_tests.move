#[test_only]
module huy_addr::aptogotchi_tests {
    use huy_addr::advancedAptogotchi;
    use std::string::utf8;
    use std::signer;
    use aptos_framework::account;

    // Test helper function to set up the module
    fun setup_test(deployer: &signer) {
        // We need to manually call the equivalent of init_module
        // Since we can't call init_module directly, we'll work around this
        advancedAptogotchi::setup_for_test(deployer);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_create_aptogotchi_success(deployer: &signer, user: &signer) {
        // Initialize accounts
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));

        // Setup the module
        setup_test(deployer);

        // Test creating an aptogotchi
        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));

        // Verify the aptogotchi address can be retrieved
        let _token_address =
            advancedAptogotchi::get_aptogotchi_address(signer::address_of(user));
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_create_aptogotchi_with_empty_name(
        deployer: &signer, user: &signer
    ) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b""));
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_create_aptogotchi_with_long_name(
        deployer: &signer, user: &signer
    ) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(
            user, utf8(b"ThisIsAVeryLongNameForAnAptogotchiPetThatShouldStillWork")
        );
    }

    #[test(deployer = @huy_addr, user1 = @0x456, user2 = @0x789)]
    fun test_multiple_users_create_aptogotchi(
        deployer: &signer, user1: &signer, user2: &signer
    ) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user1));
        account::create_account_for_test(signer::address_of(user2));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user1, utf8(b"Pet1"));
        advancedAptogotchi::create_aptogotchi(user2, utf8(b"Pet2"));

        // Verify they have different addresses
        let addr1 = advancedAptogotchi::get_aptogotchi_address(signer::address_of(user1));
        let addr2 = advancedAptogotchi::get_aptogotchi_address(signer::address_of(user2));
        assert!(addr1 != addr2, 1);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_feed_basic(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 1);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_feed_multiple_amounts(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 3);
        advancedAptogotchi::feed(user, 2);
        advancedAptogotchi::feed(user, 1);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_feed_zero_amount(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 0);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_feed_to_max_energy(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 10); // MAX_ENERGY = 10
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    #[expected_failure]
    fun test_feed_beyond_max_energy(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 11); // Should fail
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    #[expected_failure]
    fun test_feed_cumulative_beyond_max(
        deployer: &signer, user: &signer
    ) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 6);
        advancedAptogotchi::feed(user, 5); // 6 + 5 = 11 > 10, should fail
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    #[expected_failure]
    fun test_feed_without_aptogotchi(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        // Try to feed without creating aptogotchi first
        advancedAptogotchi::feed(user, 1);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_play_basic(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 5);
        advancedAptogotchi::play(user, 2);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_play_zero_amount(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::play(user, 0);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_play_all_energy(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 8);
        advancedAptogotchi::play(user, 8); // Use all energy
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    #[expected_failure]
    fun test_play_more_than_available(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 3);
        advancedAptogotchi::play(user, 4); // Should fail
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    #[expected_failure]
    fun test_play_without_aptogotchi(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        // Try to play without creating aptogotchi first
        advancedAptogotchi::play(user, 1);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    #[expected_failure]
    fun test_play_with_zero_energy(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        // Don't feed, so energy remains 0
        advancedAptogotchi::play(user, 1);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_feed_and_play_sequence(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 5);
        advancedAptogotchi::play(user, 2);
        advancedAptogotchi::feed(user, 3);
        advancedAptogotchi::play(user, 1);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_multiple_play_sessions(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 10);
        advancedAptogotchi::play(user, 2);
        advancedAptogotchi::play(user, 3);
        advancedAptogotchi::play(user, 1);
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_get_aptogotchi_address(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        let _address =
            advancedAptogotchi::get_aptogotchi_address(signer::address_of(user));
        // Test passes if no error occurs
    }

    #[test(deployer = @huy_addr, user1 = @0x456, user2 = @0x789)]
    fun test_different_users_different_addresses(
        deployer: &signer, user1: &signer, user2: &signer
    ) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user1));
        account::create_account_for_test(signer::address_of(user2));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user1, utf8(b"Pet1"));
        advancedAptogotchi::create_aptogotchi(user2, utf8(b"Pet2"));

        let addr1 = advancedAptogotchi::get_aptogotchi_address(signer::address_of(user1));
        let addr2 = advancedAptogotchi::get_aptogotchi_address(signer::address_of(user2));

        assert!(addr1 != addr2, 1);
    }

    #[test(deployer = @huy_addr)]
    fun test_get_app_signer(deployer: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        setup_test(deployer);

        let _app_signer = advancedAptogotchi::get_app_signer();
        // Test passes if no error occurs
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_large_feed_amount(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 10); // Max amount
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_large_play_amount(deployer: &signer, user: &signer) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 10);
        advancedAptogotchi::play(user, 10); // Use all energy at once
    }

    #[test(deployer = @huy_addr, user = @0x456)]
    fun test_edge_case_exact_max_energy(
        deployer: &signer, user: &signer
    ) {
        account::create_account_for_test(signer::address_of(deployer));
        account::create_account_for_test(signer::address_of(user));
        setup_test(deployer);

        advancedAptogotchi::create_aptogotchi(user, utf8(b"TestPet"));
        advancedAptogotchi::feed(user, 5);
        advancedAptogotchi::feed(user, 5); // Should reach exactly 10
        advancedAptogotchi::play(user, 10); // Should be able to spend all
    }
}

