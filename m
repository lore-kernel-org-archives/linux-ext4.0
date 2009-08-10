From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/6] libext2fs: Treat uninitialized parts of bitmaps as unallocated
Date: Sun,  9 Aug 2009 23:31:58 -0400
Message-ID: <1249875118-26291-7-git-send-email-tytso@mit.edu>
References: <20090727183636.GN4231@webber.adilger.int>
Cc: Andreas Dilger <adilger@sun.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46049 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbZHJDcC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Aug 2009 23:32:02 -0400
In-Reply-To: <20090727183636.GN4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/rw_bitmaps.c |    4 +-
 tests/m_uninit/expect.1 |   48 +++++++++++++++++++++++-----------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 341f834..56fcfd6 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -248,7 +248,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					goto cleanup;
 				}
 			} else
-				memset(block_bitmap, 0xff, block_nbytes);
+				memset(block_bitmap, 0, block_nbytes);
 			cnt = block_nbytes << 3;
 			retval = ext2fs_set_block_bitmap_range(fs->block_map,
 					       blk_itr, cnt, block_bitmap);
@@ -270,7 +270,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					goto cleanup;
 				}
 			} else
-				memset(inode_bitmap, 0xff, inode_nbytes);
+				memset(inode_bitmap, 0, inode_nbytes);
 			cnt = inode_nbytes << 3;
 			retval = ext2fs_set_inode_bitmap_range(fs->inode_map,
 					       ino_itr, cnt, inode_bitmap);
diff --git a/tests/m_uninit/expect.1 b/tests/m_uninit/expect.1
index 549aced..67cd33d 100644
--- a/tests/m_uninit/expect.1
+++ b/tests/m_uninit/expect.1
@@ -71,13 +71,13 @@ Group 1: (Blocks 8193-16384) [INODE_UNINIT, ITABLE_ZEROED]
   Inode table at 8453-8708 (+260)
   7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 8709-16384
-  Free inodes: 
+  Free inodes: 2049-4096
 Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
   Inode table at 16387-16642 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 16385-24576
+  Free inodes: 4097-6144
 Group 3: (Blocks 24577-32768) [INODE_UNINIT, ITABLE_ZEROED]
   Backup superblock at 24577, Group descriptors at 24578-24578
   Reserved GDT blocks at 24579-24834
@@ -85,13 +85,13 @@ Group 3: (Blocks 24577-32768) [INODE_UNINIT, ITABLE_ZEROED]
   Inode table at 24837-25092 (+260)
   7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 25093-32768
-  Free inodes: 
+  Free inodes: 6145-8192
 Group 4: (Blocks 32769-40960) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 32769 (+0), Inode bitmap at 32770 (+1)
   Inode table at 32771-33026 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 32769-40960
+  Free inodes: 8193-10240
 Group 5: (Blocks 40961-49152) [INODE_UNINIT, ITABLE_ZEROED]
   Backup superblock at 40961, Group descriptors at 40962-40962
   Reserved GDT blocks at 40963-41218
@@ -99,13 +99,13 @@ Group 5: (Blocks 40961-49152) [INODE_UNINIT, ITABLE_ZEROED]
   Inode table at 41221-41476 (+260)
   7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 41477-49152
-  Free inodes: 
+  Free inodes: 10241-12288
 Group 6: (Blocks 49153-57344) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 49153 (+0), Inode bitmap at 49154 (+1)
   Inode table at 49155-49410 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 49153-57344
+  Free inodes: 12289-14336
 Group 7: (Blocks 57345-65536) [INODE_UNINIT, ITABLE_ZEROED]
   Backup superblock at 57345, Group descriptors at 57346-57346
   Reserved GDT blocks at 57347-57602
@@ -113,13 +113,13 @@ Group 7: (Blocks 57345-65536) [INODE_UNINIT, ITABLE_ZEROED]
   Inode table at 57605-57860 (+260)
   7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 57861-65536
-  Free inodes: 
+  Free inodes: 14337-16384
 Group 8: (Blocks 65537-73728) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 65537 (+0), Inode bitmap at 65538 (+1)
   Inode table at 65539-65794 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 65537-73728
+  Free inodes: 16385-18432
 Group 9: (Blocks 73729-81920) [INODE_UNINIT, ITABLE_ZEROED]
   Backup superblock at 73729, Group descriptors at 73730-73730
   Reserved GDT blocks at 73731-73986
@@ -127,40 +127,40 @@ Group 9: (Blocks 73729-81920) [INODE_UNINIT, ITABLE_ZEROED]
   Inode table at 73989-74244 (+260)
   7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 74245-81920
-  Free inodes: 
+  Free inodes: 18433-20480
 Group 10: (Blocks 81921-90112) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 81921 (+0), Inode bitmap at 81922 (+1)
   Inode table at 81923-82178 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 81921-90112
+  Free inodes: 20481-22528
 Group 11: (Blocks 90113-98304) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 90113 (+0), Inode bitmap at 90114 (+1)
   Inode table at 90115-90370 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 90113-98304
+  Free inodes: 22529-24576
 Group 12: (Blocks 98305-106496) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 98305 (+0), Inode bitmap at 98306 (+1)
   Inode table at 98307-98562 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 98305-106496
+  Free inodes: 24577-26624
 Group 13: (Blocks 106497-114688) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 106497 (+0), Inode bitmap at 106498 (+1)
   Inode table at 106499-106754 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 106497-114688
+  Free inodes: 26625-28672
 Group 14: (Blocks 114689-122880) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 114689 (+0), Inode bitmap at 114690 (+1)
   Inode table at 114691-114946 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 114689-122880
+  Free inodes: 28673-30720
 Group 15: (Blocks 122881-131071) [INODE_UNINIT, ITABLE_ZEROED]
   Block bitmap at 122881 (+0), Inode bitmap at 122882 (+1)
   Inode table at 122883-123138 (+2)
   7933 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 123139-131071
-  Free inodes: 
+  Free inodes: 30721-32768
-- 
1.6.3.2.1.gb9f7d.dirty

