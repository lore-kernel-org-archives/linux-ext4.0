From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH]ext4: Fix compile warnings with EXT4FS_DEBUG
Date: Fri, 21 Jan 2011 16:35:14 +0900
Message-ID: <4D393732.5020301@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:35968 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1AUHfg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jan 2011 02:35:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Compile 2.6.38-rc1 with turning EXT4FS_DEBUG on,
we get following compile warnings. This patch fixes them.

  CC      fs/ext4/hash.o
  CC      fs/ext4/resize.o
fs/ext4/resize.c: In function 'setup_new_group_blocks':
fs/ext4/resize.c:233:2: warning: format '%#04llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'
fs/ext4/resize.c:251:2: warning: format '%#04llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'
  CC      fs/ext4/extents.o
  CC      fs/ext4/ext4_jbd2.o
  CC      fs/ext4/migrate.o

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/resize.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
diff -Nrup -X linux-2.6.38-rc1-a/Documentation/dontdiff linux-2.6.38-rc1-a/fs/ext4/resize.c linux-2.6.38-rc1-b/fs/ext4/resize.c
--- linux-2.6.38-rc1-a/fs/ext4/resize.c 2011-01-21 14:07:55.000000000 +0900
+++ linux-2.6.38-rc1-b/fs/ext4/resize.c 2011-01-21 14:08:49.000000000 +0900
@@ -231,7 +231,7 @@ static int setup_new_group_blocks(struct

        /* Zero out all of the reserved backup group descriptor table blocks */
        ext4_debug("clear inode table blocks %#04llx -> %#04llx\n",
-                       block, sbi->s_itb_per_group);
+                       block, (ext4_fsblk_t)sbi->s_itb_per_group);
        err = sb_issue_zeroout(sb, gdblocks + start + 1, reserved_gdb,
                               GFP_NOFS);
        if (err)
@@ -249,7 +249,7 @@ static int setup_new_group_blocks(struct
        /* Zero out all of the inode table blocks */
        block = input->inode_table;
        ext4_debug("clear inode table blocks %#04llx -> %#04llx\n",
-                       block, sbi->s_itb_per_group);
+                       block, (ext4_fsblk_t)sbi->s_itb_per_group);
        err = sb_issue_zeroout(sb, block, sbi->s_itb_per_group, GFP_NOFS);
        if (err)
                goto exit_bh;

