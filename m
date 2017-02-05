From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/7] ext4: preserve the needs_recovery flag when the journal is aborted
Date: Sun,  5 Feb 2017 02:34:26 -0500
Message-ID: <20170205073430.9109-3-tytso@mit.edu>
References: <20170205073430.9109-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170205073430.9109-1-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If the journal is aborted, the needs_recovery feature flag should not
be removed.  Otherwise, it's the journal might not get replayed and
this could lead to more data getting lost.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 829e4a7b59e4..3fef82e79131 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -825,6 +825,7 @@ static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
+	int aborted = 0;
 	int i, err;
 
 	ext4_unregister_li_request(sb);
@@ -834,9 +835,10 @@ static void ext4_put_super(struct super_block *sb)
 	destroy_workqueue(sbi->rsv_conversion_wq);
 
 	if (sbi->s_journal) {
+		aborted = is_journal_aborted(sbi->s_journal);
 		err = jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
-		if (err < 0)
+		if ((err < 0) && !aborted)
 			ext4_abort(sb, "Couldn't clean up the journal");
 	}
 
@@ -847,7 +849,7 @@ static void ext4_put_super(struct super_block *sb)
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
 
-	if (!(sb->s_flags & MS_RDONLY)) {
+	if (!(sb->s_flags & MS_RDONLY) && !aborted) {
 		ext4_clear_feature_journal_needs_recovery(sb);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
 	}
-- 
2.11.0.rc0.7.gbe5a750
