From: Beata Michalska <b.michalska@samsung.com>
Subject: [RFC] ext4: Add pollable sysfs entry for block threshold events
Date: Wed, 11 Mar 2015 11:16:32 +0100
Message-ID: <1426068993-1051-1-git-send-email-b.michalska@samsung.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi All,

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

BR
Beata Michalska
----
Beate Michalska (1):
  ext4: Add pollable sysfs entry for block threshold events

 fs/ext4/balloc.c  |   17 ++++-------------
 fs/ext4/ext4.h    |   12 ++++++++++++
 fs/ext4/ialloc.c  |    5 +----
 fs/ext4/inode.c   |    2 +-
 fs/ext4/mballoc.c |   14 ++++----------
 fs/ext4/resize.c  |    3 ++-
 fs/ext4/super.c   |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 7 files changed, 74 insertions(+), 31 deletions(-)

-- 
1.7.9.5
