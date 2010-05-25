From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext4: Clear the EXT4_EOFBLOCKS_FL flag only when warranted
Date: Tue, 25 May 2010 00:18:37 -0400
Message-ID: <1274761117-26560-2-git-send-email-tytso@mit.edu>
References: <20100525041737.GB5556@thunk.org>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49555 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab0EYESj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 00:18:39 -0400
In-Reply-To: <20100525041737.GB5556@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
 fs/ext4/extents.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index aeec5c7..c7c304f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3319,7 +3319,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_extent_header *eh;
 	struct ext4_extent newex, *ex, *last_ex;
 	ext4_fsblk_t newblock;
-	int err = 0, depth, ret, cache_type;
+	int i, err = 0, depth, ret, cache_type;
 	unsigned int allocated = 0;
 	struct ext4_allocation_request ar;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
@@ -3508,8 +3508,20 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			goto out2;
 		}
 		last_ex = EXT_LAST_EXTENT(eh);
-		if (map->m_lblk + ar.len > le32_to_cpu(last_ex->ee_block)
-		    + ext4_ext_get_actual_len(last_ex))
+		/*
+		 * If the current leaf block was reached by looking at
+		 * the last index block all the way down the tree, and
+		 * we are extending the inode beyond the last extent
+		 * in the current leaf block, then clear the
+		 * EOFBLOCKS_FL flag.
+		 */
+		for (i=depth-1; i >= 0; i--) {
+			if (path[i].p_idx != EXT_LAST_INDEX(path[i].p_hdr))
+				break;
+		}
+		if ((i < 0) &&
+		    (map->m_lblk + ar.len > le32_to_cpu(last_ex->ee_block) + 
+		     ext4_ext_get_actual_len(last_ex)))
 			ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
 	}
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
-- 
1.6.6.1.1.g974db.dirty

