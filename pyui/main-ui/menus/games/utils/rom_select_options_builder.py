

import os
from pathlib import Path
from typing import Callable
from devices.device import Device
from games.utils.rom_utils import RomUtils
from menus.games.utils.favorites_manager import FavoritesManager
from menus.games.utils.rom_info import RomInfo
from themes.theme import Theme
from views.grid_or_list_entry import GridOrListEntry


class RomSelectOptionsBuilder:
    def __init__(self):
        self.roms_path = "/mnt/SDCARD/Roms/"
        self.rom_utils : RomUtils= RomUtils(self.roms_path)
        
    
    def _remove_extension(self,file_name):
        return os.path.splitext(file_name)[0]

    def get_image_path(self, rom_path):
        # Get the base filename without extension (e.g., "DKC")
        base_name = os.path.splitext(os.path.basename(rom_path))[0]
        
        # Get the parent directory of the ROM file
        parent_dir = os.path.dirname(rom_path)
        
        # Construct the path to the Imgs directory
        imgs_dir = os.path.join(parent_dir, "Imgs")
        
        # Construct the full path to the PNG image
        image_path = os.path.join(imgs_dir, base_name + ".png")
        if os.path.exists(image_path):
            return image_path
        else:
            return None

    def _build_favorites_dict(self):
        favorites = Device.parse_favorites()
        favorite_paths = []
        for favorite in favorites:
            favorite_paths.append(str(Path(favorite.rom_path).resolve()))

        return favorite_paths

    def build_rom_list(self, game_system, filter: Callable[[str], bool] = lambda a: True) -> list[GridOrListEntry]:
        rom_list = []
        for rom_file_path in self.rom_utils.get_roms(game_system.folder_name):
            if(filter(rom_file_path)):
                rom_file_name = os.path.basename(rom_file_path)
                img_path = self.get_image_path(rom_file_path)
                rom_info = RomInfo(game_system,rom_file_path)
                icon=Theme.favorite_icon() if FavoritesManager.is_favorite(rom_info) else None

                rom_list.append(
                    GridOrListEntry(
                        primary_text=self._remove_extension(rom_file_name),
                        image_path=img_path,
                        image_path_selected=img_path,
                        description=game_system.folder_name, 
                        icon=icon,
                        value=RomInfo(game_system,rom_file_path))
                )

        return rom_list
