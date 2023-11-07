# ImagesFeed

## Назначение и цели приложения ##

Многостраничное приложение предназначено для просмотра изображений через API Unsplash.

Цели приложения:

- Просмотр бесконечной ленты картинок из Unsplash Editorial.
- Просмотр краткой информации из профиля пользователя.

## Краткое описание приложения ##

- В приложении обязательна авторизация через OAuth Unsplash.
- Главный экран состоит из ленты с изображениями. Пользователь может просматривать ее, добавлять и удалять изображения из избранного.
- Пользователи могут просматривать каждое изображение отдельно и делиться ссылкой на них за пределами приложения.
- У пользователя есть профиль с избранными изображениями и краткой информацией о пользователе.
- Дополнительно механика избранного и возможность лайкать фотографии при просмотре изображения на весь экран.

## Стек технологий ##
- Swift, UIKit
- Архитектура: MVP
- Верстка кодом
- UIKit: UITabBarController, UITableView, WKWebView
- URLSession
- Keychain
- OAuth 2.0
- Swift Package Manager
- Kingfisher
- Unit, UI тесты

## Запись экрана с демонстрацией работы ##
![Screenshot](screencast.gif?raw=true)

## Установка ##
Установка и запуск через Xcode. Требуемые зависимости закгружаются с помощью Swift Package Manager. 

Минимальная версия системы iOS 13.0.

Для использования приложения необходимо иметь учетную запись в сервисе [Unsplash](<https://unsplash.com>)
