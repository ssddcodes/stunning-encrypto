package dev.ssdd;

import dev.ssdd.zot.JSONObject;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.Base64;

import static dev.ssdd.BigIntPlayground.*;

public class ZotPublicKey {

    public final BigInteger e,on;

    public ZotPublicKey(BigInteger e, BigInteger n) {
        this.e = e;
        this.on = n;
    }

    public String sterilizePublicKey(){
        Base64.Encoder encoder = Base64.getEncoder();
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("pe", e.toString()).put("on", on.toString());
        return encoder.encodeToString(jsonObject.toString().getBytes());
    }

    public String encrypt(byte[] val) {
        return Base64.getEncoder().encodeToString(writeBigInt((convertBytesToBigInt(val).multiply(e)).mod(on)));
    }

    @Override
    public String toString() {
        return "Algo: RSA\n" + "modulus: "+on + "\npublic exponent: "+e;
    }
}
