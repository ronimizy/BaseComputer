# BaseComputer

## Телеграм канал с новостями о программе
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
    
    
## Формат .bcmc
Используется для записи микро-програм в память микро-команд БЭВМ

- Формат имеет два вида синтаксиса
  - Полное перечисление микро-програмы
  - Частичное перечисление микро-програмы
    ```
    POSITION XXX
    ...
    ```
    
    Используется для внедрения микро-програмы
