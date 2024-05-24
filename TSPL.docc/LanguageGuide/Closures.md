# Затваряния

Групирайте код, който се изпълнява заедно, без да създавате именувана функция.

*Затварянията* (closures) представляват самостоятелни блокове функционалност,
които могат да бъдат предавани от едно място на друго и използвани в кода, който пишете.
Затварянията в Swift са подобни на затварянията, анонимните функции, ламбда функциите
и блоковете в други езици за програмиране.

Затварянията могат да прихващат и съхраняват референции към константи и променливи
от контекста, в който са дефинирани.
Това явление е известно като *затваряне върху* тези константи и променливи.
При такова прихващане Swift се грижи за управлението на паметта вместо Вас.

> Забележка: Не се притеснявайте, ако понятието прихващане не Ви е познато.
> То е обяснено подробно по-надолу в <doc:Closures#Capturing-Values>.

Глобалните и вложените функции, представени в <doc:Functions>,
всъщност представляват специални случаи на затваряния.
Затварянията приемат една от следните три форми:

- Глобалните функции са затваряния, които имат име и не прихващат стойности
- Вложените функции са затваряния, които имат име и могат да прихващат стойности от
  съдържащата ги функция
- Затварянията изрази са неименувани затваряния, написани в олекотен синтаксис,
  които могат да прихващат стойности от обкръжаващия ги контекст.

Затварянията изрази на Swift имат чист, ясен стил,
с оптимизации, насърчаващи използването в често срещаните сценарии на съкратен синтаксис, в който няма излишни претрупвания.
Тези оптимизации включват:

- Разпознаване на типовете на параметрите и типовете на връщаните стойности от контекста
- Неявно връщане от затваряния, които представляват един-единствен израз
- Съкратени имена на аргументи
- Синтаксис за затваряне в крайна позиция

## Затваряния изрази

Вложените функции, представени в <doc:Functions#Nested-Functions>,
са удобно средство за именуване и дефиниране на самостоятелни блокове код като част от
по-голяма функция.
Понякога обаче е полезно да се пишат по-кратки версии на конструкти, подобни на функции, 
без пълна декларация и име.
Това важи с особена сила, когато работите с функции или методи, които приемат функции
като един или повече от своите аргументи.

*Затварянията изрази* са начин да се пишат затваряния наред с друг код в
един съкратен и целенасочен синтаксис.
Затварянията изрази предоставят няколко оптимизации на синтаксиса
за писане на затваряния в съкратена форма без загуба на яснота или предназначение.
Примерите на затваряния изрази по-долу илюстрират тези оптимизации,
като усъвършенстват конкретен пример на метода `sorted(by:)` през няколко итерации,
всяка от която изразява една и съща функционалност по по-кратък начин.

### Методът `sorted`

Стандартната библиотека на Swift предоставя метод с име `sorted(by:)`,
който сортира масив от стойности от известен тип,
на базата на върнатата стойност от предоставено от Вас сортиращо затваряне.
След като завърши процеса на сортирането, методът `sorted(by:)` връща нов масив от същия тип и размер
като стария, в който елементите са в правилния подреден ред.
Методът `sorted(by:)` не променя изходния масив.

Примерите на затваряния изрази по-долу сортират масив от `String` стойности в 
обратен азбучен ред чрез метода `sorted(by:)`.
Началният масив, който ще бъде сортиран, е:

```swift
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
```

<!--
  - test: `closureSyntax`

  ```swifttest
  -> let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
  ```
-->

Методът `sorted(by:)` приема затваряне с два аргумента
от същия тип като съдържанието на масива и връщащо `Bool` стойност,
която означава дали първата стойност трябва да бъде преди или след
втората след сортирането.
Сортиращото затваряне трябва да връща `true`, ако мястото на първата стойност
е *преди* втората, и `false` в противен случай.

Този пример е за сортиране на масив от `String` стойности,
така че сортиращото затваряне трябва да е функция от тип `(String, String) -> Bool`.

Един начин да се осигури сортиращо затваряне е да се напише нормална функция от правилния тип,
която да се предаде като аргумент на метода `sorted(by:)`:

```swift
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
// reversedNames е равно на ["Ewa", "Daniella", "Chris", "Barry", "Alex"]
```

<!--
  - test: `closureSyntax`

  ```swifttest
  -> func backward(_ s1: String, _ s2: String) -> Bool {
        return s1 > s2
     }
  -> var reversedNames = names.sorted(by: backward)
  /> reversedNames is equal to \(reversedNames)
  </ reversedNames is equal to ["Ewa", "Daniella", "Chris", "Barry", "Alex"]
  ```
-->

Ако първият низ (`s1`) е по-голям от втория (`s2`),
функцията `backward(_:_:)` ще върне `true`,
указвайки, че `s1` трябва да е преди `s2` в сортирания масив.
За символи от низ "по-голямо от" означава "по-нататък в азбуката в сравнение с".
Това означава, че буквата `"B"` е “по-голяма от” буквата `"A"`,
както и че низът `"Tom"` е по-голям от низа `"Tim"`.
Това ни дава сортиране в обратен азбучен ред, като
`"Barry"` е преди `"Alex"`, и т.н.

