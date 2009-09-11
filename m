From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/2] ext4: Automatically enable journal_async_commit on
 ext4 file systems
Date: Fri, 11 Sep 2009 07:07:27 -0400
Message-ID: <4AAA2F6F.3080903@redhat.com>
References: <1252189963-23868-1-git-send-email-tytso@mit.edu> <1252189963-23868-2-git-send-email-tytso@mit.edu> <4AA59A82.9090502@gmail.com> <20090908044541.GF22901@mit.edu> <4AA6450B.9040001@redhat.com> <20090911024505.GA9363@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbZIKLIF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2009 07:08:05 -0400
In-Reply-To: <20090911024505.GA9363@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/10/2009 10:45 PM, Theodore Tso wrote:
> On Tue, Sep 08, 2009 at 07:50:35AM -0400, Ric Wheeler wrote:
>>>
>>> So here's what we do on a non-async commit:
>>>
>>> This is what we do with an async commit:
>>>
>>> That's the only difference at this point.  The fatal flaw with async
>>> commit from before was this that we weren't writing the commit block
>>> in step (2) with a barrier --- and that *was* disastrous, since it
>>> meant the equivalent of mounting with barrier=0.
>>
>> I think that the difference is basically that in the original mode,
>> waiting for stage (2) to finish means that our commit block will never
>> hit the storage before the dependent data is committed. Remember that
>> barriers are actually 2 CACHE_FLUSH_EXT commands - one before the
>> flagged barrier IO is issued and one afterwards.
>
> I didn't realize that doing an ordered write meant that we had a
> barrier *before* and *after* the commit block; I didn't realiuze it
> was quite that strong.  I thought an ordered write only put a barrier
> *after* the commit block.  Looking more closely, you're right, and
> that actually explains why I wasn't see that much of a difference with
> and without journal_async_write.
>
> The fact that an ordered write puts barriers before and after the
> commit means that right now the two scenarios above are in fact
> *identical*.
>
> So here's a respin of the fix-async-journal patch that changes what we
> do from:
>
> 1)  Write the journal data, revoke, and descriptor blocks
> 2)  Wait for the block I/O layer to signal that all of these blocks
>       have been written out --- *without* a barrier
> 3)  Write the commit block in ordered mode
> 4)  Wait for the I/O to commit block to be done
>
> To this (in journal_async_commit):
>
> 1)  Write the journal data, revoke, and descriptor blocks
> 2)  Write the commit block (with a checksum) without setting ordered mode
> 3)  Send an empty barrier bio (so we only send a *single* CACHE_FLUSH_EXT)
> 4)  Wait for the I/O to in steps (1) and (2) to be done


I still think that we changing from a situation in which the drive state with 
regards to our transactions is almost always consistent to one in which we will 
often not be consistent.

More or less, moving from tight control of the persistent state on the platter 
to a situation in which, after power failure, we will more often see a bad 
transaction.  The checksum will catch those conditions, but catching and 
repairing is not the same as avoiding the need to repair in the first place :)

The key is really how can we measure the impact of this in a realistic way. How 
many fsck's are needed after a power fail? Chris's directory corruption test?

I have no objections to making this a non-default mount option, but think that 
we will need significant power fail testing before it would be a candidate for 
default use.

It certainly does have a significant performance bump!

ric


