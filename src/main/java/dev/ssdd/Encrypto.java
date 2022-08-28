package dev.ssdd;

import dev.ssdd.zot.JSONObject;

import java.util.Base64;

public class Encrypto {

    public static final String RSA = "RSA", DES = "DES";
    private final int bitLength; //key size
    private final String algo; // algorithm
    private EncryptoSpi ei;
    ZotKeyPair keyPair;

    private String pw; // password for DES encryption.


    /**
     * @param algo "RSA" and "DES" are only supported currently.
     */

    public Encrypto(String algo) {
        this.bitLength = 1024;
        this.algo = algo;
        init();
    }

    /**
     * @param algo      "RSA" and "DES" are only supported currently.
     * @param bitLength it's the keysize that's used to generate keys for encryption/decryption
     */
    public Encrypto(String algo, int bitLength) {
        this.bitLength = bitLength;
        this.algo = algo;
        init();
    }


    /**
     * @param algo     "RSA" and "DES" are only supported currently.
     * @param password mandatory to pass password for encryption/decryption, and it's suggested to pass the hash of the password instead of plain text
     */
    public Encrypto(String algo, String password) {
        this.bitLength = 1024;
        this.algo = algo;
        this.pw = password;
        init();
    }

    /**
     * it initiates required classes and values for the selected ALGORITHM
     */
    private void init() {
        String link = "https://github.com/ssddcodes/encrypto/";
        if (algo.equalsIgnoreCase(Encrypto.DES)) {
            if (pw == null || pw.length() < 8) {
                throw new RuntimeException("Password can't be null or less then 8 characters long for DES encryption. Please pass the password as 2nd argument. Please refer: " + link);
            }
            ei = new LocalFileEncryption(pw);
        } else if (algo.equalsIgnoreCase(Encrypto.RSA)) {
            ei = new ZotKeyPair(bitLength, Encrypto.this);
        } else {
            //TODO
            throw new RuntimeException("the algorithm: " + algo + "does not exist or not supported by Zot Encrypto. Please refer docs at: " + link);
        }
    }

    /**
     * sends back the respective public key
     */

    public ZotPublicKey getPublicKey() {
        return keyPair.publicKey;
    }

    /**
     * used to convert the client's public key to the ZotPublicKey class instance.
     */

    public static ZotPublicKey getPublicKey(String base64PublicKey) {
        Base64.Decoder decoder = Base64.getDecoder();
        JSONObject jsonObject = new JSONObject(new String(decoder.decode(base64PublicKey)));
        return new ZotPublicKey(jsonObject.getBigInteger("pe"), jsonObject.getBigInteger("on"));
    }

    /**
     * returns sterilized public key to be sent to the client.
     */

    public String getSterilizedPublicKey() {
        String returnPublicKeyB64 = keyPair.publicKey.sterilizePublicKey();
        if (returnPublicKeyB64 == null) {
            return "null";
        }
        return returnPublicKeyB64;
    }

    /**
     * returns private key string
     */

    public String getPrivateKeyString() {
        String x = ei.getPrivateKeyString();
        if (x.equals("null")) {
            System.err.println("there are no keys ever used for DES local file encryption");
        }
        return x;
    }

    /**
     * returns public key string
     */

    public String getPublicKeyString() {
        String x = ei.getPublicKeyString();
        if (x.equals("null")) {
            System.err.println("there are no keys ever used for DES local file encryption");
        }
        return x;
    }

    /**
     * encrypt the message using public key.
     */

    public String encrypt(String value, ZotPublicKey publicKey) {
        return ei.encrypt(value, publicKey);
    }

    /**
     * encrypt the message with password.
     */

    public String encrypt(String value) {
        return ei.encrypt(value, null);
    }

    /**
     * decrypt the encrypted message
     */
    public String decrypt(String value) {
        return ei.decrypt(value);
    }

}
