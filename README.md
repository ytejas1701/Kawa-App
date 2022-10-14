# Kawa: Flutter App for Learning Kanji 
## Flashcard based Kanji learning app which used an SRS model
Users can progress through levels, unlock new kanji and review Kanji based on a Spaced Repetition System. Users can review Kanji through a quiz-like interface which converts their responses into the Japanese script. If they answer incorrectly, then the reviews are conducted more frequently. As the user gets better with a Kanji, their level increases and new Kanji are unlocked.

I used Firebase as the backend for this app. For collecting the Kanji data, I scraped over 1000 Kanji characters from different websites and stored them in a JSON file. I designed the user interface myself, taking inspiration from some other flashcard based apps. I implemented a Spaced Repetition Algorithm, which enables the user to rapidly learn Kanji characters by spacing successive reviews in accordance with user performance. I developed the app with Flutter, utilizing its Provider Package and a kanakit package for translating user iput into the Japanese script.

## Features

## Gallery
<p>
  <img src="https://user-images.githubusercontent.com/97452093/195892454-7d666e61-7fee-47ce-a536-3565dcd1306d.jpg" width="200" />
  <img src="https://user-images.githubusercontent.com/97452093/195892460-ff8460ac-da1b-42d5-a90f-3a538ba31ad3.jpg" width="200" /> 
  <img src="https://user-images.githubusercontent.com/97452093/195892466-e443ee1a-0d39-4bca-984f-61555b5a8161.jpg" width="200" /> 
  <img src="https://user-images.githubusercontent.com/97452093/195892475-dc0ec9ac-91f3-444a-8c42-f68b10eb34c2.jpg" width="200" /> 
</p>
