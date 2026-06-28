# DT_ERASE - DATA ERASER

# INFO

Bash script that securely erases data from a selected block device.
It utilizes hardware-level TRIM (blkdiscard) for supported SSDs, or falls back to zero-filling (dd) for traditional HDDs.

Note: If your SSD does not support Deterministic TRIM (RZAT/DZAT), residual data may still be temporarily readable until the drive's internal garbage collection completes execution in the background.

# REQUIREMENTS

- At least 1 target storage drive
- Root privileges (sudo)

# HOW TO START

1. chmod +x DTERASE.sh
2. sudo ./DTERASE.sh
