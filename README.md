# 🚀 Windows Developer Toolkit Installer

![GitHub stars](https://img.shields.io/github/stars/yourusername/windows-dev-toolkit?style=social)
![GitHub forks](https://img.shields.io/github/forks/yourusername/windows-dev-toolkit?style=social)
![GitHub issues](https://img.shields.io/github/issues/yourusername/windows-dev-toolkit)
![License](https://img.shields.io/badge/License-MIT-green.svg)

<div align="center">
  <img src="https://github.com/yourusername/windows-dev-toolkit/raw/main/assets/toolkit-logo.png" alt="Windows Developer Toolkit Logo" width="300">
  <h3>One-click solution to set up your complete Windows development environment</h3>
</div>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-included-tools">Included Tools</a> •
  <a href="#-usage">Usage</a> •
  <a href="#-customization">Customization</a> •
  <a href="#-contributing">Contributing</a> •
  <a href="#-license">License</a>
</p>

## ✨ Features

- **Fully Automated**: Installs and configures everything with minimal user intervention
- **PATH Management**: Automatically adds all tools to your system PATH
- **Administrator Friendly**: Handles UAC and permissions appropriately
- **Error Handling**: Robust error handling with informative feedback
- **Clean Design**: Beautiful terminal output with color-coded information
- **Customizable**: Easily modify the script to add or remove tools

## 📥 Installation

### Prerequisites
- Windows 10 (64-bit)
- PowerShell 5.1 or later
- Administrator privileges
- Internet connection

### Quick Install

1. **Download the script**
   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yourusername/windows-dev-toolkit/main/install.ps1" -OutFile "$env:TEMP\install.ps1"
   ```

2. **Run the script as administrator**
   ```powershell
   Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$env:TEMP\install.ps1`"" -Verb RunAs
   ```

### Manual Installation

1. Clone this repository:
   ```powershell
   git clone https://github.com/yourusername/windows-dev-toolkit.git
   ```

2. Navigate to the directory:
   ```powershell
   cd windows-dev-toolkit
   ```

3. Run the installer script as administrator:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\install.ps1
   ```

## 🛠 Included Tools

The toolkit installs and configures the following development tools:

| Tool | Version | Description | Path Added |
|------|---------|-------------|------------|
| **XAMPP** | 8.2.4 | Complete web development environment (Apache, MySQL, PHP, Perl) | `C:\xampp\php`, `C:\xampp\mysql\bin` |
| **Strawberry Perl** | 5.32.1.1 | Perl programming language for Windows | `C:\Strawberry\perl\bin` |
| **Ruby** | 3.2.2 | Ruby programming language | `C:\Ruby32\bin` |
| **Python** | 3.11.3 | Python programming language | Added automatically by installer |
| **Node.js** | 18.16.0 | JavaScript runtime built on Chrome's V8 engine | Added automatically by installer |
| **MSYS2** | Latest | Software distribution and building platform for Windows | `C:\msys64\usr\bin`, `C:\msys64\mingw64\bin` |
| **Go** | 1.20.4 | Go programming language | `C:\Go\bin`, `%USERPROFILE%\go\bin` |
| **Git** | 2.40.1 | Distributed version control system | `C:\Program Files\Git\cmd` |

## 💻 Usage

After running the installer, you'll have a complete development environment ready to use. All tools are available from any command prompt or PowerShell window.

### Verification

To verify that tools were installed correctly, open a new command prompt and try these commands:

```bash
php --version
perl --version
ruby --version
python --version
node --version
go version
git --version
```

### Project Examples

#### PHP (XAMPP)
```bash
cd C:\xampp\htdocs
mkdir my-php-project
cd my-php-project
echo "<?php phpinfo(); ?>" > index.php
# Access at http://localhost/my-php-project/
```

#### Node.js
```bash
mkdir my-node-project
cd my-node-project
npm init -y
npm install express
echo "const express = require('express'); const app = express(); app.get('/', (req, res) => res.send('Hello World!')); app.listen(3000, () => console.log('Server running on port 3000'));" > index.js
node index.js
# Access at http://localhost:3000/
```

#### Python
```bash
mkdir my-python-project
cd my-python-project
python -m venv venv
.\venv\Scripts\activate
pip install flask
echo "from flask import Flask; app = Flask(__name__); @app.route('/'); def hello(): return 'Hello, World!'; if __name__ == '__main__': app.run(debug=True)" > app.py
python app.py
# Access at http://localhost:5000/
```

## ⚙️ Customization

You can customize the installation by editing the script:

### Adding a New Tool

Add a new function to the script following this pattern:

```powershell
function Install-NewTool {
    $toolUrl = "https://example.com/tool-installer.exe"
    $toolInstaller = "$tempDir\tool-installer.exe"
    
    if (Download-File -Url $toolUrl -OutputFile $toolInstaller) {
        if (Install-Tool -InstallerPath $toolInstaller -Arguments "/silent" -ToolName "New Tool") {
            Add-ToPath -PathToAdd "C:\Path\To\Tool\bin"
        }
    }
}

# Then add it to the main installation list
Install-NewTool
```

### Removing a Tool

Simply comment out or remove the respective installation function call from the main installation process:

```powershell
# Install each tool
Install-Xampp
Install-StrawberryPerl
# Install-Ruby  # Commented out to skip Ruby installation
Install-Python
```

## 🔄 Updating the Tools

This script installs specific versions of each tool. To update to newer versions:

1. Edit the script and update the URLs to point to the latest versions
2. Run the script again to reinstall with the newer versions

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

- [PowerShell Team](https://github.com/PowerShell/PowerShell) for creating an amazing scripting language
- All the amazing open-source projects we're installing
- [Shields.io](https://shields.io) for the badges

---

<div align="center">
  <p>Made with ❤️ for developers who need a quick start on Windows</p>
  <p>© 2025 Your Name</p>
</div># Dev_Tools
