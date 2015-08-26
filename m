From: Jan Kara <jack@suse.com>
Subject: [PATCH 12/21] libext2fs: Bump default number of reserved inodes to 64
Date: Wed, 26 Aug 2015 18:22:27 +0200
Message-ID: <1440606156-5754-13-git-send-email-jack@suse.com>
References: <1440606156-5754-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951AbbHZQW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:22:57 -0400
In-Reply-To: <1440606156-5754-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

We ran out of reserved inodes so bump the default number of reserved
inodes to 64 to get some breathing space. Otherwise we have to do a full
fs scan when increasing number of reserved inodes when some feature
needing another reserved inode is enabled. This consumes 13.5 KB on a
filesystem which is negligible these days.

Also update expected output for e2fsprogs tests since the number of used
inodes changes (yes, I went through all changed outputs and verified
that the changes are there only because of changed number of reserved
inodes).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/ext2fs/initialize.c                            |  8 ++++-
 misc/mke2fs.8.in                                   |  8 ++---
 tests/d_dumpe2fs_group_only/expect                 |  2 +-
 tests/d_loaddump/expect                            |  4 +--
 tests/d_xattr_edits/expect                         |  2 +-
 tests/f_create_symlinks/expect                     | 12 +++----
 tests/f_dup_resize/expect.1                        |  6 ++--
 tests/f_dup_resize/expect.2                        |  2 +-
 tests/f_extent_oobounds/expect.1                   | 12 +++----
 tests/f_extent_oobounds/expect.2                   |  2 +-
 tests/f_mmp_garbage/expect.1                       |  2 +-
 tests/f_mmp_garbage/expect.2                       |  2 +-
 tests/f_opt_extent/expect                          |  8 ++---
 tests/f_resize_inode/expect                        | 20 +++++------
 tests/j_ext_long_revoke_trans/expect               |  4 +--
 tests/j_ext_long_trans/expect                      | 10 +++---
 tests/j_long_revoke_trans/expect                   |  4 +--
 tests/j_long_revoke_trans_mcsum_32bit/expect       |  4 +--
 tests/j_long_revoke_trans_mcsum_64bit/expect       |  4 +--
 tests/j_long_trans/expect                          | 10 +++---
 tests/j_long_trans_mcsum_32bit/expect              | 10 +++---
 tests/j_long_trans_mcsum_64bit/expect              | 10 +++---
 tests/j_short_revoke_trans/expect                  |  4 +--
 tests/j_short_revoke_trans_mcsum_64bit/expect      |  4 +--
 tests/j_short_trans/expect                         |  6 ++--
 tests/j_short_trans_64bit/expect                   |  6 ++--
 tests/j_short_trans_mcsum_64bit/expect             |  6 ++--
 tests/j_short_trans_old_csum/expect                |  6 ++--
 tests/j_short_trans_open_recover/expect            |  6 ++--
 tests/j_short_trans_recover/expect                 |  6 ++--
 tests/j_short_trans_recover_mcsum_64bit/expect     |  6 ++--
 tests/j_short_uncommitted_trans/expect             |  4 +--
 tests/j_short_uncommitted_trans_mcsum_64bit/expect |  4 +--
 tests/m_64bit_flexbg/expect.1                      | 10 +++---
 tests/m_dasd_bs/expect.1                           | 10 +++---
 tests/m_desc_size_128/expect.1                     | 10 +++---
 tests/m_extent_journal/expect.1                    | 10 +++---
 tests/m_large_file/expect.1                        | 24 ++++++-------
 tests/m_meta_bg/expect.1                           | 10 +++---
 tests/m_minrootdir/expect                          | 42 +++++++++++-----------
 tests/m_mmp/expect.1                               | 10 +++---
 tests/m_no_opt/expect.1                            | 10 +++---
 tests/m_raid_opt/expect.1                          | 10 +++---
 tests/m_root_owner/expect.1                        | 10 +++---
 tests/m_rootdir/expect                             | 10 +++---
 tests/m_std/expect.1                               | 10 +++---
 tests/m_uninit/expect.1                            | 10 +++---
 tests/r_fixup_lastbg/expect                        |  2 +-
 tests/r_fixup_lastbg_big/expect                    |  2 +-
 tests/r_resize_inode/expect                        | 30 ++++++++--------
 tests/t_32to64bit_meta/expect                      |  2 +-
 tests/t_32to64bit_move_itable/expect               |  2 +-
 tests/t_64to32bit/expect                           |  2 +-
 tests/t_64to32bit_meta/expect                      |  2 +-
 tests/t_disable_mcsum_noinitbg/expect              |  6 ++--
 tests/t_enable_mcsum/expect                        |  8 ++---
 tests/t_enable_mcsum_ext3/expect                   |  4 +--
 tests/t_enable_mcsum_initbg/expect                 |  8 ++---
 tests/t_uninit_bg_rm/expect                        |  4 +--
 59 files changed, 234 insertions(+), 228 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 75fbf8ee0061..23432571dac6 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -81,6 +81,12 @@ static unsigned int calc_reserved_gdt_blocks(ext2_filsys fs)
 	return rsv_gdb;
 }
 
+/*
+ * Default for the first inode available for allocation (the previous ones are
+ * reserved for system files).
+ */
+#define EXT2_DEF_FIRST_INO 64
+
 errcode_t ext2fs_initialize(const char *name, int flags,
 			    struct ext2_super_block *param,
 			    io_manager manager, ext2_filsys *ret_fs)
