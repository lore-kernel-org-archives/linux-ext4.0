From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2] e2fsprogs: Limit number of reserved gdt blocks on small fs
Date: Wed, 25 Mar 2015 11:46:22 +0100
Message-ID: <1427280382-31120-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbbCYKq1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Mar 2015 06:46:27 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 7C938C658C
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2015 10:46:27 +0000 (UTC)
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
case that it would not fit in the journal transaction by default.
Note that it's still possible to create such file system by specifying
non-default options so I've added mke2fs message that would warn users
that would try to create such file system, but will still allow them to
do so.

We still need to address the kernel problem where such file system would
generate scary kernel warning, but that's for a separate patch.

Also fix output of some tests, because this change slightly alters the
file system layout (specifically number of free blocks and number of
reserved gdt blocks) on very small file systems.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/initialize.c         | 31 ++++++++++++-
 misc/mke2fs.c                   | 27 ++++++++++++
 tests/d_loaddump/script         |  2 +-
 tests/f_desc_size_bad/expect.1  |  2 +-
 tests/f_desc_size_bad/expect.2  |  2 +-
 tests/f_resize_inode/expect     | 44 +++++++++----------
 tests/m_mkfs_overhead/script    |  2 +-
 tests/r_fixup_lastbg/expect     | 22 +++++-----
 tests/r_fixup_lastbg_big/expect | 26 +++++------
 tests/r_resize_inode/expect     | 96 ++++++++++++++++++++---------------------
 10 files changed, 154 insertions(+), 100 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 75fbf8e..180e605 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -59,18 +59,45 @@ static unsigned int calc_reserved_gdt_blocks(ext2_filsys fs)
 	unsigned long max_blocks = 0xffffffff;
 	unsigned long rsv_groups;
 	unsigned int rsv_gdb;
+	__u64 blocks_count;
+	int journal_blocks, credits;
+
+	blocks_count = ext2fs_blocks_count(sb);
+	journal_blocks = ext2fs_default_journal_size(blocks_count);
 
 	/* We set it at 1024x the current filesystem size, or
 	 * the upper block count limit (2^32), whichever is lower.
 	 */
-	if (ext2fs_blocks_count(sb) < max_blocks / 1024)
-		max_blocks = ext2fs_blocks_count(sb) * 1024;
+	if (blocks_count < max_blocks / 1024)
+		max_blocks = blocks_count * 1024;
 	/*
 	 * ext2fs_div64_ceil() is unnecessary because max_blocks is
 	 * max _GDT_ blocks, which is limited to 32 bits.
 	 */
 	rsv_groups = ext2fs_div_ceil(max_blocks - sb->s_first_data_block, bpg);
 	rsv_gdb = ext2fs_div_ceil(rsv_groups, gdpb) - fs->desc_blocks;
