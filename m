From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 01/10] ext4: balloc: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:42:56 +0530
Message-ID: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52709 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2JPTNY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2012 15:13:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixed checkpatch.pl reported ERRORs

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/balloc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/balloc.c b/linux-3.7-rc1/fs/ext4/balloc.c
index 1b50890..395418d 100644
--- a/linux-3.7-rc1/fs/ext4/balloc.c
+++ b/linux-3.7-rc1/fs/ext4/balloc.c
@@ -246,7 +246,7 @@ unsigned ext4_free_clusters_after_init(struct super_block *sb,
  * @bh:			pointer to the buffer head to store the block
  *			group descriptor
  */
-struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
+struct ext4_group_desc *ext4_get_group_desc(struct super_block *sb,
 					     ext4_group_t block_group,
 					     struct buffer_head **bh)
 {
@@ -700,7 +700,7 @@ static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb,
 	if (!ext4_bg_has_super(sb, group))
 		return 0;
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG))
 		return le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
 	else
 		return EXT4_SB(sb)->s_gdb_count;
@@ -721,11 +721,11 @@ unsigned long ext4_bg_num_gdb(struct super_block *sb, ext4_group_t group)
 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
 	unsigned long metagroup = group / EXT4_DESC_PER_BLOCK(sb);
 
-	if (!EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG) ||
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG) ||
 			metagroup < first_meta_bg)
 		return ext4_bg_num_gdb_nometa(sb, group);
 
-	return ext4_bg_num_gdb_meta(sb,group);
+	return ext4_bg_num_gdb_meta(sb, group);
 
 }
 
-- 
1.7.7.3

