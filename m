From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 01/11] ext4: remove deprecation warnings for minix_df and grpid
Date: Sun,  4 Mar 2012 22:08:15 -0500
Message-ID: <1330916905-5976-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41859 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab2CEDI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2012 22:08:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

People complained about removing both of these features, so per
Linus's dictate, we won't be able to remove them.  Sigh...

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index deb6eb3..ed9a4b5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1539,23 +1539,16 @@ static int parse_options(char *options, struct super_block *sb,
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_bsd_df:
-			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
 			clear_opt(sb, MINIX_DF);
 			break;
 		case Opt_minix_df:
-			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
 			set_opt(sb, MINIX_DF);
-
 			break;
 		case Opt_grpid:
-			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
 			set_opt(sb, GRPID);
-
 			break;
 		case Opt_nogrpid:
-			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.38");
 			clear_opt(sb, GRPID);
