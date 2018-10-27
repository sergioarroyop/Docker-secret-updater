# Docker secret updater

As docker doesn't have a docker secret update command, here is a bash script for updating secrets without stopping any service.

# HOW IT WORKS? 🔩

The script will create a new "second" secret and update the desire service with the new "second" secret. Doing this way you will be able to manage your main secret without stopping the service. Then the script will create your main secret with the new env.file and update the desire service with it.

# USAGE 🖥

You can run the script without arguments for checking the usage.

./DockerSecret_updater. sh <env.file> <secret_name> <service_name>
