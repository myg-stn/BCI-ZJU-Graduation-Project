#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 让 left_arm 中的 JointL3 在当前基础上 +0.325 rad，在 RViz 中显示

import sys
import rospy
import moveit_commander

def move_jointL3_up(delta_angle=0.325):
    # 初始化 moveit_commander 和 ROS 节点
    moveit_commander.roscpp_initialize(sys.argv)
    rospy.init_node('move_jointL3_up', anonymous=True)

    group_name = "left_arm"
    move_group = moveit_commander.MoveGroupCommander(group_name)

    # 获取当前关节角
    joint_names = move_group.get_active_joints()
    rospy.loginfo("Active joints in group '%s': %s", group_name, joint_names)

    # 找到 JointL3 在关节数组中的索引
    try:
        idx = joint_names.index("JointL3")
    except ValueError:
        rospy.logerr("Joint 'JointL3' not found in group '%s' joints: %s",
                     group_name, joint_names)
        return

    current_joints = move_group.get_current_joint_values()
    rospy.loginfo("Current joint values: %s", current_joints)

    # 在当前 JointL3 角度基础上加 delta_angle（弧度）
    target_joints = list(current_joints)
    target_joints[idx] += delta_angle
    rospy.loginfo("Target joint values: %s", target_joints)

    # 设定关节角目标并执行
    move_group.set_joint_value_target(target_joints)
    success = move_group.go(wait=True)

    # 停止残余运动
    move_group.stop()

    if not success:
        rospy.logwarn("MoveGroup go() returned False, motion may have failed.")

    # 关闭 MoveIt
    moveit_commander.roscpp_shutdown()

if __name__ == '__main__':
    try:
        move_jointL3_up(0.325)
    except rospy.ROSInterruptException:
        pass