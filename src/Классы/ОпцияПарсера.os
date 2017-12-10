Перем Опция Экспорт;
Перем ОпцииИндекс Экспорт;


Функция ПриСозданииОбъекта(КлассОпции, Индекс)
	Сообщить("Создан парсер для опции "+ КлассОпции.Имя);
	Опция = КлассОпции;
	ОпцииИндекс = Индекс;
КонецФункции

Функция Поиск(Знач Аргументы, КонтекстПоиска) Экспорт

	Результат  = Новый Структура("РезультатПоиска, Аргументы", Ложь, Аргументы);

	Если Аргументы.Количество() = 0 
		ИЛИ КонтекстПоиска.СбросОпций Тогда
	
		Результат.РезультатПоиска = Опция.УстановленаИзПеременнойОкружения;
		Возврат Результат;

	КонецЕсли;

	Индекс = 0;

	Пока Индекс < Аргументы.Количество() Цикл
		
		ТекущийАргумент = Аргументы[Индекс];

		Если ТекущийАргумент = "-" Тогда
			Индекс = Индекс+1;
			Продолжить;
		ИначеЕсли ТекущийАргумент = "--" Тогда
			Результат.РезультатПоиска = Опция.УстановленаИзПеременнойОкружения;
			Возврат Результат;
		ИначеЕсли СтрНачинаетсяС(ТекущийАргумент, "--") Тогда

		ИначеЕсли СтрНачинаетсяС(ТекущийАргумент, "-") Тогда

			РезультатПоискаКороткойОпции = НайтиКоротнуюОпцию(Аргументы, Индекс, КонтекстПоиска);
			Сообщить("Короткая опция найдена: " + РезультатПоискаКороткойОпции.Найден);
			Если РезультатПоискаКороткойОпции.Найден Тогда
				Результат.РезультатПоиска = Истина;
				Результат.Аргументы = РезультатПоискаКороткойОпции.Аргументы;
				Возврат Результат;
				
			КонецЕсли;

		Иначе
			Результат.РезультатПоиска = Опция.УстановленаИзПеременнойОкружения;
			Возврат Результат;
		КонецЕсли;

		Индекс = Индекс+1;

	КонецЦикла;

	// Если НЕ КонтекстПоиска.СбросОпций И 
	// 	СтрНачинаетсяС(Аргументы[0], "-")
	// 	И Аргументы[0] = "-"
	// 	Тогда 
	// 	Возврат Результат;
		
	// КонецЕсли;

	// АргументКонтекст = КонтекстПоиска.Аргументы[Аргумент];
	// Если АргументКонтекст = Неопределено Тогда
	// 	АргументКонтекст = Новый Массив;
	// КонецЕсли;
	// АргументКонтекст.Добавить(Аргументы[0]);
	// КонтекстПоиска.Аргументы.Вставить(Аргумент,АргументКонтекст);
	
	// Результат.РезультатПоиска = Истина;
	// Результат.Аргументы = Аргументы.Удалить(0);
	

	Возврат Результат;

КонецФункции

Функция НайтиКоротнуюОпцию(Знач Аргументы, Индекс, КонтекстПоиска)
	Сообщить("Класс опции " + ТипЗнч(Опция));
	Сообщить("Ищю короткую опцию "+ Опция.Имя);

	ТекущийАргумент = Аргументы[Индекс];

	Результат  = Новый Структура("Найден, ПрибавочныйИндекс, Аргументы", Ложь, 0, Аргументы);
	
	Если СтрДлина(ТекущийАргумент) < 2 Тогда
	
		Возврат Результат;

	КонецЕсли;
	
	Если Сред(ТекущийАргумент,3, 1) = "=" Тогда
		
		Имя = Лев(ТекущийАргумент,2);

		КлассОпции = ОпцииИндекс[Имя];
		Если Не КлассОпции.имя = Опция.Имя Тогда
			Результат.ПрибавочныйИндекс  = 1;
			Возврат Результат;

		КонецЕсли; 
		// if opt != o.theOne {
		// 	return false, 1, args
		// }
		Значение = Сред(ТекущийАргумент, 4);

		Если ПустаяСтрока(СокрЛП(Значение)) Тогда
			Возврат Результат;
		КонецЕсли;


		ОпцииКонтекст = КонтекстПоиска.Опции[Опция];
		Если ОпцииКонтекст = Неопределено Тогда
			ОпцииКонтекст = Новый Массив;
		КонецЕсли;
		ОпцииКонтекст.Добавить(Значение);
		КонтекстПоиска.Опции.Вставить(Опция, ОпцииКонтекст);
		
		Аргументы.Удалить(Индекс);
		Результат.ПрибавочныйИндекс  = 1;
		Результат.Аргументы  = Аргументы;
		Результат.Найден  = Истина;

		Возврат Результат;


	КонецЕсли;


	ИщемОпцию = Сред(ТекущийАргумент,2); 

	ДлинаОпций = СтрДлина(ИщемОпцию);
	Для ИИ = 1 По ДлинаОпций Цикл
		
		ИмяОпции = Сред(ИщемОпцию, ИИ, ИИ+1);
		
		КлассОпции = ОпцииИндекс["-"+ИмяОпции];
		
		Если КлассОпции = Неопределено Тогда
			
			Возврат Результат;
			// Назад();
			// Сообщить("Нашли не объявленную опцию");
			// ВызватьИсключение "Ошибка получения в индексе класса опции";
		КонецЕсли;

		Если ТипЗнч(КлассОпции.Значение) = Тип("Булево") Тогда
			
			Если Не КлассОпции.имя = Опция.Имя Тогда
				Продолжить;
			КонецЕсли; 

			ОпцииКонтекст = КонтекстПоиска.Опции[Опция];
			Если ОпцииКонтекст = Неопределено Тогда
				ОпцииКонтекст = Новый Массив;
			КонецЕсли;
			ОпцииКонтекст.Добавить(Истина);
			КонтекстПоиска.Опции.Вставить(Опция,ОпцииКонтекст);
			
			Результат.Найден  = Истина;
			Если СтрДлина(ИмяОпции) = СтрДлина(ИщемОпцию) Тогда
				Аргументы.Удалить(Индекс);
				Результат.ПрибавочныйИндекс  = 1;
				Возврат Результат;
			КонецЕсли;

			НовыйАргумент = СтрЗаменить(ИмяОпции, ИмяОпции, "");
			Аргументы[Индекс] = НовыйАргумент;
			Результат.Аргументы  = Аргументы;
			
			Возврат Результат;

		КонецЕсли;


	
	КонецЦикла;

	
	Возврат Результат;


КонецФункции



Функция Приоритет() Экспорт
	Возврат 1;
КонецФункции

Функция ВСтроку() Экспорт
	Возврат Опция.Имя;
КонецФункции
