# 📘 HƯỚNG DẪN SỬ DỤNG (HDSD) — BỘ KỸ NĂNG `Skill_AI_ALL` (v3.0)

Tài liệu này hướng dẫn chi tiết cách sử dụng, bảo mật mật khẩu/API key và tích hợp bộ kỹ năng **`Skill_AI_ALL` (v3.0)** — được chắt lọc từ **REA (`rea-agents`)**, **OpenSpec**, **UI-TARS**, **Windows-MCP**, **Claude Official Plugins** và **Antigravity Skills** — vào **Claude Desktop App**, **Claude Code**, **OpenCode**, **Antigravity/Gemini**, **Cursor**, **Windsurf**, **GitHub Copilot**, **ChatGPT/Claude Web** và **Local AI (Ollama/LM Studio)**.

---

## 1. Cấu Trúc Thư Mục Tinh Gọn (Đã Xóa Bỏ File Trùng Lặp)

Toàn bộ bộ kỹ năng được đóng gói gọn gàng, không trùng lặp trong thư mục `c:\Git_Skill_AI\Skill_AI_ALL\`:

```text
c:\Git_Skill_AI\Skill_AI_ALL\
├── UNIVERSAL_AI_SKILL_PACK.md     # [FILE GỐC DUY NHẤT] Chứa trọn bộ Rule + 6 Module Skill (Dual-Format)
├── secret_guard.py                # Công cụ Python Offline quét & che giấu mật khẩu/API key ([REDACTED])
├── apply-skill-pack.ps1           # Script tự động cài đặt 1 chạm trên Windows (PowerShell)
├── apply-skill-pack.sh            # Script tự động cài đặt 1 chạm trên Kali Linux / Ubuntu / macOS (Bash)
├── README_HDSD.md                 # Tài liệu Hướng dẫn sử dụng đầy đủ này
├── claude-app-zips\               # 8 file .zip chuẩn POSIX để Upload trực tiếp vào Claude Desktop App
│   ├── universal-ai-elite-skill-pack.zip        # Gói All-in-One (khuyên dùng nếu chỉ muốn up 1 file)
│   ├── zero-leak-security-guard.zip             # 1. Chốt chặn chống lộ mật khẩu, .env, dữ liệu nhạy cảm
│   ├── desktop-browser-operator.zip             # 2. Điều khiển Windows GUI & Trình duyệt lai (DOM + Vision)
│   ├── mcp-blackbox-qa-tester.zip               # 3. Kiểm thử hộp đen (Black-box QA) & Bắt "Test Xanh Giả"
│   ├── adversarial-verifier-siege.zip           # 4. Phản biện đối kháng & Giải quyết bug khó (Siege + 4 tầng bằng chứng)
│   ├── reverse-engineering-and-rea.zip          # 5. Dịch ngược Binary/App/Network & Phân tích sâu bằng REA
│   ├── distinctive-ui-and-playground.zip        # 6. Thiết kế giao diện chống rập khuôn & HTML Playground
│   └── universal-skill-mcp-architect.zip        # 7. Kiến trúc sư tạo Skill 3 tầng & MCP 6 hình thái chuẩn
└── skills\                        # 8 Module kỹ năng chuẩn SKILL.md (tự động đồng bộ sang các AI Agent)
    ├── universal-ai-elite-skill-pack\SKILL.md
    ├── zero-leak-security-guard\SKILL.md
    ├── desktop-browser-operator\SKILL.md
    ├── mcp-blackbox-qa-tester\SKILL.md
    ├── adversarial-verifier-siege\SKILL.md
    ├── reverse-engineering-and-rea\SKILL.md
    ├── distinctive-ui-and-playground\SKILL.md
    └── universal-skill-mcp-architect\SKILL.md
