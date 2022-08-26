package dev.ssdd;

import java.math.BigInteger;

public class BigIntPlayground {
    public static BigInteger convertBytesToBigInt(byte[] bytes) {
        BigInteger result = BigInteger.ZERO;
        for (byte z : bytes) {
            result = (result.shiftLeft(8)).or(BigInteger.valueOf(z & 0xff));
        }
        return result;
    }

    public static byte[] writeBigInt(BigInteger number) {
        // Not handling negative numbers. Decide how you want to do that.
        int bytes = (number.bitLength() + 7) >> 3;
        BigInteger b256 = BigInteger.valueOf(256);
        byte[] result = new byte[bytes];
        for (int i = 0; i < bytes; i++) {
            result[bytes-1-i] = number.remainder(b256).byteValue();
            number = number.shiftRight(8);
        }
        return result;
    }
}