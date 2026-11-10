# 雨里歌單隨機點單曲 — 437 首批次更新

這次依照新上傳的 Markdown 歌曲清單完整取代舊預設歌庫（共 437 首，無完全相同重複歌名）。

## 上傳 GitHub 前，必須先處理連線金鑰

此版 index.html **刻意沒有附上你的 Supabase 公開 API Key**。請打開 GitHub 現行 index.html 找到 `CLOUD_CONFIG`，複製原有 `anonKey` 欄位的值，貼入新版 index.html 的 `PASTE_YOUR_EXISTING_PUBLISHABLE_KEY`。保留原本的 Project URL 與 Room ID。只使用 publishable/anon 公開金鑰，絕不可放 secret/service_role key 或密碼。

## 上線步驟

1. 下載原本 GitHub 的 `index.html` 備份。
2. 補上公開 API Key。
3. 將本包內 `index.html`、`songs.json` 與 `歌曲清單.txt` 上傳覆蓋 GitHub 倉庫根目錄的同名檔案，Commit changes。
4. GitHub Pages 部署 Success 後，開啟網站，按「管理員」以已授權的個人帳密登入。
5. **先點「下載歌單備份」**，再點 **「⚠ 整份取代歌單」** 並確認。這才會將 Supabase 雲端歌單更新成 437 首；單純 GitHub 部署不會修改雲端資料。
6. 其他裝置點「重新讀取歌單」即可看到新清單。

## 注意

「合併預設歌單」不會刪除舊歌曲，不能用來清除錯誤歌名。若要移除全部舊歌名並完全依照這份清單更新，請使用「整份取代歌單」。
此動作具破壞性且僅限管理員；若有其他管理員在操作，請先協調避免同時覆寫。
部分原始歌名（例如 PRRFECT）可能是原清單拼字，未擅自校正。
