module resource_owner::main {

    use std::capability;
    use aptos_framework::account::{SignerCapability};
    use std::account;
    use std::signer;

    struct Resource has key{
        cap: SignerCapability,
    }

    const SEED: vector<u8> = b"Owner";

    struct AccessStorage has drop {}

    struct Storage has key{
        data: vector<u8>,
    }

    public entry fun init(owner: &signer) {
        let (resource_signer, cap) = account::create_resource_account(owner, SEED);
        let resource = Resource{cap};
        capability::create<AccessStorage>(&resource_signer, &AccessStorage{});
        move_to(owner, resource);
    }

    public entry fun delegate_access_storage(owner: &signer) acquires Resource{
        let owner_address = signer::address_of(owner);
        let owner_resource = borrow_global_mut<Resource>(owner_address);
        let resource_signer = account::create_signer_with_capability(&owner_resource.cap);
        let aquired_feature = capability::acquire(&resource_signer, &AccessStorage{});
        capability::delegate(aquired_feature, &AccessStorage{},owner);
    }

    public entry fun access_storage(owner: &signer, data: vector<u8>) acquires Storage {
        let owner_address = signer::address_of(owner);
        capability::acquire(owner, &AccessStorage{});
        if (exists<Storage>(owner_address)) {
            let storage = borrow_global_mut<Storage>(owner_address);
            storage.data = data;
        } else {
            let storage = Storage{data};
            move_to(owner, storage);
        }
    }

    #[view]
    public fun get_data(owner: address): vector<u8> acquires Storage{
        let storage = borrow_global<Storage>(owner);
        storage.data
    }
}
