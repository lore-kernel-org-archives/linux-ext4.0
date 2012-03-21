From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH 6/8] ext2: stop using VFS for dirty superblock management
Date: Wed, 21 Mar 2012 18:14:33 +0200
Message-ID: <1332346475-1441-7-git-send-email-dedekind1@gmail.com>
References: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Do not use VFS for managing dirty superblock but do it inside ext2. Remove the
'->write_super()' VFS callback and instead, schedule a delayed work when the
superblock is marked as dirty.

We add memory barriers to make sure the 's_dirt' flag changes are visible to
other CPUs as soon as possible to avoid queuing unnecessary works.

Note: the final goal is to get rid of the 'sync_supers()' kernel thread which
wakes up every 5 seconds and even if there is nothing to do. Thus, we are
pushing superblock management from VFS down to file-systems.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext2/super.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 80ffd22..95dc25f 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -305,7 +305,6 @@ static const struct super_operations ext2_sops = {
 	.write_inode	= ext2_write_inode,
 	.evict_inode	= ext2_evict_inode,
 	.put_super	= ext2_put_super,
-	.write_super	= ext2_write_super,
 	.sync_fs	= ext2_sync_fs,
 	.statfs		= ext2_statfs,
 	.remount_fs	= ext2_remount,
@@ -1161,6 +1160,13 @@ static void ext2_clear_super_error(struct super_block *sb)
 static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 			    int wait)
 {
+	sb->s_dirt = 0;
+	/*
+	 * Make sure we first mark the superblock as clean and then start
+	 * writing it out.
+	 */
+	smp_wmb();
+
 	ext2_clear_super_error(sb);
 	spin_lock(&EXT2_SB(sb)->s_lock);
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
@@ -1171,7 +1177,6 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	if (wait)
 		sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
-	sb->s_dirt = 0;
 }
 
 /*
@@ -1201,18 +1206,72 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	return 0;
 }
 
-
 void ext2_write_super(struct super_block *sb)
 {
 	if (!(sb->s_flags & MS_RDONLY))
 		ext2_sync_fs(sb, 1);
-	else
+	else {
 		sb->s_dirt = 0;
+		smp_wmb();
+	}
+}
+
+struct sb_delayed_work {
+	struct delayed_work dwork;
+	struct super_block *sb;
+};
+
+static struct sb_delayed_work *work_to_sbwork(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+
+	dwork = container_of(work, struct delayed_work, work);
+	return container_of(dwork, struct sb_delayed_work, dwork);
+}
+
+static void write_super(struct work_struct *work)
+{
+	struct sb_delayed_work *sbwork = work_to_sbwork(work);
+	struct super_block *sb = sbwork->sb;
+
+	kfree(sbwork);
+
+	smp_rmb();
+	if (sb->s_dirt)
+		return;
+
+	ext2_write_super(sb);
 }
 
 void ext2_mark_super_dirty(struct super_block *sb)
 {
+	struct ext2_sb_info *sbi = EXT2_SB(sb);
+	struct sb_delayed_work *sbwork;
+	unsigned long delay;
+
+	/* Make sure we see 's_dirt' changes ASAP */
+	smp_rmb();
+	if (sb->s_dirt == 1)
+		return;
 	sb->s_dirt = 1;
+	/* Make other CPUs see the 's_dirt' change as soon as possible */
+	smp_wmb();
+
+	sbwork = kmalloc(sizeof(struct sb_delayed_work), GFP_NOFS);
+	if (!sbwork) {
+		/*
+		 * Well, should not be a big deal - the system must be in
+		 * trouble anyway, and the SB will be written out on unmount or
+		 * we may be luckier next time it is marked as dirty.
+		 */
+		sb->s_dirt = 2;
+		return;
+	}
+
+	INIT_DELAYED_WORK(&sbwork->dwork, write_super);
+	sbwork->sb = sb;
+	delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+	queue_delayed_work(sbi->sync_super_wq, &sbwork->dwork, delay);
 }
 
 static int ext2_remount (struct super_block * sb, int * flags, char * data)
-- 
1.7.7.6
