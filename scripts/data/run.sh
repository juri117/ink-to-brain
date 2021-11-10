mkdir logs
start ./ink2brain.exe  > "./logs/$(date '+%d-%m-%Y_%H-%M-%S')_stout.txt" 2>&1
