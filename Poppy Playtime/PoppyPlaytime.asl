state("Poppy_Playtime-Win64-Shipping")
{
    int isLoaded: 0x676FD54;
    int isPaused: 0x67E37E4;

    int hasLeftHand: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x920;
    int hasRightHand: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x921;
    int isGameReady: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x8A0;

    int inventorySize: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x910;

    int MovementX: 0x67E6430, 0x1B8, 0x38, 0x0, 0x30, 0x2D0, 0x320, 0x2E8;
    int MovementY: 0x67E6430, 0x1B8, 0x38, 0x0, 0x30, 0x2D0, 0x320, 0x2F0;
    int MovementZ: 0x67E6430, 0x1B8, 0x38, 0x0, 0x30, 0x2D0, 0x320, 0x2F8;
    float CamPitch: 0x67E6430, 0x1B8, 0x38, 0x0, 0x30, 0x308;
    float CamYaw: 0x67E6430, 0x1B8, 0x38, 0x0, 0x30, 0x310;

    string32 slot1DisplayName: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x8, 0x0;
    string32 slot2DisplayName: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x30, 0x0;
    string32 slot3DisplayName: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x58, 0x0;
    string32 slot4DisplayName: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x80, 0x0;
    string32 slot5DisplayName: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0xA8, 0x0;
    string32 slot6DisplayName: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0xD0, 0x0;
    string32 slot7DisplayName: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0xF8, 0x0;
    string32 slot8DisplayName: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x118, 0x0;
    string32 slot9DisplayName: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x148, 0x0;
    string32 slot10DisplayName: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x170, 0x0;
    string32 slot11DisplayName: 0x67E3B50, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x198, 0x0;

    // PoppyDoorCase_C pointer location : 0x065EA1C0, 0x88, 0x08, 0x128, 0x098, 0x750, 0x278;

    // As soon as the door case opening animation timeline has completed we can split
    //float isEndCaseDoorOpening: 0x67E6430, 0x88, 0x8, 0x128, 0x98, 0x750, 0x278, 0xB8;

    // UWorld pointer location : 0x67E6430, 0x0;
    int uWorldFNameIndex: 0x67E6430, 0x18;
}

init
{
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

    vars.GetFNamePool = (Func<IntPtr>) (() => {	
        var scanner = new SignatureScanner(game, modules.First().BaseAddress, (int)modules.First().ModuleMemorySize);
        var pattern = new SigScanTarget("74 09 48 8D 15 ?? ?? ?? ?? EB 16");
        var gameOffset = scanner.Scan(pattern);
        if (gameOffset == IntPtr.Zero) return IntPtr.Zero;
        int offset = game.ReadValue<int>((IntPtr)gameOffset+0x5);
        return (IntPtr)gameOffset+offset+0x9;
	});

    vars.FNamePool = vars.GetFNamePool();

    vars.GetNameFromFName = (Func<int, int, string>) ( (key,partial) => {
        int chunkOffset = key >> 16;
        int nameOffset = (ushort)key;
        IntPtr namePoolChunk = memory.ReadValue<IntPtr>((IntPtr)vars.FNamePool + (chunkOffset+2) * 0x8);
        Int16 nameEntry = game.ReadValue<Int16>((IntPtr)namePoolChunk + 2 * nameOffset);
        int nameLength = nameEntry >> 6;
        if (partial == 0) {
            return game.ReadString((IntPtr)namePoolChunk + 2 * nameOffset + 2, nameLength);
        } else {
            return game.ReadString((IntPtr)namePoolChunk + 2 * nameOffset + 2, nameLength)+"_"+partial.ToString();
        }
	});
}

startup
{
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

start
{
    if (current.isGameReady == 1 && (current.MovementX != 0 && old.MovementX == 0 || current.MovementY != 0 && old.MovementY == 0 || current.MovementZ != 0 && old.MovementZ == 0 || 
    current.CamPitch != old.CamPitch  || current.CamYaw != old.CamYaw)) {
        vars.ResetRunPersistentVariables();
        return true;
    }
}

onStart
{
    vars.ResetRunPersistentVariables();
}

isLoading
{
    return current.isLoaded == 0 || current.isPaused == 3;
}

reset
{
    // 803705 is the fname index of the main menu map
    if (current.uWorldFNameIndex != old.uWorldFNameIndex && vars.GetNameFromFName(current.uWorldFNameIndex, 0).ToLower() == "mainmenu") {
        return true;
    }
}

split
{
    if (current.isLoaded == 0 || current.isPaused == 3) {
        return false;
    }

    if (settings["Left Hand"] && !vars.hasPickedUpLeftHand && (int) current.hasLeftHand == 257) {
        if (settings["Debug"]) {
            print("Left Hand Split");
        }
        
        vars.hasPickedUpLeftHand = true;
        return true;
    }

    if (settings["Right Hand"] && !vars.hasPickedUpRightHand && (int) current.hasRightHand == 1) {
        if (settings["Debug"]) {
            print("Right Hand Split");
        }

        vars.hasPickedUpRightHand = true;
        return true;
    }

    // TODO: Only do the final split after door is completely open
    // if (old.isEndCaseDoorOpening != 6 && current.isEndCaseDoorOpening == 6) {
    //     if (settings["Debug"]) {
    //         print("Poppy Case Door Opened");
    //     }

    //     return true;
    // }

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
