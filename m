From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Improve credit estimate for EXT4_SINGLEDATA_TRANS_BLOCKS
Date: Tue,  9 Apr 2013 10:34:07 +0200
Message-ID: <1365496448-9907-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab3DIIeM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 04:34:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Estimate of 27 credits for allocation of a block in extent based inode
is unnecessarily high. We can easily argue 20 is enough.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 4c216b1..042e463 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -29,11 +29,13 @@
  * block to complete the transaction.
  *
  * For extents-enabled fs we may have to allocate and modify up to
- * 5 levels of tree + root which are stored in the inode. */
+ * 5 levels of tree, data block (for each of these we need bitmap + group
+ * summaries), root which is stored in the inode, sb
+ */
 
 #define EXT4_SINGLEDATA_TRANS_BLOCKS(sb)				\
 	(EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)   \
-	 ? 27U : 8U)
+	 ? 20U : 8U)
 
 /* Extended attribute operations touch at most two data buffers,
  * two bitmap buffers, and two group summaries, in addition to the inode
-- 
1.7.1

