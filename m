From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext2: Fix possible sleep in atomic during mount option parsing
Date: Mon,  9 Oct 2017 17:00:42 +0200
Message-ID: <20171009150042.31293-3-jack@suse.cz>
References: <20171009150042.31293-1-jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Jia-Ju Bai <baijiaju1990@163.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47462 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754615AbdJIPAw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 9 Oct 2017 11:00:52 -0400
In-Reply-To: <20171009150042.31293-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

match_int() used in mount option parsing can allocate memory using
GFP_KERNEL and thus sleep. Avoid parsing mount options with sbi->s_lock
held.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 05eae20d133f..e2b6be03e69b 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1321,20 +1321,20 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	int err;
 
 	sync_filesystem(sb);
-	spin_lock(&sbi->s_lock);
 
+	spin_lock(&sbi->s_lock);
 	new_opts.s_mount_opt = sbi->s_mount_opt;
 	new_opts.s_resuid = sbi->s_resuid;
 	new_opts.s_resgid = sbi->s_resgid;
+	spin_unlock(&sbi->s_lock);
 
 	/*
 	 * Allow the "check" option to be passed as a remount option.
 	 */
-	if (!parse_options(data, sb, &new_opts)) {
-		spin_unlock(&sbi->s_lock);
+	if (!parse_options(data, sb, &new_opts))
 		return -EINVAL;
-	}
 
+	spin_lock(&sbi->s_lock);
 	es = sbi->s_es;
 	if ((sbi->s_mount_opt ^ new_opts.s_mount_opt) & EXT2_MOUNT_DAX) {
 		ext2_msg(sb, KERN_WARNING, "warning: refusing change of "
-- 
2.12.3
