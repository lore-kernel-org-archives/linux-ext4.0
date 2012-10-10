From: zwu.kernel@gmail.com
Subject: [RFC v3 00/13] vfs: hot data tracking
Date: Wed, 10 Oct 2012 18:07:22 +0800
Message-ID: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

NOTE:

  The patchset is currently post out mainly to make sure
it is going in the correct direction and hope to get some
helpful comments from other guys.
  For more infomation, please check hot_tracking.txt in Documentation

TODO List:

 1.) Need to do scalability or performance tests.
 2.) Turn some Micro into be tunable
       TIME_TO_KICK, and HEAT_UPDATE_DELAY
 3.) Rafactor hot_hash_is_aging()
       If you just made the timeout value a timespec and compared
     the _timespecs_, you would be doing a lot fewer conversions.
 4.) Cleanup some unnecessary lock protect
 5.) Add more comments to explain how to calc temperature
       How to "read" the avg read/write time (nanoseconds,
     microseconds, jiffies....??)
 6.) Make updating tempreture more parallel
 7.) How to save the file tempreture among the umount to be able to
     preserve the file tempreture after reboot
 8.) Add one new ioctl inteface to set temperature value.

Ben Chociej, Matt Lupfer and Conor Scott originally wrote this code to
 be very btrfs-specific.  I've taken their code and attempted to
make it more generic and integrate it at the VFS level.

Changelog from v2:
 1.) Converted to Radix trees, not RB-tree [Zhiyong, Dave Chinner]
 2.) Added memory shrinker [Dave Chinner]
 3.) Converted to one workqueue to update map info periodically [Dave Chinner]
 4.) Cleanedup a lot of other issues [Dave Chinner]

v1:
 1.) Reduce new files and put all in fs/hot_tracking.[ch] [Dave Chinner]
 2.) The first three patches can probably just be flattened into one.
                                        [Marco Stornelli , Dave Chinner]

Zhi Yong Wu (13):
  btrfs: add one new mount option '-o hot_track'
  vfs: introduce private radix tree structures
  vfs: Initialize and free main data structures
  vfs: add function for collecting raw access info
  vfs: add two map arrays
  vfs: add hooks to enable hot data tracking
  vfs: add function for updating map arrays
  vfs: add aging function for old map info
  vfs: add one wq to update map info periodically
  vfs: register one memory shrinker
  vfs: add 3 new ioctl interfaces
  vfs: add debugfs support
  vfs: add documentation

 Documentation/filesystems/00-INDEX         |    2 +
 Documentation/filesystems/hot_tracking.txt |  165 ++++
 fs/Makefile                                |    2 +-
 fs/btrfs/ctree.h                           |    1 +
 fs/btrfs/super.c                           |   15 +-
 fs/compat_ioctl.c                          |    9 +
 fs/direct-io.c                             |    8 +
 fs/hot_tracking.c                          | 1321 ++++++++++++++++++++++++++++
 fs/hot_tracking.h                          |  155 ++++
 fs/ioctl.c                                 |  122 +++
 include/linux/fs.h                         |    4 +
 include/linux/hot_tracking.h               |  123 +++
 mm/filemap.c                               |    7 +
 mm/page-writeback.c                        |   13 +
 mm/readahead.c                             |    7 +
 15 files changed, 1952 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/filesystems/hot_tracking.txt
 create mode 100644 fs/hot_tracking.c
 create mode 100644 fs/hot_tracking.h
 create mode 100644 include/linux/hot_tracking.h

-- 
1.7.6.5
