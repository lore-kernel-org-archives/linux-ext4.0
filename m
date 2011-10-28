From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/7] ext4: Restore old EOFBLOCKS flag state after error
Date: Fri, 28 Oct 2011 21:00:04 +0400
Message-ID: <1319821210-7374-2-git-send-email-dmonakhov@openvz.org>
References: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Cc: achender@linux.vnet.ibm.com, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64725 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab1J1RAS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 13:00:18 -0400
Received: by bkbzt4 with SMTP id zt4so624053bkb.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 10:00:17 -0700 (PDT)
In-Reply-To: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_insert_extent() may fail due to number of reasons (ENOSPC),
restore it's state before exit.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61abc13..eae9680 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3723,6 +3723,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t newblock = 0;
 	int free_on_err = 0, err = 0, depth, ret;
+	int eof_fl = 0;
 	unsigned int allocated = 0, offset = 0;
 	unsigned int allocated_clusters = 0, reserved_clusters = 0;
 	unsigned int punched_out = 0;
@@ -4056,9 +4057,11 @@ got_allocated_blocks:
 	}
 
 	err = 0;
-	if ((flags & EXT4_GET_BLOCKS_KEEP_SIZE) == 0)
+	if ((flags & EXT4_GET_BLOCKS_KEEP_SIZE) == 0) {
+		eof_fl = ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
 		err = check_eofblocks_fl(handle, inode, map->m_lblk,
 					 path, ar.len);
+	}
 	if (!err)
 		err = ext4_ext_insert_extent(handle, inode, path,
 					     &newex, flags);
@@ -4071,6 +4074,12 @@ got_allocated_blocks:
 		ext4_discard_preallocations(inode);
 		ext4_free_blocks(handle, inode, NULL, ext4_ext_pblock(&newex),
 				 ext4_ext_get_actual_len(&newex), fb_flags);
+		/* Restore EOFBLOCKS flag state */
+		if (eof_fl &&
+		    !ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)) {
+			ext4_set_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
+			ext4_mark_inode_dirty(handle, inode);
+		}
 		goto out2;
 	}
 
-- 
1.7.1

