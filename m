From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: Remove unused variable from ext4_show_options
Date: Fri, 06 Jun 2008 14:12:25 -0400
Message-ID: <E1K4gQL-0005uf-GA@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35411 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754615AbYFFSM1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2008 14:12:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 271c91f..97bcf32 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -671,7 +671,6 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	unsigned long def_mount_opts;
 	struct super_block *sb = vfs->mnt_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	journal_t *journal = sbi->s_journal;
 	struct ext4_super_block *es = sbi->s_es;
 
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
