import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType, qmlRegisterModule
from pyside_client import user_register


if __name__ == "__main__":
    
    qmlRegisterType(user_register, "User_registeration", 1, 0, "User_registration_class")
    
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.load("wellcome_page.qml")

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())