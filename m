From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/9] ext4: avoid duplicate writes of the backup bg descriptor blocks
Date: Thu, 13 Sep 2012 18:49:09 -0400
Message-ID: <1347576556-5725-3-git-send-email-tytso@mit.edu>
References: <1347576556-5725-1-git-send-email-tytso@mit.edu>
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50570 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab2IMWtT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 18:49:19 -0400
In-Reply-To: <1347576556-5725-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

The resize code was needlessly writing the backup block group
descriptor blocks multiple times (once per block group) during an
online resize.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/resize.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index a0ee26c..365d800 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1358,13 +1358,15 @@ exit_journal:
 		err = err2;
 
 	if (!err) {
-		int i;
+		int gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
+		int gdb_num_end = ((group + flex_gd->count - 1) /
+				   EXT4_DESC_PER_BLOCK(sb));
+
 		update_backups(sb, sbi->s_sbh->b_blocknr, (char *)es,
 			       sizeof(struct ext4_super_block));
-		for (i = 0; i < flex_gd->count; i++, group++) {
+		for (; gdb_num <= gdb_num_end; gdb_num++) {
 			struct buffer_head *gdb_bh;
-			int gdb_num;
-			gdb_num = group / EXT4_BLOCKS_PER_GROUP(sb);
+
 			gdb_bh = sbi->s_group_desc[gdb_num];
 			update_backups(sb, gdb_bh->b_blocknr, gdb_bh->b_data,
 				       gdb_bh->b_size);
-- 
1.7.12.rc0.22.gcdd159b

