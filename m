From: Jan Kara <jack@suse.cz>
Subject: Re: Nasty race found in ext4 extents truncate logic
Date: Tue, 11 Aug 2009 17:25:04 +0200
Message-ID: <20090811152504.GA26070@atrey.karlin.mff.cuni.cz>
References: <E1MaqmK-0003vi-6F@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40348 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZHKPZE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 11:25:04 -0400
Content-Disposition: inline
In-Reply-To: <E1MaqmK-0003vi-6F@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> This is a heads up that I've found up a really nasty race condition in
> the ext4 extents code's truncate logic.  The problem is more likely to
> turn up after you apply my recent set of mballoc patches, but they
> didn't cause the problem.  What seems to be going on is that allocating
> small numbers of blocks takes more CPU time, and this widens the race
> window where it's detectable --- and even with the patches applied, it
> still takes 3 or 4 runs of the XFSQA test suites to turn up the problem.
> Still, people who try testing my patches may run into this soft lockup,
> so here's an explanation of what's goign on.
> 
> The core problem is that the extents truncate code doesn't know in
> advance how much journal "credits" (i.e., space in the journal) it
> requires while it is running.  So it calls ext4_ext_journal_restart()
> which tries reserve extra space for the truncate operation; but if there
> isn't enough space in the transaction, what happens is that
> jbd2_journal_restart() gets called, which closes the current transaction
> and starts a new one.
> 
> (n.b., ext4_ext_journal_restart() is misnamed; it really should be
> something like request_extra_credits_or_start_new_txn(), since it
> doesn't always call jbd2_journal_restart.)
> 
> The race condition happens because the truncate code calls
> jbd2_journal_restart() while holding an inode's i_data_sem for writing,
> and before jbd2_journal_restart() can start a new transaction, it needs
> to wait for all handles open against the current transaction to be
> completed.  If there is some other operation, such as ext4_get_blocks(),
> whose caller had already called ext4_start_handle() earlier (for
> example, in ext4_da_writepages() in the pdflush thread) and so is
> holding an open handle, tries grab the already-locked-for-writing
> i_data_sem, we have a deadlock.
> 
> This problem exists for both extent-mapped and indirect-block-mapped
> inode; both truncate paths take i_data_sem, and both can potentially
> call jbd2_journal_restart().  The fsstress program is needed to turn up
> the race, since it requires a truncate racing against a block allocation
> happening in the same file.  So it's very unlikely to turn up in
> real-life usage, thus making it *exactly* the sort of problem that
> causes level 3 support personnel to tear out their hair when it shows up
> 2-3 years later in some customer's enterprise data center.  :-)
> 
> 
> The solution is relatively simple; we need to release i_data_sem before
> calling jbd2_journal_restart().  However, before we do this, we need to
> make sure we don't introduce a harder to find bug --- since the moment
> we release i_data_sem, it will allow a waiting ext4_get_blocks()
> function to start reading and/or modifying the inode.  Worse yet, we
> might allow *another* truncate operation to start, with predictable
> hilarty ensuing.
> 
> So before we do this, we need to make sure that (a) before dropping
> i_data_sem, data structures, both in memory and on disk, are in a
> consistent state to allow another reader or writing to enter, and (b)
> after retaking i_data_sem, we need to check to see if some other process
> may have changed the state of the extent (or indirect block) tree out
> from under us.
  Hmm, ext3 seems to have a same problem wrt. ei->truncate_mutex and a
transaction restart. I wonder why lockdep didn't warn us about this -
ahh, there's a problem in lockdep annotation as well. It is only in
journal_start() but it should rather be in start_this_handle() which is
called both by journal_start() and journal_restart().
  I guess I'll have a look into both ext3 and ext4 and fix this..

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
