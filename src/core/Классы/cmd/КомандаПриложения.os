
#Использовать delegate
#Использовать logos

Перем Спек экспорт;
Перем ПодробноеОписание Экспорт;

Перем ДействиеВыполнения Экспорт;
Перем ДействиеПередВыполнением Экспорт;
Перем ДействиеПослеВыполнения Экспорт;

Перем Имя; // текст
Перем Синонимы; // массив строк
Перем Описание; // текст
Перем ВложенныеКоманды;  // Массив классов КомандаПриложения
Перем Опции; // Соответствие Ключ - Значение (Структура описание опции)
Перем Аргументы; // Соответствие  

Перем ОпцииИндекс; // Соответствие
Перем АргументыИндекс; // Соответствие

Перем КлассРеализации;

Перем КомандыРодители Экспорт;

Перем fsm;
Перем НачальноеСостояние;

Перем РефлекторПроверкиКоманд;

Перем Лог;

Функция ДобавитьПодкоманду(ИмяПодкоманды, ОписаниеПодкоманды, КлассРеализацииПодкоманды) Экспорт

	Подкоманда = Новый КомандаПриложения(ИмяПодкоманды, ОписаниеПодкоманды, КлассРеализацииПодкоманды);
	
	Подкоманда = ВыполнитьОписаниеКоманды(КлассРеализацииПодкоманды, Подкоманда);
	ВложенныеКоманды.Добавить(Подкоманда);
	Возврат Подкоманда;
	
КонецФункции

Процедура ПриСозданииОбъекта(ИмяКоманды, ОписаниеКоманды, КлассРеализацииКоманды)
	
	Синонимы = СтрРазделить(ИмяКоманды, " ", Ложь);
	Имя = Синонимы[0];
	Описание = ОписаниеКоманды;
	КлассРеализации = КлассРеализацииКоманды;

	ВложенныеКоманды = Новый Массив;
	КомандыРодители = Новый Массив;
	Опции = Новый Соответствие;
	Аргументы = Новый Соответствие;
	
	ОпцииИндекс = Новый Соответствие;
	АргументыИндекс = Новый Соответствие;
	
	Спек = "";
	ПодробноеОписание = "";

	ДействиеВыполнения = Делегаты.Создать(КлассРеализацииКоманды, "ВыполнитьКоманду");
	ДействиеПередВыполнением = Делегаты.Создать(КлассРеализацииКоманды, "ПередВыполнением");
	ДействиеПослеВыполнения = Делегаты.Создать(КлассРеализацииКоманды, "ПослеВыполнения");
	
	РефлекторПроверкиКоманд = Новый Рефлектор;

	fsm = Новый ВыборСовпадений();

КонецПроцедуры

Функция ПолучитьИмяКоманды() Экспорт
	Возврат Имя;	
КонецФункции

Функция ПолучитьСинонимы() Экспорт
	Возврат Синонимы;	
КонецФункции

Функция ПолучитьОписание() Экспорт
	Возврат Описание;	
КонецФункции

