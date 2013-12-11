From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 41/74] tests: adjust test output to reflect block_uninit
 calculated block bitmaps
Date: Tue, 10 Dec 2013 17:22:52 -0800
Message-ID: <20131211012252.30655.19588.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43234 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3LKBW7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:22:59 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that libext2fs marks group metadata in the fs block bitmap, adjust
the expected test output to reflect expanded use of block_uninit and
the fact debugfs no longer prints block bitmap data that fails to
account for group data blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/m_bigjournal/expect.1 |   16 ++++++++--------
 tests/m_uninit/expect.1     |   28 ++++++++++++++--------------
 2 files changed, 22 insertions(+), 22 deletions(-)


diff --git a/tests/m_bigjournal/expect.1 b/tests/m_bigjournal/expect.1
index 312c276..b45d02c 100644
--- a/tests/m_bigjournal/expect.1
+++ b/tests/m_bigjournal/expect.1
@@ -55,7 +55,7 @@ Group 0: (Blocks 0-32767)
   31836 free blocks, 5 free inodes, 2 directories, 5 unused inodes
   Free blocks: 764-1184, 1269-1696, 1781-32767
   Free inodes: 12-16
-Group 1: (Blocks 32768-65535) [INODE_UNINIT]
+Group 1: (Blocks 32768-65535) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 32768, Group descriptors at 32769-32769
   Reserved GDT blocks at 32770-33440
   Block bitmap at 674 (bg #0 + 674), Inode bitmap at 1186 (bg #0 + 1186)
@@ -69,7 +69,7 @@ Group 2: (Blocks 65536-98303) [INODE_UNINIT, BLOCK_UNINIT]
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 65536-98303
   Free inodes: 33-48
-Group 3: (Blocks 98304-131071) [INODE_UNINIT]
+Group 3: (Blocks 98304-131071) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 98304, Group descriptors at 98305-98305
   Reserved GDT blocks at 98306-98976
   Block bitmap at 676 (bg #0 + 676), Inode bitmap at 1188 (bg #0 + 1188)
@@ -83,7 +83,7 @@ Group 4: (Blocks 131072-163839) [INODE_UNINIT, BLOCK_UNINIT]
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 131072-163839
   Free inodes: 65-80
-Group 5: (Blocks 163840-196607) [INODE_UNINIT]
+Group 5: (Blocks 163840-196607) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 163840, Group descriptors at 163841-163841
   Reserved GDT blocks at 163842-164512
   Block bitmap at 678 (bg #0 + 678), Inode bitmap at 1190 (bg #0 + 1190)
@@ -97,7 +97,7 @@ Group 6: (Blocks 196608-229375) [INODE_UNINIT, BLOCK_UNINIT]
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 196608-229375
   Free inodes: 97-112
-Group 7: (Blocks 229376-262143) [INODE_UNINIT]
+Group 7: (Blocks 229376-262143) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 229376, Group descriptors at 229377-229377
   Reserved GDT blocks at 229378-230048
   Block bitmap at 680 (bg #0 + 680), Inode bitmap at 1192 (bg #0 + 1192)
@@ -111,7 +111,7 @@ Group 8: (Blocks 262144-294911) [INODE_UNINIT, BLOCK_UNINIT]
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 262144-294911
   Free inodes: 129-144
-Group 9: (Blocks 294912-327679) [INODE_UNINIT]
+Group 9: (Blocks 294912-327679) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 294912, Group descriptors at 294913-294913
   Reserved GDT blocks at 294914-295584
   Block bitmap at 682 (bg #0 + 682), Inode bitmap at 1194 (bg #0 + 1194)
@@ -209,7 +209,7 @@ Group 24: (Blocks 786432-819199) [INODE_UNINIT, BLOCK_UNINIT]
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 786432-819199
   Free inodes: 385-400
-Group 25: (Blocks 819200-851967) [INODE_UNINIT]
+Group 25: (Blocks 819200-851967) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 819200, Group descriptors at 819201-819201
   Reserved GDT blocks at 819202-819872
   Block bitmap at 698 (bg #0 + 698), Inode bitmap at 1210 (bg #0 + 1210)
@@ -223,7 +223,7 @@ Group 26: (Blocks 851968-884735) [INODE_UNINIT, BLOCK_UNINIT]
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 851968-884735
   Free inodes: 417-432
-Group 27: (Blocks 884736-917503) [INODE_UNINIT]
+Group 27: (Blocks 884736-917503) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 884736, Group descriptors at 884737-884737
   Reserved GDT blocks at 884738-885408
   Block bitmap at 700 (bg #0 + 700), Inode bitmap at 1212 (bg #0 + 1212)
@@ -551,7 +551,7 @@ Group 80: (Blocks 2621440-2654207) [INODE_UNINIT, BLOCK_UNINIT]
   32768 free blocks, 16 free inodes, 0 directories, 16 unused inodes
   Free blocks: 2621440-2654207
   Free inodes: 1281-1296
-Group 81: (Blocks 2654208-2686975) [INODE_UNINIT]
+Group 81: (Blocks 2654208-2686975) [INODE_UNINIT, BLOCK_UNINIT]
   Backup superblock at 2654208, Group descriptors at 2654209-2654209
   Reserved GDT blocks at 2654210-2654880
   Block bitmap at 754 (bg #0 + 754), Inode bitmap at 1266 (bg #0 + 1266)
diff --git a/tests/m_uninit/expect.1 b/tests/m_uninit/expect.1
index 3212e10..4af5955 100644
--- a/tests/m_uninit/expect.1
+++ b/tests/m_uninit/expect.1
@@ -64,7 +64,7 @@ Group 0: (Blocks 1-8192) [ITABLE_ZEROED]
   7662 free blocks, 2037 free inodes, 2 directories, 2037 unused inodes
   Free blocks: 531-8192
   Free inodes: 12-2048
-Group 1: (Blocks 8193-16384) [INODE_UNINIT, ITABLE_ZEROED]
+Group 1: (Blocks 8193-16384) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Backup superblock at 8193, Group descriptors at 8194-8194
   Reserved GDT blocks at 8195-8450
   Block bitmap at 8451 (+258), Inode bitmap at 8452 (+259)
@@ -76,9 +76,9 @@ Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
   Inode table at 16387-16642 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 16385-24576
+  Free blocks: 16643-24576
   Free inodes: 4097-6144
-Group 3: (Blocks 24577-32768) [INODE_UNINIT, ITABLE_ZEROED]
+Group 3: (Blocks 24577-32768) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Backup superblock at 24577, Group descriptors at 24578-24578
   Reserved GDT blocks at 24579-24834
   Block bitmap at 24835 (+258), Inode bitmap at 24836 (+259)
@@ -90,9 +90,9 @@ Group 4: (Blocks 32769-40960) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 32769 (+0), Inode bitmap at 32770 (+1)
   Inode table at 32771-33026 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 32769-40960
+  Free blocks: 33027-40960
   Free inodes: 8193-10240
-Group 5: (Blocks 40961-49152) [INODE_UNINIT, ITABLE_ZEROED]
+Group 5: (Blocks 40961-49152) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Backup superblock at 40961, Group descriptors at 40962-40962
   Reserved GDT blocks at 40963-41218
   Block bitmap at 41219 (+258), Inode bitmap at 41220 (+259)
@@ -104,9 +104,9 @@ Group 6: (Blocks 49153-57344) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 49153 (+0), Inode bitmap at 49154 (+1)
   Inode table at 49155-49410 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 49153-57344
+  Free blocks: 49411-57344
   Free inodes: 12289-14336
-Group 7: (Blocks 57345-65536) [INODE_UNINIT, ITABLE_ZEROED]
+Group 7: (Blocks 57345-65536) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Backup superblock at 57345, Group descriptors at 57346-57346
   Reserved GDT blocks at 57347-57602
   Block bitmap at 57603 (+258), Inode bitmap at 57604 (+259)
@@ -118,9 +118,9 @@ Group 8: (Blocks 65537-73728) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 65537 (+0), Inode bitmap at 65538 (+1)
   Inode table at 65539-65794 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 65537-73728
+  Free blocks: 65795-73728
   Free inodes: 16385-18432
-Group 9: (Blocks 73729-81920) [INODE_UNINIT, ITABLE_ZEROED]
+Group 9: (Blocks 73729-81920) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Backup superblock at 73729, Group descriptors at 73730-73730
   Reserved GDT blocks at 73731-73986
   Block bitmap at 73987 (+258), Inode bitmap at 73988 (+259)
@@ -132,31 +132,31 @@ Group 10: (Blocks 81921-90112) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 81921 (+0), Inode bitmap at 81922 (+1)
   Inode table at 81923-82178 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 81921-90112
+  Free blocks: 82179-90112
   Free inodes: 20481-22528
 Group 11: (Blocks 90113-98304) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 90113 (+0), Inode bitmap at 90114 (+1)
   Inode table at 90115-90370 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 90113-98304
+  Free blocks: 90371-98304
   Free inodes: 22529-24576
 Group 12: (Blocks 98305-106496) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 98305 (+0), Inode bitmap at 98306 (+1)
   Inode table at 98307-98562 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 98305-106496
+  Free blocks: 98563-106496
   Free inodes: 24577-26624
 Group 13: (Blocks 106497-114688) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 106497 (+0), Inode bitmap at 106498 (+1)
   Inode table at 106499-106754 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 106497-114688
+  Free blocks: 106755-114688
   Free inodes: 26625-28672
 Group 14: (Blocks 114689-122880) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 114689 (+0), Inode bitmap at 114690 (+1)
   Inode table at 114691-114946 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 114689-122880
+  Free blocks: 114947-122880
   Free inodes: 28673-30720
 Group 15: (Blocks 122881-131071) [INODE_UNINIT, ITABLE_ZEROED]
   Block bitmap at 122881 (+0), Inode bitmap at 122882 (+1)

