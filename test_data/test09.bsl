
Функция ТестРасстановкиОтступов2(Парам1, Парам2, Парам3) Экспорт // Тест комментария
	
    Результат = Парам1 + Парам2*Парам3;
	
    Для ц=1 по 100500 Цикл
	Если Результат > Парам3
		ИЛИ Результат < Парам2 Тогда
	
		Попытка
		
	Возврат Парам1/Парам2;
			
		Исключение
		#Если Клиент Тогда
		//Сообщим пользователю, что на ноль делить тельзя
			ОбщегоНазначения.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Число %1 нельзя делить на %2'"),
			Парам1, Парам2),
			"Парам1", "Объект");
			#КонецЕсли
		КонецПопытки;
	ИначеЕсли Результат = Парам3 Тогда
		Возврат Парам3;
	КонецЕсли;
КонецЦикла;
	Возврат Результат;

КонецФункции
