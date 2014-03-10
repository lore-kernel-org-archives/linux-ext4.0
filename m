From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] fs: only call sync_filesystem() when remounting
 read-only
Date: Mon, 10 Mar 2014 10:41:28 -0400
Message-ID: <20140310144128.GC10562@thunk.org>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140308160818.GC11633@thunk.org>
 <20140310114508.GA28107@xanadu.blop.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Emmanuel Jeanvoine <emmanuel.jeanvoine@inria.fr>
To: Lucas Nussbaum <lucas.nussbaum@loria.fr>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140310114508.GA28107@xanadu.blop.info>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 10, 2014 at 12:45:08PM +0100, Lucas Nussbaum wrote:
> > Lukas, can you try this patch?  I'm pretty sure this is what's going
> > on.  It turns out each "mount -o remount" is implying an fsync(), so
> > your test case is identical to copying a large file while having
> > thousand of processes calling syncfs() on the file system, with the
> > predictable results.
> 
> Hi Ted,
> 
> I can confirm that:
> 1) the patch solves my problem
> 2) issuing 'sync' instead of 'mount -o remount' indeed exhibits the
>    problem again
> 
> However, I'm curious: why would such a workload (multiple syncfs()
> initiated during a write) block for several minutes on an ext4
> filesystem? I've just tried again on ext3, and it's not a problem in
> that case.

The reason why is because ext3 is less careful than ext4.
ext3_sync_fs() simply tries to start a commit, and if there is already
a commit already started, it does nothing.  So if you issue a
gazillion syncfs() calls, with ext3, it's a no-op.

For ext4, each syncfs() call will result in a SYNC_CACHE flushh being
sent to the disk:

	/*
	 * Data writeback is possible w/o journal transaction, so barrier must
	 * being sent at the end of the function. But we can skip it if
	 * transaction_commit will do it for us.
	 */
	target = jbd2_get_latest_transaction(sbi->s_journal);
	if (wait && sbi->s_journal->j_flags & JBD2_BARRIER &&
	    !jbd2_trans_will_send_data_barrier(sbi->s_journal, target))
		needs_barrier = true;
		.
		.
		.
	if (needs_barrier) {
		int err;
		err = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
		if (!ret)
			ret = err;
	}

We can debate whether or not this care is necessary, and since
syncfs() isn't terribly reliable, we could add hacks so that if an
syncfs() had been issued in the last 100ms, we could make it be a
no-op, or some other horrible hack.

But given that these hacks are horrible, it's not clear that it's
worth it to do all of this just to something where userspace is doing
something really stupid, whether it is issuing thousands of syncfs()
or "mount -o remount" requests per second.

Cheers,

						- Ted
