state("Poppy_Playtime-Win64-Shipping")
{
    byte isLoaded: 0x45867C8;
    int isPaused: 0x4A7DF74;
    string30 MainMenu: 0x4A7DFA8, 0x8B0, 0x18;

    int hasLeftHand: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x70A;
    int hasRightHand: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x709;
    int isGameReady: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x870;
    //int CaseOpen: 0x4936658, 0x90, 0x320, 0x494;

    float LocationX: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x618;
    float LocationY: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x61C;

    int inventorySize: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x868;

    string32 slot1DisplayName: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x860, 0x8, 0x0;
    string32 slot2DisplayName: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x860, 0x30, 0x0;
    string32 slot3DisplayName: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x860, 0x58, 0x0;
    string32 slot4DisplayName: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x860, 0x80, 0x0;
    string32 slot5DisplayName: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x860, 0xA8, 0x0;
    string32 slot6DisplayName: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x860, 0xD0, 0x0;
    string32 slot7DisplayName: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x860, 0xF8, 0x0;
    string32 slot8DisplayName: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x860, 0x118, 0x0;
    string32 slot9DisplayName: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x860, 0x148, 0x0;
    string32 slot10DisplayName: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x860, 0x170, 0x0;
    string32 slot11DisplayName: 0x4A7DFA8, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x860, 0x198, 0x0;
}

startup
{
    settings.Add("PP", true, "Poppy Playtime Chapter 1");
        settings.Add("ANY", true, "Any%", "PP");
            settings.Add("Left Hand", true, "Split on getting the Left Hand", "ANY");
            settings.Add("Right Hand", true, "Split on getting the Right Hand", "ANY");
            settings.Add("Scanner Doll", true, "Scanner Doll", "ANY");
            settings.Add("Insert Scanner Doll", true, "Insert Scanner Doll", "ANY");
            settings.Add("CASE", true, "Split on opening Poppy's Case", "ANY");
        settings.Add("VHS", true, "VHS Tapes", "PP");
            settings.Add("Insert Lobby VHS", true, "Insert Lobby VHS", "VHS");
            settings.Add("Lobby VHS", true, "Lobby VHS", "VHS");
            settings.Add("Security VHS", true, "Security VHS", "VHS");
            settings.Add("Insert Security VHS", true, "Insert Security VHS", "VHS");
            settings.Add("Storage VHS", true, "Storage VHS", "VHS");
            settings.Add("Insert Storage VHS", true, "Insert Storage VHS", "VHS");
            settings.Add("Machine VHS", true, "Machine VHS", "VHS");
            settings.Add("Insert Machine VHS", true, "Insert Machine VHS", "VHS");
            settings.Add("Silo VHS", true, "Silo VHS", "VHS");
            settings.Add("Insert Silo VHS", true, "Insert Silo VHS", "VHS");
        settings.Add("KEYS", true, "Keys", "PP");
            settings.Add("Simon Room Key", true, "Simon Room Key", "KEYS");
            settings.Add("Red Key", true, "Red Key", "KEYS");
            settings.Add("Blue Key", true, "Blue Key", "KEYS");
            settings.Add("Green Key", true, "Green Key", "KEYS");
            settings.Add("Yellow Key", true, "Yellow Key", "KEYS");


    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Poppy Playtime Chapter 1",
            MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

init
{
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
}

update
{
    if(current.hasLeftHand != old.hasLeftHand)
    {
        print("Old: " + old.hasLeftHand + " New: " + current.hasLeftHand);
    }

    if(current.hasRightHand != old.hasRightHand)
    {
        print("Old: " + old.hasRightHand + " New: " + current.hasRightHand);
    }
}

isLoading
{
    return current.isLoaded == 0 || current.isPaused == 3;
}

start 
{
    if (current.LocationX != 0 && current.isLoaded == 1 && current.MainMenu == "/PP_FinalLevel" || current.LocationY != 0 && current.isLoaded == 1 && current.MainMenu == "/PP_FinalLevel") 
    {
        vars.ResetRunPersistentVariables();
        return true;
    }
}

split
{
    if (current.isPaused == 3) 
    {
        return false;
    }

    if (settings["Left Hand"] && !vars.hasPickedUpLeftHand && (int) current.hasLeftHand == 1)
    {
        vars.hasPickedUpLeftHand = true;
        return true;
    }

    if (settings["Right Hand"] && !vars.hasPickedUpRightHand && (int) current.hasRightHand == 257)
    {
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

reset
{
    return current.MainMenu == "/MainMenu" && old.MainMenu == "/PP_FinalLevel";
}
