<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="UTF-8" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">
    // 登録フォルダのリストを取得
    private List<string> GetRegisteredFolders()
    {
        var folders = new List<string>();
        var appSettings = ConfigurationManager.AppSettings;
        foreach (string key in appSettings.AllKeys)
        {
            if (key.StartsWith("Folder", StringComparison.OrdinalIgnoreCase))
            {
                folders.Add(appSettings[key]);
            }
        }
        return folders;
    }

    // rootパラメータからベースディレクトリを取得
    private string GetBaseDirectory(string rootParam, List<string> folders)
    {
        if (string.IsNullOrEmpty(rootParam)) return null;
        int rootIndex;
        if (!int.TryParse(rootParam, out rootIndex)) return null;
        if (rootIndex < 0 || rootIndex >= folders.Count) return null;
        return folders[rootIndex];
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string fileParam = Request.QueryString["file"];
        if (!string.IsNullOrEmpty(fileParam))
        {
            // パストラバーサル対策
            if (fileParam.Contains("..") || fileParam.Contains(":") || fileParam.StartsWith("/") || fileParam.StartsWith("\\"))
            {
                Response.StatusCode = 403;
                Response.End();
                return;
            }

            // rootパラメータからベースディレクトリを取得
            string rootParam = Request.QueryString["root"];
            var folders = GetRegisteredFolders();
            string baseDir = GetBaseDirectory(rootParam, folders);

            if (baseDir == null)
            {
                Response.StatusCode = 403;
                Response.Write("Invalid root parameter.");
                Response.End();
                return;
            }

            string physicalPath = Path.Combine(baseDir, fileParam);
            FileInfo fi = new FileInfo(physicalPath);

            if (fi.Exists)
            {
                Response.Clear();
                Response.ContentType = "application/octet-stream";
                Response.AddHeader("Content-Disposition", "attachment; filename=\"" + HttpUtility.UrlEncode(fi.Name, System.Text.Encoding.UTF8) + "\"");
                Response.AddHeader("Content-Length", fi.Length.ToString());
                Response.TransmitFile(fi.FullName);
                Response.End();
            }
            else
            {
                Response.StatusCode = 404;
                Response.Write("File not found.");
                Response.End();
            }
        }
    }
