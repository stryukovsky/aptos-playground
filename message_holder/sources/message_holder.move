module message_holder::main {
    use std::string;
    use std::error;
    use std::signer;

    struct MessageHolder has key{
        message: string::String,
    }

    #[view]
    public fun get_message(addr: address): string::String acquires MessageHolder {
        assert!(exists<MessageHolder>(addr), error::not_found(0));
        borrow_global<MessageHolder>(addr).message
    }

    public entry fun set_message(account: &signer, message: string::String) acquires MessageHolder {
        let account_addr = signer::address_of(account);
        if(!exists<MessageHolder>(account_addr)) {
            let msg_holder = MessageHolder{message};
            move_to(account, msg_holder)
        } else {
            let old_message_holder = borrow_global_mut<MessageHolder>(account_addr);
            old_message_holder.message = message;
        }
    }
}
