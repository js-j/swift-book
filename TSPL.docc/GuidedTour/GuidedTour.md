# Обиколка из Swift

Изследвайте възможностите и синтаксиса на Swift.

Традицията повелява първата програма в един нов език
да изведе думите "Здравейте!" (англ. "Hello, world!" - бел. прев.) на екрана.
В Swift това може да се направи с един-единствен ред:

<!--
  K&R използва “здравейте”.
  Изглежда си струва да се наруши традицията, за да се използва
  правилно първата главна буква.
-->

```swift
print("Здравейте!")
// Извежда "Здравейте!"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> print("Hello, world!")
  <- Hello, world!
  ```
-->

Този синтаксис би трябвало да Ви изглежда познат, ако познавате друг език ---
в Swift този ред код е цяла програма.
Не е необходимо да се импортира отделна библиотека, ако е необходима функционалност
като извеждане на текст или обработка на низове.
Кодът, написан в глобалния обхват, се използва като входна точка за програмата,
поради което няма нужда от функция `main()`.
Също така не е необходимо да пишете знака точка и запетая накрая на всяка конструкция.

Тази обиколка Ви дава достатъчно информация,
за да започнете да пишете код на Swift, 
като Ви показва как да извършите разнообразни задачи от програмирането.
Не се притеснявайте, ако не разбирате нещо ---
всичко, което е представено тук, е обяснено подробно в 
останалата част на книгата.

## Прости стойности

Използвайте `let`, за да създадете константа, и `var` за променлива.
Не е задължително стойността на една константа да бъде известна по време на компилирането,
но трябва да й зададете стойност точно веднъж.
Това означава, че посредством константите давате име на стойност,
която определяте веднъж, но използвате на много места.

```swift
var myVariable = 42
myVariable = 50
let myConstant = 42
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> var myVariable = 42
  -> myVariable = 50
  -> let myConstant = 42
  ```
-->

Една константа или променлива трябва да има същия тип
като стойността, която искате да й присвоите.
Но не винаги е необходимо да указвате типа изрично.
Предоставянето на стойност при създаване на константа или променлива
позволява на компилатора да разпознае нейния тип.
В примера по-горе компилаторът разпознава, че `myVariable` е целочислен тип,
защото началната й стойност е цяло число.

Ако началната стойност не предоставя достатъчно информация
(или ако няма начална стойност),
укажете типа, като го напишете след променливата, разделяйки ги
с двоеточие.

```swift
let implicitInteger = 70
let implicitDouble = 70.0
let explicitDouble: Double = 70
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let implicitInteger = 70
  -> let implicitDouble = 70.0
  -> let explicitDouble: Double = 70
  ```
-->

> Експериментирайте: Създайте константа с изричен тип
> `Float` и стойност `4`.

Стойностите никога не се преобразуват неявно към друг тип.
Ако е необходимо да преобразувате дадена стойност в друг тип,
явно създайте екземпляр на желания тип.

```swift
let label = "Ширината е "
let width = 94
let widthLabel = label + String(width)
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let label = "The width is "
  -> let width = 94
  -> let widthLabel = label + String(width)
  >> print(widthLabel)
  << The width is 94
  ```
-->

> Експериментирайте: Опитайте да премахнете преобразуването към `String` от последния ред.
> Каква грешка получавате?

<!--
  TODO: Discuss with Core Writers ---
  are these experiments that make you familiar with errors
  helping you learn something?
-->

