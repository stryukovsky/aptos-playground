module nft_mint::main {
    use std::error;
    use std::string;
    use std::vector;

    use aptos_token::token;
    use std::signer;
    use std::string::String;
    use aptos_token::token::TokenDataId;
    use aptos_framework::account::SignerCapability;
    use aptos_framework::resource_account;
    use aptos_framework::account;
    use aptos_framework::timestamp;

    struct ModuleData has key {
        signer_cap: SignerCapability,
        token_data_id: TokenDataId,
        expiration_timestamp: u64,
        minting_enabled: bool,
    }

    const ENOT_AUTHORIZED: u64 = 1;

    fun init_module(resource_signer: &signer) {
        let collection_name = string::utf8(b"My NFT");
        let description = string::utf8(b"A new collection on APTOS network");
        let collection_uri = string::utf8(b"https://example.com");
        let token_name = string::utf8(b"My Token");        
        let token_uri = string::utf8(b"https://example.com");        

        let max_supply = 0;
        let mutate_setting = vector<bool>[false, false, false];

        token::create_collection(resource_signer, collection_name, description, collection_uri, max_supply, mutate_setting);

        let token_data_id = token::create_tokendata(
            resource_signer,
            collection_name,
            token_name,
            string::utf8(b""),
            0,
            token_uri,
            signer::address_of(resource_signer),
            1,
            0,
            token::create_token_mutability_config(&vector<bool>[ false, false, false, false, true ]),
            vector<String>[string::utf8(b"given_to")],
            vector<vector<u8>>[b""],
            vector<String>[ string::utf8(b"address") ],
        );

        let resource_signer_cap = resource_account::retrieve_resource_account_cap(resource_signer, @source_addr);
        move_to(resource_signer, ModuleData {
            signer_cap: resource_signer_cap,
            token_data_id, 
            minting_enabled: false,
            expiration_timestamp: 10000000000,
        });
    }
}