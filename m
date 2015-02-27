From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2fsprogs: Limit number of reserved gdt blocks on small fs
Date: Fri, 27 Feb 2015 18:00:28 +0100
Message-ID: <1425056428-22598-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbbB0RAe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Feb 2015 12:00:34 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1RH0XKU028987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2015 12:00:34 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we're unable to online resize very small (smaller than 32 MB)
file systems with 1k block size because there is not enough space in the
journal to put all the reserved gdt blocks.

I tried to find solution in kernel which does not require to reserve
journal credits for all the gdt blocks, but it looks like we have to
have them all in journal to make sure that we atomically either change
them all, or none.

So it leaves us with fixing the root cause which is the fact that mke2fs
is setup by default so that it creates so many gdt blocks that it can't
fit into the journal transaction.

Fix it by limiting the default number of reserved gdt blocks in the
specific case of 1k bs and fs size < 32M. Note that it's still possible
to create such file system by specifying non-default options so I've
added mke2fs message that would warn users that would try to create such
file system, but will still allow them to do so.

We still need to address the kernel problem where such file system would
generate scary kernel warning, but that's for a separate patch.

Also fix output of some tests, because this change slightly alters the
file system layout (specifically number of free blocks and number of
reserved gdt blocks) on very small file systems.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/initialize.c         |  23 +++
 misc/mke2fs.c                   |  28 +++
 tests/f_create_symlinks/expect  |   8 +-
 tests/f_desc_size_bad/expect.1  |   2 +-
 tests/f_desc_size_bad/expect.2  |   2 +-
 tests/f_resize_inode/expect     |  44 ++---
 tests/m_mkfs_overhead/script    |   2 +-
 tests/r_fixup_lastbg/expect     |  22 +--
 tests/r_fixup_lastbg_big/expect |  26 +--
 tests/r_move_itable/expect      | 404 ++++++++++++++++++++--------------------
 tests/r_resize_inode/expect     |  96 +++++-----
 11 files changed, 354 insertions(+), 303 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 75fbf8e..0ef0e94 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -71,6 +71,29 @@ static unsigned int calc_reserved_gdt_blocks(ext2_filsys fs)
 	 */
 	rsv_groups = ext2fs_div_ceil(max_blocks - sb->s_first_data_block, bpg);
 	rsv_gdb = ext2fs_div_ceil(rsv_groups, gdpb) - fs->desc_blocks;
+
+	/*
+	 * In online resize we require a huge number of journal
+	 * credits mainly because of the reserved_gdt_blocks. The
+	 * exact number of journal credits needed is:
+	 * flex_gd->count * 4 + reserved_gdb
+	 *
+	 * In order to allow online resize on file system with tiny
+	 * journal (tiny fs) we have to make the sure we have to
+	 * make sure reserved_gdt_blocks is small enough. If the user
+	 * specifies non-default values he can still run into this issue
+	 * but we do not want to make that mistake by default.
+	 *
+	 * Magic numbers:
+	 * - At block count smaller than 32768, journal will be 1024 block
+	 *   blocks long which would not be enough by default.
+	 * - 64 reserved gtd blocks is maximum number we can fit into said
+	 *   journal by default (flex_bg_count * 4 + rsv_gdb)
+	 */
+	if ((fs->blocksize == 1024) && (ext2fs_blocks_count(sb) < 32768) &&
+	    (rsv_gdb > 64))
+		rsv_gdb = 64;
+
 	if (rsv_gdb > EXT2_ADDR_PER_BLOCK(sb))
 		rsv_gdb = EXT2_ADDR_PER_BLOCK(sb);
 #ifdef RES_GDT_DEBUG
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index aeb852f..e9edd3b 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -3076,6 +3076,34 @@ int main (int argc, char *argv[])
 		}
 		if (!quiet)
 			printf("%s", _("done\n"));
