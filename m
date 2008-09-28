From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Potential bug in mballoc --- reusing data blocks before txn commit
Date: Sat, 27 Sep 2008 21:35:46 -0400
Message-ID: <E1KjlCM-0002L7-SO@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: Alex Tomas <bzzz@sun.com>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:59140 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751073AbYI1Bft (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Sep 2008 21:35:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So while I was preparing a patch to delete the old legacy block
allocator, I came across this bit of code in balloc.c:

/**
 * ext4_test_allocatable()
 * @nr:                        given allocation block group
 * @bh:                        bufferhead contains the bitmap of the given bloc
 *
 * For ext4 allocations, we must not reuse any blocks which are
 * allocated in the bitmap buffer's "last committed data" copy.  This
 * prevents deletes from freeing up the page for reuse until we have
 * committed the delete transaction.
 *
 * If we didn't do this, then deleting something and reallocating it as
 * data would allow the old block to be overwritten before the
 * transaction committed (because we force data to disk before commit).
 * This would lead to corruption if we crashed between overwriting the
 * data and committing the delete.
 *
 * @@@ We may want to make this allocation behaviour conditional on
 * data-writes at some point, and disable it for metadata allocations or
 * sync-data inodes.
 */

This is done by searching an old copy of the bitmap found
jh->b_committed_data.

So I was more than a little bit concerned when I found that mballoc.c
wasn't referencing b_committed data *at* *all*.  When I looked a bit
more closely, it looks like that mballoc is using a separate scheme,
based on linked list hanging off of sbi->s_active_transaction.
Unfortunately, it seems to only prevent released metadata blocks from
being reused:

	if (metadata) {
		/* blocks being freed are metadata. these blocks shouldn't
		 * be used until this transaction is committed */
		ext4_mb_free_metadata(handle, &e4b, block_group, bit, count);
	} else {

This means that if a file is deleted, but then system crashes before the
commit, some of its data blocks could be reallocated and then written
out.  We could fix this by running all released blocks via
ext4_mb_free_metadata(), but since ext4_mb_free_metadata() stores blocks
that need to be protected via a block list, this could get *quite*
unwieldy, especially when deleting very large files (we could end up
with a very large linked list).  Alternate solutions would involve using
a list of extents, or the original jh->b_commited_data mechanism.

I'll also note that a linked list of extents that should be freed would
also be useful for implementing the trim command for SSD's --- and that
this would be much more cleanly implemented via a callback from the jbd2
layer when a commit is finished, rather than the current
ext4_mb_poll_new_transaction() mechanism.

In any case, is there a reason why the mballoc.c is using its current
scheme, and not using kj->b_commited_data as in the original balloc.c
code?  And was there a reason why you decided that it wasn't necessary
to protect freed data blocks from being reused until the transaction was
committed?

Regards,

							- Ted
