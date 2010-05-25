From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCHv4 01/17] VFS: introduce helpers for the s_dirty flag
Date: Tue, 25 May 2010 16:48:56 +0300
Message-ID: <1274795352-3551-2-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Roman Zippel <zippel@linux-m68k.org>,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	Chris Mason <chris.mason@oracle.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	David Woodhouse <dwmw2@infradead.org>,
	reiserfs-devel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Evgeniy Dushistov <dushistov@mail.ru>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch introduces 3 new VFS helpers: 'mark_sb_dirty()',
'mark_sb_clean()', and 'is_sb_dirty()'. The helpers simply
set 'sb->s_dirt' or test 'sb->s_dirt'. The plan is to make
every FS use these helpers instead of manipulating the
'sb->s_dirt' flag directly.

Ultimately, this change is a preparation for the periodic
superblock synchronization optimization which is about
preventing the "sync_supers" kernel thread from waking up
even if there is nothing to synchronize.

This patch also makes VFS use the new helpers.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Tigran A. Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: reiserfs-devel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
---
 fs/super.c         |    4 ++--
 fs/sync.c          |    2 +-
 include/linux/fs.h |   17 +++++++++++++++++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 69688b1..2b418fb 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -368,12 +368,12 @@ void sync_supers(void)
 	list_for_each_entry_safe(sb, n, &super_blocks, s_list) {
 		if (list_empty(&sb->s_instances))
 			continue;
-		if (sb->s_op->write_super && sb->s_dirt) {
+		if (sb->s_op->write_super && is_sb_dirty(sb)) {
 			sb->s_count++;
 			spin_unlock(&sb_lock);
 
 			down_read(&sb->s_umount);
-			if (sb->s_root && sb->s_dirt)
+			if (sb->s_root && is_sb_dirty(sb))
 				sb->s_op->write_super(sb);
 			up_read(&sb->s_umount);
 
diff --git a/fs/sync.c b/fs/sync.c
index e8cbd41..782e466 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -144,7 +144,7 @@ int file_fsync(struct file *filp, struct dentry *dentry, int datasync)
 
 	/* sync the superblock to buffers */
 	sb = inode->i_sb;
-	if (sb->s_dirt && sb->s_op->write_super)
+	if (is_sb_dirty(sb) && sb->s_op->write_super)
 		sb->s_op->write_super(sb);
 
 	/* .. finally sync the buffers to disk */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b336cb9..21fe2b3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1782,6 +1782,23 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 	struct vfsmount *mnt);
 extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 
+/*
+ * Note, VFS does not provide any serialization for the super block clean/dirty
+ * state changes, file-systems should take care of this.
+ */
+static inline void mark_sb_dirty(struct super_block *sb)
+{
+	sb->s_dirt = 1;
+}
+static inline void mark_sb_clean(struct super_block *sb)
+{
+	sb->s_dirt = 0;
+}
+static inline int is_sb_dirty(struct super_block *sb)
+{
+	return sb->s_dirt;
+}
+
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-- 
1.6.6.1

