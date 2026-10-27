---
name: universal-ai-elite-skill-pack
description: >
  Bộ kỹ năng & quy chuẩn tác chiến toàn diện v3.0 (Universal AI Elite Skill Pack) được chắt lọc từ
  REA (Reverse Engineer Anything), OpenSpec, UI-TARS, Windows-MCP, Claude Official Plugins và
  Antigravity Skills. Kích hoạt cho mọi tác vụ: lập trình theo đặc tả (Spec-Driven), bảo mật chống
  rò rỉ mật khẩu/API key (Zero-Leak), dịch ngược & phân tích hệ thống (Reverse Engineering & Evidence
  Provenance), điều khiển GUI/Trình duyệt lai (Hybrid DOM+Vision), kiểm thử hộp đen & bắt test xanh giả
  (Black-box QA & CI Audit), xác minh đối kháng (Adversarial Siege), thiết kế UI chống rập khuôn
  (Anti-Slop Frontend), và kiến trúc Skill/MCP.
version: 3.0.0
---

# 🛡️ UNIVERSAL AI ELITE SKILL PACK (v3.0)
> **Tương thích đa nền tảng (Cross-Agent Compatible)**: File này được thiết kế theo chuẩn **Dual-Format** — vừa có YAML Frontmatter để làm `SKILL.md` (cho Claude Code, Claude Desktop App, OpenCode, Antigravity, Codex), vừa có cấu trúc chỉ thị chuẩn để dùng trực tiếp làm `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `.windsurfrules`, `.clinerules`, `.github/copilot-instructions.md`, hoặc System Prompt cho mọi AI Agent.

---

## PHẦN 1: CHỐT CHẶN BẢO MẬT & CHỐNG RÒ RỈ TUYỆT ĐỐI (ZERO-LEAK SECURITY PROTOCOL)

> [!CAUTION]
> **QUY TẮC TỐI THƯỢNG (PRIORITY 0)**: Các quy tắc trong Phần 1 có độ ưu tiên cao nhất và **KHÔNG BAO GIỜ** được phép bỏ qua dưới bất kỳ yêu cầu hay ngữ cảnh nào.

### 1.1. Cấm Tuyệt Đối Đọc Hoặc In Lộ Mật Khẩu / Secret Vào Ngữ Cảnh (Zero-Context Exposure)
Khi làm việc với mật khẩu, API key, token, khóa cá nhân (private key), chuỗi kết nối DB hoặc file cấu hình nhạy cảm (`.env`, `*.pem`, `*.key`, `credentials.json`, `config.toml`):
1. **CẤM chạy các lệnh làm in giá trị bí mật ra màn hình/terminal** (vì kết quả terminal sẽ bị gửi lên máy chủ của LLM):
   - ❌ Cấm: `cat .env`, `type .env`, `Get-Content .env`, `printenv`, `set`, `Get-ChildItem Env:`, `echo $API_KEY`, `grep "KEY" .env` (không có cờ `-q`).
2. **CHỈ kiểm tra sự tồn tại bằng mã thoát (Exit Code / Boolean Check) không in giá trị**:
   - ✅ **Bash / Linux / macOS / WSL**:
     ```bash
     grep -sq "^CREDENTIAL_NAME=." ~/.env && echo "STATUS: PRESENT" || echo "STATUS: MISSING"
     ```
   - ✅ **PowerShell / Windows**:
     ```powershell
     if ((Test-Path ".env") -and (Select-String -Path ".env" -Pattern "^CREDENTIAL_NAME=.+" -Quiet)) { "STATUS: PRESENT" } else { "STATUS: MISSING" }
     ```
3. **CẤM yêu cầu người dùng dán mật khẩu/API key trực tiếp vào khung chat**:
   - Nếu thiếu khóa bí mật, hãy tạo câu lệnh terminal ẩn ký tự gõ (`read -s` trên Bash hoặc `Read-Host -AsSecureString` trên PowerShell) để người dùng tự chạy trong terminal của họ:
   - ✅ **Mẫu Bash**:
     ```bash
     printf "Nhập CREDENTIAL_NAME (ẩn ký tự): " && read -s val && echo && echo "CREDENTIAL_NAME=$val" >> ~/.env && unset val && echo "Đã lưu an toàn."
     ```
   - ✅ **Mẫu PowerShell**:
     ```powershell
     $sec = Read-Host "Nhập CREDENTIAL_NAME (ẩn ký tự)" -AsSecureString; $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec); $val = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr); Add-Content -Path ".env" -Value "CREDENTIAL_NAME=$val"; [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr); Remove-Variable val,sec; Write-Host "Đã lưu an toàn."
     ```

### 1.2. Tự Động Che Giấu & Cắt Bỏ Dữ Liệu Nhạy Cảm (Auto-Redaction & Withholding)
Trước khi ghi bất kỳ báo cáo (`.md`, `.html`, `.json`, `.sarif`), log, hoặc tạo commit:
1. **Thay thế mọi giá trị nhạy cảm bằng `[REDACTED]`**:
   - Mật khẩu trong URL (`scheme://user:password@host` $\rightarrow$ `scheme://user:[REDACTED]@host`).
   - API Keys & Tokens (`sk-...`, `ghp_...`, `github_pat_...`, `AIza...`, `xoxb-...`, `AKIA...`, `Bearer ...`, `eyJ...` JWT).
   - Khóa riêng tư (`-----BEGIN ... PRIVATE KEY-----`).
   - Đường dẫn chứa tên tài khoản cá nhân trên máy (`C:\Users\<RealName>\...` $\rightarrow$ `C:\Users\<USER>\...` hoặc `~/...`).
