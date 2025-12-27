<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="UTF-8" %>
    <%@ Import Namespace="System.IO" %>
        <%@ Import Namespace="System.Linq" %>
            <%@ Import Namespace="System.Web" %>
                <script runat="server">
    protected void Page_Load(object sender, EventArgs e)
                    {
        string fileParam = Request.QueryString["file"];
                        if (!string.IsNullOrEmpty(fileParam)) {
                            if (fileParam.Contains("..") || fileParam.Contains(":") || fileParam.StartsWith("/") || fileParam.StartsWith("\\")) {
                                Response.StatusCode = 403;
                                Response.End();
                                return;
                            }

            string baseDir = Server.MapPath(".");
            string physicalPath = Path.Combine(baseDir, fileParam);
            FileInfo fi = new FileInfo(physicalPath);

                            if (fi.Exists) {
                                Response.Clear();
                                Response.ContentType = "application/octet-stream";
                                Response.AddHeader("Content-Disposition", "attachment; filename=\"" + HttpUtility.UrlEncode(fi.Name, System.Text.Encoding.UTF8) + "\"");
                                Response.AddHeader("Content-Length", fi.Length.ToString());
                                Response.TransmitFile(fi.FullName);
                                Response.End();
                            }
                            else {
                                Response.StatusCode = 404;
                                Response.Write("File not found.");
                                Response.End();
                            }
                        }
                    }
                </script>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="utf-8" />
                    <title>File Browser</title>
                    <style>
                        body {
                            font-family: sans-serif;
                            margin: 20px;
                        }

                        table {
                            border-collapse: collapse;
                            width: 100%;
                        }

                        th,
                        td {
                            border-bottom: 1px solid #ddd;
                            padding: 8px;
                            text-align: left;
                        }

                        th {
                            background-color: #f2f2f2;
                        }

                        tr:hover {
                            background-color: #f5f5f5;
                        }

                        .folder {
                            font-weight: bold;
                            color: #0056b3;
                        }

                        .file {
                            color: #333;
                        }

                        a {
                            text-decoration: none;
                        }

                        a:hover {
                            text-decoration: underline;
                        }
                    </style>
                </head>

                <body>
                    <% string relativePath=Request.QueryString["dir"]; if (string.IsNullOrEmpty(relativePath)) {
                        relativePath="" ; } if (relativePath.Contains("..") || relativePath.StartsWith("/") ||
                        relativePath.StartsWith("\\") || relativePath.Contains(":")) { relativePath="" ; } string
                        baseDir=Server.MapPath("."); string currentPhysicalPath=Path.Combine(baseDir, relativePath);
                        DirectoryInfo di=null; try { di=new DirectoryInfo(currentPhysicalPath); if (!di.Exists) { di=new
                        DirectoryInfo(baseDir); relativePath="" ; } } catch { di=new DirectoryInfo(baseDir);
                        relativePath="" ; } %>

                        <h2>Current Location: /<%= relativePath.Replace("\\", "/" ) %>
                        </h2>

                        <table>
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Last Modified</th>
                                    <th>Size (KB)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (!string.IsNullOrEmpty(relativePath)) { string
                                    parentDir=Path.GetDirectoryName(relativePath); if (string.IsNullOrEmpty(parentDir)
                                    || parentDir=="\\" || parentDir=="/" ) parentDir="" ; string
                                    parentLink=string.IsNullOrEmpty(parentDir) ? "index.aspx" : "index.aspx?dir=" +
                                    HttpUtility.UrlEncode(parentDir); %>
                                    <tr>
                                        <td colspan="3">
                                            <a href="<%= parentLink %>" class="folder">[..] Up One Level</a>
                                        </td>
                                    </tr>
                                    <% } try { foreach (var dir in di.GetDirectories().OrderBy(d=> d.Name)) {
                                        string nextDir = Path.Combine(relativePath, dir.Name);
                                        string dirLink = "index.aspx?dir=" + HttpUtility.UrlEncode(nextDir);
                                        %>
                                        <tr>
                                            <td><a href="<%= dirLink %>" class="folder">[<%= dir.Name %>]</a></td>
                                            <td>
                                                <%= dir.LastWriteTime.ToString("yyyy/MM/dd HH:mm:ss") %>
                                            </td>
                                            <td>-</td>
                                        </tr>
                                        <% } } catch {} try { var files=di.GetFiles() .Where(f=>
                                            !f.Name.Equals("index.aspx", StringComparison.OrdinalIgnoreCase) &&
                                            !f.Name.Equals("web.config", StringComparison.OrdinalIgnoreCase))
                                            .OrderByDescending(f => f.LastWriteTime);

                                            foreach (var file in files) {
                                            string webPath = relativePath.Replace("\\", "/");
                                            string filePathForDownload = (string.IsNullOrEmpty(webPath) ? "" : webPath +
                                            "/") + file.Name;

                                            string link = "index.aspx?file=" +
                                            HttpUtility.UrlEncode(filePathForDownload);
                                            %>
                                            <tr>
                                                <td><a href="<%= link %>" class="file">
                                                        <%= file.Name %>
                                                    </a></td>
                                                <td>
                                                    <%= file.LastWriteTime.ToString("yyyy/MM/dd HH:mm:ss") %>
                                                </td>
                                                <td>
                                                    <%= (file.Length / 1024.0).ToString("N0") %>
                                                </td>
                                            </tr>
                                            <% } } catch {} %>
                            </tbody>
                        </table>
                </body>

                </html>