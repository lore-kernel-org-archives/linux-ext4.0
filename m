From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] ext4/jbd2: fix io-barrier logic in case of external journal
Date: Mon, 22 Mar 2010 17:04:19 +0300
Message-ID: <87iq8o4fmk.fsf@openvz.org>
References: <1268414810-17289-1-git-send-email-dmonakhov@openvz.org>
	<20100322012000.GD11560@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43890 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0CVOEX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Mar 2010 10:04:23 -0400
Received: by bwz1 with SMTP id 1so1920957bwz.21
        for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 07:04:22 -0700 (PDT)
In-Reply-To: <20100322012000.GD11560@thunk.org> (tytso@mit.edu's message of
	"Sun, 21 Mar 2010 21:20:00 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Fri, Mar 12, 2010 at 08:26:49PM +0300, Dmitry Monakhov wrote:
>>  start_journal_io:
>> +			if (bufs)
>> +				commit_transaction->t_flushed_data_blocks = 1;
>> +
>
> I'm not convinced this is right.
>
> From your test case, the problem isn't because we have journaled
> metadata blocks (which is what bufs) counts, but because fsync()
> depends on data blocks also getting flushed out to disks.
>
> However, if we aren't closing the transaction because of fsync(), I
> don't think we need to do a barrier in the case of an external
> journal.  So instead of effectively unconditionally setting
> t_flushed_data_blocks (since bufs is nearly always going to be
> non-zero), I think the better fix is to test to see if the journal
> device != to the fs data device in fsync(), and if so, start the
> barrier operation there.
>
> Do you agree?
Yes.
BTW Would it be correct to update j_tail in
jbd2_journal_commit_transaction() to something more recent
if we have issued an io-barrier to j_fs_dev?
This will helps to reduce journal_recovery time which may be really
painful in some slow devices.

I've take a look at async commit logic: fs/jbd2/commit.c
void jbd2_journal_commit_transaction(journal_t *journal)
{
725:    /* Done it all: now write the commit record asynchronously. */
        if (JBD2_HAS_INCOMPAT_FEATURE(journal,
                                      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
                                      {
                err = journal_submit_commit_record(journal,
                commit_transaction,
                                                 &cbh, crc32_sum);
                if (err)
                        __jbd2_journal_abort_hard(journal);
                if (journal->j_flags & JBD2_BARRIER)
                        blkdev_issue_flush(journal->j_dev, NULL);
<<< blkdev_issue_flush is wait for barrier to complete by default, but
<<< in fact we don't have to wait for barrier here. I've prepared a
<<< patch wich add flags to control blkdev_issue_flush() wait
<<< behavior, and this is the place for no-wait variant.
...
855:    if (!err && !is_journal_aborted(journal))
                err = journal_wait_on_commit_record(journal, cbh);
}
