
// Результат оформления расстановки отступов завистит от настроек плагина
// Попробуйте РекурсивныеДополнительныеОтступы = Истина
Процедура ТестРасстановкиОтступов1(Парам1, Парам2)
	
	ОбщегоНазначения.СообщитьПользователю(
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru = 'Число %1 нельзя делить на %2'"),
	Парам1, Парам2),
	"Парам1", "Объект");
	
КонецПроцедуры
