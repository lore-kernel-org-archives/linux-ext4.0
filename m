From: akpm@linux-foundation.org
Subject: [patch 072/277] ext3: handle deleting corrupted indirect blocks
Date: Fri, 25 Jul 2008 01:46:26 -0700
Message-ID: <200807250846.m6P8kQTS001135@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, duaneg@dghda.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133AbYGYIq7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 04:46:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Duane Griffin" <duaneg@dghda.com>

While freeing indirect blocks we attach a journal head to the parent
buffer head, free the blocks, then journal the parent.  If the indirect
block list is corrupted and points to the parent the journal head will be
detached when the block is cleared, causing an OOPS.

Check for that explicitly and handle it gracefully.

This patch fixes the third case (image hdb.20000057.nullderef.gz)
reported in http://bugzilla.kernel.org/show_bug.cgi?id=10882.

Immediately above the change, in the ext3_free_data function, we call
ext3_clear_blocks to clear the indirect blocks in this parent block.  If
one of those blocks happens to actually be the parent block it will clear
b_private / BH_JBD.

I did the check at the end rather than earlier as it seemed more elegant. 
I don't think there should be much practical difference, although it is
possible the FS may not be quite so badly corrupted if we did it the other
way (and didn't clear the block at all).  To be honest, I'm not convinced
there aren't other similar failure modes lurking in this code, although I
couldn't find any with a quick review.

[akpm@linux-foundation.org: fix printk warning]
Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN fs/ext3/inode.c~ext3-handle-deleting-corrupted-indirect-blocks fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-handle-deleting-corrupted-indirect-blocks
+++ a/fs/ext3/inode.c
@@ -2127,7 +2127,21 @@ static void ext3_free_data(handle_t *han
 
 	if (this_bh) {
 		BUFFER_TRACE(this_bh, "call ext3_journal_dirty_metadata");
-		ext3_journal_dirty_metadata(handle, this_bh);
+
+		/*
+		 * The buffer head should have an attached journal head at this
+		 * point. However, if the data is corrupted and an indirect
+		 * block pointed to itself, it would have been detached when
+		 * the block was cleared. Check for this instead of OOPSing.
+		 */
+		if (bh2jh(this_bh))
+			ext3_journal_dirty_metadata(handle, this_bh);
+		else
+			ext3_error(inode->i_sb, "ext3_free_data",
+				   "circular indirect block detected, "
+				   "inode=%lu, block=%llu",
+				   inode->i_ino,
+				   (unsigned long long)this_bh->b_blocknr);
 	}
 }
 
_
