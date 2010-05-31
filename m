From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 07/53] ext4: Ensure zeroout blocks have no dirty metadata
Date: Sun, 30 May 2010 22:49:20 -0400
Message-ID: <1275274206-3900-7-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Curt Wohlgemuth <curtw@google.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44567 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459Ab0EaCuP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:15 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit 515f41c33a9d44a964264c9511ad2c869af1fac3 upstream (as of v2.6.33-rc3)

This fixes a bug (found by Curt Wohlgemuth) in which new blocks
returned from an extent created with ext4_ext_zeroout() can have dirty
metadata still associated with them.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f2effe4..b14fb6d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3029,6 +3029,14 @@ out:
 	return err;
 }
 
+static void unmap_underlying_metadata_blocks(struct block_device *bdev,
+			sector_t block, int count)
+{
+	int i;
+	for (i = 0; i < count; i++)
+                unmap_underlying_metadata(bdev, block + i);
+}
+
 static int
 ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock, unsigned int max_blocks,
@@ -3104,6 +3112,18 @@ out:
 	} else
 		allocated = ret;
 	set_buffer_new(bh_result);
+	/*
+	 * if we allocated more blocks than requested
+	 * we need to make sure we unmap the extra block
+	 * allocated. The actual needed block will get
+	 * unmapped later when we find the buffer_head marked
+	 * new.
+	 */
+	if (allocated > max_blocks) {
+		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
+					newblock + max_blocks,
+					allocated - max_blocks);
+	}
 map_out:
 	set_buffer_mapped(bh_result);
 out1:
-- 
1.6.6.1.1.g974db.dirty

