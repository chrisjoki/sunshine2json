#!/usr/bin/python3

# MIT License
#
# Copyright (c) 2021 chrisjoki
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:#
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import sys
import os
import io
import argparse
import binascii

def main():

    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument('--in', type=str, default='/dev/ttyS0', help='The serial port to read from. Default: /dev/ttyS0')

    parser.add_argument('--cnt', type=int, default=6, help='Number of bytes to read at once, Default: 6')
            
    parser.add_argument('--out', type=str, default='/proc/self/fd/2', help='The fifo/file to write to. Default: STDOUT.')

    options = parser.parse_args();

    try:
        os.mkfifo(options.out)
    except FileExistsError:
        pass
    except:
        raise

    try:
        fh = open(options.in,'rb')
        print("Serial Port opened ...")
    except:
        sys.exit("Error: Could not open serial port.")
        
    while True:
        try:
            b = fh.read(options.cnt)
            print("Raw Data:",binascii.hexlify(b).decode("ascii"), "Output: ", end='')
            ff = open(options.out,'a')
            for i in bytearray(b):
                ff.write(str(i)+" ")
                print(str(i),"",end='')
            ff.write("\n")
            ff.close()
            print()
        except IOError as ex:
            if ex.errno == errno.EPIPE:
                print(ex)
                print("Ignoring ...")
            else:
                print(ex)
                break
        except Exception as ex:
            print(ex)
            break

    fh.close()
            
    return

if __name__ == "__main__":
    main()
