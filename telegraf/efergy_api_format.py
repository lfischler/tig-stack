
import urllib.request
import urllib.error
import json
import os


efergy_tokens = {
    'P1': os.environ.get('EFERGY_TOKEN_1'),
    'P2': os.environ.get('EFERGY_TOKEN_2')
}


def run_efergy_request(efergy_token):
    '''
    Runs the api request itself to efergy and returns a dict with the data
    and other info about the household.
    '''

    # build up the efergy request url. Find API documentation here:
    # `http://napi.hbcontent.com/document/index.php``
    request = f"http://www.energyhive.com/mobile_proxy/" \
              f"getCurrentValuesSummary?" \
              f"token={efergy_token}"

    result = urllib.request.Request(request)
    # send request to efergy

    try:
        response_byte = urllib.request.urlopen(result).read()
        # downloads in byte format the response from the api
        response_dict = json.loads(response_byte.decode('utf-8'))
        # turns bytes format to dictionary/json

    except urllib.error.URLError as url_error:
        # Handle URL-related errors (e.g., network issues, invalid URLs)
        print(f"Error fetching data: {url_error}")
        response_dict = None

    except json.JSONDecodeError as json_error:
        # Handle JSON decoding errors (e.g., invalid JSON format)
        print(f"Error decoding JSON: {json_error}")
        response_dict = None

    return response_dict


def convert_to_line(api_output, participant_no):
    '''
    Converts to line protocol format

    Returns:
        `measurement,sid=<sensor-sid> value=<power-reading> timecode`
        Will return one new line for every sensor as per InfluxDB requirements.
    '''

    line_protocol_data_list = []
    # create empty list to store line protocol data

    # line_protocol_all_data_string = ""
    # # create empty string which will store the line protocol data in the
    # # correct format (with new lines between readings)

    # Iterate through each item in the 'api_output' list returned
    for item in api_output:
        # save type of measurement
        measurement = item['cid']
        # save SID number
        tags = f'sid={item["sid"]},participant_no={participant_no}'
        # Iterate through each datapoint in the 'data' list
        for datapoint in item['data']:
            # Extract the timestamp and value from the datapoint
            for timestamp, value in datapoint.items():
                # Create fields using the extracted value
                fields = f'value={value}'
                # Construct the line protocol format for the specific reading
                reading_in_line_protocol = f'{measurement},{tags} {fields}'
                # Append the reading to the list of line protocol data
                line_protocol_data_list.append(reading_in_line_protocol)

    # Join all the line protocol data strings with newline characters
    line_protocol_all_data_string = '\n'.join(line_protocol_data_list)

    return line_protocol_all_data_string


all_line_data = []

for participant, token in efergy_tokens.items():
    api_output = run_efergy_request(token)
    if api_output is not None:
        line_data = convert_to_line(api_output, participant)
        all_line_data.append(line_data)
    else:
        print(f"HTTP error occurred for {participant}")


final_line_data = '\n'.join(all_line_data)
print(final_line_data)
