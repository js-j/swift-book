# Автоматично броене на референциите

Моделирайте продължителността на живота на обектите и техните взаимоотношения.

Swift следи и управлява употребата на паметта във Вашето приложение с помощта на
*Автоматично броене на референциите* (Automatic Reference Counting - ARC).
В повечето случаи това означава, че в Swift управлението на паметта *просто се случва*
и не се налага сами да мислите него.
ARC автоматично освобождава паметта, използвана от екземпляри на класове,
когато тези екземпляри повече не са необходими.

В няколко случая обаче ARC изисква повече информация
относно зависимостите между частите от Вашия код,
за да може да управлява паметта вместо Вас.
В настоящата глава тези ситуации са обяснени, както и е показано
как да дадете на ARC да управлява цялата памет на Вашето приложение.
Използването на ARC в Swift е много подобно на подхода, описан в
[Transitioning to ARC Release Notes](https://developer.apple.com/library/content/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html)
за използнане на ARC с Objective-C.

Броенето на референциите е приложимо само за екземпляри на класове.
Структурите и изброяванията са стойностни, а не референтни, типове,
които не се съхраняват и предават по референция.

## Как работи ARC

Всеки път, когато създадете нов екземпляр на някой клас,
ARC заделя място в паметта, където да съхрани информация за този екземпляр.
Тази памет съдържа информация за типа на екземпляра, както и стойностите
на всички съхранени свойства, асоциирани с този екземпляр.

В допълнение, когато даден екземпляр повече не е необходим,
ARC освобождава паммета, заета от него, така че паметта
да може да се използва за други цели.
По този начин екземплярите на класовете не заемат място в паметта,
когато повече не са необходими.

Ако обаче ARC освобождаваше паметта за екземпляр, която все още се използва,
нямаше повече да е възможно да се получи достъп до свойствата на този екземпляр
или да се извикват неговите методи.
Наистина, при опит за достъп до екземпляра Вашето приложения вероятно би забило.

За да е сигурно, че екземплярите няма да изчезват, докато все още са необходими,
ARC следи колко свойства, константи и променливи към момента реферират всеки екземпляр на клас.
ARC не освобождава паметта за екземпляра, докато все още съществува поне една активна референция към него.

За да бъде това възможно, винаги, когато присвоите екземпляр на клас на свойство, константа или променлива,
това свойство, константа или променлива поддържат *силна референция* към екземпляра.
Референцията се нарича "силна", защото твърдо държи този екземпляр и не позволява той да бъде освободен,
докато силната референция остава.

## ARC в действие

Ето пример за това как работи автоматичното броене на референциите.
Започваме с прост клас с име `Person`,
който дефинира съхранено константно свойство, наречено `name`:

```swift
class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("Инициализира се \(name)")
    }
    deinit {
        print("Деинициализира се \(name)")
    }
}
```

<!--
  - test: `howARCWorks`

  ```swifttest
  -> class Person {
        let name: String
        init(name: String) {
           self.name = name
           print("\(name) is being initialized")
        }
        deinit {
           print("\(name) is being deinitialized")
        }
     }
  ```
-->

Класът `Person` има инициализатор, който задава свойството `name` на екземпляра
и извежда съобщение, посочващо, че в този момент се извършва инициализация.
Също така класът `Person` разполага с деинициализатор,
който извежда съобщение при освобождаване на паметта за екземпляра на класа.

Следващият примерен фрагмент код дефинира три променливи от тип `Person?`,
които се използват за установяването на множество референции към нов екземпляр на `Person`
в последващи примерни фрагменти код.
Тъй като тези променливи са от незадължителен тип(`Person?`, а не `Person`),
те автоматично се инициализират със стойност `nil`
и на този етап не реферират екземпляр на `Person`.

```swift
var reference1: Person?
var reference2: Person?
var reference3: Person?
```

<!--
  - test: `howARCWorks`

  ```swifttest
  -> var reference1: Person?
  -> var reference2: Person?
  -> var reference3: Person?
  ```
-->

Сега вече можете да създадете нов екземпляр на `Person`
и да я присвоите на една от тези три променливи:

```swift
reference1 = Person(name: "John Appleseed")
// Извежда "Инициализира се John Appleseed"
```

<!--
  - test: `howARCWorks`

  ```swifttest
  -> reference1 = Person(name: "John Appleseed")
  <- John Appleseed is being initialized
  ```
-->

Забележете, че съобщението `"Инициализира се John Appleseed"` се извежда
в момента, в който извикате инициализатора на класа `Person`.
Това потвърждава, че инициализацията се е извършила.

Тъй като новият екземпляр на `Person` е присвоен на променливата `reference1`,
сега вече има силна референция от `reference1` към новия екземпляр на `Person`.
Поради обстоятелството, че има поне една силна референция, ARC прави така, че
този `Person` със сигурност се поддържа в паметта, без да се освобождава.

Ако присвоите същия екземпляр на `Person` на още две променливи,
ще бъдат установени още две силни референции към този екземпляр:

```swift
reference2 = reference1
reference3 = reference1
```

<!--
  - test: `howARCWorks`

  ```swifttest
  -> reference2 = reference1
  -> reference3 = reference1
  ```
-->

Сега вече има *три* силни референции към този единствен екземпляр на `Person`.

Ако прекъснете две от тези силни референции (включително оригиналната референция),
като присвоите `nil` на две от променливите,
остава единствена силна референция
и екземплярът на `Person` не се освобождава:

```swift
reference1 = nil
reference2 = nil
```

<!--
  - test: `howARCWorks`

  ```swifttest
  -> reference1 = nil
  -> reference2 = nil
  ```
-->

ARC не освобождава екземпляра на `Person`,
докато третата и последна силна референция не бъде прекъсната,
в който момент е ясно, че вече не го използвате:

```swift
reference3 = nil
// Извежда "Деинициализира се John Appleseed"
```

<!--
  - test: `howARCWorks`

  ```swifttest
  -> reference3 = nil
  <- John Appleseed is being deinitialized
  ```
-->

## Цикли от силни референции между екземпляри на класове

В примерите, представени по-горе, ARC е в състояние да следи броя на референциите
към новия екземпляр на `Person`, които създавате, и да освободи този екземпляр,
когато повече не е необходим.

Възможно е обаче да бъде написан код, в който екземпляр на даден клас
*никога* не стига до състояние, при което към него няма никакви силни референции.
Това може да се случи, ако два екземпляра на клас държат силна референция един към друг,
така че всеки екземпляр държи другия жив.
Това е известно като *Цикъл от силни референции*.

За да прекъснете цикъла от силни референции, трябва да дефинирате някои от
взаимозависимостите между класовете като слаби или непритежавани (unowned) референции
вместо като силни.
Този процес е описан в
<doc:AutomaticReferenceCounting#Resolving-Strong-Reference-Cycles-Between-Class-Instances>.
Но преди да научите как да разрешавате такива цикли, е полезно да разбирате
какво ги причинява.

Ето един пример за това как неволно може да бъде създаден цикъл от силни референции.
Тук са дефинирани два класа, `Person` и `Apartment`,
които моделират блок от апартаменти и техните жители:

```swift
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("Деинициализира се \(name)") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person?
    deinit { print("Деинициализира се апартамент \(unit)") }
}
```

<!--
  - test: `referenceCycles`

  ```swifttest
  -> class Person {
        let name: String
        init(name: String) { self.name = name }
        var apartment: Apartment?
        deinit { print("\(name) is being deinitialized") }
     }
  ---
  -> class Apartment {
        let unit: String
        init(unit: String) { self.unit = unit }
        var tenant: Person?
        deinit { print("Apartment \(unit) is being deinitialized") }
     }
  ```
-->

Всеки екземпляр на `Person` има свойство `name` от тип `String`
и незадължително свойство `apartment`, което първоначално е `nil`.
Свойството `apartment` е незадължително, защото един човек не винаги може 
да има апартамент.

В същия ред на мисли, всеки екземпляр на `Apartment` има свойство `unit` от тип `String`,
както и незадължително свойство `tenant`, което първоначално е `nil`.
Свойството `tenant` е незадължително, защото един апартамент не винаги може да има наемател.

Също така и двата класа дефиринат деинициализатор,
който визуализира факта, че екземпляр на този клас се деинициализира.
Това дава възможност да се види дали екземплярите на `Person` и `Apartment` се освобождават така, както се очаква.

Следващият фрагмент код дефинира две променливи от незадължителен тип с име `john` и `unit4A`,
които по-надолу ще бъдат установени с конкретни екземпляри на `Person` и `Apartment`.
И двете променливи имат първоначална стойност `nil`, по силата на това, че са декларирани като незадължителни:

```swift
var john: Person?
var unit4A: Apartment?
```

<!--
  - test: `referenceCycles`

  ```swifttest
  -> var john: Person?
  -> var unit4A: Apartment?
  ```
-->

You can now create a specific `Person` instance and `Apartment` instance
and assign these new instances to the `john` and `unit4A` variables:

```swift
john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")
```

<!--
  - test: `referenceCycles`

  ```swifttest
  -> john = Person(name: "John Appleseed")
  -> unit4A = Apartment(unit: "4A")
  ```
-->

Here's how the strong references look after creating and assigning these two instances.
The `john` variable now has a strong reference to the new `Person` instance,
and the `unit4A` variable has a strong reference to the new `Apartment` instance:

![](referenceCycle01)

You can now link the two instances together
so that the person has an apartment, and the apartment has a tenant.
Note that an exclamation point (`!`) is used to unwrap and access
the instances stored inside the `john` and `unit4A` optional variables,
so that the properties of those instances can be set:

```swift
john!.apartment = unit4A
unit4A!.tenant = john
```

<!--
  - test: `referenceCycles`

  ```swifttest
  -> john!.apartment = unit4A
  -> unit4A!.tenant = john
  ```
-->

Here's how the strong references look after you link the two instances together:

![](referenceCycle02)

Unfortunately, linking these two instances creates
a strong reference cycle between them.
The `Person` instance now has a strong reference to the `Apartment` instance,
and the `Apartment` instance has a strong reference to the `Person` instance.
Therefore, when you break the strong references held by
the `john` and `unit4A` variables,
the reference counts don't drop to zero,
and the instances aren't deallocated by ARC:

```swift
john = nil
unit4A = nil
```

<!--
  - test: `referenceCycles`

  ```swifttest
  -> john = nil
  -> unit4A = nil
  ```
-->

Note that neither deinitializer was called
when you set these two variables to `nil`.
The strong reference cycle prevents the `Person` and `Apartment` instances
from ever being deallocated, causing a memory leak in your app.

Here's how the strong references look after you set
the `john` and `unit4A` variables to `nil`:

![](referenceCycle03)

The strong references between the `Person` instance
and the `Apartment` instance remain and can't be broken.

## Resolving Strong Reference Cycles Between Class Instances

Swift provides two ways to resolve strong reference cycles
when you work with properties of class type:
weak references and unowned references.

Weak and unowned references enable one instance in a reference cycle
to refer to the other instance *without* keeping a strong hold on it.
The instances can then refer to each other without creating a strong reference cycle.

Use a weak reference when the other instance has a shorter lifetime ---
that is, when the other instance can be deallocated first.
In the `Apartment` example above,
it's appropriate for an apartment to be able to have
no tenant at some point in its lifetime,
and so a weak reference is an appropriate way to break the reference cycle in this case.
In contrast, use an unowned reference when the other instance
has the same lifetime or a longer lifetime.

<!--
  QUESTION: how do I answer the question
  "which of the two properties in the reference cycle
  should be marked as weak or unowned?"
-->

### Weak References

A *weak reference* is a reference that doesn't keep a strong hold
on the instance it refers to,
and so doesn't stop ARC from disposing of the referenced instance.
This behavior prevents the reference from becoming part of a strong reference cycle.
You indicate a weak reference by placing the `weak` keyword
before a property or variable declaration.

Because a weak reference doesn't keep a strong hold on the instance it refers to,
it's possible for that instance to be deallocated
while the weak reference is still referring to it.
Therefore, ARC automatically sets a weak reference to `nil`
when the instance that it refers to is deallocated.
And, because weak references need to allow
their value to be changed to `nil` at runtime,
they're always declared as variables, rather than constants, of an optional type.

You can check for the existence of a value in the weak reference,
just like any other optional value,
and you will never end up with
a reference to an invalid instance that no longer exists.

> Note: Property observers aren't called
> when ARC sets a weak reference to `nil`.

<!--
  - test: `weak-reference-doesnt-trigger-didset`

  ```swifttest
  -> class C {
         weak var w: C? { didSet { print("did set") } }
     }
  -> var c1 = C()
  -> do {
  ->     let c2 = C()
  ->     assert(c1.w == nil)
  ->     c1.w = c2
  << did set
  ->     assert(c1.w != nil)
  -> } // ARC deallocates c2; didSet doesn't fire.
  -> assert(c1.w == nil)
  ```
-->

The example below is identical to the `Person` and `Apartment` example from above,
with one important difference.
This time around, the `Apartment` type's `tenant` property
is declared as a weak reference:

```swift
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}
```

<!--
  - test: `weakReferences`

  ```swifttest
  -> class Person {
        let name: String
        init(name: String) { self.name = name }
        var apartment: Apartment?
        deinit { print("\(name) is being deinitialized") }
     }
  ---
  -> class Apartment {
        let unit: String
        init(unit: String) { self.unit = unit }
        weak var tenant: Person?
        deinit { print("Apartment \(unit) is being deinitialized") }
     }
  ```
-->

The strong references from the two variables (`john` and `unit4A`)
and the links between the two instances are created as before:

```swift
var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john
```

<!--
  - test: `weakReferences`

  ```swifttest
  -> var john: Person?
  -> var unit4A: Apartment?
  ---
  -> john = Person(name: "John Appleseed")
  -> unit4A = Apartment(unit: "4A")
  ---
  -> john!.apartment = unit4A
  -> unit4A!.tenant = john
  ```
-->

Here's how the references look now that you've linked the two instances together:

![](weakReference01)

The `Person` instance still has a strong reference to the `Apartment` instance,
but the `Apartment` instance now has a *weak* reference to the `Person` instance.
This means that when you break the strong reference held by
the `john` variable by setting it to `nil`,
there are no more strong references to the `Person` instance:

```swift
john = nil
// Prints "John Appleseed is being deinitialized"
```

<!--
  - test: `weakReferences`

  ```swifttest
  -> john = nil
  <- John Appleseed is being deinitialized
  ```
-->

Because there are no more strong references to the `Person` instance,
it's deallocated
and the `tenant` property is set to `nil`:

![](weakReference02)

The only remaining strong reference to the `Apartment` instance
is from the `unit4A` variable.
If you break *that* strong reference,
there are no more strong references to the `Apartment` instance:

```swift
unit4A = nil
// Prints "Apartment 4A is being deinitialized"
```

<!--
  - test: `weakReferences`

  ```swifttest
  -> unit4A = nil
  <- Apartment 4A is being deinitialized
  ```
-->

Because there are no more strong references to the `Apartment` instance,
it too is deallocated:

![](weakReference03)

> Note: In systems that use garbage collection,
> weak pointers are sometimes used to implement a simple caching mechanism
> because objects with no strong references are deallocated
> only when memory pressure triggers garbage collection.
> However, with ARC, values are deallocated
> as soon as their last strong reference is removed,
> making weak references unsuitable for such a purpose.

### Unowned References

Like a weak reference,
an *unowned reference* doesn't keep
a strong hold on the instance it refers to.
Unlike a weak reference, however,
an unowned reference is used when the other instance
has the same lifetime or a longer lifetime.
You indicate an unowned reference by placing the `unowned` keyword
before a property or variable declaration.

Unlike a weak reference,
an unowned reference is expected to always have a value.
As a result,
marking a value as unowned doesn't make it optional,
and ARC never sets an unowned reference's value to `nil`.

<!--
  Everything that unowned can do, weak can do slower and more awkwardly
  (but still correctly).
  Unowned is interesting because it's faster and easier (no optionals) ---
  in the cases where it's actually correct for your data.
-->

> Important: Use an unowned reference only when you are sure that
> the reference *always* refers to an instance that hasn't been deallocated.
>
> If you try to access the value of an unowned reference
> after that instance has been deallocated,
> you'll get a runtime error.

<!--
  One way to satisfy that requirement is to
  always access objects that have unmanaged properties through their owner
  instead of keeping a reference to them directly,
  because those direct references could outlive the owner.
  However... this strategy really only works when the unowned reference
  is a backpointer from an object up to its owner.
-->

The following example defines two classes, `Customer` and `CreditCard`,
which model a bank customer and a possible credit card for that customer.
These two classes each store an instance of the other class as a property.
This relationship has the potential to create a strong reference cycle.

The relationship between `Customer` and `CreditCard` is slightly different from
the relationship between `Apartment` and `Person`
seen in the weak reference example above.
In this data model, a customer may or may not have a credit card,
but a credit card will *always* be associated with a customer.
A `CreditCard` instance never outlives the `Customer` that it refers to.
To represent this, the `Customer` class has an optional `card` property,
but the `CreditCard` class has an unowned (and non-optional) `customer` property.

Furthermore, a new `CreditCard` instance can *only* be created
by passing a `number` value and a `customer` instance
to a custom `CreditCard` initializer.
This ensures that a `CreditCard` instance always has
a `customer` instance associated with it when the `CreditCard` instance is created.

Because a credit card will always have a customer,
you define its `customer` property as an unowned reference,
to avoid a strong reference cycle:

```swift
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}
```

<!--
  - test: `unownedReferences`

  ```swifttest
  -> class Customer {
        let name: String
        var card: CreditCard?
        init(name: String) {
           self.name = name
        }
        deinit { print("\(name) is being deinitialized") }
     }
  ---
  -> class CreditCard {
        let number: UInt64
        unowned let customer: Customer
        init(number: UInt64, customer: Customer) {
           self.number = number
           self.customer = customer
        }
        deinit { print("Card #\(number) is being deinitialized") }
     }
  ```
-->

> Note: The `number` property of the `CreditCard` class is defined with
> a type of `UInt64` rather than `Int`,
> to ensure that the `number` property's capacity is large enough to store
> a 16-digit card number on both 32-bit and 64-bit systems.

This next code snippet defines an optional `Customer` variable called `john`,
which will be used to store a reference to a specific customer.
This variable has an initial value of nil, by virtue of being optional:

```swift
var john: Customer?
```

<!--
  - test: `unownedReferences`

  ```swifttest
  -> var john: Customer?
  ```
-->

You can now create a `Customer` instance,
and use it to initialize and assign a new `CreditCard` instance
as that customer's `card` property:

```swift
john = Customer(name: "John Appleseed")
john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
```

<!--
  - test: `unownedReferences`

  ```swifttest
  -> john = Customer(name: "John Appleseed")
  -> john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
  ```
-->

Here's how the references look, now that you've linked the two instances:

![](unownedReference01)

The `Customer` instance now has a strong reference to the `CreditCard` instance,
and the `CreditCard` instance has an unowned reference to the `Customer` instance.

Because of the unowned `customer` reference,
when you break the strong reference held by the `john` variable,
there are no more strong references to the `Customer` instance:

![](unownedReference02)

Because there are no more strong references to the `Customer` instance,
it's deallocated.
After this happens,
there are no more strong references to the `CreditCard` instance,
and it too is deallocated:

```swift
john = nil
// Prints "John Appleseed is being deinitialized"
// Prints "Card #1234567890123456 is being deinitialized"
```

<!--
  - test: `unownedReferences`

  ```swifttest
  -> john = nil
  <- John Appleseed is being deinitialized
  <- Card #1234567890123456 is being deinitialized
  ```
-->

The final code snippet above shows that
the deinitializers for the `Customer` instance and `CreditCard` instance
both print their “deinitialized” messages
after the `john` variable is set to `nil`.

> Note: The examples above show how to use *safe* unowned references.
> Swift also provides *unsafe* unowned references for cases where
> you need to disable runtime safety checks ---
> for example, for performance reasons.
> As with all unsafe operations,
> you take on the responsibility for checking that code for safety.
>
> You indicate an unsafe unowned reference by writing `unowned(unsafe)`.
> If you try to access an unsafe unowned reference
> after the instance that it refers to is deallocated,
> your program will try to access the memory location
> where the instance used to be,
> which is an unsafe operation.

<!--
  <rdar://problem/28805121> TSPL: ARC - Add discussion of "unowned" with different lifetimes
  Try expanding the example above so each customer has an array of credit cards.
-->

### Unowned Optional References

You can mark an optional reference to a class as unowned.
In terms of the ARC ownership model,
an unowned optional reference and a weak reference
can both be used in the same contexts.
The difference is that when you use an unowned optional reference,
you're responsible for making sure it always
refers to a valid object or is set to `nil`.

Here's an example that keeps track of the courses
offered by a particular department at a school:

```swift
class Department {
    var name: String
    var courses: [Course]
    init(name: String) {
        self.name = name
        self.courses = []
    }
}

class Course {
    var name: String
    unowned var department: Department
    unowned var nextCourse: Course?
    init(name: String, in department: Department) {
        self.name = name
        self.department = department
        self.nextCourse = nil
    }
}
```

<!--
  - test: `unowned-optional-references`

  ```swifttest
  -> class Department {
         var name: String
         var courses: [Course]
         init(name: String) {
             self.name = name
             self.courses = []
         }
     }
  ---
  -> class Course {
         var name: String
         unowned var department: Department
         unowned var nextCourse: Course?
         init(name: String, in department: Department) {
             self.name = name
             self.department = department
             self.nextCourse = nil
         }
     }
  ```
-->

`Department` maintains a strong reference
to each course that the department offers.
In the ARC ownership model, a department owns its courses.
`Course` has two unowned references,
one to the department
and one to the next course a student should take;
a course doesn't own either of these objects.
Every course is part of some department
so the `department` property isn't an optional.
However,
because some courses don't have a recommended follow-on course,
the `nextCourse` property is an optional.

Here's an example of using these classes:

```swift
let department = Department(name: "Horticulture")

let intro = Course(name: "Survey of Plants", in: department)
let intermediate = Course(name: "Growing Common Herbs", in: department)
let advanced = Course(name: "Caring for Tropical Plants", in: department)

intro.nextCourse = intermediate
intermediate.nextCourse = advanced
department.courses = [intro, intermediate, advanced]
```

<!--
  - test: `unowned-optional-references`

  ```swifttest
  -> let department = Department(name: "Horticulture")
  ---
  -> let intro = Course(name: "Survey of Plants", in: department)
  -> let intermediate = Course(name: "Growing Common Herbs", in: department)
  -> let advanced = Course(name: "Caring for Tropical Plants", in: department)
  ---
  -> intro.nextCourse = intermediate
  -> intermediate.nextCourse = advanced
  -> department.courses = [intro, intermediate, advanced]
  ```
-->

The code above creates a department and its three courses.
The intro and intermediate courses both have a suggested next course
stored in their `nextCourse` property,
which maintains an unowned optional reference to
the course a student should take after completing this one.

![](unownedOptionalReference)

An unowned optional reference doesn't keep a strong hold
on the instance of the class that it wraps,
and so it doesn't prevent ARC from deallocating the instance.
It behaves the same as an unowned reference does under ARC,
except that an unowned optional reference can be `nil`.

Like non-optional unowned references,
you're responsible for ensuring that `nextCourse`
always refers to a course that hasn't been deallocated.
In this case, for example,
when you delete a course from `department.courses`
you also need to remove any references to it
that other courses might have.

> Note: The underlying type of an optional value is `Optional`,
> which is an enumeration in the Swift standard library.
> However, optionals are an exception to the rule that
> value types can't be marked with `unowned`.
>
> The optional that wraps the class
> doesn't use reference counting,
> so you don't need to maintain a strong reference to the optional.

<!--
  - test: `unowned-can-be-optional`

  ```swifttest
  >> class C { var x = 100 }
  >> class D {
  >>     unowned var a: C
  >>     unowned var b: C?
  >>     init(value: C) {
  >>         self.a = value
  >>         self.b = value
  >>     }
  >> }
  >> var c = C() as C?
  >> let d = D(value: c! )
  >> print(d.a.x, d.b?.x as Any)
  << 100 Optional(100)
  ---
  >> c = nil
  // Now that the C instance is deallocated, access to d.a is an error.
  // We manually nil out d.b, which is safe because d.b is an Optional and the
  // enum stays in memory regardless of ARC deallocating the C instance.
  >> d.b = nil
  >> print(d.b?.x as Any)
  << nil
  ```
-->

### Unowned References and Implicitly Unwrapped Optional Properties

The examples for weak and unowned references above
cover two of the more common scenarios
in which it's necessary to break a strong reference cycle.

The `Person` and `Apartment` example shows
a situation where two properties, both of which are allowed to be `nil`,
have the potential to cause a strong reference cycle.
This scenario is best resolved with a weak reference.

The `Customer` and `CreditCard` example
shows a situation where one property that's allowed to be `nil`
and another property that can't be `nil`
have the potential to cause a strong reference cycle.
This scenario is best resolved with an unowned reference.

However, there's a third scenario,
in which *both* properties should always have a value,
and neither property should ever be `nil` once initialization is complete.
In this scenario, it's useful to combine an unowned property on one class
with an implicitly unwrapped optional property on the other class.

This enables both properties to be accessed directly
(without optional unwrapping) once initialization is complete,
while still avoiding a reference cycle.
This section shows you how to set up such a relationship.

The example below defines two classes, `Country` and `City`,
each of which stores an instance of the other class as a property.
In this data model, every country must always have a capital city,
and every city must always belong to a country.
To represent this, the `Country` class has a `capitalCity` property,
and the `City` class has a `country` property:

```swift
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}
```

<!--
  - test: `implicitlyUnwrappedOptionals`

  ```swifttest
  -> class Country {
        let name: String
        var capitalCity: City!
        init(name: String, capitalName: String) {
           self.name = name
           self.capitalCity = City(name: capitalName, country: self)
        }
     }
  ---
  -> class City {
        let name: String
        unowned let country: Country
        init(name: String, country: Country) {
           self.name = name
           self.country = country
        }
     }
  ```
-->

To set up the interdependency between the two classes,
the initializer for `City` takes a `Country` instance,
and stores this instance in its `country` property.

The initializer for `City` is called from within the initializer for `Country`.
However, the initializer for `Country` can't pass `self` to the `City` initializer
until a new `Country` instance is fully initialized,
as described in <doc:Initialization#Two-Phase-Initialization>.

To cope with this requirement,
you declare the `capitalCity` property of `Country` as
an implicitly unwrapped optional property,
indicated by the exclamation point at the end of its type annotation (`City!`).
This means that the `capitalCity` property has a default value of `nil`,
like any other optional,
but can be accessed without the need to unwrap its value
as described in <doc:TheBasics#Implicitly-Unwrapped-Optionals>.

Because `capitalCity` has a default `nil` value,
a new `Country` instance is considered fully initialized
as soon as the `Country` instance sets its `name` property within its initializer.
This means that the `Country` initializer can start to reference and pass around
the implicit `self` property as soon as the `name` property is set.
The `Country` initializer can therefore pass `self` as one of the parameters for
the `City` initializer when the `Country` initializer is setting
its own `capitalCity` property.

All of this means that you can create the `Country` and `City` instances
in a single statement, without creating a strong reference cycle,
and the `capitalCity` property can be accessed directly,
without needing to use an exclamation point to unwrap its optional value:

```swift
var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")
// Prints "Canada's capital city is called Ottawa"
```

<!--
  - test: `implicitlyUnwrappedOptionals`

  ```swifttest
  -> var country = Country(name: "Canada", capitalName: "Ottawa")
  -> print("\(country.name)'s capital city is called \(country.capitalCity.name)")
  <- Canada's capital city is called Ottawa
  ```
-->

In the example above, the use of an implicitly unwrapped optional
means that all of the two-phase class initializer requirements are satisfied.
The `capitalCity` property can be used and accessed like a non-optional value
once initialization is complete,
while still avoiding a strong reference cycle.

## Strong Reference Cycles for Closures

You saw above how a strong reference cycle can be created
when two class instance properties hold a strong reference to each other.
You also saw how to use weak and unowned references to break these strong reference cycles.

A strong reference cycle can also occur
if you assign a closure to a property of a class instance,
and the body of that closure captures the instance.
This capture might occur because the closure's body accesses a property of the instance,
such as `self.someProperty`,
or because the closure calls a method on the instance,
such as `self.someMethod()`.
In either case, these accesses cause the closure to “capture” `self`,
creating a strong reference cycle.

This strong reference cycle occurs because closures, like classes, are *reference types*.
When you assign a closure to a property,
you are assigning a *reference* to that closure.
In essence, it's the same problem as above ---
two strong references are keeping each other alive.
However, rather than two class instances,
this time it's a class instance and a closure that are keeping each other alive.

Swift provides an elegant solution to this problem,
known as a *closure capture list*.
However, before you learn how to break a strong reference cycle with a closure capture list,
it's useful to understand how such a cycle can be caused.

The example below shows how you can create a strong reference cycle
when using a closure that references `self`.
This example defines a class called `HTMLElement`,
which provides a simple model for an individual element within an HTML document:

```swift
class HTMLElement {

    let name: String
    let text: String?

    lazy var asHTML: () -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }

    deinit {
        print("\(name) is being deinitialized")
    }

}
```

<!--
  - test: `strongReferenceCyclesForClosures`

  ```swifttest
  -> class HTMLElement {
  ---
        let name: String
        let text: String?
  ---
        lazy var asHTML: () -> String = {
           if let text = self.text {
              return "<\(self.name)>\(text)</\(self.name)>"
           } else {
              return "<\(self.name) />"
           }
        }
  ---
        init(name: String, text: String? = nil) {
           self.name = name
           self.text = text
        }
  ---
        deinit {
           print("\(name) is being deinitialized")
        }
  ---
     }
  ```
-->

The `HTMLElement` class defines a `name` property,
which indicates the name of the element,
such as `"h1"` for a heading element,
`"p"` for a paragraph element,
or `"br"` for a line break element.
`HTMLElement` also defines an optional `text` property,
which you can set to a string that represents
the text to be rendered within that HTML element.

In addition to these two simple properties,
the `HTMLElement` class defines a lazy property called `asHTML`.
This property references a closure that combines `name` and `text`
into an HTML string fragment.
The `asHTML` property is of type `() -> String`,
or “a function that takes no parameters, and returns a `String` value”.

By default, the `asHTML` property is assigned a closure that returns
a string representation of an HTML tag.
This tag contains the optional `text` value if it exists,
or no text content if `text` doesn't exist.
For a paragraph element, the closure would return `"<p>some text</p>"` or `"<p />"`,
depending on whether the `text` property equals `"some text"` or `nil`.

The `asHTML` property is named and used somewhat like an instance method.
However, because `asHTML` is a closure property rather than an instance method,
you can replace the default value of the `asHTML` property with a custom closure,
if you want to change the HTML rendering for a particular HTML element.

For example, the `asHTML` property could be set to a closure
that defaults to some text if the `text` property is `nil`,
in order to prevent the representation from returning an empty HTML tag:

```swift
let heading = HTMLElement(name: "h1")
let defaultText = "some default text"
heading.asHTML = {
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())
// Prints "<h1>some default text</h1>"
```

<!--
  - test: `strongReferenceCyclesForClosures`

  ```swifttest
  -> let heading = HTMLElement(name: "h1")
  -> let defaultText = "some default text"
  -> heading.asHTML = {
        return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
     }
  -> print(heading.asHTML())
  <- <h1>some default text</h1>
  ```
-->

> Note: The `asHTML` property is declared as a lazy property,
> because it's only needed if and when the element actually needs to be rendered
> as a string value for some HTML output target.
> The fact that `asHTML` is a lazy property means that you can refer to `self`
> within the default closure,
> because the lazy property will not be accessed until
> after initialization has been completed and `self` is known to exist.

The `HTMLElement` class provides a single initializer,
which takes a `name` argument and (if desired) a `text` argument
to initialize a new element.
The class also defines a deinitializer,
which prints a message to show when an `HTMLElement` instance is deallocated.

Here's how you use the `HTMLElement` class to create and print a new instance:

```swift
var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
// Prints "<p>hello, world</p>"
```

<!--
  - test: `strongReferenceCyclesForClosures`

  ```swifttest
  -> var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
  -> print(paragraph!.asHTML())
  <- <p>hello, world</p>
  ```
-->

> Note: The `paragraph` variable above is defined as an *optional* `HTMLElement`,
> so that it can be set to `nil` below to demonstrate
> the presence of a strong reference cycle.

Unfortunately, the `HTMLElement` class, as written above,
creates a strong reference cycle between
an `HTMLElement` instance and the closure used for its default `asHTML` value.
Here's how the cycle looks:

![](closureReferenceCycle01)

The instance's `asHTML` property holds a strong reference to its closure.
However, because the closure refers to `self` within its body
(as a way to reference `self.name` and `self.text`),
the closure *captures* self,
which means that it holds a strong reference back to the `HTMLElement` instance.
A strong reference cycle is created between the two.
(For more information about capturing values in a closure,
see <doc:Closures#Capturing-Values>.)

> Note: Even though the closure refers to `self` multiple times,
> it only captures one strong reference to the `HTMLElement` instance.

If you set the `paragraph` variable to `nil`
and break its strong reference to the `HTMLElement` instance,
the strong reference cycle prevents deallocating
both the `HTMLElement` instance and its closure:

```swift
paragraph = nil
```

<!--
  - test: `strongReferenceCyclesForClosures`

  ```swifttest
  -> paragraph = nil
  ```
-->

Note that the message in the `HTMLElement` deinitializer isn't printed,
which shows that the `HTMLElement` instance isn't deallocated.

## Resolving Strong Reference Cycles for Closures

You resolve a strong reference cycle between a closure and a class instance
by defining a *capture list* as part of the closure's definition.
A capture list defines the rules to use when capturing one or more reference types
within the closure's body.
As with strong reference cycles between two class instances,
you declare each captured reference to be a weak or unowned reference
rather than a strong reference.
The appropriate choice of weak or unowned depends on
the relationships between the different parts of your code.

> Note: Swift requires you to write `self.someProperty` or `self.someMethod()`
> (rather than just `someProperty` or `someMethod()`)
> whenever you refer to a member of `self` within a closure.
> This helps you remember that it's possible to capture `self` by accident.

### Defining a Capture List

Each item in a capture list is a pairing of the `weak` or `unowned` keyword
with a reference to a class instance (such as `self`)
or a variable initialized with some value (such as `delegate = self.delegate`).
These pairings are written within a pair of square braces, separated by commas.

Place the capture list before a closure's parameter list and return type
if they're provided:

```swift
lazy var someClosure = {
        [unowned self, weak delegate = self.delegate]
        (index: Int, stringToProcess: String) -> String in
    // closure body goes here
}
```

<!--
  - test: `strongReferenceCyclesForClosures`

  ```swifttest
  >> class SomeClass {
  >> var delegate: AnyObject?
     lazy var someClosure = {
           [unowned self, weak delegate = self.delegate]
           (index: Int, stringToProcess: String) -> String in
        // closure body goes here
  >>    return "foo"
     }
  >> }
  ```
-->

If a closure doesn't specify a parameter list or return type
because they can be inferred from context,
place the capture list at the very start of the closure,
followed by the `in` keyword:

```swift
lazy var someClosure = {
        [unowned self, weak delegate = self.delegate] in
    // closure body goes here
}
```

<!--
  - test: `strongReferenceCyclesForClosures`

  ```swifttest
  >> class AnotherClass {
  >> var delegate: AnyObject?
     lazy var someClosure = {
           [unowned self, weak delegate = self.delegate] in
        // closure body goes here
  >>    return "foo"
     }
  >> }
  ```
-->

### Weak and Unowned References

Define a capture in a closure as an unowned reference
when the closure and the instance it captures will always refer to each other,
and will always be deallocated at the same time.

Conversely, define a capture as a weak reference when the captured reference
may become `nil` at some point in the future.
Weak references are always of an optional type,
and automatically become `nil` when the instance they reference is deallocated.
This enables you to check for their existence within the closure's body.

<!--
  <rdar://problem/28812110> Reframe discussion of weak/unowned closure capture in terms of object graph
-->

> Note: If the captured reference will never become `nil`,
> it should always be captured as an unowned reference,
> rather than a weak reference.

An unowned reference is the appropriate capture method to use to resolve
the strong reference cycle in the `HTMLElement` example
from <doc:AutomaticReferenceCounting#Strong-Reference-Cycles-for-Closures> above.
Here's how you write the `HTMLElement` class to avoid the cycle:

```swift
class HTMLElement {

    let name: String
    let text: String?

    lazy var asHTML: () -> String = {
            [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }

    deinit {
        print("\(name) is being deinitialized")
    }

}
```

<!--
  - test: `unownedReferencesForClosures`

  ```swifttest
  -> class HTMLElement {
  ---
        let name: String
        let text: String?
  ---
        lazy var asHTML: () -> String = {
              [unowned self] in
           if let text = self.text {
              return "<\(self.name)>\(text)</\(self.name)>"
           } else {
              return "<\(self.name) />"
           }
        }
  ---
        init(name: String, text: String? = nil) {
           self.name = name
           self.text = text
        }
  ---
        deinit {
           print("\(name) is being deinitialized")
        }
  ---
     }
  ```
-->

This implementation of `HTMLElement` is identical to the previous implementation,
apart from the addition of a capture list within the `asHTML` closure.
In this case, the capture list is `[unowned self]`,
which means “capture self as an unowned reference rather than a strong reference”.

You can create and print an `HTMLElement` instance as before:

```swift
var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
// Prints "<p>hello, world</p>"
```

<!--
  - test: `unownedReferencesForClosures`

  ```swifttest
  -> var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
  -> print(paragraph!.asHTML())
  <- <p>hello, world</p>
  ```
-->

Here's how the references look with the capture list in place:

![](closureReferenceCycle02)

This time, the capture of `self` by the closure is an unowned reference,
and doesn't keep a strong hold on the `HTMLElement` instance it has captured.
If you set the strong reference from the `paragraph` variable to `nil`,
the `HTMLElement` instance is deallocated,
as can be seen from the printing of its deinitializer message in the example below:

```swift
paragraph = nil
// Prints "p is being deinitialized"
```

<!--
  - test: `unownedReferencesForClosures`

  ```swifttest
  -> paragraph = nil
  <- p is being deinitialized
  ```
-->

For more information about capture lists,
see <doc:Expressions#Capture-Lists>.

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
