From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] ext4/jbd2: fix io-barrier logic in case of external journal
Date: Mon, 22 Mar 2010 19:14:13 +0300
Message-ID: <87d3yw49m2.fsf@openvz.org>
References: <1268414810-17289-1-git-send-email-dmonakhov@openvz.org>
	<20100322012000.GD11560@thunk.org> <87iq8o4fmk.fsf@openvz.org>
	<20100322150342.GG11560@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43070 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0CVQOS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Mar 2010 12:14:18 -0400
Received: by bwz1 with SMTP id 1so2063157bwz.21
        for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 09:14:16 -0700 (PDT)
In-Reply-To: <20100322150342.GG11560@thunk.org> (tytso@mit.edu's message of
	"Mon, 22 Mar 2010 11:03:42 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Mon, Mar 22, 2010 at 05:04:19PM +0300, Dmitry Monakhov wrote:
>> tytso@mit.edu writes:
>> 
>> > On Fri, Mar 12, 2010 at 08:26:49PM +0300, Dmitry Monakhov wrote:
>> >>  start_journal_io:
>> >> +			if (bufs)
>> >> +				commit_transaction->t_flushed_data_blocks = 1;
>> >> +
>> >
>> > I'm not convinced this is right.
>> >
>> > From your test case, the problem isn't because we have journaled
>> > metadata blocks (which is what bufs) counts, but because fsync()
>> > depends on data blocks also getting flushed out to disks.
>> >
>> > However, if we aren't closing the transaction because of fsync(), I
>> > don't think we need to do a barrier in the case of an external
>> > journal.  So instead of effectively unconditionally setting
>> > t_flushed_data_blocks (since bufs is nearly always going to be
>> > non-zero), I think the better fix is to test to see if the journal
>> > device != to the fs data device in fsync(), and if so, start the
>> > barrier operation there.
>> >
>> > Do you agree?
>> Yes.
>
> Just to be clear, since I realized I wrote fsync() when I should have
> written fs/ext4/fsync.c, my proposal was to put this check in
> ext4_sync_file().
This means that we will end up with two io-barriers in a row
for external journal case:
ext4_sync_file()
  ->jbd2_log_start_commit()
     ->blkdev_issue_flush(j_fs_dev)
  /* seems following flush is mandatory to guarantee the metadata
   * consistency */
  ->blkdev_issue_flush(j_fs_dev)

may be it will be better to pass some sort of barrier flag to
jbd2_log_start_commit() this function mark journal->j_commit_request
with ->t_flushed_data_blocks = 1, so io-carrier will be issued
even if transaction has only metadata
Advantages:
1) approach will works for all data modes
2) only one io-barrier is needed to guarantee the data and
   metadata consiscency.
3) changes not so complicated.

I've already started to work with the patch but was surprised with
commit logic. 
->__jbd2_log_start_commit(target)
   journal->j_commit_request = target
   ->wake_up(&journal->j_wait_commit)
->kjournald2
   transaction = journal->j_running_transaction
   ->jbd2_journal_commit_transaction(journal);
     commit_transaction = journal->j_running_transaction
     ...
     /* So j_commit_request is used only for comparison. But actually
        committing journal->j_running_transaction->t_tid transaction
        instead of j_commit_request. Why?
      */
>
>> BTW Would it be correct to update j_tail in
>> jbd2_journal_commit_transaction() to something more recent
>> if we have issued an io-barrier to j_fs_dev?
>> This will helps to reduce journal_recovery time which may be really
>> painful in some slow devices.
>
> Um, maybe.  We are already calling __jbd2_journal_clean_checkpoint_list(),
> and the barrier operation *is* expensive.
>
> On the other hand, updating the journal superblock on every sync is
> another seek that would have to made before the barrier operation, and
> I'm a bit concerned that this seek would be noticeable.  If it is
> noticeable, is it worth it to optimize for the uncommon case (a power
> failure requiring a journal replay) when it might cost us something,
> however, small, on every single journal update?
>
> Do we really think the journal replay time is really something that is
> a major pain point.  I can think of optimizations that involve
> skipping writes that will get updated later in future transactions,
> but it means complicating the replay code, which has been stable for a
> long time, and it's not clear to me that the costs are worth the
> benefits.
Never mind. It was just my thoughts. The price of broken recovery stage
is to expansive to fix such rare cases.
>
>> I've take a look at async commit logic: fs/jbd2/commit.c
>> void jbd2_journal_commit_transaction(journal_t *journal)
>> {
>> 725:    /* Done it all: now write the commit record asynchronously. */
>>         if (JBD2_HAS_INCOMPAT_FEATURE(journal,
>>                                       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
>>                                       {
>>                 err = journal_submit_commit_record(journal,
>>                 commit_transaction,
>>                                                  &cbh, crc32_sum);
>>                 if (err)
>>                         __jbd2_journal_abort_hard(journal);
>>                 if (journal->j_flags & JBD2_BARRIER)
>>                         blkdev_issue_flush(journal->j_dev, NULL);
>> <<< blkdev_issue_flush is wait for barrier to complete by default, but
>> <<< in fact we don't have to wait for barrier here. I've prepared a
>> <<< patch wich add flags to control blkdev_issue_flush() wait
>> <<< behavior, and this is the place for no-wait variant.
>
> I think that's right, as long as we're confident that subsequent
> writes won't get scheduled before the no-wait barrier.  If it did, it
> would be a bug in the block I/O layer, so it should be OK.
>
>       	       	      	    	- Ted
>  
