# 雨里歌單隨機點單曲 🎵

以兩張歌單照片整理的**隨機抽歌網站**。只有「隨機抽一首」模式；可管理歌單與抽歌紀錄。

## A. 放到 GitHub Pages（不需要安裝任何程式）

1. 登入 https://github.com ，右上角 `+` → **New repository**。
2. Repository name 填 `yuli-song-random`，選 **Public**，按 **Create repository**。
3. 在倉庫頁面選 **Add file → Upload files**，將此資料夾內的 `index.html`、`songs.json`、`歌曲清單.txt`、`supabase_setup.sql`、`.nojekyll`、`README.md` **直接上傳到倉庫根目錄**，按 **Commit changes**。注意不要把整個 ZIP 上傳當成唯一檔案；`.nojekyll` 是隱藏檔，可省略。
4. 開啟倉庫 **Settings → Pages**。
5. **Build and deployment → Source** 選 **Deploy from a branch**；Branch 選 `main`、Folder 選 `/(root)`，按 **Save**。
6. 公開網站網址通常是 `https://你的GitHub帳號.github.io/yuli-song-random/`，可在 Settings → Pages 找到確切網址。

完成以上步驟後，任何裝置能打開同一網址使用網站，但**尚未啟用跨裝置的歌單同步**。在雲端設定完成前，不同裝置的修改會各自留在自己的瀏覽器。

## B. 共用同一份歌單（Supabase）

1. 至 https://supabase.com 建立一個專案。
2. 開啟 **SQL Editor**，貼上本資料夾的 `supabase_setup.sql` 並執行一次。**警告：這份 SQL 為簡易公開協作版，允許匿名存取表中所有房間，不適合私人資料或正式需要權限管制的服務。**
3. 在 Supabase 的 **Project URL** 及 **API Keys** 複製公開的 `publishable` key（或舊版 `anon` key）。**絕對不要使用 `secret` / `service_role` key。**
4. 用 UUID 產生器產生一個隨機 UUID 作為 `roomId`（範例格式 `00000000-0000-4000-8000-000000000000`，**不能直接使用這個範例值**）。
5. 編輯 `index.html` 中的這一行：

   ```js
   const CLOUD_CONFIG={url:'',anonKey:'',roomId:''};
   ```

   把 `url` 填成 Project URL、`anonKey` 填成公開 key、`roomId` 填成你產生的 UUID。
6. 在 GitHub 倉庫打開 `index.html` → 鉛筆圖示 **Edit** → 貼上修改後內容 → **Commit changes**。GitHub Pages 重新部署後，相同網址上的使用者會讀取同一份雲端歌單。
7. 用兩個不同裝置開網址，新增一首歌，另一個裝置按「同步歌單」確認是否看得到。

**安全限制**：網站程式碼可被訪客看到。此版本沒有登入及管理員驗證，任何人都能查看、修改共享歌單；此外，SQL 政策允許匿名讀寫全部房間，不是以 UUID 當作保護。要避免外人更動資料，必須額外設計 Supabase Auth 和限制資料存取的 RLS 政策。

**同步限制**：是「開啟／按同步時抓取，以及操作後上傳」，不是即時推播；兩台裝置同時編輯可能最後寫入覆蓋先前寫入。請定期用網站的「下載備份」保留資料。

**歌名品質**：圖片文字密集，預設歌名有可能辨識錯誤，請依原圖校正。

## 繁體／简体中文切换

页面右上角可以切换「繁體中文」与「简体中文」，选择会保存在当前浏览器，不影响歌单、抽歌记录或云端同步。歌曲名称保留原始录入文字，不会自动转换。


## Song title conversion / 歌名繁簡切換

介面選擇「简体中文」時，預設歌單、抽歌結果、歌單搜尋與刪除確認，都會顯示簡體歌名；新增簡體歌名會保留原文，並與等價繁體歌名做重複檢查。OpenCC 由 jsDelivr CDN 載入（https://cdn.jsdelivr.net/npm/opencc-js@1.4.2/dist/umd/full.js），無網路時僅支援內建有限的字元轉換；若要完全離線使用應另將 OpenCC JS 檔案放入網站。
