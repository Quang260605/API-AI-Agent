---
name: desktop-browser-operator
description: >
  Kỹ năng điều khiển máy tính Windows (Windows-MCP) và tự động hóa trình duyệt lai
  (UI-TARS Hybrid Browser DOM + Vision). Sử dụng khi cần thao tác GUI, mở/điều khiển ứng dụng,
  chụp màn hình, lấy cây UIA/DOM, điền biểu mẫu web, hoặc thu thập dữ liệu trên trình duyệt.
version: 2.0.0
---

# Desktop & Hybrid Browser Operator

## 1. Chiến Lược Screenshot-First vs. Snapshot (Windows-MCP)
- **Mặc định gọi `Screenshot` trước**: Truyền `display=[0]` hoặc `region=[left, top, right, bottom]` (với `WINDOWS_MCP_SCREENSHOT_SCALE=0.5` trên màn hình độ phân giải cao) để lấy ngữ cảnh thị giác nhanh (~0.2s) mà không tốn chi phí duyệt cây Accessibility (UIA).
- **Chỉ gọi `Snapshot` khi**: Cần mã định danh phần tử tương tác (`id`), vùng cuộn, hoặc cần trích xuất DOM trình duyệt (`use_dom=True`).
- **Chống treo UIA**: Loại trừ các tiến trình Electron nặng bằng biến môi trường `WINDOWS_MCP_EXCLUDE_PROCESSES=Code.exe,Cursor.exe`.

## 2. Chiến Lược Trình Duyệt Lai (Hybrid Browser: DOM + Vision)
- **Thu thập nội dung**: Ưu tiên tuyệt đối công cụ trích xuất Markdown/DOM (`Snapshot(use_dom=True)`, `Scrape`, `browser_get_markdown`) ngay sau mỗi lần chuyển trang và trước khi rời trang.
- **Tương tác phần tử**:
  - Dùng công cụ DOM cho ô nhập liệu, form và nút bấm chuẩn.
  - Dùng công cụ Vision (`Screenshot` + `Click`/`Move` theo tọa độ) khi gặp Canvas, custom widget hoặc phần tử phức tạp khó chọn qua DOM.
- **Phân biệt loại hình ảnh**:
  - *Interface Screenshot* (ảnh chụp màn hình/trình duyệt): Được phép tính tọa độ để Click/Scroll.
  - *User-Uploaded Image* (ảnh người dùng gửi trong chat): Chỉ phân tích nội dung, **tuyệt đối không** gọi lệnh Click lên ảnh này.

## 3. Tối Ưu Hóa Thao Tác & Vòng Lặp Chuẩn
- **Thought $\rightarrow$ Action $\rightarrow$ Verify**: Trong bước suy nghĩ, tóm tắt kế hoạch ngắn và nêu rõ hành động tiếp theo kèm phần tử mục tiêu trong 1 câu.
- **Dùng `WaitFor` thay cho `Wait`**: Chờ cửa sổ/văn bản/phần tử xuất hiện trong 1 lần gọi thay vì lặp `Wait` + `Snapshot`.
- **Gộp thao tác hàng loạt**: Dùng `MultiSelect` (chọn nhiều mục) và `MultiEdit` (điền nhiều trường) thay vì gọi nhiều lệnh `Click`/`Type` rời rạc.
- **An toàn phím & Quyền điều khiển**: Luôn giải phóng mọi phím giữ (`release`) ở cuối bước; kiểm tra `ControlStatus` và tôn trọng quyền ưu tiên chuột/phím vật lý của người dùng (`Ctrl+Alt+Shift+Backspace`).
