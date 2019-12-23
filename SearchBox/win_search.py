import keyboard
import sys
import time

if __name__ == '__main__':
    if len(sys.argv) == 2:
        keyboard.send('windows+s')
        time.sleep(0.2)
        keyboard.write(sys.argv[1])