Забележете обаче, че това е един излишно подробен начин да се напише това, което
по същесто представлява функция от един израз (`a > b`).
В този пример би било за предпочитане сортиращото затваряне да се напише наред с останалия код
посредством синтаксиса за затваряне израз.

### Синтаксис за затваряне израз

Синтаксисът за затваряне израз има следната обща форма:

```swift
{ (параметри) -> тип на връщаната стойност in
   конструкции
}
```
*Параметри* в синтаксиса за затваряне израз
могат да бъдат in-out параметри, но не могат да имат
подразбираща се стойност.
Можете да използвате вариативни параметри, ако им дадете име.
Също така като типове данни за параметри и тип на връщаната стойност
могат да се използват кортежи.

Следващият пример показва версия на функцията `backward(_:_:)` от по-горе,
написана като израз на затваряне:

```swift
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})
```

<!--
  - test: `closureSyntax`

  ```swifttest
  -> reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
        return s1 > s2
     })
  >> assert(reversedNames == ["Ewa", "Daniella", "Chris", "Barry", "Alex"])
  ```
-->

Забележете, че декларацията на параметрите и типа на връщаната стойност за това
затваряне, което е написано наред с другия код, е идентична с декларацията от функцията `backward(_:_:)`.
И в двата случая тя се пише така: `(s1: String, s2: String) -> Bool`.
При затварянето израз, написано наред с другия код обаче,
параметрите и типът на върнатата стойност са написани *вътре във* фигурните скоби,
не извън тях.

Началото на тялото на затварянето е ключовата дума `in`.
Тази ключова дума показва, че дефиницията на параметрите и типа на върнатата стойност на затварянето
е завършила, а тялото на затварянето започва.

Понеже тялото на затварянето е толкова кратко,
то дори може да бъде написано на един-единствен ред:

```swift
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )
```

<!--
  - test: `closureSyntax`

  ```swifttest
  -> reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )
  >> assert(reversedNames == ["Ewa", "Daniella", "Chris", "Barry", "Alex"])
  ```
-->

Това илюстрира, че въобще извикването на метода `sorted(by:)` е останало едно и също.
Двойка фигурни скоби пак огражда целия аргумент на метода.
Сега обаче този аргумент е затваряне, написано наред с другия код.

### Разпознаване на типа от контекста

Понеже сортиращото затваряне се предава като аргумент на метод,
Swift може да разбере какви са типовете на неговите параметри, както и
типа на стойността, която то връща.
Методът `sorted(by:)` се извиква върху масив от низове,
така че неговият аргумент трябва да бъде функция от типа `(String, String) -> Bool`.
Това означава, че не е необходимо типовете `(String, String)` и `Bool` да бъдат изписвани
като част от дефиницията на израза на затварянето.
Тъй като компилаторът може да разбере какви са всичките типове, стрелката за връщане (`->`) и скобите около
иената на параметрите също могат да бъдат изпуснати:

```swift
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )
```

<!--
  - test: `closureSyntax`

  ```swifttest
  -> reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )
  >> assert(reversedNames == ["Ewa", "Daniella", "Chris", "Barry", "Alex"])
  ```
-->

Винаги е възможно да се разпознаят типовете на параметрите и типът на връщаната стойност,
когато едно затваряне, записано като израз наред с другия код, се предава на функция или метод.
В резултат на това никога няма да е задължително да изписвате такова затваряне, предавано като аргумент,
в пълната му форма.

И все пак бихте могли, ако желаете, да направите типовете изрични, и дори това се насърчава, ако така се 
избягва двусмислието за читателите на Вашия код.
В случая с метода `sorted(by:)` предназначението на затварянето е ясно от факта, че се извършва сортиране,
и е безопасно този, който чете кода, да допусне, че затварянето вероятно работи със `String` стойности,
Тъй като то изпълнява помощна функция при сортирането на масив от низове.

### Неявно връщане на стойност от едноизразни затваряния

Затварянията, които се състоят от един-единствен израз, могат неявно да връщат неговия резултат, като
в тяхната декларация се пропуска ключовата дума `return` --- така,
както е направено в следната версия на предишния пример:

```swift
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )
```

<!--
  - test: `closureSyntax`

  ```swifttest
  -> reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )
  >> assert(reversedNames == ["Ewa", "Daniella", "Chris", "Barry", "Alex"])
  ```
-->