Процедура Запуск(Знач АргументыCLI) Экспорт

	Если НужноВывестиСправку(АргументыCLI) Тогда
		ВывестиСправку();
		Возврат;
	КонецЕсли;


	nargsLen = ПолучитьОпцииИАргументы(АргументыCLI);

	Лог.Отладка("Количество входящих аргументов команды: %1", АргументыCLI.Количество());
	Лог.Отладка("Количество аргументов команды: %1", nargsLen);

	НачальныйИндексКоманды = 0;
	КонечныйИндексКоманды = nargsLen-1;
	Лог.Отладка("КонечныйИндексКоманды аргументов команды: %1", КонечныйИндексКоманды);
	
	
	МассивАргументовКПарсингу = Новый Массив;

	Для ИИ = 0 По КонечныйИндексКоманды Цикл
		МассивАргументовКПарсингу.Добавить(АргументыCLI[ИИ]);
	КонецЦикла;

	Лог.Отладка("Читаю аргументы строки");
	ОшибкаЧтения = Не НачальноеСостояние.Прочитать(МассивАргументовКПарсингу);

	Если ОшибкаЧтения Тогда
		Лог.КритичнаяОшибка("Ошибка чтения");		
		ВывестиСправку();
		Возврат;
	КонецЕсли;

	Если КонечныйИндексКоманды = АргументыCLI.ВГраница() Тогда
		Лог.Отладка("Выполняю полезную работу %1", Имя);
		ДействиеВыполнения.Исполнить(ЭтотОбъект);
		Возврат;
	КонецЕсли;

	ПервыйАргумент = АргументыCLI[КонечныйИндексКоманды+1];
		
	Для каждого ВложеннаяКоманда Из ВложенныеКоманды Цикл
		
		Если ВложеннаяКоманда.ЭтоСинонимКоманды(ПервыйАргумент) Тогда
		
			АргументыПодкоманды = Новый Массив;
			
			НачальныйИндекс = КонечныйИндексКоманды+2;
			
			Если НачальныйИндекс <= АргументыCLI.ВГраница() Тогда
				
				Для ИИ = НачальныйИндекс По АргументыCLI.ВГраница() Цикл
					АргументыПодкоманды.Добавить(АргументыCLI[ИИ]);
				КонецЦикла;
			
			КонецЕсли;

			ВложеннаяКоманда.НачалоЗапуска();
			ВложеннаяКоманда.Запуск(АргументыПодкоманды);
			Возврат;

		КонецЕсли;

	КонецЦикла;


	Если СтрНачинаетсяС(ПервыйАргумент,"-") Тогда
		ВывестиСправку();
		ВызватьИсключение "Не известна опция";

	КонецЕсли;
	ВывестиСправку();
	ВызватьИсключение "Вызвать исключение не корректное использование";
	
КонецПроцедуры

