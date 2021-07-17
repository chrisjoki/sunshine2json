#!/usr/bin/python3

import sys
import os
import io
import argparse
import binascii

def main():

    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument('ser', type=str, help='The serial port to read from')

    parser.add_argument('bytecount', type=int, help='Number of bytes to read at once')
            
    parser.add_argument('fifo', type=str, help='The fifo/file to write to')

    options = parser.parse_args();

    try:
        os.mkfifo(options.fifo)
    except FileExistsError:
        pass
    except:
        raise

    try:
        fh = open(options.ser,'rb')
        print("Serial Port opened ...")
    except:
        sys.exit("Error: Could not open serial port.")
        
    while True:
        try:
            b = fh.read(options.bytecount)
            print("Raw Data:",binascii.hexlify(b).decode("ascii"), "Output: ", end='')
            ff = open(options.fifo,'a')
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
