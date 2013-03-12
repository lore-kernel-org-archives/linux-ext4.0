From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: print more info in ext4_print_free_blocks()
Date: Tue, 12 Mar 2013 15:14:36 +0100
Message-ID: <1363097676-19587-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab3CLOOk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 10:14:40 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2CEEeUO015427
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 12 Mar 2013 10:14:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Additionally print i_allocated_meta_blocks information as well.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/inode.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e0d5bc6..93763d9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1583,22 +1583,25 @@ static void ext4_print_free_blocks(struct inode *inode)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct super_block *sb = inode->i_sb;
+	struct ext4_inode_info *ei = EXT4_I(inode);
 
 	ext4_msg(sb, KERN_CRIT, "Total free blocks count %lld",
 	       EXT4_C2B(EXT4_SB(inode->i_sb),
-			ext4_count_free_clusters(inode->i_sb)));
+			ext4_count_free_clusters(sb)));
 	ext4_msg(sb, KERN_CRIT, "Free/Dirty block details");
 	ext4_msg(sb, KERN_CRIT, "free_blocks=%lld",
-	       (long long) EXT4_C2B(EXT4_SB(inode->i_sb),
+	       (long long) EXT4_C2B(EXT4_SB(sb),
 		percpu_counter_sum(&sbi->s_freeclusters_counter)));
 	ext4_msg(sb, KERN_CRIT, "dirty_blocks=%lld",
-	       (long long) EXT4_C2B(EXT4_SB(inode->i_sb),
+	       (long long) EXT4_C2B(EXT4_SB(sb),
 		percpu_counter_sum(&sbi->s_dirtyclusters_counter)));
 	ext4_msg(sb, KERN_CRIT, "Block reservation details");
 	ext4_msg(sb, KERN_CRIT, "i_reserved_data_blocks=%u",
-		 EXT4_I(inode)->i_reserved_data_blocks);
+		 ei->i_reserved_data_blocks);
 	ext4_msg(sb, KERN_CRIT, "i_reserved_meta_blocks=%u",
-	       EXT4_I(inode)->i_reserved_meta_blocks);
+	       ei->i_reserved_meta_blocks);
+	ext4_msg(sb, KERN_CRIT, "i_allocated_meta_blocks=%u",
+	       ei->i_allocated_meta_blocks);
 	return;
 }
 
-- 
1.7.7.6

