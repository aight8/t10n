# t10n Server Application

This RoR App which provides the top 10 stories with the most growth rate.

## Initial position

### Specs

- [ ] **Use the Hacker News API** to fetch the data
- [ ] **Host** your application somewhere (we recommend **Heroku**)
- [ ] Use Ruby on Rails, but instead of the standard templating engine, use React. You can either use the rails-react gem or **create the RoR application in API mode** and **build a separate React-only app**
- [ ] Bonus points if you display somewhere a current record holder. Meaning the entry that had the fastest growth per time unit yet (update, if necessary, with every refresh). **It should be saved in a persistent database (e.g. PostgreSQL or MySQL)**
- [ ] **Bonus points if you write appropriate tests** (you can use the testing library of your choice, we like Minitest or **RSpec**)
- [ ] Bonus points if you add a CI (e.g. CircleCI or **Heroku Pipeline’s Test** feature)

## Implementation

### Needs
-  [ ] Abstract the way how **Story** objects are gathered.
  Currently it uses the Hacker News API how defined in the specs - this result in 500 separate URL requests to fetch all required item details. Theoretically any other source can be used which could generate **Story** objects.

### Technological decision points

- I split the RoR app and the frontend in separate packages because API's are more flexible

### Requirements

- Ruby version ^2.4
