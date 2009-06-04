From: Artem Bityutskiy <dedekind@infradead.org>
Subject: [PATCH v2 05/17] EXT2: do not manipulate s_dirt directly
Date: Thu,  4 Jun 2009 13:41:42 +0300
Message-ID: <1244112114-23144-6-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
	linux-ext4@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:34056 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbZFDIs4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 04:48:56 -0400
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext2/balloc.c |    4 ++--
 fs/ext2/ialloc.c |    4 ++--
 fs/ext2/super.c  |    8 ++++----
 fs/ext2/xattr.c  |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 7f8d2e5..a3de92b 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -164,7 +164,7 @@ static void release_blocks(struct super_block *sb, int count)
 		struct ext2_sb_info *sbi = EXT2_SB(sb);
 
 		percpu_counter_add(&sbi->s_freeblocks_counter, count);
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 }
 
@@ -179,7 +179,7 @@ static void group_adjust_blocks(struct super_block *sb, int group_no,
 		free_blocks = le16_to_cpu(desc->bg_free_blocks_count);
 		desc->bg_free_blocks_count = cpu_to_le16(free_blocks + count);
 		spin_unlock(sb_bgl_lock(sbi, group_no));
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		mark_buffer_dirty(bh);
 	}
 }
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 15387c9..bb8cf4e 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -81,7 +81,7 @@ static void ext2_release_inode(struct super_block *sb, int group, int dir)
 	spin_unlock(sb_bgl_lock(EXT2_SB(sb), group));
 	if (dir)
 		percpu_counter_dec(&EXT2_SB(sb)->s_dirs_counter);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mark_buffer_dirty(bh);
 }
 
@@ -548,7 +548,7 @@ got:
 	}
 	spin_unlock(sb_bgl_lock(sbi, group));
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mark_buffer_dirty(bh2);
 	inode->i_uid = current_fsuid();
 	if (test_opt (sb, GRPID))
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index f5b7fad..4f054d5 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -116,7 +116,7 @@ static void ext2_put_super (struct super_block * sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		ext2_write_super(sb);
 
 	ext2_xattr_put_super(sb);
@@ -1107,7 +1107,7 @@ static void ext2_commit_super (struct super_block * sb,
 {
 	es->s_wtime = cpu_to_le32(get_seconds());
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 }
 
 static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
@@ -1117,7 +1117,7 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
 	es->s_wtime = cpu_to_le32(get_seconds());
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 }
 
 /*
@@ -1148,7 +1148,7 @@ void ext2_write_super (struct super_block * sb)
 		} else
 			ext2_commit_super (sb, es);
 	}
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	unlock_kernel();
 }
 
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7913531..1673ee4 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -343,7 +343,7 @@ static void ext2_xattr_update_super_block(struct super_block *sb)
 		return;
 
 	EXT2_SET_COMPAT_FEATURE(sb, EXT2_FEATURE_COMPAT_EXT_ATTR);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 }
 
-- 
1.6.0.6

