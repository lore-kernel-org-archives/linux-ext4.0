From: Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH] ext4: Support "check=none" "nocheck" mount options
Date: Tue, 10 Jan 2012 12:41:19 -0500
Message-ID: <20120110174118.GB3015@zod.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	kernel-team@fedoraproject.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685Ab2AJRlX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 12:41:23 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext2/ext3 filesystems supported "check=none" and "nocheck" as mount options
even though that was already the default behavior and it essentially did
nothing.  When using ext4 to mount ext2/ext3 filesystems, that mount option
causes the mount to fail.  That isn't as backward compatible as it could be,
so add support to ext4 to accept the option.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>

---
 fs/ext4/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3e1329e..5ff09e7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1333,7 +1333,7 @@ enum {
 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
-	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
+	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable, Opt_nocheck,
 };
 
 static const match_table_t tokens = {
@@ -1409,6 +1409,8 @@ static const match_table_t tokens = {
 	{Opt_init_itable, "init_itable=%u"},
 	{Opt_init_itable, "init_itable"},
 	{Opt_noinit_itable, "noinit_itable"},
+	{Opt_nocheck, "check=none"},
+	{Opt_nocheck, "nocheck"},
 	{Opt_err, NULL},
 };
 
@@ -1905,6 +1907,9 @@ set_qf_format:
 		case Opt_noinit_itable:
 			clear_opt(sb, INIT_INODE_TABLE);
 			break;
+		case Opt_nocheck:
+			/* ext2/ext3 used to "support" this option.  Silently eat it */
+			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
-- 
1.7.7.5

