---
name: reverse-engineering-and-rea
description: >
  Kỹ năng Dịch ngược (Reverse Engineering), phân tích sâu tệp nhị phân (.exe, PE, ELF, Mach-O),
  ứng dụng đóng gói (Electron .asar, Android .apk, Unity IL2CPP, .NET, PyInstaller, WASM, GGUF),
  gói tin mạng (.har, .saz, .pcap), và tối ưu hóa phân tích theo chuẩn REA (rea-agents). Kích hoạt
  khi người dùng yêu cầu mổ xẻ phần mềm không có mã nguồn, dịch ngược tính năng, phân tích file
  binary/network capture, hoặc làm việc với REA.
version: 3.0.0
---

# Reverse Engineering & Deep System Analysis (`REA` Workflow)

## 1. Kỷ Luật 4 Tầng Bằng Chứng (`Evidence Provenance`)
Mọi kết luận khi dịch ngược hoặc phân tích hệ thống phải phân biệt rõ 4 mức độ sự thật:
- **Quan sát thực tế (`Observations`)**: Dữ liệu đọc trực tiếp từ byte, header, bảng import/export, hoặc kết quả bắt gói tin/chạy thực tế.
- **Suy dẫn (`Derivations`)**: Kết quả tính toán xác định trực tiếp từ dữ liệu quan sát (ví dụ: SHA-256, địa chỉ RVA sang file offset).
- **Phỏng đoán (`Inferences`)**: Giả thuyết hợp lý từ mã giả (pseudocode), chuỗi ký tự hoặc tên hàm nhưng chưa chạy thực nghiệm. **Tuyệt đối không khẳng định kết quả phân tích tĩnh là hành vi lúc chạy (`runtime`)**.
- **Chưa rõ (`Unknowns`)**: Phạm vi chưa quét tới, hàm gọi gián tiếp (indirect calls) hoặc bị cắt bớt. **Thiếu dữ liệu là `Unknown`, không phải bằng chứng của sự không tồn tại**.

## 2. Định Tuyến Công Cụ Theo Loại Đích (`Target-First Routing`)
Chọn công cụ đầu tiên dựa trên đúng loại tệp/đích mà người dùng cung cấp:
1. **Ứng dụng Electron / JavaScript đã đóng gói (`.asar` hoặc thư mục giải nén)**:
   - Gọi `analyze_javascript_application` với `"detail": "summary"` (hoặc CLI: `npx -y rea-agents@latest analyze-javascript-application <path> --json`).
   - Sau đó dùng `inspect_analysis_view` với `parent_evidence_id` hoặc `trace_application_feature` để truy vết tính năng cụ thể.
   - Trước khi gắn debugger vào tiến trình Electron chính, kiểm tra fuse bằng `inspect_electron_fuses`.
2. **Tệp Thực Thi Native (`.exe`, `.dll`, `ELF`, `Mach-O`)**:
   - **Kiểm tra tĩnh nhanh (Không cần cài Ghidra/IDA)**:
     - Bảng Import / Delay-load & Imphash: `inspect_pe_imports`
     - Chữ ký số Authenticode / PKCS#7: `inspect_pe_certificates`
     - Cấu hình bảo mật PE (CFG, SafeSEH, TLS callbacks): `inspect_pe_load_config`
     - Tài nguyên & Icon PE: `inspect_pe_resources`; Bảng Export PE/ELF: `inspect_native_exports`
     - Binary viết bằng Go / Rust: `inspect_go_binary`, `inspect_rust_binary`
     - Bố cục ELF & kiểm tra tĩnh: `inspect_binary_layout`; ELF Notes: `inspect_elf_notes`
   - **Phân tích sâu mã giả & đồ thị luồng (Cần Ghidra / IDA / Hopper / Kuna)**:
     - Mở phiên bằng `open_binary`, sau đó gọi `analyze_function`, tìm kiếm chuỗi/hàm, hoặc đối chiếu bằng `compare_functions`.
     - **Bắt buộc đóng phiên** bằng `close_binary` ngay khi kết thúc điều tra.
3. **Game, Mobile & Đa Nền Tảng**:
   - **Android `.apk`**: `inspect_android_package` (cần JADX + JDK) để xem class/method/manifest; `inspect_apk_signature` để kiểm tra chữ ký v1–v3.1.
   - **Unity `IL2CPP` (`global-metadata.dat`)**: `inspect_il2cpp_metadata` kết hợp `inspect_analysis_view` (hỗ trợ đối chiếu kèm `binary_path`).
   - **`.NET` Managed Assembly**: `inspect_managed_artifact`.
   - **Python `.pyc` & PyInstaller**: `inspect_python_pyc` hoặc `open_binary` + `inspect_artifact` để đọc `CArchive`.
   - **WebAssembly (`.wasm`)**: `inspect_wasm_artifact`; **EVM Bytecode**: `inspect_evm_interface`.
   - **Trọng số AI (`GGUF` / `safetensors`)**: `inspect_model_artifact`; **Cơ sở dữ liệu SQLite**: `inspect_sqlite_database`.
4. **Gói Tin Mạng & Môi Trường Giả Lập Web (`Network & AgentEnv`)**:
   - **File `.har`, Fiddler `.saz`, `mitmproxy`, `qlog`**: Dùng `inspect_web_network_capture`, sau đó dùng `inspect_analysis_view` với `kind: "api-surface"` để gom nhóm các API endpoint, hoặc `export_environment_bundle` để dựng môi trường giả lập `AgentEnv`.
   - **File Wireshark `.pcap`**: Dùng `inspect_pcap_capture` (tóm tắt DNS, TLS SNI, giao thức, HTTP) hoặc `inspect_packet_capture`.

## 3. Chiến Lược `Summary-First` & Sổ Cái Điều Tra (`Finding Ledger`)
1. **Luôn làm việc theo nguyên tắc `Summary-First`**:
   - Với mọi tệp tin hoặc ứng dụng chưa rõ kích thước, luôn yêu cầu `"detail": "summary"` trước.
   - Dùng `parent_evidence_id` trả về để phân trang qua `inspect_analysis_view`. Không bao giờ gọi lặp lại cùng một lệnh phân tích nặng chỉ để đọc lại dữ liệu đã lưu trong phiên.
2. **Sổ Cái Điều Tra Đa Bước (`Staged Investigation Ledger`)**:
   - Chuyển yêu cầu của người dùng thành danh sách câu hỏi kiểm tra (Checklist).
   - Ghi nhận từng phát hiện kèm `evidence_id`, mức độ tin cậy (`Observed` / `Inferred` / `Unknown`), và phạm vi đã quét.
   - Khi người dùng yêu cầu viết lại một tính năng tương tự cho dự án của họ, tách bạch rõ **Hành vi quan sát được từ bản gốc** và **Lựa chọn thiết kế mới**, sau đó dùng `verify_reconstruction` để đối chiếu.

