From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 11/11] ext4: try to deprecate noacl and noxattr_user mount options
Date: Sun,  4 Mar 2012 22:08:25 -0500
Message-ID: <1330916905-5976-11-git-send-email-tytso@mit.edu>
References: <1330916905-5976-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41875 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab2CEDI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2012 22:08:26 -0500
In-Reply-To: <1330916905-5976-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

No other file system allows ACL's and extended attributes to be
enabled or disabled via a mount option.  So let's try to deprecate
these options from ext4.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 960681f..25b1f03 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1443,6 +1443,10 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	if (args->from && match_int(args, &arg))
 		return -1;
 	switch (token) {
+	case Opt_noacl:
+	case Opt_nouser_xattr:
+		ext4_msg(sb, KERN_WARNING, deprecated_msg, opt, "3.5");
+		break;
 	case Opt_sb:
 		return 1;	/* handled by get_sb_block() */
 	case Opt_removed:
-- 
1.7.9.107.g97f9a

