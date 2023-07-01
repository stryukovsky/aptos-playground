module resource_owner::test {
    
    #[test_only]
    use resource_owner::main;
    #[test_only]
    use std::signer;

    #[test(account=@0x1234)]
    public fun test_init(account: &signer) {
        main::init(account);
    }

    #[test(account=@0x1234)]
    public fun test_delegate(account: &signer) {
        main::init(account);
        main::delegate_access_storage(account);
    }

    #[test(account=@0x1234)]
    public fun test_storage_access(account: &signer) {
        main::init(account);
        main::delegate_access_storage(account);
        let data = b"Hello, world!";
        main::access_storage(account, data);
        let stored = main::get_data(signer::address_of(account));
        assert!(stored == data, 0);
    }
}
