# Use the official Telegraf image as a parent image
FROM telegraf:latest

# Update the package lists for upgrades and new packages
RUN apt-get update

# Install Python and pip
RUN apt-get install -y python3 python3-pip

# clean cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
# WORKDIR /etc/telegraf

# # Make ports available to the world outside this container
# EXPOSE 8125/udp 8092/udp 8094

# Run Telegraf when the container launches
CMD ["telegraf"]
