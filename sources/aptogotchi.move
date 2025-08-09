// module huy_addr::my_aptogotchi {

//     // Modules, Functions declaration
//     use std::string::String;
//     use std::signer::address_of;
//     // use std::account::exists_at;
//     use std::object::create_named_object;
//     // Constant declaration
//     const MAX_ENERGY: u64 = 10;

//     // Structs
//     struct Aptogotchi has key {
//         name: String,
//         birthday: u64,
//         energy_points: u64
//     }

//     public entry fun create_pet(account: &signer, name: String) {
//         assert!(!exists<Aptogotchi>(address_of(account)));
//         let new_aptogotchi = Aptogotchi { name, birthday: 0, energy_points: 0 };
//         move_to(account, new_aptogotchi);
//     }

//     public entry fun feed (account: &signer) acquires Aptogotchi {
//         let ref = &mut borrow_global_mut<Aptogotchi>(address_of(account)).energy_points;
//         assert!(*ref < MAX_ENERGY);
//         *ref +=1;
//     }

//     public entry fun play (account: &signer, amount: u64) acquires Aptogotchi{
//         let ref = &mut borrow_global_mut<Aptogotchi>(address_of(account)).energy_points;
//         assert!(*ref - amount >= 0);
//         *ref -= amount;
//     }
// }

module huy_addr::advancedAptogotchi {
    use std::object::ExtendRef;
    use std::object::{
        create_named_object,
        generate_extend_ref,
        generate_signer,
        create_object_address,
        generate_signer_for_extending,
        transfer_with_ref,
        generate_linear_transfer_ref,
        generate_transfer_ref,

    };
    use std::string::{utf8, String};
    use std::option::none;
    use std::signer::{address_of};
    use aptos_std::string_utils;
    use aptos_token_objects::collection::create_unlimited_collection;
    use aptos_token_objects::token::{
        create_named_token,
        create_token_address,
        MutatorRef,
        BurnRef,
        generate_mutator_ref,
        generate_burn_ref,
    };
    // use std::bcs::to_bytes;
    

    const APP_OBJECT_SEED: vector<u8> = b"APTOGOTCHI";
    const MAX_ENERGY: u64 = 10;
    const MIN_ENERGY: u64 = 0;
    // Collection information
    const NAME: vector<u8> = b"Aptogotchi collection";
    const DESCRIPTION: vector<u8> = b"Empty description";
    const URI: vector<u8> = b"https://google.com";

    struct ObjectController has key {
        app_extend_ref: ExtendRef
    }

    struct Aptogotchi has key {
        name: String,
        birthday: u64,
        energy_points: u64,
        // Allow user to change the NFT
        mutator_ref: MutatorRef,
        // Allow user to destroy it
        burn_ref: BurnRef
    }

    fun init_module(account: &signer) {

        // Create new object - empty independent entity
        let constructor_ref = create_named_object(account, APP_OBJECT_SEED);

        // Create master key for the robot
        let extend_ref = generate_extend_ref(&constructor_ref);
        // Create new signer for this app - the robot signer
        let app_signer = generate_signer(&constructor_ref);
        // Add the master key to the robot
        move_to(&app_signer, ObjectController { app_extend_ref: extend_ref });

        // Create a new collection with the owner is new_signer
        create_aptogotchi_collection(&app_signer);
    }


    /// Create a new collection
    fun create_aptogotchi_collection(creator: &signer) {
        create_unlimited_collection(
            creator,
            utf8(DESCRIPTION),
            utf8(NAME),
            none(),
            utf8(URI)
        );
    }
    /// This function will have the robot mint an NFT, then transfer this to the function caller (sender). After the function, the NFT belongs to the token_address, not the user's address
    public entry fun create_aptogotchi(user: &signer, name: String) acquires ObjectController {

        // Get the signer of app deployer
        let app_signer = get_app_signer();
        // Reference to the collection hold by the robot 
        let constructor_ref =
            create_named_token(
                &app_signer,
                utf8(NAME),
                utf8(DESCRIPTION),
                string_utils::to_string(&address_of(user)),
                none(),
                utf8(URI)
            );
        // Get the NFT minter (the robot)
        let token_signer = generate_signer(&constructor_ref);
        let mutator_ref = generate_mutator_ref(&constructor_ref);
        let burn_ref = generate_burn_ref(&constructor_ref);
        // Create new NFT
        let new_aptogotchi = Aptogotchi {
            name,
            birthday: 0,
            energy_points: 0,
            mutator_ref,
            burn_ref
        };
        let transfer_ref = generate_transfer_ref(&constructor_ref);
        let linear_transfer_ref = generate_linear_transfer_ref(&transfer_ref);
        // Transfer this NFT to the robot
        move_to(&token_signer, new_aptogotchi);
        // Transfer this NFT from robot to user
        transfer_with_ref(linear_transfer_ref, address_of(user));
        
    }

    public entry fun feed (account: &signer, amount: u64) acquires Aptogotchi, ObjectController {
        let token_address = get_aptogotchi_address(address_of(account));
        let ref = &mut borrow_global_mut<Aptogotchi>(token_address).energy_points;
        assert!(*ref + amount <= MAX_ENERGY);
        *ref += amount;
    }

    public entry fun play (account: &signer, amount: u64) acquires Aptogotchi, ObjectController {
        let token_address = get_aptogotchi_address(address_of(account));
        let ref = &mut borrow_global_mut<Aptogotchi>(token_address).energy_points;
        assert!(*ref - amount >= 0);
        *ref -= amount;
    }


    // GETTER FUCTIONS
    #[view]
    public fun get_app_signer(): signer acquires ObjectController {
        let app_address = create_object_address(&@huy_addr, APP_OBJECT_SEED);
        let ref = borrow_global<ObjectController>(app_address);
        generate_signer_for_extending(&ref.app_extend_ref)
    }

    #[view]
    public fun get_aptogotchi_address (user: address) : address acquires ObjectController {
        let app_signer = get_app_signer();
        create_token_address(&address_of(&app_signer), &utf8(NAME), &string_utils::to_string(&user))
    }

    #[test_only]
    public fun setup_for_test(account: &signer) {
        init_module(account);
    }
}

