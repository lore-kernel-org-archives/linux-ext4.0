From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 02/28] ext4: Fix optional-arg mount options
Date: Tue,  2 Mar 2010 13:18:19 -0500
Message-ID: <1267553925-6308-3-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43025 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354Ab0CBSSv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:51 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

We have 2 mount options, "barrier" and "auto_da_alloc" which may or
may not take a 1/0 argument.  This causes the ext4 superblock mount
code to subtract uninitialized pointers and pass the result to
kmalloc, which results in very noisy failures.

Per Ted's suggestion, initialize the args struct so that
we know whether match_token() found an argument for the
option, and skip match_int() if not.

Also, return error (0) from parse_options if we thought
we found an argument, but match_int() Fails.

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 735c20d..68a55df 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1229,6 +1229,11 @@ static int parse_options(char *options, struct super_block *sb,
 		if (!*p)
 			continue;
 
+		/*
+		 * Initialize args struct so we know whether arg was
+		 * found; some options take optional arguments.
+		 */
+		args[0].to = args[0].from = 0;
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_bsd_df:
@@ -1518,10 +1523,11 @@ set_qf_format:
 			clear_opt(sbi->s_mount_opt, BARRIER);
 			break;
 		case Opt_barrier:
-			if (match_int(&args[0], &option)) {
-				set_opt(sbi->s_mount_opt, BARRIER);
-				break;
-			}
+			if (args[0].from) {
+				if (match_int(&args[0], &option))
+					return 0;
+			} else
+				option = 1;	/* No argument, default to 1 */
 			if (option)
 				set_opt(sbi->s_mount_opt, BARRIER);
 			else
@@ -1594,10 +1600,11 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
 			break;
 		case Opt_auto_da_alloc:
-			if (match_int(&args[0], &option)) {
-				clear_opt(sbi->s_mount_opt, NO_AUTO_DA_ALLOC);
-				break;
-			}
+			if (args[0].from) {
+				if (match_int(&args[0], &option))
+					return 0;
+			} else
+				option = 1;	/* No argument, default to 1 */
 			if (option)
 				clear_opt(sbi->s_mount_opt, NO_AUTO_DA_ALLOC);
 			else
-- 
1.6.6.1.1.g974db.dirty

