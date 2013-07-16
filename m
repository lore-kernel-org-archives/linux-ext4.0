From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/5] ext4: print the block number of invalid extent tree blocks
Date: Tue, 16 Jul 2013 11:18:00 -0400
Message-ID: <1373987883-4466-3-git-send-email-tytso@mit.edu>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38264 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab3GPPSH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Jul 2013 11:18:07 -0400
In-Reply-To: <1373987883-4466-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we find an invalid extent tree block, report the block number of
the bad block for debugging purposes.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index dd422db..ba58815 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -407,7 +407,7 @@ static int ext4_valid_extent_entries(struct inode *inode,
 
 static int __ext4_ext_check(const char *function, unsigned int line,
 			    struct inode *inode, struct ext4_extent_header *eh,
-			    int depth)
+			    int depth, ext4_fsblk_t pblk)
 {
 	const char *error_msg;
 	int max = 0;
@@ -447,21 +447,21 @@ static int __ext4_ext_check(const char *function, unsigned int line,
 
 corrupted:
 	ext4_error_inode(inode, function, line, 0,
-			"bad header/extent: %s - magic %x, "
-			"entries %u, max %u(%u), depth %u(%u)",
-			error_msg, le16_to_cpu(eh->eh_magic),
-			le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max),
-			max, le16_to_cpu(eh->eh_depth), depth);
-
+			 "pblk %llu bad header/extent: %s - magic %x, "
+			 "entries %u, max %u(%u), depth %u(%u)",
+			 (unsigned long long) pblk, error_msg,
+			 le16_to_cpu(eh->eh_magic),
+			 le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max),
+			 max, le16_to_cpu(eh->eh_depth), depth);
 	return -EIO;
 }
 
-#define ext4_ext_check(inode, eh, depth)	\
-	__ext4_ext_check(__func__, __LINE__, inode, eh, depth)
+#define ext4_ext_check(inode, eh, depth, pblk)			\
+	__ext4_ext_check(__func__, __LINE__, (inode), (eh), (depth), (pblk))
 
 int ext4_ext_check_inode(struct inode *inode)
 {
-	return ext4_ext_check(inode, ext_inode_hdr(inode), ext_depth(inode));
+	return ext4_ext_check(inode, ext_inode_hdr(inode), ext_depth(inode), 0);
 }
 
 static struct buffer_head *
@@ -484,7 +484,7 @@ __read_extent_tree_block(const char *function, unsigned int line,
 	if (buffer_verified(bh))
 		return bh;
 	err = __ext4_ext_check(function, line, inode,
-			       ext_block_hdr(bh), depth);
+			       ext_block_hdr(bh), depth, pblk);
 	if (err)
 		goto errout;
 	set_buffer_verified(bh);
@@ -2775,7 +2775,7 @@ again:
 		path[0].p_hdr = ext_inode_hdr(inode);
 		i = 0;
 
-		if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
+		if (ext4_ext_check(inode, path[0].p_hdr, depth, 0)) {
 			err = -EIO;
 			goto out;
 		}
-- 
1.7.12.rc0.22.gcdd159b

