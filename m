Return-Path: <SRS0=oRRr=OR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:16098 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726124AbeLHOLu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 8 Dec 2018 09:11:50 -0500
From: "zhangyi (F)" <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <tytso@mit.edu>, <yi.zhang@huawei.com>, <miaoxie@huawei.com>
Subject: [PATCH] ext4: fix unsafe extent initialization
Date: Sat, 8 Dec 2018 22:25:58 +0800
Message-ID: <20181208142558.47955-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current ext4 will call ext4_ext_convert_to_initialized() to split and
initialize an unwritten extent if someone write something to it. It may
also zeroout the nearby blocks and expand the split extent if the
allocated extent is fully inside i_size or new_size. But it may lead to
inode inconsistency when system crash or the power fails.

Consider the following case:
 - Create an empty file and buffer write from block A to D (with delay
   allocate). It will update the i_size to D.
 - Zero range from part of block B to D. It will allocate an unwritten
   extent from B to D.
 - The write back worker write block B and initialize the unwritten
   extent from B to D, and then update the i_disksize to B.
 - System crash.
 - Remount and fsck complain about the extent size exceeds the inode
   size.

This patch add checking i_disksize and chose the small one between
i_size to make sure it's safe to convert extent to initialized.

---------------------

This problem can reproduce by xfstests generic/482 with fsstress seed
1544025012.

Fsck output:

fsck from util-linux 2.23.2
e2fsck 1.42.9 (28-Dec-2013)
Pass 1: Checking inodes, blocks, and sizes
Inode 15, end of extent exceeds allowed value
        (logical block 294, physical block 34028, len 3)
Clear? no

Inode 15, i_blocks is 3784, should be 3760.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(34028--34030)
Fix? no

The sizeof inode 15 is 0x127000, and the extent tree is:

Level Entries       Logical          Physical Length Flags
 1/ 1   1/  8    14 -    38   36110 -   36134     25
 1/ 1   2/  8   128 -   137   34688 -   34697     10
 1/ 1   3/  8   219 -   231   36305 -   36317     13
 1/ 1   4/  8   284 -   293   36370 -   36379     10
 1/ 1   5/  8   294 -   296   34028 -   34030      3
 1/ 1   6/  8   297 -   511   35182 -   35396    215 Uninit
 1/ 1   7/  8   512 -   523   34096 -   34107     12 Uninit
 1/ 1   8/  8   630 -   813   35746 -   35929    184 Uninit

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 240b6de..7c9abab 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3473,6 +3473,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	struct ext4_extent zero_ex1, zero_ex2;
 	struct ext4_extent *ex, *abut_ex;
 	ext4_lblk_t ee_block, eof_block;
+	loff_t eof_size;
 	unsigned int ee_len, depth, map_len = map->m_len;
 	int allocated = 0, max_zeroout = 0;
 	int err = 0;
@@ -3483,7 +3484,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		(unsigned long long)map->m_lblk, map_len);
 
 	sbi = EXT4_SB(inode->i_sb);
-	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
+	eof_size = min(inode->i_size, EXT4_I(inode)->i_disksize);
+	eof_block = (eof_size + inode->i_sb->s_blocksize - 1) >>
 		inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map_len)
 		eof_block = map->m_lblk + map_len;
@@ -3623,7 +3625,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	WARN_ON(map->m_lblk < ee_block);
 	/*
 	 * It is safe to convert extent to initialized via explicit
-	 * zeroout only if extent is fully inside i_size or new_size.
+	 * zeroout only if extent is fully inside min(i_size, i_disksize)
+	 * or new_size.
 	 */
 	split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
 
-- 
2.5.0