</script>
                <!DOCTYPE html>
                <html lang="ja">

                <head>
                    <meta charset="utf-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>File Browser</title>
                    <link rel="preconnect" href="https://fonts.googleapis.com">
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap"
                        rel="stylesheet">
                    <style>
                        :root {
                            --primary-color: #2563eb;
                            --primary-hover: #1d4ed8;
                            --bg-color: #f3f4f6;
                            --card-bg: #ffffff;
                            --text-main: #1f2937;
                            --text-secondary: #6b7280;
                            --border-color: #e5e7eb;
                            --header-bg: #f9fafb;
                        }

                        body {
                            font-family: 'Inter', sans-serif;
                            margin: 0;
                            padding: 20px;
                            background-color: var(--bg-color);
                            color: var(--text-main);
                            line-height: 1.5;
                        }

                        .container {
                            max-width: 1400px;
                            width: 95%;
                            margin: 0 auto;
                        }

                        h2 {
                            font-size: 1.25rem;
                            color: var(--text-main);
                            margin-bottom: 20px;
                            word-break: break-all;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        h2::before {
                            content: "\01F4C2";
                            font-size: 1.5rem;
                        }

                        .table-card {
                            background: var(--card-bg);
                            border-radius: 12px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                            overflow: hidden;
                            overflow-x: auto;
                            border: 1px solid var(--border-color);
                        }

                        table {
                            border-collapse: collapse;
                            width: 100%;
                            font-size: 0.95rem;
                        }

                        th,
                        td {
                            padding: 16px;
                            text-align: left;
                            border-bottom: 1px solid var(--border-color);
                        }

                        th {
                            background-color: var(--header-bg);
                            font-weight: 600;
                            color: var(--text-secondary);
                            text-transform: uppercase;
                            font-size: 0.75rem;
                            letter-spacing: 0.05em;
                        }

                        tr:last-child td {
                            border-bottom: none;
                        }

                        tr:hover {
                            background-color: #f9fafb;
                        }

                        a {
                            text-decoration: none;
                            color: var(--text-main);
                            font-weight: 500;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            transition: color 0.2s;
                        }

                        a:hover {
                            color: var(--primary-color);
                        }

                        .folder,
                        .file {
                            width: 100%;
                            word-break: break-all;
                        }

                        .folder-icon,
                        .file-icon {
                            font-size: 1.2em;
                            color: var(--primary-color);
                        }

                        .file-icon {
                            color: var(--text-secondary);
                        }

                        .up-level {
                            color: var(--text-secondary);
                            font-weight: 600;
                        }

                        .error-folder {
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            color: #991b1b;
                        }

                        .error-icon {
                            color: #dc2626;
                        }

                        .status-ok {
                            color: #059669;
                            font-weight: 500;
                        }

                        .status-error {
                            color: #dc2626;
                            font-weight: 500;
                        }

                        /* Mobile Responsive Styles */
                        @media screen and (max-width: 768px) {
                            body {
                                padding: 10px;
                            }

                            h2 {
                                font-size: 1.1rem;
                                margin-bottom: 15px;
                            }

                            /* Convert table to card list */
                            table,
                            thead,
                            tbody,
                            th,
                            td,
                            tr {
                                display: block;
                            }

                            thead tr {
                                position: absolute;
                                top: -9999px;
                                left: -9999px;
                            }

                            tr {
                                background: white;
                                margin-bottom: 0;
                                border-bottom: 1px solid var(--border-color);
                            }

                            tr:last-child {
                                border-bottom: none;
                            }

                            td {
                                border: none;
                                position: relative;
                                padding: 8px 16px;
                                padding-left: 16px;
                            }

                            /* Name row acts as header of the item */
                            td:first-child {
                                padding-top: 16px;
                                font-size: 1rem;
                                font-weight: 600;
                            }

                            /* Detail rows */
                            td:not(:first-child) {
                                padding-top: 4px;
                                padding-bottom: 4px;
                                font-size: 0.85rem;
                                color: var(--text-secondary);
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                            }

                            td:not(:first-child)::before {
                                content: attr(data-label);
                                font-weight: 500;
                                font-size: 0.75rem;
                                text-transform: uppercase;
                                letter-spacing: 0.05em;
                                color: #9ca3af;
                                margin-right: 12px;
                            }

                            /* Add some spacing at bottom of card item */
                            td:last-child {
                                padding-bottom: 16px;
                            }
                        }
                    </style>
                </head>

<body>
<%
    // 登録フォルダリストを取得
    var registeredFolders = GetRegisteredFolders();
    string rootParam = Request.QueryString["root"];
    string relativePath = Request.QueryString["dir"] ?? "";

    // パストラバーサル対策
    if (relativePath.Contains("..") || relativePath.StartsWith("/") ||
        relativePath.StartsWith("\\") || relativePath.Contains(":"))
    {
        relativePath = "";
    }

    bool isRootView = string.IsNullOrEmpty(rootParam);
    int rootIndex = -1;
    string baseDir = null;
    DirectoryInfo di = null;
    bool baseDirExists = false;

    if (!isRootView)
    {
        // rootパラメータの検証
        if (int.TryParse(rootParam, out rootIndex) && rootIndex >= 0 && rootIndex < registeredFolders.Count)
        {
            baseDir = registeredFolders[rootIndex];
            string currentPhysicalPath = Path.Combine(baseDir, relativePath);
            try
            {
                di = new DirectoryInfo(currentPhysicalPath);
                if (!di.Exists)
                {
                    di = new DirectoryInfo(baseDir);
                    relativePath = "";
                }
                baseDirExists = Directory.Exists(baseDir);
            }
            catch
            {
                di = new DirectoryInfo(baseDir);
                relativePath = "";
                baseDirExists = Directory.Exists(baseDir);
            }
        }
        else
        {
            // 無効なrootパラメータの場合はルートビューにリダイレクト
            isRootView = true;
        }
    }
%>

<div class="container">
<% if (isRootView) { %>
    <!-- ルート画面: 登録フォルダ一覧 -->
    <h2>Registered Folders</h2>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Last Modified</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
            <%
            for (int i = 0; i < registeredFolders.Count; i++)
            {
                string folderPath = registeredFolders[i];
                bool exists = Directory.Exists(folderPath);
                string folderLink = "index.aspx?root=" + i;
                DirectoryInfo folderInfo = null;
                string lastModified = "-";

                if (exists)
                {
                    try
                    {
                        folderInfo = new DirectoryInfo(folderPath);
                        lastModified = folderInfo.LastWriteTime.ToString("yyyy/MM/dd HH:mm");
                    }
                    catch { }
                }
            %>
                <tr>
                    <td data-label="Name">
                        <% if (exists) { %>
                        <a href="<%= folderLink %>" class="folder">
                            <span class="folder-icon">&#128193;</span>
                            <%= folderPath %>
                        </a>
                        <% } else { %>
                        <span class="folder error-folder">
                            <span class="folder-icon error-icon">&#9888;</span>
                            <%= folderPath %>
                        </span>
                        <% } %>
                    </td>
                    <td data-label="Date"><%= lastModified %></td>
                    <td data-label="Status">
                        <% if (exists) { %>
                        <span class="status-ok">OK</span>
                        <% } else { %>
                        <span class="status-error">Not Found</span>
                        <% } %>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>

<% } else { %>
    <!-- フォルダブラウジング画面 -->
    <h2>Location: <%= baseDir %><%= string.IsNullOrEmpty(relativePath) ? "" : "\\" + relativePath %></h2>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Last Modified</th>
                    <th>Size</th>
                </tr>
            </thead>
            <tbody>
                <!-- Up One Level -->
                <tr>
                    <td colspan="3">
                        <%
                        string parentLink;
                        if (string.IsNullOrEmpty(relativePath))
                        {
                            // ルートフォルダの直下 → フォルダ一覧に戻る
                            parentLink = "index.aspx";
                        }
                        else
                        {
                            // サブフォルダ内 → 親ディレクトリへ
                            string parentDir = Path.GetDirectoryName(relativePath);
                            if (string.IsNullOrEmpty(parentDir) || parentDir == "\\" || parentDir == "/")
                            {
                                parentLink = "index.aspx?root=" + rootIndex;
                            }
                            else
                            {
                                parentLink = "index.aspx?root=" + rootIndex + "&dir=" + HttpUtility.UrlEncode(parentDir);
                            }
                        }
                        %>
                        <a href="<%= parentLink %>" class="folder up-level">
                            <span class="folder-icon">&#8617;</span> Up One Level
                        </a>
                    </td>
                </tr>

                <!-- サブフォルダ一覧 -->
                <%
                try
                {
                    foreach (var dir in di.GetDirectories().OrderBy(d => d.Name))
                    {
                        string nextDir = string.IsNullOrEmpty(relativePath) ? dir.Name : Path.Combine(relativePath, dir.Name);
                        string dirLink = "index.aspx?root=" + rootIndex + "&dir=" + HttpUtility.UrlEncode(nextDir);
                %>
                <tr>
                    <td data-label="Name">
                        <a href="<%= dirLink %>" class="folder">
                            <span class="folder-icon">&#128193;</span>
                            <%= dir.Name %>
                        </a>
                    </td>
                    <td data-label="Date"><%= dir.LastWriteTime.ToString("yyyy/MM/dd HH:mm") %></td>
                    <td data-label="Size">-</td>
                </tr>
                <%
                    }
                }
                catch { }
                %>

                <!-- ファイル一覧 -->
                <%
                try
                {
                    var files = di.GetFiles()
                        .Where(f => !f.Name.Equals("index.aspx", StringComparison.OrdinalIgnoreCase) &&
                                    !f.Name.Equals("web.config", StringComparison.OrdinalIgnoreCase))
                        .OrderByDescending(f => f.LastWriteTime);

                    foreach (var file in files)
                    {
                        string webPath = relativePath.Replace("\\", "/");
                        string filePathForDownload = (string.IsNullOrEmpty(webPath) ? "" : webPath + "/") + file.Name;
                        string link = "index.aspx?root=" + rootIndex + "&file=" + HttpUtility.UrlEncode(filePathForDownload);
                %>
                <tr>
                    <td data-label="Name">
                        <a href="<%= link %>" class="file">
                            <span class="file-icon">&#128196;</span>
                            <%= file.Name %>
                        </a>
                    </td>
                    <td data-label="Date"><%= file.LastWriteTime.ToString("yyyy/MM/dd HH:mm") %></td>
                    <td data-label="Size"><%= (file.Length / 1024.0).ToString("N0") %> KB</td>
                </tr>
                <%
                    }
                }
                catch { }
                %>
            </tbody>
        </table>
    </div>
<% } %>
</div>
</body>

                </html>