import { ActionPanel, Action, List, showToast, Toast } from "@raycast/api";
import { useState } from "react";
import { exec, execSync } from "child_process";
import { promisify } from "util";

// Promisify exec for async/await usage
const execAsync = promisify(exec);

// Define available themes
interface Theme {
  id: string;
  name: string;
  description: string;
  icon: string;
}

const themes: Theme[] = [
  {
    id: "catppuccin",
    name: "Catppuccin",
    description: "Catpuccin theme",
    icon: "🔵"
  },
  {
    id: "gruvbox",
    name: "Gruvbox",
    description: "Gruvbox theme",
    icon: "🟠"
  },
];

// Alternative: Synchronous version for simple commands
async function switchToTheme(themeId: string): Promise<void> {
  const env = {
    ...process.env,
    USER: process.env.USER || process.env.LOGNAME || 'user',
    HOME: process.env.HOME || require('os').homedir(),
    PATH: process.env.PATH || '/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin',
  };
  try {
    switch (themeId) {
      case "catppuccin":
        await execAsync('$HOME/.config/themes/set_theme.sh Catppuccin', { env });
        break;
      case "gruvbox":
        await execAsync('$HOME/.config/themes/set_theme.sh Gruvbox', { env });
        break;
      default:
        throw new Error(`Theme "${themeId}" not implemented yet`);
    }
  } catch (error) {
    console.error(`Error switching to theme ${themeId}:`, error);
    throw error;
  }
}

export default function Command() {
  const [searchText, setSearchText] = useState("");
  const [currentTheme, setCurrentTheme] = useState<string>("");

  // Filter themes based on search text
  const filteredThemes = themes.filter((theme) =>
    theme.name.toLowerCase().includes(searchText.toLowerCase()) ||
    theme.description.toLowerCase().includes(searchText.toLowerCase())
  );

  async function handleThemeSwitch(theme: Theme) {
    try {
      await showToast({
        style: Toast.Style.Animated,
        title: "Switching theme...",
        message: `Changing to ${theme.name}`,
      });

      await switchToTheme(theme.id);
      setCurrentTheme(theme.id);

      await showToast({
        style: Toast.Style.Success,
        title: "Theme switched!",
        message: `Successfully changed to ${theme.name}`,
      });
    } catch (error) {
      await showToast({
        style: Toast.Style.Failure,
        title: "Failed to switch theme",
        message: error instanceof Error ? error.message : "Unknown error occurred",
      });
    }
  }

  return (
    <List
      isLoading={!currentTheme && currentTheme !== ""}
      onSearchTextChange={setSearchText}
      searchBarPlaceholder="Search themes..."
      throttle
    >
      {filteredThemes.map((theme) => (
        <List.Item
          key={theme.id}
          icon={theme.icon}
          title={theme.name}
          subtitle={theme.description}
          accessories={[
            ...(currentTheme === theme.id
              ? [{ text: "Current", tooltip: "Currently active theme" }]
              : []),
          ]}
          actions={
            <ActionPanel>
              <Action
                title={`Switch to ${theme.name}`}
                onAction={() => handleThemeSwitch(theme)}
              />
              <Action.CopyToClipboard
                title="Copy Theme ID"
                content={theme.id}
                shortcut={{ modifiers: ["cmd"], key: "c" }}
              />
            </ActionPanel>
          }
        />
      ))}
      {filteredThemes.length === 0 && (
        <List.EmptyView
          icon="🔍"
          title="No themes found"
          description="Try adjusting your search terms"
        />
      )}
    </List>
  );
}
