
import os
from controller.controller_inputs import ControllerInput
from games.utils.game_system import GameSystem
from games.utils.game_system_utils import GameSystemUtils
from menus.games.game_select_menu import GameSelectMenu
from menus.games.game_system_select_menu_popup import GameSystemSelectMenuPopup
from themes.theme import Theme
from views.grid_or_list_entry import GridOrListEntry
from views.selection import Selection
from views.view_creator import ViewCreator


class GameSystemSelectMenu:
    def __init__(self):
        self.game_utils : GameSystemUtils = GameSystemUtils()
        self.rom_select_menu : GameSelectMenu = GameSelectMenu()
        self.use_emu_cfg = False
        self.game_system_select_menu_popup = GameSystemSelectMenuPopup()
        self.common_icon_mappings = {
            "PPSSPP": "psp",
            "FFPLAY":"ffplay",
            "MPV":"ffplay",
            "WSC":"ws",
            "FAKE8":"pico",
            "PICO8":"pico",
            "THIRTYTWOX":"32X"
        }

    def get_system_name_for_icon(self, sys_config):        
        return os.path.splitext(os.path.basename(sys_config.get_icon()))[0]
    
    def get_first_existing_path(self,icon_system_name_priority):
        for path in icon_system_name_priority:
            try:
                if path and os.path.isfile(path):
                    return path
            except Exception:
                pass
        return None 

    def get_images(self, game_system : GameSystem):
        icon_system_name = self.get_system_name_for_icon(game_system.game_system_config)
        icon_system_name_priority = []
        icon_system_name_priority.append(Theme.get_system_icon(icon_system_name))
        icon_system_name_priority.append(Theme.get_system_icon(game_system.folder_name.lower()))
        icon_system_name_priority.append(Theme.get_system_icon(game_system.display_name.lower()))
        if game_system.folder_name in self.common_icon_mappings:
            icon_system_name_priority.append(Theme.get_system_icon(self.common_icon_mappings[game_system.folder_name]))
        icon_system_name_priority.append(game_system.game_system_config.get_icon())

        if(game_system.game_system_config.get_icon() is not None):
            icon_system_name_priority.append(os.path.join(game_system.game_system_config.get_emu_folder(),game_system.game_system_config.get_icon()))

        selected_icon_system_name_priority = []
        selected_icon_system_name_priority.append(Theme.get_system_icon_selected(icon_system_name))
        selected_icon_system_name_priority.append(Theme.get_system_icon_selected(game_system.folder_name.lower()))
        selected_icon_system_name_priority.append(Theme.get_system_icon_selected(game_system.display_name.lower()))
        if game_system.folder_name in self.common_icon_mappings:
            selected_icon_system_name_priority.append(Theme.get_system_icon_selected(self.common_icon_mappings[game_system.folder_name]))
        selected_icon_system_name_priority.append(game_system.game_system_config.get_icon_selected())
        
        if(game_system.game_system_config.get_icon_selected() is not None):
            icon_system_name_priority.append(os.path.join(game_system.game_system_config.get_emu_folder(),game_system.game_system_config.get_icon_selected()))

        
        
        return self.get_first_existing_path(icon_system_name_priority), self.get_first_existing_path(selected_icon_system_name_priority),
    
    def run_system_selection(self) :
        selected = Selection(None,None,0)
        systems_list = []
        view = None
        for game_system in self.game_utils.get_active_systems():
            sys_config = game_system.game_system_config
            print(f"{sys_config}")
            image_path, image_path_selected = self.get_images(game_system)
            print(f"{game_system.display_name} using {image_path}")
            icon = image_path_selected
            systems_list.append(
                GridOrListEntry(
                    primary_text=game_system.display_name,
                    image_path=image_path,
                    image_path_selected=image_path_selected,
                    description="Game System",
                    icon=icon,
                    value=game_system
                )                
            )
        if(view is None):
            view = ViewCreator.create_view(
                view_type=Theme.get_view_type_for_system_select_menu(),
                top_bar_text="Game", 
                options=systems_list, 
                cols=Theme.get_game_system_select_col_count(), 
                rows=Theme.get_game_system_select_row_count(),
                selected_index=selected.get_index())
        else:
            view.set_options(systems_list)

        exit = False
        while(not exit):
            selected = view.get_selection([ControllerInput.A, ControllerInput.MENU])
            if(ControllerInput.A == selected.get_input()):
                self.rom_select_menu.run_rom_selection(selected.get_selection().get_value())
            elif(ControllerInput.MENU == selected.get_input()):
                self.game_system_select_menu_popup.run_popup_menu_selection(selected.get_selection().get_value())
            elif(ControllerInput.B == selected.get_input()):
                exit = True