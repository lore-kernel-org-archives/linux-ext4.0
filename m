From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/9] ext4: set bg_itable_unused when resizing
Date: Thu, 13 Sep 2012 18:49:13 -0400
Message-ID: <1347576556-5725-7-git-send-email-tytso@mit.edu>
References: <1347576556-5725-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50574 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab2IMW4P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 18:56:15 -0400
In-Reply-To: <1347576556-5725-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Set bg_itable_unused for file systems that have uninit_bg enabled.
This will speed up the first e2fsck run after the file system is
resized.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 7adc088..a5be589 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1268,6 +1268,9 @@ static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
 		ext4_free_group_clusters_set(sb, gdp,
 					     EXT4_B2C(sbi, group_data->free_blocks_count));
 		ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
+		if (ext4_has_group_desc_csum(sb))
+			ext4_itable_unused_set(sb, gdp,
+					       EXT4_INODES_PER_GROUP(sb));
 		gdp->bg_flags = cpu_to_le16(*bg_flags);
 		ext4_group_desc_csum_set(sb, group, gdp);
 
-- 
1.7.12.rc0.22.gcdd159b

