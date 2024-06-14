import pyautogui
import time 
i = 0
while i<=1:
    pyautogui.moveTo(1851,391, duration=1)
    pyautogui.click()
    pyautogui.moveTo(399,314, duration=1)
    pyautogui.click()
    time.sleep(1)
    i+=1
# print(pyautogui.position())