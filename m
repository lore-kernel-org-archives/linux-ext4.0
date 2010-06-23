From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/3] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
Date: Wed, 23 Jun 2010 10:50:28 -0400
Message-ID: <x49bpb1pzuz.fsf@segfault.boston.devel.redhat.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<1277242502-9047-2-git-send-email-jmoyer@redhat.com>
	<20100622220406.690bb0c8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100622220406.690bb0c8.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 22 Jun 2010 22:04:06 -0700")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 22 Jun 2010 17:35:00 -0400 Jeff Moyer <jmoyer@redhat.com> wrote:
>
>> This patch implements a blk_yield to allow a process to voluntarily
>> give up its I/O scheduler time slice.  This is desirable for those processes
>> which know that they will be blocked on I/O from another process, such as
>> the file system journal thread.  Following patches will put calls to blk_yield
>> into jbd and jbd2.
>> 
>
> I'm looking through this patch series trying to find the
> analysis/description of the cause for this (bad) performance problem. 
> But all I'm seeing is implementation stuff :(  It's hard to review code
> with your eyes shut.

Sorry about that, Andrew.  The problem case is (for example) iozone when
run with small file sizes (up to 8MB) configured to fsync after each
file is written.  Because the iozone process is issuing synchronous
writes, it is put onto CFQ's SYNC service tree.  The significance of
this is that CFQ will idle for up to 8ms waiting for requests on such
queues.  So, what happens is that the iozone process will issue, say,
64KB worth of write I/O.  That I/O will just land in the page cache.
Then, the iozone process does an fsync which forces those I/Os to disk
as synchronous writes.  Then, the file system's fsync method is invoked,
and for ext3/4, it calls log_start_commit followed by log_wait_commit.
Because those synchronous writes were forced out in the context of the
iozone process, CFQ will now idle on iozone's cfqq waiting for more I/O.
However, iozone's progress is gated by the journal thread, now.

So, I tried two approaches to solving the problem.  The first, which
Christoph brought up again in this thread, was to simply mark all
journal I/O as BIO_RW_META, which would cause the iozone process' cfqq
to be preempted when the journal issued its I/O.  However, Vivek pointed
out that this was bad for interactive performance.

The second approach, of which this is the fourth iteration, was to allow
the file system to explicitly tell the I/O scheduler that it is waiting
on I/O from another process.

Does that help?  Let me know if you have any more questions, and thanks
a ton for looking at this, Andrew.  I appreciate it.

The comments I've elided from my response make perfect sense, so I'll
address them in the next posting.

>>  };
>>  #define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
>> -			.count = 0, .min_vdisktime = 0, }
>> +			.count = 0, .min_vdisktime = 0, .last_expiry = 0UL, \
>> +			.last_pid = (pid_t)-1, }
>
> May as well leave the 0 and NULL fields unmentioned (ie: don't do
> crappy stuff because the old code did crappy stuff!)

I don't actually understand why you take issue with this.

>> +{
>> +	struct cfq_data *cfqd = q->elevator->elevator_data;
>> +	struct cfq_io_context *cic, *new_cic;
>> +	struct cfq_queue *cfqq;
>> +
>> +	cic = cfq_cic_lookup(cfqd, current->io_context);
>> +	if (!cic)
>> +		return;
>> +
>> +	task_lock(tsk);
>> +	new_cic = cfq_cic_lookup(cfqd, tsk->io_context);
>> +	atomic_long_inc(&tsk->io_context->refcount);
>
> How do we know tsk has an io_context?  Use get_io_context() and check
> its result?

I'll fix that up.  It works now only by luck (and the fact that there's
a good chance the journal thread has an i/o context).

>> +	task_unlock(tsk);
>> +	if (!new_cic)
>> +		goto out_dec;
>> +
>> +	spin_lock_irq(q->queue_lock);
>> +
>> +	cfqq = cic_to_cfqq(cic, 1);
>> +	if (!cfqq)
>> +		goto out_unlock;
>> +
>> +	/*
>> +	 * If we are currently servicing the SYNC_NOIDLE_WORKLOAD, and we
>> +	 * are idling on the last queue in that workload, *and* there are no
>> +	 * potential dependent readers running currently, then go ahead and
>> +	 * yield the queue.
>> +	 */
>
> Comment explains the code, but doesn't explain the *reason* for the code.

Actually, it explains more than just what the code does.  It would be
difficult for one to divine that the code actually only really cares
about breaking up a currently running dependent reader.  I'll see if I
can make that more clear.

Cheers,
Jeff
