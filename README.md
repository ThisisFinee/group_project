
# Group Project
Авторы: Анатолий Иванашко, Екатерина Жакова, Сергей Романов, Федотов Илья

## Подготовка к работе: 
1. Клонировать репозиторий:
```bash
git clone git@git-intern.digitalleague.ru:zh_ekaterina/group-project.git
```

2. Перейти в папку `group-project` 

3. Выполнить: 
```bash
docker compose run --rm booking_server bash 
rails db:create 
rails db:migrate
```

4. Выполнить:
```bash
docker compose run --rm gate_server bash 
rails db:create 
rails db:migrate
```

5. Выполнить:
```bash
docker compose run --rm user_server bash 
rails db:create 
rails db:migrate
```

6. Выполнить:
```bash
docker compose run --rm ticket_server bash 
rails db:create 
rails db:migrate 
rails db:seed
```
 
## Работа приложения: 
1. Бронирование:
```bash
curl -X POST "http://localhost:3000/booking?category=vip&date=2024-01-01"
```

Параметры: 
+ `categoty` - `vip` или `fan`
+ `date` - `2024-01-01` (в сидах при создании билетов создается эта дата) 

Возвращает `booking_number, price`
 
2. Отмена брони 
```bash
curl -X DELETE "http://localhost:3000/booking/cancel?booking_number=<Вернувшийся номер брони при бронировании>"
```
Возвращает статус `200`
 
3. Покупка
```bash
curl -X GET "http://localhost:3002/purchase?booking_number=813934001&name=alex&age=20&document_number=441991&document_type=passport"
```
Параметры:
+ `booking_number` - Вернувшийся номер брони при бронировании
+ `name` - имя пользователя 
+ `age` - возраст пользователя (integer) 
+ `document_number` - номер документа (string) 
+ `document_type` - тип документа: `passport`, `driver_license` или `birth_certificate` 
Возвращает номер билета и цену внутри json 
 
4. Вход/выход
```bash
curl -X POST "http://localhost:3006/pass?ticket_number=158&category=vip&user_action=in&current_date=2024-01-01"
```
Параметры:
+ `ticket_number` - номер билета, который возвращается после покупки 
+ `category` - (`vip` или `fan`) зона, куда пользователь хочет зайти (должна совпадать с зоной на билете) 
+ `user_action` - (`in` или `out`) хочет ли пользователь войти или выйти 
+ `current_date` - текущая дата, должна совпадать с датой на билете (`2024-01-01` на всех билетах по умолчанию). 
Возвращает: `status: 200, result: true/false` (`true`, если пользователь успешно совершил действие, `false`, если не успешно) 
 
5. Вывод журнала входа/выхода
```bash
curl -X GET "http://localhost:3006/in_out_events?ticket_number=123&status=true&user_name=Ivan&user_action=in&date_time=2024-01-01"
```
Основной запрос (без фильтрации): `curl -X GET "http://localhost:3006/in_out_events`

Остальные параметры указываются при желании фильтровать по одному или нескольким полям.

Параметры:
+ `ticket_number` - номер билета 
+ `status` - (true или false) успешно ли вошел/вышел пользователь 
+ `user_name` - имя пользователя 
+ `user_action` - (in или out) какое действие совершает пользователь (вход или выход) 
+ `date_time` - дата мероприятия 
Возвращает массив записей из бд 
 
6. Блокировка билета
```bash
curl -X PUT "http://localhost:3001/tickets/block?ticket_number=158&document_number=441991"
``` 
Параметры:
+ `ticket_number` - номер билета, который вернулся после покупки 
+ `document_number` - номер документа, указанный при покупке 
Возвращает статус `200` и сообщение `"Status updated"`

## Проверка баз данных в консоли:
1. Таблица бронирования
`Booking.allBooking.find_by(booking_number: <номер бронирования>)`

2. Таблица билетов
`Ticket.allTicket.find_by(ticket_number: <номер билета>)`

3. Таблица пользователей
`User.allUser.find_by(ticket_number: <номер купленного билета>)`

4. Таблица журнала входа/выхода
`InOutEvent.all`