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

#[derive(Debug, Default, Clone, Serialize)]
struct PublicKey {
    e: BigUint,
    n: BigUint,
}

#[derive(Debug, Default, Clone)]
struct PrivateKey {
    on: BigUint,
    d: BigUint,
}

#[derive(Debug, Default, Clone)]
struct Encrypto {
    pbl: PublicKey,
    pri: PrivateKey,
}

#[derive(Serialize, Deserialize, Default)]
struct ForPub {
    pe: BigUint,
    on: BigUint,
}

impl Encrypto {
    fn init(bit_len: usize) -> Self {
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
            e: e1,
            on,
            d,
        };

        Self {
            pbl,
            pri,
        }
    }

    fn get_public_key(&self) -> PublicKey {
        self.pbl.clone()
    }

    /*  fn get_public_key_string(&self) -> String {
          /*let x = base64::decode(encode).unwrap();
          let json;
          unsafe {
              json = json!(String::from_utf8_unchecked(x));
          }*/
          base64::encode(Strin)
      }*/

    fn desterilize_pub_key(encoded: &str) -> PublicKey {
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

    fn sterilize_pub_key(&self) -> String {
        let mut hm = HashMap::<&str, String>::new();
        hm.insert("pe", self.pbl.e.clone().to_string());
        hm.insert("on", self.pbl.n.clone().to_string());
        let json = serde_json::to_value(hm).unwrap().to_string();
        base64::encode(json.as_bytes())
    }

    fn encrypt(val: String, pub_key: PublicKey) -> String {
        base64::encode(convert_bigint_to_bytes((convert_bytes_to_big_int(val.as_bytes()) * pub_key.e) % pub_key.n))
    }

    fn decrypt_as_string(&self, val: String) -> String {
        String::from_utf8(convert_bigint_to_bytes((convert_bytes_to_big_int(&*base64::decode(val).unwrap()) * self.pri.d.clone()) % self.pri.on.clone())).unwrap()
    }

}

fn convert_bytes_to_big_int(bytes: &[u8]) -> BigUint {
    let mut result = BigUint::zero();
    for z in bytes {
        result = (result << 8) | (BigUint::from(z & 0xff));
    }
    return result;
}

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

fn modinv(a: BigInt, m: BigInt) -> Option<BigUint> {
    let (g, x, _) = egcd(a, m.clone());
    if g != BigInt::one() {
        None
    } else {
        Some(((x % m.clone() + m.clone()) % m).to_biguint().unwrap())
    }
}