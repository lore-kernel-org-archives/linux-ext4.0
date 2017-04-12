From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/11] reiserfs: Remove useless setting of i_flags
Date: Wed, 12 Apr 2017 09:26:09 +0200
Message-ID: <20170412072611.29017-10-jack@suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

reiserfs_new_inode() clears IMMUTABLE and APPEND flags from a symlink
i_flags however a few lines below in sd_attrs_to_i_attrs() we will
happily overwrite i_flags with whatever we inherited from the directory.
Since this behavior is there for ages just remove the useless setting of
i_flags.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/inode.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index a6ab9d64ea1b..aeca1a0b7b5a 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2002,10 +2002,6 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 
 	/* uid and gid must already be set by the caller for quota init */
 
-	/* symlink cannot be immutable or append only, right? */
-	if (S_ISLNK(inode->i_mode))
-		inode->i_flags &= ~(S_IMMUTABLE | S_APPEND);
-
 	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
 	inode->i_size = i_size;
 	inode->i_blocks = 0;
-- 
2.12.0

