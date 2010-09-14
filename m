From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext3: Accept in-inode xattrs for reserved inodes
Date: Tue, 14 Sep 2010 14:32:46 +0200
Message-ID: <1284467566-12661-3-git-send-email-jack@suse.cz>
References: <1284467566-12661-1-git-send-email-jack@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab0INMdv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Sep 2010 08:33:51 -0400
In-Reply-To: <1284467566-12661-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So far we just ignore any in-inode xattrs in reserved inodes (with inode
number <= EXT3_FIRST_INO + 1) to workaround a bug in old mke2fs (<= 1.37)
which forgot to zero such inodes when inode size was greater than
EXT3_GOOD_OLD_INODE_SIZE. This kernel behavior prevents us from ever
using in-inode xattrs for such inodes because they would be ignored by
older kernels.

So make kernel accept data in extended inode space even for reserved inodes
if they look sane but never store data there. This way, we can remove all
the special cases once kernels without this handling are old enough.

CC: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   37 ++++++++++++++++++++++++-------------
 1 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5e0faf4..1f3e83f 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2914,24 +2914,35 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 		atomic_set(&ei->i_datasync_tid, tid);
 	}
 
-	if (inode->i_ino >= EXT3_FIRST_INO(inode->i_sb) + 1 &&
-	    EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
-		/*
-		 * When mke2fs creates big inodes it does not zero out
-		 * the unused bytes above EXT3_GOOD_OLD_INODE_SIZE,
-		 * so ignore those first few inodes.
-		 */
+	if (EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT3_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
 		    EXT3_INODE_SIZE(inode->i_sb)) {
-			brelse (bh);
-			ret = -EIO;
-			goto bad_inode;
+			/*
+			 * Old mke2fs (<= 1.37) did not zero i_extra_size for
+			 * large reserved inodes. So just ignore bogus
+			 * i_extra_size for these inodes.
+			 */
+			if (inode->i_ino >= EXT3_FIRST_INO(inode->i_sb) + 1) {
+				brelse (bh);
+				ret = -EIO;
+				goto bad_inode;
+			}
+			ei->i_extra_isize = 0;
 		}
 		if (ei->i_extra_isize == 0) {
-			/* The extra space is currently unused. Use it. */
-			ei->i_extra_isize = sizeof(struct ext3_inode) -
-					    EXT3_GOOD_OLD_INODE_SIZE;
+			/*
+			 * We cannot use free space for reserved inodes because
+			 * old kernels (until 2.6.36) would just ignore xattrs
+			 * in that space. This workaround can be removed if we
+			 * ever deem that mounting a filesystem with an old
+			 * kernel is unlikely enough.
+			 */
+			if (inode->i_ino >= EXT3_FIRST_INO(inode->i_sb) + 1) {
+				/* The extra space is unused. Use it. */
+				ei->i_extra_isize = sizeof(struct ext3_inode) -
+						    EXT3_GOOD_OLD_INODE_SIZE;
+			}
 		} else {
 			__le32 *magic = (void *)raw_inode +
 					EXT3_GOOD_OLD_INODE_SIZE +
-- 
1.6.4.2