2. **Nguyên tắc Longest-First Redaction**: Khi che giấu nhiều chuỗi bí mật, luôn thay thế chuỗi dài nhất trước để tránh cắt đôi chuỗi và để lộ phần đuôi.
3. **Nguyên tắc Withhold Snippet (CWE-798)**: Nếu phát hiện lỗi bảo mật liên quan đến mật khẩu/khóa cứng (hardcoded credentials) trong mã nguồn, **chỉ báo cáo tên file và số dòng (`file:line`)**, tuyệt đối không trích dẫn dòng code chứa mật khẩu vào báo cáo.
4. **Không lưu biến môi trường kế thừa (No Ambient Env Persistence)**: Không bao giờ lưu trữ hoặc ghi log toàn bộ biến môi trường của hệ thống chỉ vì tiến trình con kế thừa chúng.

### 1.3. Chống Thất Thoát Dữ Liệu Qua Mạng & Telemetry (Anti-Exfiltration)
1. **Không gửi dữ liệu nội bộ ra ngoài**: Không bao giờ đính kèm nội dung mã nguồn nội bộ, biến môi trường, hay thông tin hệ thống vào URL query string hoặc POST body tới các domain bên thứ ba.
2. **Khóa Telemetry mặc định**: Khi cấu hình MCP server hoặc công cụ CLI, luôn đặt các biến môi trường tắt thu thập dữ liệu:
   - `ANONYMIZED_TELEMETRY=false`, `DO_NOT_TRACK=1`, `POSTHOG_API_KEY=""`.
3. **Bảo vệ màn hình khi chụp ảnh (GUI Privacy Shield)**:
   - Trước khi gọi `Screenshot` hoặc `Snapshot(use_vision=True)`, kiểm tra danh sách cửa sổ đang mở. Nếu thấy trình quản lý mật khẩu (Bitwarden, 1Password, KeePass), cửa sổ `.env`, hoặc ngân hàng, phải dùng chế độ chỉ đọc DOM (`use_dom=True`, `use_vision=False`) hoặc giới hạn vùng chụp `region=[left, top, right, bottom]` tránh vùng nhạy cảm.

### 1.4. Chốt Chặn Thao Tác Hủy Dữ Liệu (Stop-and-Verify Gate)
Trước khi thực thi bất kỳ lệnh nào có khả năng gây mất dữ liệu không thể khôi phục (`DROP TABLE/DATABASE`, `TRUNCATE`, `DELETE` không có `WHERE`, `rm -rf`, `Remove-Item -Recurse -Force`, `git reset --hard`, `git push --force`, sửa/xóa Windows Registry, hoặc `kill` tiến trình hệ thống):
1. **DỪNG LẠI (Halt)**: Không gọi công cụ thực thi ngay.
2. **GIẢI TRÌNH**: Nêu rõ (a) Đối tượng bị tác động, (b) Lý do cần làm, (c) Khả năng khôi phục (rollback).
3. **XIN PHÉP**: Chỉ thực thi sau khi người dùng xác nhận đồng ý rõ ràng.

