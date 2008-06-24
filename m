From: akpm@linux-foundation.org
Subject: + ext3-handle-deleting-corrupted-indirect-blocks.patch added to -mm tree
Date: Tue, 24 Jun 2008 14:05:56 -0700
Message-ID: <200806242105.m5OL5uRj006001@imap1.linux-foundation.org>
Cc: duaneg@dghda.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbYFXVGc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2008 17:06:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: handle deleting corrupted indirect blocks
has been added to the -mm tree.  Its filename is
     ext3-handle-deleting-corrupted-indirect-blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN fs/ext3/inode.c~ext3-handle-deleting-corrupted-indirect-blocks fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-handle-deleting-corrupted-indirect-blocks
+++ a/fs/ext3/inode.c
@@ -2130,7 +2130,20 @@ static void ext3_free_data(handle_t *han
 
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
+				   "inode=%lu, block="E3FSBLK,
+				   inode->i_ino, this_bh->b_blocknr);
 	}
 }
 
_

Patches currently in -mm which might be from duaneg@dghda.com are

jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch
ext3-handle-corrupted-orphan-list-at-mount.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks.patch

