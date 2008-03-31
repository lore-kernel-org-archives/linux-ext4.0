From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] Split the m_lazy test case into two cases: m_lazy and m_lazy_resize
Date: Mon, 31 Mar 2008 19:36:29 -0400
Message-ID: <1207006592-13980-8-git-send-email-tytso@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int>
 <1207006592-13980-1-git-send-email-tytso@mit.edu>
 <1207006592-13980-2-git-send-email-tytso@mit.edu>
 <1207006592-13980-3-git-send-email-tytso@mit.edu>
 <1207006592-13980-4-git-send-email-tytso@mit.edu>
 <1207006592-13980-5-git-send-email-tytso@mit.edu>
 <1207006592-13980-6-git-send-email-tytso@mit.edu>
 <1207006592-13980-7-git-send-email-tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61435 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbYCaXjL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:39:11 -0400
In-Reply-To: <1207006592-13980-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Dilger <adilger@dilger.ca>

Split the m_lazy testcase into two tests - one that has resize enabled,
and one that does not.  There were previously problems with lazy+resize
because the resize feature consumed blocks in some of the groups.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/m_lazy/expect.1        |   74 ++++++++----------
 tests/m_lazy/script          |    2 +-
 tests/m_lazy_resize/expect.1 |  166 ++++++++++++++++++++++++++++++++++++++++++
 tests/m_lazy_resize/script   |    4 +
 4 files changed, 204 insertions(+), 42 deletions(-)
 create mode 100644 tests/m_lazy_resize/expect.1
 create mode 100644 tests/m_lazy_resize/script

diff --git a/tests/m_lazy/expect.1 b/tests/m_lazy/expect.1
index e0e459c..901133b 100644
--- a/tests/m_lazy/expect.1
+++ b/tests/m_lazy/expect.1
@@ -5,7 +5,6 @@ Fragment size=1024 (log=0)
 32768 inodes, 131072 blocks
 6553 blocks (5.00%) reserved for the super user
 First data block=1
-Maximum filesystem blocks=67371008
 16 block groups
 8192 blocks per group, 8192 fragments per group
 2048 inodes per group
@@ -15,21 +14,21 @@ Superblock backups stored on blocks:
 Writing inode tables: done                            
 Writing superblocks and filesystem accounting information: done
 
-Filesystem features: ext_attr resize_inode dir_index lazy_bg filetype sparse_super
+Filesystem features: ext_attr dir_index lazy_bg filetype sparse_super
  
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 28683/32768 files (0.0% non-contiguous), 77097/131072 blocks
+test_filesys: 28683/32768 files (0.0% non-contiguous), 115220/131072 blocks
 Exit status is 0
 
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
 Filesystem revision #:    1 (dynamic)
-Filesystem features:      ext_attr resize_inode dir_index lazy_bg filetype sparse_super
+Filesystem features:      ext_attr dir_index lazy_bg filetype sparse_super
 Default mount options:    (none)
 Filesystem state:         clean
 Errors behavior:          Continue
@@ -37,12 +36,11 @@ Filesystem OS type:       Linux
 Inode count:              32768
 Block count:              131072
 Reserved block count:     6553
-Free blocks:              53975
+Free blocks:              15852
 Free inodes:              4085
 First block:              1
 Block size:               1024
 Fragment size:            1024
-Reserved GDT blocks:      256
 Blocks per group:         8192
 Fragments per group:      8192
 Inodes per group:         2048
@@ -58,19 +56,17 @@ Default directory hash:   tea
 
 Group 0: (Blocks 1-8192)
   Primary superblock at 1, Group descriptors at 2-2
-  Reserved GDT blocks at 3-258
-  Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
-  Inode table at 261-516 (+260)
-  7662 free blocks, 2037 free inodes, 2 directories
-  Free blocks: 531-8192
+  Block bitmap at 3 (+2), Inode bitmap at 4 (+3)
+  Inode table at 5-260 (+4)
+  7919 free blocks, 2037 free inodes, 2 directories
+  Free blocks: 274-8192
   Free inodes: 12-2048
-Group 1: (Blocks 8193-16384) [Inode not init]
+Group 1: (Blocks 8193-16384) [Inode not init, Block not init]
   Backup superblock at 8193, Group descriptors at 8194-8194
-  Reserved GDT blocks at 8195-8450
-  Block bitmap at 8451 (+258), Inode bitmap at 8452 (+259)
-  Inode table at 8453-8708 (+260)
-  7676 free blocks, 0 free inodes, 0 directories
-  Free blocks: 8709-16384
+  Block bitmap at 8195 (+2), Inode bitmap at 8196 (+3)
+  Inode table at 8197-8452 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
   Free inodes: 
 Group 2: (Blocks 16385-24576) [Inode not init, Block not init]
   Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
@@ -78,13 +74,12 @@ Group 2: (Blocks 16385-24576) [Inode not init, Block not init]
   0 free blocks, 0 free inodes, 0 directories
   Free blocks: 
   Free inodes: 
