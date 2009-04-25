From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Use is_power_of_2() for clarity
Date: Sat, 25 Apr 2009 00:00:23 -0400
Message-ID: <1240632023-29556-1-git-send-email-tytso@mit.edu>
References: <20090424173450.GJ7949@mit.edu>
Cc: Andrew Morton <akpm@osdl.org>, Theodore Ts'o <tytso@mit.edu>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49775 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZDYEAa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Apr 2009 00:00:30 -0400
In-Reply-To: <20090424173450.GJ7949@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f19d8b8..e20ff9c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1482,7 +1482,7 @@ set_qf_format:
 				return 0;
 			if (option < 0 || option > (1 << 30))
 				return 0;
-			if (option & (option - 1)) {
+			if (!is_power_of_2(option)) {
 				printk(KERN_ERR "EXT4-fs: inode_readahead_blks"
 				       " must be a power of 2\n");
 				return 0;
@@ -2100,8 +2100,7 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 	if (parse_strtoul(buf, 0x40000000, &t))
 		return -EINVAL;
 
-	/* inode_readahead_blks must be a power of 2 */
-	if (t & (t-1))
+	if (!is_power_of_2(t))
 		return -EINVAL;
 
 	sbi->s_inode_readahead_blks = t;
-- 
1.5.6.3

