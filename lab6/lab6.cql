
-- 1. Создание Keyspace
CREATE KEYSPACE IF NOT EXISTS lab6
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE lab6;

-- 2. Таблица для поиска заказов по клиенту (Q1, Q4, Q5)
CREATE TABLE orders_by_client (
    client_id text,
    order_date date,
    order_id text,
    total_amount decimal,
    status text,
    PRIMARY KEY ((client_id), order_date, order_id)
) WITH CLUSTERING ORDER BY (order_date DESC, order_id ASC);

-- 3. Таблица для поиска заказов по статусу (Q2)
CREATE TABLE orders_by_status (
    status text,
    order_date date,
    order_id text,
    client_id text,
    PRIMARY KEY ((status), order_date, order_id)
) WITH CLUSTERING ORDER BY (order_date DESC, order_id ASC);

-- 4. Таблица для просмотра позиций заказа (Q3)
CREATE TABLE order_items (
    order_id text,
    item_id text,
    product_name text,
    quantity int,
    PRIMARY KEY ((order_id), item_id)
);

-- ====================================================================
-- ЗАПОЛНЕНИЕ ДАННЫМИ (DML)
-- ====================================================================

INSERT INTO orders_by_client (client_id, order_date, order_id, total_amount, status) VALUES ('C1', '2026-10-01', 'O1', 1500, 'Доставлен');
INSERT INTO orders_by_client (client_id, order_date, order_id, total_amount, status) VALUES ('C1', '2026-10-05', 'O2', 3200, 'Новый');
INSERT INTO orders_by_client (client_id, order_date, order_id, total_amount, status) VALUES ('C1', '2026-10-07', 'O3', 450, 'Новый');
INSERT INTO orders_by_client (client_id, order_date, order_id, total_amount, status) VALUES ('C2', '2026-09-15', 'O4', 9900, 'Доставлен');
INSERT INTO orders_by_client (client_id, order_date, order_id, total_amount, status) VALUES ('C2', '2026-10-06', 'O5', 120, 'Новый');
INSERT INTO orders_by_client (client_id, order_date, order_id, total_amount, status) VALUES ('C3', '2026-10-02', 'O6', 5000, 'Отменен');
INSERT INTO orders_by_client (client_id, order_date, order_id, total_amount, status) VALUES ('C3', '2026-10-04', 'O7', 1300, 'Новый');

INSERT INTO orders_by_status (status, order_date, order_id, client_id) VALUES ('Доставлен', '2026-10-01', 'O1', 'C1');
INSERT INTO orders_by_status (status, order_date, order_id, client_id) VALUES ('Новый', '2026-10-05', 'O2', 'C1');
INSERT INTO orders_by_status (status, order_date, order_id, client_id) VALUES ('Новый', '2026-10-07', 'O3', 'C1');
INSERT INTO orders_by_status (status, order_date, order_id, client_id) VALUES ('Доставлен', '2026-09-15', 'O4', 'C2');
INSERT INTO orders_by_status (status, order_date, order_id, client_id) VALUES ('Новый', '2026-10-06', 'O5', 'C2');
INSERT INTO orders_by_status (status, order_date, order_id, client_id) VALUES ('Отменен', '2026-10-02', 'O6', 'C3');
INSERT INTO orders_by_status (status, order_date, order_id, client_id) VALUES ('Новый', '2026-10-04', 'O7', 'C3');

INSERT INTO order_items (order_id, item_id, product_name, quantity) VALUES ('O2', 'I1', 'Телефон', 1);
INSERT INTO order_items (order_id, item_id, product_name, quantity) VALUES ('O2', 'I2', 'Чехол', 1);
INSERT INTO order_items (order_id, item_id, product_name, quantity) VALUES ('O3', 'I3', 'Кабель', 2);
INSERT INTO order_items (order_id, item_id, product_name, quantity) VALUES ('O7', 'I4', 'Наушники', 1);
INSERT INTO order_items (order_id, item_id, product_name, quantity) VALUES ('O7', 'I5', 'Мышь', 1);
INSERT INTO order_items (order_id, item_id, product_name, quantity) VALUES ('O7', 'I6', 'Коврик', 1);

-- ====================================================================
-- ПРОВЕРКА ЗАПРОСОВ (SELECT)
-- ====================================================================

-- Q1: Все заказы клиента C1
SELECT * FROM orders_by_client WHERE client_id = 'C1';

-- Q2: Все новые заказы
SELECT * FROM orders_by_status WHERE status = 'Новый';

-- Q3: Что лежит в заказе O2
SELECT * FROM order_items WHERE order_id = 'O2';

-- Q4: Заказы клиента C1 за диапазон дат
SELECT * FROM orders_by_client WHERE client_id = 'C1' AND order_date >= '2026-10-02' AND order_date <= '2026-10-06';

-- Q5: Последние 2 заказа клиента C1
SELECT * FROM orders_by_client WHERE client_id = 'C1' LIMIT 2;

-- ====================================================================
-- ИЗМЕНЕНИЕ И УДАЛЕНИЕ (UPDATE / DELETE)
-- ====================================================================

UPDATE orders_by_client SET status = 'Доставлен' WHERE client_id = 'C1' AND order_date = '2026-10-05' AND order_id = 'O2';
DELETE FROM orders_by_client WHERE client_id = 'C3' AND order_date = '2026-10-02' AND order_id = 'O6';
```

## Шаг 3: Как запустить этот код прямо из терминала VS Code

Чтобы не копировать строки по одной вручную в интерактивную консоль `cqlsh`, можно скормить весь файл `lab6.cql` в Docker одной командой через терминал VS Code.

1. Откройте встроенный терминал в VS Code (`Ctrl + \``).
2. Убедитесь, что вы находитесь в папке, где сохранили файл `lab6.cql`.
3. Выполните команду (она прогонит весь файл внутри контейнера и выведет результаты в терминал):

```bash
docker exec -i cassandra-lab6 cqlsh < lab6.cql
```

*Примечание: Если Cassandra запущена на Windows локально без Docker, используйте:*
```bash
cqlsh -f lab6.cql
```