Тук типът функция на аргумента на метода sorted(by:)` ясно определя, че
затварянето трябва да върне `Bool` стойност.
Тъй като тялото на затварянето съдържа единствен израз (`s1 > s2`),
който връща `Bool` стойност, няма двусмислие и ключовата дума `return`
може да бъде изпусната.

### Съкратени имена на аргументи

Swift автоматично предоставя съкратени имена на аргументите на вградените затваряния.
Така стойностите на аргументите на затварянето могат да бъдат реферирани чрез имената `$0`, `$1`, `$2`, и т.н.

Ако използвате тези съкратени имена на аргументи във Вашия израз на затваряне,
можете да пропуснете списъка от аргументи на затварянето от неговата дефиниция.
Типът на аргументите с кратки имена се извлича от очаквания тип функция,
като съкратеният аргумент с най-висок номер определя броя на аргументите, които
затварянето приема. 
Ключовата дума `in` също може да бъде пропусната, тъй като изразът на затварянето
е съставен изцяло от своето тяло:

```swift
reversedNames = names.sorted(by: { $0 > $1 } )
```

<!--
  - test: `closureSyntax`

  ```swifttest
  -> reversedNames = names.sorted(by: { $0 > $1 } )
  >> assert(reversedNames == ["Ewa", "Daniella", "Chris", "Barry", "Alex"])
  ```
-->

Тук `$0` и `$1` се отнасят до първия и втория `String` аргументи на затварянето.
Тъй като `$1` е съкратеният аргумент с най-висок номер,
се приема, че затварянето приема два аргумента.
А вследствие на това, че функцията `sorted(by:)` тук очаква затваряне, всеки от аргументите
на което е низ, и двата съкратени аргумента `$0` и `$1` са от тип `String`.

<!--
  - test: `closure-syntax-arity-inference`

  ```swifttest
  >> let a: [String: String] = [:]
  >> var b: [String: String] = [:]
  >> b.merge(a, uniquingKeysWith: { $1 })
  >> b.merge(a, uniquingKeysWith: { $0 })
  !$ error: contextual closure type '(String, String) throws -> String' expects 2 arguments, but 1 was used in closure body
  !! b.merge(a, uniquingKeysWith: { $0 })
  !! ^
  ```
-->

### Методи за оператори

Всъщност има един още *по-кратък* начин да се запише изразът затваряне от примера по-горе.
Типът `String` на Swift дефинира своя собствена имплементация на оператора по-голямо (`>`), специфична
за низове, като метод, имащ два параметъра от тип `String`,
който връща стойност от тип `Bool`.
Това съвпада точно с типа метод, необходим на метода `sorted(by:)`.
Следователно може просто да предадете като аргумент оператора по-голямо и
Swift ще разбере, че искате да използвате тази негова имплементация, която е специфична за низове:

```swift
reversedNames = names.sorted(by: >)
```

<!--
  - test: `closureSyntax`

  ```swifttest
  -> reversedNames = names.sorted(by: >)
  >> assert(reversedNames == ["Ewa", "Daniella", "Chris", "Barry", "Alex"])
  ```
-->

Повече по отношение на методите за оператори ще намерите в <doc:AdvancedOperators#Operator-Methods>.

## Затваряния в крайна позиция

Ако Ви се налага да предадете затваряне израз към дадена функция като нейн последен аргумент
и този израз е дълъг, би било полезно вместо това да го запишете като *затваряне в крайна позиция*.
Затваряне в крайна позиция се пише след скобите на извикването на функцията, макар и затварянето
да си остава аргумент на функцията.
Когато използвате синтаксиса за затваряне в крайна позиция, не трябва да пишете етикета на аргумента
за първото затваряне като част от извикването на функцията.
Едно извикване на функция може да включва повече от едно затваряне в крайна позиция;
първите няколко примера по-долу обаче използват единствено затваряне.


```swift
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // тяло на функцията
}

// Here's how you call this function without using a trailing closure:

someFunctionThatTakesAClosure(closure: {
    // тяло на затварянето
})

// Here's how you call this function with a trailing closure instead:

