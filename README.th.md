# cc-devenv-doctor

คำสั่งเดียว พาเครื่อง Windows หรือ Mac เปล่า ๆ ไปถึง [Claude Code](https://claude.com/claude-code) ที่ใช้งานได้จริง — พ่วงปลั๊กอินที่คอยตรวจสุขภาพเครื่องให้ต่อหลังจากนั้น

> English version: [README.md](./README.md)

## ทำไมถึงมีของชิ้นนี้

เรื่องเริ่มที่ห้องสอบวิชา **AI Agentic Engineering for IT**

เนื้อหาไม่ใช่ส่วนที่ยาก ส่วนที่ยากคือการทำให้เครื่องของทุกคนพร้อมใช้งาน ลง git ต่อด้วย Node ต่อด้วย VS Code ต่อด้วย Docker ต่อด้วย Claude Code CLI — ทีละคำสั่ง บน Windows กับ Mac พร้อมกัน เจอ PATH ไม่รีเฟรช เจอ installer หยุดถามคำถามที่ไม่มีใครในห้องตอบได้ เวลาหลายชั่วโมงหมดไปกับตรงนั้น ทั้งที่ควรได้ใช้กับเนื้อหาจริง

ที่น่าหงุดหงิดคือมันไม่มีอะไรน่าสนใจเลย คำสั่งชุดเดิม ลำดับเดิม พังแบบเดิมทุกครั้ง — ซึ่งเป็นปัญหาประเภทที่ควรแก้ครั้งเดียวแล้วแจกออกไป จะได้ไม่มีใครต้องเสียเวลาทั้งเช้ากับมันอีก

สรุป: สคริปต์หนึ่งตัวต่อหนึ่ง OS กับปลั๊กอินที่บอกได้ว่าอะไรยังพังอยู่

## ลงอะไรให้บ้าง

- **Git**
- **Node.js** (LTS)
- **Bun** — claude-mem ต้องใช้ แต่ตัวมันไม่ลงให้
- **Claude Code CLI** (ผ่าน native installer ตัวทางการ)
- **[devenv-doctor](./devenv-doctor)** — ปลั๊กอินที่มาพร้อม repo นี้ พิมพ์ `/devenv-doctor:environment-doctor` ใน Claude Code แล้วมันจะไล่เช็คของจริง แล้วบอกว่าต้องแก้อะไรบ้าง
- **Docker Desktop** รวมถึงติดตั้ง WSL2 ให้บน Windows ถ้ายังไม่มี
- **VS Code** + extension สองตัว: [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) กับ Docker
- **[mattpocock-skills](https://github.com/mattpocock/skills)** — ปลั๊กอินบน marketplace ทางการของ Anthropic (grilling, TDD, code review และอื่น ๆ)

## สองอย่างสุดท้ายเป็นแค่ตัวอย่าง ไม่ใช่สาระ

VS Code extensions กับ mattpocock-skills ใส่มาเพื่อเป็น **ตัวอย่างว่าเครื่องที่พร้อมใช้งานหน้าตาเป็นยังไง** ไม่ได้แปลว่านี่คือของที่เหมาะกับทุกคน สาระจริง ๆ ของสคริปต์คือ พอฐานทำงานได้แล้ว การเพิ่ม skill หรือ extension ตัวถัดไปเหลือแค่บรรทัดเดียว แทนที่จะเป็นทั้งบ่าย ที่ใส่ไว้ก็เพื่อให้เห็นรูปร่างของเรื่องนี้ และเพื่อให้คนที่เพิ่งเริ่มมีของที่ใช้ได้ตั้งแต่วันแรก

เปลี่ยนเป็นของที่คุณใช้จริงได้เลย นั่นคือวิธี fork ที่ตั้งใจไว้

### เรื่อง VS Code โดยเฉพาะ

พูดตรง ๆ: **ผมไม่ได้เปิด VS Code เลยตั้งแต่ตุลาคม 2025** ไม่เปิดเลยสักครั้ง

แต่ก็ยังใส่ไว้ในสคริปต์ และคิดว่าถูกแล้ว — ถ้าคุณเพิ่งเริ่ม editor ที่มี Claude Code extension ติดมาแล้วคือทางที่สั้นที่สุดที่จะได้ของที่ใช้งานได้ และเป็นจุดลงจอดที่เป็นมิตรกว่า terminal เปล่า ๆ เยอะ

แต่อย่าอ่านว่านี่คือคำแนะนำจากคนที่ใช้มันทุกวัน ถ้ามี editor ที่ชอบอยู่แล้ว ลบบล็อกนั้นออกจากสคริปต์ได้เลย ไม่มีอะไรอื่นพึ่งพามัน

## เริ่มใช้งาน

### ถ้ามี git อยู่แล้ว

**Windows (PowerShell):**
```powershell
git clone https://github.com/killernay/cc-devenv-doctor.git
cd cc-devenv-doctor
powershell -ExecutionPolicy Bypass -File setup.ps1
```

**macOS:**
```bash
git clone https://github.com/killernay/cc-devenv-doctor.git
cd cc-devenv-doctor
bash setup.sh
```

### ถ้ายังไม่มี git

1. ไปที่ [github.com/killernay/cc-devenv-doctor](https://github.com/killernay/cc-devenv-doctor) กด **Code → Download ZIP** แล้วแตกไฟล์
2. เปิด terminal / PowerShell ในโฟลเดอร์ที่แตกออกมา — GitHub ตั้งชื่อให้ว่า **`cc-devenv-doctor-main`** ไม่ใช่ `cc-devenv-doctor`
3. รันสคริปต์เดิมตามด้านบน — `bash setup.sh` (macOS) หรือ `powershell -ExecutionPolicy Bypass -File setup.ps1` (Windows) สคริปต์จะลง git ให้ระหว่างทางเอง

สคริปต์เป็น idempotent รันซ้ำได้ ปลอดภัย มันจะข้ามของที่ลงไว้แล้ว และสรุปผลผ่าน/ไม่ผ่านให้ตอนจบ

### คำถามเดียวที่สคริปต์จะถาม

ช่วงต้นมันจะถามว่า **จะเปิดใช้ปลั๊กอินที่ระดับไหน**:

- **user** (แนะนำ) — เขียนลง `~/.claude/settings.json` ปลั๊กอินใช้ได้ทุกโปรเจกต์บนเครื่องนี้
- **project** — เขียน `.claude/settings.json` ลงในโฟลเดอร์ที่รันสคริปต์ ปลั๊กอินจะโหลดเฉพาะตอนอยู่ใน*โฟลเดอร์นั้น*

กด Enter ผ่านไปเลยจะได้ `user` เลือก `project` เฉพาะตอนที่ตั้งใจจะผูกปลั๊กอินกับโปรเจกต์เดียวจริง ๆ — และถ้ารันสคริปต์จากโฟลเดอร์ดาวน์โหลด `project` จะแปลว่า "ใช้ได้แค่ในโฟลเดอร์ดาวน์โหลด" ซึ่งแทบจะแน่นอนว่าไม่ใช่สิ่งที่ต้องการ

ถ้าไม่อยากให้ถาม กำหนดไปตั้งแต่แรก:

```bash
PLUGIN_SCOPE=user bash setup.sh
```
```powershell
$env:PLUGIN_SCOPE="user"; powershell -ExecutionPolicy Bypass -File setup.ps1
```

### เอาแค่ปลั๊กอิน devenv-doctor ไม่เอา bootstrap ทั้งชุด

มี Claude Code **กับ git** อยู่แล้ว อยากได้แค่ปลั๊กอิน ไม่ต้อง clone เอง ไม่ต้องโหลด ZIP ไม่ต้อง `cd` ไปไหน:

```
claude plugin marketplace add killernay/cc-devenv-doctor
claude plugin install devenv-doctor
```

แล้วเปิด `claude` พิมพ์ `/devenv-doctor:environment-doctor` จบ — ติดตั้งเป็น scope **user** คือใช้ได้ทุกโปรเจกต์บนเครื่องนี้ ถ้าอยากจำกัดแค่โฟลเดอร์เดียว ดู[คำถามเรื่อง scope](#คำถามเดียวที่สคริปต์จะถาม)

`marketplace add` เรียก `git clone` ข้างใน เครื่องต้องมี git ไม่งั้นขึ้น *"Failed to clone marketplace repository"* — ถ้ายังไม่มี git ให้รันสคริปต์ setup ด้านบนแทน มันลง git ให้ด้วย

ถ้าตอนติดตั้งมีเซสชัน Claude Code เปิดค้างอยู่ ให้ `/reload-plugins` ก่อน เพราะปลั๊กอินถูกสแกนตอนเปิดเซสชัน เซสชันที่เปิดใหม่หลังติดตั้งไม่ต้องทำ

### ถอนออกยังไง

```
claude plugin uninstall devenv-doctor@ngernthongdee
claude plugin marketplace remove ngernthongdee
```

`uninstall` ต้องใส่ id เต็ม `name@marketplace` ตามที่ `claude plugin list` แสดง และการลบ marketplace เป็นอีกขั้นแยกต่างหาก ไม่งั้น marketplace จะยังค้างอยู่ทั้งที่ไม่มีปลั๊กอินเหลือแล้ว

## อะไรที่ยังต้องใช้คนทำ

สามอย่างที่เขียนสคริปต์แทนไม่ได้จริง ๆ เพราะต้องให้คุณยืนยันตัวตนเองหรือตอบคำถามเอง:

1. **Login** — รัน `claude` หลังสคริปต์จบ มันจะเปิดเบราว์เซอร์ให้ล็อกอิน
2. **`npx claude-mem install`** — ให้ Claude Code มีความจำข้ามเซสชัน เป็น installer แบบโต้ตอบที่ถามสองสามคำถาม (จะใช้ provider ไหน ฯลฯ) จัดอยู่กลุ่มเดียวกับ extension ด้านบน คือตัวอย่างของสิ่งที่ต่อเพิ่มได้เมื่อฐานพร้อมแล้ว มันต้องใช้ Bun ซึ่งสคริปต์ลงให้แล้ว — ถ้าในสรุปขึ้น `Bun` เป็น `[!]` ให้แก้ตรงนั้นก่อน ไม่งั้น claude-mem จะลงผ่านสวย ๆ แล้วเงียบไม่ทำอะไรเลย
3. **รีสตาร์ทเครื่อง** ถ้าสคริปต์ต้องลง WSL2 ให้บน Windows (Docker Desktop ต้องใช้) — สคริปต์จะบอกชัดเจนถ้าเข้าเคสนี้

ถ้าขั้น devenv-doctor หรือ mattpocock-skills ขึ้น `[!]` ในสรุป ส่วนใหญ่เป็นเพราะยังไม่ได้ล็อกอินตอนสคริปต์รันถึงตรงนั้น ล็อกอินแล้วรันสคริปต์ซ้ำ มันจะข้ามทุกอย่างที่สำเร็จไปแล้ว

## devenv-doctor

ติดตั้งแล้วรัน **`/devenv-doctor:environment-doctor`** ในเซสชัน Claude Code ไหนก็ได้ — หรือจะเล่าปัญหาไปตรง ๆ ("setup พัง", "ทำไม docker ไม่ทำงาน") ก็เรียก skill ตัวเดียวกัน มันจะไล่เช็คของจริง — git, Node, VS Code extensions, Docker, claude-mem, ปลั๊กอินที่ลงไว้ — แล้วให้คำสั่งแก้ที่ตรงกับ OS ของคุณ ทุกการเช็คเป็น read-only และ pre-approved ไว้แล้ว เลยไม่มีเด้งถามสิทธิ์ระหว่างทาง

ถ้าเรียกแล้วไม่ตอบ แปลว่าเซสชันเปิดอยู่ก่อนที่ปลั๊กอินจะถูกติดตั้ง — รัน `/reload-plugins` หรือเปิดเซสชันใหม่

### หน้าตาผลลัพธ์

บนเครื่องที่รันสคริปต์ไปแล้ว รายงานจะออกมาประมาณนี้:

| Check | Status | Detail |
|---|---|---|
| git | ✅ | 2.54.0 |
| Node.js | ✅ | v22.22.2 (≥20) |
| Bun | ✅ | 1.3.13 |
| VS Code | ✅ | 1.131.0 |
| Docker | ✅ | 29.6.2, engine running |
| Claude Code CLI | ✅ | 2.1.222 |
| claude-mem | ✅ | installed, plugin v13.13.1 enabled |
| devenv-doctor | ✅ | 0.2.0, scope user, enabled |
| marketplace `ngernthongdee` | ✅ | Directory `/Users/you/Downloads/cc-devenv-doctor-main` |
| anthropic.claude-code | ✅ | |
| ms-azuretools.vscode-docker | ✅ | |

อันไหนไม่ขึ้น ✅ มันจะบอกคำสั่งแก้มาให้ตรงกับ OS ของคุณ

นอกจากนี้มันยังรู้จักความพังสองแบบที่หน้าตาเหมือนสำเร็จ: ปลั๊กอินที่ลงผิด scope กับปลั๊กอินที่ไม่เคย add marketplace เลย

## ทำไมไม่ใช้ `npm install -g @anthropic-ai/claude-code` เฉย ๆ

คำสั่งนั้นลงแค่ตัว Claude Code แล้วปล่อยให้คุณไปลง git, Node, VS Code, Docker เองทีละอย่าง แล้วไปงมไวยากรณ์ของปลั๊กอินเอง ซึ่งนั่นแหละคือจุดที่เวลาทั้งเช้าหายไป

## สำหรับคนที่จะแก้โค้ดต่อ

macOS มาพร้อม **bash 3.2** และเครื่องเปล่าไม่มีเวอร์ชันใหม่กว่านั้นใน `PATH` — ซึ่งคือเครื่องที่ `setup.sh` เล็งไว้พอดี ต้องเขียนให้ compatible กับ bash 3.2: ห้ามใช้ negative array index (`${arr[-1]}`), ห้าม associative array และห้าม expand `"${arr[@]}"` โดยไม่เช็คความยาวก่อนตอนเปิด `set -u` ไว้ — `bash -n` จับไม่ได้สักข้อ มันพังตอน runtime เท่านั้น

ฝั่ง PowerShell คำสั่ง native (`winget`, `claude`, `code`) ไม่โยน terminating error เพราะฉะนั้น `try`/`catch` ครอบไว้ก็ไม่เคยทำงาน ให้เช็ค `$LASTEXITCODE` แทน

ตรวจ manifest ก่อน push:

```bash
claude plugin validate . --strict
claude plugin validate ./devenv-doctor --strict
```

## ร่วมพัฒนา

เปิดรับ issue และ PR — โดยเฉพาะอะไรก็ตามที่ตัดขั้นตอนที่มือใหม่ต้องทำเองด้วยมือออกไปได้

## License

MIT — ดู [LICENSE](./LICENSE) เอาไปใช้ fork ต่อ เปลี่ยนลิสต์ extension เป็นของตัวเองได้เลย
