# 🕌 القرآن الكريم

تطبيق مصحف إلكتروني شامل مبني بـ Flutter

![Build APK](https://github.com/YOUR_USERNAME/quran_app/actions/workflows/build_apk.yml/badge.svg)

## المميزات

- 📖 **القرآن الكريم** — ١١٤ سورة كاملة بخط حفص الأصيل مع علامات نهاية الآيات ۝
- 📖 **تمرير بالصفحات** — تصفح بالإصبح يميناً ويساراً كالمصحف الحقيقي
- 🔤 **تحكم في الخط** — تكبير وتصغير حجم الخط
- 💾 **يعمل بدون إنترنت** — السور تُحمَّل وتُحفظ تلقائياً
- 🤲 **أذكار وأدعية** — صباح، مساء، نوم، صلاة، سفر وأكثر
- 📿 **سبحة إلكترونية** — مع أذكار مختلفة وحفظ الإجمالي
- 🔍 **بحث** — في السور والأذكار

## رفع المشروع على GitHub

```bash
# 1. إنشاء مستودع جديد على github.com
# 2. ثم نفّذ هذه الأوامر:

git init
git add .
git commit -m "🕌 Initial commit - القرآن الكريم app"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

## بناء الـ APK تلقائياً

بعد رفع الكود على GitHub:

1. اذهب لـ **Actions** في الـ repository
2. ستجد workflow اسمه **Build Quran APK** يعمل تلقائياً
3. بعد انتهاء البناء (5-8 دقائق) اضغط على الـ workflow
4. ستجد **Artifacts** في الأسفل → اضغط لتحميل الـ APK

## إنشاء Release

لإنشاء release رسمي:
```bash
git tag v1.0.0
git push origin v1.0.0
```

## الخط القرآني

الخط يُحمَّل تلقائياً أثناء بناء الـ APK عبر GitHub Actions.

للتطوير المحلي، ضع ملف الخط في:
```
assets/fonts/hafs.ttf
```

## المتطلبات المحلية

- Flutter SDK 3.24+
- Android Studio أو VS Code
- JDK 17

```bash
flutter pub get
flutter run
```
