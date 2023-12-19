#!/usr/bin/env python
#!-*-coding:utf-8 -*-

import time 
import random
import pyautogui

historyX = 0
historyY = 0

while True:
    time.sleep(290)
    x,y = pyautogui.position()
    print(x,y,historyX,historyY)
    newx = random.randint(0, 5599)
    newy = random.randint(0, 1279)
    if x == historyX and y == historyY:
        pyautogui.moveTo(newx,newy)
    historyX = x
    historyY = y