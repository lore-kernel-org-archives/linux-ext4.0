From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] ext4: add sanity checking to count_overhead()
Date: Fri, 18 Nov 2016 13:38:42 -0500
Message-ID: <20161118183842.25682-4-tytso@mit.edu>
References: <20161118183842.25682-1-tytso@mit.edu>
Cc: kernel@kyup.com, bp@alien8.de, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57942 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753338AbcKRSit (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 18 Nov 2016 13:38:49 -0500
In-Reply-To: <20161118183842.25682-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The commit "ext4: sanity check the block and cluster size at mount
time" should prevent any problems, but in case the superblock is
modified while the file system is mounted, add an extra safety check
to make sure we won't overrun the allocated buffer.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 689c02df1af4..2d8a49d74f56 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3195,10 +3195,15 @@ static int count_overhead(struct super_block *sb, ext4_group_t grp,
 			ext4_set_bit(s++, buf);
 			count++;
 		}
-		for (j = ext4_bg_num_gdb(sb, grp); j > 0; j--) {
-			ext4_set_bit(EXT4_B2C(sbi, s++), buf);
-			count++;
+		j = ext4_bg_num_gdb(sb, grp);
+		if (s + j > EXT4_BLOCKS_PER_GROUP(sb)) {
+			ext4_error(sb, "Invalid number of block group "
+				   "descriptor blocks: %d", j);
+			j = EXT4_BLOCKS_PER_GROUP(sb) - s;
 		}
+		count += j;
+		for (; j > 0; j--)
+			ext4_set_bit(EXT4_B2C(sbi, s++), buf);
 	}
 	if (!count)
 		return 0;
-- 
2.11.0.rc0.7.gbe5a750

