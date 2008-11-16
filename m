From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 01/20] Update flex_bg free blocks and free inodes counters when resizing.
Date: Sun, 16 Nov 2008 11:05:21 -0500
Message-ID: <1226851540-8032-2-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Frederic Bohe <frederic.bohe@bull.net>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:36956 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753758AbYKPQes (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:34:48 -0500
In-Reply-To: <1226851540-8032-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

This fixes a bug which prevented the newly created inodes after a
resize from being used on filesystems with flex_bg.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit c62a11fd9555007b1caab83b5bcbb443a43e32bb)
---
 fs/ext4/resize.c |    9 +++++++++
 fs/ext4/super.c  |    7 +++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index b3d3560..3922a8b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -929,6 +929,15 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		ext4_group_t flex_group;
+		flex_group = ext4_flex_group(sbi, input->group);
+		sbi->s_flex_groups[flex_group].free_blocks +=
+			input->free_blocks_count;
+		sbi->s_flex_groups[flex_group].free_inodes +=
+			EXT4_INODES_PER_GROUP(sb);
+	}
+
 	ext4_journal_dirty_metadata(handle, sbi->s_sbh);
 	sb->s_dirt = 1;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 566344b..062b7c5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1504,8 +1504,11 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
 	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
 
-	flex_group_count = (sbi->s_groups_count + groups_per_flex - 1) /
-		groups_per_flex;
+	/* We allocate both existing and potentially added groups */
+	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
+			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
+			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
+			   groups_per_flex;
 	sbi->s_flex_groups = kzalloc(flex_group_count *
 				     sizeof(struct flex_groups), GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {
-- 
1.6.0.4.8.g36f27.dirty

