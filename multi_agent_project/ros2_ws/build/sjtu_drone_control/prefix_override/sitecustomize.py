import sys
if sys.prefix == '/usr':
    sys.real_prefix = sys.prefix
    sys.prefix = sys.exec_prefix = '/home/multiagents/ros2_ws/install/sjtu_drone_control'
