﻿
Перем Токены;
Перем Исходник;
Перем ТаблицаТокенов;
Перем ТаблицаЗамен;

//Настройки пока тут
Перем мОтступ;
Перем мПустыеСтрокиСОтступами;
Перем мРекурсивныеДополнительныеОтступы;

Процедура Открыть(Парсер, Параметры) Экспорт
	
	Токены = Парсер.Токены();
	Исходник = Парсер.Исходник();
	ТаблицаТокенов = Парсер.ТаблицаТокенов();
	КлючевыеСлова = Парсер.КлючевыеСлова();
	ТаблицаЗамен = Парсер.ТаблицаЗамен();
	
	Если Параметры.Свойство("ПустыеСтрокиСОтступами") Тогда
		мПустыеСтрокиСОтступами = Параметры.ПустыеСтрокиСОтступами;
	КонецЕсли;
	
	Если Параметры.Свойство("Отступ") Тогда
		мОтступ = Параметры.Отступ;
	КонецЕсли;
	
	Если Параметры.Свойство("РекурсивныеДополнительныеОтступы") Тогда
		мРекурсивныеДополнительныеОтступы = Параметры.РекурсивныеДополнительныеОтступы;
	КонецЕсли;
	
КонецПроцедуры // Открыть()

Функция Закрыть() Экспорт
	
	ОтступСтрока = Строка(Символы.Таб);
	
	КоличествоТокенов = ТаблицаТокенов.Количество();
	
	ТокеныСтавимОтступ = Новый Структура();
	//Скобка закрывающая объявление фнукции и процедур 
	//ТокеныСтавимОтступ.Вставить("ПраваяКруглаяСкобка");
	//Тогда, но не в иструкции предпроцессора, а в условном операторе Если
	//ТокеныСтавимОтступ.Вставить("Тогда");
	ТокеныСтавимОтступ.Вставить("Иначе");
	ТокеныСтавимОтступ.Вставить("Попытка");
	ТокеныСтавимОтступ.Вставить("Исключение");
	ТокеныСтавимОтступ.Вставить("Цикл");
	
	ТокеныУбираемОтступ = Новый Структура();
	ТокеныУбираемОтступ.Вставить("КонецФункции");
	ТокеныУбираемОтступ.Вставить("КонецПроцедуры");
	ТокеныУбираемОтступ.Вставить("Иначе");
	ТокеныУбираемОтступ.Вставить("ИначеЕсли");
	ТокеныУбираемОтступ.Вставить("КонецЕсли");
	ТокеныУбираемОтступ.Вставить("Исключение");
	ТокеныУбираемОтступ.Вставить("КонецПопытки");
	ТокеныУбираемОтступ.Вставить("КонецЦикла");
	
	БлокиДополнительногоОтступа = Новый Соответствие();
	БлокиДополнительногоОтступа.Вставить("Если", "Тогда");
	БлокиДополнительногоОтступа.Вставить("ИначеЕсли", "Тогда");
	БлокиДополнительногоОтступа.Вставить("Пока", "Цикл");
	БлокиДополнительногоОтступа.Вставить("Для", "Цикл");
	БлокиДополнительногоОтступа.Вставить("ЛеваяКруглаяСкобка", "ПраваяКруглаяСкобка");
	БлокиДополнительногоОтступа.Вставить("ЛеваяКвадратнаяСкобка", "ПраваяКвадратнаяСкобка");
	БлокиДополнительногоОтступа.Вставить("Возврат", "ТочкаСЗапятой");
	
	Индекс = 1;
	
	ОтступыЭтойСтроки = 0;
	ОтступыСледующейСтроки = 0;
	СтекДополнительныхОтступов = Новый Массив();
	
	МассивКоличествоОтступов = Новый Массив();
	Для ц = 0 По ТаблицаТокенов[ТаблицаТокенов.Количество() - 1].НомерСтроки Цикл
		МассивКоличествоОтступов.Добавить(0);
	КонецЦикла;
	
	СпБлоков = Новый Массив();
	Для Индекс = 1 По КоличествоТокенов - 1 Цикл
		
		Токен = ТаблицаТокенов[Индекс];
		Если Индекс > 1 И Токен.НомерСтроки - ТаблицаТокенов[Индекс - 1].НомерСтроки > 0 Тогда
			
			ТокенНачало = ТаблицаТокенов[Индекс - 1];
			МассивКоличествоОтступов[ТокенНачало.НомерСтроки] = МассивКоличествоОтступов[ТокенНачало.НомерСтроки] + ОтступыЭтойСтроки;
			ОтступыЭтойСтроки = ОтступыСледующейСтроки;
			
			Для ц = ТокенНачало.НомерСтроки + 1 По Токен.НомерСтроки - 1 Цикл
				Если мПустыеСтрокиСОтступами Тогда
					МассивКоличествоОтступов[ц] = МассивКоличествоОтступов[ц] + ОтступыЭтойСтроки + СтекДополнительныхОтступов.Количество();
				КонецЕсли;
			КонецЦикла;
			
			Если мРекурсивныеДополнительныеОтступы Тогда
				МассивКоличествоОтступов[Токен.НомерСтроки] = СтекДополнительныхОтступов.Количество();
			ИначеЕсли СтекДополнительныхОтступов.Количество() > 0 Тогда
				МассивКоличествоОтступов[Токен.НомерСтроки] = 1;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТокеныСтавимОтступ.Свойство(Токен.Токен) Тогда
			
			ОтступыСледующейСтроки = ОтступыСледующейСтроки + 1;
			
		ИначеЕсли Токен.Токен = "Тогда" Тогда
			
			ц = Индекс;
			Пока ц > 0 Цикл
				ц = ц - 1;
				
				Если ТаблицаТокенов[Ц].Токен = "Если"
					Или ТаблицаТокенов[Ц].Токен = "ИначеЕсли" Тогда
					
					ОтступыСледующейСтроки = ОтступыСледующейСтроки + 1;
					Прервать;
					
				ИначеЕсли ТаблицаТокенов[Ц].Токен = "_Если"
					Или ТаблицаТокенов[Ц].Токен = "_ИначеЕсли" Тогда
					
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;
			
		ИначеЕсли Токен.Токен = "ПраваяКруглаяСкобка" Тогда
			
			// Скобка может означать конец объявления функции
			ц = Индекс - 1;
			КоличествоПравыхКруглыхСкобок = 1;
			Пока Ц >= 2 Цикл
				
				Если ТаблицаТокенов[ц].Токен = "ПраваяКруглаяСкобка" Тогда
					КоличествоПравыхКруглыхСкобок = КоличествоПравыхКруглыхСкобок + 1;
				ИначеЕсли ТаблицаТокенов[ц].Токен = "ЛеваяКруглаяСкобка" Тогда
					КоличествоПравыхКруглыхСкобок = КоличествоПравыхКруглыхСкобок - 1;
				КонецЕсли;
				
				Если КоличествоПравыхКруглыхСкобок = 0 Тогда
					Прервать;
				КонецЕсли;
				
				ц = ц - 1;
				
			КонецЦикла;
			
			Если ТаблицаТокенов[ц - 2].Токен = "Функция" Или ТаблицаТокенов[ц - 2].Токен = "Процедура" Тогда
				ОтступыСледующейСтроки = ОтступыСледующейСтроки + 1;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТокеныУбираемОтступ.Свойство(Токен.Токен) Тогда
			
			ОтступыЭтойСтроки = ОтступыЭтойСтроки - 1;
			ОтступыСледующейСтроки = ОтступыСледующейСтроки - 1;
			
		КонецЕсли;
		
		Если БлокиДополнительногоОтступа.Получить(Токен.Токен) <> Неопределено Тогда
			
			СтекДополнительныхОтступов.Добавить(Токен.Токен);
			
		ИначеЕсли СтекДополнительныхОтступов.Количество() = 0 И Токен.Токен = "ЗнакРавно" Тогда
			
			СтекДополнительныхОтступов.Добавить(Токен.Токен);
			
		КонецЕсли;
		
		Если СтекДополнительныхОтступов.Количество() > 0 Тогда
			
			Если Токен.Токен = БлокиДополнительногоОтступа[СтекДополнительныхОтступов[СтекДополнительныхОтступов.Количество() - 1]]
				Или(Токен.Токен = "ТочкаСЗапятой" И СтекДополнительныхОтступов[СтекДополнительныхОтступов.Количество() - 1] = "ЗнакРавно") Тогда
				
				СтекДополнительныхОтступов.Удалить(СтекДополнительныхОтступов.Количество() - 1);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Теперь пройдемся и расставим отступы
	Для Индекс = 1 По КоличествоТокенов - 1 Цикл
		
		Начало = ТаблицаТокенов[Индекс - 1];
		Конец = ТаблицаТокенов[Индекс];
		Если Начало.НомерСтроки = Конец.НомерСтроки Тогда
			Продолжить;
		КонецЕсли;
		Если Начало.НомерСтроки = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		КонецПозиция = Конец.Позиция;
		Если Конец.Токен = "Комментарий" Тогда
			КонецПозиция = КонецПозиция - 2;
		КонецЕсли;
		
		НачалоДлина = Начало.Длина;
		Если Начало.Токен = "НачалоСтроки" Или Начало.Токен = "ПродолжениеСтроки" Тогда
			НачалоДлина = НачалоДлина - 1;
		КонецЕсли;
		
		СтрокаДляЗамены = "";
		Для НомерСтроки = Начало.НомерСтроки + 1 По Конец.НомерСтроки Цикл
			
			СтрокаОтступы = "";
			Для цц = 1 По МассивКоличествоОтступов[НомерСтроки] Цикл
				СтрокаОтступы = СтрокаОтступы + мОтступ;
			КонецЦикла;
			СтрокаДляЗамены = СтрокаДляЗамены + Строка(Символы.ПС) + СтрокаОтступы;
			
		КонецЦикла;
		
		Если СтрокаДляЗамены <> Сред(Исходник, Начало.Позиция + НачалоДлина, КонецПозиция - Начало.Позиция - НачалоДлина) Тогда
			
			НоваяЗамена = ТаблицаЗамен.Добавить();
			НоваяЗамена.Источник = "Расстановка отступов начало строки";
			НоваяЗамена.Текст    = СтрокаДляЗамены;
			НоваяЗамена.Позиция  = Начало.Позиция + НачалоДлина;
			НоваяЗамена.Длина    = КонецПозиция - Начало.Позиция - НачалоДлина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции // Закрыть()

Функция Подписки() Экспорт
	Перем Подписки;
	Подписки = Новый Массив;
	Возврат Подписки;
КонецФункции // Подписки()

// Настройки пока тут
мПустыеСтрокиСОтступами = Ложь;
мОтступ = Строка(Символы.Таб);
мРекурсивныеДополнительныеОтступы = Ложь;
