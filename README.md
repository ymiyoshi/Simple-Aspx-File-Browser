# Simple Aspx File Browser

A simple and lightweight single-file file browser running on ASP.NET.
It operates with just `index.aspx` and `web.config`, providing file listing within directories and file download capabilities.

## Features

- **Registered Folders**: Configure multiple root folders to browse from a central list.
- **Directory Browsing**: Navigate through folder structures to view subdirectories.
- **File Listing**: Displays file name, last modified date, and file size.
- **File Download**: Click to securely download files.
- **Folder Status**: Shows availability status (OK/Not Found) for registered folders.
- **Security**: Includes basic protection against directory traversal attacks.
- **Lightweight**: Works in a standard ASP.NET environment without the need for external libraries.
- **Responsive Design**: Mobile-friendly interface with card-style layout on small screens.

## Requirements

- IIS (Internet Information Services)
- ASP.NET (C#) Runtime

## Installation

1. Place `index.aspx` and `web.config` from this repository into your Web server's public directory.
2. Configure the folders you want to browse in `web.config` (see Configuration section).
3. Access the directory where you placed the files using a web browser.
4. Installation is complete if the registered folders list is displayed.

## Configuration

Register folders to browse by adding entries to the `appSettings` section in `web.config`:

```xml
<appSettings>
    <add key="Folder1" value="D:\Data\Files" />
    <add key="Folder2" value="E:\SharedFiles" />
    <add key="Folder3" value="C:\PublicDocuments" />
</appSettings>
```

- Use keys starting with `Folder` (e.g., `Folder1`, `Folder2`, `FolderBackup`, etc.)
- Values should be absolute paths to the directories you want to browse
- Folders that don't exist will be displayed with a "Not Found" status

## License

This software is released under the [Apache License 2.0](LICENSE).
