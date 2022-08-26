package dev.ssdd;

import dev.ssdd.EncryptoSpi;
import dev.ssdd.ZotPublicKey;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.spec.AlgorithmParameterSpec;
import java.util.Base64;

public class LocalFileEncryption implements EncryptoSpi {
    private final SecretKey secretKey;
    private final AlgorithmParameterSpec aps;

    //Ignore the class name "LocalFileEncryption" but I suggest you to only use this for encrypting values where password exchange involved
    LocalFileEncryption(String pw) {
        this.secretKey = new SecretKeySpec(pw.getBytes(), 0, 8, "DES");
        byte[] initialization_vector = {22, 33, 11, 44, 55, 99, 66, 77};
        aps = new IvParameterSpec(initialization_vector);
    }

    @Override
    public String encrypt(String val, ZotPublicKey publicKey) {
        if(val.equals(""))
            return "";
        try {
            Cipher encrypt = Cipher.getInstance("DES/CBC/PKCS5Padding");
            encrypt.init(Cipher.ENCRYPT_MODE, secretKey, aps);
            return Base64.getEncoder().encodeToString(encrypt.doFinal(val.getBytes()));
        }catch (Exception e){
            throw new RuntimeException(e);
        }
    }

    @Override
    public String decrypt(String val) {
        if(val.equals(""))
            return "";
        try {
            Cipher decrypt = Cipher.getInstance("DES/CBC/PKCS5Padding");
            decrypt.init(Cipher.DECRYPT_MODE, secretKey, aps);
            byte[] x = Base64.getDecoder().decode(val);
            return new String(decrypt.doFinal(x));
        }catch (Exception e){
            throw new RuntimeException(e);
        }
    }

    /**
     * this always returns "null" as a string to avoid errors.
     * */
    @Override
    public String getPublicKeyString() {
        return "null";
    }

    /**
     * this always returns "null" as a string to avoid errors.
     * */

    @Override
    public String getPrivateKeyString() {
        return "null";
    }

}
