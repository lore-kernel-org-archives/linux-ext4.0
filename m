From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH] ext4: write superblock only once on unmount
Date: Mon, 19 Mar 2012 14:50:34 +0200
Message-ID: <1332161434-1301-1-git-send-email-dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

In some rather rare cases it is possible that ext4 may the superblock to the
media twice. This patch makes sure this does not happen. This should speed up
unmounting in those cases.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/super.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 502c61f..c1f5111 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -808,9 +808,6 @@ static void ext4_put_super(struct super_block *sb)
 	destroy_workqueue(sbi->dio_unwritten_wq);
 
 	lock_super(sb);
-	if (sb->s_dirt)
-		ext4_commit_super(sb, 1);
-
 	if (sbi->s_journal) {
 		err = jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
@@ -827,8 +824,10 @@ static void ext4_put_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
-		ext4_commit_super(sb, 1);
 	}
+	if (sb->s_dirt || !(sb->s_flags & MS_RDONLY))
+		ext4_commit_super(sb, 1);
+
 	if (sbi->s_proc) {
 		remove_proc_entry(sb->s_id, ext4_proc_root);
 	}
-- 
1.7.7.6

