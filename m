From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 36/40] ext4: Clear the EXT4_EOFBLOCKS_FL flag only when warranted
Date: Tue,  1 Jun 2010 08:03:23 -0400
Message-ID: <1275393807-14369-36-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47260 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab0FAMDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:33 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit 786ec7915e530936b9eb2e3d12274145cab7aa7d upstream (as of v2.6.34-git13)

Dimitry Monakhov discovered an edge case where it was possible for the
EXT4_EOFBLOCKS_FL flag could get cleared unnecessarily.  This is true;
I have a test case that can be exercised via downloading and
decompressing the file:

wget ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-testcases/eofblocks-fl-test-case.img.bz2
bunzip2 eofblocks-fl-test-case.img
dd if=/dev/zero of=eofblocks-fl-test-case.img bs=1k seek=17925 bs=1k count=1 conv=notrunc

However, triggering it in real life is highly unlikely since it
requires an extremely fragmented sparse file with a hole in exactly
the right place in the extent tree.  (It actually took quite a bit of
work to generate this test case.)  Still, it's nice to get even
extreme corner cases to be correct, so this patch makes sure that we
don't clear the EXT4_EOFBLOCKS_FL incorrectly even in this corner
case.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e2d9bfb..799416f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3223,7 +3223,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_extent_header *eh;
 	struct ext4_extent newex, *ex, *last_ex;
 	ext4_fsblk_t newblock;
-	int err = 0, depth, ret, cache_type;
+	int i, err = 0, depth, ret, cache_type;
 	unsigned int allocated = 0;
 	struct ext4_allocation_request ar;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
@@ -3404,19 +3404,29 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	if (unlikely(ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))) {
-		if (eh->eh_entries) {
-			last_ex = EXT_LAST_EXTENT(eh);
-			if (iblock + ar.len > le32_to_cpu(last_ex->ee_block)
-					    + ext4_ext_get_actual_len(last_ex))
-				ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
-		} else {
-			WARN_ON(eh->eh_entries == 0);
+		if (unlikely(!eh->eh_entries)) {
 			ext4_error(inode->i_sb, __func__,
 				   "inode#%lu, eh->eh_entries = 0 and "
 				   "EOFBLOCKS_FL set", inode->i_ino);
 			err = -EIO;
 			goto out2;
 		}
+		last_ex = EXT_LAST_EXTENT(eh);
+		/*
+		 * If the current leaf block was reached by looking at
+		 * the last index block all the way down the tree, and
+		 * we are extending the inode beyond the last extent
+		 * in the current leaf block, then clear the
+		 * EOFBLOCKS_FL flag.
+		 */
+		for (i = depth-1; i >= 0; i--) {
+			if (path[i].p_idx != EXT_LAST_INDEX(path[i].p_hdr))
+				break;
+		}
+		if ((i < 0) &&
+		    (iblock + ar.len > le32_to_cpu(last_ex->ee_block) +
+		     ext4_ext_get_actual_len(last_ex)))
+			ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
 	}
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
-- 
1.6.6.1.1.g974db.dirty

