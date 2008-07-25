From: akpm@linux-foundation.org
Subject: - ext3-handle-deleting-corrupted-indirect-blocks.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:56:41 -0700
Message-ID: <200807252256.m6PMuflC003110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: duaneg@dghda.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: handle deleting corrupted indirect blocks
has been removed from the -mm tree.  Its filename was
     ext3-handle-deleting-corrupted-indirect-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: handle deleting corrupted indirect blocks
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

Patches currently in -mm which might be from duaneg@dghda.com are

origin.patch

