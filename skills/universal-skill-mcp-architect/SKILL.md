---
name: universal-skill-mcp-architect
description: >
  Kỹ năng thiết kế, tối ưu hóa Skill mới theo kiến trúc 3 tầng, đóng gói quy trình làm việc
  (Workflow Distillation) và xây dựng MCP Server theo 6 hình thái công cụ chuẩn của REA. Kích hoạt
  khi người dùng muốn tạo skill mới, biến quy trình vừa làm thành skill tái sử dụng, hoặc phát triển
  MCP server/tool.
version: 3.0.0
---

# Universal Skill & MCP Architect

## 1. Quy Trình 5 Bước Khảo Sát Trước Khi Viết (`Brainstorming Protocol`)
Trước khi viết một Skill hoặc MCP Server mới, xác định rõ 5 yếu tố:
1. **Câu hỏi của người phân tích & Đầu vào/Đầu ra**: Công cụ giải quyết câu hỏi thực tế nào, nhận dữ liệu gì và trả về bằng chứng định dạng nào?
2. **Độ linh hoạt & Xử lý lỗi**: Bước nào bắt buộc làm đúng tuyệt đối, bước nào cho phép tự thử phương án thay thế khi gặp lỗi?
3. **Tái sử dụng**: Có Skill hay MCP Server nào sẵn có giải quyết được một phần quy trình không? (Mở rộng công cụ sẵn có nếu cùng mục đích thay vì tạo công cụ trùng lặp).
4. **Quyết định Code CLI vs. Chỉ thị văn bản**: Nếu quy trình có bước gọi API, xử lý dữ liệu hoặc lặp lại logic cố định $\rightarrow$ bắt buộc tách thành CLI script trong `scripts/`.
5. **Kiểm chứng (`Evaluation`)**: Kiểm tra cả trường hợp gọi trực tiếp, gọi tổng quát và trường hợp âm tính (negative test).

## 2. Thiết Kế Công Cụ MCP Theo 6 Hình Thái Chuẩn (`REA 6 Tool Shapes`)
Khi thiết kế các tool cho MCP Server, đặt tên và phân tách theo 6 hình thái chuẩn (tránh nhồi nhét khám phá, thực thi và sửa đổi vào chung 1 tool):
1. **`inspect`**: Trả về thông tin chi tiết, vị trí và bằng chứng về 1 đối tượng/tài nguyên xác định.
2. **`search` / `list`**: Khám phá danh sách ứng viên với thứ tự ổn định và hỗ trợ phân trang (`pagination`).
3. **`trace`**: Truy vết các mối quan hệ có kiểu (`typed edges`) qua nhiều nguồn bằng chứng.
4. **`compare`**: Đối chiếu 2 đối tượng/phiên bản để chỉ ra phần tương đồng, phần thay đổi và phần chưa đủ dữ liệu.
5. **`workflow`**: Kết hợp một chuỗi thao tác lặp lại thành 1 kết quả tổng hợp kèm bằng chứng chi tiết.
6. **`observe` / `capture`**: Ghi nhận hành vi lúc chạy (`runtime`), khai báo trung thực tác động lên tiến trình/file/mạng và trạng thái dọn dẹp (`cleanup`).

## 3. Kiến Trúc Tiết Lộ Dần 3 Tầng (`3-Level Progressive Disclosure`)
```text
skill-name/
├── SKILL.md          # Tầng 1 (YAML Frontmatter ~100 từ) + Tầng 2 (Quy trình cốt lõi <500 dòng)
├── scripts/          # Tầng 3: Code CLI thực thi trực tiếp (tiết kiệm token context)
├── references/       # Tầng 3: Tài liệu API, schema chi tiết (chỉ đọc khi cần)
└── assets/           # Tầng 3: File mẫu, template HTML, icon dùng cho đầu ra
```
- **Mẹo viết `description` chống bỏ quên (`Anti-Undertriggering`)**: Viết mô tả chủ động, nêu rõ cả chức năng lẫn danh sách các từ khóa/tình huống thực tế mà người dùng thường nói để AI kích hoạt chính xác.
