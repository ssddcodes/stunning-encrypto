package dev.ssdd;

import dev.ssdd.zot.JSONObject;

import java.math.BigInteger;
import java.util.Base64;

public class ZotPublicKey {

    final BigInteger e,on;

    public ZotPublicKey(BigInteger e, BigInteger n) {
        this.e = e;
        this.on = n;
    }

    public String sterilizePublicKey(){
        Base64.Encoder encoder = Base64.getEncoder();
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("pe", e).put("on", on);
        return encoder.encodeToString(jsonObject.toString().getBytes());
    }

    public String encrypt(byte[] val) {
        return Base64.getEncoder().encodeToString((new BigInteger(val).multiply(e)).mod(on).toByteArray());
    }

    @Override
    public String toString() {
        return "Algo: RSA\n" + "modulus: "+on + "\npublic exponent: "+e;
    }
}
