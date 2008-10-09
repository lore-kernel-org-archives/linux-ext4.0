From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 17/42] Update flex_bg free blocks and free inodes counters when resizing.
Date: Thu,  9 Oct 2008 00:05:35 -0400
Message-ID: <1223525160-9887-18-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
 <1223525160-9887-13-git-send-email-tytso@mit.edu>
 <1223525160-9887-14-git-send-email-tytso@mit.edu>
 <1223525160-9887-15-git-send-email-tytso@mit.edu>
 <1223525160-9887-16-git-send-email-tytso@mit.edu>
 <1223525160-9887-17-git-send-email-tytso@mit.edu>
Cc: Frederic Bohe <frederic.bohe@bull.net>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54504 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757587AbYJIEGM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:12 -0400
In-Reply-To: <1223525160-9887-17-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

This fixes a bug which prevented the newly created inodes after a
resize from being used on filesystems with flex_bg.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |    9 +++++++++
 fs/ext4/super.c  |    7 +++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 4392e3f..b60afbc 100644
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
index efa40d9..f58cc03 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1507,8 +1507,11 @@ static int ext4_fill_flex_info(struct super_block *sb)
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
1.5.6.1.205.ge2c7.dirty