someFunctionThatTakesAClosure() {
    // тяло на затваряне в крайна позиция
}
```

<!--
  - test: `closureSyntax`

  ```swifttest
  -> func someFunctionThatTakesAClosure(closure: () -> Void) {
        // function body goes here
     }
  ---
  -> // Here's how you call this function without using a trailing closure:
  ---
  -> someFunctionThatTakesAClosure(closure: {
        // closure's body goes here
     })
  ---
  -> // Here's how you call this function with a trailing closure instead:
  ---
  -> someFunctionThatTakesAClosure() {
        // trailing closure's body goes here
     }
  ```
-->

Затварянето, сортиращо низ, от секцията <doc:Closures#Closure-Expression-Syntax> по-горе
може да бъде записано извън скобите на метода `sorted(by:)` като затваряне в крайна позиция:

```swift
reversedNames = names.sorted() { $0 > $1 }
```

<!--
  - test: `closureSyntax`

  ```swifttest
  -> reversedNames = names.sorted() { $0 > $1 }
  >> assert(reversedNames == ["Ewa", "Daniella", "Chris", "Barry", "Alex"])
  ```
-->

Ако бъде предоставено затваряне израз като единствен аргумент на функцията и
го напишете като затваряне в крайна позиция, не е необходимо да пишете двойка скоби `()`
след името на функцията или метода при извикването:

```swift
reversedNames = names.sorted { $0 > $1 }
```

<!--
  - test: `closureSyntax`

  ```swifttest
  -> reversedNames = names.sorted { $0 > $1 }
  >> assert(reversedNames == ["Ewa", "Daniella", "Chris", "Barry", "Alex"])
  ```
-->

Затварянията в крайна позиция са най-полезни, когато затварянето е достатъчно дълго
и не е възможно то да бъде написано на един ред заедно с другия код.
Като пример да разгледаме типа `Array` на Swift, имащ метод `map(_:)`,
който приема затваряне израз като единствен аргумент.
Затварянето се извиква по веднъж за всеки елемент от масива и връща
друга съответстваща стойност (възможно е тя да е от друг тип) за този елемент.
Вие задавате естеството на това съответствие и типа на върнатата стойност, 
като пишете код в затварянето, което предавате на `map(_:)`.

След като приложи даденото затваряне към всеки елемент на масива,
методът `map(_:)` връща нов масив, съдържащ всичките нови съпоставени стойности
в същия ред като техните съответни стойности от първоначалния масив.

Ето как бихте могли да използвате метода `map(_:)` със затваряне в крайна позиция,
за да пребразувате масив от `Int` стойности в масив от `String` стойности.
Масивът `[16, 58, 510]` се използва, за да се създаде новият масив
`["OneSix", "FiveEight", "FiveOneZero"]`:

```swift
let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]
```

<!--
  - test: `arrayMap`

  ```swifttest
  -> let digitNames = [
        0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
        5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
     ]
  -> let numbers = [16, 58, 510]
  ```
-->

Кодът по-горе създава речник от съответствия между
целочислените цифри и версиите на техните имена на английски език.
Той също така дефинира масив от цели числа, готови да бъдат преобразувани в низове.

Сега вече можете да използвате масива `numbers`, за да създадете масив от `String` стойности,
като предадете затваряне израз на метода `map(_:)` на масива като затваряне в крайна позиция:

```swift
let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}
// strings се определя да е от тип [String]
// неговата стойност е ["OneSix", "FiveEight", "FiveOneZero"]
```

<!--
  - test: `arrayMap`

  ```swifttest
  -> let strings = numbers.map { (number) -> String in
        var number = number
        var output = ""
        repeat {
           output = digitNames[number % 10]! + output
           number /= 10
        } while number > 0
        return output
     }
  // strings is inferred to be of type [String]
  /> its value is [\"\(strings[0])\", \"\(strings[1])\", \"\(strings[2])\"]
  </ its value is ["OneSix", "FiveEight", "FiveOneZero"]
  ```
-->

Методът `map(_:)` извиква затварянето израз веднъж за всеки елемент от масива.
Не е необходимо да указвате типа на входния параметър на затварянето, `number`,
тъй като типът може да бъде определен от стойностите в масива, които ще бъдат съпоставяни.

В този пример променливата `number` се инициализира със стойността на параметъра `number` на затварянето,
така че стойността може да бъде променяна вътре в тялото на затварянето.
(Параметрите на функции и затваряния винаги са константи.)
Също така затварянето израз указва тип за връщане `String`,
за да посочи типа, който ще бъде съхранен в съпоставения изходен масив.

Затварянето израз изгражда низ, наречен `output`, всеки път, когато бъде извикано.
То изчислява последната цифра на `number` с помощта на оператора остатък при деление (`number % 10`)
и използва тази цифра, за да потърси подходящ низ в речника `digitNames`.
Затварянето може да се използва за създаване на низово представяне на всяко цяло число, по-голямо от нула.

> Забележка: Извикването на индекса на речника `digitNames`
> е следвано от удивителен знак (`!`),
> тъй като индексите на речници връщат незадължителна стойност,
> с което се означава, че търсенето в речника може да е неуспешно, ако ключът не съществува.
> В примера по-горе е гарантирано, че `number % 10`
> винаги ще бъде валиден ключ за речника `digitNames`,
> така че се използва удивителен знак, за да се премахне принудително обвивката от `String` стойността,
> съхранена в незадължителната стойност за връщане на индекса.

Низът, извлечен от речника `digitNames`,
се добавя към *предната част* на `output`,
което по същество представлява изграждане на низова версия на числото в обратен ред.
(Изразът `number % 10` дава стойност
`6` за `16`, `8` за `58` и `0` за `510`.)

След това променливата`number` се дели на `10`.
Тъй като стойността е целочислена, тя се закръглява надолу по време на делението,
така че `16` става `1`, `58` става `5`, а `510` става `51`.

Процесът се повтаря дотогава, докато стойността `number` стане равна на `0`,
при което затварянето връща низа `output`,
който се добавя към изходния масив от метода `map(_:)`.

Употребата на синтаксис за затваряне в крайна позиция в примера по-горе
по ясен начин капсулира функционалността на затварянето
незабавно след функцията, която това затваряне поддържа,
без да трябва да обвива цялото затваряне вътре във външните
скоби на метода `map(_:)`.

Ако дадена функция приема множество затваряния в крайна позиция,
трябва да пропуснете етикета на аргумента за първото затваряне
и да поставите етикетите на останалите затваряния.
Например функцията по-долу зарежда картина в галерия със снимки:

```swift
func loadPicture(from server: Server, completion: (Picture) -> Void, onFailure: () -> Void) {
    if let picture = download("photo.jpg", from: server) {
        completion(picture)
    } else {
        onFailure()
    }
}
```

<!--
  - test: `multiple-trailing-closures`

  ```swifttest
  >> struct Server { }
  >> struct Picture { }
  >> func download(_ path: String, from server: Server) -> Picture? {
  >>     return Picture()
  >> }
  -> func loadPicture(from server: Server, completion: (Picture) -> Void, onFailure: () -> Void) {
         if let picture = download("photo.jpg", from: server) {
             completion(picture)
         } else {
             onFailure()
         }
     }
  ```
-->

Когато извиквате тази функция, за да заредите картина,
трябва да предоставите две затваряния.
Първото служи за обработка при нормално приключване, 
която показва картината след успешно сваляне.
Второто затваряне е функция за обработка на грешката,
която показва грешката на потребителя.

```swift
loadPicture(from: someServer) { picture in
    someView.currentPicture = picture
} onFailure: {
    print("Не може да бъде свалена следващата картина.")
}
```

<!--
  - test: `multiple-trailing-closures`

  ```swifttest
  >> struct View {
  >>    var currentPicture = Picture() { didSet { print("Changed picture") } }
  >> }
  >> var someView = View()
  >> let someServer = Server()
  -> loadPicture(from: someServer) { picture in
         someView.currentPicture = picture
     } onFailure: {
         print("Couldn't download the next picture.")
     }
  << Changed picture
  ```
-->

В този пример функцията `loadPicture(from:completion:onFailure:)` изпраща своята мрежова задача
за обработка на заден план и извиква един от двата блока за обработка при приключване, когато мрежовата задача
завърши.
Съставянето на функцията по този начин позволява ясно да се раздели кодът, който е отговорен за
обработката на мрежова грешка от кода, който актуализира потребителския интерфейс след успешно сваляне,
вместо да се използва само едно затваряне, което да обработва и двата тези случая.

> Забележка: Блоковете за обработка при приключване може да станат трудни за четене,
> особено когато трябва да се вложат повече от един такива.
> Един алтернативен подход е да се използва асинхронен код,
> както е описано в <doc:Concurrency>.

## Прихващане на стойности

Едно затваряне може да *прихваща* константи и промениливи
от обграждащия контекст, в който то е дефинирано.
След това затварянето може да указва към и променя
стойностите на тези константи и променливи в рамките на своето тяло,
дори ако оригиналният обхват, който е дефинирал константите и променливите, вече не съществува.

В Swift най-простата форма на затваряне, което може да прихваща стойности, е вложена функция,
написана вътре в тялото на друга функция.
Една вложена функция може да прихваща всеки от аргументите на външната функция,
както и всяка от константите и променливите, дефинирани във външната функция.

Ето един пример на функция, наречена `makeIncrementer`,
която съдържа вложена функция, наречена `incrementer`.
Вложената функция `incrementer()` прихваща две стойности,
`runningTotal` и `amount`,
от окръжаващия я контекст.
След прихащането на тези стойности
`incrementer` бива върната от `makeIncrementer` като затваряне,
което инкрементира `runningTotal` с `amount` при всяко свое извикване.

```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
```

<!--
  - test: `closures`

  ```swifttest
  -> func makeIncrementer(forIncrement amount: Int) -> () -> Int {
        var runningTotal = 0
        func incrementer() -> Int {
           runningTotal += amount
           return runningTotal
        }
        return incrementer
     }
  ```
-->

Типът, който `makeIncrementer` връща, е `() -> Int`.
Това означава, че тя връща *функция* вместо проста стойност.
Тази върната функция няма параметри и връща `Int` стойност при всяко свое извикване.
За да научите как функциите могат да връщат други функции, вижте
<doc:Functions#Function-Types-as-Return-Types>.

Функцията `makeIncrementer(forIncrement:)` дефинира целочислена променлива, наречена `runningTotal`,
за да съхрани текущо изчислената обща стойност на инкрементора, която ще бъде върната.
Тази променлива се инициализира със стойност `0`.

Функцията `makeIncrementer(forIncrement:)` има единствен параметър от тип `Int`
с аргументен етикет `forIncrement` и име на параметъра `amount`.
Аргументата стойност, предадена на този параметър, определя
с колко ще се инкрементира `runningTotal`
при всяко извикване на инкрементиращата функция.
Функцията `makeIncrementer` дефинира вложена функция, наречена `incrementer`,
която извършва същинското инкрементиране.
Тази функция просто добавя `amount` към `runningTotal` и връща резултата.

Използвана изолирано,
вложената функция `incrementer()` може да изглежда необичайно:

```swift
func incrementer() -> Int {
    runningTotal += amount
    return runningTotal
}
```

<!--
  - test: `closuresPullout`

  ```swifttest
  -> func incrementer() -> Int {
  >>    var runningTotal = 0
  >>    let amount = 1
        runningTotal += amount
        return runningTotal
     }
  ```
-->

??????????s

The `incrementer()` function doesn't have any parameters,
and yet it refers to `runningTotal` and `amount` from within its function body.
It does this by capturing a *reference* to `runningTotal` and `amount`
from the surrounding function and using them within its own function body.
Capturing by reference ensures that `runningTotal` and `amount` don't disappear
when the call to `makeIncrementer` ends,
and also ensures that `runningTotal` is available
the next time the `incrementer` function is called.

> Note: As an optimization,
> Swift may instead capture and store a *copy* of a value
> if that value isn't mutated by a closure,
> and if the value isn't mutated after the closure is created.
>
> Swift also handles all memory management involved in disposing of
> variables when they're no longer needed.

Here's an example of `makeIncrementer` in action:

```swift
let incrementByTen = makeIncrementer(forIncrement: 10)
```

<!--
  - test: `closures`

  ```swifttest
  -> let incrementByTen = makeIncrementer(forIncrement: 10)
  ```
-->

This example sets a constant called `incrementByTen`
to refer to an incrementer function that adds `10` to
its `runningTotal` variable each time it's called.
Calling the function multiple times shows this behavior in action:

```swift
incrementByTen()
// returns a value of 10
incrementByTen()
// returns a value of 20
incrementByTen()
// returns a value of 30
```

<!--
  - test: `closures`

  ```swifttest
  >> let r0 =
  -> incrementByTen()
  /> returns a value of \(r0)
  </ returns a value of 10
  >> let r1 =
  -> incrementByTen()
  /> returns a value of \(r1)
  </ returns a value of 20
  >> let r2 =
  -> incrementByTen()
  /> returns a value of \(r2)
  </ returns a value of 30
  ```
-->

<!--
  Rewrite the above to avoid discarding the function's return value.
  Tracking bug is <rdar://problem/35301593>
-->

If you create a second incrementer,
it will have its own stored reference to a new, separate `runningTotal` variable:

```swift
let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven()
// returns a value of 7
```

<!--
  - test: `closures`

  ```swifttest
  -> let incrementBySeven = makeIncrementer(forIncrement: 7)
  >> let r3 =
  -> incrementBySeven()
  /> returns a value of \(r3)
  </ returns a value of 7
  ```
-->

Calling the original incrementer (`incrementByTen`) again
continues to increment its own `runningTotal` variable,
and doesn't affect the variable captured by `incrementBySeven`:

```swift
incrementByTen()
// returns a value of 40
```

<!--
  - test: `closures`

  ```swifttest
  >> let r4 =
  -> incrementByTen()
  /> returns a value of \(r4)
  </ returns a value of 40
  ```
-->

> Note: If you assign a closure to a property of a class instance,
> and the closure captures that instance by referring to the instance or its members,
> you will create a strong reference cycle between the closure and the instance.
> Swift uses *capture lists* to break these strong reference cycles.
> For more information, see <doc:AutomaticReferenceCounting#Strong-Reference-Cycles-for-Closures>.

## Closures Are Reference Types

In the example above,
`incrementBySeven` and `incrementByTen` are constants,
but the closures these constants refer to are still able to increment
the `runningTotal` variables that they have captured.
This is because functions and closures are *reference types*.

Whenever you assign a function or a closure to a constant or a variable,
you are actually setting that constant or variable to be
a *reference* to the function or closure.
In the example above,
it's the choice of closure that `incrementByTen` *refers to* that's constant,
and not the contents of the closure itself.

This also means that if you assign a closure to two different constants or variables,
both of those constants or variables refer to the same closure.

```swift
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()
// returns a value of 50

incrementByTen()
// returns a value of 60
```

<!--
  - test: `closures`

  ```swifttest
  -> let alsoIncrementByTen = incrementByTen
  >> let r5 =
  -> alsoIncrementByTen()
  /> returns a value of \(r5)
  </ returns a value of 50
  ---
  >> let r6 =
  -> incrementByTen()
  /> returns a value of \(r6)
  </ returns a value of 60
  ```
-->

The example above shows that calling `alsoIncrementByTen`
is the same as calling `incrementByTen`.
Because both of them refer to the same closure,
they both increment and return the same running total.

## Escaping Closures

A closure is said to *escape* a function
when the closure is passed as an argument to the function,
but is called after the function returns.
When you declare a function that takes a closure as one of its parameters,
you can write `@escaping` before the parameter's type
to indicate that the closure is allowed to escape.

One way that a closure can escape
is by being stored in a variable that's defined outside the function.
As an example,
many functions that start an asynchronous operation
take a closure argument as a completion handler.
The function returns after it starts the operation,
but the closure isn't called until the operation is completed ---
the closure needs to escape, to be called later.
For example:

```swift
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
```

<!--
  - test: `noescape-closure-as-argument, implicit-self-struct`

  ```swifttest
  -> var completionHandlers: [() -> Void] = []
  -> func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
         completionHandlers.append(completionHandler)
     }
  ```
-->

The `someFunctionWithEscapingClosure(_:)` function takes a closure as its argument
and adds it to an array that's declared outside the function.
If you didn't mark the parameter of this function with `@escaping`,
you would get a compile-time error.

An escaping closure that refers to `self`
needs special consideration if `self` refers to an instance of a class.
Capturing `self` in an escaping closure
makes it easy to accidentally create a strong reference cycle.
For information about reference cycles,
see <doc:AutomaticReferenceCounting>.

Normally, a closure captures variables implicitly
by using them in the body of the closure,
but in this case you need to be explicit.
If you want to capture `self`,
write `self` explicitly when you use it,
or include `self` in the closure's capture list.
Writing `self` explicitly lets you express your intent,
and reminds you to confirm that there isn't a reference cycle.
For example, in the code below,
the closure passed to `someFunctionWithEscapingClosure(_:)`
refers to `self` explicitly.
In contrast, the closure passed to `someFunctionWithNonescapingClosure(_:)`
is a nonescaping closure, which means it can refer to `self` implicitly.

```swift
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)
// Prints "200"

