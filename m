From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/4] ext4: fix init_itable=n to work as expected for n=0
Date: Mon,  9 May 2011 17:57:09 +0200
Message-ID: <1304956630-20384-3-git-send-email-lczerner@redhat.com>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1EIP5n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 11:57:43 -0400
In-Reply-To: <1304956630-20384-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For some reason, when we set mount option init_itable=0 it behaves as
we would set init_itable=20 which is not right at all. Basically when we
set it to zero we are saying to lazyinit thread not to wait between
zeroing the inode table (except of cond_resched()) so this commit fixes
that and removes the unnecessary condition. The 'n' should be also
properly used on remount.

When the n is not set at all, it means that the default miltiplier
EXT4_DEF_LI_WAIT_MULT is set instead.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/super.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6ccf0e2..c379af6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2690,11 +2690,8 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 		ret = ext4_init_inode_table(sb, group,
 					    elr->lr_timeout ? 0 : 1);
 		if (elr->lr_timeout == 0) {
-			timeout = jiffies - timeout;
-			if (elr->lr_sbi->s_li_wait_mult)
-				timeout *= elr->lr_sbi->s_li_wait_mult;
-			else
-				timeout *= 20;
+			timeout = (jiffies - timeout) *
+				  elr->lr_sbi->s_li_wait_mult;
 			elr->lr_timeout = timeout;
 		}
 		elr->lr_next_sched = jiffies + elr->lr_timeout;
@@ -2931,8 +2928,14 @@ static int ext4_register_li_request(struct super_block *sb,
 	ext4_group_t ngroups = EXT4_SB(sb)->s_groups_count;
 	int ret = 0;
 
-	if (sbi->s_li_request != NULL)
+	if (sbi->s_li_request != NULL) {
+		/*
+		 * Reset timeout so it can be computed again, because
+		 * s_li_wait_mult might have changed.
+		 */
+		sbi->s_li_request->lr_timeout = 0;
 		return 0;
+	}
 
 	if (first_not_zeroed == ngroups ||
 	    (sb->s_flags & MS_RDONLY) ||
@@ -3137,6 +3140,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	    ((def_mount_opts & EXT4_DEFM_NODELALLOC) == 0))
 		set_opt(sb, DELALLOC);
 
+	/*
+	 * set default s_li_wait_mult for lazyinit, for the case there is
+	 * no mount option specified.
+	 */
+	sbi->s_li_wait_mult = EXT4_DEF_LI_WAIT_MULT;
+
 	if (!parse_options((char *) sbi->s_es->s_mount_opts, sb,
 			   &journal_devnum, &journal_ioprio, NULL, 0)) {
 		ext4_msg(sb, KERN_WARNING,
-- 
1.7.4.4

