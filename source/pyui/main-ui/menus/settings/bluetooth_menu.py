
from controller.controller import Controller
from controller.controller_inputs import ControllerInput
from devices.device import Device
from devices.bluetooth.bluetooth_scanner import BluetoothScanner
from display.display import Display
from display.font_purpose import FontPurpose
from display.render_mode import RenderMode
from themes.theme import Theme
from utils.logger import PyUiLogger
from views.grid_or_list_entry import GridOrListEntry
from views.selection import Selection
from views.view_creator import ViewCreator
from views.view_type import ViewType


class BluetoothMenu:
    def __init__(self):
        self.bluetooth_scanner = BluetoothScanner()

    def bluetooth_adjust(self):
        if Device.is_bluetooth_enabled():
            Device.disable_bluetooth()
        else:
            Device.enable_bluetooth()
            self.should_scan_for_bluetooth = True

    def toggle_pairing_device(self, device):
        self.bluetooth_scanner.connect_to_device(Device.address)
        Controller.new_bt_device_paired()

    def scan_for_devices(self):
        PyUiLogger.get_logger().info(f"scan_for_devices start")
        Display.clear("Bluetooth")
        Display.render_text(
            text = "Scanning for Bluetooth Devices (~10s)",
            x = Device.screen_width() // 2,
            y = Display.get_usable_screen_height() // 2,
            color = Theme.text_color(FontPurpose.DESCRIPTIVE_LIST_TITLE),
            purpose = FontPurpose.DESCRIPTIVE_LIST_TITLE,
            render_mode=RenderMode.MIDDLE_CENTER_ALIGNED
        )
        Display.present()
        devices = self.bluetooth_scanner.scan_devices()
        PyUiLogger.get_logger().info(f"scan_for_devices end")
        return devices

    def show_bluetooth_menu(self):
        selected = Selection(None, None, 0)
        self.should_scan_for_bluetooth = True
        devices = []
        while(selected is not None):
            PyUiLogger.get_logger().info(f"Waiting for bt selection")
            bluetooth_enabled = Device.is_bluetooth_enabled()
            option_list = []
            option_list.append(
                GridOrListEntry(
                        primary_text="Status",
                        value_text="<    " + ("On" if bluetooth_enabled else "Off") + "    >",
                        image_path=None,
                        image_path_selected=None,
                        description=None,
                        icon=None,
                        value=self.bluetooth_adjust
                    )
            )
            

            if(bluetooth_enabled):
                if(self.should_scan_for_bluetooth):
                    self.should_scan_for_bluetooth = False
                    devices = self.scan_for_devices()
                    selected.index = 0

                for bt_device in devices:
                    option_list.append(
                        GridOrListEntry(
                                primary_text=bt_device.name,
                                value_text=bt_device.address,
                                image_path=None,
                                image_path_selected=None,
                                description=None,
                                icon=None,
                                value=lambda device=bt_device: self.toggle_pairing_device(device)  
                            )
                    )

            list_view = ViewCreator.create_view(
                    view_type=ViewType.ICON_AND_DESC,
                    top_bar_text="Bluetooth Configuration", 
                    options=option_list,
                    selected_index=selected.get_index()) #always reset to the top in case devices change during a scan

            accepted_inputs = [ControllerInput.A, ControllerInput.DPAD_LEFT, ControllerInput.DPAD_RIGHT,
                                                ControllerInput.L1, ControllerInput.R1, ControllerInput.X]
            selected = list_view.get_selection(accepted_inputs)

            if(selected.get_input() in accepted_inputs):
                PyUiLogger.get_logger().info(f"bluetooth_enabled={bluetooth_enabled}")
                if(ControllerInput.X == selected.get_input() and bluetooth_enabled):
                    self.should_scan_for_bluetooth = True
                elif(ControllerInput.A == selected.get_input() 
                     or ControllerInput.DPAD_LEFT == selected.get_input() 
                     or ControllerInput.DPAD_RIGHT == selected.get_input()):
                    selected.get_selection().value()
            elif(ControllerInput.B == selected.get_input()):
                selected = None

