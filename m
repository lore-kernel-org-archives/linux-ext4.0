From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 21/24] ext4: Fix sub-block zeroing for writes into preallocated extents
Date: Tue,  2 Jun 2009 08:09:33 -0400
Message-ID: <1243944576-20915-21-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
 <1243944576-20915-5-git-send-email-tytso@mit.edu>
 <1243944576-20915-6-git-send-email-tytso@mit.edu>
 <1243944576-20915-7-git-send-email-tytso@mit.edu>
 <1243944576-20915-8-git-send-email-tytso@mit.edu>
 <1243944576-20915-9-git-send-email-tytso@mit.edu>
 <1243944576-20915-10-git-send-email-tytso@mit.edu>
 <1243944576-20915-11-git-send-email-tytso@mit.edu>
 <1243944576-20915-12-git-send-email-tytso@mit.edu>
 <1243944576-20915-13-git-send-email-tytso@mit.edu>
 <1243944576-20915-14-git-send-email-tytso@mit.edu>
 <1243944576-20915-15-git-send-email-tytso@mit.edu>
 <1243944576-20915-16-git-send-email-tytso@mit.edu>
 <1243944576-20915-17-git-send-email-tytso@mit.edu>
 <1243944576-20915-18-git-send-email-tytso@mit.edu>
 <1243944576-20915-19-git-send-email-tytso@mit.edu>
 <1243944576-20915-20-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59287 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbZFBMJs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:48 -0400
In-Reply-To: <1243944576-20915-20-git-send-email-tytso@mit.edu>
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
index acb98c9..067cbc0 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2670,6 +2670,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 				if (allocated > max_blocks)
 					allocated = max_blocks;
 				set_buffer_unwritten(bh_result);
+				bh_result->b_bdev = inode->i_sb->s_bdev;
+				bh_result->b_blocknr = newblock;
 				goto out2;
 			}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0768859..537a4b6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2131,6 +2131,13 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
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