-Group 3: (Blocks 24577-32768) [Inode not init]
+Group 3: (Blocks 24577-32768) [Inode not init, Block not init]
   Backup superblock at 24577, Group descriptors at 24578-24578
-  Reserved GDT blocks at 24579-24834
-  Block bitmap at 24835 (+258), Inode bitmap at 24836 (+259)
-  Inode table at 24837-25092 (+260)
-  7676 free blocks, 0 free inodes, 0 directories
-  Free blocks: 25093-32768
+  Block bitmap at 24579 (+2), Inode bitmap at 24580 (+3)
+  Inode table at 24581-24836 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
   Free inodes: 
 Group 4: (Blocks 32769-40960) [Inode not init, Block not init]
   Block bitmap at 32769 (+0), Inode bitmap at 32770 (+1)
@@ -92,13 +87,12 @@ Group 4: (Blocks 32769-40960) [Inode not init, Block not init]
   0 free blocks, 0 free inodes, 0 directories
   Free blocks: 
   Free inodes: 
-Group 5: (Blocks 40961-49152) [Inode not init]
+Group 5: (Blocks 40961-49152) [Inode not init, Block not init]
   Backup superblock at 40961, Group descriptors at 40962-40962
-  Reserved GDT blocks at 40963-41218
-  Block bitmap at 41219 (+258), Inode bitmap at 41220 (+259)
-  Inode table at 41221-41476 (+260)
-  7676 free blocks, 0 free inodes, 0 directories
-  Free blocks: 41477-49152
+  Block bitmap at 40963 (+2), Inode bitmap at 40964 (+3)
+  Inode table at 40965-41220 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
   Free inodes: 
 Group 6: (Blocks 49153-57344) [Inode not init, Block not init]
   Block bitmap at 49153 (+0), Inode bitmap at 49154 (+1)
@@ -106,13 +100,12 @@ Group 6: (Blocks 49153-57344) [Inode not init, Block not init]
   0 free blocks, 0 free inodes, 0 directories
   Free blocks: 
   Free inodes: 
-Group 7: (Blocks 57345-65536) [Inode not init]
+Group 7: (Blocks 57345-65536) [Inode not init, Block not init]
   Backup superblock at 57345, Group descriptors at 57346-57346
-  Reserved GDT blocks at 57347-57602
-  Block bitmap at 57603 (+258), Inode bitmap at 57604 (+259)
-  Inode table at 57605-57860 (+260)
-  7676 free blocks, 0 free inodes, 0 directories
-  Free blocks: 57861-65536
+  Block bitmap at 57347 (+2), Inode bitmap at 57348 (+3)
+  Inode table at 57349-57604 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
   Free inodes: 
 Group 8: (Blocks 65537-73728) [Inode not init, Block not init]
   Block bitmap at 65537 (+0), Inode bitmap at 65538 (+1)
@@ -120,13 +113,12 @@ Group 8: (Blocks 65537-73728) [Inode not init, Block not init]
   0 free blocks, 0 free inodes, 0 directories
   Free blocks: 
   Free inodes: 
-Group 9: (Blocks 73729-81920) [Inode not init]
+Group 9: (Blocks 73729-81920) [Inode not init, Block not init]
   Backup superblock at 73729, Group descriptors at 73730-73730
-  Reserved GDT blocks at 73731-73986
-  Block bitmap at 73987 (+258), Inode bitmap at 73988 (+259)
-  Inode table at 73989-74244 (+260)
-  7676 free blocks, 0 free inodes, 0 directories
-  Free blocks: 74245-81920
+  Block bitmap at 73731 (+2), Inode bitmap at 73732 (+3)
+  Inode table at 73733-73988 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
   Free inodes: 
 Group 10: (Blocks 81921-90112) [Inode not init, Block not init]
   Block bitmap at 81921 (+0), Inode bitmap at 81922 (+1)
diff --git a/tests/m_lazy/script b/tests/m_lazy/script
index 35be0c8..aaac8f0 100644
--- a/tests/m_lazy/script
+++ b/tests/m_lazy/script
@@ -1,4 +1,4 @@
 DESCRIPTION="lazy group feature"
 FS_SIZE=131072
-MKE2FS_OPTS="-O lazy_bg"
+MKE2FS_OPTS="-O ^resize_inode,lazy_bg"
 . $cmd_dir/run_mke2fs