Има един още по-прост начин да включвате стойности в низове:
Напишете стойността в скоби, като поставите обратно наклонена
черта (`\`) преди скобите.
Например:

```swift
let apples = 3
let oranges = 5
let appleSummary = "Имам \(apples) ябълки."
let fruitSummary = "Имам \(apples + oranges) броя плод."
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let apples = 3
  -> let oranges = 5
  -> let appleSummary = "I have \(apples) apples."
  >> print(appleSummary)
  << I have 3 apples.
  -> let fruitSummary = "I have \(apples + oranges) pieces of fruit."
  >> print(fruitSummary)
  << I have 8 pieces of fruit.
  ```
-->

> Експериментирайте: Използвайте `\()`, за да
> включите изчисление с плаваща запетая в низ
> и нечие име в поздрав.

Използвайте три двойни кавички (`"""`) за низове,
които заемат повече от един ред.
Отстъпът в началото на всеки от редовете се премахва,
стига да съответства на отстъпа на обграждащите кавички.
Например:


```swift
let quotation = """
        Независимо че отляво има празно пространство,
        действителните редове нямат отстъп.
            С изключение на този ред.
        Знакът за кавички (") може да присъства без да е предхождан от escape-последователност.

        Все още имам \(apples + oranges) броя плод.
        """
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let quotation = """
     I said "I have \(apples) apples."
     And then I said "I have \(apples + oranges) pieces of fruit."
     """
  ```
-->

<!--
  Can't show an example of indentation in the triple-quoted string above.
  <rdar://problem/49129068> Swift code formatting damages indentation
-->

Създавайте масиви и речници с помощта на скоби (`[]`).
Осъществявайте достъп до техните елементи, като записвате
индекса или ключа в скобите.
Позволено е да има запетая след последния елемент.

<!--
  REFERENCE
  The list of fruits comes from the colors that the original iMac came in,
  following the initial launch of the iMac in Bondi Blue, ordered by SKU --
  which also lines up with the order they appeared in ads:

       M7389LL/A (266 MHz Strawberry)
       M7392LL/A (266 MHz Lime)
       M7391LL/A (266 MHz Tangerine)
       M7390LL/A (266 MHz Grape)
       M7345LL/A (266 MHz Blueberry)

       M7441LL/A (333 MHz Strawberry)
       M7444LL/A (333 MHz Lime)
       M7443LL/A (333 MHz Tangerine)
       M7442LL/A (333 MHz Grape)
       M7440LL/A (333 MHz Blueberry)
-->

<!--
  REFERENCE
  Occupations is a reference to Firefly,
  specifically to Mal's joke about Jayne's job on the ship.

  Can't find the specific episode,
  but it shows up in several lists of Firefly "best of" quotes:

  Mal: Jayne, you will keep a civil tongue in that mouth, or I will sew it shut.
       Is there an understanding between us?
  Jayne: You don't pay me to talk pretty. [...]
  Mal: Walk away from this table. Right now.
  [Jayne loads his plate with food and leaves]
  Simon: What *do* you pay him for?
  Mal: What?
  Simon: I was just wondering what his job is - on the ship.
  Mal: Public relations.
-->

```swift
var fruits = ["strawberries", "limes", "tangerines"]
fruits[1] = "grapes"

var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
 ]
occupations["Jayne"] = "Public Relations"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> var fruits = ["strawberries", "limes", "tangerines"]
  -> fruits[1] = "grapes"
  ---
  -> var occupations = [
         "Malcolm": "Captain",
         "Kaylee": "Mechanic",
      ]
  -> occupations["Jayne"] = "Public Relations"
  ```
-->

<!-- Apple Books screenshot begins here. -->

С добавянето на още елементи масивите автоматично се преоразмеряват.

```swift
fruits.append("blueberries")
print(fruits)
// Prints "["strawberries", "grapes", "tangerines", "blueberries"]"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> fruits.append("blueberries")
  -> print(fruits)
  <- ["strawberries", "grapes", "tangerines", "blueberries"]
  ```
-->

Квадратните скоби се използват също така за означаване на празен масив или речник.
За масив изпишете `[]`,
за речник - `[:]`.

```swift
fruits = []
occupations = [:]
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> fruits = []
  -> occupations = [:]
  ```
-->

Ако присвоявате празен масив или речник на нова променлива
или другаде, където няма информация за типа,
ще трябва го да укажете.

```swift
let emptyArray: [String] = []
let emptyDictionary: [String: Float] = [:]
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let emptyArray: [String] = []
  -> let emptyDictionary: [String: Float] = [:]
  ---
  -> let anotherEmptyArray = [String]()
  -> let emptyDictionary = [String: Float]()
  ```
-->

## Управление на потока на изпълнението

Използвайте `if` и `switch`, за да създавате условни конструкции,
както и  `for`-`in`, `while` и `repeat`-`while` за цикли.
Скобите около условието или променливата за цикъл са незадължителни.
Фигурните скоби около тялото не могат да бъдат изпуснати.

```swift
let individualScores = [75, 43, 103, 87, 12]
var teamScore = 0
for score in individualScores {
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}
print(teamScore)
// Извежда "11"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let individualScores = [75, 43, 103, 87, 12]
  -> var teamScore = 0
  -> for score in individualScores {
         if score > 50 {
             teamScore += 3
         } else {
             teamScore += 1
         }
     }
  -> print(teamScore)
  <- 11
  ```
-->

<!--
  REFERENCE
  Jelly babies are a candy/sweet that was closely associated
  with past incarnations of the Doctor in Dr. Who.
-->

<!--
  -> let haveJellyBabies = true
  -> if haveJellyBabies {
     }
  << Would you like a jelly baby?
-->

В една `if` конструкция условието трябва да бъде
булев израз --- това означава, че код от вида на
`if score { ... }` е грешка,
а не неявно сравнение с нула.

Можете да пишете `if` или `switch`
след знака за равенство (`=`) на конструкция за присвояване
или след `return`,
за да се избере стойност на базата на условието.

```swift
let scoreDecoration = if teamScore > 10 {
    "🎉"
} else {
    ""
}
print("Score:", teamScore, scoreDecoration)
// Отпечатва "Score: 11 🎉"
```

Можете да използвате `if` и `let` заедно,
за да работите със стойности, които може да липсват.
Тези стойности се представят като незадължителни.
Незадължителна стойност (Optional) е такава, която или съдържа
стойност, или `nil`, което означава, че липсва стойност.
Добавете знак за въпросителна (`?`) след типа на дадена стойност,
за да я отбележите като незадължителна.

<!-- Apple Books screenshot ends here. -->

<!--
  REFERENCE
  John Appleseed is a stock Apple fake name,
  going back at least to the contacts database
  that ships with the SDK in the simulator.
-->

```swift
var optionalString: String? = "Hello"
print(optionalString == nil)
// Извежда "false"

var optionalName: String? = "John Appleseed"
var greeting = "Hello!"
if let name = optionalName {
    greeting = "Здравейте, \(name)"
}
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> var optionalString: String? = "Hello"
  -> print(optionalString == nil)
  <- false
  ---
  -> var optionalName: String? = "John Appleseed"
  -> var greeting = "Hello!"
  -> if let name = optionalName {
         greeting = "Hello, \(name)"
     }
  >> print(greeting)
  << Hello, John Appleseed
  ```
-->

> Експериментирайте: Променете `optionalName` на `nil`.
> Какъв поздрав получавате?
> Добавете `else` клауза, която задава друг поздрав,
> ако `optionalName` е `nil`.

Ако незадължителната стойност е `nil`,
условната конструкция е `false` и кодът между фигурните скоби се пропуска.
В противен случай на незадължителната стойност се премахва обвивката и тя се
присвоява на константата след `let`,
което прави стойността след премахване на обвивката достъпна
вътре в блока от код.

Друг начин за работа с незадължителни стойности
е да предоставите подразбираща се стойност посредством оператора `??`.
Ако незадължителната стойност липсва,
вместо това се използва подразбиращата се.

```swift
let nickname: String? = nil
let fullName: String = "John Appleseed"
let informalGreeting = "Здравейте, \(nickname ?? fullName)"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let nickname: String? = nil
  -> let fullName: String = "John Appleseed"
  -> let informalGreeting = "Hi \(nickname ?? fullName)"
  >> print(informalGreeting)
  << Hi John Appleseed
  ```
-->

Можете да използвате по-кратко изписване, за да премахнете обвивката от дадена стойност ---
като използвате същото име за стойността след премахване на обвивката.

```swift
if let nickname {
    print("Hey, \(nickname)")
}
// Не отпечатва нищо, защото nickname е nil.
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> if let nickname {
         print("Hey, \(nickname)")
     }
  ```
-->

switch конструкциите поддържат всякакъв вид данни
и голямо разнообразие от оператори за сравнение ---
те не са ограничени само до цели числа
и тестове за равенство.

<!--
  REFERENCE
  The vegetables and foods made from vegetables
  were just a convenient choice for a switch statement.
  They have various properties
  and fit with the apples & oranges used in an earlier example.
-->

```swift
let vegetable = "червена чушка"
switch vegetable {
case "celery":
    print("Добавете малко стафиди и направете мравки върху дънер.")
case "cucumber", "watercress":
    print("От това би станало добър сандвич за чай.")
case let x where x.hasSuffix("pepper"):
    print("Това люта \(x) ли е?")
default:
    print("На супа всичко е вкусно.")
}
// Prints "Това люта червена чушка ли е?"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let vegetable = "red pepper"
  -> switch vegetable {
         case "celery":
             print("Add some raisins and make ants on a log.")
         case "cucumber", "watercress":
             print("That would make a good tea sandwich.")
         case let x where x.hasSuffix("pepper"):
             print("Is it a spicy \(x)?")
         default:
             print("Everything tastes good in soup.")
     }
  <- Is it a spicy red pepper?
  ```
-->

> Експериментирайте: Опитайте да премахнете подразбиращия се случай.
> Каква грешка получавате?

Забележете, че можете да използвате `let` в шаблон,
за да присвоите стойността, която е съвпаднала с шаблона,
на константа.

След изпълнението на кода в съответстващия switch случай,
програмата излиза от switch конструкцията.
Изпълнението не продължава към следващия случай,
така че не е необходимо изрично да указвате изход от switch
конструкцията чрез конструкция brake
в края на кода на всеки случай.

<!--
  Omitting mention of "fallthrough" keyword.
  It's in the guide/reference if you need it.
-->

`for`-`in` се използва за итериране през елементите на речник,
като е необходимо да предоставите двойка имена, които да се 
използват за всяка двойка ключ-стойност.
Речниците представляват неподредена колекция,
поради което техните ключове и стойности се итерират
в произволен ред.

<!--
  REFERENCE
  Prime, square, and Fibonacci numbers
  are just convenient sets of numbers
  that many developers are already familiar with
  that we can use for some simple math.
-->

```swift
let interestingNumbers = [
    "Прости": [2, 3, 5, 7, 11, 13],
    "Фибоначи": [1, 1, 2, 3, 5, 8],
    "Квадратни": [1, 4, 9, 16, 25],
]
var largest = 0
for (_, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}
print(largest)
// Извежда "25"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let interestingNumbers = [
         "Prime": [2, 3, 5, 7, 11, 13],
         "Fibonacci": [1, 1, 2, 3, 5, 8],
         "Square": [1, 4, 9, 16, 25],
     ]
  -> var largest = 0
  -> for (_, numbers) in interestingNumbers {
         for number in numbers {
             if number > largest {
                 largest = number
             }
         }
     }
  -> print(largest)
  <- 25
  ```
-->

> Експериментирайте: Заместете `_` с име на променлива
> и следете от кой вид е най-голямото число.

Използвайте `while`, за да повтаряте блок от код, докато
дадено условие не се промени.
Условието на цикъла може вместо в началото, да бъде накрая,
за да се гарантира, че цикълът ще бъде изпълнен поне веднъж.

<!--
  REFERENCE
  This example is rather skeletal -- m and n are pretty boring.
  I couldn't come up with anything suitably interesting at the time though,
  so I just went ahead and used this.
-->

```swift
var n = 2
while n < 100 {
    n *= 2
}
print(n)
// Извежда "128"

var m = 2
repeat {
    m *= 2
} while m < 100
print(m)
// Извежда "128"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> var n = 2
  -> while n < 100 {
         n *= 2
     }
  -> print(n)
  <- 128
  ---
  -> var m = 2
  -> repeat {
         m *= 2
     } while m < 100
  -> print(m)
  <- 128
  ```
-->

> Експериментирайте:
> Променете условието от `m < 100` на `m < 0`,
> за да видите как `while` и `repeat`-`while` се държат по различен начин,
> когато условието на цикъла е вече false.

В един цикъл можете да поддържате индекс, като създадете област от индекси
с помощта на `..<`.

```swift
var total = 0
for i in 0..<4 {
    total += i
}
print(total)
// Извежда "6"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> var total = 0
  -> for i in 0..<4 {
         total += i
     }
  -> print(total)
  <- 6
  ```
-->

Използвайте `..<`, за да създадете област, в която горната стойност е изпусната;
използвайте `...`, за да създадете стойност, която включва и двете стойности.

## Функции и затваряния

Използвайте `func`, за да декларирате функция.
Извикайте функцията, като след името й предоставите списък с аргументи в скоби.
Използвайте `->`, за да отделите имената и типовете на параметрите от типа данни,
който функцията връща.

<!--
  REFERENCE
  Bob is used as just a generic name,
  but also a callout to Alex's dad.
  Tuesday is used on the assumption that lots of folks would be reading
  on the Tuesday after the WWDC keynote.
-->

```swift
func greet(person: String, day: String) -> String {
    return "Здравейте, \(person), днес е \(day)."
}
greet(person: "Bob", day: "вторник")
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func greet(person: String, day: String) -> String {
         return "Hello \(person), today is \(day)."
     }
  >> let greetBob =
  -> greet(person: "Bob", day: "Tuesday")
  >> print(greetBob)
  << Hello Bob, today is Tuesday.
  ```
-->

> Експериментирайте: Премахнете параметъра `day`.
> Добавете параметър, с който да включите днешното специално предложение от обедното меню в поздрава.

По подразбиране функциите използват имената на своите параметри
като етикети за своите аргументи.
Пишете собствен етикет на аргумента преди името на параметъра или
`_`, за да използвате аргумента без етикет.

```swift
func greet(_ person: String, on day: String) -> String {
    return "Здравейте, \(person), днес е \(day)."
}
greet("John", on: "сряда")
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func greet(_ person: String, on day: String) -> String {
         return "Hello \(person), today is \(day)."
     }
  >> let greetJohn =
  -> greet("John", on: "Wednesday")
  >> print(greetJohn)
  << Hello John, today is Wednesday.
  ```
-->

Използвайте кортеж (tuple), за да създадете съставна стойност ---
например, за да върнете повече от една стойност от дадена функция.
Елементите на един кортеж могат да бъдат реферирани или 
по име, или по пореден номер.

<!--
  REFERENCE
  Min, max, and sum are convenient for this example
  because they're all simple operations
  that are performed on the same kind of data.
  This gives the function a reason to return a tuple.
-->

```swift
func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0

    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }

    return (min, max, sum)
}
let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
print(statistics.sum)
// Извежда "120"
print(statistics.2)
// Извежда "120"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
         var min = scores[0]
         var max = scores[0]
         var sum = 0

         for score in scores {
             if score > max {
                 max = score
             } else if score < min {
                 min = score
             }
             sum += score
         }

         return (min, max, sum)
     }
  -> let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
  >> print(statistics)
  << (min: 3, max: 100, sum: 120)
  -> print(statistics.sum)
  <- 120
  -> print(statistics.2)
  <- 120
  ```
-->

Функциите могат да се влагат една в друга.
Вложените функции имат достъп до променливите,
декларирани във външната функция.
Можете да използвате вложени функции, за да да организирате
кода в дадена функция по-добре, когато той е дълъг или сложен.

```swift
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func returnFifteen() -> Int {
         var y = 10
         func add() {
             y += 5
         }
         add()
         return y
     }
  >> let fifteen =
  -> returnFifteen()
  >> print(fifteen)
  << 15
  ```
-->

Функциите са тип от първи клас.
Това означава, че една функция може да връща друга като своя стойност.

```swift
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func makeIncrementer() -> ((Int) -> Int) {
         func addOne(number: Int) -> Int {
             return 1 + number
         }
         return addOne
     }
  -> var increment = makeIncrementer()
  >> let incrementResult =
  -> increment(7)
  >> print(incrementResult)
  << 8
  ```
-->

Една функция може да приема друга като аргумент.

```swift
func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}
var numbers = [20, 19, 7, 12]
hasAnyMatches(list: numbers, condition: lessThanTen)
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
         for item in list {
             if condition(item) {
                 return true
             }
         }
         return false
     }
  -> func lessThanTen(number: Int) -> Bool {
         return number < 10
     }
  -> var numbers = [20, 19, 7, 12]
  >> let anyMatches =
  -> hasAnyMatches(list: numbers, condition: lessThanTen)
  >> print(anyMatches)
  << true
  ```
-->

Всъщност функциите са специален случай на затварянията (closures):
блокове от код, които могат да бъдат извикани по-късно.
Кодът в едно затваряне има достъп до такива елементи като променливите и функциите,
които са достъпни в обхвата, където затварянето е създадено,
дори ако то е в друг обхват, когато бъде изпълнявано ---
вече видяхте пример за това при вложените функции.
Можете да създадете затваряне без име, като 
оградите кода във фигурни скоби (`{}`).
Използвайте `in`, за да отделите аргументите и връщания тип от тялото.

```swift
numbers.map({ (number: Int) -> Int in
    let result = 3 * number
    return result
})
```

<!--
  - test: `guided-tour`

  ```swifttest
  >> let numbersMap =
  -> numbers.map({ (number: Int) -> Int in
         let result = 3 * number
         return result
     })
  >> print(numbersMap)
  << [60, 57, 21, 36]
  ```
-->

> Експериментирайте: Променете затварянето така, че да връща нула за всички нечетни числа.

Имате на разположение няколко възможности да пишете затварянията по-сбито.
Когато типът на едно затваряне е вече известен,
например при callback за делегат,
можете да пропуснете типа на неговите параметри,
неговия връщан тип, или и двете.
Затварянията, съставени от една-единствена конструкция, неявно връщат стойността
на тази конструкция.

```swift
let mappedNumbers = numbers.map({ number in 3 * number })
print(mappedNumbers)
// Извежда "[60, 57, 21, 36]"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let mappedNumbers = numbers.map({ number in 3 * number })
  -> print(mappedNumbers)
  <- [60, 57, 21, 36]
  ```
-->

Можете да реферирате параметрите по пореден номер вместо по име ---
този подход е особено полезен в много кратки затваряния.
Затваряне, предадено като последен аргумент на функция,
може да бъде изписано непосредствено след скобите.
Когато едно затваряне е единственият аргумент на дадена функция,
можете изцяло да пропуснете скобите.

```swift
let sortedNumbers = numbers.sorted { $0 > $1 }
print(sortedNumbers)
// Извежда "[20, 19, 12, 7]"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let sortedNumbers = numbers.sorted { $0 > $1 }
  -> print(sortedNumbers)
  <- [20, 19, 12, 7]
  ```
-->

<!--
  Called sorted() on a variable rather than a literal to work around an issue in Xcode.  See <rdar://17540974>.
-->

<!--
  Omitted sort(foo, <) because it often causes a spurious warning in Xcode.  See <rdar://17047529>.
-->

<!--
  Omitted custom operators as "advanced" topics.
-->

## Обекти и класове

Използвайте `class`, след което името на класа, за да създадете клас.
Декларация на свойство в един клас се пише по същия начин
като декларация на константа или променлива,
с тази разлика, че е в контекста на клас.
По подобен начин декларациите на методи и функции се пишат по същия начин.

<!--
  REFERENCE
  Shapes are used as the example object
  because they're familiar and they have a sense of properties
  and a sense of inheritance/subcategorization.
  They're not a perfect fit --
  they might be better off modeled as structures --
  but that wouldn't let them inherit behavior.
-->

```swift
class Shape {
    var numberOfSides = 0
    func simpleDescription() -> String {
        return "Фигура с \(numberOfSides) страни."
    }
}
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> class Shape {
         var numberOfSides = 0
         func simpleDescription() -> String {
             return "A shape with \(numberOfSides) sides."
         }
     }
  >> print(Shape().simpleDescription())
  << A shape with 0 sides.
  ```
-->

> Експериментирайте: Добавете константно свойство с `let`
> и друг метод, който приема аргумент.

Създайте екземпляр на даден клас, като поставите скоби след името
на класа.
Използвайте синтаксис с точка, за да получите достъп до свойствата
и методите на екземпляра.

```swift
var shape = Shape()
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> var shape = Shape()
  -> shape.numberOfSides = 7
  -> var shapeDescription = shape.simpleDescription()
  >> print(shapeDescription)
  << A shape with 7 sides.
  ```
-->

В тази версия на класа `Shape` липсва нещо важно:
инициализатор, който да направи първоначалното установяване, когато се създава екземпляр на класа.
За да създадете инициализатор, използвайте `init`.

```swift
class NamedShape {
    var numberOfSides: Int = 0
    var name: String

    init(name: String) {
       self.name = name
    }

    func simpleDescription() -> String {
       return "Фигура с \(numberOfSides) страни."
    }
}
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> class NamedShape {
         var numberOfSides: Int = 0
         var name: String
  ---
         init(name: String) {
            self.name = name
         }
  ---
         func simpleDescription() -> String {
            return "A shape with \(numberOfSides) sides."
         }
     }
  >> print(NamedShape(name: "test name").name)
  << test name
  >> print(NamedShape(name: "test name").simpleDescription())
  << A shape with 0 sides.
  ```
-->

Забележете, че за да се различи свойството `name` от
аргумента `name` на инициализатора, се използва `self`.
Аргументите на инициализатора се предават по същия начин както в извикване на функция,
когато създавате екземпляр на класа.
Всяко свойство трябва да има присвоена стойност ---
или в неговата декларация (както при `numberOfSides`),
или в инициализатора (както при `name`).

Използвайте `deinit`, за да създадете деинициализатор,
ако трябва да извършите някакъв вид почистване,
преди паметта за обекта да бъде освободена.

Подкласовете включват името на своя надклас
след своето име, следвано от двоеточие.
Няма изискване класовете да произхождат от някакъв стандарен коренен клас,
така че можете да включвате или пропускате надклас според нуждата.

Методите на един подклас, които предефинират реализацията, дефинирана от надкласа,
се маркират с `override` ---
предефиниране на метод по погрешка, без `override`,
се разпознава от компилатора като грешка.
Също така компилаторът разпознава методите с `override`,
които в действителност не предефинират метод от надкласа.

```swift
class Square: NamedShape {
    var sideLength: Double

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }

    func area() -> Double {
        return sideLength * sideLength
    }

    override func simpleDescription() -> String {
        return "Квадрат със страни с дължина \(sideLength)."
    }
}
let test = Square(sideLength: 5.2, name: "my test square")
test.area()
test.simpleDescription()
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> class Square: NamedShape {
         var sideLength: Double
  ---
         init(sideLength: Double, name: String) {
             self.sideLength = sideLength
             super.init(name: name)
             numberOfSides = 4
         }
  ---
         func area() -> Double {
             return sideLength * sideLength
         }
  ---
         override func simpleDescription() -> String {
             return "A square with sides of length \(sideLength)."
         }
     }
  -> let test = Square(sideLength: 5.2, name: "my test square")
  >> let testArea =
  -> test.area()
  >> print(testArea)
  << 27.040000000000003
  >> let testDesc =
  -> test.simpleDescription()
  >> print(testDesc)
  << A square with sides of length 5.2.
  ```
-->

> Експериментирайте: Създайте друг подклас на `NamedShape`,
> с име `Circle`,
> който приема радиус и име
> като аргументи на своя инициализатор.
> Реализирайте методите `area()` и `simpleDescription()`
> на класа `Circle`.

Освен простите свойства, които съхраняват стойност,
може да има свойства с get (за получаване на стойност) и set (за задаване на стойност) процедура.

```swift
class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }

    var perimeter: Double {
        get {
             return 3.0 * sideLength
        }
        set {
            sideLength = newValue / 3.0
        }
    }

    override func simpleDescription() -> String {
        return "Равностранен триъгълник със страни с дължина \(sideLength)."
    }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "триъгълник")
print(triangle.perimeter)
// Извежда "9.3"
triangle.perimeter = 9.9
print(triangle.sideLength)
// Извежда "3.3000000000000003"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> class EquilateralTriangle: NamedShape {
         var sideLength: Double = 0.0
  ---
         init(sideLength: Double, name: String) {
             self.sideLength = sideLength
             super.init(name: name)
             numberOfSides = 3
         }
  ---
         var perimeter: Double {
             get {
                  return 3.0 * sideLength
             }
             set {
                 sideLength = newValue / 3.0
             }
         }
  ---
         override func simpleDescription() -> String {
             return "Равностранен триъгълник със страни с дължина \(sideLength)."
         }
     }
  -> var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
  -> print(triangle.perimeter)
  <- 9.3
  -> triangle.perimeter = 9.9
  -> print(triangle.sideLength)
  <- 3.3000000000000003
  ```
-->
<!--- ??? HERE-MARKER ???--->
В set процедурата за `perimeter` новата стойност 
има неявно име `newValue`.
Можете да предоставите изрично име в скоби след `set`.

Забележете, че инициализаторът на класа `EquilateralTriangle`
включва три различни стъпки:

1. Задаване на стойността на свойствата, декларирани от подкласа.
2. Извикване на инициализатора на надкласа.
3. Промяна на стойностите на свойства, дефинирани от надкласа.
   Ако е необходима друга допълнителна инициализация, която използва методи,
   `get` или `set` процедури, тя също може да бъде направена тук.

Ако не е необходимо да изчислявате свойството,
но все пак да предоставите код, който се изпълнява преди и след задаването на нова стойност,
използвайте `willSet` и `didSet`.
Кодът, който предоставите, се изпълнява винаги, когато стойността бъде променена извън инициализатора.
Например класът по-долу гарантира, че дължината на страната на неговия триъгълник
е винаги същата като дължината на страната на неговия квадрат.

<!--
  This triangle + square example could use improvement.
  The goal is to show why you would want to use willSet,
  but it was constrained by the fact that
  we're working in the context of geometric shapes.
-->

```swift
class TriangleAndSquare {
    var triangle: EquilateralTriangle {
        willSet {
            square.sideLength = newValue.sideLength
        }
    }
    var square: Square {
        willSet {
            triangle.sideLength = newValue.sideLength
        }
    }
    init(size: Double, name: String) {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
print(triangleAndSquare.square.sideLength)
// Отпечатва "10.0"
print(triangleAndSquare.triangle.sideLength)
// Отпечатва "10.0"
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
print(triangleAndSquare.triangle.sideLength)
// Отпечатва "50.0"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> class TriangleAndSquare {
         var triangle: EquilateralTriangle {
             willSet {
                 square.sideLength = newValue.sideLength
             }
         }
         var square: Square {
             willSet {
                 triangle.sideLength = newValue.sideLength
             }
         }
         init(size: Double, name: String) {
             square = Square(sideLength: size, name: name)
             triangle = EquilateralTriangle(sideLength: size, name: name)
         }
     }
  -> var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
  -> print(triangleAndSquare.square.sideLength)
  <- 10.0
  -> print(triangleAndSquare.triangle.sideLength)
  <- 10.0
  -> triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
  -> print(triangleAndSquare.triangle.sideLength)
  <- 50.0
  ```
-->

<!--
  Grammatically, these clauses are general to variables.
  Not sure what it would look like
  (or if it's even allowed)
  to use them outside a class or a struct.
-->

Когато работите с незадължителни стойности,
можете да пишете `?` преди операции като методи, свойства и достъп до елемент на масив или речник.
Ако стойността преди `?` е `nil`,
всичко след `?` се игнорира
и стойността на целия израз е `nil`.
В противен случай незадължителната стойност се изважда от обвивката
и всичко след `?` действа като стойност след изваждането.
И в двата случая стойността на целия израз е незадължителна стойност.

```swift
let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
  -> let sideLength = optionalSquare?.sideLength
  ```
-->

## Изброявания и структури

Използвайте `enum`, за да създадете изброяване.
Подобно на класовете и всички други именувани типове
към изброяванията може да има асоциирани методи.

<!--
  REFERENCE
  Playing cards work pretty well to demonstrate enumerations
  because they have two aspects, suit and rank,
  both of which come from a small finite set.
  The deck used here is probably the most common,
  at least through most of Europe and the Americas,
  but there are many other regional variations.
-->

```swift
enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king

    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}
let ace = Rank.ace
let aceRawValue = ace.rawValue
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> enum Rank: Int {
         case ace = 1
         case two, three, four, five, six, seven, eight, nine, ten
         case jack, queen, king
  ---
         func simpleDescription() -> String {
             switch self {
                 case .ace:
                     return "ace"
                 case .jack:
                     return "jack"
                 case .queen:
                     return "queen"
                 case .king:
                     return "king"
                 default:
                     return String(self.rawValue)
             }
         }
     }
  -> let ace = Rank.ace
  -> let aceRawValue = ace.rawValue
  >> print(aceRawValue)
  << 1
  ```
-->

> Експериментирайте: Напишете функция, която сравнява две стойности `Rank`,
> като сравни числовите стойности, които стоят под тях.

По подразбиране Swift задава съответстващите стойности на изброяването започвайки от нула и инкрементирайки ги
с едно всеки път, но можете да промените това поведение, като изрично зададете свои 
стойности.
В примера по-горе на `Ace` изрично се дава стойност `1`, а останалите стойности се задават по реда им по-нататък.
Като стойности, съответстващи на членовете на изброяването, можете да използвате низове или числа с плаваща запетая вместо цели числа.
За да получите достъп до съответстващата стойност на определен член на изброяване, използвайте свойството `rawValue`.

Използвайте инициализатора `init?(rawValue:)`, за да създадете екземпляр на дадено изброяване от конкретна съответстваща стойност.
Той връща или члена на изброяването, който съответства на исканата стойност, или `nil`, ако няма съответстващ `Rank`.

```swift
if let convertedRank = Rank(rawValue: 3) {
    let threeDescription = convertedRank.simpleDescription()
}
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> if let convertedRank = Rank(rawValue: 3) {
         let threeDescription = convertedRank.simpleDescription()
  >> print(threeDescription)
  << 3
  -> }
  ```
-->

Отделните случаи в едно изброяване са действителни стойности, не просто
друг начин за записване на съответстваща стойност.
Нещо повече, в случаите, където няма смислена съответстваща стойност, 
не е необходимо да предоставяте такава.

```swift
enum Suit {
    case spades, hearts, diamonds, clubs

    func simpleDescription() -> String {
        switch self {
        case .spades:
            return "spades"
        case .hearts:
            return "hearts"
        case .diamonds:
            return "diamonds"
        case .clubs:
            return "clubs"
        }
    }
}
let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> enum Suit {
         case spades, hearts, diamonds, clubs
  ---
         func simpleDescription() -> String {
             switch self {
                 case .spades:
                     return "spades"
                 case .hearts:
                     return "hearts"
                 case .diamonds:
                     return "diamonds"
                 case .clubs:
                     return "clubs"
             }
         }
     }
  -> let hearts = Suit.hearts
  -> let heartsDescription = hearts.simpleDescription()
  >> print(heartsDescription)
  << hearts
  ```
-->

> Experiment: Add a `color()` method to `Suit` that returns "black"
> for spades and clubs, and returns "red" for hearts and diamonds.

<!--
  Suits are in Bridge order, which matches Unicode order.
  In other games, orders differ.
  Wikipedia lists a good half dozen orders.
-->

Notice the two ways that the `hearts` case of the enumeration
is referred to above:
When assigning a value to the `hearts` constant,
the enumeration case `Suit.hearts` is referred to by its full name
because the constant doesn't have an explicit type specified.
Inside the switch,
the enumeration case is referred to by the abbreviated form `.hearts`
because the value of `self` is already known to be a suit.
You can use the abbreviated form
anytime the value's type is already known.

Ако на случаите на едно изброяване има зададени стойности,
те се определят като част от декларацията, което
означава, че всеки екземпляр на случай на изброяването
винаги има една и съща съответстваща стойност.
Друг избор за случаите на изброяването е да има
стойности, асоциирани с този случай ---
тези стойности се определят, когато създавате екземпляра;
те може да са различни за всеки екземпляр на случай на изброяването.
Бихте могли да мислите за асоциираните стойности като за съхранени свойства 
на екземпляра на случая на изброяването.
Да вземем като пример изпращането на заявка към сървър за времената на изгрева и залеза на 
слънцето. Сървърът или отговаря с исканата информация,
или отговаря с описание на това какво не е сработило.

<!--
  REFERENCE
  The server response is a simple way to essentially re-implement Optional
  while sidestepping the fact that I'm doing so.

  "Out of cheese" is a reference to a Terry Pratchet book,
  which features a computer named Hex.
  Hex's other error messages include:

       - Out of Cheese Error. Redo From Start.
       - Mr. Jelly! Mr. Jelly! Error at Address Number 6, Treacle Mine Road.
       - Melon melon melon
       - +++ Wahhhhhhh! Mine! +++
       - +++ Divide By Cucumber Error. Please Reinstall Universe And Reboot +++
       - +++Whoops! Here comes the cheese! +++

  These messages themselves are references to BASIC interpreters
  (REDO FROM START) and old Hayes-compatible modems (+++).

  The "out of cheese error" may be a reference to a military computer
  although I can't find the source of this story anymore.
  As the story goes, during the course of a rather wild party,
  one of the computer's vacuum tube cabinets
  was opened to provide heat to a cold room in the winter.
  Through great coincidence,
  when a cheese tray got bashed into it during the celebration,
  the computer kept on working even though some of the tubes were broken
  and had cheese splattered & melted all over them.
  Tech were dispatched to make sure the computer was ok
  and told add more cheese if necessary --
  the officer in charge said that he didn't want
  an "out of cheese error" interrupting the calculation.
-->

```swift
enum ServerResponse {
    case result(String, String)
    case failure(String)
}

let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Сиренето свърши.")

switch success {
case let .result(sunrise, sunset):
    print("Изгревът е в \(sunrise), залезът е в \(sunset).")
case let .failure(message):
    print("Грешка...  \(message)")
}
// Отпечатва "Изгревът е в 6:00 am, залезът е в 8:09 pm."
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> enum ServerResponse {
         case result(String, String)
         case failure(String)
     }
  ---
  -> let success = ServerResponse.result("6:00 am", "8:09 pm")
  -> let failure = ServerResponse.failure("Out of cheese.")
  ---
  -> switch success {
         case let .result(sunrise, sunset):
             print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
         case let .failure(message):
             print("Failure...  \(message)")
     }
  <- Sunrise is at 6:00 am and sunset is at 8:09 pm.
  ```
-->

> Експериментирайте: Добавете трети случай към `ServerResponse` и към switch конструкцията.

Забележете, че времената на изгрева и залеза
се извличат от `ServerResponse` стойността
като част от съпоставянето на стойността спрямо случаите на switch конструкцията.

Използвайте `struct`, за да създадете структура.
Структурите в много отношения се държат като класовете,
включително могат да имат методи и инициализатори.
Една от най-важните разлики между структурите и класовете е, че
структурите винаги се копират, когато се предават в кода,
но класовете се предават по референция.

```swift
struct Card {
    var rank: Rank
    var suit: Suit
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}
let threeOfSpades = Card(rank: .three, suit: .spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> struct Card {
         var rank: Rank
         var suit: Suit
         func simpleDescription() -> String {
             return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
         }
     }
  -> let threeOfSpades = Card(rank: .three, suit: .spades)
  -> let threeOfSpadesDescription = threeOfSpades.simpleDescription()
  >> print(threeOfSpadesDescription)
  << The 3 of spades
  ```
-->

> Experiment: Write a function that returns an array containing
> a full deck of cards,
> with one card of each combination of rank and suit.

## Едновременност

Използвайте `async`, за да маркирате функция, която се изпълнява асинхронно.

```swift
func fetchUserID(from server: String) async -> Int {
    if server == "primary" {
        return 97
    }
    return 501
}
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func fetchUserID(from server: String) async -> Int {
         if server == "primary" {
             return 97
         }
         return 501
     }
  ```
-->

Извикването на асинхронна функция се изписва с `await` отпред.

```swift
func fetchUsername(from server: String) async -> String {
    let userID = await fetchUserID(from: server)
    if userID == 501 {
        return "John Appleseed"
    }
    return "Guest"
}
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func fetchUsername(from server: String) async -> String {
         let userID = await fetchUserID(from: server)
         if userID == 501 {
             return "John Appleseed"
         }
         return "Guest"
     }
  ```
-->

Използвайте `async let`, за да извикате асинхронна функция,
позволявайки и да се изпълнява паралелно с друг асинхронен код.
Когато използвате стойността, която тя връща, напишете `await`.

```swift
func connectUser(to server: String) async {
    async let userID = fetchUserID(from: server)
    async let username = fetchUsername(from: server)
    let greeting = await "Hello \(username), user ID \(userID)"
    print(greeting)
}
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func connectUser(to server: String) async {
         async let userID = fetchUserID(from: server)
         async let username = fetchUsername(from: server)
         let greeting = await "Hello \(username), user ID \(userID)"
         print(greeting)
     }
  ```
-->

Използвайте `Task`, за да извиквате асинхронни функции от синхронен код,
без да чакате връщането от тях.

```swift
Task {
    await connectUser(to: "primary")
}
// Отпечатва "Здравей, Guest, потребител с ID 97"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> Task {
         await connectUser(to: "primary")
     }
  >> import Darwin; sleep(1)  // Pause for task to run
  <- Hello Guest, user ID 97
  ```
-->

Използвайте групи от задачи, за да структурирате едновременно изпълняващ се код.

```swift
let userIDs = await withTaskGroup(of: Int.self) { group in
    for server in ["primary", "secondary", "development"] {
        group.addTask {
            return await fetchUserID(from: server)
        }
    }

    var results: [Int] = []
    for await result in group {
        results.append(result)
    }
    return results
}
```

Акторите са подобни на класовете, с тази разлика, че те
създават условия за това различни асинхронни функции безопасно да
взаимодействат с екземпляр на един и същи актор по едно и също време.

```swift
actor ServerConnection {
    var server: String = "primary"
    private var activeUsers: [Int] = []
    func connect() async -> Int {
        let userID = await fetchUserID(from: server)
        // ... communicate with server ...
        activeUsers.append(userID)
        return userID
    }
}
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> actor Oven {
         var contents: [String] = []
         func bake(_ food: String) -> String {
             contents.append(food)
             // ... wait for food to bake ...
             return contents.removeLast()
         }
     }
  ```
-->

Когато извиквате метод на актор или осъществявате достъп до едно от неговите свойства,
трябва да маркирате кода с `await`, за да посочите, че е възможно той да трябва да 
чака друг код, който вече се изпълнява върху актора, да завърши.

```swift
let server = ServerConnection()
let userID = await server.connect()
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let oven = Oven()
  -> let biscuits = await oven.bake("biscuits")
  ```
-->


## Протоколи и разширения

Декларирайте протокол с `protocol`.

```swift
protocol ExampleProtocol {
     var simpleDescription: String { get }
     mutating func adjust()
}
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> protocol ExampleProtocol {
          var simpleDescription: String { get }
          mutating func adjust()
     }
  ```
-->

И класовете, и изброяванията, и структурите могат да възприемат протоколи.

<!--
  REFERENCE
  The use of adjust() is totally a placeholder
  for some more interesting operation.
  Likewise for the struct and classes -- placeholders
  for some more interesting data structure.
-->

```swift
class SimpleClass: ExampleProtocol {
     var simpleDescription: String = "A very simple class."
     var anotherProperty: Int = 69105
     func adjust() {
          simpleDescription += "  Now 100% adjusted."
     }
}
var a = SimpleClass()
a.adjust()
let aDescription = a.simpleDescription

struct SimpleStructure: ExampleProtocol {
     var simpleDescription: String = "A simple structure"
     mutating func adjust() {
          simpleDescription += " (adjusted)"
     }
}
var b = SimpleStructure()
b.adjust()
let bDescription = b.simpleDescription
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> class SimpleClass: ExampleProtocol {
          var simpleDescription: String = "A very simple class."
          var anotherProperty: Int = 69105
          func adjust() {
               simpleDescription += "  Now 100% adjusted."
          }
     }
  -> var a = SimpleClass()
  -> a.adjust()
  -> let aDescription = a.simpleDescription
  >> print(aDescription)
  << A very simple class.  Now 100% adjusted.
  ---
  -> struct SimpleStructure: ExampleProtocol {
          var simpleDescription: String = "A simple structure"
          mutating func adjust() {
               simpleDescription += " (adjusted)"
          }
     }
  -> var b = SimpleStructure()
  -> b.adjust()
  -> let bDescription = b.simpleDescription
  >> print(bDescription)
  << A simple structure (adjusted)
  ```
-->

> Експериментирайте: Добавете друго изискване към `ExampleProtocol`.
> Какви промени в `SimpleClass` и `SimpleStructure` трябва да направите така, че
> те пак да отговарят на протокола?

Забележете, че в декларацията на `SimpleStructure` метод, който променя структурата,
е маркиран с ключовата дума `mutating`.
В декларацията на `SimpleClass` не е необходимо никой от методите
да се маркира като `mutating`, защото методите на един клас винаги могат да променят класа.

Използвайте `extension`, за да добавите функционалност към съществуващ тип,
например нови методи и изчислени свойства.
С помощта на разширение можете да добавите съвместимост с протокол към тип,
който е дефиниран другаде, или дори към тип, който е импортиран от библиотека
или фреймуърк.

```swift
extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "Числото \(self)"
    }
    mutating func adjust() {
        self += 42
    }
 }
print(7.simpleDescription)
// Отпечатва "Числото 7"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> extension Int: ExampleProtocol {
         var simpleDescription: String {
             return "The number \(self)"
         }
         mutating func adjust() {
             self += 42
         }
      }
  -> print(7.simpleDescription)
  <- The number 7
  ```
-->

> Експериментирайте: Създайте разширение на типа `Double`,
> което добавя свойство `absoluteValue`.

Можете да използвате име на протокол като всеки друг именуван тип ---
например за да създадете колекция от обекти, които имат
различни типове, но всички отговарят на конкретен протокол.
Когато работите със стойности, чийто тип е опакован протоколен тип,
методите извън дефиницията на протокола не са достъпни.

```swift
let protocolValue: any ExampleProtocol = a
print(protocolValue.simpleDescription)
// Prints "Един много прост клас. Сега вече 100% нагласен."
// print(protocolValue.anotherProperty)  // Премахнете коментара, за да видите грешката
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let protocolValue: ExampleProtocol = a
  -> print(protocolValue.simpleDescription)
  <- A very simple class.  Now 100% adjusted.
  // print(protocolValue.anotherProperty)  // Uncomment to see the error
  ```
-->

Въпреки че променливата `protocolValue`
има тип по време на изпълнението `SimpleClass`,
компилаторът я третира като дадения тип `ExampleProtocol`.
Това означава, че не може случайно да се получи достъп до
методи и свойства, които класът реализира в допълнение към
тези, реализирани за изпълнение на изискванията на протокола.

## Обработка на грешки

Грешките се представят посредством произволен тип, който възприема протокола `Error`.

<!--
  REFERENCE
  PrinterError.OnFire is a reference to the Unix printing system's "lp0 on
  fire" error message, used when the kernel can't identify the specific error.
  The names of printers used in the examples in this section are names of
  people who were important in the development of printing.

  Bi Sheng is credited with inventing the first movable type out of porcelain
  in China in the 1040s.  It was a mixed success, in large part because of the
  vast number of characters needed to write Chinese, and failed to replace
  wood block printing.  Johannes Gutenberg is credited as the first European
  to use movable type in the 1440s --- his metal type enabled the printing
  revolution.  Ottmar Mergenthaler invented the Linotype machine in the 1884,
  which dramatically increased the speed of setting type for printing compared
  to the previous manual typesetting.  It set an entire line of type (hence
  the name) at a time, and was controlled by a keyboard.  The Monotype
  machine, invented in 1885 by Tolbert Lanston, performed similar work.
-->

```swift
enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> enum PrinterError: Error {
         case outOfPaper
         case noToner
         case onFire
     }
  ```
-->

Използвайте `throw`, за да хвърлите грешка,
и `throws`, за да маркирате функция, коятоможе да хвърли грешка.
Ако хвърлите грешка в някоя функция, тя връща управлението незабавно и кодът, който я е  извикал, обработва грешката.

```swift
func send(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrinterError.noToner
    }
    return "Job sent"
}
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func send(job: Int, toPrinter printerName: String) throws -> String {
         if printerName == "Never Has Toner" {
             throw PrinterError.noToner
         }
         return "Job sent"
     }
  ```
-->

Има няколко начина да обработвате грешки.
Един от тях е да използвате `do`-`catch`.
Вътру в `do` блока маркирате кода, който може да хвърли грешка, като напишете `try` пред него.
В `catch` блока на грешката автоматично се дава име `error`,
освен ако не използвате друго име.

```swift
do {
    let printerResponse = try send(job: 1040, toPrinter: "Bi Sheng")
    print(printerResponse)
} catch {
    print(error)
}
// Отпечатва "Job sent"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> do {
         let printerResponse = try send(job: 1040, toPrinter: "Bi Sheng")
         print(printerResponse)
     } catch {
         print(error)
     }
  <- Job sent
  ```
-->

> Експериментирайти: Промерете името на принтера на `"Никога няма тонер"`,
> така че функцията `send(job:toPrinter:)` да хвърля грешка.

<!--
  Assertion tests the change that the Experiment box instructs you to make.
-->

<!--
  - test: `guided-tour`

  ```swifttest
  >> do {
         let printerResponse = try send(job: 500, toPrinter: "Never Has Toner")
         print(printerResponse)
     } catch {
         print(error)
     }
  <- noToner
  ```
-->

Можете да предоставите повече от един `catch` блока,
които обработват конкретни грешки.
След `catch` се пише шаблон също както при `case` условията
на една `switch` конструкция.

<!--
  REFERENCE
  The "rest of the fire" quote comes from The IT Crowd, season 1 episode 2.
-->

```swift
do {
    let printerResponse = try send(job: 1440, toPrinter: "Gutenberg")
    print(printerResponse)
} catch PrinterError.onFire {
    print("Просто ще оставя това тук, при другия огън.")
} catch let printerError as PrinterError {
    print("Грешка на принтера: \(printerError).")
} catch {
    print(error)
}
// Prints "Job sent"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> do {
         let printerResponse = try send(job: 1440, toPrinter: "Gutenberg")
         print(printerResponse)
     } catch PrinterError.onFire {
         print("I'll just put this over here, with the rest of the fire.")
     } catch let printerError as PrinterError {
         print("Printer error: \(printerError).")
     } catch {
         print(error)
     }
  <- Job sent
  ```
-->

> Експериментирайте: Добавете код, който да хвърля грешка вътре в `do` блока.
> Какъв вид грешка трябва да хвърлите,
> така че тя да бъде обработена от първия `catch` блок?
> Какво може да се каже за втория и третия блокове?

Друг начин да обработвате грешките
е като преобразувате резултата към незадължителна стойност посредством `try?`.
Ако функцията хвърли грешка,
конкретната грешка се отхвърля и резултатът е `nil`.
В противен случай резултатът е незадължителна стойност, съдържаща
стойността, върната от функцията.

```swift
let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
  >> print(printerSuccess as Any)
  << Optional("Job sent")
  -> let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")
  >> print(printerFailure as Any)
  << nil
  ```
-->
Използвайте `defer`, за да напишете блок от код,
който се изпълнява след всеки друг код във функцията,
точно преди функцията да върне управлението.
Кодът се изпълнява независимо от това дали функцията хвърля грешка.
С помощта на `defer` можете да пишете код за инициализация и такъв за почистване един до друг,
независимо от това, че те трябва да бъдат изпълнени по различно време.


```swift
var fridgeIsOpen = false
let fridgeContent = ["milk", "eggs", "leftovers"]

func fridgeContains(_ food: String) -> Bool {
    fridgeIsOpen = true
    defer {
        fridgeIsOpen = false
    }

    let result = fridgeContent.contains(food)
    return result
}
if fridgeContains("banana") {
    print("Открит е банан")
}
print(fridgeIsOpen)
// Отпечатва "false"
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> var fridgeIsOpen = false
  -> let fridgeContent = ["milk", "eggs", "leftovers"]
  ---
  -> func fridgeContains(_ food: String) -> Bool {
         fridgeIsOpen = true
         defer {
             fridgeIsOpen = false
         }
  ---
         let result = fridgeContent.contains(food)
         return result
     }
  >> let containsBanana =
  -> fridgeContains("banana")
  >> print(containsBanana)
  << false
  -> print(fridgeIsOpen)
  <- false
  ```
-->

## Обобщени типове

Напишете име в ъглови скоби, за да създадете
обобщена функция или тип.

<!--
  REFERENCE
  The four knocks is a reference to Dr Who series 4,
  in which knocking four times is a running aspect
  of the season's plot.
-->

```swift
func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result: [Item] = []
    for _ in 0..<numberOfTimes {
         result.append(item)
    }
    return result
}
makeArray(repeating: "knock", numberOfTimes: 4)
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
         var result: [Item] = []
         for _ in 0..<numberOfTimes {
              result.append(item)
         }
         return result
     }
  >> let fourKnocks =
  -> makeArray(repeating: "knock", numberOfTimes: 4)
  >> print(fourKnocks)
  << ["knock", "knock", "knock", "knock"]
  ```
-->

Можете да правите обобщени форми на функции и методи,
както и на класове, изброявания и структури.

```swift
// Друга реализация на незадължителния тип от стандартната библиотека на Swift
enum OptionalValue<Wrapped> {
    case none
    case some(Wrapped)
}
var possibleInteger: OptionalValue<Int> = .none
possibleInteger = .some(100)
```

<!--
  - test: `guided-tour`

  ```swifttest
  // Reimplement the Swift standard library's optional type
  -> enum OptionalValue<Wrapped> {
         case none
         case some(Wrapped)
     }
  -> var possibleInteger: OptionalValue<Int> = .none
  -> possibleInteger = .some(100)
  ```
-->

Използвайте `where` непосредствено преди тялото,
за да укажете списък с изисквания ---
например, за да изискате от типа да имплементира конкретен протокол,
да изискате два типа да бъдат едни и същи
или да изискате даден клас да има конкретен надклас.

```swift
func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
    where T.Element: Equatable, T.Element == U.Element
{
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
   return false
}
anyCommonElements([1, 2, 3], [3])
```

<!--
  - test: `guided-tour`

  ```swifttest
  -> func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
         where T.Element: Equatable, T.Element == U.Element
     {
         for lhsItem in lhs {
             for rhsItem in rhs {
                 if lhsItem == rhsItem {
                     return true
                 }
             }
         }
        return false
     }
  >> let hasAnyCommon =
  -> anyCommonElements([1, 2, 3], [3])
  >> print(hasAnyCommon)
  << true
  ```
-->

> Експериментирайте: Променете функцията `anyCommonElements(_:_:)` така, че
> да направите функция, която връща масив
> от елементите, които са общи за произволни две последователности.

Writing `<T: Equatable>`
is the same as writing `<T> ... where T: Equatable`.

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
