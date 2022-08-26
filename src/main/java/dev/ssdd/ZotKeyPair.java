package dev.ssdd;

import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

public class ZotKeyPair implements EncryptoSpi {
    private final ZotPrivateKey privateKey;

    ZotPublicKey publicKey;

    public ZotKeyPair(int bitLen, Encrypto encrypto) {
        privateKey = new ZotPrivateKey(bitLen, new SecureRandom().nextInt(9999), this, encrypto);
    }

    @Override
    public String encrypt(String val, ZotPublicKey publicKey) {
        if(publicKey == null){
            throw new RuntimeException("ZotPublicKey can't be null for RSA encryption");
        }
        return publicKey.encrypt(val.getBytes());
    }

    @Override
    public String decrypt(String val) {
        return privateKey.decrypt(Base64.getDecoder().decode(val.getBytes()));
    }

    @Override
    public String getPublicKeyString() {
        return publicKey.toString();
    }

    @Override
    public String getPrivateKeyString() {
        return privateKey.toString();
    }

}
