From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 4/4]ext4: Fix comment typo in move_extent.c
Date: Fri, 30 Oct 2009 16:42:08 +0900
Message-ID: <4AEA98D0.5070602@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:41055 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZJ3HoS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 03:44:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix comment typo in move_extent.c

From: Akira Fujita <a-fujita@rs.jp.nec.com>

Fix some comment typo in move_extent.c

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.co.jp>
---
 fs/ext4/move_extent.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 2ca6aa3..5a106e0 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -568,7 +568,7 @@ out:
  * @tmp_oext:		the extent that will belong to the donor inode
  * @orig_off:		block offset of original inode
  * @donor_off:		block offset of donor inode
- * @max_count:		the maximun length of extents
+ * @max_count:		the maximum length of extents
  *
  * Return 0 on success, or a negative error value on failure.
  */
@@ -1073,7 +1073,7 @@ mext_check_arguments(struct inode *orig_inode,
 	}

 	if (!*len) {
-		ext4_debug("ext4 move extent: len shoudld not be 0 "
+		ext4_debug("ext4 move extent: len should not be 0 "
 			"[ino:orig %lu, donor %lu]\n", orig_inode->i_ino,
 			donor_inode->i_ino);
 		return -EINVAL;
