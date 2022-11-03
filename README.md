# About Project
End to End encryption (RSA e2ee) for multiple languages (cross-platform) and Value password protection (DES encryption) specially for local file encryption!


| Icon |             Item              |
|:----:|:-----------------------------:|
|  🥳  |   [**Upcoming**](#Upcoming)   |
|  ⚖️  |    [**License**](#License)    |
|  📝  | [**ChangeLog**](CHANGELOG.md) |

# Usage (rust)

## Implementation
### Cargo
```xml

```

## RSA


### RSA Init

```rust
let encrypto = Encrypto::init(1024);
```
### RSA Encrypt
```rust
let public_key = encrypto.get_public_key(); //returns PublicKey struct
let msg = "Alo".to_string(); // sample message to be encrypted 
let enc = Encrypto::encrypt_from_string(msg.clone(), public_key.clone()); // returns encrypted msg as base64 string

Or

let enc_from_bytes = Encrypto::encrypt_from_bytes(bytes, public_key); // returns encrypted bytes as base64 string

```

### RSA Decrypt

```rust
let dec = encrypto.decrypt_as_string(enc); // returns decoded msg as string

Or

let dec_from_bytes = encrypto.decrypt_as_bytes(enc_from_bytes); // returns bytes as Vec<u8>
```

## DES
### Unavailable for rust as of now

## Upcoming

| Supported Languages | Status                                                                                                    |
|---------------------|-----------------------------------------------------------------------------------------------------------|
| Flutter             | Completed and available [here](https://github.com/ssddcodes/stunning-encrypto/edit/encrypto/tree/flutter) |
| Java                | Completed and available [here](https://github.com/ssddcodes/stunning-encrypto/)                           |
| JavaScript          | Completed and available [here](https://github.com/ssddcodes/stunning-encrypto/edit/encrypto/tree/js)      |

* And DES support for rust

## License

### Click [here](https://github.com/ssddcodes/stunning-encryptio/blob/encrypto/LICENSE.md)
