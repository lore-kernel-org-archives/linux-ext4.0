From: zwu.kernel@gmail.com
Subject: [RFC v2 00/10] vfs: hot data tracking
Date: Sun, 23 Sep 2012 20:56:25 +0800
Message-ID: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, cmm@us.ibm.com, tytso@mit.edu,
	marco.stornelli@gmail.com, david@fromorbit.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
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

Changelog from v1:
 1.) Reduce new files and put all in fs/hot_tracking.[ch] [Dave Chinner]
 2.) The first three patches can probably just be flattened into one.
					[Marco Stornelli , Dave Chinner]

Zhi Yong Wu (10):
  vfs: introduce private rb structures
  vfs: add support for updating access frequency
  vfs: add one new mount option '-o hottrack'
  vfs: add init and exit support
  vfs: introduce one hash table
  vfs: enable hot data tracking
  vfs: fork one kthread to update data temperature
  vfs: add 3 new ioctl interfaces
  vfs: add debugfs support
  vfs: add documentation

 Documentation/filesystems/hot_tracking.txt |  106 ++
 fs/Makefile                                |    2 +-
 fs/compat_ioctl.c                          |    8 +
 fs/dcache.c                                |    2 +
 fs/direct-io.c                             |   10 +
 fs/hot_tracking.c                          | 1563 ++++++++++++++++++++++++++++
 fs/hot_tracking.h                          |  163 +++
 fs/ioctl.c                                 |  130 +++
 fs/namespace.c                             |   10 +
 fs/super.c                                 |   11 +
 include/linux/fs.h                         |   15 +
 include/linux/hot_tracking.h               |  164 +++
 mm/filemap.c                               |    8 +
 mm/page-writeback.c                        |   21 +
 mm/readahead.c                             |    9 +
 15 files changed, 2221 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/filesystems/hot_tracking.txt
 create mode 100644 fs/hot_tracking.c
 create mode 100644 fs/hot_tracking.h
 create mode 100644 include/linux/hot_tracking.h

-- 
1.7.6.5