@@ -186,7 +192,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 
 	set_field(s_rev_level, EXT2_GOOD_OLD_REV);
 	if (super->s_rev_level >= EXT2_DYNAMIC_REV) {
-		set_field(s_first_ino, EXT2_GOOD_OLD_FIRST_INO);
+		set_field(s_first_ino, EXT2_DEF_FIRST_INO);
 		set_field(s_inode_size, EXT2_GOOD_OLD_INODE_SIZE);
 		if (super->s_inode_size >= sizeof(struct ext2_inode_large)) {
 			int extra_isize = sizeof(struct ext2_inode_large) -
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 4165c0a9d051..1a13e1a5b835 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -386,10 +386,10 @@ Do not attempt to discard blocks at mkfs time.
 @QUOTA_MAN_COMMENT@behavior is to initialize both user and group quotas.
 .TP
 .BI reserved_inodes= number
-Specify the number of inodes reserved for system files. This number must be
-at least 10. Currently 10 is enough but future features may require additional
-reserved inodes. Reserving more inodes after the file system is created
-requires full file system scan which can take a long time.
+Specify the number of inodes reserved for system files. This number must be at
+least 10, default is 64. Currently 10 is enough but future features may require
+additional reserved inodes. Reserving more inodes after the file system is
+created requires full file system scan which can take a long time.
 .RE
 .TP
 .BI \-f " fragment-size"
diff --git a/tests/d_dumpe2fs_group_only/expect b/tests/d_dumpe2fs_group_only/expect
index 78f97a2bafcc..ea8b8310719b 100644
--- a/tests/d_dumpe2fs_group_only/expect
+++ b/tests/d_dumpe2fs_group_only/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/262144 files (0.0% non-contiguous), 51278/1048576 blocks
+test_filesys: 64/262144 files (0.0% non-contiguous), 51278/1048576 blocks
 Exit status is 0
 dumpe2fs output
 
diff --git a/tests/d_loaddump/expect b/tests/d_loaddump/expect
index f70df88d2263..6d39cbe0408a 100644
--- a/tests/d_loaddump/expect
+++ b/tests/d_loaddump/expect
@@ -2,7 +2,7 @@ debugfs load/dump test
 mke2fs -Fq -b 1024 test.img 512
 Exit status is 0
 debugfs -R ''write d_loaddump.tmp test_data'' -w test.img
-Allocated inode: 12
+Allocated inode: 65
 Exit status is 0
 e2fsck -yf -N test_filesys
 Pass 1: Checking inodes, blocks, and sizes
@@ -10,7 +10,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 12/64 files (0.0% non-contiguous), 158/512 blocks
+test_filesys: 65/72 files (0.0% non-contiguous), 159/512 blocks
 Exit status is 0
 debugfs -R ''dump test_data d_loaddump.ver.tmp'' test.img
 Exit status is 0
diff --git a/tests/d_xattr_edits/expect b/tests/d_xattr_edits/expect
index 4db54142b5fc..d729e264b736 100644
--- a/tests/d_xattr_edits/expect
+++ b/tests/d_xattr_edits/expect
@@ -46,5 +46,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/64 files (0.0% non-contiguous), 29/512 blocks
+test_filesys: 64/72 files (0.0% non-contiguous), 30/512 blocks
 Exit status is 0
diff --git a/tests/f_create_symlinks/expect b/tests/f_create_symlinks/expect
index 47fa46827f6e..aab2f8615ff6 100644
--- a/tests/f_create_symlinks/expect
+++ b/tests/f_create_symlinks/expect
@@ -4,7 +4,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/128 files (0.0% non-contiguous), 441/1024 blocks
+test_filesys: 64/128 files (0.0% non-contiguous), 441/1024 blocks
 Exit status is 0
 debugfs -R "symlink /l_30 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
 debugfs -R "symlink /l_70 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
@@ -17,7 +17,7 @@ debugfs -R "symlink /l_1500 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 ext2fs_symlink: Invalid argument passed to ext2 library while creating symlink "l_1500"
 symlink: Invalid argument passed to ext2 library 
 debugfs -R "stat /l_30" test.img
-Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0
+Inode: 65   Type: symlink    Mode:  0777   Flags: 0x0
 Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Size: 31
 File ACL: 0    Directory ACL: 0
@@ -26,7 +26,7 @@ Fragment:  Address: 0    Number: 0    Size: 0
 Size of extra inode fields: 28
 Fast link dest: "/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
 debugfs -R "stat /l_70" test.img
-Inode: 13   Type: symlink    Mode:  0777   Flags: 0x10000000
+Inode: 66   Type: symlink    Mode:  0777   Flags: 0x10000000
 Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Size: 71
 File ACL: 0    Directory ACL: 0
@@ -37,7 +37,7 @@ Extended attributes:
   system.data (11)
 Fast link dest: "/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
 debugfs -R "stat /l_500" test.img
-Inode: 14   Type: symlink    Mode:  0777   Flags: 0x80000
+Inode: 67   Type: symlink    Mode:  0777   Flags: 0x80000
 Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Size: 501
 File ACL: 0    Directory ACL: 0
@@ -47,7 +47,7 @@ Size of extra inode fields: 28
 EXTENTS:
 (0):153
 debugfs -R "stat /l_1023" test.img
-Inode: 15   Type: symlink    Mode:  0777   Flags: 0x80000
+Inode: 68   Type: symlink    Mode:  0777   Flags: 0x80000
 Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Size: 1024
 File ACL: 0    Directory ACL: 0
@@ -65,5 +65,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 15/128 files (0.0% non-contiguous), 443/1024 blocks
+test_filesys: 68/128 files (0.0% non-contiguous), 443/1024 blocks
 Exit status is 0
diff --git a/tests/f_dup_resize/expect.1 b/tests/f_dup_resize/expect.1
index aaf7769cbcd7..f7e46cf54824 100644
--- a/tests/f_dup_resize/expect.1
+++ b/tests/f_dup_resize/expect.1
@@ -5,12 +5,12 @@ Pass 1: Checking inodes, blocks, and sizes
 Running additional passes to resolve blocks claimed by more than one inode...
 Pass 1B: Rescanning for multiply-claimed blocks
 Multiply-claimed block(s) in inode 7: 4--7
-Multiply-claimed block(s) in inode 12: 4--7
+Multiply-claimed block(s) in inode 65: 4--7
 Pass 1C: Scanning directories for inodes with multiply-claimed blocks
 Pass 1D: Reconciling multiply-claimed blocks
 (There are 1 inodes containing multiply-claimed blocks.)
 
-File /debugfs (inode #12, mod time Mon Apr 11 00:00:00 2005) 
+File /debugfs (inode #65, mod time Mon Apr 11 00:00:00 2005) 
   has 4 multiply-claimed block(s), shared with 1 file(s):
 	<The group descriptor inode> (inode #7, mod time Mon Apr 11 06:13:20 2005)
 Clone multiply-claimed blocks? yes
@@ -30,5 +30,5 @@ Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 12/2560 files (8.3% non-contiguous), 485/10240 blocks
+test_filesys: 65/2560 files (1.5% non-contiguous), 485/10240 blocks
 Exit status is 1
diff --git a/tests/f_dup_resize/expect.2 b/tests/f_dup_resize/expect.2
index 198acb958f5c..a3c97a77108c 100644
--- a/tests/f_dup_resize/expect.2
+++ b/tests/f_dup_resize/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 12/2560 files (8.3% non-contiguous), 485/10240 blocks
+test_filesys: 65/2560 files (1.5% non-contiguous), 485/10240 blocks
 Exit status is 0
diff --git a/tests/f_extent_oobounds/expect.1 b/tests/f_extent_oobounds/expect.1
index 59e1952cc695..fb4789026acc 100644
--- a/tests/f_extent_oobounds/expect.1
+++ b/tests/f_extent_oobounds/expect.1
@@ -1,11 +1,11 @@
 Pass 1: Checking inodes, blocks, and sizes
-Inode 12, end of extent exceeds allowed value
+Inode 65, end of extent exceeds allowed value
 	(logical block 15, physical block 200, len 30)
 Clear? yes
 
-Inode 12 extent tree (at (level 1) could be narrower.  Fix? yes
+Inode 65 extent tree (at (level 1) could be narrower.  Fix? yes
 
-Inode 12, i_blocks is 154, should be 94.  Fix? yes
+Inode 65, i_blocks is 154, should be 94.  Fix? yes
 
 Pass 1E: Optimizing extent trees
 Pass 2: Checking directory structure
@@ -15,13 +15,13 @@ Pass 5: Checking group summary information
 Block bitmap differences:  -(200--229)
 Fix? yes
 
-Free blocks count wrong for group #0 (158, counted=188).
+Free blocks count wrong for group #0 (158, counted=183).
 Fix? yes
 
-Free blocks count wrong (158, counted=188).
+Free blocks count wrong (158, counted=183).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 12/32 files (8.3% non-contiguous), 68/256 blocks
+test_filesys: 65/72 files (1.5% non-contiguous), 73/256 blocks
 Exit status is 1
diff --git a/tests/f_extent_oobounds/expect.2 b/tests/f_extent_oobounds/expect.2
index 072928316833..8a48f36bfa8c 100644
--- a/tests/f_extent_oobounds/expect.2
+++ b/tests/f_extent_oobounds/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 12/32 files (8.3% non-contiguous), 68/256 blocks
+test_filesys: 65/72 files (1.5% non-contiguous), 73/256 blocks
 Exit status is 0
diff --git a/tests/f_mmp_garbage/expect.1 b/tests/f_mmp_garbage/expect.1
index a8add10175d0..b0904fa61dfc 100644
--- a/tests/f_mmp_garbage/expect.1
+++ b/tests/f_mmp_garbage/expect.1
@@ -5,5 +5,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/64 files (0.0% non-contiguous), 13/100 blocks
+test_filesys: 64/96 files (0.0% non-contiguous), 14/100 blocks
 Exit status is 0
diff --git a/tests/f_mmp_garbage/expect.2 b/tests/f_mmp_garbage/expect.2
index 66300025e546..e6df796c08b3 100644
--- a/tests/f_mmp_garbage/expect.2
+++ b/tests/f_mmp_garbage/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/64 files (0.0% non-contiguous), 13/100 blocks
+test_filesys: 64/96 files (0.0% non-contiguous), 14/100 blocks
 Exit status is 0
diff --git a/tests/f_opt_extent/expect b/tests/f_opt_extent/expect
index 6d4863b51b2b..e9413b1c441d 100644
--- a/tests/f_opt_extent/expect
+++ b/tests/f_opt_extent/expect
@@ -32,18 +32,18 @@ Change in FS metadata:
  Reserved block count:     26214
 -Free blocks:              570
 +Free blocks:              567
- Free inodes:              65047
+ Free inodes:              64994
  First block:              1
  Block size:               1024
 @@ -47,8 +47,8 @@
    Block bitmap at 262 (+261)
    Inode bitmap at 278 (+277)
    Inode table at 294-549 (+293)
--  21 free blocks, 535 free inodes, 3 directories, 535 unused inodes
+-  21 free blocks, 482 free inodes, 3 directories, 482 unused inodes
 -  Free blocks: 4414-4434
-+  18 free blocks, 535 free inodes, 3 directories, 535 unused inodes
++  18 free blocks, 482 free inodes, 3 directories, 482 unused inodes
 +  Free blocks: 4417-4434
-   Free inodes: 490-1024
+   Free inodes: 543-1024
  Group 1: (Blocks 8193-16384) [INODE_UNINIT]
    Backup superblock at 8193, Group descriptors at 8194-8197
 Pass 1: Checking inodes, blocks, and sizes
diff --git a/tests/f_resize_inode/expect b/tests/f_resize_inode/expect
index db57ed651ab0..d3c6ae27d767 100644
--- a/tests/f_resize_inode/expect
+++ b/tests/f_resize_inode/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 64/4096 files (0.0% non-contiguous), 2107/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -33,14 +33,14 @@ Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 64/4096 files (0.0% non-contiguous), 2107/16384 blocks
 Exit status is 1
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 64/4096 files (0.0% non-contiguous), 2107/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -61,14 +61,14 @@ Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 64/4096 files (0.0% non-contiguous), 2107/16384 blocks
 Exit status is 1
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 64/4096 files (0.0% non-contiguous), 2107/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -89,14 +89,14 @@ Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 64/4096 files (0.0% non-contiguous), 2107/16384 blocks
 Exit status is 1
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 64/4096 files (0.0% non-contiguous), 2107/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -111,7 +111,7 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 64/4096 files (0.0% non-contiguous), 2107/16384 blocks
 Exit status is 1
 -----------------------------------------------
  
@@ -148,12 +148,12 @@ Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 763/16384 blocks
+test_filesys: 64/4096 files (0.0% non-contiguous), 763/16384 blocks
 Exit status is 1
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 763/16384 blocks
+test_filesys: 64/4096 files (0.0% non-contiguous), 763/16384 blocks
 Exit status is 0
diff --git a/tests/j_ext_long_revoke_trans/expect b/tests/j_ext_long_revoke_trans/expect
index ed198725ff05..80c703c3a05e 100644
--- a/tests/j_ext_long_revoke_trans/expect
+++ b/tests/j_ext_long_revoke_trans/expect
@@ -20,7 +20,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 6239/262144 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 6239/262144 blocks
 Exit status is 0
 debugfs write journal
 debugfs: logdump -c
@@ -87,5 +87,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 6239/262144 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 6239/262144 blocks
 Exit status is 0
diff --git a/tests/j_ext_long_trans/expect b/tests/j_ext_long_trans/expect
index d379610e7c2a..8aac7a6ec6b7 100644
--- a/tests/j_ext_long_trans/expect
+++ b/tests/j_ext_long_trans/expect
@@ -20,7 +20,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 6239/262144 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 6239/262144 blocks
 Exit status is 0
 debugfs write journal
 debugfs: logdump -c
@@ -86,19 +86,19 @@ Fix? yes
 Free blocks count wrong (255903, counted=255916).
 Fix? yes
 
-Inode bitmap differences:  +1 +(3--10)
+Inode bitmap differences:  +1 +(3--63)
 Fix? yes
 
-Free inodes count wrong for group #0 (500, counted=501).
+Free inodes count wrong for group #0 (447, counted=448).
 Fix? yes
 
 Directories count wrong for group #0 (3, counted=2).
 Fix? yes
 
-Free inodes count wrong (16372, counted=16373).
+Free inodes count wrong (16319, counted=16320).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/16384 files (0.0% non-contiguous), 6228/262144 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 6228/262144 blocks
 Exit status is 1
diff --git a/tests/j_long_revoke_trans/expect b/tests/j_long_revoke_trans/expect
index c0730e609383..c499f724ae9d 100644
--- a/tests/j_long_revoke_trans/expect
+++ b/tests/j_long_revoke_trans/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 14431/262144 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 14431/262144 blocks
 Exit status is 0
 debugfs write journal
 debugfs: logdump -c
@@ -77,5 +77,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 14431/262144 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 14431/262144 blocks
 Exit status is 0
diff --git a/tests/j_long_revoke_trans_mcsum_32bit/expect b/tests/j_long_revoke_trans_mcsum_32bit/expect
index 664a301d0dae..8e8d6ab021de 100644
--- a/tests/j_long_revoke_trans_mcsum_32bit/expect
+++ b/tests/j_long_revoke_trans_mcsum_32bit/expect
@@ -13,7 +13,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 27050/524288 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 27050/524288 blocks
 Exit status is 0
 Journal features:         (none)
 debugfs write journal
@@ -113,5 +113,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 27050/524288 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 27050/524288 blocks
 Exit status is 0
diff --git a/tests/j_long_revoke_trans_mcsum_64bit/expect b/tests/j_long_revoke_trans_mcsum_64bit/expect
index 29dc407d1269..76baf1a2641f 100644
--- a/tests/j_long_revoke_trans_mcsum_64bit/expect
+++ b/tests/j_long_revoke_trans_mcsum_64bit/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 27068/524288 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 27068/524288 blocks
 Exit status is 0
 Journal features:         (none)
 debugfs write journal
@@ -128,5 +128,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 27068/524288 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 27068/524288 blocks
 Exit status is 0
diff --git a/tests/j_long_trans/expect b/tests/j_long_trans/expect
index 7a175414be5f..991cea18a6bd 100644
--- a/tests/j_long_trans/expect
+++ b/tests/j_long_trans/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 14431/262144 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 14431/262144 blocks
 Exit status is 0
 debugfs write journal
 debugfs: logdump -c
@@ -84,16 +84,16 @@ Fix? yes
 Free blocks count wrong (247711, counted=255916).
 Fix? yes
 
-Inode bitmap differences:  +1 +(3--10)
+Inode bitmap differences:  +1 +(3--63)
 Fix? yes
 
-Free inodes count wrong for group #0 (500, counted=501).
+Free inodes count wrong for group #0 (447, counted=448).
 Fix? yes
 
 Directories count wrong for group #0 (3, counted=2).
 Fix? yes
 
-Free inodes count wrong (16372, counted=16373).
+Free inodes count wrong (16319, counted=16320).
 Fix? yes
 
 Recreate journal? yes
@@ -103,5 +103,5 @@ Creating journal (8192 blocks):  Done.
 *** journal has been regenerated ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/16384 files (0.0% non-contiguous), 14420/262144 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 14420/262144 blocks
 Exit status is 1
diff --git a/tests/j_long_trans_mcsum_32bit/expect b/tests/j_long_trans_mcsum_32bit/expect
index a808d9f4d706..ef4969a04dcb 100644
--- a/tests/j_long_trans_mcsum_32bit/expect
+++ b/tests/j_long_trans_mcsum_32bit/expect
@@ -13,7 +13,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 27050/524288 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 27050/524288 blocks
 Exit status is 0
 Journal features:         (none)
 debugfs write journal
@@ -123,16 +123,16 @@ Fix? yes
 Free blocks count wrong (497236, counted=513633).
 Fix? yes
 
-Inode bitmap differences:  +1 +(3--10)
+Inode bitmap differences:  +1 +(3--63)
 Fix? yes
 
-Free inodes count wrong for group #0 (500, counted=501).
+Free inodes count wrong for group #0 (447, counted=448).
 Fix? yes
 
 Directories count wrong for group #0 (3, counted=2).
 Fix? yes
 
-Free inodes count wrong (32756, counted=32757).
+Free inodes count wrong (32703, counted=32704).
 Fix? yes
 
 Recreate journal? yes
@@ -142,5 +142,5 @@ Creating journal (16384 blocks):  Done.
 *** journal has been regenerated ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/32768 files (0.0% non-contiguous), 27039/524288 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 27039/524288 blocks
 Exit status is 1
diff --git a/tests/j_long_trans_mcsum_64bit/expect b/tests/j_long_trans_mcsum_64bit/expect
index 76e109a42102..27d38cf7d12b 100644
--- a/tests/j_long_trans_mcsum_64bit/expect
+++ b/tests/j_long_trans_mcsum_64bit/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 27068/524288 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 27068/524288 blocks
 Exit status is 0
 Journal features:         (none)
 debugfs write journal
@@ -122,16 +122,16 @@ Fix? yes
 Free blocks count wrong (497218, counted=513615).
 Fix? yes
 
-Inode bitmap differences:  +1 +(3--10)
+Inode bitmap differences:  +1 +(3--63)
 Fix? yes
 
-Free inodes count wrong for group #0 (500, counted=501).
+Free inodes count wrong for group #0 (447, counted=448).
 Fix? yes
 
 Directories count wrong for group #0 (3, counted=2).
 Fix? yes
 
-Free inodes count wrong (32756, counted=32757).
+Free inodes count wrong (32703, counted=32704).
 Fix? yes
 
 Recreate journal? yes
@@ -141,5 +141,5 @@ Creating journal (16384 blocks):  Done.
 *** journal has been regenerated ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/32768 files (0.0% non-contiguous), 27057/524288 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 27057/524288 blocks
 Exit status is 1
diff --git a/tests/j_short_revoke_trans/expect b/tests/j_short_revoke_trans/expect
index e83c5ea8414d..dd6104ded65d 100644
--- a/tests/j_short_revoke_trans/expect
+++ b/tests/j_short_revoke_trans/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 0
 debugfs write journal
 debugfs: logdump -c
@@ -28,5 +28,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 0
diff --git a/tests/j_short_revoke_trans_mcsum_64bit/expect b/tests/j_short_revoke_trans_mcsum_64bit/expect
index 2b0eeb3676ef..542ec17b49af 100644
--- a/tests/j_short_revoke_trans_mcsum_64bit/expect
+++ b/tests/j_short_revoke_trans_mcsum_64bit/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 6353/131072 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 6353/131072 blocks
 Exit status is 0
 Journal features:         (none)
 debugfs write journal
@@ -30,5 +30,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 6353/131072 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 6353/131072 blocks
 Exit status is 0
diff --git a/tests/j_short_trans/expect b/tests/j_short_trans/expect
index bcc8fe82a57a..fda0c1ebdef9 100644
--- a/tests/j_short_trans/expect
+++ b/tests/j_short_trans/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 0
 debugfs write journal
 debugfs: logdump -c
@@ -29,10 +29,10 @@ Pass 5: Checking group summary information
 Block bitmap differences:  +(0--1050) +(32768--36880)
 Fix? yes
 
-Inode bitmap differences:  +(1--11)
+Inode bitmap differences:  +(1--64)
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 1
diff --git a/tests/j_short_trans_64bit/expect b/tests/j_short_trans_64bit/expect
index f9971eba383a..9833b848a037 100644
--- a/tests/j_short_trans_64bit/expect
+++ b/tests/j_short_trans_64bit/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 5196/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5196/65536 blocks
 Exit status is 0
 Journal features:         (none)
 debugfs write journal
@@ -31,10 +31,10 @@ Pass 5: Checking group summary information
 Block bitmap differences:  +(0--1066) +(32768--36896)
 Fix? yes
 
-Inode bitmap differences:  +(1--11)
+Inode bitmap differences:  +(1--64)
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/16384 files (0.0% non-contiguous), 5196/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5196/65536 blocks
 Exit status is 1
diff --git a/tests/j_short_trans_mcsum_64bit/expect b/tests/j_short_trans_mcsum_64bit/expect
index d876ff095542..bc0fd309454b 100644
--- a/tests/j_short_trans_mcsum_64bit/expect
+++ b/tests/j_short_trans_mcsum_64bit/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 6353/131072 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 6353/131072 blocks
 Exit status is 0
 Journal features:         (none)
 debugfs write journal
@@ -31,10 +31,10 @@ Pass 5: Checking group summary information
 Block bitmap differences:  +(0--65) +(67--69) +(71--584) +(1097--2126) +(65536--69631) +(98304--98368)
 Fix? yes
 
-Inode bitmap differences:  +(1--11)
+Inode bitmap differences:  +(1--64)
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/32768 files (0.0% non-contiguous), 6353/131072 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 6353/131072 blocks
 Exit status is 1
diff --git a/tests/j_short_trans_old_csum/expect b/tests/j_short_trans_old_csum/expect
index 29ac27fb3c9c..9d9148bed943 100644
--- a/tests/j_short_trans_old_csum/expect
+++ b/tests/j_short_trans_old_csum/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 0
 Journal features:         (none)
 debugfs write journal
@@ -31,10 +31,10 @@ Pass 5: Checking group summary information
 Block bitmap differences:  +(0--1050) +(32768--36880)
 Fix? yes
 
-Inode bitmap differences:  +(1--11)
+Inode bitmap differences:  +(1--64)
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 1
diff --git a/tests/j_short_trans_open_recover/expect b/tests/j_short_trans_open_recover/expect
index be6e363dc8ac..6673ccea503a 100644
--- a/tests/j_short_trans_open_recover/expect
+++ b/tests/j_short_trans_open_recover/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 0
 debugfs write journal
 debugfs: logdump -c
@@ -34,10 +34,10 @@ Pass 5: Checking group summary information
 Block bitmap differences:  +(0--1050) +(32768--36880)
 Fix? yes
 
-Inode bitmap differences:  +(1--11)
+Inode bitmap differences:  +(1--64)
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 1
diff --git a/tests/j_short_trans_recover/expect b/tests/j_short_trans_recover/expect
index 75867337fafd..b0eecef78cd6 100644
--- a/tests/j_short_trans_recover/expect
+++ b/tests/j_short_trans_recover/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 0
 debugfs write journal
 debugfs: logdump -c
@@ -31,10 +31,10 @@ Pass 5: Checking group summary information
 Block bitmap differences:  +(0--1050) +(32768--36880)
 Fix? yes
 
-Inode bitmap differences:  +(1--11)
+Inode bitmap differences:  +(1--64)
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 1
diff --git a/tests/j_short_trans_recover_mcsum_64bit/expect b/tests/j_short_trans_recover_mcsum_64bit/expect
index 9cc330978560..02decee3c0c7 100644
--- a/tests/j_short_trans_recover_mcsum_64bit/expect
+++ b/tests/j_short_trans_recover_mcsum_64bit/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 6353/131072 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 6353/131072 blocks
 Exit status is 0
 Journal features:         (none)
 debugfs write journal
@@ -33,10 +33,10 @@ Pass 5: Checking group summary information
 Block bitmap differences:  +(0--65) +(67--69) +(71--584) +(1097--2126) +(65536--69631) +(98304--98368)
 Fix? yes
 
-Inode bitmap differences:  +(1--11)
+Inode bitmap differences:  +(1--64)
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/32768 files (0.0% non-contiguous), 6353/131072 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 6353/131072 blocks
 Exit status is 1
diff --git a/tests/j_short_uncommitted_trans/expect b/tests/j_short_uncommitted_trans/expect
index dedddb5b373a..db8a18f7a85d 100644
--- a/tests/j_short_uncommitted_trans/expect
+++ b/tests/j_short_uncommitted_trans/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 0
 debugfs write journal
 debugfs: logdump -c
@@ -22,5 +22,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 5164/65536 blocks
 Exit status is 0
diff --git a/tests/j_short_uncommitted_trans_mcsum_64bit/expect b/tests/j_short_uncommitted_trans_mcsum_64bit/expect
index 3effc94fec5d..2504838fc963 100644
--- a/tests/j_short_uncommitted_trans_mcsum_64bit/expect
+++ b/tests/j_short_uncommitted_trans_mcsum_64bit/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 6353/131072 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 6353/131072 blocks
 Exit status is 0
 Journal features:         (none)
 debugfs write journal
@@ -24,5 +24,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 6353/131072 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 6353/131072 blocks
 Exit status is 0
diff --git a/tests/m_64bit_flexbg/expect.1 b/tests/m_64bit_flexbg/expect.1
index cfa3bc9bf336..1d731def1699 100644
--- a/tests/m_64bit_flexbg/expect.1
+++ b/tests/m_64bit_flexbg/expect.1
@@ -10,7 +10,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/128 files (0.0% non-contiguous), 42/1024 blocks
+test_filesys: 64/128 files (0.0% non-contiguous), 42/1024 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -25,7 +25,7 @@ Inode count:              128
 Block count:              1024
 Reserved block count:     51
 Free blocks:              982
-Free inodes:              117
+Free inodes:              64
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -40,7 +40,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -51,6 +51,6 @@ Group 0: (Blocks 1-1023)
   Block bitmap at 10 (+9)
   Inode bitmap at 26 (+25)
   Inode table at 42-57 (+41)
-  982 free blocks, 117 free inodes, 2 directories
+  982 free blocks, 64 free inodes, 2 directories
   Free blocks: 24-25, 28-41, 58-1023
-  Free inodes: 12-128
+  Free inodes: 65-128
diff --git a/tests/m_dasd_bs/expect.1 b/tests/m_dasd_bs/expect.1
index 0e55e8f7e127..14808ed41b2c 100644
--- a/tests/m_dasd_bs/expect.1
+++ b/tests/m_dasd_bs/expect.1
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 1104/32768 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 1104/32768 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -27,7 +27,7 @@ Inode count:              16384
 Block count:              32768
 Reserved block count:     1638
 Free blocks:              31664
-Free inodes:              16373
+Free inodes:              16320
 First block:              0
 Block size:               2048
 Fragment size:            2048
@@ -40,7 +40,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -51,9 +51,9 @@ Group 0: (Blocks 0-16383)
   Block bitmap at 33 (+33)
   Inode bitmap at 34 (+34)
   Inode table at 35-546 (+35)
-  15827 free blocks, 8181 free inodes, 2 directories
+  15827 free blocks, 8128 free inodes, 2 directories
   Free blocks: 557-16383
-  Free inodes: 12-8192
+  Free inodes: 65-8192
 Group 1: (Blocks 16384-32767)
   Backup superblock at 16384, Group descriptors at 16385-16385
   Reserved GDT blocks at 16386-16416
diff --git a/tests/m_desc_size_128/expect.1 b/tests/m_desc_size_128/expect.1
index 5a7da87b72d1..9b6f5647df92 100644
--- a/tests/m_desc_size_128/expect.1
+++ b/tests/m_desc_size_128/expect.1
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/8192 files (0.0% non-contiguous), 4298/131072 blocks
+test_filesys: 64/8192 files (0.0% non-contiguous), 4298/131072 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -27,7 +27,7 @@ Inode count:              8192
 Block count:              131072
 Reserved block count:     6553
 Free blocks:              126774
-Free inodes:              8181
+Free inodes:              8128
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -41,7 +41,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -51,9 +51,9 @@ Group 0: (Blocks 1-1024)
   Reserved GDT blocks at 18-273
   Block bitmap at 274 (+273), Inode bitmap at 275 (+274)
   Inode table at 276-283 (+275)
-  727 free blocks, 53 free inodes, 2 directories
+  727 free blocks, 0 free inodes, 2 directories
   Free blocks: 298-1024
-  Free inodes: 12-64
+  Free inodes: 
 Group 1: (Blocks 1025-2048)
   Backup superblock at 1025, Group descriptors at 1026-1041
   Reserved GDT blocks at 1042-1297
diff --git a/tests/m_extent_journal/expect.1 b/tests/m_extent_journal/expect.1
index 34e8a80d353d..f3a74084a270 100644
--- a/tests/m_extent_journal/expect.1
+++ b/tests/m_extent_journal/expect.1
@@ -13,7 +13,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 7460/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 7460/65536 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -28,7 +28,7 @@ Inode count:              16384
 Block count:              65536
 Reserved block count:     3276
 Free blocks:              58076
-Free inodes:              16373
+Free inodes:              16320
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -41,7 +41,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Journal inode:            8
 Default directory hash:   half_md4
@@ -58,9 +58,9 @@ Group 0: (Blocks 1-8192)
   Reserved GDT blocks at 3-257
   Block bitmap at 258 (+257), Inode bitmap at 259 (+258)
   Inode table at 260-515 (+259)
-  7663 free blocks, 2037 free inodes, 2 directories
+  7663 free blocks, 1984 free inodes, 2 directories
   Free blocks: 530-8192
-  Free inodes: 12-2048
+  Free inodes: 65-2048
 Group 1: (Blocks 8193-16384)
   Backup superblock at 8193, Group descriptors at 8194-8194
   Reserved GDT blocks at 8195-8449
diff --git a/tests/m_large_file/expect.1 b/tests/m_large_file/expect.1
index 4acca41ce520..840c2fe934b1 100644
--- a/tests/m_large_file/expect.1
+++ b/tests/m_large_file/expect.1
@@ -1,4 +1,4 @@
-Creating filesystem with 16384 4k blocks and 64 inodes
+Creating filesystem with 16384 4k blocks and 80 inodes
 
 Allocating group tables:    done                            
 Writing inode tables:    done                            
@@ -10,7 +10,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/64 files (0.0% non-contiguous), 17/16384 blocks
+test_filesys: 64/80 files (0.0% non-contiguous), 18/16384 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -21,24 +21,24 @@ Default mount options:    (none)
 Filesystem state:         clean
 Errors behavior:          Continue
 Filesystem OS type:       Linux
-Inode count:              64
+Inode count:              80
 Block count:              16384
 Reserved block count:     819
-Free blocks:              16367
-Free inodes:              53
+Free blocks:              16366
+Free inodes:              16
 First block:              0
 Block size:               4096
 Fragment size:            4096
 Reserved GDT blocks:      3
 Blocks per group:         32768
 Fragments per group:      32768
-Inodes per group:         64
-Inode blocks per group:   4
+Inodes per group:         80
+Inode blocks per group:   5
 Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          256
 Required extra isize:     28
 Desired extra isize:      28
@@ -50,7 +50,7 @@ Group 0: (Blocks 0-16383)
   Reserved GDT blocks at 2-4
   Block bitmap at 5 (+5)
   Inode bitmap at 6 (+6)
-  Inode table at 7-10 (+7)
-  16367 free blocks, 53 free inodes, 2 directories
-  Free blocks: 17-16383
-  Free inodes: 12-64
+  Inode table at 7-11 (+7)
+  16366 free blocks, 16 free inodes, 2 directories
+  Free blocks: 18-16383
+  Free inodes: 65-80
diff --git a/tests/m_meta_bg/expect.1 b/tests/m_meta_bg/expect.1
index 7df4230ca0bd..568c43514780 100644
--- a/tests/m_meta_bg/expect.1
+++ b/tests/m_meta_bg/expect.1
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 4389/131072 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 4389/131072 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -27,7 +27,7 @@ Inode count:              32768
 Block count:              131072
 Reserved block count:     6553
 Free blocks:              126683
-Free inodes:              32757
+Free inodes:              32704
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -39,7 +39,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -48,9 +48,9 @@ Group 0: (Blocks 1-1024)
   Primary superblock at 1, Group descriptor at 2
   Block bitmap at 3 (+2), Inode bitmap at 4 (+3)
   Inode table at 5-36 (+4)
-  975 free blocks, 245 free inodes, 2 directories
+  975 free blocks, 192 free inodes, 2 directories
   Free blocks: 50-1024
-  Free inodes: 12-256
+  Free inodes: 65-256
 Group 1: (Blocks 1025-2048)
   Backup superblock at 1025, Group descriptor at 1026
   Block bitmap at 1027 (+2), Inode bitmap at 1028 (+3)
diff --git a/tests/m_minrootdir/expect b/tests/m_minrootdir/expect
index 41a713fd02ca..953df9b2db0f 100644
--- a/tests/m_minrootdir/expect
+++ b/tests/m_minrootdir/expect
@@ -12,7 +12,7 @@ Inode count:              1024
 Block count:              16384
 Reserved block count:     819
 Free blocks:              16065
-Free inodes:              1006
+Free inodes:              953
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -26,7 +26,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          256
 Required extra isize:     28
 Desired extra isize:      28
@@ -39,9 +39,9 @@ Group 0: (Blocks 1-8192)
   Block bitmap at 3 (+2)
   Inode bitmap at 5 (+4)
   Inode table at 7-134 (+6)
-  7876 free blocks, 494 free inodes, 4 directories, 494 unused inodes
+  7876 free blocks, 441 free inodes, 4 directories, 441 unused inodes
   Free blocks: 317-8192
-  Free inodes: 19-512
+  Free inodes: 72-512
 Group 1: (Blocks 8193-16383) [INODE_UNINIT]
   Backup superblock at 8193, Group descriptors at 8194-8194
   Block bitmap at 4 (bg #0 + 3)
@@ -105,11 +105,11 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test.img: 18/1024 files (0.0% non-contiguous), 319/16384 blocks
+test.img: 71/1024 files (0.0% non-contiguous), 319/16384 blocks
 minify fs
 Setting reserved blocks percentage to 0% (0 blocks)
-Resizing the filesystem on test.img to 338 (1k) blocks.
-The filesystem on test.img is now 338 (1k) blocks long.
+Resizing the filesystem on test.img to 352 (1k) blocks.
+The filesystem on test.img is now 352 (1k) blocks long.
 
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -121,10 +121,10 @@ Filesystem state:         clean
 Errors behavior:          Continue
 Filesystem OS type:       Linux
 Inode count:              512
-Block count:              338
+Block count:              352
 Reserved block count:     0
-Free blocks:              151
-Free inodes:              494
+Free blocks:              165
+Free inodes:              441
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -138,7 +138,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          256
 Required extra isize:     28
 Desired extra isize:      28
@@ -146,20 +146,20 @@ Default directory hash:   half_md4
 Checksum type:            crc32c
 
 
-Group 0: (Blocks 1-337)
+Group 0: (Blocks 1-351)
   Primary superblock at 1, Group descriptors at 2-2
   Block bitmap at 3 (+2)
   Inode bitmap at 5 (+4)
   Inode table at 7-134 (+6)
-  151 free blocks, 494 free inodes, 4 directories, 494 unused inodes
-  Free blocks: 4, 6, 135-262, 317-337
-  Free inodes: 19-512
+  165 free blocks, 441 free inodes, 4 directories, 441 unused inodes
+  Free blocks: 4, 6, 135-262, 317-351
+  Free inodes: 72-512
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test.img: 18/512 files (0.0% non-contiguous), 187/338 blocks
+test.img: 71/512 files (0.0% non-contiguous), 187/352 blocks
 minify fs (2)
 Setting reserved blocks percentage to 0% (0 blocks)
 Resizing the filesystem on test.img to 188 (1k) blocks.
@@ -178,7 +178,7 @@ Inode count:              512
 Block count:              188
 Reserved block count:     0
 Free blocks:              1
-Free inodes:              494
+Free inodes:              441
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -192,7 +192,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          256
 Required extra isize:     28
 Desired extra isize:      28
@@ -205,12 +205,12 @@ Group 0: (Blocks 1-187)
   Block bitmap at 3 (+2)
   Inode bitmap at 5 (+4)
   Inode table at 7-134 (+6)
-  1 free blocks, 494 free inodes, 4 directories, 494 unused inodes
+  1 free blocks, 441 free inodes, 4 directories, 441 unused inodes
   Free blocks: 187
-  Free inodes: 19-512
+  Free inodes: 72-512
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test.img: 18/512 files (5.6% non-contiguous), 187/188 blocks
+test.img: 71/512 files (1.4% non-contiguous), 187/188 blocks
diff --git a/tests/m_mmp/expect.1 b/tests/m_mmp/expect.1
index a1452e6ba795..396e608dd02b 100644
--- a/tests/m_mmp/expect.1
+++ b/tests/m_mmp/expect.1
@@ -13,7 +13,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/65536 files (0.0% non-contiguous), 2093/65536 blocks
+test_filesys: 64/65536 files (0.0% non-contiguous), 2093/65536 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -28,7 +28,7 @@ Inode count:              65536
 Block count:              65536
 Reserved block count:     3276
 Free blocks:              63443
-Free inodes:              65525
+Free inodes:              65472
 First block:              0
 Block size:               4096
 Fragment size:            4096
@@ -41,7 +41,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 MMP block number:         1049
@@ -54,9 +54,9 @@ Group 0: (Blocks 0-32767)
   Block bitmap at 17 (+17)
   Inode bitmap at 18 (+18)
   Inode table at 19-1042 (+19)
-  31718 free blocks, 32757 free inodes, 2 directories
+  31718 free blocks, 32704 free inodes, 2 directories
   Free blocks: 1050-32767
-  Free inodes: 12-32768
+  Free inodes: 65-32768
 Group 1: (Blocks 32768-65535)
   Backup superblock at 32768, Group descriptors at 32769-32769
   Reserved GDT blocks at 32770-32784
diff --git a/tests/m_no_opt/expect.1 b/tests/m_no_opt/expect.1
index 58b311c4eddf..4a9733735d47 100644
--- a/tests/m_no_opt/expect.1
+++ b/tests/m_no_opt/expect.1
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 2094/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 2094/65536 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -27,7 +27,7 @@ Inode count:              16384
 Block count:              65536
 Reserved block count:     3276
 Free blocks:              63442
-Free inodes:              16373
+Free inodes:              16320
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -39,7 +39,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -48,9 +48,9 @@ Group 0: (Blocks 1-8192)
   Primary superblock at 1, Group descriptors at 2-2
   Block bitmap at 3 (+2), Inode bitmap at 4 (+3)
   Inode table at 5-260 (+4)
-  7919 free blocks, 2037 free inodes, 2 directories
+  7919 free blocks, 1984 free inodes, 2 directories
   Free blocks: 274-8192
-  Free inodes: 12-2048
+  Free inodes: 65-2048
 Group 1: (Blocks 8193-16384)
   Backup superblock at 8193, Group descriptors at 8194-8194
   Block bitmap at 8195 (+2), Inode bitmap at 8196 (+3)
diff --git a/tests/m_raid_opt/expect.1 b/tests/m_raid_opt/expect.1
index 0fccb7cadcbc..8385089d01d0 100644
--- a/tests/m_raid_opt/expect.1
+++ b/tests/m_raid_opt/expect.1
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 7238/131072 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 7238/131072 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -27,7 +27,7 @@ Inode count:              32768
 Block count:              131072
 Reserved block count:     6553
 Free blocks:              123834
-Free inodes:              32757
+Free inodes:              32704
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -41,7 +41,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -51,9 +51,9 @@ Group 0: (Blocks 1-1024)
   Reserved GDT blocks at 6-261
   Block bitmap at 294 (+293), Inode bitmap at 295 (+294)
   Inode table at 262-293 (+261)
-  715 free blocks, 245 free inodes, 2 directories
+  715 free blocks, 192 free inodes, 2 directories
   Free blocks: 310-1024
-  Free inodes: 12-256
+  Free inodes: 65-256
 Group 1: (Blocks 1025-2048)
   Backup superblock at 1025, Group descriptors at 1026-1029
   Reserved GDT blocks at 1030-1285
diff --git a/tests/m_root_owner/expect.1 b/tests/m_root_owner/expect.1
index 30d119e22c99..7a83f962c869 100644
--- a/tests/m_root_owner/expect.1
+++ b/tests/m_root_owner/expect.1
@@ -10,7 +10,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/128 files (0.0% non-contiguous), 38/1024 blocks
+test_filesys: 64/128 files (0.0% non-contiguous), 38/1024 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -25,7 +25,7 @@ Inode count:              128
 Block count:              1024
 Reserved block count:     51
 Free blocks:              986
-Free inodes:              117
+Free inodes:              64
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -38,7 +38,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -49,6 +49,6 @@ Group 0: (Blocks 1-1023)
   Block bitmap at 6 (+5)
   Inode bitmap at 7 (+6)
   Inode table at 8-23 (+7)
-  986 free blocks, 117 free inodes, 2 directories
+  986 free blocks, 64 free inodes, 2 directories
   Free blocks: 38-1023
-  Free inodes: 12-128
+  Free inodes: 65-128
diff --git a/tests/m_rootdir/expect b/tests/m_rootdir/expect
index a5314f14366f..cc150d234fb1 100644
--- a/tests/m_rootdir/expect
+++ b/tests/m_rootdir/expect
@@ -11,7 +11,7 @@ Inode count:              1024
 Block count:              16384
 Reserved block count:     819
 Free blocks:              14786
-Free inodes:              1005
+Free inodes:              952
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -26,7 +26,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          256
 Required extra isize:     28
 Desired extra isize:      28
@@ -47,9 +47,9 @@ Group 0: (Blocks 1-8192)
   Block bitmap at 130 (+129)
   Inode bitmap at 132 (+131)
   Inode table at 134-261 (+133)
-  7748 free blocks, 493 free inodes, 4 directories, 493 unused inodes
+  7748 free blocks, 440 free inodes, 4 directories, 440 unused inodes
   Free blocks: 445-8192
-  Free inodes: 20-512
+  Free inodes: 73-512
 Group 1: (Blocks 8193-16383) [INODE_UNINIT]
   Backup superblock at 8193, Group descriptors at 8194-8194
   Reserved GDT blocks at 8195-8321
@@ -114,4 +114,4 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test.img: 19/1024 files (0.0% non-contiguous), 1598/16384 blocks
+test.img: 72/1024 files (0.0% non-contiguous), 1598/16384 blocks
diff --git a/tests/m_std/expect.1 b/tests/m_std/expect.1
index b05031f8e315..8661e6978354 100644
--- a/tests/m_std/expect.1
+++ b/tests/m_std/expect.1
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 3364/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 3364/65536 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -27,7 +27,7 @@ Inode count:              16384
 Block count:              65536
 Reserved block count:     3276
 Free blocks:              62172
-Free inodes:              16373
+Free inodes:              16320
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -40,7 +40,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -50,9 +50,9 @@ Group 0: (Blocks 1-8192)
   Reserved GDT blocks at 3-257
   Block bitmap at 258 (+257), Inode bitmap at 259 (+258)
   Inode table at 260-515 (+259)
-  7663 free blocks, 2037 free inodes, 2 directories
+  7663 free blocks, 1984 free inodes, 2 directories
   Free blocks: 530-8192
-  Free inodes: 12-2048
+  Free inodes: 65-2048
 Group 1: (Blocks 8193-16384)
   Backup superblock at 8193, Group descriptors at 8194-8194
   Reserved GDT blocks at 8195-8449
diff --git a/tests/m_uninit/expect.1 b/tests/m_uninit/expect.1
index e886dfbf1373..3e2ead292009 100644
--- a/tests/m_uninit/expect.1
+++ b/tests/m_uninit/expect.1
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (0.0% non-contiguous), 5691/131072 blocks
+test_filesys: 64/32768 files (0.0% non-contiguous), 5691/131072 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
@@ -27,7 +27,7 @@ Inode count:              32768
 Block count:              131072
 Reserved block count:     6553
 Free blocks:              125381
-Free inodes:              32757
+Free inodes:              32704
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -40,7 +40,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -50,9 +50,9 @@ Group 0: (Blocks 1-8192) [ITABLE_ZEROED]
   Reserved GDT blocks at 3-258
   Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
   Inode table at 261-516 (+260)
-  7662 free blocks, 2037 free inodes, 2 directories, 2037 unused inodes
+  7662 free blocks, 1984 free inodes, 2 directories, 1984 unused inodes
   Free blocks: 531-8192
-  Free inodes: 12-2048
+  Free inodes: 65-2048
 Group 1: (Blocks 8193-16384) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Backup superblock at 8193, Group descriptors at 8194-8194
   Reserved GDT blocks at 8195-8450
diff --git a/tests/r_fixup_lastbg/expect b/tests/r_fixup_lastbg/expect
index 96b154a94078..64e227c89d4d 100644
--- a/tests/r_fixup_lastbg/expect
+++ b/tests/r_fixup_lastbg/expect
@@ -36,4 +36,4 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test.img: 11/1248 files (0.0% non-contiguous), 1517/20004 blocks
+test.img: 64/1248 files (0.0% non-contiguous), 1517/20004 blocks
diff --git a/tests/r_fixup_lastbg_big/expect b/tests/r_fixup_lastbg_big/expect
index edaabaf00d91..43a21b2b9987 100644
--- a/tests/r_fixup_lastbg_big/expect
+++ b/tests/r_fixup_lastbg_big/expect
@@ -42,4 +42,4 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test.img: 11/2080 files (0.0% non-contiguous), 1809/40000 blocks
+test.img: 64/2080 files (0.0% non-contiguous), 1809/40000 blocks
diff --git a/tests/r_resize_inode/expect b/tests/r_resize_inode/expect
index ba1647ea72c2..4594bc190e55 100644
--- a/tests/r_resize_inode/expect
+++ b/tests/r_resize_inode/expect
@@ -8,7 +8,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 4513/65536 blocks
+test_filesys: 64/16384 files (0.0% non-contiguous), 4513/65536 blocks
 Exit status is 0
 dumpe2fs test.img
 Filesystem volume name:   <none>
@@ -24,7 +24,7 @@ Inode count:              16384
 Block count:              65536
 Reserved block count:     3276
 Free blocks:              61023
-Free inodes:              16373
+Free inodes:              16320
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -37,7 +37,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -47,9 +47,9 @@ Group 0: (Blocks 1-1024)
   Reserved GDT blocks at 4-258
   Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
   Inode table at 261-292 (+260)
-  718 free blocks, 245 free inodes, 2 directories
+  718 free blocks, 192 free inodes, 2 directories
   Free blocks: 307-1024
-  Free inodes: 12-256
+  Free inodes: 65-256
 Group 1: (Blocks 1025-2048)
   Backup superblock at 1025, Group descriptors at 1026-1027
   Reserved GDT blocks at 1028-1282
@@ -455,7 +455,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 64/4096 files (0.0% non-contiguous), 2107/16384 blocks
 Exit status is 0
 dumpe2fs test.img
 Filesystem volume name:   <none>
@@ -471,7 +471,7 @@ Inode count:              4096
 Block count:              16384
 Reserved block count:     819
 Free blocks:              14277
-Free inodes:              4085
+Free inodes:              4032
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -484,7 +484,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -494,9 +494,9 @@ Group 0: (Blocks 1-1024)
   Reserved GDT blocks at 3-258
   Block bitmap at 260 (+259), Inode bitmap at 261 (+260)
   Inode table at 262-293 (+261)
-  718 free blocks, 245 free inodes, 2 directories
+  718 free blocks, 192 free inodes, 2 directories
   Free blocks: 259, 308-1024
-  Free inodes: 12-256
+  Free inodes: 65-256
 Group 1: (Blocks 1025-2048)
   Backup superblock at 1025, Group descriptors at 1026-1026
   Reserved GDT blocks at 1027-1282
@@ -609,7 +609,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/41472 files (0.0% non-contiguous), 8361/165536 blocks
+test_filesys: 64/41472 files (0.0% non-contiguous), 8361/165536 blocks
 Exit status is 0
 dumpe2fs test.img
 Filesystem volume name:   <none>
@@ -625,7 +625,7 @@ Inode count:              41472
 Block count:              165536
 Reserved block count:     8274
 Free blocks:              157175
-Free inodes:              41461
+Free inodes:              41408
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -638,7 +638,7 @@ Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
 Reserved blocks gid:      0
-First inode:              11
+First inode:              64
 Inode size:	          128
 Default directory hash:   half_md4
 
@@ -648,9 +648,9 @@ Group 0: (Blocks 1-1024)
   Reserved GDT blocks at 8-258
   Block bitmap at 260 (+259), Inode bitmap at 261 (+260)
   Inode table at 262-293 (+261)
-  718 free blocks, 245 free inodes, 2 directories
+  718 free blocks, 192 free inodes, 2 directories
   Free blocks: 259, 308-1024
-  Free inodes: 12-256
+  Free inodes: 65-256
 Group 1: (Blocks 1025-2048)
   Backup superblock at 1025, Group descriptors at 1026-1031
   Reserved GDT blocks at 1032-1282
diff --git a/tests/t_32to64bit_meta/expect b/tests/t_32to64bit_meta/expect
index 28e328c524a8..eb5b79e1fe9a 100644
--- a/tests/t_32to64bit_meta/expect
+++ b/tests/t_32to64bit_meta/expect
@@ -34,7 +34,7 @@ Change in FS metadata:
  Reserved block count:     26214
 -Free blocks:              858
 +Free blocks:              852
- Free inodes:              65046
+ Free inodes:              64993
  First block:              1
  Block size:               1024
  Fragment size:            1024
diff --git a/tests/t_32to64bit_move_itable/expect b/tests/t_32to64bit_move_itable/expect
index e4fa55432bb3..4f9aa9ef7922 100644
--- a/tests/t_32to64bit_move_itable/expect
+++ b/tests/t_32to64bit_move_itable/expect
@@ -34,7 +34,7 @@ Change in FS metadata:
  Reserved block count:     39321
 -Free blocks:              764
 +Free blocks:              734
- Free inodes:              97566
+ Free inodes:              97513
  First block:              1
  Block size:               1024
  Fragment size:            1024
diff --git a/tests/t_64to32bit/expect b/tests/t_64to32bit/expect
index 6d8ff8011a7c..2af0227b891e 100644
--- a/tests/t_64to32bit/expect
+++ b/tests/t_64to32bit/expect
@@ -34,7 +34,7 @@ Change in FS metadata:
  Reserved block count:     26214
 -Free blocks:              571
 +Free blocks:              589
- Free inodes:              65048
+ Free inodes:              64995
  First block:              1
  Block size:               1024
  Fragment size:            1024
diff --git a/tests/t_64to32bit_meta/expect b/tests/t_64to32bit_meta/expect
index d6e2dccc894b..7e40a99ae8ec 100644
--- a/tests/t_64to32bit_meta/expect
+++ b/tests/t_64to32bit_meta/expect
@@ -37,7 +37,7 @@ Change in FS metadata:
  Reserved block count:     26214
 -Free blocks:              852
 +Free blocks:              858
- Free inodes:              65046
+ Free inodes:              64993
  First block:              1
  Block size:               1024
  Fragment size:            1024
diff --git a/tests/t_disable_mcsum_noinitbg/expect b/tests/t_disable_mcsum_noinitbg/expect
index a022631d1706..3c405e770767 100644
--- a/tests/t_disable_mcsum_noinitbg/expect
+++ b/tests/t_disable_mcsum_noinitbg/expect
@@ -40,10 +40,10 @@ Change in FS metadata:
    Block bitmap at 262 (+261)
    Inode bitmap at 278 (+277)
    Inode table at 294-549 (+293)
--  21 free blocks, 536 free inodes, 2 directories, 536 unused inodes
-+  21 free blocks, 536 free inodes, 2 directories
+-  21 free blocks, 483 free inodes, 2 directories, 483 unused inodes
++  21 free blocks, 483 free inodes, 2 directories
    Free blocks: 4413-4433
-   Free inodes: 489-1024
+   Free inodes: 542-1024
 -Group 1: (Blocks 8193-16384) [INODE_UNINIT]
 +Group 1: (Blocks 8193-16384)
    Backup superblock at 8193, Group descriptors at 8194-8197
diff --git a/tests/t_enable_mcsum/expect b/tests/t_enable_mcsum/expect
index 2ee3c279c42b..6ed16ded0798 100644
--- a/tests/t_enable_mcsum/expect
+++ b/tests/t_enable_mcsum/expect
@@ -47,7 +47,7 @@ Change in FS metadata:
  Reserved block count:     26214
 -Free blocks:              571
 +Free blocks:              568
- Free inodes:              65048
+ Free inodes:              64995
  First block:              1
  Block size:               1024
 @@ -33,6 +33,7 @@
@@ -62,11 +62,11 @@ Change in FS metadata:
    Block bitmap at 262 (+261)
    Inode bitmap at 278 (+277)
    Inode table at 294-549 (+293)
--  21 free blocks, 536 free inodes, 2 directories, 536 unused inodes
+-  21 free blocks, 483 free inodes, 2 directories, 483 unused inodes
 -  Free blocks: 4413-4433
-+  18 free blocks, 536 free inodes, 2 directories, 536 unused inodes
++  18 free blocks, 483 free inodes, 2 directories, 483 unused inodes
 +  Free blocks: 4413, 4417-4433
-   Free inodes: 489-1024
+   Free inodes: 542-1024
  Group 1: (Blocks 8193-16384) [INODE_UNINIT]
    Backup superblock at 8193, Group descriptors at 8194-8197
 Pass 1: Checking inodes, blocks, and sizes
diff --git a/tests/t_enable_mcsum_ext3/expect b/tests/t_enable_mcsum_ext3/expect
index 5460482a0d6d..fae36821fea9 100644
--- a/tests/t_enable_mcsum_ext3/expect
+++ b/tests/t_enable_mcsum_ext3/expect
@@ -49,9 +49,9 @@ Change in FS metadata:
    Reserved GDT blocks at 4-259
    Block bitmap at 260 (+259)
 @@ -45,7 +46,7 @@
-   7789 free blocks, 1013 free inodes, 2 directories
+   7789 free blocks, 960 free inodes, 2 directories
    Free blocks: 404-8192
-   Free inodes: 12-1024
+   Free inodes: 65-1024
 -Group 1: (Blocks 8193-16384)
 +Group 1: (Blocks 8193-16384) [ITABLE_ZEROED]
    Backup superblock at 8193, Group descriptors at 8194-8195
diff --git a/tests/t_enable_mcsum_initbg/expect b/tests/t_enable_mcsum_initbg/expect
index d3b444436f84..c13c9785dffd 100644
--- a/tests/t_enable_mcsum_initbg/expect
+++ b/tests/t_enable_mcsum_initbg/expect
@@ -47,7 +47,7 @@ Change in FS metadata:
  Reserved block count:     26214
 -Free blocks:              571
 +Free blocks:              568
- Free inodes:              65048
+ Free inodes:              64995
  First block:              1
  Block size:               1024
 @@ -33,6 +33,7 @@
@@ -69,11 +69,11 @@ Change in FS metadata:
    Block bitmap at 262 (+261)
    Inode bitmap at 278 (+277)
    Inode table at 294-549 (+293)
--  21 free blocks, 536 free inodes, 2 directories
+-  21 free blocks, 483 free inodes, 2 directories
 -  Free blocks: 4413-4433
-+  18 free blocks, 536 free inodes, 2 directories, 536 unused inodes
++  18 free blocks, 483 free inodes, 2 directories, 483 unused inodes
 +  Free blocks: 4413, 4417-4433
-   Free inodes: 489-1024
+   Free inodes: 542-1024
 -Group 1: (Blocks 8193-16384)
 +Group 1: (Blocks 8193-16384) [INODE_UNINIT, ITABLE_ZEROED]
    Backup superblock at 8193, Group descriptors at 8194-8197
diff --git a/tests/t_uninit_bg_rm/expect b/tests/t_uninit_bg_rm/expect
index 61e9eaa88219..ac8b68ee93bf 100644
--- a/tests/t_uninit_bg_rm/expect
+++ b/tests/t_uninit_bg_rm/expect
@@ -7,7 +7,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/65536 files (0.0% non-contiguous), 52294/1048576 blocks
+test_filesys: 64/65536 files (0.0% non-contiguous), 52294/1048576 blocks
  
 mke2fs -q -t ext4 -O bigalloc -F -o Linux -b 1024 -C 8192 test.img 10G
 tune2fs -f -O ^uninit_bg test.img
@@ -18,4 +18,4 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/655360 files (0.0% non-contiguous), 199864/10485760 blocks
+test_filesys: 64/655360 files (0.0% non-contiguous), 199864/10485760 blocks
-- 
2.1.4

