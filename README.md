# About Project
End to End encryption (RSA e2ee) for multiple languages (cross-platform) and Value password protection (DES encryption) specially for local file encryption! 


| Icon |             Item              |
|:----:|:-----------------------------:|
|  📺  |    [**Preview**](#Preview)    |
|  🥳  |   [**Upcoming**](#Upcoming)   |
|  ⚖️  |    [**License**](#License)    |
|  📝  | [**ChangeLog**](CHANGELOG.md) |

# Usage (java)

## Implementation
### Maven
```xml
<dependency>
  <groupId>dev.ssdd</groupId>
  <artifactId>encrypto</artifactId>
  <version>1.2.1</version>
</dependency>
```

### Gradle
```java
implementation 'dev.ssdd.encrypto:1.2.1'
```

## RSA


### RSA Init

```java
Encrypto encrypto = new Encrypto(Encrypto.RSA);
//this generates public and private keys for e2ee
//DO NOT pass anything as 2nd parameter for RSA
```
### RSA Encrypt
```java
String val = "alo";
String base64encrypted = encrypto.encrypt(val, publicKey);
//passing public key as 2nd parameter is MANDATORY for RSA encryption
```

### RSA Decrypt

```java
String decrypted = encrypto.decrypt(base64encrypted);
System.out.println(decrypted);
//prints original message i.e. "alo"
```

### Other methods for RSA

| Sr. number |                                            Methods                                            |                                                                                                                                                                                                                                                                                                                                                       Info |
|------------|:---------------------------------------------------------------------------------------------:|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| 1          |                                Encrypto.class / getPublicKey()                                |                                                                                                                                                                                                 is a method that returns generated [ZotPublicKey](!https://github.com/ssddcodes/stunning-encryptio/blob/encrypto/src/main/java/dev/ssdd/ZotPublicKey.java) |
| 2          |                          Encrypto.class / getDeSterilizePublicKey()                           |                                                                                                                                                                           is a static method which converts ZotPublicKey string to [ZotPublicKey](!https://github.com/ssddcodes/stunning-encryptio/blob/encrypto/src/main/java/dev/ssdd/ZotPublicKey.java) |
| 3          |                           Encrypto.class / getSterilizePublicKey()                            |                                                                                                                                                                                                                                                                                       returns a ZotPublicKey string which can be sent to the other person. |
| 4          |                Encrypto.class / getPrivateKeyString() and getPublicKeyString()                |                                                                                                                                                                                                                                                                                              returns plain text of private/public key exponent and modulus |
| 5          |                Encrypto.class / encrypt(String value, ZotPublicKey publicKey)                 |                                                                                                                                                                                                                                                                                                                            used to encrypt String with RSA |
| 6          |                     Encrypto.class / public String decrypt(String value)                      | used to decrypt string using the password or [ZotPrivateKey](!https://github.com/ssddcodes/stunning-encryptio/blob/encrypto/src/main/java/dev/ssdd/ZotPrivateKey.java) (no need to pass [ZotPrivateKey](!https://github.com/ssddcodes/stunning-encryptio/blob/encrypto/src/main/java/dev/ssdd/ZotPrivateKey.java) or Password as parameter for decryption) |
| 7          | ZotPublicKey.class / public String sterilizePublicKey() and public String encrypt(byte[] val) |                                                                                                                                                                                                                                                                                                                       same as no. 3 and no. 5 of the table |
| 8          |                  ZotPrivateKey.class / public String decrypt(byte[] decode)                   |                                                                                                                                                                                                                                                                                                                                 same as no. 7 of the table |

## DES

### DES Init 
```java
Encrypto encrypto = new Encrypto(Encrypto.DES, "the moon is scary sometimes"); 
//MANDATORY to pass password as 2nd parameter for DES
//It's suggested to pass the hash of the password instead of plain text
```

### DES Encrypt

```java
String base64DESencrypted = encrypto.encrypt("alo");
//do not pass anything as 2nd parameter or pass null
```

### DES Decrypt

```java
String decrypted = encrypto.decrypt(base64DESencrypted);
//you get back the text 
```

## Upcoming

| Supported Languages | Status                                                                                                    |
|---------------------|-----------------------------------------------------------------------------------------------------------|
| Flutter             | Completed and available [here](https://github.com/ssddcodes/stunning-encrypto/edit/encrypto/tree/flutter) |
| Rust                | Pending                                                                                                   |
| JavaScript          | Completed and available [here](https://github.com/ssddcodes/stunning-encrypto/tree/js)                    |

## Preview

![](img.png "Test Screenshot")

## License

### Click [here](https://github.com/ssddcodes/stunning-encryptio/blob/encrypto/LICENSE.md)
