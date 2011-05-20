From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/4 v2] ext4: fix init_itable=n to work as expected for n=0
Date: Fri, 20 May 2011 13:20:41 +0200
Message-ID: <1305890442-16361-3-git-send-email-lczerner@redhat.com>
References: <1305890442-16361-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, tytso@mit.edu,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934708Ab1ETLU4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 07:20:56 -0400
In-Reply-To: <1305890442-16361-1-git-send-email-lczerner@redhat.com>
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
CC: Eric Sandeen <sandeen@redhat.com>
---
[v2]: Do not set default in parsing Opt_init_inode_table
 Documentation/filesystems/ext4.txt |    4 +++-
 fs/ext4/super.c                    |   30 +++++++++++++++++++-----------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index c79ec58..bab8f8e 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -364,8 +364,10 @@ noinit_itable		Do not initialize any uninitialized inode table
 init_itable=n		The lazy itable init code will wait n times the
 			number of milliseconds it took to zero out the
 			previous block group's inode table.  This
-			minimizes the impact on the systme performance
+			minimizes the impact on the system performance
 			while file system's inode table is being initialized.
+			Parameter n is optional and if omitted, will be
+			defaulted to 10.
 
 discard			Controls whether ext4 should issue discard/TRIM
 nodiscard(*)		commands to the underlying block device when
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6ccf0e2..72df905 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1833,11 +1833,10 @@ set_qf_format:
 			if (args[0].from) {
 				if (match_int(&args[0], &option))
 					return 0;
-			} else
-				option = EXT4_DEF_LI_WAIT_MULT;
-			if (option < 0)
-				return 0;
-			sbi->s_li_wait_mult = option;
+				if (option < 0)
+					return 0;
+				sbi->s_li_wait_mult = option;
+			}
 			break;
 		case Opt_noinit_inode_table:
 			clear_opt(sb, INIT_INODE_TABLE);
@@ -2690,11 +2689,8 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
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
@@ -2931,8 +2927,14 @@ static int ext4_register_li_request(struct super_block *sb,
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
@@ -3137,6 +3139,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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

