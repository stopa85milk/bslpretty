﻿
Перем Токены;
Перем Исходник;
Перем ТаблицаТокенов;
Перем ТаблицаЗамен;

Перем мШаблоны;

// Минимальное количество строк подряд попадающих под шаблон
// для которго будет применено оформление
Перем мКоличествоСтрокПодряд;

Процедура Открыть(Парсер, Параметры) Экспорт
	
	Токены = Парсер.Токены();
	Исходник = Парсер.Исходник();
	ТаблицаТокенов = Парсер.ТаблицаТокенов();
	КлючевыеСлова = Парсер.КлючевыеСлова();
	ТаблицаЗамен = Парсер.ТаблицаЗамен();
	
	СоздатьШаблоны();
	
	Если Параметры <> Неопределено 
		И Параметры.Свойство("КоличествоСтрокПодряд") Тогда
		
		мКоличествоСтрокПодряд = Параметры.КоличествоСтрокПодряд;
		
	КонецЕсли;
	
КонецПроцедуры // Открыть()

Функция Закрыть() Экспорт
	
	КоличествоТокенов = ТаблицаТокенов.Количество() - 1;
	КоличествоСтрок = ТаблицаТокенов[ТаблицаТокенов.Количество() - 2].НомерСтроки;
	Индекс = 1;
	НачалоСтроки = 1;
	КонецСтроки = 1;
	НомерСтроки = 1;
	Позиция = 1;
	
	КлючСовпадений = Новый Структура("Ключ,ИндексШаблона", Неопределено, Неопределено);
	МассивНачалИКонцовСтрок = Новый Массив();
	
	РезультатПоиска = Новый Массив();
	
	Пока Индекс < КоличествоТокенов Цикл
		
		НачалоСтроки = Индекс;
		
		Пока Индекс < КоличествоТокенов
			И ТаблицаТокенов[Индекс].НомерСтроки <= НомерСтроки Цикл
			
			//Токены внутри строки
			КонецСтроки = Индекс;
			Индекс = Индекс + 1;
			
		КонецЦикла;
		
		Если НачалоСтроки <= КонецСтроки Тогда
			
			Рез = ПроверитьНаШаблон(НачалоСтроки, КонецСтроки);
			
			Если КлючСовпадений.Ключ <> Рез.Ключ Тогда
				
				Если МассивНачалИКонцовСтрок.Количество() > 1 Тогда
					
					Стр = Новый Структура();
					Стр.Вставить("Ключ", КлючСовпадений.Ключ);
					Стр.Вставить("ИндексШаблона", КлючСовпадений.ИндексШаблона);
					Стр.Вставить("МассивНачалИКонцовСтрок", Новый ФиксированныйМассив(МассивНачалИКонцовСтрок));
					
					РезультатПоиска.Добавить(Стр);
					
				КонецЕсли;
				
				МассивНачалИКонцовСтрок.Очистить();
				
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(КлючСовпадений, Рез);
			Если Рез.Ключ <> Неопределено Тогда
				МассивНачалИКонцовСтрок.Добавить(Новый Структура("НачалоСтроки,КонецСтроки", НачалоСтроки, КонецСтроки));
			КонецЕсли;
			
		КонецЕсли;
		
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	Если МассивНачалИКонцовСтрок.Количество() > 1 Тогда
		
		Стр = Новый Структура();
		Стр.Вставить("Ключ", КлючСовпадений.Ключ);
		Стр.Вставить("ИндексШаблона", КлючСовпадений.ИндексШаблона);
		Стр.Вставить("МассивНачалИКонцовСтрок", Новый ФиксированныйМассив(МассивНачалИКонцовСтрок));
		
		РезультатПоиска.Добавить(Стр);
		
	КонецЕсли;
	
	
	СтрокаИзПробелов = "                                                                           ";
	
	// Обход результатов поиска с конца. 
	// Тогда не нужно запоминать количество добавленых символов и формулы
	// становятся проще
	ц = РезультатПоиска.Количество();
	Пока ц > 0 Цикл
		
		ц = ц - 1;
		Эл = РезультатПоиска[ц];
		
		Если Эл.МассивНачалИКонцовСтрок.Количество() < мКоличествоСтрокПодряд Тогда
			Продолжить;
		КонецЕсли;
		
		МаксПозицияВСтроке = 0;
		Для Каждого НачалоИКонец Из Эл.МассивНачалИКонцовСтрок Цикл
			
			Если мШаблоны[Эл.ИндексШаблона].ПереносПоследнегоТокена Тогда
				
				НомерКолонки = ТаблицаТокенов[НачалоИКонец.НачалоСтроки + мШаблоны[Эл.ИндексШаблона].Шаблон.Количество() - 1].НомерКолонки;
				
			Иначе
				
				НомерКолонки = ТаблицаТокенов[НачалоИКонец.НачалоСтроки + мШаблоны[Эл.ИндексШаблона].Шаблон.Количество()].НомерКолонки;
				
			КонецЕсли;
			
			Если НомерКолонки > МаксПозицияВСтроке Тогда
				
				МаксПозицияВСтроке = НомерКолонки;
				
			КонецЕсли;
			
		КонецЦикла;
		
		цц = Эл.МассивНачалИКонцовСтрок.Количество() - 1;
		Пока цц >= 0 Цикл
			
			НачалоИКонец = Эл.МассивНачалИКонцовСтрок[цц];
			Если мШаблоны[Эл.ИндексШаблона].ПереносПоследнегоТокена Тогда
				
				ПоследнийТокен = ТаблицаТокенов[НачалоИКонец.НачалоСтроки + мШаблоны[Эл.ИндексШаблона].Шаблон.Количество() - 1];
				
			Иначе
				
				ПоследнийТокен = ТаблицаТокенов[НачалоИКонец.НачалоСтроки + мШаблоны[Эл.ИндексШаблона].Шаблон.Количество()];
				
			КонецЕсли;
			
			ПозицияДляВставкиОтступов = ПоследнийТокен.Позиция;
			ПозицияВСтроке = ПоследнийТокен.НомерКолонки;
			
			Если МаксПозицияВСтроке > ПозицияВСтроке Тогда
				
				НоваяЗамена = ТаблицаЗамен.Добавить();
				НоваяЗамена.Источник = "Выравнивание аргументов";
				НоваяЗамена.Текст    = Лев(СтрокаИзПробелов, МаксПозицияВСтроке - ПозицияВСтроке);
				НоваяЗамена.Позиция  = ПозицияДляВставкиОтступов;
				НоваяЗамена.Длина    = 0;
				
			КонецЕсли;
			
			цц = цц - 1;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции // Закрыть()

