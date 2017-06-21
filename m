From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 07/32] ext4: call journal revoke when freeing ea_inode blocks
Date: Wed, 21 Jun 2017 14:21:17 -0700
Message-ID: <20170621212142.16581-7-tahsin@google.com>
References: <20170621212142.16581-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:34499 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752571AbdFUVWE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jun 2017 17:22:04 -0400
Received: by mail-pg0-f43.google.com with SMTP id e187so29804611pgc.1
        for <linux-ext4@vger.kernel.org>; Wed, 21 Jun 2017 14:22:04 -0700 (PDT)
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ea_inode contents are treated as metadata, that's why it is journaled
during initial writes. Failing to call revoke during freeing could cause
user data to be overwritten with original ea_inode contents during journal
replay.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/extents.c  | 3 ++-
 fs/ext4/indirect.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3e36508610b7..e0a8425ff74d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2488,7 +2488,8 @@ int ext4_ext_index_trans_blocks(struct inode *inode, int extents)
 
 static inline int get_default_free_blocks_flags(struct inode *inode)
 {
-	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
+	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode) ||
+	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE))
 		return EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET;
 	else if (ext4_should_journal_data(inode))
 		return EXT4_FREE_BLOCKS_FORGET;
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index bc15c2c17633..7ffa290cbb8e 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -829,7 +829,8 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
 	int	flags = EXT4_FREE_BLOCKS_VALIDATED;
 	int	err;
 
-	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
+	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode) ||
+	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE))
 		flags |= EXT4_FREE_BLOCKS_FORGET | EXT4_FREE_BLOCKS_METADATA;
 	else if (ext4_should_journal_data(inode))
 		flags |= EXT4_FREE_BLOCKS_FORGET;
-- 
2.13.1.611.g7e3b11ae1-goog