diff --git a/tests/m_lazy_resize/expect.1 b/tests/m_lazy_resize/expect.1
new file mode 100644
index 0000000..e0e459c
--- /dev/null
+++ b/tests/m_lazy_resize/expect.1
@@ -0,0 +1,166 @@
+Filesystem label=
+OS type: Linux
+Block size=1024 (log=0)
+Fragment size=1024 (log=0)
+32768 inodes, 131072 blocks
+6553 blocks (5.00%) reserved for the super user
+First data block=1
+Maximum filesystem blocks=67371008
+16 block groups
+8192 blocks per group, 8192 fragments per group
+2048 inodes per group
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729
+
+Writing inode tables: done                            
+Writing superblocks and filesystem accounting information: done
+
+Filesystem features: ext_attr resize_inode dir_index lazy_bg filetype sparse_super
+ 
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 28683/32768 files (0.0% non-contiguous), 77097/131072 blocks
+Exit status is 0
+
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr resize_inode dir_index lazy_bg filetype sparse_super
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              32768
+Block count:              131072
+Reserved block count:     6553
+Free blocks:              53975
+Free inodes:              4085
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Reserved GDT blocks:      256
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         2048
+Inode blocks per group:   256
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:		  128
+Default directory hash:   tea
+
+
+Group 0: (Blocks 1-8192)
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-258
+  Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
+  Inode table at 261-516 (+260)
+  7662 free blocks, 2037 free inodes, 2 directories
+  Free blocks: 531-8192
+  Free inodes: 12-2048
+Group 1: (Blocks 8193-16384) [Inode not init]
+  Backup superblock at 8193, Group descriptors at 8194-8194
+  Reserved GDT blocks at 8195-8450
+  Block bitmap at 8451 (+258), Inode bitmap at 8452 (+259)
+  Inode table at 8453-8708 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 8709-16384
+  Free inodes: 
+Group 2: (Blocks 16385-24576) [Inode not init, Block not init]
+  Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
+  Inode table at 16387-16642 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 3: (Blocks 24577-32768) [Inode not init]
+  Backup superblock at 24577, Group descriptors at 24578-24578
+  Reserved GDT blocks at 24579-24834
+  Block bitmap at 24835 (+258), Inode bitmap at 24836 (+259)
+  Inode table at 24837-25092 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 25093-32768
+  Free inodes: 
+Group 4: (Blocks 32769-40960) [Inode not init, Block not init]
+  Block bitmap at 32769 (+0), Inode bitmap at 32770 (+1)
+  Inode table at 32771-33026 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 5: (Blocks 40961-49152) [Inode not init]
+  Backup superblock at 40961, Group descriptors at 40962-40962
+  Reserved GDT blocks at 40963-41218
+  Block bitmap at 41219 (+258), Inode bitmap at 41220 (+259)
+  Inode table at 41221-41476 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 41477-49152
+  Free inodes: 
+Group 6: (Blocks 49153-57344) [Inode not init, Block not init]
+  Block bitmap at 49153 (+0), Inode bitmap at 49154 (+1)
+  Inode table at 49155-49410 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 7: (Blocks 57345-65536) [Inode not init]
+  Backup superblock at 57345, Group descriptors at 57346-57346
+  Reserved GDT blocks at 57347-57602
+  Block bitmap at 57603 (+258), Inode bitmap at 57604 (+259)
+  Inode table at 57605-57860 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 57861-65536
+  Free inodes: 
+Group 8: (Blocks 65537-73728) [Inode not init, Block not init]
+  Block bitmap at 65537 (+0), Inode bitmap at 65538 (+1)
+  Inode table at 65539-65794 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 9: (Blocks 73729-81920) [Inode not init]
+  Backup superblock at 73729, Group descriptors at 73730-73730
+  Reserved GDT blocks at 73731-73986
+  Block bitmap at 73987 (+258), Inode bitmap at 73988 (+259)
+  Inode table at 73989-74244 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 74245-81920
+  Free inodes: 
+Group 10: (Blocks 81921-90112) [Inode not init, Block not init]
+  Block bitmap at 81921 (+0), Inode bitmap at 81922 (+1)
+  Inode table at 81923-82178 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 11: (Blocks 90113-98304) [Inode not init, Block not init]
+  Block bitmap at 90113 (+0), Inode bitmap at 90114 (+1)
+  Inode table at 90115-90370 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 12: (Blocks 98305-106496) [Inode not init, Block not init]
+  Block bitmap at 98305 (+0), Inode bitmap at 98306 (+1)
+  Inode table at 98307-98562 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 13: (Blocks 106497-114688) [Inode not init, Block not init]
+  Block bitmap at 106497 (+0), Inode bitmap at 106498 (+1)
+  Inode table at 106499-106754 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 14: (Blocks 114689-122880) [Inode not init, Block not init]
+  Block bitmap at 114689 (+0), Inode bitmap at 114690 (+1)
+  Inode table at 114691-114946 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 15: (Blocks 122881-131071)
+  Block bitmap at 122881 (+0), Inode bitmap at 122882 (+1)
+  Inode table at 122883-123138 (+2)
+  7933 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 123139-131071
+  Free inodes: 30721-32768
diff --git a/tests/m_lazy_resize/script b/tests/m_lazy_resize/script
new file mode 100644
index 0000000..2ba081f
--- /dev/null
+++ b/tests/m_lazy_resize/script
@@ -0,0 +1,4 @@
+DESCRIPTION="lazy group feature with resize_inode"
+FS_SIZE=131072
+MKE2FS_OPTS="-O resize_inode,lazy_bg"
+. $cmd_dir/run_mke2fs
-- 
1.5.4.1.144.gdfee-dirty

