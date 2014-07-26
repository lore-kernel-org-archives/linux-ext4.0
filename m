From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/6] libext2fs: fix free block accounting for 64-bit file systems
Date: Sat, 26 Jul 2014 09:48:34 -0400
Message-ID: <1406382514-8662-7-git-send-email-tytso@mit.edu>
References: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58037 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaGZNsi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 09:48:38 -0400
In-Reply-To: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We rely on a nasty hack to adjust the free block count where we pass
signed value into ext2fs_free_blocks_count_add(), which takes an
64-bit unsigned value, and relies on overflow and C's signed->unsigned
semantics to do the subtraction.  This works, so long as a 64-bit
signed value is used.

Unfortunately, ext2fs_block_alloc_stats2() and
ext2fs_block_alloc_stats_range(), this is not true, so on a 64-bit
file system, the free blocks accounting can get screwed up.

A simple way to demonstrate the problem is:

mke2fs -F -t ext4 -O 64bit /tmp/foo.img 1M
e2fsck -fy /tmp/foo.img

... which will result in the following e2fsck complaint:

Pass 5: Checking group summary information
Free blocks count wrong (4294968278, counted=982).
Fix? yes

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/alloc_stats.c      |  4 ++--
 tests/m_64bit_flexbg/expect.1 | 55 +++++++++++++++++++++++++++++++++++++++++++
 tests/m_64bit_flexbg/script   |  4 ++++
 3 files changed, 61 insertions(+), 2 deletions(-)
 create mode 100644 tests/m_64bit_flexbg/expect.1
 create mode 100644 tests/m_64bit_flexbg/script

diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 1f58e00..a449dc3 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -79,7 +79,7 @@ void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse)
 	ext2fs_group_desc_csum_set(fs, group);
 
 	ext2fs_free_blocks_count_add(fs->super,
-				     -inuse * EXT2FS_CLUSTER_RATIO(fs));
+			     -inuse * (blk64_t) EXT2FS_CLUSTER_RATIO(fs));
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
 	if (fs->block_alloc_stats)
@@ -140,7 +140,7 @@ void ext2fs_block_alloc_stats_range(ext2_filsys fs, blk64_t blk,
 			inuse*n/EXT2FS_CLUSTER_RATIO(fs));
 		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 		ext2fs_group_desc_csum_set(fs, group);
-		ext2fs_free_blocks_count_add(fs->super, -inuse * n);
+		ext2fs_free_blocks_count_add(fs->super, -inuse * (blk64_t) n);
 		blk += n;
 		num -= n;
 	}
diff --git a/tests/m_64bit_flexbg/expect.1 b/tests/m_64bit_flexbg/expect.1
new file mode 100644
index 0000000..3635318
--- /dev/null
+++ b/tests/m_64bit_flexbg/expect.1
@@ -0,0 +1,55 @@
+Creating filesystem with 1024 1k blocks and 128 inodes
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Writing superblocks and filesystem accounting information:    done
+
+Filesystem features: ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 42/1024 blocks
+Exit status is 0
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              128
+Block count:              1024
+Reserved block count:     51
+Free blocks:              982
+Free inodes:              117
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Group descriptor size:    64
+Reserved GDT blocks:      7
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         128
+Inode blocks per group:   16
+Flex block group size:    16
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:	          128
+Default directory hash:   half_md4
+
+
+Group 0: (Blocks 1-1023)
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-9
+  Block bitmap at 10 (+9), Inode bitmap at 26 (+25)
+  Inode table at 42-57 (+41)
+  982 free blocks, 117 free inodes, 2 directories
+  Free blocks: 24-25, 28-41, 58-1023
+  Free inodes: 12-128
diff --git a/tests/m_64bit_flexbg/script b/tests/m_64bit_flexbg/script
new file mode 100644
index 0000000..98684e4
--- /dev/null
+++ b/tests/m_64bit_flexbg/script
@@ -0,0 +1,4 @@
+DESCRIPTION="mkfs with 64bit and flex_bg"
+FS_SIZE=1M
+MKE2FS_OPTS="-O 64bit,extents,flex_bg"
+. $cmd_dir/run_mke2fs
-- 
2.0.0

