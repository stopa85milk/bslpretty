﻿
Перем Токены;
Перем Исходник;
Перем ТаблицаТокенов;
Перем ТаблицаЗамен;

Процедура Открыть(Парсер, Параметры) Экспорт
	
	Токены = Парсер.Токены();
	Исходник = Парсер.Исходник();
	ТаблицаТокенов = Парсер.ТаблицаТокенов();
	КлючевыеСлова = Парсер.КлючевыеСлова();
	ТаблицаЗамен = Парсер.ТаблицаЗамен();
	
КонецПроцедуры // Открыть()

Функция Закрыть() Экспорт
	
	ОтступСтрока = Строка(Символы.Таб);
	
	ОперацииПередКоторымиНеСтавимПробел = Новый Структура();
	ОперацииПередКоторымиНеСтавимПробел.Вставить("ЛеваяКруглаяСкобка");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("ПраваяКруглаяСкобка");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("ЛеваяКвадратнаяСкобка");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("ПраваяКвадратнаяСкобка");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("ЗнакВопроса");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("Запятая");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("Точка");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("Двоеточие");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("ТочкаСЗапятой");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("ПродолжениеСтроки");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("ОкончаниеСтроки");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("ЗнакУмножения");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("ЗнакДеления");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("ЗнакОстатка");
	ОперацииПередКоторымиНеСтавимПробел.Вставить("КонецТекста");
	
	ОперацииПослеКоторыхНеСтавимПробел = Новый Структура();
	ОперацииПослеКоторыхНеСтавимПробел.Вставить("ЛеваяКруглаяСкобка");
	ОперацииПослеКоторыхНеСтавимПробел.Вставить("ЛеваяКвадратнаяСкобка");
	ОперацииПослеКоторыхНеСтавимПробел.Вставить("ЗнакВопроса");
	ОперацииПослеКоторыхНеСтавимПробел.Вставить("Точка");
	ОперацииПослеКоторыхНеСтавимПробел.Вставить("ТочкаСЗапятой");
	ОперацииПослеКоторыхНеСтавимПробел.Вставить("ПродолжениеСтроки");
	ОперацииПослеКоторыхНеСтавимПробел.Вставить("ОкончаниеСтроки");
	ОперацииПослеКоторыхНеСтавимПробел.Вставить("ЗнакУмножения");
	ОперацииПослеКоторыхНеСтавимПробел.Вставить("ЗнакДеления");
	ОперацииПослеКоторыхНеСтавимПробел.Вставить("ЗнакОстатка");
	
	ОперацииОпределяющиеУнарныйМинус = Новый Структура();
	ОперацииОпределяющиеУнарныйМинус.Вставить("ЗнакРавно");
	ОперацииОпределяющиеУнарныйМинус.Вставить("ЗнакПлюс");
	ОперацииОпределяющиеУнарныйМинус.Вставить("ЗнакВычитания");
	ОперацииОпределяющиеУнарныйМинус.Вставить("ЗнакПлюс");
	
	КоличествоТокенов = ТаблицаТокенов.Количество();
	
	Индекс = 1;
	
	Для Индекс = 1 По КоличествоТокенов - 2 Цикл
		
		Начало = ТаблицаТокенов[Индекс];
		Конец = ТаблицаТокенов[Индекс + 1];
		
		Если Начало.НомерСтроки <> Конец.НомерСтроки Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаДляЗамены = " ";
		
		Если ОперацииПослеКоторыхНеСтавимПробел.Свойство(Начало.Токен)
			Или ОперацииПередКоторымиНеСтавимПробел.Свойство(Конец.Токен)
			Или Начало.НомерСтроки <> Конец.НомерСтроки Тогда
			
			СтрокаДляЗамены = "";
			
		ИначеЕсли Индекс > 1 И Начало.Токен = "ЗнакВычитания"
			И(Конец.Токен = "Идентификатор" Или Конец.Токен = "Число") Тогда
			
			//попробуем определить унарный минус
			Если ОперацииОпределяющиеУнарныйМинус.Свойство(ТаблицаТокенов[Индекс - 1].Токен) Тогда
				СтрокаДляЗамены = "";
			КонецЕсли;
			
		КонецЕсли;
		
		
		КонецПозиция = Конец.Позиция;
		Если Конец.Токен = "Комментарий" Тогда
			КонецПозиция = КонецПозиция - 2;
		КонецЕсли;
		
		Если СтрокаДляЗамены <> Сред(Исходник, Начало.Позиция + Начало.Длина, КонецПозиция - Начало.Позиция - Начало.Длина) Тогда
			
			НоваяЗамена = ТаблицаЗамен.Добавить();
			НоваяЗамена.Источник = "Расстановка пробелов";
			НоваяЗамена.Текст = СтрокаДляЗамены;
			НоваяЗамена.Позиция = Начало.Позиция + Начало.Длина;
			НоваяЗамена.Длина = КонецПозиция - Начало.Позиция - Начало.Длина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	
	Возврат Неопределено;
	
КонецФункции // Закрыть()

Функция Подписки() Экспорт
	Перем Подписки;
	Подписки = Новый Массив;
	Возврат Подписки;
КонецФункции // Подписки()