completionHandlers.first?()
print(instance.x)
// Prints "100"
```

<!--
  - test: `noescape-closure-as-argument`

  ```swifttest
  -> func someFunctionWithNonescapingClosure(closure: () -> Void) {
         closure()
     }
  ---
  -> class SomeClass {
         var x = 10
         func doSomething() {
             someFunctionWithEscapingClosure { self.x = 100 }
             someFunctionWithNonescapingClosure { x = 200 }
         }
     }
  ---
  -> let instance = SomeClass()
  -> instance.doSomething()
  -> print(instance.x)
  <- 200
  ---
  -> completionHandlers.first?()
  -> print(instance.x)
  <- 100
  ```
-->

Here's a version of `doSomething()` that captures `self`
by including it in the closure's capture list,
and then refers to `self` implicitly:

```swift
class SomeOtherClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { [self] in x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}
```

<!--
  - test: `noescape-closure-as-argument`

  ```swifttest
  -> class SomeOtherClass {
         var x = 10
         func doSomething() {
             someFunctionWithEscapingClosure { [self] in x = 100 }
             someFunctionWithNonescapingClosure { x = 200 }
         }
     }
  >> completionHandlers = []
  >> let instance2 = SomeOtherClass()
  >> instance2.doSomething()
  >> print(instance2.x)
  << 200
  >> completionHandlers.first?()
  >> print(instance2.x)
  << 100
  ```
-->

If `self` is an instance of a structure or an enumeration,
you can always refer to `self` implicitly.
However,
an escaping closure can't capture a mutable reference to `self`
when `self` is an instance of a structure or an enumeration.
Structures and enumerations don’t allow shared mutability,
as discussed in <doc:ClassesAndStructures#Structures-and-Enumerations-Are-Value-Types>.

```swift
struct SomeStruct {
    var x = 10
    mutating func doSomething() {
        someFunctionWithNonescapingClosure { x = 200 }  // Ok
        someFunctionWithEscapingClosure { x = 100 }     // Error
    }
}
```

<!--
  - test: `struct-capture-mutable-self`

  ```swifttest
  >> var completionHandlers: [() -> Void] = []
  >> func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
  >>     completionHandlers.append(completionHandler)
  >> }
  >> func someFunctionWithNonescapingClosure(closure: () -> Void) {
  >>     closure()
  >> }
  -> struct SomeStruct {
         var x = 10
         mutating func doSomething() {
             someFunctionWithNonescapingClosure { x = 200 }  // Ok
             someFunctionWithEscapingClosure { x = 100 }     // Error
         }
     }
  !$ error: escaping closure captures mutating 'self' parameter
  !! someFunctionWithEscapingClosure { x = 100 }     // Error
  !! ^
  !$ note: captured here
  !! someFunctionWithEscapingClosure { x = 100 }     // Error
  !! ^
  ```
-->

The call to the `someFunctionWithEscapingClosure` function
in the example above is an error
because it's inside a mutating method,
so `self` is mutable.
That violates the rule that escaping closures can't capture
a mutable reference to `self` for structures.

<!--
  - test: `noescape-closure-as-argument`

  ```swifttest
  // Test the non-error portion of struct-capture-mutable-self
  >> struct SomeStruct {
  >>     var x = 10
  >>     mutating func doSomething() {
  >>         someFunctionWithNonescapingClosure { x = 200 }
  >>     }
  >> }
  ---
  >> completionHandlers = []
  >> var instance3 = SomeStruct()
  >> instance3.doSomething()
  >> print(instance3.x)
  << 200
  ```
-->

<!--
  - test: `noescape-closure-as-argument`

  ```swifttest
  >> struct S {
  >>     var x = 10
  >>     func doSomething() {
  >>         someFunctionWithEscapingClosure { print(x) }  // OK
  >>     }
  >> }
  ---
  >> completionHandlers = []
  >> var s = S()
  >> s.doSomething()
  >> s.x = 99  // No effect on self.x already captured -- S is a value type
  >> completionHandlers.first?()
  << 10
  ```
-->

## Autoclosures

An *autoclosure* is a closure that's automatically created
to wrap an expression that's being passed as an argument to a function.
It doesn't take any arguments,
and when it's called, it returns the value
of the expression that's wrapped inside of it.
This syntactic convenience lets you omit braces around a function's parameter
by writing a normal expression instead of an explicit closure.

It's common to *call* functions that take autoclosures,
but it's not common to *implement* that kind of function.
For example,
the `assert(condition:message:file:line:)` function
takes an autoclosure for its `condition` and `message` parameters;
its `condition` parameter is evaluated only in debug builds
and its `message` parameter is evaluated only if `condition` is `false`.

An autoclosure lets you delay evaluation,
because the code inside isn't run until you call the closure.
Delaying evaluation is useful for code
that has side effects or is computationally expensive,
because it lets you control when that code is evaluated.
The code below shows how a closure delays evaluation.

```swift
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)
// Prints "5"

