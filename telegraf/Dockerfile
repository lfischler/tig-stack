# Use the official Telegraf image as a parent image
FROM telegraf:1.30.3

# Update the package lists and install Python and pip
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv && \
    rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment, then install boto3
RUN python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install boto3

# Ensure the virtual environment is activated in the shell
ENV PATH="/opt/venv/bin:$PATH"

# clean cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /etc/telegraf

# Copy files into the container
COPY efergy_api_format.py $EFERGY_SCRIPT_PATH

# Source the virtual environment in the entrypoint script
ENTRYPOINT ["/bin/bash", "-c", ". /opt/venv/bin/activate && exec telegraf"]

# Run Telegraf when the container launches
CMD ["telegraf"]
