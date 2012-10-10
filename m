From: zwu.kernel@gmail.com
Subject: [RFC v3 13/13] vfs: add documentation
Date: Wed, 10 Oct 2012 18:07:35 +0800
Message-ID: <1349863655-29320-14-git-send-email-zwu.kernel@gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 Documentation/filesystems/00-INDEX         |    2 +
 Documentation/filesystems/hot_tracking.txt |  165 ++++++++++++++++++++++++++++
 2 files changed, 167 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/hot_tracking.txt

diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 8c624a1..b68bdff 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -118,3 +118,5 @@ xfs.txt
 	- info and mount options for the XFS filesystem.
 xip.txt
 	- info on execute-in-place for file mappings.
+hot_tracking.txt
+	- info on hot data tracking in VFS layer
diff --git a/Documentation/filesystems/hot_tracking.txt b/Documentation/filesystems/hot_tracking.txt
new file mode 100644
index 0000000..34dc232
--- /dev/null
+++ b/Documentation/filesystems/hot_tracking.txt
@@ -0,0 +1,165 @@
+Hot Data Tracking
+
+September, 2012		Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+
+CONTENTS
+
+1. Introduction
+2. Motivation
+3. The Design
+4. Git Development Tree
+5. Usage Example
+
+
+1. Introduction
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
+2. Motivation
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
+
+3. The Design
+
+These include the following parts:
+
+    * Hooks in existing vfs functions to track data access frequency
+
+    * New rbtrees for tracking access frequency of inodes and sub-file
+ranges (hot_rb.c)
+    The relationship between super_block and rbtree is as below:
+super_block->s_hotinfo.hot_inode_tree
+    In include/linux/fs.h, one struct hot_info s_hotinfo is added to
+super_block struct. Each FS instance can find hot tracking info
+s_hotinfo via its super_block. In this hot_info, it store a lot of hot
+tracking info such as hot_inode_tree, inode and range hash list, etc.
+
+    * A hash list for indexing data by its temperature (hot_hash.c)
+
+    * A debugfs interface for dumping data from the rbtrees (hot_debugfs.c)
+
+    * A background kthread for updating inode heat info
+
+    * Mount options for enabling temperature tracking(-o hottrack,
+default mean disabled) (hot_track.c)
+    * An ioctl to retrieve the frequency information collected for a certain
+file
+    * Ioctls to enable/disable frequency tracking per inode.
+
+Let us see their relationship as below:
+
+    * hot_info.hot_inode_tree indexes hot_inode_items, one per inode
+
+    * hot_inode_item contains access frequency data for that inode
+
+    * hot_inode_item holds a heat hash node to index the access
+frequency data for that inode
+
+    * hot_inode_item.hot_range_tree indexes hot_range_items for that inode
+
+    * hot_range_item contains access frequency data for that range
+
+    * hot_range_item holds a heat hash node to index the access
+frequency data for that range
+
+    * hot_info.heat_inode_map indexes per-inode heat hash nodes
+
+    * hot_info.heat_range_map indexes per-range heat hash nodes
+
+  How about some ascii art? :) Just looking at the hot inode item case
+(the range item case is the same pattern, though), we have:
+
+heat_inode_map           hot_inode_tree
+    |                         |
+    |                         V
+    |           +-------hot_comm_item--------+
+    |           |       frequency data       |
++---+           |        list_head           |
+|               V            ^ |             V
+| ...<--hot_comm_item-->...  | |  ...<--hot_comm_item-->...
+|       frequency data       | |        frequency data
++-------->list_head----------+ +--------->list_head--->.....
+       hot_range_tree                  hot_range_tree
+                                             |
+             heat_range_map                  V
+                   |           +-------hot_comm_item--------+
+                   |           |       frequency data       |
+               +---+           |        list_head           |
+               |               V            ^ |             V
+               | ...<--hot_comm_item-->...  | |  ...<--hot_comm_item-->...
+               |       frequency data       | |        frequency data
+               +-------->list_head----------+ +--------->list_head--->.....
+
+4. Git Development Tree
+
+  The feature is still on development and review, so if you're interested,
+you can pull from the git repository at the following location:
+  https://github.com/wuzhy/kernel.git hot_tracking
+  git://github.com/wuzhy/kernel.git hot_tracking
+
+
+5. Usage Example
+
+To use hot tracking, you should mount like this:
+
+$ mount -o hot_track /dev/sdb /mnt
+[ 1505.894078] device label test devid 1 transid 29 /dev/sdb
+[ 1505.952977] btrfs: disk space caching is enabled
+[ 1506.069678] vfs: turning on hot data tracking
+
+Mount debugfs at first:
+
+$ mount -t debugfs none /sys/kernel/debug
+$ ls -l /sys/kernel/debug/hot_track/
+total 0
+drwxr-xr-x 2 root root 0 Aug  8 04:40 sdb
+$ ls -l /sys/kernel/debug/hot_track/sdb
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

