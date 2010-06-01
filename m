From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 09/40] ext4: Fix insertion point of extent in mext_insert_across_blocks()
Date: Tue,  1 Jun 2010 08:02:56 -0400
Message-ID: <1275393807-14369-9-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47258 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab0FAMDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:33 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Akira Fujita <a-fujita@rs.jp.nec.com>

commit 5fd5249aa36fad98c9fd5edced352939e54f9324 upstream (as of v2.6.33-git11)

If the leaf node has 2 extent space or fewer and EXT4_IOC_MOVE_EXT
ioctl is called with the file offset where after the 2nd extent
covers, mext_insert_across_blocks() always tries to insert extent into
the first extent.  As a result, the file gets corrupted because of
wrong extent order.  The patch fixes this problem.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/move_extent.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 82c415b..b2b2e67 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -252,6 +252,7 @@ mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,
 		}
 
 		o_start->ee_len = start_ext->ee_len;
+		eblock = le32_to_cpu(start_ext->ee_block);
 		new_flag = 1;
 
 	} else if (start_ext->ee_len && new_ext->ee_len &&
@@ -262,6 +263,7 @@ mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,
 		 * orig  |------------------------------|
 		 */
 		o_start->ee_len = start_ext->ee_len;
+		eblock = le32_to_cpu(start_ext->ee_block);
 		new_flag = 1;
 
 	} else if (!start_ext->ee_len && new_ext->ee_len &&
@@ -502,6 +504,7 @@ mext_leaf_block(handle_t *handle, struct inode *orig_inode,
 		le32_to_cpu(oext->ee_block) + oext_alen) {
 		start_ext.ee_len = cpu_to_le16(le32_to_cpu(new_ext.ee_block) -
 					       le32_to_cpu(oext->ee_block));
+		start_ext.ee_block = oext->ee_block;
 		copy_extent_status(oext, &start_ext);
 	} else if (oext > EXT_FIRST_EXTENT(orig_path[depth].p_hdr)) {
 		prev_ext = oext - 1;
@@ -515,6 +518,7 @@ mext_leaf_block(handle_t *handle, struct inode *orig_inode,
 			start_ext.ee_len = cpu_to_le16(
 				ext4_ext_get_actual_len(prev_ext) +
 				new_ext_alen);
+			start_ext.ee_block = oext->ee_block;
 			copy_extent_status(prev_ext, &start_ext);
 			new_ext.ee_len = 0;
 		}
-- 
1.6.6.1.1.g974db.dirty