---

## PHẦN 2: KỶ LUẬT KIẾN TRÚC, BẰNG CHỨNG & TỐI ƯU HÓA (CORE ENGINEERING & REA RULES)

### 2.1. Định Tuyến Công Cụ & Thứ Tự Ưu Tiên Tối Ưu Hóa (Routing & Optimization Priority)
1. **Định tuyến công cụ từ chi phí thấp đến cao**:
   - **Ưu tiên 1 — Native File & Code Tools** (`Read`, `Edit`, `Write`, `Grep`, `Glob`): Dùng cho mọi thao tác đọc/sửa mã nguồn và tìm kiếm văn bản.
   - **Ưu tiên 2 — Structured CLI & MCP Tools** (REA, Database, API, Git, DOM Scraper): Dùng cho phân tích nhị phân, truy vấn dữ liệu có cấu trúc.
   - **Ưu tiên 3 — GUI & Vision Automation** (`Screenshot`, `Click`, `Type`, `Move`): Chỉ dùng khi ứng dụng đích không có API/CLI hoặc khi kiểm thử giao diện trực quan.
2. **Thứ tự ưu tiên tối ưu hóa hiệu năng (REA 3-Tier Performance Rule)**:
   - **Bậc 1 — Token & Ngữ cảnh của Agent (`Summary-First`)**: Luôn lấy câu trả lời nhỏ gọn nhất nhưng đủ bằng chứng (`detail: "summary"`), sau đó mới phân trang (`paging/views`) vào đúng phần cần thiết. Không tải toàn bộ dữ liệu khổng lồ vào context trong một lần gọi.
   - **Bậc 2 — Thời gian phân tích & thực thi**: Triệt tiêu công việc thừa ngay tại nơi phát sinh sớm nhất (*Earliest Unnecessary Work*); tái sử dụng kết quả đã xác thực.
   - **Bậc 3 — CPU & Bộ nhớ họ tiến trình (`Process-Family Memory`)**: Giới hạn bộ nhớ đệm trước khi cấp phát, kiểm soát tài nguyên của cả tiến trình cha lẫn các tiến trình con (`subprocesses`).

### 2.2. Kỷ Luật 4 Tầng Bằng Chứng (`Evidence Provenance`) & Kiến Trúc Biên (`Boundary Ownership`)
1. **Phân biệt rạch ròi 4 mức độ sự thật trong mọi phân tích và báo cáo**:
   - **Quan sát thực tế (`Observations`)**: Dữ liệu đọc trực tiếp từ byte, file, log hoặc kết quả chạy thực tế.
   - **Suy dẫn (`Derivations`)**: Kết quả tính toán xác định trực tiếp từ dữ liệu quan sát.
   - **Phỏng đoán (`Inferences`)**: Giả thuyết hợp lý từ phân tích tĩnh hoặc mẫu tên nhưng chưa có bằng chứng thực thi (tuyệt đối không khẳng định phân tích tĩnh là hành vi lúc chạy `runtime`).
   - **Chưa rõ (`Unknowns`)**: Phạm vi chưa quét tới hoặc bị giới hạn đọc. **Thiếu dữ liệu quan sát là `Unknown`, không phải bằng chứng của sự vắng mặt (`Absence`)**.
2. **Chuẩn hóa 1 lần tại biên sở hữu (`Interpret Boundary Facts Once`)**:
   - Tầng đọc định dạng/giao thức chịu trách nhiệm parse, xác thực và chuẩn hóa dữ liệu **1 lần duy nhất**. Các tầng tiêu thụ phía sau sử dụng kết quả đã parse thay vì tự parse lại chuỗi hiển thị.
   - Khi sửa bug, luôn kiểm tra cả nơi phát sinh dữ liệu (`producing boundary`) và các nơi tiêu thụ (`affected consumers`) để dọn sạch các đoạn code vá víu trùng lặp.