+
+	/*
+	 * In online resize we require a huge number of journal
+	 * credits mainly because of the reserved gdt blocks. The
+	 * exact number of journal credits needed is:
+	 * flex_gd->count * 4 + reserved_gdb
+	 *
+	 * In order to allow online resize on file system with tiny
+	 * journal (tiny fs) we have to make sure that the number of
+	 * reserved gdt blocks is small enough. If the user specifies
+	 * non-default values he can still run into this issue but we
+	 * do not want to make that mistake by default.
+	 *
+	 * journal_blocks / 8 is the maximum amount of credits we're allowed
+	 * to use in a single transaction.
+	 *
+	 */
+	credits = (1 << fs->super->s_log_groups_per_flex) * 4 + rsv_gdb;
+	if (journal_blocks > 0 && credits > journal_blocks / 8)
+		rsv_gdb = (journal_blocks / 8) -
+			  (1 << fs->super->s_log_groups_per_flex) * 4;
+
 	if (rsv_gdb > EXT2_ADDR_PER_BLOCK(sb))
 		rsv_gdb = EXT2_ADDR_PER_BLOCK(sb);
 #ifdef RES_GDT_DEBUG
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index aeb852f..a6c6a1d 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -3076,6 +3076,33 @@ int main (int argc, char *argv[])
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
+			credits = (1 << fs_param.s_log_groups_per_flex) * 4 +
+				  fs->super->s_reserved_gdt_blocks;
+			if (credits > journal_blocks / 8) {
+				fprintf(stderr, "%s", _("Warning: Journal is "
+					"not big enough. In this configuration "
+					"the file system will not be able to "
+					"grow online!\n"));
+			}
+		}
 	}
 no_journal:
 	if (!super_only &&
diff --git a/tests/d_loaddump/script b/tests/d_loaddump/script
index 39727ba..0f5fd25 100644
--- a/tests/d_loaddump/script
+++ b/tests/d_loaddump/script
@@ -13,7 +13,7 @@ dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
 
 echo "mke2fs -Fq -b 1024 test.img 512" >> $OUT
 
-$MKE2FS -Fq $TMPFILE 512 > /dev/null 2>&1
+$MKE2FS -Fq $TMPFILE 512
 status=$?
 echo Exit status is $status >> $OUT
 
diff --git a/tests/f_desc_size_bad/expect.1 b/tests/f_desc_size_bad/expect.1
index 009ee04..08a8dbc 100644
--- a/tests/f_desc_size_bad/expect.1
+++ b/tests/f_desc_size_bad/expect.1
@@ -7,5 +7,5 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/32 files (0.0% non-contiguous), 801/2048 blocks
+test_filesys: 11/32 files (0.0% non-contiguous), 405/2048 blocks
 Exit status is 1
diff --git a/tests/f_desc_size_bad/expect.2 b/tests/f_desc_size_bad/expect.2
index d1429fd..ad1cf50 100644
--- a/tests/f_desc_size_bad/expect.2
+++ b/tests/f_desc_size_bad/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32 files (0.0% non-contiguous), 801/2048 blocks
+test_filesys: 11/32 files (0.0% non-contiguous), 405/2048 blocks
 Exit status is 0
diff --git a/tests/f_resize_inode/expect b/tests/f_resize_inode/expect
index db57ed6..95fc4cf 100644
--- a/tests/f_resize_inode/expect
+++ b/tests/f_resize_inode/expect
@@ -12,7 +12,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 1315/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -25,22 +25,22 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Free blocks count wrong for group #0 (717, counted=718).
+Free blocks count wrong for group #0 (849, counted=850).
 Fix? yes
 
-Free blocks count wrong (14276, counted=14277).
+Free blocks count wrong (15068, counted=15069).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 1315/16384 blocks
 Exit status is 1
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 1315/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -53,22 +53,22 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Free blocks count wrong for group #0 (717, counted=718).
+Free blocks count wrong for group #0 (849, counted=850).
 Fix? yes
 
-Free blocks count wrong (14276, counted=14277).
+Free blocks count wrong (15068, counted=15069).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 1315/16384 blocks
 Exit status is 1
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 1315/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -81,22 +81,22 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Free blocks count wrong for group #0 (717, counted=718).
+Free blocks count wrong for group #0 (849, counted=850).
 Fix? yes
 
-Free blocks count wrong (14276, counted=14277).
+Free blocks count wrong (15068, counted=15069).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 1315/16384 blocks
 Exit status is 1
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 1315/16384 blocks
 Exit status is 0
 -----------------------------------------------
  
@@ -111,7 +111,7 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
+test_filesys: 11/4096 files (0.0% non-contiguous), 1315/16384 blocks
 Exit status is 1
 -----------------------------------------------
  
@@ -122,28 +122,28 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Block bitmap differences:  -(35--258) -(1059--1282) -(3107--3330) -(5155--5378) -(7203--7426) -(9251--9474)
+Block bitmap differences:  -(35--126) -(1059--1150) -(3107--3198) -(5155--5246) -(7203--7294) -(9251--9342)
 Fix? yes
 
-Free blocks count wrong for group #0 (718, counted=942).
+Free blocks count wrong for group #0 (850, counted=942).
 Fix? yes
 
-Free blocks count wrong for group #1 (732, counted=956).
+Free blocks count wrong for group #1 (864, counted=956).
 Fix? yes
 
-Free blocks count wrong for group #3 (732, counted=956).
+Free blocks count wrong for group #3 (864, counted=956).
 Fix? yes
 
-Free blocks count wrong for group #5 (732, counted=956).
+Free blocks count wrong for group #5 (864, counted=956).
 Fix? yes
 
-Free blocks count wrong for group #7 (732, counted=956).
+Free blocks count wrong for group #7 (864, counted=956).
 Fix? yes
 
-Free blocks count wrong for group #9 (732, counted=956).
+Free blocks count wrong for group #9 (864, counted=956).
 Fix? yes
 
-Free blocks count wrong (14277, counted=15621).
+Free blocks count wrong (15069, counted=15621).
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
diff --git a/tests/r_resize_inode/expect b/tests/r_resize_inode/expect
index ba1647e..698347f 100644
--- a/tests/r_resize_inode/expect
+++ b/tests/r_resize_inode/expect
@@ -8,7 +8,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 4513/65536 blocks
+test_filesys: 11/16384 files (0.0% non-contiguous), 3325/65536 blocks
 Exit status is 0
 dumpe2fs test.img
 Filesystem volume name:   <none>
@@ -23,12 +23,12 @@ Filesystem OS type:       Linux
 Inode count:              16384
 Block count:              65536
 Reserved block count:     3276
-Free blocks:              61023
+Free blocks:              62211
 Free inodes:              16373
 First block:              1
 Block size:               1024
 Fragment size:            1024
-Reserved GDT blocks:      255
+Reserved GDT blocks:      123
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
+  Reserved GDT blocks at 4-126
+  Block bitmap at 127 (+126), Inode bitmap at 128 (+127)
+  Inode table at 129-160 (+128)
+  850 free blocks, 245 free inodes, 2 directories
+  Free blocks: 175-1024
   Free inodes: 12-256
 Group 1: (Blocks 1025-2048)
   Backup superblock at 1025, Group descriptors at 1026-1027
-  Reserved GDT blocks at 1028-1282
-  Block bitmap at 1283 (+258), Inode bitmap at 1284 (+259)
-  Inode table at 1285-1316 (+260)
-  732 free blocks, 256 free inodes, 0 directories
-  Free blocks: 1317-2048
+  Reserved GDT blocks at 1028-1150
+  Block bitmap at 1151 (+126), Inode bitmap at 1152 (+127)
+  Inode table at 1153-1184 (+128)
+  864 free blocks, 256 free inodes, 0 directories
+  Free blocks: 1185-2048
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
+  Reserved GDT blocks at 3076-3198
+  Block bitmap at 3199 (+126), Inode bitmap at 3200 (+127)
+  Inode table at 3201-3232 (+128)
+  864 free blocks, 256 free inodes, 0 directories
+  Free blocks: 3233-4096
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
+  Reserved GDT blocks at 5124-5246
+  Block bitmap at 5247 (+126), Inode bitmap at 5248 (+127)
+  Inode table at 5249-5280 (+128)
+  864 free blocks, 256 free inodes, 0 directories
+  Free blocks: 5281-6144
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
+  Reserved GDT blocks at 7172-7294
+  Block bitmap at 7295 (+126), Inode bitmap at 7296 (+127)
+  Inode table at 7297-7328 (+128)
+  864 free blocks, 256 free inodes, 0 directories
+  Free blocks: 7329-8192
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
+  Reserved GDT blocks at 9220-9342
+  Block bitmap at 9343 (+126), Inode bitmap at 9344 (+127)
+  Inode table at 9345-9376 (+128)
+  864 free blocks, 256 free inodes, 0 directories
+  Free blocks: 9377-10240
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
+  Reserved GDT blocks at 25604-25726
+  Block bitmap at 25727 (+126), Inode bitmap at 25728 (+127)
+  Inode table at 25729-25760 (+128)
+  864 free blocks, 256 free inodes, 0 directories
+  Free blocks: 25761-26624
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
+  Reserved GDT blocks at 27652-27774
+  Block bitmap at 27775 (+126), Inode bitmap at 27776 (+127)
+  Inode table at 27777-27808 (+128)
+  864 free blocks, 256 free inodes, 0 directories
+  Free blocks: 27809-28672
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
+  Reserved GDT blocks at 50180-50302
+  Block bitmap at 50303 (+126), Inode bitmap at 50304 (+127)
+  Inode table at 50305-50336 (+128)
+  864 free blocks, 256 free inodes, 0 directories
+  Free blocks: 50337-51200
   Free inodes: 12545-12800
 Group 50: (Blocks 51201-52224)
   Block bitmap at 51201 (+0), Inode bitmap at 51202 (+1)
-- 
1.8.3.1

