From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Remove EXT4_STATE_ORDERED_MODE
Date: Mon, 11 Jan 2016 11:23:50 +0100
Message-ID: <1452507830-8574-2-git-send-email-jack@suse.cz>
References: <1452507830-8574-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	"HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759055AbcAKKXq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jan 2016 05:23:46 -0500
In-Reply-To: <1452507830-8574-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This flag is just duplicating what ext4_should_order_data() tells you
and is used in a single place. Furthermore it doesn't reflect changes to
inode data journalling flag so it may be possibly misleading. Just
remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  | 1 -
 fs/ext4/inode.c | 5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1e20fa94fcf6..bc4910bce4ff 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1489,7 +1489,6 @@ enum {
 	EXT4_STATE_DIOREAD_LOCK,	/* Disable support for dio read
 					   nolocking */
 	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */
-	EXT4_STATE_ORDERED_MODE,	/* data=ordered mode */
 	EXT4_STATE_EXT_PRECACHED,	/* extents have been precached */
 };
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b216a3eb41a8..173da9d467d1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3444,10 +3444,7 @@ void ext4_set_aops(struct inode *inode)
 {
 	switch (ext4_inode_journal_mode(inode)) {
 	case EXT4_INODE_ORDERED_DATA_MODE:
-		ext4_set_inode_state(inode, EXT4_STATE_ORDERED_MODE);
-		break;
 	case EXT4_INODE_WRITEBACK_DATA_MODE:
-		ext4_clear_inode_state(inode, EXT4_STATE_ORDERED_MODE);
 		break;
 	case EXT4_INODE_JOURNAL_DATA_MODE:
 		inode->i_mapping->a_ops = &ext4_journalled_aops;
@@ -3540,7 +3537,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	} else {
 		err = 0;
 		mark_buffer_dirty(bh);
-		if (ext4_test_inode_state(inode, EXT4_STATE_ORDERED_MODE))
+		if (ext4_should_order_data(inode))
 			err = ext4_jbd2_file_inode(handle, inode);
 	}
 
-- 
2.6.2

