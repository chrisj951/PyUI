
import os
import subprocess
from controller.controller import Controller
from controller.controller_inputs import ControllerInput
from devices.device import Device
from display.display import Display
from menus.games.game_config_menu import GameConfigMenu
from menus.games.game_select_menu_popup import GameSelectMenuPopup
from menus.games.in_game_menu_listener import InGameMenuListener
from menus.games.utils.rom_select_options_builder import RomSelectOptionsBuilder
from themes.theme import Theme
from utils.logger import PyUiLogger
from views.grid_or_list_entry import GridOrListEntry
from views.selection import Selection
from abc import ABC, abstractmethod

from views.view_creator import ViewCreator
from views.view_type import ViewType


class RomsMenuCommon(ABC):
    def __init__(self):
        self.rom_select_options_builder = RomSelectOptionsBuilder()
        self.in_game_menu_listener = InGameMenuListener()
        self.popup_menu = GameSelectMenuPopup()

    def _remove_extension(self,file_name):
        return os.path.splitext(file_name)[0]
    
    def _get_image_path(self, rom_path):
        # Get the base filename without extension (e.g., "DKC")
        return self.rom_select_options_builder.get_image_path(rom_path)
        
    def _extract_game_system(self, rom_path):
        rom_path = os.path.abspath(os.path.normpath(rom_path))
        parts = os.path.normpath(rom_path).split(os.sep)
        try:
            roms_index = parts.index("Roms")
            return parts[roms_index + 1]
        except (ValueError, IndexError) as e:
            PyUiLogger.get_logger().error(f"Error extracting subdirectory after 'Roms' for {rom_path}: {e}")
        return None  # "Roms" not found or no subdirectory after it
    
    @abstractmethod
    def _get_rom_list(self) -> list[GridOrListEntry]:
        pass
    
    @abstractmethod
    def _run_game(self, selected_entry) -> subprocess.Popen:
        pass

    def _run_rom_selection(self, page_name) :
        selected = Selection(None,None,0)
        view = None
        rom_list = self._get_rom_list()
        while(selected is not None):
            if(view is None):
                view = ViewCreator.create_view(
                    view_type=Theme.get_game_selection_view_type(),
                    top_bar_text=page_name,
                    options=rom_list,
                    selected_index=selected.get_index(),
                    rows=2,
                    cols=4)
            else:
                view.set_options(rom_list)

            selected = view.get_selection([ControllerInput.A, ControllerInput.X, ControllerInput.MENU])
            if(selected is not None):
                if(ControllerInput.A == selected.get_input()):
        
                    Display.deinit_display()
                    game_thread : subprocess.Popen = Device.run_game(selected.get_selection().get_value())
        
                    if(game_thread is not None):
                        self.in_game_menu_listener.game_launched(game_thread, selected.get_selection().get_value())
                        Controller.clear_input_queue()
        
                    Display.reinitialize()
                elif(ControllerInput.X == selected.get_input()):
                    GameConfigMenu(selected.get_selection().get_value().game_system, 
                                   selected.get_selection().get_value()).show_config()
                    # Regenerate as game config menu might've changed something
                    rom_list = self._get_rom_list()
                elif(ControllerInput.MENU == selected.get_input()):
                    self.popup_menu.run_game_select_popup_menu(selected.get_selection().get_value())
                    # Regenerate as game config menu might've changed something
                    rom_list = self._get_rom_list()
                elif(ControllerInput.B == selected.get_input()):
                    selected = None
