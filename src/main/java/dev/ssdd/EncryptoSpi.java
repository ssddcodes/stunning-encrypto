package dev.ssdd;

public abstract class EncryptoSpi {
    protected abstract String encrypt(String val, ZotPublicKey publicKey);
    protected abstract String decrypt(String val);
    protected abstract String getPublicKeyString();
    protected abstract String getPrivateKeyString();
}