Функция Подписки() Экспорт
	Перем Подписки;
	Подписки = Новый Массив;
	Возврат Подписки;
КонецФункции // Подписки() 

Функция ПроверитьНаШаблон(НачалоСтроки, КонецСтроки)
	
	Для ИндексШаблона = 0 По мШаблоны.Количество() - 1 Цикл
		
		Шаблон = мШаблоны[ИндексШаблона];
		
		КлючСтроки = Новый Массив();
		ц = 0;
		КоличествоСтрокИдентификаторов = 0;
		
		СовпадаетСШаблоном = Истина;
		
		Пока ц < Шаблон.Шаблон.Количество()
			И ц + НачалоСтроки < КонецСтроки Цикл
			
			Токен = ТаблицаТокенов[ц + НачалоСтроки];
			Если Токен.Токен <> Шаблон.Шаблон[ц] Тогда
				СовпадаетСШаблоном = Ложь;
				Прервать;
			КонецЕсли;
			
			Если Токен.Токен = "Идентификатор" Или Токен.Токен = "Строка" Тогда
				
				Если КоличествоСтрокИдентификаторов < Шаблон.КоличествоСтрокИдентификаторов - 1 Тогда
					КлючСтроки.Добавить("""" + Сред(Исходник, Токен.Позиция, Токен.Длина) + """");
				Иначе
					КлючСтроки.Добавить("*");
				КонецЕсли;
				КоличествоСтрокИдентификаторов = КоличествоСтрокИдентификаторов + 1;
				
			Иначе
				
				КлючСтроки.Добавить(Токен.Токен);
				
			КонецЕсли;
			
			ц = ц + 1;
			
		КонецЦикла;
		
		Если СовпадаетСШаблоном И ц = Шаблон.Шаблон.Количество() Тогда
			
			Рез = Новый Структура();
			Рез.Вставить("Ключ", СтрСоединить(КлючСтроки, ","));
			Рез.Вставить("ИндексШаблона", ИндексШаблона);
			
			Возврат Рез;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый Структура("Ключ", Неопределено);
	
КонецФункции

Процедура СоздатьШаблоны()
	
	мШаблоны.Очистить();
	
	// Стр.Эл =
	Шаблон = Шаблон();
	Шаблон.Шаблон.Добавить("Идентификатор");
	Шаблон.Шаблон.Добавить("Точка");
	Шаблон.Шаблон.Добавить("Идентификатор");
	Шаблон.Шаблон.Добавить("ЗнакРавно");
	Шаблон.ПереносПоследнегоТокена = Истина;
	Шаблон.КоличествоСтрокИдентификаторов = 2;
	
	мШаблоны.Добавить(Шаблон);
	
	// Идент.Стр.Эл =
	Шаблон = Шаблон();
	Шаблон.Шаблон.Добавить("Идентификатор");
	Шаблон.Шаблон.Добавить("Точка");
	Шаблон.Шаблон.Добавить("Идентификатор");
	Шаблон.Шаблон.Добавить("ЗнакРавно");
	Шаблон.Шаблон.Добавить("Идентификатор");
	Шаблон.Шаблон.Добавить("ЗнакРавно");
	Шаблон.ПереносПоследнегоТокена = Истина;
	Шаблон.КоличествоСтрокИдентификаторов = 3;
	
	мШаблоны.Добавить(Шаблон);
	
	// Стр.Вставить("",
	Шаблон = Шаблон();
	Шаблон.Шаблон.Добавить("Идентификатор");
	Шаблон.Шаблон.Добавить("Точка");
	Шаблон.Шаблон.Добавить("Идентификатор");
	Шаблон.Шаблон.Добавить("ЛеваяКруглаяСкобка");
	Шаблон.Шаблон.Добавить("Строка");
	Шаблон.Шаблон.Добавить("Запятая");
	Шаблон.ПереносПоследнегоТокена = Ложь;
	Шаблон.КоличествоСтрокИдентификаторов = 3;
	
	мШаблоны.Добавить(Шаблон);
	
	// Запрос.Параметры.Вставить("",
	Шаблон = Шаблон();
	Шаблон.Шаблон.Добавить("Идентификатор");
	Шаблон.Шаблон.Добавить("Точка");
	Шаблон.Шаблон.Добавить("Идентификатор");
	Шаблон.Шаблон.Добавить("Точка");
	Шаблон.Шаблон.Добавить("Идентификатор");
	Шаблон.Шаблон.Добавить("ЛеваяКруглаяСкобка");
	Шаблон.Шаблон.Добавить("Строка");
	Шаблон.Шаблон.Добавить("Запятая");
	Шаблон.ПереносПоследнегоТокена = Ложь;
	Шаблон.КоличествоСтрокИдентификаторов = 4;
	
	мШаблоны.Добавить(Шаблон);
	
КонецПроцедуры

Функция Шаблон()
	
	Шаблон = Новый Структура();
	Шаблон.Вставить("Шаблон", Новый Массив());
	Шаблон.Вставить("ПереносПоследнегоТокена", Неопределено);
	Шаблон.Вставить("КоличествоСтрокИдентификаторов", Неопределено);
	
	Возврат Шаблон;
	
КонецФункции

мКоличествоСтрокПодряд = 3;
мШаблоны = Новый Массив();
