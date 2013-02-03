From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] ext4: print error when argument of inode_readahead_blk is invalid
Date: Sat,  2 Feb 2013 23:44:05 -0500
Message-ID: <1359866646-29876-4-git-send-email-tytso@mit.edu>
References: <1359866646-29876-1-git-send-email-tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46693 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab3BCEoN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Feb 2013 23:44:13 -0500
In-Reply-To: <1359866646-29876-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

If argument of inode_readahead_blk is too big, we just bail out
without printing any error. Fix this since it could confuse users.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e8d3c2f..bcd5f12 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1558,11 +1558,10 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	} else if (token == Opt_min_batch_time) {
 		sbi->s_min_batch_time = arg;
 	} else if (token == Opt_inode_readahead_blks) {
-		if (arg > (1 << 30))
-			return -1;
-		if (arg && !is_power_of_2(arg)) {
-			ext4_msg(sb, KERN_ERR, "EXT4-fs: inode_readahead_blks"
-				 " must be a power of 2");
+		if (arg && (arg > (1 << 30) || !is_power_of_2(arg))) {
+			ext4_msg(sb, KERN_ERR,
+				 "EXT4-fs: inode_readahead_blks must be "
+				 "0 or a power of 2 smaller than 2^31");
 			return -1;
 		}
 		sbi->s_inode_readahead_blks = arg;
-- 
1.7.12.rc0.22.gcdd159b

