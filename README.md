# BaseComputer

## Подпишись на телеграм канал чтобы не пропускать обновления
**https://t.me/BaseComputer**

## Формат .bc
Используется для записи програм в память БЭВМ

- Начало программы обозначается знаком '+' (Обязательно с пробелом после) 
  ```
  + 00A F000
  ```
- Формат имеет два вида синтаксиса
  - Явная нумерация 
    ```
    + 00A F200 
    00B F200
    ```
  - Указательная нумерация
    ```
    POSITION 00A
    + F200 //00A
    F200 //00B
    POSITION 010
    F200 //010
    F200 //011
    ```
    
    
## Формат .bcmp
Используется для записи микро-программ в память микро-команд БЭВМ

- Формат имеет два вида синтаксиса
  - Полное перечисление микро-программы (**Open Micro Program**)
    /* Все микро-команды МПУ */
    //Ваша микро программа
    3031 
    A98F
    ......
    
    **ВАЖНО! "Open Micro Program" подразумевает наличие в файле ПОЛНОЙ микро программы для МПУ**
    **У "Open Micro Program" нет адресации, формат является списком микро-команд**
    **Чтобы получить пример записи в таком виде и шаблон для редактирования, нажмите "Save Micro Program"**
  - Частичное перечисление микро-программы
    ```
    POSITION XXX
    3031
    A98F
    ....
    ```
    
    **Такой вид записи перезапишет ячейки памяти микро-команд МПУ начиная с ХХХ**
    Используется для внедрения микро-программы
    
    
## Автоматическое использование ВУ
- Под каждым ВУ есть текстовое поле "Очередь", оно нужно, если требуется подать на ВУ несколько значений подряд.
- Различные значения записываются через пробел.
- Для автоматическая работа ВУ достигается с помощью трассировки 
    - советую использовать трассировку с выборочным количеством команд <kbd> ⌘ </kbd> + <kbd> ⌥ </kbd> + <kbd> T </kbd>)
