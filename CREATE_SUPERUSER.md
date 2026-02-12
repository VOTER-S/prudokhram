# 🔐 Как создать суперпользователя Django

## Для локальной разработки:

### Вариант 1: Через командную строку

1. **Откройте терминал/командную строку**

2. **Перейдите в папку проекта:**
```bash
cd prudok
```

3. **Активируйте виртуальное окружение (если используете):**

Windows:
```bash
myenv\Scripts\activate
```

Linux/Mac:
```bash
source myenv/bin/activate
```

4. **Выполните команду создания суперпользователя:**
```bash
python manage.py createsuperuser
```

5. **Введите данные:**
```
Username: admin             # Имя пользователя (например: admin)
Email address: (пропустить) # Можно нажать Enter
Password: ********          # Пароль (не будет виден при вводе)
Password (again): ********  # Повторите пароль
```

6. **Готово!** Суперпользователь создан.

---

### Вариант 2: Программно (в коде)

Создайте файл `create_superuser.py` в корне проекта:

```python
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'prudok.settings')
django.setup()

from django.contrib.auth import get_user_model

User = get_user_model()

if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser(
        username='admin',
        email='admin@example.com',
        password='admin123'  # Измените на свой пароль!
    )
    print("Суперпользователь создан!")
else:
    print("Суперпользователь уже существует")
```

Запустите:
```bash
python create_superuser.py
```

---

## Для Render (после деплоя):

### Способ 1: Через Render Shell (рекомендуется)

1. **Перейдите на https://dashboard.render.com/**

2. **Откройте ваш Web Service** (prudok)

3. **Нажмите на вкладку "Shell"** (справа в меню)

4. **В открывшемся терминале выполните:**
```bash
cd prudok
python manage.py createsuperuser
```

5. **Введите данные:**
```
Username: admin
Email address: (нажмите Enter)
Password: ********
Password (again): ********
```

6. **Готово!** Можете войти в админку.

---

### Способ 2: Автоматически при деплое

Добавьте в конец файла `build.sh`:

```bash
# В конец build.sh добавьте:
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@example.com', 'your_password')" | python manage.py shell
```

**⚠️ Внимание:** Это небезопасно! Пароль будет виден в коде. Используйте только для тестирования.

---

## Вход в админ-панель:

### Локально:
1. Запустите сервер: `python manage.py runserver`
2. Откройте: http://127.0.0.1:8000/admin/
3. Введите username и password
4. Готово!

### На Render:
1. Откройте: https://ваш-домен.onrender.com/admin/
2. Введите username и password
3. Готово!

---

## Если забыли пароль:

### Изменить пароль существующего пользователя:

```bash
python manage.py changepassword admin
```

Или через shell:

```bash
python manage.py shell
```

Затем в shell:
```python
from django.contrib.auth import get_user_model
User = get_user_model()
user = User.objects.get(username='admin')
user.set_password('новый_пароль')
user.save()
print("Пароль изменен!")
exit()
```

---

## Проверка существующих суперпользователей:

```bash
python manage.py shell
```

В shell:
```python
from django.contrib.auth import get_user_model
User = get_user_model()

# Показать всех суперпользователей
superusers = User.objects.filter(is_superuser=True)
for user in superusers:
    print(f"Username: {user.username}, Email: {user.email}")
```

---

## Удалить суперпользователя:

```bash
python manage.py shell
```

В shell:
```python
from django.contrib.auth import get_user_model
User = get_user_model()
User.objects.get(username='admin').delete()
print("Пользователь удален!")
```

---

## Типичные ошибки:

### "Password is too similar to username"
Используйте более сложный пароль, непохожий на username.

### "This password is too short"
Минимум 8 символов.

### "This password is too common"
Не используйте простые пароли типа "password123".

### "Password is entirely numeric"
Добавьте буквы в пароль.

---

## Рекомендации:

✅ **Для локальной разработки:**
- Username: `admin`
- Password: `admin123` (простой пароль OK)

✅ **Для продакшена (Render):**
- Username: `admin` или что-то уникальное
- Password: **сложный пароль!** (минимум 12 символов, буквы, цифры, символы)
- Пример: `Admin@2026!SecurePass`

❌ **НЕ используйте:**
- admin/admin
- admin/password
- admin/123456
- root/root

---

## Быстрая команда (одной строкой):

### Для локальной разработки:
```bash
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', '', 'admin123')" | python manage.py shell
```

### Проверка:
```bash
python manage.py shell -c "from django.contrib.auth import get_user_model; print(get_user_model().objects.filter(is_superuser=True).values_list('username', flat=True))"
```

---

## После создания суперпользователя:

1. ✅ Войдите в админку: `/admin/`
2. ✅ Добавьте новости через админку
3. ✅ Добавьте расписание
4. ✅ Загрузите изображения
5. ✅ Проверьте, что все работает

---

*Готово! Теперь вы можете управлять сайтом через админ-панель Django!* 🎉
