From: akpm@linux-foundation.org
Subject: [patch 21/34] ext3: Clean up outdated and incorrect comment for ext3_write_super()
Date: Wed, 12 Nov 2008 13:27:01 -0800
Message-ID: <200811122127.mACLR16j026874@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681AbYKLVfU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Nov 2008 16:35:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Theodore Tso <tytso@mit.edu>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/ext3/super.c~ext3-clean-up-outdated-and-incorrect-comment-for-ext3_write_super fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-clean-up-outdated-and-incorrect-comment-for-ext3_write_super
+++ a/fs/ext3/super.c
@@ -2375,12 +2375,9 @@ int ext3_force_commit(struct super_block
 /*
  * Ext3 always journals updates to the superblock itself, so we don't
  * have to propagate any other updates to the superblock on disk at this
- * point.  Just start an async writeback to get the buffers on their way
- * to the disk.
- *
- * This implicitly triggers the writebehind on sync().
+ * point.  (We can probably nuke this function altogether, and remove
+ * any mention to sb->s_dirt in all of fs/ext3; eventual cleanup...)
  */
