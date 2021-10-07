# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'logout.ui'
#
# Created by: PyQt5 UI code generator 5.15.4
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.

# This file is not minded to be redone in the future 

from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import QShortcut
import os, logging

def logout():
    cmd = 'mate-session-save --logout'
    out = os.popen(cmd).read()
    debug(out)

def reboot():
    cmd = 'systemctl reboot'
    out = os.popen(cmd).read()
    debug(out)

def shutdown():
    cmd = 'systemctl poweroff'
    out = os.popen(cmd).read()
    debug(out)

def debug(out):
    if str(out) == '':
        out = "Env error, run in terminal to see about it better.\n"
    
    logging.error(str(out))

class Ui_Form(object):
    def setupUi(self, Form):

        # Keybindings
        QShortcut('Escape', Form).activated.connect(lambda:Form.close())
        
        Form.setObjectName("Form")
        Form.setWindowModality(QtCore.Qt.NonModal)
        Form.setEnabled(True)
        Form.resize(1920, 1080)
        Form.setWindowOpacity(1.0)
        Form.setStyleSheet("background-color: rgba(46, 52, 64, 0.6);")
        self.horizontalLayout = QtWidgets.QHBoxLayout(Form)
        self.horizontalLayout.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout.setSpacing(0)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.frame = QtWidgets.QFrame(Form)
        self.frame.setEnabled(True)
        self.frame.setFrameShape(QtWidgets.QFrame.NoFrame)
        self.frame.setFrameShadow(QtWidgets.QFrame.Plain)
        self.frame.setObjectName("frame")
        self.verticalLayout_2 = QtWidgets.QVBoxLayout(self.frame)
        self.verticalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_2.setSpacing(0)
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.frame_2 = QtWidgets.QFrame(self.frame)
        self.frame_2.setFrameShape(QtWidgets.QFrame.NoFrame)
        self.frame_2.setFrameShadow(QtWidgets.QFrame.Plain)
        self.frame_2.setObjectName("frame_2")
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout(self.frame_2)
        self.horizontalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout_2.setSpacing(0)
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.frame_3 = QtWidgets.QFrame(self.frame_2)
        self.frame_3.setMaximumSize(QtCore.QSize(918, 192))
        self.frame_3.setStyleSheet("background-color: none;")
        self.frame_3.setFrameShape(QtWidgets.QFrame.NoFrame)
        self.frame_3.setFrameShadow(QtWidgets.QFrame.Plain)
        self.frame_3.setObjectName("frame_3")
        self.pushButton_3 = QtWidgets.QPushButton(self.frame_3)
        self.pushButton_3.setGeometry(QtCore.QRect(480, 0, 192, 192))
        self.pushButton_3.setStyleSheet("QPushButton {\n"
"  border-radius: 25px;\n"
"  background-color: transparent;\n"
"}\n"
"QPushButton:hover:!pressed\n"
"{\n"
"  background-color: rgba(242, 242, 242, 0.08);\n"
"}\n"
"QPushButton:pressed {\n"
"  background-color: rgba(242, 242, 242, 0.08);\n"
"}")
        self.pushButton_3.setText("")
        icon = QtGui.QIcon()
        icon.addPixmap(QtGui.QPixmap(":/assets/reboot.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.pushButton_3.setIcon(icon)
        self.pushButton_3.setIconSize(QtCore.QSize(96, 96))
        self.pushButton_3.setFlat(True)
        self.pushButton_3.setObjectName("pushButton_3")
        self.pushButton = QtWidgets.QPushButton(self.frame_3)
        self.pushButton.setGeometry(QtCore.QRect(0, 0, 192, 192))
        self.pushButton.setStyleSheet("QPushButton {\n"
"  border-radius: 25px;\n"
"  background-color: transparent;\n"
"}\n"
"QPushButton:hover:!pressed\n"
"{\n"
"  background-color: rgba(242, 242, 242, 0.08);\n"
"}\n"
"QPushButton:pressed {\n"
"  background-color: rgba(242, 242, 242, 0.08);\n"
"}")
        self.pushButton.setText("")
        icon1 = QtGui.QIcon()
        icon1.addPixmap(QtGui.QPixmap(":/assets/cancel.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.pushButton.setIcon(icon1)
        self.pushButton.setIconSize(QtCore.QSize(96, 96))
        self.pushButton.setFlat(True)
        self.pushButton.setObjectName("pushButton")
        self.pushButton_4 = QtWidgets.QPushButton(self.frame_3)
        self.pushButton_4.setGeometry(QtCore.QRect(726, 0, 192, 192))
        self.pushButton_4.setStyleSheet("QPushButton {\n"
"  border-radius: 25px;\n"
"  background-color: transparent;\n"
"}\n"
"QPushButton:hover:!pressed\n"
"{\n"
"  background-color: rgba(242, 242, 242, 0.08);\n"
"}\n"
"QPushButton:pressed {\n"
"  background-color: rgba(242, 242, 242, 0.08);\n"
"}")
        self.pushButton_4.setText("")
        icon2 = QtGui.QIcon()
        icon2.addPixmap(QtGui.QPixmap(":/assets/logout.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.pushButton_4.setIcon(icon2)
        self.pushButton_4.setIconSize(QtCore.QSize(96, 96))
        self.pushButton_4.setFlat(True)
        self.pushButton_4.setObjectName("pushButton_4")
        self.pushButton_2 = QtWidgets.QPushButton(self.frame_3)
        self.pushButton_2.setGeometry(QtCore.QRect(238, 0, 192, 192))
        self.pushButton_2.setStyleSheet("QPushButton {\n"
"  border-radius: 25px;\n"
"  background-color: transparent;\n"
"}\n"
"QPushButton:hover:!pressed\n"
"{\n"
"  background-color: rgba(242, 242, 242, 0.08);\n"
"}\n"
"QPushButton:pressed {\n"
"  background-color: rgba(242, 242, 242, 0.08);\n"
"}")
        self.pushButton_2.setText("")
        icon3 = QtGui.QIcon()
        icon3.addPixmap(QtGui.QPixmap(":/assets/shutdown.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.pushButton_2.setIcon(icon3)
        self.pushButton_2.setIconSize(QtCore.QSize(96, 96))
        self.pushButton_2.setFlat(True)
        self.pushButton_2.setObjectName("pushButton_2")
        self.horizontalLayout_2.addWidget(self.frame_3)
        self.verticalLayout_2.addWidget(self.frame_2)
        self.horizontalLayout.addWidget(self.frame)

        # Actions
        self.pushButton.clicked.connect(Form.close)
        self.pushButton_2.clicked.connect(shutdown)
        self.pushButton_3.clicked.connect(reboot)
        self.pushButton_4.clicked.connect(logout)
        
        self.retranslateUi(Form)
        QtCore.QMetaObject.connectSlotsByName(Form)

    def retranslateUi(self, Form):
        _translate = QtCore.QCoreApplication.translate
        Form.setWindowTitle(_translate("Form", "logoutScreen"))
        self.pushButton_3.setShortcut(_translate("Form", "R"))
        self.pushButton.setShortcut(_translate("Form", "C"))
        self.pushButton_4.setShortcut(_translate("Form", "L"))
        self.pushButton_2.setShortcut(_translate("Form", "S"))
    
import logout_rc


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Form = QtWidgets.QWidget()
    ui = Ui_Form()
    ui.setupUi(Form)
    Form.showFullScreen()
    sys.exit(app.exec_())