extern crate core;

use core::str;
use std::collections::HashMap;
use num_bigint::{BigInt, BigUint, ToBigInt};
use num_traits::{FromPrimitive, One, ToPrimitive, Zero};
use serde::{Deserialize, Serialize};
use serde_json::{Value};
use crate::bigint::Generator;

mod bigint;

#[cfg(test)]
mod tests {
    // use encrypto_rust::Encrypto;
    // use crate::{Encrypto, Generator, rsa};
    use crate::{Encrypto};

    #[test]
    fn it_works() {
        let x = Encrypto::init(512);
        let msg = "abc";
        let enc = Encrypto::encrypt(msg.to_string(), x.get_public_key());
    }
}

/// This struct is used to store your generated PrivateKey and PublicKeys, click for demo code
///
/// # Uses
/// ```
/// use encrypto_rust::Encrypto;
///
/// fn main() {
///     let encrypto = Encrypto::init(1024);
///     let public_key = encrypto.get_public_key(); //returns PublicKey struct
///     let msg = "Alo".to_string(); // sample message to be encrypted
///     let enc = Encrypto::encrypt_from_string(msg.clone(), public_key.clone()); // returns encrypted msg as base64 string
///     let dec = encrypto.decrypt_as_string(enc); // returns decoded msg as string
///
///     let public_key_string = encrypto.sterilize_pub_key(); // IMPORTANT - returns base64 encoded public key which is to be sent to other client for encryption
///
///     let enc_from_bytes = Encrypto::encrypt_from_bytes(bytes, public_key); // returns encrypted bytes as base64 string
///     let dec_from_bytes = encrypto.decrypt_as_bytes(enc_from_bytes); // returns bytes as Vec<u8>
///
///     assert_eq!(msg, dec);
/// }
/// ```
#[derive(Debug, Default, Clone)]
pub struct Encrypto {
    pbl: PublicKey,
    pri: PrivateKey,
}

/// Struct to store public key
#[derive(Debug, Default, Clone, Serialize)]
pub struct PublicKey {
    e: BigUint,
    n: BigUint,
}

/// Struct to store private key
#[derive(Debug, Default, Clone)]
pub struct PrivateKey {
    on: BigUint,
    d: BigUint,
}

impl Encrypto {
    pub fn init(bit_len: usize) -> Self {
        let e = BigUint::from(65537 as u32);
        let e1 = e.clone();
        let p = Generator::new_prime(bit_len);
        let q = Generator::new_prime(bit_len);

        let n = p.clone() * q.clone();
        let on = (p - BigUint::one()) * (q - BigUint::one());
        let d = modinv(e.clone().to_bigint().unwrap(), on.clone().to_bigint().unwrap()).unwrap();

        let pbl: PublicKey = PublicKey {
            e,
            n,
        };

        let pri: PrivateKey = PrivateKey {
            on,
            d,
        };

        Self {
            pbl,
            pri,
        }
    }

    pub fn get_public_key(&self) -> PublicKey {
        self.pbl.clone()
    }

    pub fn desterilize_pub_key(encoded: &str) -> PublicKey {
        let x = base64::decode(encoded).unwrap();
        let json: Value = serde_json::from_slice(&*x).unwrap();
        let x = json.get("on").unwrap().as_str().unwrap();
        let xx = x.as_bytes();
        let n = BigUint::parse_bytes(xx, 10).unwrap();
        let x = json.get("pe").unwrap().as_str().unwrap();
        let xx = x.as_bytes();
        let e = BigUint::parse_bytes(xx, 10).unwrap();

        PublicKey {
            e,
            n,
        }
    }

    pub fn sterilize_pub_key(&self) -> String {
        let mut hm = HashMap::<&str, String>::new();
        hm.insert("pe", self.pbl.e.clone().to_string());
        hm.insert("on", self.pbl.n.clone().to_string());
        let json = serde_json::to_value(hm).unwrap().to_string();
        base64::encode(json.as_bytes())
    }

    pub fn encrypt_from_string(val: String, pub_key: PublicKey) -> String {
        base64::encode(convert_bigint_to_bytes((convert_bytes_to_big_int(val.as_bytes()) * pub_key.e) % pub_key.n))
    }

    pub fn encrypt_from_bytes(bytes: &[u8], pub_key: PublicKey) -> String{
        base64::encode(convert_bigint_to_bytes((convert_bytes_to_big_int(bytes) * pub_key.e) % pub_key.n))
    }

    pub fn decrypt_as_string(&self, val: String) -> String {
        String::from_utf8(convert_bigint_to_bytes((convert_bytes_to_big_int(&*base64::decode(val).unwrap()) * self.pri.d.clone()) % self.pri.on.clone())).unwrap()
    }

    pub fn decrypt_as_bytes(&self, val: String) -> Vec<u8> {
        convert_bigint_to_bytes((convert_bytes_to_big_int(&*base64::decode(val).unwrap()) * self.pri.d.clone()) % self.pri.on.clone())
    }

}

/// Custom common method to convert Bytes to BigInteger
fn convert_bytes_to_big_int(bytes: &[u8]) -> BigUint {
    let mut result = BigUint::zero();
    for z in bytes {
        result = (result << 8) | (BigUint::from(z & 0xff));
    }
    return result;
}

/// Custom common method to convert BigInteger to Bytes
fn convert_bigint_to_bytes(mut number: BigUint) -> Vec<u8> {
    let bytes = (number.clone().bits() + 7) >> 3;
    let b256 = BigUint::from_i32(256).unwrap();
    let mut result = Vec::new();
    for _ in 0..bytes {
        result.push(u8::try_from((number.clone() % b256.clone()).to_i64().unwrap()).unwrap());
        number >>= 8;
    }
    return result;
}


fn egcd(a: BigInt, b: BigInt) -> (BigInt, BigInt, BigInt) {
    if a == BigInt::zero() {
        (b, BigInt::zero(), BigInt::one())
    } else {
        let (g, x, y) = egcd(b.clone() % a.clone(), a.clone());
        (g, y - (b / a) * x.clone(), x)
    }
}

/// Returns modulo inverse
fn modinv(a: BigInt, m: BigInt) -> Option<BigUint> {
    let (g, x, _) = egcd(a, m.clone());
    if g != BigInt::one() {
        None
    } else {
        Some(((x % m.clone() + m.clone()) % m).to_biguint().unwrap())
    }
}