From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/5] ext4: statistic of different data and metadata IO types
Date: Mon, 31 Oct 2011 17:42:59 +0800
Message-ID: <1320054184-14329-1-git-send-email-wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

This patchset adds statistic of different data and metadata IO types.
Some hooks are added into filesystem's read and write routines and we
can see how much IOs are issued to the disk. Meanwhile we ignore the
IOs which hit in cache.

ios structure saves a callback function for counting read operations
because read counter need to be increased in buffer layer.

ext4_ios and related functions are defined to count how much different
types of IOs are issued to the disk in ext4.

Metadata and data types in ext4:
+--------------------------------+
| Metadata:                      |
|      super block               |
|      group desc                |
|      inode bitmap              |
|      block bitmap              |
|      inode table               |
|      extents                   |
|      indirect block            |
|      dir index and entry       |
|      extended attributes       |
+--------------------------------+
| Data:                          |
|      regular data block        |
+--------------------------------+

Wang Shaoyan (5):
	ext4: add data structure and functions for io statistic
	ext4: add hooks in buffer layer
	ext4: io stat read related entrance
	ext4: io stat write related entrance
	ext4: io stat show result in sysfs
-- 
1.7.4.1
