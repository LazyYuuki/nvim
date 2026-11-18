#!/usr/bin/env python3
"""Strip gAMA, cHRM and eXIf chunks from a PNG (stdin -> stdout).

pngpaste on macOS writes a bogus gAMA chunk (gamma 2.2 instead of 1/2.2),
which makes browsers render pasted screenshots washed out. Pixel data is
copied unchanged. Non-PNG input is passed through untouched.
"""
import struct
import sys

DROP = {b"gAMA", b"cHRM", b"eXIf"}
SIG = b"\x89PNG\r\n\x1a\n"


def strip(data: bytes) -> bytes:
    if not data.startswith(SIG):
        return data
    out = bytearray(SIG)
    i = len(SIG)
    while i + 8 <= len(data):
        length, ctype = struct.unpack(">I4s", data[i : i + 8])
        end = i + 12 + length
        if ctype not in DROP:
            out += data[i:end]
        i = end
        if ctype == b"IEND":
            break
    return bytes(out)


if __name__ == "__main__":
    sys.stdout.buffer.write(strip(sys.stdin.buffer.read()))
