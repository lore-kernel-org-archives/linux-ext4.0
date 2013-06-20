From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v3] ext4: delete unnecessary C statements
Date: Thu, 20 Jun 2013 15:45:48 -0400
Message-ID: <1371757548-30605-1-git-send-email-tytso@mit.edu>
References: <1371739943-31176-1-git-send-email-tytso@mit.edu>
Cc: jon ernst <jonernst07@gmx.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59901 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161106Ab3FTTp5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 15:45:57 -0400
In-Reply-To: <1371739943-31176-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: jon ernst <jonernst07@gmx.com>

Comparing unsigned variable with 0 always returns false.
err = 0 is duplicated and unnecessary.

[ tytso: Also cleaned up error handling in ext4_block_zero_page_range() ]

Signed-off-by: "Jon Ernst" <jonernst07@gmx.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 78cf398..67963cf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1100,8 +1100,6 @@ static int ext4_write_end(struct file *file,
 	if (i_size_changed)
 		ext4_mark_inode_dirty(handle, inode);
 
-	if (copied < 0)
-		ret = copied;
 	if (pos + len > inode->i_size && ext4_can_truncate(inode))
 		/* if we have allocated more blocks and copied
 		 * less. We will have blocks allocated outside
@@ -3366,13 +3364,10 @@ int ext4_block_zero_page_range(handle_t *handle,
 		iblock++;
 		pos += blocksize;
 	}
-
-	err = 0;
 	if (buffer_freed(bh)) {
 		BUFFER_TRACE(bh, "freed: skip");
 		goto unlock;
 	}
-
 	if (!buffer_mapped(bh)) {
 		BUFFER_TRACE(bh, "unmapped");
 		ext4_get_block(inode, iblock, bh, 0);
@@ -3395,22 +3390,19 @@ int ext4_block_zero_page_range(handle_t *handle,
 		if (!buffer_uptodate(bh))
 			goto unlock;
 	}
-
 	if (ext4_should_journal_data(inode)) {
 		BUFFER_TRACE(bh, "get write access");
 		err = ext4_journal_get_write_access(handle, bh);
 		if (err)
 			goto unlock;
 	}
-
 	zero_user(page, offset, length);
