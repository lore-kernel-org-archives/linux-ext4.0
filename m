From: Eric Whitney <enwlinux@gmail.com>
Subject: [RESEND][PATCH 2/2] ext4: use journal inode to determine journal
 overhead
Date: Thu, 22 Sep 2016 11:07:52 -0400
Message-ID: <20160922150752.GA14239@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34587 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933674AbcIVPDp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Sep 2016 11:03:45 -0400
Received: by mail-qk0-f194.google.com with SMTP id b204so5337633qkc.1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Sep 2016 08:03:45 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a file system contains an internal journal that has not been
loaded, use the journal inode's i_size field to determine its
contribution to the file system's overhead.  (The journal's j_maxlen
field is normally used to determine its size, but it's unavailable when
the journal has not been loaded.)

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/super.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4b0ca25..1a7b6fd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3210,6 +3210,8 @@ int ext4_calculate_overhead(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
+	struct inode *j_inode;
+	unsigned int j_blocks, j_inum = le32_to_cpu(es->s_journal_inum);
 	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
 	ext4_fsblk_t overhead = 0;
 	char *buf = (char *) get_zeroed_page(GFP_NOFS);
@@ -3240,10 +3242,23 @@ int ext4_calculate_overhead(struct super_block *sb)
 			memset(buf, 0, PAGE_SIZE);
 		cond_resched();
 	}
-	/* Add the internal journal blocks as well */
+
+	/*
+	 * Add the internal journal blocks whether the journal has been
+	 * loaded or not
+	 */
 	if (sbi->s_journal && !sbi->journal_bdev)
 		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