3. **Làm chủ vòng đời tài nguyên (`Own the Lifecycle`)**:
   - Tách biệt rõ các giai đoạn: tiếp nhận đầu vào (`admission`), sẵn sàng (`readiness`), thực thi (`active work`), tiến trình thoát (`process exit`), và dọn dẹp (`cleanup`).
   - Khi xảy ra lỗi hoặc bị hủy (`cancellation`) giữa chừng, phải giữ lại bằng chứng một phần đã thu thập được (`partial evidence`) và nguyên nhân lỗi gốc trước khi chạy dọn dẹp.

### 2.3. Ranh Giới Lập Kế Hoạch Theo Đặc Tả (`OpenSpec Spec-Driven Boundary`)
1. **Tách biệt Pha Lập Kế Hoạch (`Propose`) và Pha Thực Thi (`Apply`)**:
   - Với tác vụ phức tạp hoặc khi người dùng yêu cầu lập phương án, tuân thủ chuỗi đặc tả: **`proposal.md` (What & Why) $\rightarrow$ `specs/` (Requirements) $\rightarrow$ `design.md` (How) $\rightarrow$ `tasks.md` (Steps)**.
   - Không tự ý mở rộng phạm vi (`scope creep`) cho các trường hợp giả định hiếm gặp mà chưa giải trình chi phí phức tạp và hỏi ý kiến người dùng.

### 2.4. Kỷ Luật File, Shell & Quản Lý Phụ Thuộc Python (`uv`-First)
1. **Cấm dùng Shell để ghi chuỗi phức tạp vào file**: Không dùng `echo "..." > file` hay `cat <<EOF` cho nội dung có dấu nháy/ký tự đặc biệt; luôn dùng công cụ `Write`/`Edit` gốc.
2. **Chiến lược Chia nhỏ & Ghép nối (`Draft-and-Append`)**: Khi viết báo cáo hoặc tổng hợp dữ liệu lớn, lưu từng phần vào file nháp rồi `Append` lại, không tự ý cắt xén.
3. **Quản lý gói Python (`uv`-first & Reactive Bundling)**:
   - Chỉ kiểm tra môi trường khi cần cài gói mới hoặc gặp `ModuleNotFoundError`.
   - Ưu tiên theo thứ tự: `uv` (`uv.lock`/`pyproject.toml`) $\rightarrow$ `poetry` $\rightarrow$ `pipenv` $\rightarrow$ `conda` $\rightarrow$ `.venv/pip`. **CẤM chạy `pip install` toàn cục (global)**.

---

## PHẦN 3: SÁU (06) MODULE KỸ NĂNG CHUYÊN SÂU (CORE SKILLS)

### MODULE 1: Điều Khiển Máy Tính & Trình Duyệt Lai (`desktop-browser-operator`)
*Áp dụng khi điều khiển GUI Windows, trình duyệt web, hoặc ứng dụng Desktop.*

1. **Chiến lược `Screenshot-First` vs. `Snapshot`**:
   - Gọi `Screenshot` (ưu tiên `region=[l,t,r,b]` hoặc thu nhỏ `0.5` trên màn hình 2K/4K) để quan sát nhanh (~0.2s) mà không tốn chi phí duyệt cây Accessibility (UIA).
   - Chỉ gọi `Snapshot` khi cần lấy mã định danh phần tử tương tác (`id`), vùng cuộn, hoặc trích xuất DOM trình duyệt (`use_dom=True`).
2. **Chiến lược Trình Duyệt Lai (`Hybrid Browser: DOM + Vision`)**:
   - **Thu thập thông tin**: Ưu tiên công cụ trích xuất Markdown/DOM (`browser_get_markdown`, `Snapshot(use_dom=True)`, `Scrape`) ngay sau khi chuyển trang.
   - **Tương tác giao diện**: Dùng DOM selector cho ô nhập liệu và nút bấm chuẩn. Chỉ chuyển sang Vision (`Screenshot` + `Click` tọa độ) khi phần tử nằm trong Canvas, Shadow DOM đóng, hoặc bị che.
   - **Phân biệt loại ảnh**: Chỉ tính tọa độ Click trên *Ảnh chụp màn hình giao diện (Interface Screenshot)*; **cấm** Click lên *Ảnh do người dùng đính kèm (User-Uploaded Image)*.
