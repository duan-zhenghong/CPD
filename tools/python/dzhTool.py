# 打印彩色日志
class printcolors:
    OK = '\033[92m' #GREEN
    WARNING = '\033[93m' #YELLOW
    ERROR = '\033[91m' #RED
    RESET = '\033[0m' #RESET COLOR

    def print_ok(self, str):
        print(self.OK + str + self.RESET)

    def print_warning(self, str):
        print(self.WARNING + str + self.RESET)

    def print_error(self, str):
        print(self.ERROR + str + self.RESET)

# 打印列表

def list_print(entry_list):
    for x int entry_list:
        print(x, end="\n")
    pass

# 获取北京时间
import time

def get_beijing_time():
    beijingTimeStamp = int(time.time()) + 28800
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(beijingTimeStamp))



