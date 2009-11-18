From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 2/3]ext4: Initialize moved_len before calling ext4_move_extents()
Date: Wed, 18 Nov 2009 16:26:10 +0900
Message-ID: <4B03A192.5000201@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33463 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZKRHa0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Nov 2009 02:30:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

# This is a RESENT patch
http://marc.info/?l=linux-ext4&m=125498954712519&w=4

ext4: initialize moved_len before calling ext4_move_extents()

From: Kazuya Mio <k-mio@sx.jp.nec.com>

moved_len of struct move_extent is used to notify
exchanged blocks count to the user space.
So at the beginning of the EXT4_IOC_MOVE_EXT,
moved_len should be always zero.
Without this patch, if wrong moved_len is passed from the user space,
EXT4_IOC_MOVE_EXT will return wrong blocks count.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 ioctl.c       |    1 +
 move_extent.c |   12 ++----------
 2 files changed, 3 insertions(+), 10 deletions(-)
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index d1fe495..dbf9a8b 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -251,6 +251,7 @@ setversion_out:
 			}
 		}

+		me.moved_len = 0;
 		err = ext4_move_extents(filp, donor_filp, me.orig_start,
 					me.donor_start, me.len, &me.moved_len);
 		fput(donor_filp);
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 25b6b14..e2e99fd 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -962,7 +962,6 @@ out2:
  * @orig_start:		logical start offset in block for orig
  * @donor_start:	logical start offset in block for donor
  * @len:		the number of blocks to be moved
- * @moved_len:		moved block length
  *
  * Check the arguments of ext4_move_extents() whether the files can be
  * exchanged with each other.
@@ -971,7 +970,7 @@ out2:
 static int
 mext_check_arguments(struct inode *orig_inode,
 			  struct inode *donor_inode, __u64 orig_start,
-			  __u64 donor_start, __u64 *len, __u64 moved_len)
+			  __u64 donor_start, __u64 *len)
 {
 	ext4_lblk_t orig_blocks, donor_blocks;
 	unsigned int blkbits = orig_inode->i_blkbits;
@@ -1025,13 +1024,6 @@ mext_check_arguments(struct inode *orig_inode,
 		return -EINVAL;
 	}

-	if (moved_len) {
-		ext4_debug("ext4 move extent: moved_len should be 0 "
-			"[ino:orig %lu, donor %lu]\n", orig_inode->i_ino,
-			donor_inode->i_ino);
-		return -EINVAL;
-	}