let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// Prints "5"

print("Now serving \(customerProvider())!")
// Prints "Now serving Chris!"
print(customersInLine.count)
// Prints "4"
```

<!--
  - test: `autoclosures`

  ```swifttest
  -> var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
  -> print(customersInLine.count)
  <- 5
  ---
  -> let customerProvider = { customersInLine.remove(at: 0) }
  -> print(customersInLine.count)
  <- 5
  ---
  -> print("Now serving \(customerProvider())!")
  <- Now serving Chris!
  -> print(customersInLine.count)
  <- 4
  ```
-->

<!--
  Using remove(at:) instead of popFirst() because the latter only works
  with ArraySlice, not with Array:
      customersInLine[0..<3].popLast()     // fine
      customersInLine[0..<3].popFirst()    // fine
      customersInLine.popLast()            // fine
      customersInLine.popFirst()           // FAIL
  It also returns an optional, which complicates the listing.
-->

<!--
  TODO: It may be worth describing the differences between ``lazy`` and autoclousures.
-->

Even though the first element of the `customersInLine` array is removed
by the code inside the closure,
the array element isn't removed until the closure is actually called.
If the closure is never called,
the expression inside the closure is never evaluated,
which means the array element is never removed.
Note that the type of `customerProvider` isn't `String`
but `() -> String` ---
a function with no parameters that returns a string.

You get the same behavior of delayed evaluation
when you pass a closure as an argument to a function.

```swift
// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
// Prints "Now serving Alex!"
```

<!--
  - test: `autoclosures-function`

  ```swifttest
  >> var customersInLine = ["Alex", "Ewa", "Barry", "Daniella"]
  /> customersInLine is \(customersInLine)
  </ customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
  -> func serve(customer customerProvider: () -> String) {
         print("Now serving \(customerProvider())!")
     }
  -> serve(customer: { customersInLine.remove(at: 0) } )
  <- Now serving Alex!
  ```
-->

The `serve(customer:)` function in the listing above
takes an explicit closure that returns a customer's name.
The version of `serve(customer:)` below
performs the same operation but, instead of taking an explicit closure,
it takes an autoclosure
by marking its parameter's type with the `@autoclosure` attribute.
Now you can call the function
as if it took a `String` argument instead of a closure.
The argument is automatically converted to a closure,
because the `customerProvider` parameter's type is marked
with the `@autoclosure` attribute.

```swift
// customersInLine is ["Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
// Prints "Now serving Ewa!"
```

<!--
  - test: `autoclosures-function-with-autoclosure`

  ```swifttest
  >> var customersInLine = ["Ewa", "Barry", "Daniella"]
  /> customersInLine is \(customersInLine)
  </ customersInLine is ["Ewa", "Barry", "Daniella"]
  -> func serve(customer customerProvider: @autoclosure () -> String) {
         print("Now serving \(customerProvider())!")
     }
  -> serve(customer: customersInLine.remove(at: 0))
  <- Now serving Ewa!
  ```
-->

> Note: Overusing autoclosures can make your code hard to understand.
> The context and function name should make it clear
> that evaluation is being deferred.

If you want an autoclosure that's allowed to escape,
use both the `@autoclosure` and `@escaping` attributes.
The `@escaping` attribute is described above in <doc:Closures#Escaping-Closures>.

```swift
// customersInLine is ["Barry", "Daniella"]
var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
}
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))

