# Simple Aspx File Browser

A simple and lightweight single-file file browser running on ASP.NET.
It operates with just `index.aspx`, providing file listing within directories and file download capabilities.

## Features

- **Directory Browsing**: Navigate through folder structures to view subdirectories.
- **File Listing**: Displays file name, last modified date, and file size.
- **File Download**: Click to securely download files.
- **Security**: Includes basic protection against directory traversal attacks.
- **Lightweight**: Works in a standard ASP.NET environment without the need for external libraries.

## Requirements

- IIS (Internet Information Services)
- ASP.NET (C#) Runtime

## Installation

1. Place `index.aspx` and `web.config` from this repository into your Web server's public directory.
2. Access the directory where you placed the files using a web browser.
3. Installation is complete if the file and directory list is displayed.

## License

This software is released under the [Apache License 2.0](LICENSE).
