# คู่มือสำหรับ Claude — Content OS

ไฟล์นี้อธิบายโครงสร้างข้อมูล เพื่อให้ Claude อ่าน/อัปเดตข้อมูลแบรนด์ได้ถูกต้อง

## ตำแหน่งไฟล์
- ข้อมูลแต่ละแบรนด์: `data/brands/<brand-id>/data.json` (UTF-8, JSON)
- สำรองอัตโนมัติ: `data/backups/<brand-id>/` · แบรนด์ที่ลบแล้ว: `data/archive/`
- ตัวแอป: `app/` (ห้ามแก้ ถ้าไม่ได้ถูกสั่ง)

## กฎเวลาแก้ไฟล์
1. อ่าน `memory` ก่อนทำงานทุกครั้ง (ตัวตนแบรนด์ ลูกค้า โทนเสียง ข้อห้าม)
2. แก้เฉพาะ key ที่เกี่ยวข้อง ห้ามลบ key อื่น เขียนกลับเป็น JSON ที่ถูกต้อง (UTF-8 ไม่ต้องมี BOM)
3. หลังแก้ ตั้ง `"updatedBy": "Claude"` และ `"updatedAt"` เป็นเวลาปัจจุบันแบบ ISO เช่น `2026-10-01T06:00:00+07:00` — แอปจะรีเฟรชเองภายใน 15 วินาที
4. ทุกรายการใน array ต้องมี `id` ไม่ซ้ำ (เช่น `c` + ตัวเลข/ตัวอักษรสุ่ม)
5. วันที่ใช้รูปแบบ `YYYY-MM-DD`, เวลา `HH:MM`
6. ห้ามแต่งตัวเลขสถิติขึ้นเอง — ถ้าไม่มีข้อมูลจริง ให้ถามผู้ใช้หรือเว้นไว้
7. ถ้าเป็นแบรนด์ตัวอย่าง (`brand.sample: true`) ข้อมูลเป็นของสมมติ

## โครงสร้าง data.json
```
schema: 1
updatedAt, updatedBy
brand:      { id, name, handle, category, color, platforms[], followers, sample? }
memory:     { about, audience, voice, products, usp, dos, donts, goals, notes }   (ข้อความทั้งหมด)
report:     { date(ISO), headline, summary, actions:[{ text, done, area: content|ads|data }] }
metrics:    { daily: [{ date, followers, views, reach, likes, comments, shares, saves, dms, orders, revenue }] }  เรียงตามวันที่
posts:      [{ id, date, platform, format, title, hook, views, likes, comments, shares, saves, url }]
competitors:[{ id, handle, name, platform, followers, change(% ต่อสัปดาห์), postsPerWeek, note, url, topPost:{ title, views, date } }]
competitorHooks: [{ id, text, source(@handle), views, tag }]
trends:     [{ id, title, platform, type: หัวข้อ|เสียง|แฮชแท็ก|ฟอร์แมต|ชาเลนจ์, heat(0-100), desc, idea, date }]
hooks:      [{ id, text, category, source, used, rating(1-5), createdAt }]
content:    [{ id, title, hook, date, time, platform, format, status: idea|draft|ready|scheduled|posted, caption, notes }]
postingTimes: { slots:["07:00",...], days:["จ","อ","พ","พฤ","ศ","ส","อา"], grid: 7 แถว × จำนวน slots (คะแนน 0-100) }
ads:        { campaigns:[{ id, name, platform, objective, status: active|paused|ended, start, budget(ต่อวัน), spend, impressions, clicks, results, resultType, revenue }] }
```
- platform ใช้: `instagram`, `facebook`, `tiktok`, `youtube`, `line`, `shopee`, `other`
- format ใช้: `Video`, `Reel`, `Carousel`, `Photo`, `Story`, `Live`, `Text`, `Article`

## เพิ่มแบรนด์ใหม่
สร้างโฟลเดอร์ `data/brands/<id>/` (id เป็น a-z, 0-9, - เท่านั้น) แล้วเขียน `data.json` ตามโครงสร้างด้านบน หรือกด "เพิ่มแบรนด์" ในแอป
