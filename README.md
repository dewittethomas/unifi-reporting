# Unifi API Reporting in PowerShell

This PowerShell script fetches information from the Unifi API and generates reports on Unifi sites and devices.

## Table of Contents

- [Features](#features)
- [Configuration](#configuration)
- [Usage](#usage)
- [CSV File](#csv-file)
- [Unifi Models](#unifi-models)
- [Contributing](#contributing)
- [License](#license)

## Features

- Retrieves data from the Unifi API, including site and device information.
- Generates JSON files containing site and device data.
- Provides a status report in a CSV file.
- Easily customizable for your Unifi environment.

## Configuration

Before using the script, you need to configure it with your Unifi API credentials and other settings.

Edit the following variables in the `unifi-reporting.ps1` script:

- `$username`: Your Unifi API username.
- `$password`: Your Unifi API password.
- `$hostname`: Your Unifi controller hostname.
- `$port`: The port number for the Unifi controller.
- `$apistatuscsv`: Path to the CSV file for status reporting.
- `$statusname`: Name for the status reporting.

## Usage

1. Clone this repository or download the `unifi-reporting.ps1` script.
2. Configure the script by editing the variables mentioned in the Configuration section.
3. Run the script using PowerShell.

## CSV File

The script appends status information to a CSV file named `api-status.csv`. The CSV file contains the following columns:

- `date`: Date of the status report (dd/MM/yyyy format).
- `time`: Time of the status report (HH:mm:ss format).
- `name`: Name of the Unifi reporting.
- `status`: Status of the script execution (OK or NOK).

## Unifi Models

The project includes a CSV file named `unifi-models.csv` that contains a list of Unifi products. If you find any missing models or would like to contribute by adding new ones, please follow these steps:

1. Fork this repository.
2. Edit the `unifi-models.csv` file to include the missing Unifi models or make any necessary updates.
3. Submit a pull request with your changes, including a brief description of the modifications you made.

Your contribution will help keep the Unifi models data up-to-date and improve this project for the community.

## Contributing

Contributions to this project are welcome. If you have any improvements or bug fixes, please submit a pull request.

## License

This project is licensed under the MIT License.

**Disclaimer:** This script is provided as-is, and the author is not responsible for any issues or data loss caused by its use. Use it responsibly and at your own risk.
