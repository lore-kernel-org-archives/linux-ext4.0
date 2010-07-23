From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fix for consistency errors after crash
Date: Fri, 23 Jul 2010 09:29:18 -0400
Message-ID: <20100723132918.GD13090@thunk.org>
References: <AANLkTimYavpuyNiaKYqUe3LFp0uzix_-ITV9ao0VagLs@mail.gmail.com>
 <AANLkTilxxsCSTIFLzg95xooW70SCNfWiDUVqpAT32FbX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59069 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab0GWN3V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 09:29:21 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTilxxsCSTIFLzg95xooW70SCNfWiDUVqpAT32FbX@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the version of the patch which I ultimately will be including
into the ext4 tree.  I removed the flag variable and cleaned up the
comment to make the code a bit clearer.

						- Ted

>From ee8973f1ff39e44d6f74cd8d456584fed4411663 Mon Sep 17 00:00:00 2001
From: Amir G <amir73il@users.sourceforge.net>
Date: Fri, 23 Jul 2010 09:27:04 -0400
Subject: [PATCH] ext4: Fix block bitmap inconsistencies after a crash when deleting files

We have experienced bitmap inconsistencies after crash during file
delete under heavy load.  The crash is not file system related and I
the following patch in ext4_free_branches() fixes the recovery
problem.

If the transaction is restarted and there is a crash before the new
transaction is committed, then after recovery, the blocks that this
indirect block points to have been freed, but the indirect block
itself has not been freed and may still point to some of the free
blocks (because of the ext4_forget()).

So ext4_forget() should be called inside ext4_free_blocks() to avoid
this problem.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   35 +++++++++++++----------------------
 1 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 755ba86..699d1d0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4490,27 +4490,6 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 					depth);
 
 			/*
-			 * We've probably journalled the indirect block several
-			 * times during the truncate.  But it's no longer
-			 * needed and we now drop it from the transaction via
-			 * jbd2_journal_revoke().
-			 *
-			 * That's easy if it's exclusively part of this
-			 * transaction.  But if it's part of the committing
-			 * transaction then jbd2_journal_forget() will simply
-			 * brelse() it.  That means that if the underlying
-			 * block is reallocated in ext4_get_block(),
-			 * unmap_underlying_metadata() will find this block
-			 * and will try to get rid of it.  damn, damn.
-			 *
-			 * If this block has already been committed to the
-			 * journal, a revoke record will be written.  And
-			 * revoke records must be emitted *before* clearing
-			 * this block's bit in the bitmaps.
-			 */
-			ext4_forget(handle, 1, inode, bh, bh->b_blocknr);
-
-			/*
 			 * Everything below this this pointer has been
 			 * released.  Now let this top-of-subtree go.
 			 *
@@ -4534,8 +4513,20 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 					    blocks_for_truncate(inode));
 			}
 
+			/*
+			 * The forget flag here is critical because if
+			 * we are journaling (and not doing data
+			 * journaling), we have to make sure a revoke
+			 * record is written to prevent the journal
+			 * replay from overwriting the (former)
+			 * indirect block if it gets reallocated as a
+			 * data block.  This must happen in the same
+			 * transaction where the data blocks are
+			 * actually freed.
+			 */
 			ext4_free_blocks(handle, inode, 0, nr, 1,
-					 EXT4_FREE_BLOCKS_METADATA);
+					 EXT4_FREE_BLOCKS_METADATA|
+					 EXT4_FREE_BLOCKS_FORGET);
 
 			if (parent_bh) {
 				/*
-- 
1.7.0.4

