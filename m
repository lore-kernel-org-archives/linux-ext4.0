From: Beata Michalska <b.michalska@samsung.com>
Subject: [PATCH v2 0/2] ext4: Add pollable sysfs entry for block threshold
 events
Date: Mon, 16 Mar 2015 14:25:27 +0100
Message-ID: <1426512329-24299-1-git-send-email-b.michalska@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
To: lczerner@redhat.com, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


There has been a request to provide a notification whenever
the amount of free space drops below a certain level.
This level, preferably, could be adjusted based on the actual
space usage, so that appropraite actions can be undertaken
for different levels being reached. The idea here is to expose
a pollabe sysfs entry through which the threshold can be spcified,
in a form of a number of used logical blocks. Then, the process might
wait for a notification, through the very same sysfs entry, instead of
periodically calling statfs - as the concept introduced, is to
resemble the very last with hopefully, minimum overhead. When
the process wakes-up it might decide to increase the threshold
and once again wait for the notification.

---
v2:
	- rename the helper function to ext4_mark_group_corrupted
          and move the changes to a separate patch
	- move the call to notify function from ext4_mb_new_blocks
          and ext4_da_reserve_space to ext4_has_free_clusters,
          remove it from ext4_update_super
	- switch from used to available blocks
	- add documnetation for new sysfs entry
---

Beata Michalska (2):
  ext4: Add helper function to mark group as corrupted
  ext4: Add pollable sysfs entry for block threshold events

 Documentation/filesystems/ext4.txt |   11 +++++++
 fs/ext4/balloc.c                   |   45 +++++++++++---------------
 fs/ext4/ext4.h                     |   14 +++++++++
 fs/ext4/ialloc.c                   |    5 +--
 fs/ext4/mballoc.c                  |   13 ++------
 fs/ext4/super.c                    |   61 ++++++++++++++++++++++++++++++++++--
 6 files changed, 106 insertions(+), 43 deletions(-)

-- 
1.7.9.5