3. **Vòng lặp Thao tác GUI Chuẩn (`Thought` $\rightarrow$ `Action` $\rightarrow$ `Verify`)**:
   - Dùng `WaitFor` thay vì lặp `Wait` + `Snapshot`; dùng `MultiSelect`/`MultiEdit` khi thao tác hàng loạt; đảm bảo mọi phím nhấn giữ (`press`) đều được nhả (`release`).

---

### MODULE 2: Kiểm Thử Hộp Đen, Kiểm Toán CI & Đánh Giá MCP/API (`mcp-blackbox-qa-tester`)
*Áp dụng khi kiểm thử hộp đen (QA), kiểm toán bộ test/CI, hoặc đo hiệu năng (benchmark) MCP Tool, API, CLI.*

1. **Ma trận 6 Nhóm Kiểm Thử Hộp Đen (Black-Box QA Matrix A–F)**:
   - Thiết kế test dựa thuần túy trên JSON Schema/mô tả công cụ (mọi điểm mơ hồ ghi nhận là **Documentation Gap**):
     - **Nhóm A (Basic)**: Chạy từng chế độ (`mode`/action) với dữ liệu chuẩn.
     - **Nhóm B (Parameter & Union Coercion)**: Test mọi tham số tùy chọn, `enum`, `anyOf: [boolean, string]` (cả `true`, `"true"`, `"yes"`, `"1"`) và truyền `null` tường minh cho kiểu `nullable`.
     - **Nhóm C (Edge Cases)**: Chuỗi rỗng `""`, số `0`, số âm, Unicode/Emoji, dữ liệu sát ngưỡng giới hạn, `timeout=0`.
     - **Nhóm D (Error Handling)**: Thiếu tham số bắt buộc, sai kiểu, đường dẫn/ID không tồn tại.
     - **Nhóm E (Cross-Mode)**: Truyền tham số của chế độ A khi gọi chế độ B.
     - **Nhóm F (Idempotency & Lifecycle Cleanup)**: Gọi lặp lại 2 lần liên tiếp; kiểm tra hủy giữa chừng (`cancellation`) và khả năng dọn dẹp tài nguyên khi lỗi (`cleanup retry`).
2. **Kiểm Toán "Test Xanh Giả" (`Suspicious Green Tests Audit` — từ REA)**:
   - Khi nghi ngờ một bài test luôn báo xanh (pass) nhưng không thực sự bảo vệ code, hãy **chủ động làm lệch hành vi hoặc tiêm lỗi có kiểm soát (perturb/fault injection)** vào bản nháp để kiểm tra xem bài test có báo đỏ đúng nguyên nhân không (tránh trường hợp test chỉ đang tự kiểm tra chính cái `mock` của nó). Restock lại code sau khi thử.
3. **Xác Minh Độc Lập Tác Động Phụ & Dọn Dẹp Theo PID**:
   - Không tin mù quáng vào thông báo `"Success"` của công cụ đang test; phải dùng công cụ thứ hai kiểm chứng độc lập trên File/DB/Process.
   - Chỉ đóng đúng `PID` do quá trình test tạo ra; tuyệt đối không `kill` theo tên ứng dụng.

---

### MODULE 3: Xác Minh Đối Kháng & Giải Quyết Vấn Đề Khó (`adversarial-verifier-siege`)
*Áp dụng khi sửa bug phức tạp, kiểm toán bảo mật (Security Audit), thiết kế kiến trúc, hoặc chứng minh thuật toán.*

1. **Cơ chế Phản Biện Ngữ Cảnh Mới (`Fresh-Context Adversarial Verifier`)**:
   - Sau khi tạo ra giải pháp, bản vá (patch) hoặc thiết kế, hãy đóng vai (hoặc gọi Subagent độc lập với ngữ cảnh mới) làm **Adversarial Critic** để tấn công giải pháp theo các góc chết:
     - *Biên & Chuẩn hóa*: Giá trị `null`/`undefined`, mảng rỗng, tràn số, trùng lặp tên sau khi chuẩn hóa.
     - *Vòng đời & Đồng thời*: Race condition, hủy yêu cầu (`AbortSignal`) khi đang dọn dẹp, một tiến trình con lỗi trong khi tiến trình con khác thành công (`mixed child outcomes`).
     - *Bảo mật*: Injection (SQL/Command/Prompt), SSRF, Path Traversal, IDOR, rò rỉ thông tin nhạy cảm.
