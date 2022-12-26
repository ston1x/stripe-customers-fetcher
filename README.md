# stripe-customers-fetcher

This Ruby program is intended to fetch customers via Stripe API and store them in a CSV file.

## Features
- Downloads and saves customers to a CSV file given a Stripe API key
- If the program is killed or interrupted at some point, it will continue from last written customer on the next launch
-

## Usage
- It is recommended to have at least ruby 3.1.2
- Run $ `bundle`
- Run $ `bin/run`
  - NOTE: You can optionally provide custom output file path: $ `bin/run my_output_file.csv`

## Q&A
- Were other approaches of fetching considered?
  - Yes. The `stripe` Ruby gem provides a handy [auto-pagination](https://stripe.com/docs/api/pagination/auto?lang=ruby), however because of the specifics of working on an "each customer" level, I've considered re-opening and closing CSV on every customer to be too expensive. The program needs to save the file at iterative intervals in order to have "checkpoints" to be able to continue after restarting.
