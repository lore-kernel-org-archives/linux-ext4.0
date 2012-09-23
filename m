From: zwu.kernel@gmail.com
Subject: [RFC v2 10/10] vfs: add documentation
Date: Sun, 23 Sep 2012 20:56:35 +0800
Message-ID: <1348404995-14372-11-git-send-email-zwu.kernel@gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, cmm@us.ibm.com, tytso@mit.edu,
	marco.stornelli@gmail.com, david@fromorbit.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 Documentation/filesystems/hot_tracking.txt |  106 ++++++++++++++++++++++++++++
 1 files changed, 106 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/hot_tracking.txt

diff --git a/Documentation/filesystems/hot_tracking.txt b/Documentation/filesystems/hot_tracking.txt
new file mode 100644
index 0000000..340df45
--- /dev/null
+++ b/Documentation/filesystems/hot_tracking.txt
@@ -0,0 +1,106 @@
+Hot Data Tracking
+
+Introduction
+-------------------------------------------------------------------------------
+
+  The feature adds experimental support for tracking data temperature
+information in VFS layer.  Essentially, this means maintaining some key
+stats(like number of reads/writes, last read/write time, frequency of
+reads/writes), then distilling those numbers down to a single
+"temperature" value that reflects what data is "hot," and using that
+temperature to move data to SSDs.
+
+  The long-term goal of the feature is to allow some FSs,
+e.g. Btrfs to intelligently utilize SSDs in a heterogenous volume.
+Incidentally, this project has been motivated by
+the Project Ideas page on the Btrfs wiki.
+
+  Of course, users are warned not to run this code outside of development
+environments. These patches are EXPERIMENTAL, and as such they might eat
+your data and/or memory. That said, the code should be relatively safe
+when the hottrack mount option are disabled.
+
+Motivation
+-------------------------------------------------------------------------------
+
+  The overall goal of enabling hot data relocation to SSD has been
+motivated by the Project Ideas page on the Btrfs wiki at
+<https://btrfs.wiki.kernel.org/index.php/Project_ideas>.
+It will divide into two steps. VFS provide hot data tracking function
+while specific FS will provide hot data relocation function.
+So as the first step of this goal, it is hoped that the patchset
+for hot data tracking will eventually mature into VFS.
+
+  This is essentially the traditional cache argument: SSD is fast and
+expensive; HDD is cheap but slow. ZFS, for example, can already take
+advantage of SSD caching. Btrfs should also be able to take advantage of
+hybrid storage without many broad, sweeping changes to existing code.
+
+Main Parts Description
+-------------------------------------------------------------------------------
+
+These include the following parts:
+    * Hooks in existing vfs functions to track data access frequency
+    * New rbtrees for tracking access frequency of inodes and sub-file
+ranges (hot_rb.c)
+    The relationship between super_block and rbtree is as below:
+super_block->s_hotinfo.hot_inode_tree
+    In include/linux/fs.h, one struct hot_info s_hotinfo is added to
+super_block struct. Each FS instance can find hot tracking info
+s_hotinfo via its super_block. In this hot_info, it store a lot of hot
+tracking info such as hot_inode_tree, inode and range hash list, etc.
+    * A hash list for indexing data by its temperature (hot_hash.c)
+    * A debugfs interface for dumping data from the rbtrees (hot_debugfs.c)
+    * A background kthread for updating inode heat info
+    * Mount options for enabling temperature tracking(-o hottrack,
+default mean disabled) (hot_track.c)
+    * An ioctl to retrieve the frequency information collected for a certain
+file
+    * Ioctls to enable/disable frequency tracking per inode.
+
+Git Development Tree
+-------------------------------------------------------------------------------
+
+  The feature is still on development and review, so if you're interested,
+you can pull from the git repository at the following location:
+  https://github.com/wuzhy/kernel.git hot_tracking
+  git://github.com/wuzhy/kernel.git hot_tracking
+
+Usage Example
+-------------------------------------------------------------------------------
+To use hot tracking, you should mount like this:
+
+$ mount -o hottrack /dev/sdb /mnt
+[ 1505.894078] device label test devid 1 transid 29 /dev/sdb
+[ 1505.952977] btrfs: disk space caching is enabled
+[ 1506.069678] vfs: turning on hot data tracking
+
+Mount debugfs at first:
+
+$ mount -t debugfs none /sys/kernel/debug
+$ ls -l /sys/kernel/debug/vfs_hotdata/
+total 0
+drwxr-xr-x 2 root root 0 Aug  8 04:40 sdb
+$ ls -l /sys/kernel/debug/vfs_hotdata/sdb
+total 0
+-rw-r--r-- 1 root root 0 Aug  8 04:40 inode_data
+-rw-r--r-- 1 root root 0 Aug  8 04:40 range_data
+
+View information about hot tracking from debugfs:
+
+$ echo "hot tracking test" > /mnt/file
+$ cat /sys/kernel/debug/hot_track/sdb/inode_data
+inode #279, reads 0, writes 1, avg read time 18446744073709551615,
+avg write time 5251566408153596, temp 109
+$ cat /sys/kernel/debug/hot_track/sdb/range_data
+inode #279, range start 0 (range len 1048576) reads 0, writes 1,
+avg read time 18446744073709551615, avg write time 1128690176623144209, temp 64
+
+$ echo "hot data tracking test" >> /mnt/file
+$ cat /sys/kernel/debug/hot_track/sdb/inode_data
+inode #279, reads 0, writes 2, avg read time 18446744073709551615,
+avg write time 4923343766042451, temp 109
+$ cat /sys/kernel/debug/hot_track/sdb/range_data
+inode #279, range start 0 (range len 1048576) reads 0, writes 2,
+avg read time 18446744073709551615, avg write time 1058147040842596150, temp 64
+
-- 
1.7.6.5
