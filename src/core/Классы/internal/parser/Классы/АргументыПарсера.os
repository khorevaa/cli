#Использовать logos

// Ссылка на класс аргумента
Перем Аргумент Экспорт;
Перем Лог;

Процедура ПриСозданииОбъекта(КлассОпции)
	
	Аргумент = КлассОпции;

КонецПроцедуры

// Выполняет поиск аргумента в массиве входящих аргументов
//
// Параметры:
//   ВходящиеАргументы - массив - входящие аргументы приложения
//   КонтекстПоиска - Объект - класс "КонтекстПарсера"
//
//  Возвращаемое значение:
//   Структура - структура описания токена
//    * РезультатПоиска - булево - признак успешного поиска
//    * Аргументы - Массив - массив оставшихся аргументов после поиска
//
Функция Поиск(Знач ВходящиеАргументы, КонтекстПоиска) Экспорт

	Аргументы = Новый Массив;

	Для каждого Арг Из ВходящиеАргументы Цикл
		Аргументы.Добавить(Арг);
	КонецЦикла;
	
	Результат = Новый Структура("РезультатПоиска, Аргументы", Аргумент.УстановленаИзПеременнойОкружения, Аргументы);
	Лог.Отладка(" АргументыПарсера: 
	|УстановленаИзПеременнойОкружения <%1>
	|УстановленаПользователем <%2>", Аргумент.УстановленаИзПеременнойОкружения, Аргумент.УстановленаПользователем);
	Если Аргументы.Количество() = 0  Тогда
		
		Если Аргумент.УстановленаИзПеременнойОкружения
			И КонтекстПоиска.НеВключенныеАргументы[Аргумент] = Истина Тогда
			Результат.РезультатПоиска = Ложь;
		Иначе
			КонтекстПоиска.НеВключенныеАргументы.Вставить(Аргумент, Истина);
		КонецЕсли;

		Возврат Результат;

	КонецЕсли;

	Если (НЕ КонтекстПоиска.СбросОпций И 
		СтрНачинаетсяС(Аргументы[0], "-")
		И НЕ Аргументы[0] = "-")
		ИЛИ ПустаяСтрока(Аргументы[0])
		Тогда 
		Возврат Результат;
		
	КонецЕсли;

	АргументКонтекст = КонтекстПоиска.Аргументы[Аргумент];
	Если АргументКонтекст = Неопределено Тогда
		АргументКонтекст = Новый Массив;
	КонецЕсли;

	АргументКонтекст.Добавить(Аргументы[0]);
	КонтекстПоиска.Аргументы.Вставить(Аргумент, АргументКонтекст);
	
	Результат.РезультатПоиска = Истина;
	Аргументы.Удалить(0);
	
	Результат.Аргументы  = Аргументы;
	Возврат Результат;

КонецФункции

// Возвращает приоритет текущего парсера
//
//  Возвращаемое значение:
//   число - приоритет текущего парсера
//
Функция Приоритет() Экспорт
	Возврат 8;
КонецФункции

// Возвращает имя текущего парсера
//
//  Возвращаемое значение:
//   строка - имя текущего парсера, на основании имени аргумента
//
Функция ВСтроку() Экспорт
	Возврат Аргумент.Имя;
КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.lib.cli_class_arg");
