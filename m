From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] ext4: Make ext4_block_in_group() much more efficient
Date: Mon, 25 Mar 2013 11:24:10 +0100
Message-ID: <1364207051-27037-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab3CYKYQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Mar 2013 06:24:16 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2PAOGr5009290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 25 Mar 2013 06:24:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently in when getting the block group number for a particular block
in ext4_block_in_group() we're using ext4_get_group_no_and_offset()
which uses do_div() to get the block group and the remainer which is
offset within the group.

We don't need all of that in ext4_block_in_group() as we only need to
figure out the group number.

This commit changes ext4_block_in_group() to calculate group number
directly. This shows as a big improvement with regards to cpu
utilization. Measuring fallocate -l 15T on fresh file system with perf
showed that 23% of cpu time was spend in the
ext4_get_group_no_and_offset(). With this change it completely
disappears from the list only bumping the occurrence of
ext4_init_block_bitmap() which is the biggest user of
ext4_block_in_group() by 4%. As the result of this change on my system
the fallocate call was approx. 10% faster.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/balloc.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 92e68b3..68368c2 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -49,14 +49,19 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 
 }
 
-static int ext4_block_in_group(struct super_block *sb, ext4_fsblk_t block,
-			ext4_group_t block_group)
+/*
+ * Check whether the 'block' lives within the 'block_group'. Returns 1 if so
+ * and 0 otherwise.
+ */
+static inline int ext4_block_in_group(struct super_block *sb,
+				      ext4_fsblk_t block,
+				      ext4_group_t block_group)
 {
 	ext4_group_t actual_group;
-	ext4_get_group_no_and_offset(sb, block, &actual_group, NULL);
-	if (actual_group == block_group)
-		return 1;
-	return 0;
+	actual_group = (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
+			block) >>
+		       (EXT4_BLOCK_SIZE_BITS(sb) + EXT4_CLUSTER_BITS(sb) + 3);
+	return (actual_group == block_group) ? 1 : 0;
 }
 
 /* Return the number of clusters used for file system metadata; this
-- 
1.7.7.6