Процедура ВывестиСправку() Экспорт
	
	КонсольВывода = Новый Консоль;
	ЦветВключенныйПлагин = ЦветКонсоли.Зеленый;
	ЦветВыключенныйПлагин = ЦветКонсоли.Yellow;

	ЦветТекстаКонсоли = КонсольВывода.ЦветТекста;

	Представление = ?(КомандыРодители.Количество()>0, "Команда", "Приложение");

	КонсольВывода.ВывестиСтроку(СтрШаблон("%1: %2 
	| %3", Представление, СтрСоединить(Синонимы, ", "), ?(ПустаяСтрока(ПодробноеОписание), Описание, ПодробноеОписание)));
	КонсольВывода.ВывестиСтроку("");
	
	ПолныйПуть = Новый Массив;
	 
	Для каждого Родитель Из КомандыРодители Цикл
		ПолныйПуть.Добавить(Родитель);
	КонецЦикла;
	ПолныйПуть.Добавить(СокрЛП(Имя));

	ПутьИспользования = СтрСоединить(ПолныйПуть," ");
	СуффиксВложенныхКоманды = "";
	Если ВложенныеКоманды.Количество() > 0  Тогда
		
		СуффиксВложенныхКоманды = "КОМАНДА [аргументы...]";
		
	КонецЕсли;

	КонсольВывода.ВывестиСтроку(СтрШаблон("Строка запуска: %1 %2 %3",ПутьИспользования, СокрЛП(Спек), СуффиксВложенныхКоманды));
		
	КонсольВывода.ВывестиСтроку("");

	Если Аргументы.Количество() > 0 Тогда
		
		КонсольВывода.ЦветТекста = ЦветТекстаКонсоли;
		КонсольВывода.ВывестиСтроку(СтрШаблон("%2Аргументы:%1%2", Символы.Таб, Символы.ВК));
		ТаблицаОпций = ТаблицаАргументовДляСправки();
		Для каждого СтрокаТаблицы Из ТаблицаОпций Цикл
			
			КонсольВывода.ВывестиСтроку(СтрШаблон("  %3%1%4%2", Символы.Таб, Символы.ВК,СтрокаТаблицы.Наименование, СтрокаТаблицы.Описание));
			
		КонецЦикла;

		КонсольВывода.ВывестиСтроку("");
	

	КонецЕсли;

	
	Если Опции.Количество() > 0 Тогда
		
		КонсольВывода.ЦветТекста = ЦветТекстаКонсоли;
		КонсольВывода.ВывестиСтроку(СтрШаблон("%2Параметры:%1%2", Символы.Таб, Символы.ВК));
		ТаблицаОпций = ТаблицаОпцийДляСправки();
		Для каждого СтрокаТаблицы Из ТаблицаОпций Цикл
			
			КонсольВывода.ВывестиСтроку(СтрШаблон("  %3%1%4%2", Символы.Таб, Символы.ВК,СтрокаТаблицы.Наименование, СтрокаТаблицы.Описание));
			
		КонецЦикла;
		КонсольВывода.ВывестиСтроку("");
		
	КонецЕсли;

	
	Если ВложенныеКоманды.Количество() > 0 Тогда
		
		КонсольВывода.ЦветТекста = ЦветТекстаКонсоли;
		КонсольВывода.ВывестиСтроку(СтрШаблон("%2Доступные команды:%1%2", Символы.Таб, Символы.ВК));
		
		Для каждого ВложеннаяКоманда Из ВложенныеКоманды Цикл
			
			КонсольВывода.ВывестиСтроку(СтрШаблон("  %3%1%4%2", Символы.Таб, Символы.ВК, СтрСоединить(ВложеннаяКоманда.ПолучитьСинонимы(),", "), ВложеннаяКоманда.ПолучитьОписание()));
	
		КонецЦикла;
	
		КонсольВывода.ВывестиСтроку("");
	
		КонсольВывода.ВывестиСтроку(СтрШаблон("Для вывода справки по доступным командам наберите: %1 КОМАНДА %2", ПутьИспользования, "--help"));
		

	КонецЕсли;


	КонсольВывода = Неопределено;
	
	

КонецПроцедуры

Функция ТаблицаАргументовДляСправки()
	
	Таблица = новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Наименование");
	Таблица.Колонки.Добавить("Описание");
	Таблица.Колонки.Добавить("ДлинаНаименования");
	

	Для каждого КлючЗначение Из Аргументы Цикл
		
		АргументСправки = КлючЗначение.Ключ;

		НоваяЗапись = Таблица.Добавить();

		ИмяОпции = АргументСправки.Имя;;
		ПеременныеОкружения = ФорматироватьПеременнуюОкруженияОпцииДляСправки(АргументСправки);
		ЗначениеОпции = ФорматироватьЗначениеОпцииДляСправки(АргументСправки);
		ОписаниеОпции = АргументСправки.Описание + ПеременныеОкружения + ЗначениеОпции; 
	
		НоваяЗапись.Наименование = ИмяОпции;
		НоваяЗапись.Описание = ОписаниеОпции;
		НоваяЗапись.ДлинаНаименования = СтрДлина(ИмяОпции);
		
	КонецЦикла;
	

	Таблица.Сортировать("ДлинаНаименования УБЫВ");
	МаксимальнаяДлина = Таблица[0].ДлинаНаименования;

	Для каждого СтрокаТаблицы Из Таблица Цикл
		
		ТекущаяДлина = СтрДлина(СтрокаТаблицы.Наименование);
		Если ТекущаяДлина = МаксимальнаяДлина Тогда
			Продолжить;
		КонецЕсли;

		СтрокаТаблицы.Наименование = ДополнитьСтрокуПробелами(СтрокаТаблицы.Наименование, МаксимальнаяДлина - ТекущаяДлина)

	КонецЦикла;

	Возврат Таблица;
КонецФункции

Функция ТаблицаОпцийДляСправки()
	
	Таблица = новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Наименование");
	Таблица.Колонки.Добавить("Описание");
	Таблица.Колонки.Добавить("ДлинаНаименования");
	
	Если Опции.Количество() = 0  Тогда
		Возврат Таблица;
	КонецЕсли;

	Для каждого КлючЗначение Из Опции Цикл
		
		ОпцияСправки = КлючЗначение.Ключ;

		НоваяЗапись = Таблица.Добавить();

		ИмяОпции = ФорматироватьИмяОпцииДляСправки(ОпцияСправки);
		ПеременныеОкружения = ФорматироватьПеременнуюОкруженияОпцииДляСправки(ОпцияСправки);
		ЗначениеОпции = ФорматироватьЗначениеОпцииДляСправки(ОпцияСправки);
		ОписаниеОпции = ОпцияСправки.Описание + ПеременныеОкружения + ЗначениеОпции; 
	
		НоваяЗапись.Наименование = ИмяОпции;
		НоваяЗапись.Описание = ОписаниеОпции;
		НоваяЗапись.ДлинаНаименования = СтрДлина(ИмяОпции);

	КонецЦикла;

	Таблица.Сортировать("ДлинаНаименования УБЫВ");
	МаксимальнаяДлина = Таблица[0].ДлинаНаименования;

	Для каждого СтрокаТаблицы Из Таблица Цикл
		
		ТекущаяДлина = СтрДлина(СтрокаТаблицы.Наименование);
		Если ТекущаяДлина = МаксимальнаяДлина Тогда
			Продолжить;
		КонецЕсли;

		СтрокаТаблицы.Наименование = ДополнитьСтрокуПробелами(СтрокаТаблицы.Наименование, МаксимальнаяДлина - ТекущаяДлина)

	КонецЦикла;

	Возврат Таблица;

КонецФункции

Функция ДополнитьСтрокуПробелами(Знач НачальнаяСтрока, КоличествоПробелов)
	
	Для Счетчик = 1 По КоличествоПробелов Цикл
		НачальнаяСтрока = НачальнаяСтрока + " ";
	КонецЦикла;

	Возврат НачальнаяСтрока;

КонецФункции


Функция ФорматироватьИмяОпцииДляСправки(Знач КлассОпции)

	КороткоеНаименование = "";
	ДлинноеНаименование = "";

	Для каждого НаименованиеОпции Из КлассОпции.НаименованияПараметров Цикл
		
		Если СтрДлина(НаименованиеОпции) = 2 
			И ПустаяСтрока(КороткоеНаименование) Тогда
			КороткоеНаименование = НаименованиеОпции;
		КонецЕсли;

		Если СтрДлина(НаименованиеОпции) > 2 
			И ПустаяСтрока(ДлинноеНаименование) Тогда
			ДлинноеНаименование = НаименованиеОпции;
		КонецЕсли;

	КонецЦикла;

	Если Не ПустаяСтрока(КороткоеНаименование) И Не ПустаяСтрока(ДлинноеНаименование) Тогда
		Возврат СтрШаблон("%1, %2", КороткоеНаименование, ДлинноеНаименование);
	ИначеЕсли ЗначениеЗаполнено(КороткоеНаименование) И ПустаяСтрока(ДлинноеНаименование) Тогда
		Возврат СтрШаблон("%1", КороткоеНаименование);
	ИначеЕсли ЗначениеЗаполнено(ДлинноеНаименование) И ПустаяСтрока(КороткоеНаименование) Тогда
		Возврат СтрШаблон("    %1", ДлинноеНаименование);
	КонецЕсли;

	Возврат ""

КонецФункции

Функция ФорматироватьЗначениеОпцииДляСправки(Знач КлассОпции)
	
	Если КлассОпции.СкрытьЗначение
		ИЛИ НЕ ЗначениеЗаполнено(КлассОпции.ЗначениеВСтроку()) Тогда
		Возврат ""
	КонецЕсли;

	Возврат СтрШаблон("(по умолчанию %1)", КлассОпции.ЗначениеВСтроку())

КонецФункции

Функция ФорматироватьПеременнуюОкруженияОпцииДляСправки(Знач КлассОпции)
	
	Если ПустаяСтрока(СокрЛП(КлассОпции.ПеременнаяОкружения)) Тогда
		Возврат "";
	КонецЕсли;
	СтрокаПеременнойОкружения = КлассОпции.ПеременнаяОкружения;
	МассивПО = СтрРазделить(СтрокаПеременнойОкружения, " ", Ложь);

	Результат = "(env";

	СтрокаРазделитель = " ";

	Для ИИ = 0 По МассивПО.ВГраница() Цикл
			
		Если ИИ > 0  Тогда
			СтрокаРазделитель = ", ";
		КонецЕсли;

		Результат = СтрШаблон("%1$%2",СтрокаРазделитель, МассивПО[ИИ]);

	КонецЦикла;

	Возврат Результат + ")";

КонецФункции

Функция ЭтоСинонимКоманды(СтрокаПроверки) Экспорт
	Возврат Не Синонимы.Найти(СтрокаПроверки) = Неопределено;
КонецФункции

Процедура НачалоЗапуска() Экспорт

	КомандыРодителиДляПодчиненной = Новый Массив;
	КомандыРодителиДляПодчиненной.Добавить(Имя);

	Для каждого КомандаРодитель Из КомандыРодители Цикл
		КомандыРодителиДляПодчиненной.Добавить(КомандаРодитель);
	КонецЦикла;

	Для каждого Подчиненнаякоманда Из ВложенныеКоманды Цикл
		Подчиненнаякоманда.КомандыРодители = КомандыРодителиДляПодчиненной;
	КонецЦикла;

	ДобавитьОпцииВИндекс();
	ДобавитьАргументыВИндекс();

	Если ПустаяСтрока(Спек) Тогда
		
		Лог.Отладка("Количество опций строки: %1", Опции.Количество());
		Если Опции.Количество() > 0 Тогда
			Спек = "[OPTIONS] ";
		КонецЕсли;
		Лог.Отладка("Количество аргументы строки: %1", Аргументы.Количество());
		Для каждого арг Из Аргументы Цикл
			Лог.Отладка("Добавляю аргумет <%1> в спек <%2>",арг.Ключ.Имя ,Спек);
			Спек = Спек + арг.Ключ.Имя + " ";
		КонецЦикла;
		
	КонецЕсли;
	//Лог.Отладка("Читаю аргументы строки");
	
	Лексер = Новый Лексер(Спек).Прочитать();
	Если Лексер.ЕстьОшибка() Тогда
		Лексер.ВывестиИнформациюОбОшибке();
		ВызватьИсключение "Ошибка разбора строки использования";
	КонецЕсли;
	
	ТокеныПарсера = Лексер.ПолучитьТокены();

	ПараметрыПарсера =  Новый Структура;
	ПараметрыПарсера.Вставить("Спек", Спек);	
	ПараметрыПарсера.Вставить("Опции", Опции);	
	ПараметрыПарсера.Вставить("Аргументы", Аргументы);	
	ПараметрыПарсера.Вставить("ОпцииИндекс", ОпцииИндекс);	
	ПараметрыПарсера.Вставить("АргументыИндекс", АргументыИндекс);	
	
	парсер = Новый Парсер(ТокеныПарсера, ПараметрыПарсера);
	НачальноеСостояние = парсер.Прочитать();

КонецПроцедуры

Функция Опция(Имя, Значение = "", Описание = "") Экспорт
	
	НоваяОпция = Новый ПараметрКоманды("опция", Имя, Значение, Описание);
	Опции.Вставить(НоваяОпция, НоваяОпция);
	
	
	Возврат НоваяОпция;

КонецФункции

Функция Аргумент(Имя, Значение = "", Описание = "") Экспорт
	
	НовыйАргумент = Новый ПараметрКоманды("аргумент", Имя, Значение, Описание);
	Аргументы.Вставить(НовыйАргумент, НовыйАргумент);
	
	Возврат НовыйАргумент;

КонецФункции

Процедура ДобавитьОпцию(КлассОпции) Экспорт

	Опции.Вставить(КлассОпции, КлассОпции);
	
КонецПроцедуры

Процедура ДобавитьАргумент(КлассАргумент) Экспорт
	
	Аргументы.Вставить(КлассАргумент, КлассАргумент);
		
КонецПроцедуры

Функция ПолучитьОпцииИАргументы(Знач АргументыCLI)
	
	Количество = 0;
	Лог.Отладка("Приверяю аргументы. Количество %1", АргументыCLI.Количество());

	Для каждого ТекущийАргумент Из АргументыCLI Цикл
			
		Для каждого ВложеннаяКоманда Из ВложенныеКоманды Цикл
			
			Лог.Отладка("Ищю подчиненную команду %1", ВложеннаяКоманда.ПолучитьИмяКоманды());
			Если ВложеннаяКоманда.ЭтоСинонимКоманды(ТекущийАргумент) Тогда
				Лог.Отладка("Подчиненная команда %1 найдена", ВложеннаяКоманда.ПолучитьИмяКоманды());
				Возврат Количество;
			КонецЕсли;

		КонецЦикла;

		Количество = Количество +1;
		
	КонецЦикла;

	Возврат Количество;

КонецФункции

Процедура ДобавитьОпцииВИндекс()
	
	Для каждого КлючЗначение Из Опции Цикл
		
		КлассОпции = КлючЗначение.Ключ;
		КлассОпции.ИзПеременнойОкружения();
	
		Для каждого ИмяПараметра Из КлассОпции.НаименованияПараметров Цикл
			
				ОпцииИндекс.Вставить(ИмяПараметра, КлассОпции);
		
		КонецЦикла;
	
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьАргументыВИндекс()
	
	Для каждого КлючЗначение Из Аргументы Цикл
		
		КлассАргумента = КлючЗначение.Ключ;
		КлассАргумента.ИзПеременнойОкружения();
		
		Для каждого ИмяПараметра Из КлассАргумента.НаименованияПараметров Цикл
			
				АргументыИндекс.Вставить(ИмяПараметра, КлассАргумента);
		
		КонецЦикла;
	
	КонецЦикла;

КонецПроцедуры

Функция ВыполнитьОписаниеКоманды(КлассКоманды, Подкоманда)

	Если Не ПроверитьМетодОписаниеКоманды(КлассКоманды) Тогда
		Возврат Подкоманда;
	КонецЕсли;

	ПараметрыВыполнения = Новый Массив;
	ПараметрыВыполнения.Добавить(Подкоманда);

	ОписаниеКоманды = Делегаты.Создать(КлассКоманды, "ОписаниеКоманды");
	ОписаниеКоманды.Исполнить(ПараметрыВыполнения);

	Возврат ПараметрыВыполнения[0];

КонецФункции


Функция ПроверитьМетодВыполнитьКоманду(ПроверяемыйКласс)
	
	Возврат ПроверитьМетодКласса(ПроверяемыйКласс, "ВыполнитьКоманду", 0, Ложь);

КонецФункции

Функция ПроверитьМетодОписаниеКоманды(ПроверяемыйКласс)
	
	Возврат ПроверитьМетодКласса(ПроверяемыйКласс, "ОписаниеКоманды", 1, Ложь);

КонецФункции

Функция НужноВывестиСправку(Знач АргументыCLI)

	Если АргументыCLI.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;

	Лог.Отладка("Вывожу справку: %1", ФлагУстановлен(АргументыCLI, "--help"));
	Возврат ФлагУстановлен(АргументыCLI, "--help");

КонецФункции

Функция ФлагУстановлен(Знач АргументыCLI, Знач Флаг)

	Если АргументыCLI.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат АргументыCLI[0] = Флаг;
	
КонецФункции

Функция ПроверитьМетодКласса(Знач ПроверяемыйКласс,
	Знач ИмяМетода,
	Знач ТребуемоеКоличествоПараметров = 0,
	Знач ЭтоФункция = Ложь)


	ЕстьМетод = РефлекторПроверкиКоманд.МетодСуществует(ПроверяемыйКласс, ИмяМетода);

	Если Не ЕстьМетод Тогда
		Возврат Ложь;
	КонецЕсли;

	ТаблицаМетодов = РефлекторПроверкиКоманд.ПолучитьТаблицуМетодов(ПроверяемыйКласс);
	СтрокаМетода = ТаблицаМетодов.Найти(ИмяМетода, "Имя");
	Если СтрокаМетода = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

	ПроверкаНаФункцию = ЭтоФункция = СтрокаМетода.ЭтоФункция;
	ПроверкаНаКоличествоПараметров = ТребуемоеКоличествоПараметров = СтрокаМетода.КоличествоПараметров;

	//Сообщить(СтрШаблон("Класс %1 метод %2: %3", КлассРеализацииКоманды, ИмяМетода, ПроверкаНаФункцию
	//		И ПроверкаНаКоличествоПараметров ));

	Возврат ПроверкаНаФункцию
		И ПроверкаНаКоличествоПараметров;

КонецФункции // ПроверитьМетодУКласса()


Лог = Логирование.ПолучитьЛог("oscript.lib.1cli");
//Лог.УстановитьУровень(УровниЛога.Отладка);