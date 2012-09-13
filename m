From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 8/9] ext4: log a resize update to the console every 10 seconds
Date: Thu, 13 Sep 2012 18:49:15 -0400
Message-ID: <1347576556-5725-9-git-send-email-tytso@mit.edu>
References: <1347576556-5725-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50589 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab2IMXGQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 19:06:16 -0400
In-Reply-To: <1347576556-5725-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For very long online resizes, a periodic update to the console log is
helpful for debugging and for progress reporting.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 5932ab5..3c9367b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1869,6 +1869,7 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 	ext4_group_t n_group;
 	ext4_fsblk_t o_blocks_count;
 	ext4_fsblk_t n_blocks_count_retry = 0;
+	unsigned long last_update_time = 0;
 	int err = 0, flexbg_size = 1 << sbi->s_log_groups_per_flex;
 	int meta_bg;
 
@@ -1977,6 +1978,13 @@ retry:
 	 */
 	while (ext4_setup_next_flex_gd(sb, flex_gd, n_blocks_count,
 					      flexbg_size)) {
+		if (jiffies - last_update_time > HZ * 10) {
+			if (last_update_time)
+				ext4_msg(sb, KERN_INFO,
+					 "resized to %llu blocks",
+					 ext4_blocks_count(es));
+			last_update_time = jiffies;
+		}
 		if (ext4_alloc_group_tables(sb, flex_gd, flexbg_size) != 0)
 			break;
 		err = ext4_flex_group_add(sb, resize_inode, flex_gd);
-- 
1.7.12.rc0.22.gcdd159b