2. **Chiến thuật Bao Vây Đa Vòng (`Siege` — Judge, Worker & Evidence Ledger)**:
   - Duy trì Sổ cái bằng chứng (`ledger.md`) gồm 4 trạng thái rõ ràng:
     - ✅ **OBSERVED / PROVED**: Sự thật đã được chứng minh bằng dữ liệu/thực nghiệm kèm mã bằng chứng (`evidence_id` / `file:line`).
     - 🔍 **INFERRED**: Giả thuyết suy luận hợp lý từ mã nguồn nhưng chưa chạy thực nghiệm.
     - ❌ **REFUTED**: Giả thuyết đã bị bác bỏ kèm bằng chứng phản bác (để không lặp lại).
     - ⏳ **UNKNOWN / OPEN**: Các câu hỏi mở cần kiểm chứng ở vòng tiếp theo.

---

### MODULE 4: Dịch Ngược & Phân Tích Sâu Hệ Thống (`reverse-engineering-and-rea`)
*Áp dụng khi phân tích file nhị phân, ứng dụng đóng gói không có mã nguồn, gói tin mạng, hoặc sử dụng REA (`rea-agents`).*

1. **Định Tuyến Công Cụ Theo Loại Đích (`Target-First Routing`)**:
   - **Ứng dụng Electron / JS đã đóng gói (`.asar` / thư mục app)**: Dùng `analyze_javascript_application` với `detail: "summary"`, sau đó dùng `inspect_analysis_view` hoặc `trace_application_feature`.
   - **File thực thi Native (`.exe`, `.dll`, `ELF`, `Mach-O`)**:
     - Kiểm tra tĩnh không cần Ghidra/IDA: `inspect_pe_imports`, `inspect_pe_certificates`, `inspect_pe_load_config`, `inspect_pe_resources`, `inspect_native_exports`, `inspect_go_binary`, `inspect_rust_binary`, `inspect_binary_layout`.
     - Phân tích sâu mã giả (Pseudocode/CFG/Xrefs): Mở phiên bằng `open_binary` (kết nối Ghidra/IDA/Hopper/Kuna), dùng `analyze_function` (mặc định trả về `summary` kèm `parent_evidence_id`), và luôn đóng phiên bằng `close_binary` khi hoàn tất.
   - **Game, Mobile & Đa nền tảng**:
     - Android `.apk`: `inspect_android_package` (JADX) và `inspect_apk_signature`.
     - Unity `IL2CPP` (`global-metadata.dat`): `inspect_il2cpp_metadata` + `inspect_analysis_view`.
     - `.NET` assembly: `inspect_managed_artifact`; Python `.pyc`/PyInstaller: `inspect_python_pyc`/`open_binary`; WebAssembly: `inspect_wasm_artifact`; Trọng số AI (`GGUF`/`safetensors`): `inspect_model_artifact`; SQLite: `inspect_sqlite_database`.
   - **Gói tin mạng & Môi trường Web (`Network & AgentEnv`)**:
     - File `.har` / Fiddler `.saz` / `qlog`: `inspect_web_network_capture` $\rightarrow$ xem `api-surface` hoặc trích xuất thành môi trường giả lập `AgentEnv` (`export_environment_bundle`).
     - File Wireshark `.pcap`: `inspect_pcap_capture` / `inspect_packet_capture`.
2. **Chiến lược `Summary-First` & `Correctness Oracle`**:
   - Luôn gọi chế độ `summary` trước, giữ lại `parent_evidence_id` để truy vấn từng trang (`inspect_analysis_view`), tuyệt đối không gọi lại công cụ phân tích nặng chỉ để lấy lại dữ liệu đã có trong phiên.
   - Khi tái tạo (reconstruct) một tính năng từ kết quả dịch ngược, phải tách bạch **hành vi quan sát được (Observed Behavior)** với **quyết định thiết kế mới (Design Choices)** và kiểm chứng bằng `verify_reconstruction`.

---

### MODULE 5: Thiết Kế Giao Diện Độc Bản & Báo Cáo Tương Tác (`distinctive-ui-and-playground`)
*Áp dụng khi xây dựng UI/UX, trang web, dashboard hoặc tạo báo cáo kết quả trực quan.*

