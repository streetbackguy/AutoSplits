state("Poppy_Playtime-Win64-Shipping")
{
    int isPaused: 0x67E37E4;
}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");

    // Any% Settings
    settings.Add("Chapter 1", true);
    settings.Add("Any%", true, "General Any% settings.", "Chapter 1");
    settings.CurrentDefaultParent = "Any%";
    settings.Add("Security VHS", true);
    settings.Add("Insert Security VHS", true);
    settings.Add("Left Hand", true);
    settings.Add("Simon Room Key", true, "Power Room Key");
    settings.Add("Blue Key", true, "Storage Key 1");
    settings.Add("Red Key", true, "Storage Key 2");
    settings.Add("Green Key", true, "Storage Key 3");
    settings.Add("Yellow Key", true, "Storage Key 4");
    settings.Add("Right Hand", true);
    settings.Add("Scanner Doll", true);
    settings.Add("Insert Scanner Doll", true);

    // All Tapes Settings
    settings.Add("All Tapes", false, "All Tapes Category Settings.", "Chapter 1");
    settings.CurrentDefaultParent = "All Tapes";
    settings.Add("Lobby VHS", false);
    settings.Add("Insert Lobby VHS", false);
    settings.Add("Storage VHS", false);
    settings.Add("Insert Storage VHS", false);
    settings.Add("Machine VHS", false);
    settings.Add("Insert Machine VHS", false);
    settings.Add("Silo VHS", false);
    settings.Add("Insert Silo VHS", false);

    settings.CurrentDefaultParent = null;
    settings.Add("Debug", false, "Debug Splits");
}

