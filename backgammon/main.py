import sys
from PySide6.QtCore import QObject, Signal, Slot
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType
from pyside_handler import Pyside_Game_Handler
import os

if __name__ == "__main__":
    # app = QGuiApplication(sys.argv)

    # engine = QQmlApplicationEngine()
    # engine.load("main.qml")

    # if not engine.rootObjects():
    #     sys.exit(-1)
    # sys.exit(app.exec())
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)
    
    # pyproject_file = os.path.join(script_dir, "backgammon.pyproject")
    # if not QResource.registerResource(pyproject_file):
    #     print(f"Failed to register resource file: {pyproject_file}")
    #     sys.exit(-1)

    # Construct the full path to the QML file
    qml_file = os.path.join(script_dir, "main.qml")  
    
    qmlRegisterType(Pyside_Game_Handler, "Pyside_handler", 1, 0, "Pyside_handler_class")
    
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.load(qml_file)
    
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
    
    