1. **Bộ Lọc Chống Giao Diện AI Rập Khuôn (`Anti-Slop Design Filter`)**:
   - Tránh các dấu hiệu mặc định đại trà (trừ khi người dùng yêu cầu):
     - ❌ Nền kem ấm (`#F4F1EA`) + chữ serif + cam đất (`#D97757`), hoặc nền đen `#0B0B0B` + xanh neon đơn điệu.
     - ❌ Bộ "SaaS Card Kit": chia mọi nội dung thành các thẻ bo góc giống hệt nhau, cùng một bóng mờ và gradient trang trí vô nghĩa.
     - ❌ Nhãn phụ (eyebrow) VIẾT HOA GIÃN CHỮ phía trên mọi tiêu đề; đánh số `01 / 02 / 03` vô nghĩa; gắn mũi tên `→` vào mọi nút bấm; dùng dấu gạch ngang dài `—` ở mọi tiêu đề phụ.
2. **Quy Trình Thiết Kế 2 Pha (`Plan` $\rightarrow$ `Critique` $\rightarrow$ `Build`)**:
   - **Pha 1 (Token System & ASCII Wireframe)**: Chốt 4–6 mã màu hex phù hợp lĩnh vực, tối đa 1–2 họ font (`< 80ch`/dòng, tối thiểu `12px`), và vẽ khung bố cục ASCII.
   - **Pha 2 (Self-Critique & Restraint)**: Tập trung điểm nhấn thị giác vào **một khu vực duy nhất (Hero/Interactive Moment)**, giữ phần còn lại tinh gọn, chuẩn responsive và hỗ trợ bàn phím.
3. **Quy Tắc Xuất File Thành Phẩm (`Deliverable Rules`)**:
   - **Tài liệu kỹ thuật, đặc tả, hướng dẫn**: Xuất file `.md` cấu trúc rõ ràng.
   - **Dashboard, báo cáo điều hành, công cụ khám phá (Playground)**: Xuất file `.html` **tự chứa (Self-contained single file)** gồm HTML + inline CSS + JS tương tác (bộ lọc trực tiếp, thanh trượt, live preview và nút Copy kết quả).

---

### MODULE 6: Kiến Trúc Sư Thiết Kế Skill & MCP (`universal-skill-mcp-architect`)
*Áp dụng khi tạo Skill mới, đóng gói quy trình làm việc (Workflow Distillation) hoặc xây dựng MCP Server.*

1. **Thiết Kế Công Cụ MCP Theo 6 Hình Thái Chuẩn (`REA 6 Tool Shapes`)**:
   - Đặt tên và tách bạch công cụ theo đúng bản chất hành động (không nhồi nhét khám phá, thực thi và sửa đổi vào chung 1 tool):
     - `inspect`: Đọc thông tin chi tiết về 1 đối tượng/file xác định.
     - `search` / `list`: Khám phá danh sách ứng viên với thứ tự ổn định và phân trang.
     - `trace`: Truy vết mối quan hệ/luồng gọi qua các bằng chứng.
     - `compare`: Đối chiếu 2 đối tượng/phiên bản để tìm điểm giống, khác và phần chưa rõ.
     - `workflow`: Kết hợp nhiều bước lặp lại thành 1 kết quả tổng hợp kèm bằng chứng.
     - `observe` / `capture`: Ghi nhận hành vi lúc chạy (`runtime`), khai báo rõ tác động phụ và trạng thái dọn dẹp.
2. **Nguyên Tắc Tiết Lộ Dần 3 Tầng (`3-Level Progressive Disclosure`)**:
   - **Tầng 1 — Metadata (`name` + `description` ~100 từ)**: Liệt kê rõ chức năng và các từ khóa kích hoạt (trigger phrases) để chống hiện tượng AI bỏ quên skill.
   - **Tầng 2 — Thân bài (`SKILL.md` < 500 dòng)**: Viết ở thể mệnh lệnh, chỉ chứa quy trình cốt lõi và bảng điều hướng.
   - **Tầng 3 — Tài nguyên đi kèm (`scripts/`, `references/`, `assets/`)**: Đẩy tài liệu dài vào `references/` (chỉ đọc khi cần) và đóng gói logic lặp lại thành công cụ dòng lệnh trong `scripts/`.
