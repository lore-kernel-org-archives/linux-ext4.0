From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/6] ext4: Fix sub-block zeroing for writes into preallocated extents
Date: Tue, 12 May 2009 18:45:22 -0400
Message-ID: <1242168327-31127-2-git-send-email-tytso@mit.edu>
References: <1242168327-31127-1-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44245 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZELWpa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2009 18:45:30 -0400
In-Reply-To: <1242168327-31127-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We need to mark the buffer_head mapping preallocated space as new
during write_begin. Otherwise we don't zero out the page cache content
properly for a partial write. This will cause file corruption with
preallocation.

Now that we mark the buffer_head new we also need to have a valid
buffer_head blocknr so that unmap_underlying_metadata unmap the
right block.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    2 ++
 fs/ext4/inode.c   |    7 +++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e403321..172656c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2875,6 +2875,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 				if (allocated > max_blocks)
 					allocated = max_blocks;
 				set_buffer_unwritten(bh_result);
+				bh_result->b_bdev = inode->i_sb->s_bdev;
+				bh_result->b_blocknr = newblock;
 				goto out2;
 			}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e91f978..d4b634a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2323,6 +2323,13 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
+		/*
+		 * With sub-block writes into unwritten extents
+		 * we also need to mark the buffer as new so that
+		 * the unwritten parts of the buffer gets correctly zeroed.
+		 */
+		if (buffer_unwritten(bh_result))
+			set_buffer_new(bh_result);
 		ret = 0;
 	}
 
-- 
1.6.3.rc4.1.g3e14.dirty

