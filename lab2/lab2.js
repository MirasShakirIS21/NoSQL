// ==========================================
// ЗАДАНИЕ 2 и 3: Создание базы и 10 документов
// ==========================================
use medicalDB;

db.patients.drop(); // Очистка перед запуском
db.doctors.drop();

db.patients.insertMany([
  { patientId: 1, name: "Иван Иванов", age: 30, gender: "М", status: "Активен", contact: { city: "Алматы", phone: "701" }, allergies: ["Пенициллин", "Пыльца"] },
  { patientId: 2, name: "Мария Петрова", age: 25, gender: "Ж", status: "Активен", contact: { city: "Астана", phone: "702" }, allergies: ["Аспирин"] },
  { patientId: 3, name: "Алихан Смагулов", age: 45, gender: "М", status: "На лечении", contact: { city: "Алматы", phone: "703" }, allergies: [] },
  { patientId: 4, name: "Елена Сидорова", age: 19, gender: "Ж", status: "Активен", contact: { city: "Шымкент", phone: "704" }, allergies: ["Цитрус"] },
  { patientId: 5, name: "Данияр Каримов", age: 35, gender: "М", status: "Архив", contact: { city: "Алматы", phone: "705" }, allergies: ["Мёд"] },
  { patientId: 6, name: "Анна Кузнецова", age: 28, gender: "Ж", status: "Активен", contact: { city: "Астана", phone: "706" }, allergies: ["Пенициллин"] },
  { patientId: 7, name: "Берик Асанов", age: 60, gender: "М", status: "На лечении", contact: { city: "Караганда", phone: "707" }, allergies: ["Лактоза"] },
  { patientId: 8, name: "Ольга Новикова", age: 52, gender: "Ж", status: "Активен", contact: { city: "Алматы", phone: "708" }, allergies: [] },
  { patientId: 9, name: "Мурат Тлеуов", age: 23, gender: "М", status: "Активен", contact: { city: "Шымкент", phone: "709" }, allergies: ["Пыльца"] },
  { patientId: 10, name: "Ирина Волкова", age: 40, gender: "Ж", status: "На лечении", contact: { city: "Астана", phone: "710" }, allergies: ["Аспирин", "Пенициллин"] }
]);

// ==========================================
// ЗАДАНИЕ 4: Добавление массива документов
// ==========================================
db.patients.updateOne({ patientId: 1 }, { $set: { visits: [ { date: "2026-01-10", diagnosis: "ГРИПП" }, { date: "2026-02-15", diagnosis: "Отит" } ] } });
db.patients.updateOne({ patientId: 2 }, { $set: { visits: [ { date: "2026-03-01", diagnosis: "Бронхит" } ] } });
db.patients.updateMany({ visits: { $exists: false } }, { $set: { visits: [] } });

// ==========================================
// ЗАДАНИЕ 5: Запросы Dot notation
// ==========================================
print("--- Q1: Пациенты из Алматы ---");
db.patients.find({ "contact.city": "Алматы" });

print("--- Q2: Пациенты из Астаны ---");
db.patients.find({ "contact.city": "Астана" });

print("--- Q3: Из Алматы старше 30 лет ---");
db.patients.find({ "contact.city": "Алматы", age: { $gt: 30 } });

// ==========================================
// ЗАДАНИЕ 6: Работа с массивами
// ==========================================
print("--- Нашли тех, у кого аллергия на Пенициллин ---");
db.patients.find({ allergies: "Пенициллин" });

print("--- Нашли тех, у кого Аспирин И Пенициллин ($all) ---");
db.patients.find({ allergies: { $all: ["Аспирин", "Пенициллин"] } });

print("--- Добавили новую аллергию пациенту №1 ($push) ---");
db.patients.updateOne({ patientId: 1 }, { $push: { allergies: "Шоколад" } });

// ==========================================
// ЗАДАНИЕ 7: Referencing (Вторая коллекция)
// ==========================================
db.doctors.insertMany([
  { _id: 101, name: "Доктор Ахметов", special: "Терапевт" },
  { _id: 102, name: "Доктор Иванова", special: "Хирург" },
  { _id: 103, name: "Доктор Ким", special: "Аллерголог" },
  { _id: 104, name: "Доктор Смаилов", special: "Кардиолог" },
  { _id: 105, name: "Доктор Петров", special: "Невролог" }
]);

db.patients.updateOne({ patientId: 1 }, { $set: { doctorIds: [101, 103] } });

// ==========================================
// ЗАДАНИЕ 11: Повышенный уровень ($lookup)
// ==========================================
print("--- Объединение коллекций через $lookup ---");
db.patients.aggregate([
  { $match: { patientId: 1 } },
  { $lookup: {
      from: "doctors",
      localField: "doctorIds",
      foreignField: "_id",
      as: "assignedDoctors"
  }}
]);
