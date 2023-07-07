## Introduction

This application provides a flexible endpoint for creating or updating reservation details, supporting multiple payload formats without the need for explicit identifiers within the payload. By matching payload schemas to internal specifications, we seamlessly store the data in the corresponding `model.attribute`. Administrators can easily add new payload formats by adding in the database.

---

### Models
  
#### Guest
```
  first_name:string
  last_name:string
  phone_numbers:string[]
  email:string
```
  
#### Reservation
```
  code:string
  start_date:date
  end_date:date
  nights_count:integer
  total_guests_count:integer
  adults_count:integer
  children_count:integer
  infants_count:integer
  status:string
  host_currency:string
  payout_price:money
  security_price:money
  total_price:money
  guest:references
```


#### PayloadFormat
```
  schema:json
  provider:string
```

### Services
`ReservationServices::ProcessPayload.call(payload:)`
This service is the core of this app, which handles the format checking and resource handling.
	
---

### Assumptions and Limitations
  1. All values will be converted into their respective attribute type. Further improvements for specificity can be done.
  2. All money values will be converted into a money type to avoid float computation errors.
  3. All included payload formats have unique structure
  4. All fields from payload format schema is required

#### Potential Additions
  1. String regex validation
  2. Date specific format
  3. Float to Integer or vice versa conversions
  4. Nested keys to avoid repetition, ie. Payload 2 schema `reservation.xx`
  5. Strict required/optional fields
  6. PayloadFormat unique schema validation to avoid conflicts
  ---
  
### PayloadFormat Schema 

```
  {
    "<payload_key_nested_with_dots>": "<model.attribute>"
  }
```

#### Samples:
**Payload #1**
```
	{
    "reservation_code": "reservation.code",
    "start_date": "reservation.start_date",
    "end_date": "reservation.end_at",
    "nights": "reservation.nights_count",
	  "guests": "reservation.total_guests_count",
	  "adults": "reservation.adults_count",
	  "children": "reservation.children_count",
	  "infants": "reservation.infants_count",
	  "status": "reservation.status",
	  "guest.first_name": "guest.first_name",
	  "guest.last_name": "guest.last_name",
	  "guest.phone": "guest.phone_numbers[]",
	  "guest.email": "guest.email"
	  "currency": "reservation.host_currency",
	  "payout_price": "reservation.payout_price"
	  "security_price": "reservation.security_price",
	  "total_price": "reservation.total_price"
  }
```

**Payload #2**
```
{
  "reservation.code": "reservation.code",
  "reservation.start_date": "reservation.start_date",
  "reservation.end_date": "reservation.end_date",
  "reservation.expected_payout_amount": "reservation.payout_price",
  "reservation.guest_details.number_of_adults": "reservation.adults_count",
  "reservation.guest_details.number_of_children": "reservation.children_count",
  "reservation.guest_details.number_of_infants": "reservation.infant_count",
  "reservation.guest_email": "guest.email",
  "reservation.guest_first_name": "guest.first_name",
  "reservation.guest_last_name": "guest.last_name",
  "reservation.guest_phone_numbers": "guest.phone_numbers[]",
  "reservation.listing_security_price_accurate": "reservation.security_price",
  "reservation.host_currency": "resrevation.host_currency",
  "reservation.nights": "reservation.nights_count",
  "reservation.status_type": "reservation.status",
  "reservation.total_paid_amount_accurate": "reservation.total_price"
}
```
---

## Setup
```shell
  # Install Ruby Version
  rbenv install 3.1.3

  # Bundle gemfile
  bundle install

  # Prepare database
  bundle exec rails db:create db:schema:load db:seed

  # Run server
  bundle exec rails s -p 3000

  # Server should be running at port 3000
```

> Note: Aside from the default rails 7 api only gems, money-rails, rubocop, factory_bot, and rspec are included in the Gemfile. 

**Adding New Payload Formats**

```ruby

# You can create new payload formats by creating in the console. A sample can be seen in the seeds file.

FactoryBot.create(
  :payload_format,
  provider: "Payload #1",
  schema: {
    reservation_code: 'reservation.code',
    start_date: 'reservation.start_date',
    end_date: 'reservation.end_date',
    nights: 'reservation.nights_count',
    guests: 'reservation.total_guests_count',
    adults: 'reservation.adults_count',
    children: 'reservation.children_count',
    infants: 'reservation.infants_count',
    status: 'reservation.status',
    'guest.first_name': 'guest.first_name',
    'guest.last_name': 'guest.last_name',
    'guest.phone': 'guest.phone_numbers',
    'guest.email': 'guest.email',
    currency: 'reservation.host_currency',
    payout_price: 'reservation.payout_price',
    security_price: 'reservation.security_price',
    total_price: 'reservation.total_price'
  }
)
```
---

# API Documentation

### POST /v1/reservations
> This endpoint can create new reservations from expected payload schema. If a reservation code is already existing, it will attempt to update the existing reservation.

#### Request:
```
{
  "reservation_code": "YYY12345678",
  "start_date": "2021-04-14",
  "end_date": "2021-04-18",
  "nights": 4,
  "guests": 4,
  "adults": 2,
  "children": 2,
  "infants": 0,
  "status": "accepted",
  "guest": {
    "first_name": "Wayne",
    "last_name": "Woodbridge",
    "phone": "639123456789",
    "email": "wayne_woodbridge@bnb.com"
  },  
  "currency": "AUD",
  "payout_price": "4200.00",
  "security_price": "500",
  "total_price": "4700.00"
}
```

#### Response:
**200**
```
  {
    reservation: { reservation_data },
    guest: { guest_data }
  }
```
**422**
```
  {
    errors: [validation_errors]
  }
```
---


