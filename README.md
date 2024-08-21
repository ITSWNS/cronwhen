# CRONWHEN(1)

## NAME
**cronwhen** - Determine the next run time of a cron expression.

## SYNOPSIS
`cronwhen <cron expression>`

## DESCRIPTION
**cronwhen** is a command-line utility that takes a cron expression as input and outputs the next scheduled run time based on the current time. This can be useful for verifying when a particular cron job will execute next.

## OPTIONS
None.

## USAGE
To use **cronwhen**, pass a valid cron expression as an argument:

```sh
cronwhen "0 0 * * *"
```

This will output the next time that the cron job is scheduled to run.

### EXAMPLES
- Determine the next run time of a daily cron job scheduled at midnight:

  ```sh
  cronwhen "0 0 * * *"
  ```
  Output:
  ```
  2024-08-22 00:00:00 +0000 UTC
  ```

- Determine the next run time of a cron job scheduled every Monday at 9 AM:

  ```sh
  cronwhen "0 9 * * 1"
  ```
  Output:
  ```
  2024-08-26 09:00:00 +0000 UTC
  ```

## EXIT STATUS
The **cronwhen** utility exits with one of the following values:

- 0: Success.
- 1: Failed to parse the cron expression or incorrect usage.

## REQUIREMENTS
- Go (Golang) version 1.13 or higher.
- External dependency: [robfig/cron/v3](https://github.com/robfig/cron)

## AUTHOR
Written by ITSWNS.

## COPYRIGHT
MIT License.

## SEE ALSO
`cron(5)`, `crontab(1)`
