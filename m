From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.29 15/18] ext4: Fix sub-block zeroing for writes into preallocated extents
Date: Tue,  2 Jun 2009 08:07:56 -0400
Message-ID: <1243944479-20574-15-git-send-email-tytso@mit.edu>
References: <1243944479-20574-1-git-send-email-tytso@mit.edu>
 <1243944479-20574-2-git-send-email-tytso@mit.edu>
 <1243944479-20574-3-git-send-email-tytso@mit.edu>
 <1243944479-20574-4-git-send-email-tytso@mit.edu>
 <1243944479-20574-5-git-send-email-tytso@mit.edu>
 <1243944479-20574-6-git-send-email-tytso@mit.edu>
 <1243944479-20574-7-git-send-email-tytso@mit.edu>
 <1243944479-20574-8-git-send-email-tytso@mit.edu>
 <1243944479-20574-9-git-send-email-tytso@mit.edu>
 <1243944479-20574-10-git-send-email-tytso@mit.edu>
 <1243944479-20574-11-git-send-email-tytso@mit.edu>
 <1243944479-20574-12-git-send-email-tytso@mit.edu>
 <1243944479-20574-13-git-send-email-tytso@mit.edu>
 <1243944479-20574-14-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33544 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbZFBMIL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:08:11 -0400
In-Reply-To: <1243944479-20574-14-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We need to mark the buffer_head mapping preallocated space as new
during write_begin. Otherwise we don't zero out the page cache content
properly for a partial write. This will cause file corruption with
preallocation.

Now that we mark the buffer_head new we also need to have a valid
buffer_head blocknr so that unmap_underlying_metadata() unmaps the
correct block.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 9c1ee184a30394e54165fa4c15923cabd952c106)
---
 fs/ext4/extents.c |    2 ++
 fs/ext4/inode.c   |    7 +++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e0aa4fe..6af5a50 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2776,6 +2776,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 				if (allocated > max_blocks)
 					allocated = max_blocks;
 				set_buffer_unwritten(bh_result);
+				bh_result->b_bdev = inode->i_sb->s_bdev;
+				bh_result->b_blocknr = newblock;
 				goto out2;
 			}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cf65a83..2caeda7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2246,6 +2246,13 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
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
1.6.3.1.1.g75fc.dirty

