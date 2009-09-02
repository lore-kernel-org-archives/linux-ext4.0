From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 1/4]ext4: Fix wrong comparisons in mext_check_arguments()
Date: Wed, 02 Sep 2009 12:17:50 +0900
Message-ID: <4A9DE3DE.2010509@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39887 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbZIBDSa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Sep 2009 23:18:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix wrong comparisons in mext_check_arguments()

From: Akira Fujita <a-fujita@rs.jp.nec.com>

mext_check_arguments() in move_extents.c has wrong comparisons.
orig_start which is passed from user-space is block unit,
but i_size of inode is byte unit, therefore the checks do not work fine.
This mis-check leads to the overflow of 'len' and then hits BUG_ON()
in ext4_move_extens().   The patch fixes this issue.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/move_extent.c |   39 ++++++++++++++++++++++++---------------
 1 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 5821e0b..60ed567 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -972,43 +972,52 @@ mext_check_arguments(struct inode *orig_inode,
 	}

 	if (orig_inode->i_size > donor_inode->i_size) {
-		if (orig_start >= donor_inode->i_size) {
+		if (orig_start << orig_inode->i_blkbits >=
+						donor_inode->i_size) {
 			ext4_debug("ext4 move extent: orig start offset "
 			"[%llu] should be less than donor file size "
 			"[%lld] [ino:orig %lu, donor_inode %lu]\n",
-			orig_start, donor_inode->i_size,
-			orig_inode->i_ino, donor_inode->i_ino);
+			orig_start << orig_inode->i_blkbits,
+			donor_inode->i_size, orig_inode->i_ino,
+			donor_inode->i_ino);
 			return -EINVAL;
 		}
-
-		if (orig_start + *len > donor_inode->i_size) {
+		if ((orig_start + *len) << orig_inode->i_blkbits >
+						donor_inode->i_size) {
 			ext4_debug("ext4 move extent: End offset [%llu] should "
 				"be less than donor file size [%lld]."
 				"So adjust length from %llu to %lld "
 				"[ino:orig %lu, donor %lu]\n",
-				orig_start + *len, donor_inode->i_size,
-				*len, donor_inode->i_size - orig_start,
+				(orig_start + *len) << orig_inode->i_blkbits,
+				donor_inode->i_size,
+				*len, (donor_inode->i_size >>
+				orig_inode->i_blkbits) - orig_start,
 				orig_inode->i_ino, donor_inode->i_ino);
-			*len = donor_inode->i_size - orig_start;
+			*len = (donor_inode->i_size >> orig_inode->i_blkbits) -
+				orig_start;
 		}
 	} else {
-		if (orig_start >= orig_inode->i_size) {
+		if (orig_start << orig_inode->i_blkbits >=
+						orig_inode->i_size) {
 			ext4_debug("ext4 move extent: start offset [%llu] "
 				"should be less than original file size "
 				"[%lld] [inode:orig %lu, donor %lu]\n",
-				 orig_start, orig_inode->i_size,
-				orig_inode->i_ino, donor_inode->i_ino);
+				orig_start << orig_inode->i_blkbits,
+				orig_inode->i_size, orig_inode->i_ino,
+				donor_inode->i_ino);
 			return -EINVAL;
 		}
