module message_holder::test {

    #[test_only]
    use std::string;

    #[test_only]
    use std::signer;

    #[test_only]
    use message_holder::main;

    #[test(account=@0xcafe)]
    fun test_create_message_holder(account: signer) {
        let message = string::utf8(b"Hello, world!");
        let signer_address = signer::address_of(&account);
        main::set_message(&account, copy message);
        let actual_message = main::get_message(signer_address);
        assert!(message == actual_message, 0);
    }

    #[test(account=@0xbeef)]
    fun test_set_message_holder(account: signer) {
        let signer_address = signer::address_of(&account);
        main::set_message(&account,  string::utf8(b"Hello, world!"));
        let new_message = string::utf8(b"New message");
        main::set_message(&account, copy new_message);
        let actual_message = main::get_message(signer_address);
        assert!(actual_message == new_message, 0);
    }


}