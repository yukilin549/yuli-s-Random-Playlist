# 雨里歌單隨機點單曲 — 多管理員自訂帳號密碼版

## 功能
- 訪客：不用登入，只能抽歌、選擇繁簡中文與重新載入共用歌單。
- 每位管理員有**自己選擇的帳號和密碼**，登入後可以新增、刪除、批次匯入歌單。
- 帳號允許 `3–32` 位英文字母、數字和底線（例如 `yuli01`, `music_team2`）；不區分英文大小寫。
- 管理員驗證由 **Supabase Auth** 執行，寫入權限由資料庫 **RLS** 實際限制，公開 GitHub 原始碼不含任何管理員密碼。
- 初始歌單已按最新兩張圖片更新；部分圖片歌名可能需人工複核。

## 為什麼能使用「自訂帳號」而不用輸入 Email？

Supabase Auth 的密碼登入原生使用 Email，因此本版在**網站程式內自動將帳號轉成專用的內部 Email 別名**：

| 使用者輸入的帳號 | 在 Supabase Auth 建立的內部 Email |
|---|---|
| `yuli01` | `yuli01@login.yuli.invalid` |
| `music_team2` | `music_team2@login.yuli.invalid` |

使用者**只需要輸入帳號和密碼**，看不到也不需記住內部 Email。`.invalid` 為專用的非真實郵件域名，**不能收取驗證信或重設密碼信**；所以請由專案擁有者在 Supabase Dashboard **直接建立且確認使用者**、必要時由擁有者重設密碼，不要使用郵件邀請方式。這是為了免設後端的簡易管理方式。若要自行收信改密碼，建議改用真實 Email 登入或另外開發安全後端。

## 一、設定雲端資料庫

1. 開啟 https://supabase.com/dashboard 並建立一個 Project。
2. 進入 **SQL Editor**，執行檔案 `supabase_setup.sql` 的全部內容。
   - 這套 SQL 會**撤銷舊版匿名寫入 policy**。如果之前已有雲端資料，請先備份，並檢查任何自訂 policy。
3. 在 **Authentication → Providers → Email**，確保 Email/Password 登入可用。**關閉對外註冊（Signups）**，因為管理員應由專案擁有者手動建立。
4. 前往 **Authentication → Users → Add user → Create new user**（不同 Dashboard 版本字詞略有差異）。為每位管理員建立：
   - Email：`自訂帳號@login.yuli.invalid`（例如 `yuli01@login.yuli.invalid`）
   - Password：為該管理員設定的強密碼
   - **務必勾選 Auto Confirm User / Confirm Email**（無法寄信到 `.invalid` 網域）
5. 在同一畫面複製管理員的 **User UID（UUID）**。每位管理員都有不同 UID。
6. 回到 **SQL Editor**，在資料表 `song_admins` 授權對應 UID：

```sql
insert into public.song_admins (user_id) values
 ('第一位管理員真實 User UID'),
 ('第二位管理員真實 User UID')
on conflict (user_id) do nothing;
```

   新增一位管理員就新增 Auth 使用者及 UID；撤銷管理員只需：

```sql
delete from public.song_admins where user_id = '要撤銷的 User UID';
```

   這樣即使該人已登入，也不能繼續寫入共用歌單。當有人離開時，亦建議在 Authentication 禁用或刪除其帳號。

## 二、在 `index.html` 設定雲端連線

搜尋：

```js
const CLOUD_CONFIG = { url:'', anonKey:'', roomId:'' };
```

把這三個值填好：
- `url`：Supabase Project URL
- `anonKey`：**publishable key** 或舊版公開 `anon` key
- `roomId`：自行產生的一組 UUID v4；同一網站所有人使用同一個 roomId。

絕對**不要**把 Supabase `service_role` / `secret` key 或管理員密碼寫進 GitHub HTML。

## 三、部署 GitHub Pages

1. 解壓縮本 ZIP，將 `index.html`、`songs.json`、`supabase_setup.sql`、`歌曲清單.txt`、`README.md` 放到 `yukilin549/yuli-s-Random-Playlist` 根目錄並 Commit。
2. GitHub Pages 用 `main` / `/(root)`。網站網址：
   https://yukilin549.github.io/yuli-s-Random-Playlist/
3. 在右上角切換繁體／简体。訪客直接抽歌。管理員點「🔒 管理員」並輸入**自訂帳號**和密碼。
4. 第一次設定雲端資料庫後，請管理員點「匯入圖片整理歌單」把內建歌單寫入共用資料庫。
5. 用兩台裝置開網站，一台新增歌、另一台按「重新讀取歌單」驗證同步。

## 注意
- 網站沒有公開註冊或自助建立管理員的功能。**管理員帳號由 Supabase 專案擁有者建立和授權**；不是讓訪客自己取得管理權。
- 請每人使用不同強密碼，並私下安全交付，避免在群組公開。`.invalid` 帳號無法透過郵件找回密碼。
- 跨裝置歌單同步需要完成 Supabase 設定；未設定時只能抽內建的唯讀歌曲。
- 目前為整份歌單更新，管理員同時編輯時可能互相覆蓋；建議定期備份。
- 抽歌紀錄僅存在個別裝置，**不會同步到其他裝置**。
