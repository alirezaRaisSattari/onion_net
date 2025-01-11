import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType, qmlRegisterModule
from pyside_client import user_register
import os

if __name__ == "__main__":
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)

    # Construct the full path to the QML file
    qml_file = os.path.join(script_dir, "wellcome_page.qml")
    
    qmlRegisterType(user_register, "User_registeration", 1, 0, "User_registration_class")
    
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.load("wellcome_page.qml")

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())