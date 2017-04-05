From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Call dquot_writeback_dquots() with s_umount held
Date: Wed,  5 Apr 2017 14:33:46 +0200
Message-ID: <20170405123346.757-1-jack@suse.cz>
Cc: Jan Beulich <jbeulich@suse.com>, Jan Kara <jack@suse.cz>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933001AbdDEMdv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 5 Apr 2017 08:33:51 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 68C4FAC8A
        for <linux-ext4@vger.kernel.org>; Wed,  5 Apr 2017 12:33:50 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2_sync_fs() could be called without s_umount semaphore held when
called through ext2_write_super() from __ext2_write_inode(). This
function then calls dquot_writeback_dquots() which relies on s_umount to
be held for protection against other quota operations.

In fact __ext2_write_inode() does not need all the functionality
ext2_write_super() provides. It is enough to just write the superblock.
So use ext2_sync_super() instead.

Fixes: 9d1ccbe70e0b14545caad12dc73adb3605447df0
Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/ext2.h  | 3 ++-
 fs/ext2/inode.c | 2 +-
 fs/ext2/super.c | 9 ++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

I have queued this patch into my tree and will send it to Linus in the coming
merge window unless someone objects.

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 5e64de9c5093..dca3604b9970 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -796,7 +796,8 @@ void ext2_error(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
 void ext2_msg(struct super_block *, const char *, const char *, ...);
 extern void ext2_update_dynamic_rev (struct super_block *sb);
-extern void ext2_write_super (struct super_block *);
+extern void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
+			    int wait);
 
 /*
  * Inodes and files operations
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 128cce540645..4d3e2528ac17 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1615,7 +1615,7 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 				EXT2_SET_RO_COMPAT_FEATURE(sb,
 					EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
 				spin_unlock(&EXT2_SB(sb)->s_lock);
-				ext2_write_super(sb);
+				ext2_sync_super(sb, EXT2_SB(sb)->s_es, 1);
 			}
 		}
 	}
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 9e25a71fe1a2..b3090416a936 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -36,8 +36,7 @@
 #include "xattr.h"
 #include "acl.h"
 
-static void ext2_sync_super(struct super_block *sb,
-			    struct ext2_super_block *es, int wait);
+static void ext2_write_super(struct super_block *sb);
 static int ext2_remount (struct super_block * sb, int * flags, char * data);
 static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf);
 static int ext2_sync_fs(struct super_block *sb, int wait);
@@ -1194,8 +1193,8 @@ static void ext2_clear_super_error(struct super_block *sb)
 	}
 }
 
-static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
-			    int wait)
+void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
+		     int wait)
 {
 	ext2_clear_super_error(sb);
 	spin_lock(&EXT2_SB(sb)->s_lock);
@@ -1270,7 +1269,7 @@ static int ext2_unfreeze(struct super_block *sb)
 	return 0;
 }
 
-void ext2_write_super(struct super_block *sb)
+static void ext2_write_super(struct super_block *sb)
 {
 	if (!(sb->s_flags & MS_RDONLY))
 		ext2_sync_fs(sb, 1);
-- 
2.10.2
