
#[cfg(test)]
mod tests {
    use encrypto_rust::Encrypto;

    #[test]
    fn it_works() {

        let x = Encrypto::new("RSA", 128, Some(""));
        let msg = "alo".to_string();
        let enc = x.encrypt(msg.clone(), x.get_publickey());
        let dec = x.decrypt(enc.clone());
        println!("{} {}", msg, dec);
    }
}

fn main() {}