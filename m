From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 24/51] ext3: wait on all pending commits in ext3_sync_fs
Date: Thu, 6 Nov 2008 16:44:31 -0500
Message-ID: <20081106214431.GL18939@mit.edu>
References: <200811062053.mA6KratV013440@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38665 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754546AbYKFVod (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 16:44:33 -0500
Content-Disposition: inline
In-Reply-To: <200811062053.mA6KratV013440@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

My version of this patch also cleaned up the following comment, which
has been wrong since 2.5.70 or thereabouts...

This isn't urgent, so could you just queue this up for the next merge
window in the -mm tree?

						- Ted

ext3: Clean up outdated and incorrect comment for ext3_write_super()

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-ext4@vger.kernel.org>
---
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index e5717a4..296c044 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2375,12 +2375,9 @@ int ext3_force_commit(struct super_block *sb)
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
