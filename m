From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 1/3]ext4: Fix double-free of blocks with EXT4_IOC_MOVE_EXT
Date: Wed, 18 Nov 2009 16:26:01 +0900
Message-ID: <4B03A189.6000109@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33376 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZKRHaO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Nov 2009 02:30:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix double-free of blocks with EXT4_IOC_MOVE_EXT

From: Akira Fujita <a-fujita@rs.jp.nec.com>

ext4_move_extent() calls ext4_discard_preallocations() to discard inode PAs
of orig and donor inodes in its beginning.
But the following case (1-4 steps) triggers the double-free of blocks,
so move ext4_discard_preallocations() to the end of ext4_move_extents().

1. Discard inode PAs of orig and donor inodes with ext4_discard_preallocations()
   in ext4_move_extents().

   orig : [ DATA1 ]
   donor: [ DATA2 ]

2. While data blocks are exchanging between orig and donor inodes,
   new inode PAs is created to orig by other process's block allocation.
   (Since there are semaphore gaps in ext4_move_extents().)
   And new inode PAs is used partially (2-1).

   2-1 Create new inode PAs to orig inode
   orig : [ DATA1 | used PA1 | free PA1 ]
   donor: [ DATA2 ]

3. Donor inode which has old orig inode's blocks is deleted
   after EXT4_IOC_MOVE_EXT finished (3-1, 3-2).
   So the block bitmap corresponds to old orig inode's blocks are freed.

   3-1 After EXT4_IOC_MOVE_EXT finished
   orig : [ DATA2 |  free PA1 ]
   donor: [ DATA1 |  used PA1 ]

   3-2 Delete donor inode
   orig : [ DATA2 |  free PA1 ]
   donor: [ FREE SPACE(DATA1) | FREE SPACE(used PA1) ]

4. The double-free of blocks is occurred, when close() is called to orig inode.
   Because ext4_discard_preallocations() for orig inode frees used PA1 and free PA1,
   though used PA1 is already freed in 3.

   4-1 Double-free of blocks is occurred
   orig : [ DATA2 |  FREE SPACE(free PA1) ]
   donor: [ FREE SPACE(DATA1) | DOUBLE FREE(used PA1) ]

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 move_extent.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 5a106e0..3478889 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1289,10 +1289,6 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			 ext4_ext_get_actual_len(ext_cur), block_end + 1) -
 		     max(le32_to_cpu(ext_cur->ee_block), block_start);

-	/* Discard preallocations of two inodes */
-	ext4_discard_preallocations(orig_inode);
-	ext4_discard_preallocations(donor_inode);
