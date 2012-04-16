From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] ext4: Print error when argument of inode_readahead_blk is invalid
Date: Mon, 16 Apr 2012 14:25:34 +0200
Message-ID: <1334579134-19885-5-git-send-email-jack@suse.cz>
References: <1334579134-19885-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab2DPMZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Apr 2012 08:25:39 -0400
In-Reply-To: <1334579134-19885-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If argument of inode_readahead_blk is too big, we just bail out without
printing any error. Fix this since it could confuse users.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f1acaa6..ced6671 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1518,12 +1518,10 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	} else if (token == Opt_min_batch_time) {
 		sbi->s_min_batch_time = arg;
 	} else if (token == Opt_inode_readahead_blks) {
-		if (arg > (1 << 30))
-			return -1;
-		if (arg && !is_power_of_2(arg)) {
+		if (arg && (arg > (1 << 30) || !is_power_of_2(arg))) {
 			ext4_msg(sb, KERN_ERR,
-				 "EXT4-fs: inode_readahead_blks"
-				 " must be a power of 2");
+				 "EXT4-fs: inode_readahead_blks must be "
+				 "0 or a power of 2 smaller than 2^31");
 			return -1;
 		}
 		sbi->s_inode_readahead_blks = arg;
-- 
1.7.1