print("Collected \(customerProviders.count) closures.")
// Prints "Collected 2 closures."
for customerProvider in customerProviders {
    print("Now serving \(customerProvider())!")
}
// Prints "Now serving Barry!"
// Prints "Now serving Daniella!"
```

<!--
  - test: `autoclosures-function-with-escape`

  ```swifttest
  >> var customersInLine = ["Barry", "Daniella"]
  /> customersInLine is \(customersInLine)
  </ customersInLine is ["Barry", "Daniella"]
  -> var customerProviders: [() -> String] = []
  -> func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
         customerProviders.append(customerProvider)
     }
  -> collectCustomerProviders(customersInLine.remove(at: 0))
  -> collectCustomerProviders(customersInLine.remove(at: 0))
  ---
  -> print("Collected \(customerProviders.count) closures.")
  <- Collected 2 closures.
  -> for customerProvider in customerProviders {
         print("Now serving \(customerProvider())!")
     }
  <- Now serving Barry!
  <- Now serving Daniella!
  ```
-->

In the code above,
instead of calling the closure passed to it
as its `customerProvider` argument,
the `collectCustomerProviders(_:)` function
appends the closure to the `customerProviders` array.
The array is declared outside the scope of the function,
which means the closures in the array can be executed after the function returns.
As a result,
the value of the `customerProvider` argument
must be allowed to escape the function's scope.

> Beta Software:
>
> This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.
>
> Learn more about using [Apple's beta software](https://developer.apple.com/support/beta-software/).

<!--
This source file is part of the Swift.org open source project

Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
Licensed under Apache License v2.0 with Runtime Library Exception

See https://swift.org/LICENSE.txt for license information
See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
-->
