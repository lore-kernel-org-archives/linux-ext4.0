From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH] ext4: do not mark superblock as dirty unnecessarily
Date: Thu, 15 Mar 2012 16:10:02 +0200
Message-ID: <1331820602-20453-1-git-send-email-dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63824 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab2COOJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Mar 2012 10:09:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Commit a0375156ca1041574b5d47cc7e32f10b891151b0 cleaned up superblock dirtying
handling. Although the commit message is vague, this patch seems to do what was
intended: if we have the journal, then we update the superblock through the
journal rather than doing this directly.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/inode.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index feaa82f..e040403 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3924,10 +3924,8 @@ static int ext4_do_update_inode(handle_t *handle,
 			ext4_update_dynamic_rev(sb);
 			EXT4_SET_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
-			sb->s_dirt = 1;
 			ext4_handle_sync(handle);
-			err = ext4_handle_dirty_metadata(handle, NULL,
-					EXT4_SB(sb)->s_sbh);
+			err = ext4_handle_dirty_super(handle, sb);
 		}
 	}
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
-- 
1.7.7.6

