From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix compile warnings with EXT4FS_DEBUG enabled
Date: Fri, 25 Feb 2011 21:50:25 -0500
Message-ID: <1298688625-19820-2-git-send-email-tytso@mit.edu>
References: <1298688625-19820-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54486 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab1BZCuc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Feb 2011 21:50:32 -0500
In-Reply-To: <1298688625-19820-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Compile 2.6.38-rc1 with turning EXT4FS_DEBUG on,
we get following compile warnings. This patch fixes them.

  CC      fs/ext4/hash.o
  CC      fs/ext4/resize.o
fs/ext4/resize.c: In function 'setup_new_group_blocks':
fs/ext4/resize.c:233:2: warning: format '%#04llx' expects type 'long long
unsigned int', but argument 3 has type 'long unsigned int'
fs/ext4/resize.c:251:2: warning: format '%#04llx' expects type 'long long
unsigned int', but argument 3 has type 'long unsigned int'
  CC      fs/ext4/extents.o
  CC      fs/ext4/ext4_jbd2.o
  CC      fs/ext4/migrate.o

Reported-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 3ecc6e4..66fec4e 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -230,7 +230,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 	}
 
 	/* Zero out all of the reserved backup group descriptor table blocks */
-	ext4_debug("clear inode table blocks %#04llx -> %#04llx\n",
+	ext4_debug("clear inode table blocks %#04llx -> %#04lx\n",
 			block, sbi->s_itb_per_group);
 	err = sb_issue_zeroout(sb, gdblocks + start + 1, reserved_gdb,
 			       GFP_NOFS);
@@ -248,7 +248,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 
 	/* Zero out all of the inode table blocks */
 	block = input->inode_table;
-	ext4_debug("clear inode table blocks %#04llx -> %#04llx\n",
+	ext4_debug("clear inode table blocks %#04llx -> %#04lx\n",
 			block, sbi->s_itb_per_group);
 	err = sb_issue_zeroout(sb, block, sbi->s_itb_per_group, GFP_NOFS);
 	if (err)
-- 
1.7.3.1

