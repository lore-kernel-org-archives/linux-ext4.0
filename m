From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 4/7] ext2: Fold ext2_commit_super() into ext2_sync_super()
Date: Wed, 14 Apr 2010 14:38:36 +0200
Message-ID: <1271248719-21488-5-git-send-email-jblunck@suse.de>
References: <1271248719-21488-1-git-send-email-jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1271248719-21488-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Both function originally did similar things except that ext2_sync_super()
is returning after the call to sync_dirty_buffer(sbh). Therefore this
patch adds a wait flag to tell ext2_sync_super() if it has to call
sync_dirty_buffer() to wait for in-progress I/O to finish.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext2/super.c |   28 +++++++++-------------------
 1 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 09a88bf..a304c54 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -39,7 +39,7 @@
 #include "xip.h"
 
 static void ext2_sync_super(struct super_block *sb,
-			    struct ext2_super_block *es);
+			    struct ext2_super_block *es, int wait);
 static int ext2_remount (struct super_block * sb, int * flags, char * data);
 static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf);
 static int ext2_sync_fs(struct super_block *sb, int wait);
@@ -54,7 +54,7 @@ void ext2_error (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		sbi->s_mount_state |= EXT2_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
-		ext2_sync_super(sb, es);
+		ext2_sync_super(sb, es, 1);
 	}
 
 	va_start(args, fmt);
@@ -125,7 +125,7 @@ static void ext2_put_super (struct super_block * sb)
 		struct ext2_super_block *es = sbi->s_es;
 
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
-		ext2_sync_super(sb, es);
+		ext2_sync_super(sb, es, 1);
 	}
 	db_count = sbi->s_gdb_count;
 	for (i = 0; i < db_count; i++)
@@ -1127,23 +1127,16 @@ static void ext2_clear_super_error(struct super_block *sb)
 	}
 }
 
-static void ext2_commit_super (struct super_block * sb,
-			       struct ext2_super_block * es)
-{
-	ext2_clear_super_error(sb);
-	es->s_wtime = cpu_to_le32(get_seconds());
-	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
-	sb->s_dirt = 0;
-}
-
-static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
+static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
+			    int wait)
 {
 	ext2_clear_super_error(sb);
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 	es->s_wtime = cpu_to_le32(get_seconds());
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
-	sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
+	if (wait)
+		sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
 	sb->s_dirt = 0;
 }
 
@@ -1166,11 +1159,8 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 		ext2_debug("setting valid to 0\n");
 		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
-		ext2_sync_super(sb, es);
-	} else {
-		ext2_commit_super(sb, es);
 	}
-	sb->s_dirt = 0;
+	ext2_sync_super(sb, es, wait);
 	unlock_kernel();
 
 	return 0;
@@ -1268,7 +1258,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		if (!ext2_setup_super (sb, es, 0))
 			sb->s_flags &= ~MS_RDONLY;
 	}
-	ext2_sync_super(sb, es);
+	ext2_sync_super(sb, es, 1);
 	unlock_kernel();
 	return 0;
 restore_opts:
-- 
1.6.4.2
