package dev.ssdd;

import com.sun.istack.internal.Nullable;

import java.security.SecureRandom;
import java.util.Base64;

public class ZotKeyPair extends EncryptoSpi {
    private final ZotPrivateKey privateKey;

    @Nullable ZotPublicKey publicKey;

    public ZotKeyPair(int bitLen, Encrypto encrypto) {
        int nx = new SecureRandom().nextInt(9999);
        privateKey = new ZotPrivateKey(bitLen, nx, this, encrypto);
    }

    @Override
    protected String encrypt(String val, ZotPublicKey publicKey) {
        if(publicKey == null){
            throw new RuntimeException("ZotPublicKey can't be null for RSA encryption");
        }
        return publicKey.encrypt(val.getBytes());
    }

    @Override
    protected String decrypt(String val) {
        return privateKey.decrypt(Base64.getDecoder().decode(val.getBytes()));
    }

    @Override
    protected String getPublicKeyString() {
        return publicKey.toString();
    }

    @Override
    protected String getPrivateKeyString() {
        return privateKey.toString();
    }

}
