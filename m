From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fix for consistency errors after crash
Date: Mon, 12 Jul 2010 21:37:27 +0200
Message-ID: <20100712193726.GB12804@atrey.karlin.mff.cuni.cz>
References: <AANLkTimYavpuyNiaKYqUe3LFp0uzix_-ITV9ao0VagLs@mail.gmail.com> <AANLkTilxxsCSTIFLzg95xooW70SCNfWiDUVqpAT32FbX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33248 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751708Ab0GLTh2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 15:37:28 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTilxxsCSTIFLzg95xooW70SCNfWiDUVqpAT32FbX@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

> I've seen you guys had some open RH bugs on ext3, who all share in
> common the "bit already free" error.
> 
> This bug I reported can explain many different problems in ext[34].
> 
> Essentially, every time there is a kernel crash (or hard reboot)
> during delete/truncate of a large file,
> it may result in "bit already clear" error after reboot.
> 
> The problem is very simple and so is the fix.
> I proved the problem with 100% recreation chances using a small patch,
> instead of running statistical stress tests.
> All I did was to add a print and 10 seconds delay after transaction
> restart in ext3_free_branches and reboot > 5 seconds after the
> transaction restarts, so that kjournald will have time to commit the
> old transaction.
> After the reboot, I always get "bit already clear" errors, because the
> "half large truncate" transaction is not handled properly.
> 
> I did not get any response from ext4 guys so far and since this bug
> dates back to ext3,
> I was hoping you guys could take a look and put your weight on pushing
> the fix upstream.
  Thanks for a ping. Your analysis and the fix looks correct to me. Attached is
a fix of the problem for ext3 which I'll merge if noone objects. BTW: I've also
updated a comment a bit so you might want to include than in an ext4 patch as
well.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--BOKacYhQ+x31HxR3
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext3-Avoid-filesystem-corruption-after-a-crash-under.patch"

>From 6c91cac7b34f60bf89cb58a9fe753918628d22c4 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 12 Jul 2010 21:04:31 +0200
Subject: [PATCH] ext3: Avoid filesystem corruption after a crash under heavy delete load

It can happen that ext3_free_branches calls ext3_forget() for an indirect
block in an earlier transaction than ext3_free_blocks() for that block.
Thus if we crash before a transaction with ext3_free_blocks() is committed,
we will see indirect block pointing to already freed blocks and complain
during orphan list cleanup.

The fix is simple: Make sure ext3_forget() is called in the same transaction
as ext3_free_blocks().

This is a backport of an ext4 fix by Amir G. <amir73il@users.sourceforge.net>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   46 +++++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index a786db4..436e5bb 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2270,27 +2270,6 @@ static void ext3_free_branches(handle_t *handle, struct inode *inode,
 					   depth);
 
 			/*
-			 * We've probably journalled the indirect block several
-			 * times during the truncate.  But it's no longer
-			 * needed and we now drop it from the transaction via
-			 * journal_revoke().
-			 *
-			 * That's easy if it's exclusively part of this
-			 * transaction.  But if it's part of the committing
-			 * transaction then journal_forget() will simply
-			 * brelse() it.  That means that if the underlying
-			 * block is reallocated in ext3_get_block(),
-			 * unmap_underlying_metadata() will find this block
-			 * and will try to get rid of it.  damn, damn.
-			 *
-			 * If this block has already been committed to the
-			 * journal, a revoke record will be written.  And
-			 * revoke records must be emitted *before* clearing
-			 * this block's bit in the bitmaps.
-			 */
-			ext3_forget(handle, 1, inode, bh, bh->b_blocknr);
-
-			/*
 			 * Everything below this this pointer has been
 			 * released.  Now let this top-of-subtree go.
 			 *
@@ -2313,6 +2292,31 @@ static void ext3_free_branches(handle_t *handle, struct inode *inode,
 				truncate_restart_transaction(handle, inode);
 			}
 
+			/*
+			 * We've probably journalled the indirect block several
+			 * times during the truncate.  But it's no longer
+			 * needed and we now drop it from the transaction via
+			 * journal_revoke().
+			 *
+			 * That's easy if it's exclusively part of this
+			 * transaction.  But if it's part of the committing
+			 * transaction then journal_forget() will simply
+			 * brelse() it.  That means that if the underlying
+			 * block is reallocated in ext3_get_block(),
+			 * unmap_underlying_metadata() will find this block
+			 * and will try to get rid of it.  damn, damn. Thus
+			 * we don't allow a block to be reallocated until
+			 * a transaction freeing it has fully committed.
+			 *
+			 * We also have to make sure journal replay after a
+			 * crash does not overwrite non-journaled data blocks
+			 * with old metadata when the block got reallocated for
+			 * data.  Thus we have to store a revoke record for a
+			 * block in the same transaction in which we free the
+			 * block.
+			 */
+			ext3_forget(handle, 1, inode, bh, bh->b_blocknr);
+
 			ext3_free_blocks(handle, inode, nr, 1);
 
 			if (parent_bh) {
-- 
1.6.4.2


--BOKacYhQ+x31HxR3--
