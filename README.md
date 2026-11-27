# KIXDEV — Việt hóa giao diện 🇻🇳

Bản dịch tiếng Việt không chính thức dành cho giao diện KIXDEV trong **99 Nights in the Forest** (Roblox).

![Version](https://img.shields.io/badge/version-V1.4-blue)
![Dictionary](https://img.shields.io/badge/translation-3497%20keys-brightgreen)

## Phiên bản V1.4

| Nội dung | Kết quả |
| --- | --- |
| Tổng số key trong `vi.json` | 3.497 |
| Key bổ sung từ V1.3 | 2.051 |
| Key khớp với bản tham chiếu Indonesia | 3.334/3.334 (100%) |
| Key riêng của bản Việt | 163 |
| Key còn thiếu so với bản tham chiếu | 0 |
| Lỗi biến giữ chỗ trong các key mới | 0 |

Bản cập nhật giữ nguyên 1.446 mục dịch trước đó, bổ sung tên vật phẩm, danh sách lựa chọn, mô tả chức năng, nhiệm vụ, sự kiện, thông báo và các chuỗi có biến động như `{number1}`, `{number2}`, `{player1}`.

**Lưu ý:** 100% là độ bao phủ key so với file Indonesia tại thời điểm đối chiếu, không phải tỷ lệ Việt hóa thực tế trong game. Một số tên riêng được giữ nguyên; một số thông báo động có thể vẫn hiện tiếng Anh do giới hạn của bộ dịch.

## Hướng dẫn sử dụng trên Executor

Chỉ sử dụng trong môi trường bạn có quyền kiểm thử. Script này chỉ bổ sung bản dịch giao diện, không cài đặt KIXDEV gốc.

1. Mở Roblox và vào game 99 Nights in the Forest.
2. Mở giao diện KIXDEV đã có sẵn trong phiên kiểm thử.
3. Mở Executor tương thích với môi trường của bạn và chọn ô nhập script.
4. Sao chép đoạn mã Việt hóa bên dưới, dán vào Executor rồi nhấn **Execute**.
5. Kiểm tra giao diện KIXDEV. Các mục có bản dịch sẽ được hiển thị bằng tiếng Việt; bộ dịch tiếp tục theo dõi các mục giao diện mới.

### Script Việt hóa

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/renosang/Kixdev-translation/main/translator.lua"))()
```

Script tải từ điển trực tiếp từ GitHub. Khi có bản dịch mới, chạy lại cùng đoạn mã để nạp từ điển mới; không cần thay đổi đường dẫn.

### Kiểm tra log

Khi tải từ điển thành công, console sẽ hiển thị thông báo tương tự:

```text
[KIXDEV-VI] Dictionary ready: 3497
[KIXDEV-VI] Attached: <tên ScreenGui>
```

Số lượng key có thể thay đổi ở các bản cập nhật sau.

### Dừng bộ dịch

```lua
local env = type(getgenv) == "function" and getgenv() or _G
if type(env.KIXDEV_VI_Stop) == "function" then
    env.KIXDEV_VI_Stop()
end
```

Lệnh này ngừng theo dõi và cập nhật bản dịch. Nó không tự khôi phục các chuỗi đã dịch; để trở về giao diện gốc, hãy mở lại giao diện từ đầu hoặc vào lại game.

## Khắc phục lỗi

| Hiện tượng | Cách kiểm tra |
| --- | --- |
| `Cannot load dictionary` | Kiểm tra kết nối mạng và khả năng truy cập file raw trên GitHub. |
| Có log `Dictionary ready` nhưng không có `Attached` | Kiểm tra cửa sổ KIXDEV đã mở và bộ dịch có nhận diện được giao diện hay không. |
| Một số mục vẫn là tiếng Anh | Kiểm tra key có khớp chính xác với nội dung hiển thị; các chuỗi động hoặc giao diện mới có thể chưa được hỗ trợ. |
| Executor báo lỗi `HttpGet` hoặc `loadstring` | Môi trường hiện tại có thể không hỗ trợ các API mà script cần. Không có cam kết tương thích với mọi Executor. |

## Cấu trúc dự án

- [vi.json](./vi.json): Từ điển tiếng Anh – tiếng Việt.
- [translator.lua](./translator.lua): Bộ dịch giao diện, xử lý nhãn, nút, placeholder và một số trạng thái động.
- [indonesian.json tham chiếu](https://github.com/Kixdev/99NITF/blob/main/translate/indonesian.json): Nguồn đối chiếu key.

## Báo lỗi và đóng góp

Nếu còn nội dung tiếng Anh hoặc bản dịch chưa chính xác, vui lòng gửi ảnh chụp màn hình, tên tab, chuỗi gốc và bản dịch đề xuất qua [GitHub Issues](https://github.com/renosang/Kixdev-translation/issues).

## Lưu ý an toàn

Đây là dự án Việt hóa độc lập, không liên kết chính thức với KIXDEV hoặc Roblox. Chỉ tải mã từ nguồn đáng tin cậy, đọc mã trước khi chạy và không cung cấp mật khẩu hoặc thông tin tài khoản cho Executor. Việc dùng công cụ bên thứ ba có thể vi phạm điều khoản Roblox hoặc dẫn đến rủi ro tài khoản. Bản dịch chưa được kiểm thử trên mọi thiết bị và Executor.
