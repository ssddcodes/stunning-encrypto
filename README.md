# About Project
End to End encryption (RSA e2ee) for multiple languages (cross-platform) and Value password protection (DES encryption) specially for local file encryption!


| Icon |                                         Item                                         |
|:----:|:------------------------------------------------------------------------------------:|
|  🎃  |                           [**Usage**](#Usage(JavaScript))                            |
|  📺  |                               [**Preview**](#Preview)                                |
|  🥳  |                              [**Upcoming**](#Upcoming)                               |
|  ⚖️  |                               [**License**](#License)                                |
|  📝  | [**ChangeLog**](https://github.com/ssddcodes/stunning-encrypto/blob/js/CHANGELOG.md) |
|  😋  |                                [**For HTML**](#HTML)                                 |

# Usage(JavaScript)

## Implementation:-
```npm i @zozoto/encrypto```

**or** [**For HTML**](#HTML)

## RSA


### RSA Init

```js
import Encrypto from '@zozoto/encrypto';
let encrypto = new Encrypto('RSA', 128);
//this generates public and private keys for e2ee, the default bitlength is 256
//keep the bitlength low if you are going to use it in web.
```

### Get ZotPublicKey
```js
let publicKeyString = encrypto.getSterilizedPublicKey();
//returns a base64 encoded public key which you can send to all other clients

//to convert above publicKeyString to ZotPublicKey use:
let pubKey = encrypto.deSterilizeZotPublicKey(publicKeyString);
// pass the public key string which you recieved from the client.
//another method to get the public key directly is:
let publicKey = encrypto.getZotPublicKey();
//returns a map with public exponent and modulus
```

### RSA Encrypt
```js
let val = "alo";
let base64encrypted = encrypto.encrypt(val, pubKey);
//passing public key as 2nd parameter is MANDATORY for RSA encryption
```

### RSA Decrypt

```js
let decrypted = encrypto.decrypt(base64encrypted);
console.log(decrypted);
//prints original message i.e. "alo"
```

### Other methods for RSA

| Sr. number |                   Methods                   |                                                                                       Info |
|------------|:-------------------------------------------:|-------------------------------------------------------------------------------------------:|
| 1          |               getPublicKey()                |                                            is a method that returns generated ZotPublicKey |
| 2          |          getDeSterilizePublicKey()          |                             is a method which converts ZotPublicKey string to ZotPublicKey |
| 3          |           getSterilizePublicKey()           |                       returns a ZotPublicKey string which can be sent to the other person. |
| 4          |        encrypt(value, ZotPublicKey)         |                                                            used to encrypt String with RSA |
| 5          |               decrypt(value)                | used to decrypt string using the password or ZotPrivateKey (no need to pass ZotPrivateKey) |

## DES

### DES Init
```java
Encrypto encrypto = new Encrypto(Encrypto.DES, "the moon is scary sometimes"); 
//MANDATORY to pass password as 2nd parameter for DES
//It's suggested to pass the hash of the password instead of plain text
```

### DES Encrypt

* Unsupported for Encrypto v1.*

## HTML

* **To use Encrypto in HTML script tag click [here](https://cdn.ssdd.dev/encrypto.min.js) for ```encrypto.min.js``` CDN link**
* **To use Encrypto in HTML script tag click [here](https://cdn.ssdd.dev/encrypto.js) for ```encrypto.js``` CDN link**
* To import file directly (without npm) just copy the ```encrypto.js``` file from [here](https://github.com/ssddcodes/stunning-encrypto/blob/js/encrypto.js) and use it the folloring way:

```js
//foo.js (foo = name of the file you use in your html code)
import Encrypto from "./encrypto.js";

let encrypto = new Encrypto('RSA', 128);
let enc = encrypto.encrypt('alo from js', encrypto.getZotPublicKey());
console.log(enc);

let dec = encrypto.decrypt(enc);

console.log(dec);
```

## Upcoming

| Supported Languages | Status                                                                                      |
|---------------------|---------------------------------------------------------------------------------------------|
| Java                | Completed and available [here](https://github.com/ssddcodes/stunning-encrypto/)             |
| Flutter             | Completed and available [here](https://github.com/ssddcodes/stunning-encrypto/tree/flutter) |
| Rust                | Pending                                                                                     |

## Preview
### Preview unavailable for js
## License

### Click [here](https://github.com/ssddcodes/stunning-encryptio/blob/encrypto/LICENSE.md)