>
> This *does* show significant improvements:
>
> Using ./fs_mark  -d  /mnt  -s  10240  -n  1000
>
> W/o journal_async_commit:
>
> FSUse%        Count         Size    Files/sec     App Overhead
>       8         1000        10240         30.5            28242
>
> w/ journal_async_commit:
>
>       8         1000        10240         45.8            28620
>
> w/ barrier=0
>
>       8         1000        10240        320.0            27699
>
>
> Since this patch is a bit more complicated, I'll hold off on making it
> be the default for now, but if the testing goes well, I plan to make
> it default in the next kernel release, since an increase of 50% of
> fs_mark is something I think we all would agree counts as a "clear
> performance advantage".  :-)
>
> 							- Ted
>
> commit fd67d1cfd73f554bae6c37745222eac2723983c8
> Author: Theodore Ts'o<tytso@mit.edu>
> Date:   Thu Sep 10 22:34:27 2009 -0400
>
>      ext4: Fix async commit mode to be safe by using a barrier
>
>      Previously the journal_async_commit mount option was equivalent to
>      using barrier=0 (and just as unsafe).  This patch fixes it so that we
>      eliminate the barrier before the commit block (by not using ordered
>      mode), and explicitly issuing an empty barrier bio after writing the
>      commit block.  Because of the journal checksum, it is safe to do this;
>      if the journal blocks are not all written before a power failure, the
>      checksum in the commit block will prevent the last transaction from
>      being replayed.
>
>      Using the fs_mark benchmark, using journal_async_commit shows a 50%
>      improvement:
>
>      FSUse%        Count         Size    Files/sec     App Overhead
>           8         1000        10240         30.5            28242
>
>      vs.
>
>      FSUse%        Count         Size    Files/sec     App Overhead
>           8         1000        10240         45.8            28620
>
>
>      Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
>
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 7b4088b..d6f4763 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -25,6 +25,7 @@
>   #include<linux/writeback.h>
>   #include<linux/backing-dev.h>
>   #include<linux/bio.h>
> +#include<linux/blkdev.h>
>   #include<trace/events/jbd2.h>
>
>   /*
> @@ -83,6 +84,34 @@ nope:
>   	__brelse(bh);
>   }
>
> +static void end_empty_barrier(struct bio *bio, int err)
> +{
> +	if (err) {
> +		if (err == -EOPNOTSUPP)
> +			set_bit(BIO_EOPNOTSUPP,&bio->bi_flags);
> +		clear_bit(BIO_UPTODATE,&bio->bi_flags);
> +	}
> +	complete(bio->bi_private);
> +}
> +
> +struct bio *issue_flush(struct block_device *bdev, struct completion *wait)
> +{
> +
> +	struct bio *bio;
> +
> +	if (!bdev->bd_disk || !bdev->bd_disk->queue)
> +		return NULL;
> +
> +	bio = bio_alloc(GFP_KERNEL, 0);
> +	if (!bio)
> +		return NULL;
> +	bio->bi_end_io = end_empty_barrier;
> +	bio->bi_private = wait;
> +	bio->bi_bdev = bdev;
> +	submit_bio(WRITE_BARRIER, bio);
> +	return bio;
> +}
> +
>   /*
>    * Done it all: now submit the commit record.  We should have
>    * cleaned up our previous buffers by now, so if we are in abort
> @@ -133,8 +162,8 @@ static int journal_submit_commit_record(journal_t *journal,
>   	bh->b_end_io = journal_end_buffer_io_sync;
>
>   	if (journal->j_flags&  JBD2_BARRIER&&
> -		!JBD2_HAS_INCOMPAT_FEATURE(journal,
> -					 JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
> +	    !JBD2_HAS_INCOMPAT_FEATURE(journal,
> +				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
>   		set_buffer_ordered(bh);
>   		barrier_done = 1;
>   	}
> @@ -352,6 +381,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>   	transaction_t *commit_transaction;
>   	struct journal_head *jh, *new_jh, *descriptor;
>   	struct buffer_head **wbuf = journal->j_wbuf;
> +	struct bio *bio_flush = NULL;
> +	DECLARE_COMPLETION_ONSTACK(wait_flush);
>   	int bufs;
>   	int flags;
>   	int err;
> @@ -707,11 +738,13 @@ start_journal_io:
>   	/* Done it all: now write the commit record asynchronously. */
>
>   	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
> -		JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
> +				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
>   		err = journal_submit_commit_record(journal, commit_transaction,
>   						&cbh, crc32_sum);
>   		if (err)
>   			__jbd2_journal_abort_hard(journal);
> +		if (journal->j_flags&  JBD2_BARRIER)
> +			bio_flush = issue_flush(journal->j_dev,&wait_flush);
>   	}
>
>   	/*
> @@ -833,8 +866,13 @@ wait_for_iobuf:
>
>   	jbd_debug(3, "JBD: commit phase 5\n");
>
> -	if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
> -		JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
> +	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
> +				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
> +		if (bio_flush) {
> +			wait_for_completion(&wait_flush);
> +			bio_put(bio_flush);
> +		}
> +	} else {
>   		err = journal_submit_commit_record(journal, commit_transaction,
>   						&cbh, crc32_sum);
>   		if (err)

