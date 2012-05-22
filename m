From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: fix precedence bug in built-in quota support
Date: Mon, 21 May 2012 22:09:34 -0400
Message-ID: <1337652574-7132-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Aditya Kali <adityakali@google.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56094 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab2EVCJh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 May 2012 22:09:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The operator precedence bug means that we might pay atteion to
s_grp_quota_inum even if the RO_COMPAT_QUOTA feature flag is clear.
However, fortunately, this is unlikely to happen in practice.

Cc: Aditya Kali <adityakali@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index c7645d1..c6aae6e 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -928,8 +928,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			if ((fs->super->s_feature_ro_compat &
 					EXT4_FEATURE_RO_COMPAT_QUOTA) &&
-			    (fs->super->s_usr_quota_inum == ino) ||
-			    (fs->super->s_grp_quota_inum == ino)) {
+			    ((fs->super->s_usr_quota_inum == ino) ||
+			     (fs->super->s_grp_quota_inum == ino))) {
 				if (!LINUX_S_ISREG(inode->i_mode) &&
 				    fix_problem(ctx, PR_1_QUOTA_BAD_MODE,
 							&pctx)) {
-- 
1.7.10.rc3

