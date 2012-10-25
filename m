From: zwu.kernel@gmail.com
Subject: [RFC v4 00/15] vfs: hot data tracking
Date: Thu, 25 Oct 2012 23:08:52 +0800
Message-ID: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

NOTE:

  The patchset can be obtained via my kernel dev git on github:
git@github.com:wuzhy/kernel.git hot_tracking
  If you're interested, you can also can review them via
https://github.com/wuzhy/kernel/commits/hot_tracking

  For more infomation, please check hot_tracking.txt in Documentation

TODO List:

 1.) Need to do scalability or performance tests.
 2.) How to save the file temperature among the umount to be able to
     preserve the file tempreture after reboot

Ben Chociej, Matt Lupfer and Conor Scott originally wrote this code to
 be very btrfs-specific.  I've taken their code and attempted to
make it more generic and integrate it at the VFS level.

Changelog from v3:
 1.) Rewritten debugfs support based seq_file operation. [Dave Chinner]
 2.) Refactored workqueue support. [Dave Chinner]
 3.) Turn some Micro into be tunable        [Zhiyong, Liu Zheng]
       TIME_TO_KICK, and HEAT_UPDATE_DELAY
 4.) Cleanedup a lot of other issues [Dave Chinner]

v2:
 1.) Converted to Radix trees, not RB-tree [Zhiyong, Dave Chinner]
 2.) Added memory shrinker [Dave Chinner]
 3.) Converted to one workqueue to update map info periodically [Dave Chinner]
 4.) Cleanedup a lot of other issues [Dave Chinner]

v1:
 1.) Reduce new files and put all in fs/hot_tracking.[ch] [Dave Chinner]
 2.) The first three patches can probably just be flattened into one.
                                        [Marco Stornelli , Dave Chinner]

Dave Chinner (1):
  xfs: add hot tracking support

Zhi Yong Wu (14):
  vfs,hot_track: introduce private radix tree structures
  vfs,hot_track: initialize and free key data structures
  vfs,hot_track: add the function for collecting I/O frequency
  vfs,hot_track: add two map arrays
  vfs,hot_track: add hooks to enable hot data tracking
  vfs,hot_track: add the function for updating map arrays
  vfs,hot_track: add the aging function
  vfs,hot_track: add one work queue
  vfs,hot_track: register one memory shrinker
  vfs,hot_track: add one new ioctl interface
  vfs,hot_track: add debugfs support
  vfs,hot_track: turn some Micro into be tunable
  btrfs: add hot tracking support
  vfs,hot_track: add the documentation

 Documentation/filesystems/00-INDEX         |    2 +
 Documentation/filesystems/hot_tracking.txt |  164 ++++
 fs/Makefile                                |    2 +-
 fs/btrfs/ctree.h                           |    1 +
 fs/btrfs/super.c                           |   22 +-
 fs/compat_ioctl.c                          |    5 +
 fs/dcache.c                                |    2 +
 fs/debugfs/inode.c                         |   26 +
 fs/direct-io.c                             |    6 +
 fs/hot_tracking.c                          | 1308 ++++++++++++++++++++++++++++
 fs/hot_tracking.h                          |   91 ++
 fs/ioctl.c                                 |   76 ++
 fs/xfs/xfs_mount.h                         |    1 +
 fs/xfs/xfs_super.c                         |   16 +
 include/linux/debugfs.h                    |    9 +
 include/linux/fs.h                         |    4 +
 include/linux/hot_tracking.h               |  125 +++
 kernel/sysctl.c                            |   14 +
 mm/filemap.c                               |    6 +
 mm/page-writeback.c                        |   12 +
 mm/readahead.c                             |    6 +
 21 files changed, 1896 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/filesystems/hot_tracking.txt
 create mode 100644 fs/hot_tracking.c
 create mode 100644 fs/hot_tracking.h
 create mode 100644 include/linux/hot_tracking.h

-- 
1.7.6.5