init
{
	IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01");
	IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
	IntPtr fNames = vars.Helper.ScanRel(7, "8B D9 74 ?? 48 8D 15 ???????? EB");
	IntPtr gSyncLoad = vars.Helper.ScanRel(21, "33 C0 0F 57 C0 F2 0F 11 05");
	
	if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero)
	{
		const string Msg = "Not all required addresses could be found by scanning.";
		throw new Exception(Msg);
	}
	
	vars.Helper["isLoading"] = vars.Helper.Make<bool>(gSyncLoad);

	vars.Helper["Level"] = vars.Helper.MakeString(gEngine, 0xAF8, 0x0);
	
	vars.Helper["localPlayer"] = vars.Helper.Make<ulong>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x18);
	vars.Helper["localPlayer"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
	
	vars.Helper["acknowledgePawn"] = vars.Helper.Make<ulong>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x18);
	vars.Helper["acknowledgePawn"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
	
	vars.Helper["gameReady"] = vars.Helper.Make<byte>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x8A0);
	
	vars.Helper["X"] = vars.Helper.Make<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x128);
	vars.Helper["Y"] = vars.Helper.Make<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x130);
	vars.Helper["Z"] = vars.Helper.Make<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x138);
	vars.Helper["Yaw"] = vars.Helper.Make<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x148);

    vars.Helper["hasLeftHand"] = vars.Helper.Make<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x921);
    vars.Helper["hasRightHand"] = vars.Helper.Make<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x920);

    vars.Helper["inventorySize"] = vars.Helper.Make<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x910);

    vars.Helper["slot1DisplayName"] = vars.Helper.MakeString(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x8, 0x0);
    vars.Helper["slot2DisplayName"] = vars.Helper.MakeString(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x30, 0x0);
    vars.Helper["slot3DisplayName"] = vars.Helper.MakeString(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x58, 0x0);
    vars.Helper["slot4DisplayName"] = vars.Helper.MakeString(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x80, 0x0);
    vars.Helper["slot5DisplayName"] = vars.Helper.MakeString(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0xA8, 0x0);
    vars.Helper["slot6DisplayName"] = vars.Helper.MakeString(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0xD0, 0x0);
    vars.Helper["slot7DisplayName"] = vars.Helper.MakeString(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0xF8, 0x0);
    vars.Helper["slot8DisplayName"] = vars.Helper.MakeString(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x118, 0x0);
    vars.Helper["slot9DisplayName"] = vars.Helper.MakeString(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x148, 0x0);
    vars.Helper["slot10DisplayName"] = vars.Helper.MakeString(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x170, 0x0);
    vars.Helper["slot11DisplayName"] = vars.Helper.MakeString(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x198, 0x0);
	
    /*
     * While moving around the level the hand flags are flipped at certain places. 
     * I believe this is due to the level streaming and possibly a bug with the PlayerBP prefab.
     * To avoid incorrect splits we keep a persistent flag which is reset with every run start
     */
    vars.hasPickedUpLeftHand = false;
    vars.hasPickedUpRightHand = false;

    /*
     * Same thing for the different inventory items. At certain level streaming triggers it seems
     * to recreate the player prefab from a previous checkpoint. This adds and then removes items from inventory the next frame
     */
    vars.hasPickedUpSecurityVhs = false;
    vars.hasInsertedSecurityVhs = false;

    vars.hasPickedUpLobbyVhs = false;
    vars.hasInsertedLobbyVhs = false;

    vars.hasPickedUpStorageVhs = false;
    vars.hasInsertedStorageVhs = false;
    
    vars.hasPickedUpMachineVhs = false;
    vars.hasInsertedMachineVhs = false;
    
    vars.hasPickedUpSiloVhs = false;
    vars.hasInsertedSiloVhs = false;

    vars.hasPickedUpScannerDoll = false;
    vars.hasInsertedScannerDoll = false;

    vars.itemNames = new Dictionary<string, Tuple<string, string>>() {
        // Vhs tapes
        { "vhslobby", Tuple.Create("Lobby VHS", "Insert Lobby VHS") },
        { "vhssecurity", Tuple.Create("Security VHS", "Insert Security VHS") },
        { "vhsstorage", Tuple.Create("Storage VHS", "Insert Storage VHS") },
        { "vhsmachine", Tuple.Create("Machine VHS", "Insert Machine VHS") },
        { "vhssilo", Tuple.Create("Silo VHS", "Insert Silo VHS") },

        // Key to the power room
        { "simonroomkey", Tuple.Create("Simon Room Key", "") },
        
        // Keys which start the right hand crane in the storage area
        { "blue", Tuple.Create("Blue Key", "") },
        { "red", Tuple.Create("Red Key", "") },
        { "green", Tuple.Create("Green Key", "") },
        { "yellow", Tuple.Create("Yellow Key", "") },

        // The doll that is created in the machine room
        { "scannerdoll", Tuple.Create("Scanner Doll", "Insert Scanner Doll") },
    };

    vars.inventorySlotCount = 11;

    vars.GetInventorySlotDisplayName = (Func<int, string>) ( (slotIndex) => {
        if (slotIndex == 0) {
            return current.slot1DisplayName;
        } else if (slotIndex == 1) {
            return current.slot2DisplayName;
        } else if (slotIndex == 2) {
            return current.slot3DisplayName;
        } else if (slotIndex == 3) {
            return current.slot4DisplayName;
        } else if (slotIndex == 4) {
            return current.slot5DisplayName;
        } else if (slotIndex == 5) {
            return current.slot6DisplayName;
        } else if (slotIndex == 6) {
            return current.slot7DisplayName;
        } else if (slotIndex == 7) {
            return current.slot8DisplayName;
        } else if (slotIndex == 8) {
            return current.slot9DisplayName;
        } else if (slotIndex == 9) {
            return current.slot10DisplayName;
        } else {
            return current.slot11DisplayName;
        }
    });

    // The number of keys the player has collected
    vars.storageKeyCount = 0;

    // We need to keep track of the current inventory state due to a level streaming player prefab bug
    vars.currentInventory = new List<string>();

    vars.SplitOnInventoryPickup = (Func<string, bool>) ( (displayName) =>  {
        Tuple<string, string> itemSettingsKeys;
        if (!vars.itemNames.TryGetValue(displayName.ToLower(), out itemSettingsKeys) || !settings[itemSettingsKeys.Item1]) {
            // Don't split if the item doesn't exist in the splittable items, or isn't enabled in the settings 
            return false;
        }

        if (settings["Debug"]) {
            print(itemSettingsKeys.Item1);
        }

        return true;
    });

    vars.ResetRunPersistentVariables = (Action) (() => {
        vars.hasPickedUpLeftHand = false;
        vars.hasPickedUpRightHand = false;

        vars.hasPickedUpSecurityVhs = false;
        vars.hasInsertedSecurityVhs = false;
        vars.hasPickedUpLobbyVhs = false;
        vars.hasInsertedLobbyVhs = false;
        vars.hasPickedUpStorageVhs = false;
        vars.hasInsertedStorageVhs = false;
        vars.hasPickedUpMachineVhs = false;
        vars.hasInsertedMachineVhs = false;
        vars.hasPickedUpSiloVhs = false;
        vars.hasInsertedSiloVhs = false;

        vars.hasPickedUpScannerDoll = false;
        vars.hasInsertedScannerDoll = false;

        vars.storageKeyCount = 0;
        vars.currentInventory = new List<string>();
    });

	vars.FNameToString = (Func<ulong, string>)(fName =>
	{
		var nameIdx  = (fName & 0x000000000000FFFF) >> 0x00;
		var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
		var number   = (fName & 0xFFFFFFFF00000000) >> 0x20;

		IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
		IntPtr entry = chunk + (int)nameIdx * sizeof(short);

		int length = vars.Helper.Read<short>(entry) >> 6;
		string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

		return number == 0 ? name : name + "_" + number;
	});
	
	vars.FNameToShortString = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int dot = name.LastIndexOf('.');
		int slash = name.LastIndexOf('/');

		return name.Substring(Math.Max(dot, slash) + 1);
	});
	
	vars.FNameToShortString2 = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int under = name.LastIndexOf('_');

		return name.Substring(0, under + 1);
	});
}

