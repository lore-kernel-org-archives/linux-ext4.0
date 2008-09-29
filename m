From: Theodore Tso <tytso@mit.edu>
Subject: Re:
	jbd2-abort-instead-of-waiting-for-nonexistent-transactions.patch
Date: Sun, 28 Sep 2008 22:24:26 -0400
Message-ID: <20080929022426.GL8711@mit.edu>
References: <20080922140851.bc3f9319.akpm@linux-foundation.org> <e9e943910809230956n3f36e544hc46a80c00ff9804a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Stephen C. Tweedie" <sct@redhat.com>, linux-ext4@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46306 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751107AbYI2CZG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Sep 2008 22:25:06 -0400
Content-Disposition: inline
In-Reply-To: <e9e943910809230956n3f36e544hc46a80c00ff9804a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 23, 2008 at 05:56:27PM +0100, Duane Griffin wrote:
> Stephen suggested that it would be better to sanity check the journal
> start/end pointers on mount, rather than catching the error later like
> this. I never quite convinced myself I'd worked out the right way to
> do that, sorry. Perhaps someone would like to confirm (or otherwise)
> whether or not the following is correct:
> 
> In journal_reset (?) check that:
> 
> journal->j_first == 1 (this seems to be the only valid value)
> 
> and
> 
> journal->j_last >= JFS_MIN_JOURNAL_BLOCKS

Yes, for all existing currently created, j_first will be 1.  I can't
think of a good reason for why we might want to reserve some space at
the beginning of the journal, but the safest check would be:

    (journal->j_last - journal->j_first +1) >= JFS_MIN_JOURNAL_BLOCKS

> Additionally, it should be possible to check the journal->j_last more
> precisely. For internal journals it seems straight-forward, we can
> just check that journal->j_last == inode->i_size >>
> inode->i_sb->s_blocksize_bits. For external journals we'd need to load
> the device's superblock and check journal->j_last == s_blocks_count.

Yep, agreed.

> Regardless, I think the original patch may be a good idea. It improves
> robustness and matches the other locations where we call
> jbd2_log_do_checkpoint. They are all in loops that test that
> journal->j_checkpoint_transactions != NULL.

Agreed.  I've included it in the ext4 patch queue, and will be soon
putting out a new ext4 patchset consisting of the patches I plan to
push during the next merge window.

						- Ted
