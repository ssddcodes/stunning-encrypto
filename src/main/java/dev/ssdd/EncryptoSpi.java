package dev.ssdd;

public interface EncryptoSpi {

    String encrypt(String val, ZotPublicKey publicKey);

    String decrypt(String val);

    String getPublicKeyString();

    String getPrivateKeyString();
}