```

---

## 2. Cách Cài Đặt Nhanh Bằng Script Tự Động (Windows & Kali Linux)

### 🐧 A. Trên Kali Linux / Ubuntu / Debian / macOS / WSL

1. **Lệnh 1 dòng: Tải từ GitHub và cài đặt Toàn Cục (Global) ngay lập tức**:
   ```bash
   git clone https://github.com/Quang260605/API-AI-Agent.git ~/Skill_AI_ALL && bash ~/Skill_AI_ALL/apply-skill-pack.sh global
   ```
2. **Nếu đã có sẵn thư mục trên máy Kali Linux**:
   - **Cài đặt Toàn cục (Global)** (cho Claude Code, OpenCode, Gemini CLI/Antigravity):
     ```bash
     bash ~/Skill_AI_ALL/apply-skill-pack.sh global
     ```
   - **Cài đặt vào một Dự án (Project) cụ thể**:
     ```bash
     bash ~/Skill_AI_ALL/apply-skill-pack.sh project /duong/dan/du_an
     ```
   - **Cài đặt cả Global lẫn Dự án hiện tại**:
     ```bash
     bash ~/Skill_AI_ALL/apply-skill-pack.sh all "$(pwd)"
     ```

---

### 🪟 B. Trên Windows (PowerShell)

1. **Cài đặt Toàn Cục (Global) cho máy tính Windows**:
   ```powershell
   powershell -ExecutionPolicy Bypass -File "c:\Git_Skill_AI\Skill_AI_ALL\apply-skill-pack.ps1" -Target Global
   ```
2. **Cài đặt vào một Dự Án (Project) cụ thể**:
   ```powershell
   powershell -ExecutionPolicy Bypass -File "c:\Git_Skill_AI\Skill_AI_ALL\apply-skill-pack.ps1" -Target Project -ProjectPath "D:\Du_An_Cua_Ban"
   ```

---

## 3. Hướng Dẫn Áp Dụng Cho Từng Loại AI Agent

### 3.1. Claude Desktop App (Ứng dụng Claude trên Windows: `Chat`, `Cowork`, `Code`)
1. **Chế độ `Code` (Tab Code trong Claude App)**:
   - **Đã tự động kích hoạt!** Tab `Code` đọc trực tiếp từ `C:\Users\<Tên_User>\.claude\CLAUDE.md` và `C:\Users\<Tên_User>\.claude\skills\`.
2. **Nạp vào mục `Skills` của Claude App (Dùng cho cả `Chat` và `Cowork` qua dấu `/`)**:
   - Mở **Claude App** $\rightarrow$ bấm vào mục **Customize** ở thanh bên trái $\rightarrow$ chọn **Skills** *(hoặc vào **Settings $\rightarrow$ Capabilities $\rightarrow$ Skills**)*.
   - Bấm nút **`+` (Add skill / Upload skill)** và chọn file trong thư mục `c:\Git_Skill_AI\Skill_AI_ALL\claude-app-zips\`:
     - **Cách nhanh nhất (1 file duy nhất)**: Upload `universal-ai-elite-skill-pack.zip` (chứa trọn bộ tất cả quy chuẩn và 6 module kỹ năng).
     - **Hoặc upload từng module riêng lẻ** để gọi nhanh bằng lệnh `/` trong khung chat (ví dụ: `/reverse-engineering-and-rea`, `/adversarial-verifier-siege`, `/zero-leak-security-guard`).
3. **Áp dụng mặc định cho mọi cuộc trò chuyện ở Tab `Chat` (`Personal preferences` / `Projects`)**:
   - **Cho mọi cuộc chat**: Vào **Settings (`Ctrl + ,`) $\rightarrow$ Profile $\rightarrow$ Personal preferences**, copy và dán nội dung file `UNIVERSAL_AI_SKILL_PACK.md` vào.
   - **Cho từng Project riêng**: Mở mục **Projects** $\rightarrow$ bấm dấu `+` ở mục **Instructions** hoặc **Files** và chọn file `UNIVERSAL_AI_SKILL_PACK.md`.

### 3.2. Claude Code (CLI & VS Code Extension)
- **Toàn cục**: Copy `UNIVERSAL_AI_SKILL_PACK.md` thành `C:\Users\<Tên_User>\.claude\CLAUDE.md` và copy `skills\*` vào `C:\Users\<Tên_User>\.claude\skills\`.
- **Theo từng project**: Copy `UNIVERSAL_AI_SKILL_PACK.md` thành `CLAUDE.md` ở thư mục gốc của project.

### 3.3. OpenCode (App Desktop & CLI)
- **Toàn cục**: Copy `UNIVERSAL_AI_SKILL_PACK.md` thành `C:\Users\<Tên_User>\.config\opencode\AGENTS.md` và copy `skills\*` vào `C:\Users\<Tên_User>\.config\opencode\skills\`.
- **Theo từng project**: Copy `UNIVERSAL_AI_SKILL_PACK.md` thành `AGENTS.md` ở thư mục gốc của project.

### 3.4. Cursor / Windsurf / Cline / Roo Code / GitHub Copilot
Copy file `UNIVERSAL_AI_SKILL_PACK.md` vào thư mục gốc của dự án và đổi tên theo công cụ:
- **Cursor IDE**: đổi tên thành `.cursorrules` (hoặc `.cursor/rules/elite-pack.mdc`).
- **Windsurf IDE**: đổi tên thành `.windsurfrules`.
- **Cline / Roo Code**: đổi tên thành `.clinerules`.
- **GitHub Copilot**: đặt vào `.github/copilot-instructions.md`.
- **OpenAI Codex CLI / Devin / Aider**: đổi tên thành `AGENTS.md`.

### 3.5. ChatGPT / Claude Web / Gemini Web & Local AI (Ollama / LM Studio)
- Copy nội dung `UNIVERSAL_AI_SKILL_PACK.md` dán vào **Project Instructions** (ChatGPT/Claude Web), **Gem Instructions** (Gemini Web), hoặc **System Prompt** (LM Studio / OpenWebUI / Ollama `Modelfile`).

---

## 4. Hướng Dẫn Bảo Mật Chống Lộ Mật Khẩu / API Key (`Zero-Leak`)

### 4.1. Cách kiểm tra và xóa mật khẩu bị lộ bằng `secret_guard.py`
Trước khi đẩy code lên GitHub, gửi log cho người khác, hoặc đưa một thư mục lạ cho AI đọc, hãy chạy công cụ Offline `secret_guard.py`:

1. **Chế độ Quét Kiểm Tra (Không sửa file)**:
   - **Windows**:
     ```powershell
     python "c:\Git_Skill_AI\Skill_AI_ALL\secret_guard.py" "D:\Du_An_Cua_Ban"
     ```
   - **Kali Linux / Linux / macOS**:
     ```bash
     python3 ~/Skill_AI_ALL/secret_guard.py /duong/dan/du_an
     ```
2. **Chế độ Tự Động Làm Sạch (`--redact`)**:
   - **Windows**:
     ```powershell
     python "c:\Git_Skill_AI\Skill_AI_ALL\secret_guard.py" "D:\Du_An_Cua_Ban" --redact
     ```
   - **Kali Linux / Linux / macOS**:
     ```bash
     python3 ~/Skill_AI_ALL/secret_guard.py /duong/dan/du_an --redact
     ```
   *(Tự động thay thế mọi mật khẩu, API key `sk-...`, `ghp_...`, `AIza...`, `AKIA...`, JWT, chuỗi kết nối DB `user:password@host` thành `[REDACTED]`).*

### 4.2. Quy tắc làm việc với `.env` khi dùng AI Agent
- AI sẽ **không bao giờ** chạy `cat .env` hay `Get-Content .env`.
- Khi cần nhập API Key mới, **đừng dán trực tiếp vào khung chat**. Hãy bảo AI: *"Tạo lệnh nhập ẩn cho biến `OPENAI_API_KEY` vào file `.env`"* — AI sẽ đưa lệnh ẩn ký tự gõ để bạn tự chạy trong terminal.

---

## 5. Cách Kết Nối Công Cụ Dịch Ngược `REA` (`c:\Git_Skill_AI\rea`) Vào Các AI Agent

Thư mục `c:\Git_Skill_AI\rea` trong workspace của bạn là hệ thống MCP & CLI **REA (`rea-agents`)** giúp AI mổ xẻ file `.exe`, `.dll`, `.apk`, Electron `.asar`, Unity `IL2CPP`, `.wasm`, gói tin mạng `.har`/`.pcap`...

### 🔹 Cách 1: Cài đặt tự động bằng trình Setup của REA (Khuyên dùng)
Chạy lệnh sau trong terminal để REA tự nhận diện các AI Agent trên máy (Claude Code, Claude Desktop, OpenCode, Cursor, Gemini CLI, Codex...), hiển thị bản xem trước và tạo bản sao lưu cấu hình:
```powershell
npx rea-agents setup
```
*(Nếu muốn kiểm tra trạng thái kết nối mà không sửa file cấu hình, chạy: `npx rea-agents doctor`)*.

### 🔹 Cách 2: Cấu hình MCP trong Claude Desktop App (Bản Microsoft Store MSIX)
Trên máy tính cài bản **Claude App qua Microsoft Store (MSIX)**, file cấu hình MCP thực tế nằm tại:
`%LOCALAPPDATA%\Claude-Data\claude_pzs8sxrjxfjjc\claude_desktop_config.json`
*(Hoặc trong Claude App bấm `Ctrl + ,` $\rightarrow$ **Developer** $\rightarrow$ **Edit Config**)*.

---

## 6. Bảng Câu Lệnh Mẫu (Prompt) Để Kích Hoạt Đúng Từng Kỹ Năng Khi Chat Với AI

| Khi bạn muốn... | Câu lệnh (Prompt) mẫu gửi cho AI | Module được kích hoạt |
| :--- | :--- | :--- |
| **Kiểm tra/nhập API Key an toàn** | *"Kiểm tra xem trong `.env` đã có `GEMINI_API_KEY` chưa theo giao thức Zero-Leak (không đọc giá trị)."* | `zero-leak-security-guard` |
| **Dịch ngược file `.exe`, `.apk`, `.asar` hoặc gói mạng `.har`** | *"Áp dụng quy trình REA Summary-First và 4 tầng bằng chứng để phân tích ứng dụng/file X xem tính năng Y hoạt động như thế nào."* | `reverse-engineering-and-rea` |
| **Điều khiển app Windows / Web** | *"Dùng chiến lược Screenshot-first và Hybrid Browser để mở trình duyệt, lấy nội dung trang X và tổng hợp báo cáo."* | `desktop-browser-operator` |
| **Kiểm thử hộp đen MCP/API hoặc bắt "Test Xanh Giả"** | *"Áp dụng quy trình Black-box QA 6 nhóm (A–F) và kiểm toán Suspicious Green Tests để kiểm tra công cụ/bộ test này."* | `mcp-blackbox-qa-tester` |
| **Sửa bug cực khó hoặc Audit bảo mật** | *"Áp dụng chế độ Siege (Judge-Worker-Evidence Ledger) và Adversarial Verifier để tìm nguyên nhân gốc rễ và phản biện bản vá của lỗi này."* | `adversarial-verifier-siege` |
| **Thiết kế Web / Dashboard đẹp, không bị "mùi AI"** | *"Thiết kế giao diện trang X theo quy trình 2 pha Anti-Slop hoặc xuất báo cáo thành 1 file HTML Playground tương tác tự chứa."* | `distinctive-ui-and-playground` |
| **Đóng gói quy trình thành Skill mới hoặc thiết kế MCP** | *"Đóng gói quy trình vừa làm thành Skill 3 tầng hoặc thiết kế bộ MCP theo 6 hình thái chuẩn của REA."* | `universal-skill-mcp-architect` |