update
{
	//Uncomment debug information in the event of an update.
	//print(modules.First().ModuleMemorySize.ToString());
	
	vars.Helper.Update();
	vars.Helper.MapPointers();

    // vars.Log("Localplayer?: " + vars.FNameToShortString2(current.localPlayer));
    // vars.Log("Localplayer?: " + vars.FNameToShortString2(current.acknowledgePawn));
	
	//print(vars.FNameToShortString(current.Inv1));
}

start
{
    if(current.X != -1073741824 && old.X == -1073741824 || current.gameReady == 1 && current.Y != -536870912 && old.Y == -536870912 || current.gameReady == 1 && current.Z != -1850441728 && old.Z == -1850441728 || 
    current.gameReady == 1 && current.Yaw != 0 && old.Yaw == 0)
    {
        vars.ResetRunPersistentVariables();
        return true;
    }
}

onStart
{
    vars.ResetRunPersistentVariables();
}

split
{
    if(current.isLoading)
    {
        return false;
    }

    if (settings["Left Hand"] && !vars.hasPickedUpLeftHand && (int) current.hasLeftHand == 1)
    {
        if (settings["Debug"]) {
            print("Left Hand Split");
        }
        
        vars.hasPickedUpLeftHand = true;
        return true;
    }

    if (settings["Right Hand"] && !vars.hasPickedUpRightHand && (int) current.hasRightHand == 257)
    {
        if (settings["Debug"])
        {
            print("Right Hand Split");
        }

        vars.hasPickedUpRightHand = true;
        return true;
    }

    if (current.inventorySize > old.inventorySize) {
        // Add the item to the player inventory
        string newItemName = vars.GetInventorySlotDisplayName(current.inventorySize - 1);

        if (String.IsNullOrEmpty(newItemName)) {
            if (settings["Debug"]) {
                print("Item Name string was empty! Current Inventory Size: " + current.inventorySize);
            }
        } else if (!vars.currentInventory.Contains(newItemName)) { // We need to check that we aren't adding duplicates due to the level streaming issues
            switch (newItemName.ToLower()) {
                case "blue":
                case "red":
                case "green":
                case "yellow":
                    // Keep track of the number of keys picked up to avoid right hand splits happening before they possibly can
                    vars.storageKeyCount++;
                    break;
                case "vhssecurity":
                    if (!vars.hasPickedUpSecurityVhs) {
                        vars.hasPickedUpSecurityVhs = true;
                    } else {
                        newItemName = null;
                    }

                    break;
                case "vhslobby":
                    if (!vars.hasPickedUpLobbyVhs) {
                        vars.hasPickedUpLobbyVhs = true;
                    } else {
                        newItemName = null;
                    }

                    break;
                case "vhsstorage":
                    if (!vars.hasPickedUpStorageVhs) {
                        vars.hasPickedUpStorageVhs = true;
                    } else {
                        newItemName = null;
                    }

                    break;
                case "vhsmachine":
                    if (!vars.hasPickedUpMachineVhs) {
                        vars.hasPickedUpMachineVhs = true;
                    } else {
                        newItemName = null;
                    }

                    break;
                case "vhssilo":
                    if (!vars.hasPickedUpSiloVhs) {
                        vars.hasPickedUpSiloVhs = true;
                    } else {
                        newItemName = null;
                    }

                    break;
                case "scannerdoll":
                    if (!vars.hasPickedUpScannerDoll) {
                        vars.hasPickedUpScannerDoll = true;
                    } else {
                        newItemName = null;
                    }

                    break;
            }

            // Check if we picked up a valid item, or this is a level streaming bug
            if (!String.IsNullOrEmpty(newItemName)) {
                vars.currentInventory.Add(newItemName);

                // The player has picked something up, find out what it is and split based on display name
                if (vars.SplitOnInventoryPickup(newItemName)) {
                    return true;
                }
            }            
        }
    } else if (current.inventorySize < old.inventorySize) {
        // This is dumb, but I couldn't find valid fields for when the item placements happen so we just need to find what item was removed from inventory by name
        for (int currentInventoryIndex = 0; currentInventoryIndex < vars.currentInventory.Count; currentInventoryIndex++) {
            string currentInventorySlotName = vars.currentInventory[currentInventoryIndex];

            for (int checkSlotIndex = 0; checkSlotIndex < vars.inventorySlotCount; checkSlotIndex++) {
                string checkName = vars.GetInventorySlotDisplayName(checkSlotIndex);
                if (currentInventorySlotName == checkName) {
                    // This item is still in the inventory
                    break;
                }

                if (checkSlotIndex < vars.inventorySlotCount - 1) {
                    // We need to check every inventory slot
                    continue;
                }

                // Clean up the removed item
                vars.currentInventory.RemoveAt(currentInventoryIndex);

                // Make sure the inventory isn't getting messed up values during level streaming
                switch (currentInventorySlotName.ToLower()) {
                    case "vhssecurity":
                        if (vars.hasInsertedSecurityVhs) {
                            return false;
                        } 
                        
                        vars.hasInsertedSecurityVhs = true;
                        break;
                    case "vhslobby":
                        if (vars.hasInsertedLobbyVhs) {
                            return false;
                        } 
                        
                        vars.hasInsertedLobbyVhs = true;
                        break;
                    case "vhsstorage":
                        if (vars.hasInsertedStorageVhs) {
                            return false;
                        } 
                        
                        vars.hasInsertedStorageVhs = true;
                        break;
                    case "vhsmachine":
                        if (vars.hasInsertedMachineVhs) {
                            return false;
                        } 
                        
                        vars.hasInsertedMachineVhs = true;
                        break;
                    case "vhssilo":
                        if (vars.hasInsertedSiloVhs) {
                            return false;
                        } 
                    
                        vars.hasInsertedSiloVhs = true;
                        break;
                    case "scannerdoll":
                        if (vars.hasInsertedScannerDoll) {
                            return false;
                        } 
                        
                        vars.hasInsertedScannerDoll = true;
                        break;
                }

                Tuple<string, string> itemSettingsKeys;
                if (!vars.itemNames.TryGetValue(currentInventorySlotName.ToLower(), out itemSettingsKeys) 
                    || String.IsNullOrEmpty(itemSettingsKeys.Item2) || !settings[itemSettingsKeys.Item2]
                ) {
                    // Don't split if the item doesn't exist in the splittable items, or isn't enabled in the settings 
                    return false;
                }

                if (settings["Debug"]) {
                    print(itemSettingsKeys.Item2);
                }

                return true;
            }
        }
    }
}

isLoading
{
	return vars.FNameToShortString2(current.localPlayer) != "BP_PoppyPlayerController_C_" || vars.FNameToShortString2(current.acknowledgePawn) != "PlayerBP_" || current.gameReady != 1 || current.isLoading || current.isPaused == 3; 
}

reset
{
    return current.Level == "/Game/Levels/MainMenu";
}