+
+		/*
+		 * In online resize we require a huge number of journal
+		 * credits mainly because of the reserved_gdt_blocks. The
+		 * exact number of journal credits needed is:
+		 * flex_gd->count * 4 + reserved_gdb
+		 *
+		 * Warn user if we will not have enough credits to resize
+		 * the file system online.
+		 */
+		if (fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE)
+		{
+			unsigned int credits;
+
+			/*
+			* This is the amount we're allowed to use for a
+			* single handle in a transaction
+			*/
+			journal_blocks /= 8;
+			credits = (1 << fs_param.s_log_groups_per_flex) * 4 +
+				  fs->super->s_reserved_gdt_blocks;
+			if (credits > journal_blocks) {
+				fprintf(stderr, "%s", _("Warning: Journal is "
+					"not big enough. In this configuration "
+					"the file system will not be able to "
+					"grow online!\n"));
+			}
+		}
 	}
 no_journal:
 	if (!super_only &&
diff --git a/tests/f_create_symlinks/expect b/tests/f_create_symlinks/expect
index 096495c..e6c7bdd 100644
--- a/tests/f_create_symlinks/expect
+++ b/tests/f_create_symlinks/expect
@@ -4,7 +4,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/128 files (0.0% non-contiguous), 441/1024 blocks
+test_filesys: 11/128 files (0.0% non-contiguous), 252/1024 blocks
 Exit status is 0
 debugfs -R "symlink /l_30 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
 debugfs -R "symlink /l_70 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
@@ -45,7 +45,7 @@ Links: 1   Blockcount: 2
 Fragment:  Address: 0    Number: 0    Size: 0
 Size of extra inode fields: 28
 EXTENTS:
-(0):153
+(0):90
 debugfs -R "stat /l_1023" test.img
 Inode: 15   Type: symlink    Mode:  0777   Flags: 0x80000
 Generation: 0    Version: 0x00000000:00000000
@@ -55,7 +55,7 @@ Links: 1   Blockcount: 2
 Fragment:  Address: 0    Number: 0    Size: 0
 Size of extra inode fields: 28
 EXTENTS:
-(0):154
+(0):91
 debugfs -R "stat /l_1024" test.img
 /l_1024: File not found by ext2_lookup 
 debugfs -R "stat /l_1500" test.img
@@ -65,5 +65,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 15/128 files (0.0% non-contiguous), 443/1024 blocks
+test_filesys: 15/128 files (0.0% non-contiguous), 254/1024 blocks
 Exit status is 0
diff --git a/tests/f_desc_size_bad/expect.1 b/tests/f_desc_size_bad/expect.1
index 009ee04..dd461a0 100644
--- a/tests/f_desc_size_bad/expect.1
+++ b/tests/f_desc_size_bad/expect.1
@@ -7,5 +7,5 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/32 files (0.0% non-contiguous), 801/2048 blocks
+test_filesys: 11/32 files (0.0% non-contiguous), 225/2048 blocks
 Exit status is 1
diff --git a/tests/f_desc_size_bad/expect.2 b/tests/f_desc_size_bad/expect.2
index d1429fd..604869f 100644
--- a/tests/f_desc_size_bad/expect.2
+++ b/tests/f_desc_size_bad/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32 files (0.0% non-contiguous), 801/2048 blocks
+test_filesys: 11/32 files (0.0% non-contiguous), 225/2048 blocks
 Exit status is 0
diff --git a/tests/f_resize_inode/expect b/tests/f_resize_inode/expect
index db57ed6..2be54a2 100644
--- a/tests/f_resize_inode/expect
+++ b/tests/f_resize_inode/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 955/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -25,22 +25,22 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Free blocks count wrong for group #0 (717, counted=718).
+Free blocks count wrong for group #0 (909, counted=910).
 Fix? yes
 
-Free blocks count wrong (14276, counted=14277).
+Free blocks count wrong (15428, counted=15429).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 955/16384 blocks
 Exit status is 1
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 955/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -53,22 +53,22 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Free blocks count wrong for group #0 (717, counted=718).
+Free blocks count wrong for group #0 (909, counted=910).
 Fix? yes
 
-Free blocks count wrong (14276, counted=14277).
+Free blocks count wrong (15428, counted=15429).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 955/16384 blocks
 Exit status is 1
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 955/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -81,22 +81,22 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Free blocks count wrong for group #0 (717, counted=718).
+Free blocks count wrong for group #0 (909, counted=910).
 Fix? yes
 
-Free blocks count wrong (14276, counted=14277).
+Free blocks count wrong (15428, counted=15429).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 955/16384 blocks
 Exit status is 1
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 955/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -111,7 +111,7 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 955/16384 blocks
 Exit status is 1
 -----------------------------------------------
  
@@ -122,28 +122,28 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Block bitmap differences:  -(35--258) -(1059--1282) -(3107--3330) -(5155--5378) -(7203--7426) -(9251--9474)
+Block bitmap differences:  -(35--66) -(1059--1090) -(3107--3138) -(5155--5186) -(7203--7234) -(9251--9282)
 Fix? yes
 
-Free blocks count wrong for group #0 (718, counted=942).
+Free blocks count wrong for group #0 (910, counted=942).
 Fix? yes
 
-Free blocks count wrong for group #1 (732, counted=956).
+Free blocks count wrong for group #1 (924, counted=956).
 Fix? yes
 
-Free blocks count wrong for group #3 (732, counted=956).
+Free blocks count wrong for group #3 (924, counted=956).
 Fix? yes
 
-Free blocks count wrong for group #5 (732, counted=956).
+Free blocks count wrong for group #5 (924, counted=956).
 Fix? yes
 
-Free blocks count wrong for group #7 (732, counted=956).
+Free blocks count wrong for group #7 (924, counted=956).
 Fix? yes
 
-Free blocks count wrong for group #9 (732, counted=956).
+Free blocks count wrong for group #9 (924, counted=956).
 Fix? yes
 
-Free blocks count wrong (14277, counted=15621).
+Free blocks count wrong (15429, counted=15621).
 Fix? yes
 
 
diff --git a/tests/m_mkfs_overhead/script b/tests/m_mkfs_overhead/script
index c21da0c..e19e67e 100644
--- a/tests/m_mkfs_overhead/script
+++ b/tests/m_mkfs_overhead/script
@@ -3,7 +3,7 @@ test_description="test bg overhead calculation"
 OUT=$test_name.log
 EXP=$test_dir/expect
 FS_SIZE=1024
-MKE2FS_OPTS="-b 1024 -m 0 -g 256 -N 3745"
+MKE2FS_OPTS="-b 1024 -m 0 -g 256 -N 4513"
 
 MKE2FS_SKIP_PROGRESS=true
 MKE2FS_SKIP_CHECK_MSG=true
diff --git a/tests/r_fixup_lastbg/expect b/tests/r_fixup_lastbg/expect
index 96b154a..6514328 100644
--- a/tests/r_fixup_lastbg/expect
+++ b/tests/r_fixup_lastbg/expect
@@ -8,16 +8,16 @@ Creating journal (1024 blocks): done
 Writing superblocks and filesystem accounting information:    done
 
 Group 2: (Blocks 16385-19999) [INODE_UNINIT, ITABLE_ZEROED]
-  Block bitmap at 83 (bg #0 + 82)
-  Inode bitmap at 86 (bg #0 + 85)
-  Inode table at 295-398 (bg #0 + 294)
+  Block bitmap at 69 (bg #0 + 68)
+  Inode bitmap at 72 (bg #0 + 71)
+  Inode table at 281-384 (bg #0 + 280)
   3615 free blocks, 416 free inodes, 0 directories, 416 unused inodes
   Free blocks: 16385-19999
   Free inodes: 833-1248
-Group 2: (Blocks 16385-19999)
-  Block bitmap at 83 (bg #0 + 82)
-  Inode bitmap at 86 (bg #0 + 85)
-  Inode table at 295-398 (bg #0 + 294)
+Group 2: (Blocks 16385-19999) (EXPECTED 0xe815)
+  Block bitmap at 69 (bg #0 + 68)
+  Inode bitmap at 72 (bg #0 + 71)
+  Inode table at 281-384 (bg #0 + 280)
   3615 free blocks, 416 free inodes, 0 directories
   Free blocks: 16385-19999
   Free inodes: 833-1248
@@ -25,9 +25,9 @@ Resizing the filesystem on test.img to 20004 (1k) blocks.
 The filesystem on test.img is now 20004 (1k) blocks long.
 
 Group 2: (Blocks 16385-20003) [INODE_UNINIT]
-  Block bitmap at 83 (bg #0 + 82)
-  Inode bitmap at 86 (bg #0 + 85)
-  Inode table at 295-398 (bg #0 + 294)
+  Block bitmap at 69 (bg #0 + 68)
+  Inode bitmap at 72 (bg #0 + 71)
+  Inode table at 281-384 (bg #0 + 280)
   3619 free blocks, 416 free inodes, 0 directories, 416 unused inodes
   Free blocks: 16385-20003
   Free inodes: 833-1248
@@ -36,4 +36,4 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test.img: 11/1248 files (0.0% non-contiguous), 1517/20004 blocks
+test.img: 11/1248 files (0.0% non-contiguous), 1489/20004 blocks
diff --git a/tests/r_fixup_lastbg_big/expect b/tests/r_fixup_lastbg_big/expect
index edaabaf..3e87acf 100644
--- a/tests/r_fixup_lastbg_big/expect
+++ b/tests/r_fixup_lastbg_big/expect
@@ -8,16 +8,16 @@ Creating journal (1024 blocks): done
 Writing superblocks and filesystem accounting information:    done
 
 Group 2: (Blocks 16385-19999) [INODE_UNINIT, ITABLE_ZEROED]
-  Block bitmap at 83 (bg #0 + 82)
-  Inode bitmap at 86 (bg #0 + 85)
-  Inode table at 295-398 (bg #0 + 294)
+  Block bitmap at 69 (bg #0 + 68)
+  Inode bitmap at 72 (bg #0 + 71)
+  Inode table at 281-384 (bg #0 + 280)
   3615 free blocks, 416 free inodes, 0 directories, 416 unused inodes
   Free blocks: 16385-19999
   Free inodes: 833-1248
-Group 2: (Blocks 16385-19999)
-  Block bitmap at 83 (bg #0 + 82)
-  Inode bitmap at 86 (bg #0 + 85)
-  Inode table at 295-398 (bg #0 + 294)
+Group 2: (Blocks 16385-19999) (EXPECTED 0xe815)
+  Block bitmap at 69 (bg #0 + 68)
+  Inode bitmap at 72 (bg #0 + 71)
+  Inode table at 281-384 (bg #0 + 280)
   3615 free blocks, 416 free inodes, 0 directories
   Free blocks: 16385-19999
   Free inodes: 833-1248
@@ -27,19 +27,19 @@ Extending the inode table     ----------------------------------------
 The filesystem on test.img is now 40000 (1k) blocks long.
 
 Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT]
-  Block bitmap at 83 (bg #0 + 82)
-  Inode bitmap at 86 (bg #0 + 85)
-  Inode table at 295-398 (bg #0 + 294)
+  Block bitmap at 69 (bg #0 + 68)
+  Inode bitmap at 72 (bg #0 + 71)
+  Inode table at 281-384 (bg #0 + 280)
   8192 free blocks, 416 free inodes, 0 directories, 416 unused inodes
   Free blocks: 16385-24576
   Free inodes: 833-1248
 Group 3: (Blocks 24577-32768) [INODE_UNINIT, ITABLE_ZEROED]
   Backup superblock at 24577, Group descriptors at 24578-24578
-  Reserved GDT blocks at 24579-24656
-  Block bitmap at 413 (bg #0 + 412)
+  Reserved GDT blocks at 24579-24642
+  Block bitmap at 399 (bg #0 + 398)
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test.img: 11/2080 files (0.0% non-contiguous), 1809/40000 blocks
+test.img: 11/2080 files (0.0% non-contiguous), 1767/40000 blocks
diff --git a/tests/r_move_itable/expect b/tests/r_move_itable/expect
index cec0038..0f7b892 100644
--- a/tests/r_move_itable/expect
+++ b/tests/r_move_itable/expect
@@ -10,7 +10,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/1248 files (0.0% non-contiguous), 1281/9985 blocks
+test_filesys: 11/1248 files (0.0% non-contiguous), 777/9985 blocks
 Exit status is 0
 dumpe2fs test.img
 Filesystem volume name:   <none>
@@ -25,12 +25,12 @@ Filesystem OS type:       Linux
 Inode count:              1248
 Block count:              9985
 Reserved block count:     497
-Free blocks:              8704
+Free blocks:              9208
 Free inodes:              1237
 First block:              1
 Block size:               1024
 Fragment size:            1024
-Reserved GDT blocks:      126
+Reserved GDT blocks:      63
 Blocks per group:         256
 Fragments per group:      256
 Inodes per group:         32
@@ -46,19 +46,19 @@ Default directory hash:   half_md4
 
 Group 0: (Blocks 1-256)
   Primary superblock at 1, Group descriptors at 2-3
-  Reserved GDT blocks at 4-129
-  Block bitmap at 130 (+129), Inode bitmap at 131 (+130)
-  Inode table at 132-135 (+131)
-  107 free blocks, 21 free inodes, 2 directories
-  Free blocks: 150-256
+  Reserved GDT blocks at 4-66
+  Block bitmap at 67 (+66), Inode bitmap at 68 (+67)
+  Inode table at 69-72 (+68)
+  170 free blocks, 21 free inodes, 2 directories
+  Free blocks: 87-256
   Free inodes: 12-32
 Group 1: (Blocks 257-512)
   Backup superblock at 257, Group descriptors at 258-259
-  Reserved GDT blocks at 260-385
-  Block bitmap at 386 (+129), Inode bitmap at 387 (+130)
-  Inode table at 388-391 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 392-512
+  Reserved GDT blocks at 260-322
+  Block bitmap at 323 (+66), Inode bitmap at 324 (+67)
+  Inode table at 325-328 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 329-512
   Free inodes: 33-64
 Group 2: (Blocks 513-768)
   Block bitmap at 513 (+0), Inode bitmap at 514 (+1)
@@ -68,11 +68,11 @@ Group 2: (Blocks 513-768)
   Free inodes: 65-96
 Group 3: (Blocks 769-1024)
   Backup superblock at 769, Group descriptors at 770-771
-  Reserved GDT blocks at 772-897
-  Block bitmap at 898 (+129), Inode bitmap at 899 (+130)
-  Inode table at 900-903 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 904-1024
+  Reserved GDT blocks at 772-834
+  Block bitmap at 835 (+66), Inode bitmap at 836 (+67)
+  Inode table at 837-840 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 841-1024
   Free inodes: 97-128
 Group 4: (Blocks 1025-1280)
   Block bitmap at 1025 (+0), Inode bitmap at 1026 (+1)
@@ -82,11 +82,11 @@ Group 4: (Blocks 1025-1280)
   Free inodes: 129-160
 Group 5: (Blocks 1281-1536)
   Backup superblock at 1281, Group descriptors at 1282-1283
-  Reserved GDT blocks at 1284-1409
-  Block bitmap at 1410 (+129), Inode bitmap at 1411 (+130)
-  Inode table at 1412-1415 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 1416-1536
+  Reserved GDT blocks at 1284-1346
+  Block bitmap at 1347 (+66), Inode bitmap at 1348 (+67)
+  Inode table at 1349-1352 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 1353-1536
   Free inodes: 161-192
 Group 6: (Blocks 1537-1792)
   Block bitmap at 1537 (+0), Inode bitmap at 1538 (+1)
@@ -96,11 +96,11 @@ Group 6: (Blocks 1537-1792)
   Free inodes: 193-224
 Group 7: (Blocks 1793-2048)
   Backup superblock at 1793, Group descriptors at 1794-1795
-  Reserved GDT blocks at 1796-1921
-  Block bitmap at 1922 (+129), Inode bitmap at 1923 (+130)
-  Inode table at 1924-1927 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 1928-2048
+  Reserved GDT blocks at 1796-1858
+  Block bitmap at 1859 (+66), Inode bitmap at 1860 (+67)
+  Inode table at 1861-1864 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 1865-2048
   Free inodes: 225-256
 Group 8: (Blocks 2049-2304)
   Block bitmap at 2049 (+0), Inode bitmap at 2050 (+1)
@@ -110,11 +110,11 @@ Group 8: (Blocks 2049-2304)
   Free inodes: 257-288
 Group 9: (Blocks 2305-2560)
   Backup superblock at 2305, Group descriptors at 2306-2307
-  Reserved GDT blocks at 2308-2433
-  Block bitmap at 2434 (+129), Inode bitmap at 2435 (+130)
-  Inode table at 2436-2439 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 2440-2560
+  Reserved GDT blocks at 2308-2370
+  Block bitmap at 2371 (+66), Inode bitmap at 2372 (+67)
+  Inode table at 2373-2376 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 2377-2560
   Free inodes: 289-320
 Group 10: (Blocks 2561-2816)
   Block bitmap at 2561 (+0), Inode bitmap at 2562 (+1)
@@ -208,11 +208,11 @@ Group 24: (Blocks 6145-6400)
   Free inodes: 769-800
 Group 25: (Blocks 6401-6656)
   Backup superblock at 6401, Group descriptors at 6402-6403
-  Reserved GDT blocks at 6404-6529
-  Block bitmap at 6530 (+129), Inode bitmap at 6531 (+130)
-  Inode table at 6532-6535 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 6536-6656
+  Reserved GDT blocks at 6404-6466
+  Block bitmap at 6467 (+66), Inode bitmap at 6468 (+67)
+  Inode table at 6469-6472 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 6473-6656
   Free inodes: 801-832
 Group 26: (Blocks 6657-6912)
   Block bitmap at 6657 (+0), Inode bitmap at 6658 (+1)
@@ -222,11 +222,11 @@ Group 26: (Blocks 6657-6912)
   Free inodes: 833-864
 Group 27: (Blocks 6913-7168)
   Backup superblock at 6913, Group descriptors at 6914-6915
-  Reserved GDT blocks at 6916-7041
-  Block bitmap at 7042 (+129), Inode bitmap at 7043 (+130)
-  Inode table at 7044-7047 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 7048-7168
+  Reserved GDT blocks at 6916-6978
+  Block bitmap at 6979 (+66), Inode bitmap at 6980 (+67)
+  Inode table at 6981-6984 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 6985-7168
   Free inodes: 865-896
 Group 28: (Blocks 7169-7424)
   Block bitmap at 7169 (+0), Inode bitmap at 7170 (+1)
@@ -308,7 +308,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/2496 files (0.0% non-contiguous), 1644/19969 blocks
+test_filesys: 11/2496 files (0.0% non-contiguous), 1077/19969 blocks
 Exit status is 0
 dumpe2fs test.img
 Filesystem volume name:   <none>
@@ -323,12 +323,12 @@ Filesystem OS type:       Linux
 Inode count:              2496
 Block count:              19969
 Reserved block count:     993
-Free blocks:              18325
+Free blocks:              18892
 Free inodes:              2485
 First block:              1
 Block size:               1024
 Fragment size:            1024
-Reserved GDT blocks:      125
+Reserved GDT blocks:      62
 Blocks per group:         256
 Fragments per group:      256
 Inodes per group:         32
@@ -344,19 +344,19 @@ Default directory hash:   half_md4
 
 Group 0: (Blocks 1-256)
   Primary superblock at 1, Group descriptors at 2-4
-  Reserved GDT blocks at 5-129
-  Block bitmap at 130 (+129), Inode bitmap at 131 (+130)
-  Inode table at 132-135 (+131)
-  107 free blocks, 21 free inodes, 2 directories
-  Free blocks: 150-256
+  Reserved GDT blocks at 5-66
+  Block bitmap at 67 (+66), Inode bitmap at 68 (+67)
+  Inode table at 69-72 (+68)
+  170 free blocks, 21 free inodes, 2 directories
+  Free blocks: 87-256
   Free inodes: 12-32
 Group 1: (Blocks 257-512)
   Backup superblock at 257, Group descriptors at 258-260
-  Reserved GDT blocks at 261-385
-  Block bitmap at 386 (+129), Inode bitmap at 387 (+130)
-  Inode table at 388-391 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 392-512
+  Reserved GDT blocks at 261-322
+  Block bitmap at 323 (+66), Inode bitmap at 324 (+67)
+  Inode table at 325-328 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 329-512
   Free inodes: 33-64
 Group 2: (Blocks 513-768)
   Block bitmap at 513 (+0), Inode bitmap at 514 (+1)
@@ -366,11 +366,11 @@ Group 2: (Blocks 513-768)
   Free inodes: 65-96
 Group 3: (Blocks 769-1024)
   Backup superblock at 769, Group descriptors at 770-772
-  Reserved GDT blocks at 773-897
-  Block bitmap at 898 (+129), Inode bitmap at 899 (+130)
-  Inode table at 900-903 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 904-1024
+  Reserved GDT blocks at 773-834
+  Block bitmap at 835 (+66), Inode bitmap at 836 (+67)
+  Inode table at 837-840 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 841-1024
   Free inodes: 97-128
 Group 4: (Blocks 1025-1280)
   Block bitmap at 1025 (+0), Inode bitmap at 1026 (+1)
@@ -380,11 +380,11 @@ Group 4: (Blocks 1025-1280)
   Free inodes: 129-160
 Group 5: (Blocks 1281-1536)
   Backup superblock at 1281, Group descriptors at 1282-1284
-  Reserved GDT blocks at 1285-1409
-  Block bitmap at 1410 (+129), Inode bitmap at 1411 (+130)
-  Inode table at 1412-1415 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 1416-1536
+  Reserved GDT blocks at 1285-1346
+  Block bitmap at 1347 (+66), Inode bitmap at 1348 (+67)
+  Inode table at 1349-1352 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 1353-1536
   Free inodes: 161-192
 Group 6: (Blocks 1537-1792)
   Block bitmap at 1537 (+0), Inode bitmap at 1538 (+1)
@@ -394,11 +394,11 @@ Group 6: (Blocks 1537-1792)
   Free inodes: 193-224
 Group 7: (Blocks 1793-2048)
   Backup superblock at 1793, Group descriptors at 1794-1796
-  Reserved GDT blocks at 1797-1921
-  Block bitmap at 1922 (+129), Inode bitmap at 1923 (+130)
-  Inode table at 1924-1927 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 1928-2048
+  Reserved GDT blocks at 1797-1858
+  Block bitmap at 1859 (+66), Inode bitmap at 1860 (+67)
+  Inode table at 1861-1864 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 1865-2048
   Free inodes: 225-256
 Group 8: (Blocks 2049-2304)
   Block bitmap at 2049 (+0), Inode bitmap at 2050 (+1)
@@ -408,11 +408,11 @@ Group 8: (Blocks 2049-2304)
   Free inodes: 257-288
 Group 9: (Blocks 2305-2560)
   Backup superblock at 2305, Group descriptors at 2306-2308
-  Reserved GDT blocks at 2309-2433
-  Block bitmap at 2434 (+129), Inode bitmap at 2435 (+130)
-  Inode table at 2436-2439 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 2440-2560
+  Reserved GDT blocks at 2309-2370
+  Block bitmap at 2371 (+66), Inode bitmap at 2372 (+67)
+  Inode table at 2373-2376 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 2377-2560
   Free inodes: 289-320
 Group 10: (Blocks 2561-2816)
   Block bitmap at 2561 (+0), Inode bitmap at 2562 (+1)
@@ -506,11 +506,11 @@ Group 24: (Blocks 6145-6400)
   Free inodes: 769-800
 Group 25: (Blocks 6401-6656)
   Backup superblock at 6401, Group descriptors at 6402-6404
-  Reserved GDT blocks at 6405-6529
-  Block bitmap at 6530 (+129), Inode bitmap at 6531 (+130)
-  Inode table at 6532-6535 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 6536-6656
+  Reserved GDT blocks at 6405-6466
+  Block bitmap at 6467 (+66), Inode bitmap at 6468 (+67)
+  Inode table at 6469-6472 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 6473-6656
   Free inodes: 801-832
 Group 26: (Blocks 6657-6912)
   Block bitmap at 6657 (+0), Inode bitmap at 6658 (+1)
@@ -520,11 +520,11 @@ Group 26: (Blocks 6657-6912)
   Free inodes: 833-864
 Group 27: (Blocks 6913-7168)
   Backup superblock at 6913, Group descriptors at 6914-6916
-  Reserved GDT blocks at 6917-7041
-  Block bitmap at 7042 (+129), Inode bitmap at 7043 (+130)
-  Inode table at 7044-7047 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 7048-7168
+  Reserved GDT blocks at 6917-6978
+  Block bitmap at 6979 (+66), Inode bitmap at 6980 (+67)
+  Inode table at 6981-6984 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 6985-7168
   Free inodes: 865-896
 Group 28: (Blocks 7169-7424)
   Block bitmap at 7169 (+0), Inode bitmap at 7170 (+1)
@@ -654,11 +654,11 @@ Group 48: (Blocks 12289-12544)
   Free inodes: 1537-1568
 Group 49: (Blocks 12545-12800)
   Backup superblock at 12545, Group descriptors at 12546-12548
-  Reserved GDT blocks at 12549-12673
-  Block bitmap at 12674 (+129), Inode bitmap at 12675 (+130)
-  Inode table at 12676-12679 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 12680-12800
+  Reserved GDT blocks at 12549-12610
+  Block bitmap at 12611 (+66), Inode bitmap at 12612 (+67)
+  Inode table at 12613-12616 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 12617-12800
   Free inodes: 1569-1600
 Group 50: (Blocks 12801-13056)
   Block bitmap at 12801 (+0), Inode bitmap at 12802 (+1)
@@ -842,7 +842,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/3744 files (0.0% non-contiguous), 2007/29953 blocks
+test_filesys: 11/3744 files (0.0% non-contiguous), 1377/29953 blocks
 Exit status is 0
 dumpe2fs test.img
 Filesystem volume name:   <none>
@@ -857,12 +857,12 @@ Filesystem OS type:       Linux
 Inode count:              3744
 Block count:              29953
 Reserved block count:     1489
-Free blocks:              27946
+Free blocks:              28576
 Free inodes:              3733
 First block:              1
 Block size:               1024
 Fragment size:            1024
-Reserved GDT blocks:      124
+Reserved GDT blocks:      61
 Blocks per group:         256
 Fragments per group:      256
 Inodes per group:         32
@@ -878,19 +878,19 @@ Default directory hash:   half_md4
 
 Group 0: (Blocks 1-256)
   Primary superblock at 1, Group descriptors at 2-5
-  Reserved GDT blocks at 6-129
-  Block bitmap at 130 (+129), Inode bitmap at 131 (+130)
-  Inode table at 132-135 (+131)
-  107 free blocks, 21 free inodes, 2 directories
-  Free blocks: 150-256
+  Reserved GDT blocks at 6-66
+  Block bitmap at 67 (+66), Inode bitmap at 68 (+67)
+  Inode table at 69-72 (+68)
+  170 free blocks, 21 free inodes, 2 directories
+  Free blocks: 87-256
   Free inodes: 12-32
 Group 1: (Blocks 257-512)
   Backup superblock at 257, Group descriptors at 258-261
-  Reserved GDT blocks at 262-385
-  Block bitmap at 386 (+129), Inode bitmap at 387 (+130)
-  Inode table at 388-391 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 392-512
+  Reserved GDT blocks at 262-322
+  Block bitmap at 323 (+66), Inode bitmap at 324 (+67)
+  Inode table at 325-328 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 329-512
   Free inodes: 33-64
 Group 2: (Blocks 513-768)
   Block bitmap at 513 (+0), Inode bitmap at 514 (+1)
@@ -900,11 +900,11 @@ Group 2: (Blocks 513-768)
   Free inodes: 65-96
 Group 3: (Blocks 769-1024)
   Backup superblock at 769, Group descriptors at 770-773
-  Reserved GDT blocks at 774-897
-  Block bitmap at 898 (+129), Inode bitmap at 899 (+130)
-  Inode table at 900-903 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 904-1024
+  Reserved GDT blocks at 774-834
+  Block bitmap at 835 (+66), Inode bitmap at 836 (+67)
+  Inode table at 837-840 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 841-1024
   Free inodes: 97-128
 Group 4: (Blocks 1025-1280)
   Block bitmap at 1025 (+0), Inode bitmap at 1026 (+1)
@@ -914,11 +914,11 @@ Group 4: (Blocks 1025-1280)
   Free inodes: 129-160
 Group 5: (Blocks 1281-1536)
   Backup superblock at 1281, Group descriptors at 1282-1285
-  Reserved GDT blocks at 1286-1409
-  Block bitmap at 1410 (+129), Inode bitmap at 1411 (+130)
-  Inode table at 1412-1415 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 1416-1536
+  Reserved GDT blocks at 1286-1346
+  Block bitmap at 1347 (+66), Inode bitmap at 1348 (+67)
+  Inode table at 1349-1352 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 1353-1536
   Free inodes: 161-192
 Group 6: (Blocks 1537-1792)
   Block bitmap at 1537 (+0), Inode bitmap at 1538 (+1)
@@ -928,11 +928,11 @@ Group 6: (Blocks 1537-1792)
   Free inodes: 193-224
 Group 7: (Blocks 1793-2048)
   Backup superblock at 1793, Group descriptors at 1794-1797
-  Reserved GDT blocks at 1798-1921
-  Block bitmap at 1922 (+129), Inode bitmap at 1923 (+130)
-  Inode table at 1924-1927 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 1928-2048
+  Reserved GDT blocks at 1798-1858
+  Block bitmap at 1859 (+66), Inode bitmap at 1860 (+67)
+  Inode table at 1861-1864 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 1865-2048
   Free inodes: 225-256
 Group 8: (Blocks 2049-2304)
   Block bitmap at 2049 (+0), Inode bitmap at 2050 (+1)
@@ -942,11 +942,11 @@ Group 8: (Blocks 2049-2304)
   Free inodes: 257-288
 Group 9: (Blocks 2305-2560)
   Backup superblock at 2305, Group descriptors at 2306-2309
-  Reserved GDT blocks at 2310-2433
-  Block bitmap at 2434 (+129), Inode bitmap at 2435 (+130)
-  Inode table at 2436-2439 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 2440-2560
+  Reserved GDT blocks at 2310-2370
+  Block bitmap at 2371 (+66), Inode bitmap at 2372 (+67)
+  Inode table at 2373-2376 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 2377-2560
   Free inodes: 289-320
 Group 10: (Blocks 2561-2816)
   Block bitmap at 2561 (+0), Inode bitmap at 2562 (+1)
@@ -1040,11 +1040,11 @@ Group 24: (Blocks 6145-6400)
   Free inodes: 769-800
 Group 25: (Blocks 6401-6656)
   Backup superblock at 6401, Group descriptors at 6402-6405
-  Reserved GDT blocks at 6406-6529
-  Block bitmap at 6530 (+129), Inode bitmap at 6531 (+130)
-  Inode table at 6532-6535 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 6536-6656
+  Reserved GDT blocks at 6406-6466
+  Block bitmap at 6467 (+66), Inode bitmap at 6468 (+67)
+  Inode table at 6469-6472 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 6473-6656
   Free inodes: 801-832
 Group 26: (Blocks 6657-6912)
   Block bitmap at 6657 (+0), Inode bitmap at 6658 (+1)
@@ -1054,11 +1054,11 @@ Group 26: (Blocks 6657-6912)
   Free inodes: 833-864
 Group 27: (Blocks 6913-7168)
   Backup superblock at 6913, Group descriptors at 6914-6917
-  Reserved GDT blocks at 6918-7041
-  Block bitmap at 7042 (+129), Inode bitmap at 7043 (+130)
-  Inode table at 7044-7047 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 7048-7168
+  Reserved GDT blocks at 6918-6978
+  Block bitmap at 6979 (+66), Inode bitmap at 6980 (+67)
+  Inode table at 6981-6984 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 6985-7168
   Free inodes: 865-896
 Group 28: (Blocks 7169-7424)
   Block bitmap at 7169 (+0), Inode bitmap at 7170 (+1)
@@ -1188,11 +1188,11 @@ Group 48: (Blocks 12289-12544)
   Free inodes: 1537-1568
 Group 49: (Blocks 12545-12800)
   Backup superblock at 12545, Group descriptors at 12546-12549
-  Reserved GDT blocks at 12550-12673
-  Block bitmap at 12674 (+129), Inode bitmap at 12675 (+130)
-  Inode table at 12676-12679 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 12680-12800
+  Reserved GDT blocks at 12550-12610
+  Block bitmap at 12611 (+66), Inode bitmap at 12612 (+67)
+  Inode table at 12613-12616 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 12617-12800
   Free inodes: 1569-1600
 Group 50: (Blocks 12801-13056)
   Block bitmap at 12801 (+0), Inode bitmap at 12802 (+1)
@@ -1382,11 +1382,11 @@ Group 80: (Blocks 20481-20736)
   Free inodes: 2561-2592
 Group 81: (Blocks 20737-20992)
   Backup superblock at 20737, Group descriptors at 20738-20741
-  Reserved GDT blocks at 20742-20865
-  Block bitmap at 20866 (+129), Inode bitmap at 20867 (+130)
-  Inode table at 20868-20871 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 20872-20992
+  Reserved GDT blocks at 20742-20802
+  Block bitmap at 20803 (+66), Inode bitmap at 20804 (+67)
+  Inode table at 20805-20808 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 20809-20992
   Free inodes: 2593-2624
 Group 82: (Blocks 20993-21248)
   Block bitmap at 20993 (+0), Inode bitmap at 20994 (+1)
@@ -1612,7 +1612,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/5024 files (0.0% non-contiguous), 2376/40000 blocks
+test_filesys: 11/5024 files (0.0% non-contiguous), 1683/40000 blocks
 Exit status is 0
 dumpe2fs test.img
 Filesystem volume name:   <none>
@@ -1627,12 +1627,12 @@ Filesystem OS type:       Linux
 Inode count:              5024
 Block count:              40000
 Reserved block count:     1988
-Free blocks:              37624
+Free blocks:              38317
 Free inodes:              5013
 First block:              1
 Block size:               1024
 Fragment size:            1024
-Reserved GDT blocks:      123
+Reserved GDT blocks:      60
 Blocks per group:         256
 Fragments per group:      256
 Inodes per group:         32
@@ -1648,19 +1648,19 @@ Default directory hash:   half_md4
 
 Group 0: (Blocks 1-256)
   Primary superblock at 1, Group descriptors at 2-6
-  Reserved GDT blocks at 7-129
-  Block bitmap at 130 (+129), Inode bitmap at 131 (+130)
-  Inode table at 132-135 (+131)
-  107 free blocks, 21 free inodes, 2 directories
-  Free blocks: 150-256
+  Reserved GDT blocks at 7-66
+  Block bitmap at 67 (+66), Inode bitmap at 68 (+67)
+  Inode table at 69-72 (+68)
+  170 free blocks, 21 free inodes, 2 directories
+  Free blocks: 87-256
   Free inodes: 12-32
 Group 1: (Blocks 257-512)
   Backup superblock at 257, Group descriptors at 258-262
-  Reserved GDT blocks at 263-385
-  Block bitmap at 386 (+129), Inode bitmap at 387 (+130)
-  Inode table at 388-391 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 392-512
+  Reserved GDT blocks at 263-322
+  Block bitmap at 323 (+66), Inode bitmap at 324 (+67)
+  Inode table at 325-328 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 329-512
   Free inodes: 33-64
 Group 2: (Blocks 513-768)
   Block bitmap at 513 (+0), Inode bitmap at 514 (+1)
@@ -1670,11 +1670,11 @@ Group 2: (Blocks 513-768)
   Free inodes: 65-96
 Group 3: (Blocks 769-1024)
   Backup superblock at 769, Group descriptors at 770-774
-  Reserved GDT blocks at 775-897
-  Block bitmap at 898 (+129), Inode bitmap at 899 (+130)
-  Inode table at 900-903 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 904-1024
+  Reserved GDT blocks at 775-834
+  Block bitmap at 835 (+66), Inode bitmap at 836 (+67)
+  Inode table at 837-840 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 841-1024
   Free inodes: 97-128
 Group 4: (Blocks 1025-1280)
   Block bitmap at 1025 (+0), Inode bitmap at 1026 (+1)
@@ -1684,11 +1684,11 @@ Group 4: (Blocks 1025-1280)
   Free inodes: 129-160
 Group 5: (Blocks 1281-1536)
   Backup superblock at 1281, Group descriptors at 1282-1286
-  Reserved GDT blocks at 1287-1409
-  Block bitmap at 1410 (+129), Inode bitmap at 1411 (+130)
-  Inode table at 1412-1415 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 1416-1536
+  Reserved GDT blocks at 1287-1346
+  Block bitmap at 1347 (+66), Inode bitmap at 1348 (+67)
+  Inode table at 1349-1352 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 1353-1536
   Free inodes: 161-192
 Group 6: (Blocks 1537-1792)
   Block bitmap at 1537 (+0), Inode bitmap at 1538 (+1)
@@ -1698,11 +1698,11 @@ Group 6: (Blocks 1537-1792)
   Free inodes: 193-224
 Group 7: (Blocks 1793-2048)
   Backup superblock at 1793, Group descriptors at 1794-1798
-  Reserved GDT blocks at 1799-1921
-  Block bitmap at 1922 (+129), Inode bitmap at 1923 (+130)
-  Inode table at 1924-1927 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 1928-2048
+  Reserved GDT blocks at 1799-1858
+  Block bitmap at 1859 (+66), Inode bitmap at 1860 (+67)
+  Inode table at 1861-1864 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 1865-2048
   Free inodes: 225-256
 Group 8: (Blocks 2049-2304)
   Block bitmap at 2049 (+0), Inode bitmap at 2050 (+1)
@@ -1712,11 +1712,11 @@ Group 8: (Blocks 2049-2304)
   Free inodes: 257-288
 Group 9: (Blocks 2305-2560)
   Backup superblock at 2305, Group descriptors at 2306-2310
-  Reserved GDT blocks at 2311-2433
-  Block bitmap at 2434 (+129), Inode bitmap at 2435 (+130)
-  Inode table at 2436-2439 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 2440-2560
+  Reserved GDT blocks at 2311-2370
+  Block bitmap at 2371 (+66), Inode bitmap at 2372 (+67)
+  Inode table at 2373-2376 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 2377-2560
   Free inodes: 289-320
 Group 10: (Blocks 2561-2816)
   Block bitmap at 2561 (+0), Inode bitmap at 2562 (+1)
@@ -1810,11 +1810,11 @@ Group 24: (Blocks 6145-6400)
   Free inodes: 769-800
 Group 25: (Blocks 6401-6656)
   Backup superblock at 6401, Group descriptors at 6402-6406
-  Reserved GDT blocks at 6407-6529
-  Block bitmap at 6530 (+129), Inode bitmap at 6531 (+130)
-  Inode table at 6532-6535 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 6536-6656
+  Reserved GDT blocks at 6407-6466
+  Block bitmap at 6467 (+66), Inode bitmap at 6468 (+67)
+  Inode table at 6469-6472 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 6473-6656
   Free inodes: 801-832
 Group 26: (Blocks 6657-6912)
   Block bitmap at 6657 (+0), Inode bitmap at 6658 (+1)
@@ -1824,11 +1824,11 @@ Group 26: (Blocks 6657-6912)
   Free inodes: 833-864
 Group 27: (Blocks 6913-7168)
   Backup superblock at 6913, Group descriptors at 6914-6918
-  Reserved GDT blocks at 6919-7041
-  Block bitmap at 7042 (+129), Inode bitmap at 7043 (+130)
-  Inode table at 7044-7047 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 7048-7168
+  Reserved GDT blocks at 6919-6978
+  Block bitmap at 6979 (+66), Inode bitmap at 6980 (+67)
+  Inode table at 6981-6984 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 6985-7168
   Free inodes: 865-896
 Group 28: (Blocks 7169-7424)
   Block bitmap at 7169 (+0), Inode bitmap at 7170 (+1)
@@ -1958,11 +1958,11 @@ Group 48: (Blocks 12289-12544)
   Free inodes: 1537-1568
 Group 49: (Blocks 12545-12800)
   Backup superblock at 12545, Group descriptors at 12546-12550
-  Reserved GDT blocks at 12551-12673
-  Block bitmap at 12674 (+129), Inode bitmap at 12675 (+130)
-  Inode table at 12676-12679 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 12680-12800
+  Reserved GDT blocks at 12551-12610
+  Block bitmap at 12611 (+66), Inode bitmap at 12612 (+67)
+  Inode table at 12613-12616 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 12617-12800
   Free inodes: 1569-1600
 Group 50: (Blocks 12801-13056)
   Block bitmap at 12801 (+0), Inode bitmap at 12802 (+1)
@@ -2152,11 +2152,11 @@ Group 80: (Blocks 20481-20736)
   Free inodes: 2561-2592
 Group 81: (Blocks 20737-20992)
   Backup superblock at 20737, Group descriptors at 20738-20742
-  Reserved GDT blocks at 20743-20865
-  Block bitmap at 20866 (+129), Inode bitmap at 20867 (+130)
-  Inode table at 20868-20871 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 20872-20992
+  Reserved GDT blocks at 20743-20802
+  Block bitmap at 20803 (+66), Inode bitmap at 20804 (+67)
+  Inode table at 20805-20808 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 20809-20992
   Free inodes: 2593-2624
 Group 82: (Blocks 20993-21248)
   Block bitmap at 20993 (+0), Inode bitmap at 20994 (+1)
@@ -2418,11 +2418,11 @@ Group 124: (Blocks 31745-32000)
   Free inodes: 3969-4000
 Group 125: (Blocks 32001-32256)
   Backup superblock at 32001, Group descriptors at 32002-32006
-  Reserved GDT blocks at 32007-32129
-  Block bitmap at 32130 (+129), Inode bitmap at 32131 (+130)
-  Inode table at 32132-32135 (+131)
-  121 free blocks, 32 free inodes, 0 directories
-  Free blocks: 32136-32256
+  Reserved GDT blocks at 32007-32066
+  Block bitmap at 32067 (+66), Inode bitmap at 32068 (+67)
+  Inode table at 32069-32072 (+68)
+  184 free blocks, 32 free inodes, 0 directories
+  Free blocks: 32073-32256
   Free inodes: 4001-4032
 Group 126: (Blocks 32257-32512)
   Block bitmap at 32257 (+0), Inode bitmap at 32258 (+1)
diff --git a/tests/r_resize_inode/expect b/tests/r_resize_inode/expect
index ba1647e..124348d 100644
--- a/tests/r_resize_inode/expect
+++ b/tests/r_resize_inode/expect
@@ -8,7 +8,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 4513/65536 blocks
+test_filesys: 11/16384 files (0.0% non-contiguous), 2785/65536 blocks
 Exit status is 0
 dumpe2fs test.img
 Filesystem volume name:   <none>
@@ -23,12 +23,12 @@ Filesystem OS type:       Linux
 Inode count:              16384
 Block count:              65536
 Reserved block count:     3276
-Free blocks:              61023
+Free blocks:              62751
 Free inodes:              16373
 First block:              1
 Block size:               1024
 Fragment size:            1024
-Reserved GDT blocks:      255
+Reserved GDT blocks:      63
 Blocks per group:         1024
 Fragments per group:      1024
 Inodes per group:         256
@@ -44,19 +44,19 @@ Default directory hash:   half_md4
 
 Group 0: (Blocks 1-1024)
   Primary superblock at 1, Group descriptors at 2-3
-  Reserved GDT blocks at 4-258
-  Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
-  Inode table at 261-292 (+260)
-  718 free blocks, 245 free inodes, 2 directories
-  Free blocks: 307-1024
+  Reserved GDT blocks at 4-66
+  Block bitmap at 67 (+66), Inode bitmap at 68 (+67)
+  Inode table at 69-100 (+68)
+  910 free blocks, 245 free inodes, 2 directories
+  Free blocks: 115-1024
   Free inodes: 12-256
 Group 1: (Blocks 1025-2048)
   Backup superblock at 1025, Group descriptors at 1026-1027
-  Reserved GDT blocks at 1028-1282
-  Block bitmap at 1283 (+258), Inode bitmap at 1284 (+259)
-  Inode table at 1285-1316 (+260)
-  732 free blocks, 256 free inodes, 0 directories
-  Free blocks: 1317-2048
+  Reserved GDT blocks at 1028-1090
+  Block bitmap at 1091 (+66), Inode bitmap at 1092 (+67)
+  Inode table at 1093-1124 (+68)
+  924 free blocks, 256 free inodes, 0 directories
+  Free blocks: 1125-2048
   Free inodes: 257-512
 Group 2: (Blocks 2049-3072)
   Block bitmap at 2049 (+0), Inode bitmap at 2050 (+1)
@@ -66,11 +66,11 @@ Group 2: (Blocks 2049-3072)
   Free inodes: 513-768
 Group 3: (Blocks 3073-4096)
   Backup superblock at 3073, Group descriptors at 3074-3075
-  Reserved GDT blocks at 3076-3330
-  Block bitmap at 3331 (+258), Inode bitmap at 3332 (+259)
-  Inode table at 3333-3364 (+260)
-  732 free blocks, 256 free inodes, 0 directories
-  Free blocks: 3365-4096
+  Reserved GDT blocks at 3076-3138
+  Block bitmap at 3139 (+66), Inode bitmap at 3140 (+67)
+  Inode table at 3141-3172 (+68)
+  924 free blocks, 256 free inodes, 0 directories
+  Free blocks: 3173-4096
   Free inodes: 769-1024
 Group 4: (Blocks 4097-5120)
   Block bitmap at 4097 (+0), Inode bitmap at 4098 (+1)
@@ -80,11 +80,11 @@ Group 4: (Blocks 4097-5120)
   Free inodes: 1025-1280
 Group 5: (Blocks 5121-6144)
   Backup superblock at 5121, Group descriptors at 5122-5123
-  Reserved GDT blocks at 5124-5378
-  Block bitmap at 5379 (+258), Inode bitmap at 5380 (+259)
-  Inode table at 5381-5412 (+260)
-  732 free blocks, 256 free inodes, 0 directories
-  Free blocks: 5413-6144
+  Reserved GDT blocks at 5124-5186
+  Block bitmap at 5187 (+66), Inode bitmap at 5188 (+67)
+  Inode table at 5189-5220 (+68)
+  924 free blocks, 256 free inodes, 0 directories
+  Free blocks: 5221-6144
   Free inodes: 1281-1536
 Group 6: (Blocks 6145-7168)
   Block bitmap at 6145 (+0), Inode bitmap at 6146 (+1)
@@ -94,11 +94,11 @@ Group 6: (Blocks 6145-7168)
   Free inodes: 1537-1792
 Group 7: (Blocks 7169-8192)
   Backup superblock at 7169, Group descriptors at 7170-7171
-  Reserved GDT blocks at 7172-7426
-  Block bitmap at 7427 (+258), Inode bitmap at 7428 (+259)
-  Inode table at 7429-7460 (+260)
-  732 free blocks, 256 free inodes, 0 directories
-  Free blocks: 7461-8192
+  Reserved GDT blocks at 7172-7234
+  Block bitmap at 7235 (+66), Inode bitmap at 7236 (+67)
+  Inode table at 7237-7268 (+68)
+  924 free blocks, 256 free inodes, 0 directories
+  Free blocks: 7269-8192
   Free inodes: 1793-2048
 Group 8: (Blocks 8193-9216)
   Block bitmap at 8193 (+0), Inode bitmap at 8194 (+1)
@@ -108,11 +108,11 @@ Group 8: (Blocks 8193-9216)
   Free inodes: 2049-2304
 Group 9: (Blocks 9217-10240)
   Backup superblock at 9217, Group descriptors at 9218-9219
-  Reserved GDT blocks at 9220-9474
-  Block bitmap at 9475 (+258), Inode bitmap at 9476 (+259)
-  Inode table at 9477-9508 (+260)
-  732 free blocks, 256 free inodes, 0 directories
-  Free blocks: 9509-10240
+  Reserved GDT blocks at 9220-9282
+  Block bitmap at 9283 (+66), Inode bitmap at 9284 (+67)
+  Inode table at 9285-9316 (+68)
+  924 free blocks, 256 free inodes, 0 directories
+  Free blocks: 9317-10240
   Free inodes: 2305-2560
 Group 10: (Blocks 10241-11264)
   Block bitmap at 10241 (+0), Inode bitmap at 10242 (+1)
@@ -206,11 +206,11 @@ Group 24: (Blocks 24577-25600)
   Free inodes: 6145-6400
 Group 25: (Blocks 25601-26624)
   Backup superblock at 25601, Group descriptors at 25602-25603
-  Reserved GDT blocks at 25604-25858
-  Block bitmap at 25859 (+258), Inode bitmap at 25860 (+259)
-  Inode table at 25861-25892 (+260)
-  732 free blocks, 256 free inodes, 0 directories
-  Free blocks: 25893-26624
+  Reserved GDT blocks at 25604-25666
+  Block bitmap at 25667 (+66), Inode bitmap at 25668 (+67)
+  Inode table at 25669-25700 (+68)
+  924 free blocks, 256 free inodes, 0 directories
+  Free blocks: 25701-26624
   Free inodes: 6401-6656
 Group 26: (Blocks 26625-27648)
   Block bitmap at 26625 (+0), Inode bitmap at 26626 (+1)
@@ -220,11 +220,11 @@ Group 26: (Blocks 26625-27648)
   Free inodes: 6657-6912
 Group 27: (Blocks 27649-28672)
   Backup superblock at 27649, Group descriptors at 27650-27651
-  Reserved GDT blocks at 27652-27906
-  Block bitmap at 27907 (+258), Inode bitmap at 27908 (+259)
-  Inode table at 27909-27940 (+260)
-  732 free blocks, 256 free inodes, 0 directories
-  Free blocks: 27941-28672
+  Reserved GDT blocks at 27652-27714
+  Block bitmap at 27715 (+66), Inode bitmap at 27716 (+67)
+  Inode table at 27717-27748 (+68)
+  924 free blocks, 256 free inodes, 0 directories
+  Free blocks: 27749-28672
   Free inodes: 6913-7168
 Group 28: (Blocks 28673-29696)
   Block bitmap at 28673 (+0), Inode bitmap at 28674 (+1)
@@ -354,11 +354,11 @@ Group 48: (Blocks 49153-50176)
   Free inodes: 12289-12544
 Group 49: (Blocks 50177-51200)
   Backup superblock at 50177, Group descriptors at 50178-50179
-  Reserved GDT blocks at 50180-50434
-  Block bitmap at 50435 (+258), Inode bitmap at 50436 (+259)
-  Inode table at 50437-50468 (+260)
-  732 free blocks, 256 free inodes, 0 directories
-  Free blocks: 50469-51200
+  Reserved GDT blocks at 50180-50242
+  Block bitmap at 50243 (+66), Inode bitmap at 50244 (+67)
+  Inode table at 50245-50276 (+68)
+  924 free blocks, 256 free inodes, 0 directories
+  Free blocks: 50277-51200
   Free inodes: 12545-12800
 Group 50: (Blocks 51201-52224)
   Block bitmap at 51201 (+0), Inode bitmap at 51202 (+1)
-- 
1.8.3.1

