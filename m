From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 1/2] ext4: initialize moved_len before calling ext4_move_extents()
Date: Thu, 08 Oct 2009 17:04:19 +0900
Message-ID: <4ACD9D03.6050908@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39008 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbZJHIHQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Oct 2009 04:07:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

moved_len in struct move_extent is set replaced block count. So it is
zeroed in the beginning of EXT4_IOC_MOVE_EXT and removes checking
moved_len in mext_check_arguments().

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
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
