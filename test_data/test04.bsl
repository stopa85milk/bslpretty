
// На мой взгляд тут присутсвует баг парсера. От считает, что в коде
// "Структура.Цикл" есть токен "цикл". Вероятно это должен быть токен "Индетнификатор"
// из-за этого баг с отступами
Процедура ОбщийМодуль()

	ОбщийМодуль1.ЭкспортнаяФункция(Перечисления.Перечисление.Возврат, Парам2);

	Структура.Цикл = 1;

	Если Истина Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры
