From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: v4.16-rc2: virtio-block + ext4 lockdep splats / sleeping from
 invalid context
Date: Mon, 26 Feb 2018 11:38:19 +0000
Message-ID: <20180226113818.v544mmjsavc4x5q2@lakrids.cambridge.arm.com>
References: <20180223154735.x4ezmpjbjm6o6duw@lakrids.cambridge.arm.com>
 <20180226105256.jagidoki6vsrvzb4@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-ext4@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180226105256.jagidoki6vsrvzb4@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 26, 2018 at 11:52:56AM +0100, Jan Kara wrote:
> On Fri 23-02-18 15:47:36, Mark Rutland wrote:
> > Hi all,
> > 
> > While fuzzing arm64/v4.16-rc2 with syzkaller, I simultaneously hit a
> > number of splats in the block layer:
> > 
> > * inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-R} usage in
> >   jbd2_trans_will_send_data_barrier
> > 
> > * BUG: sleeping function called from invalid context at mm/mempool.c:320
> > 
> > * WARNING: CPU: 0 PID: 0 at block/blk.h:297 generic_make_request_checks+0x670/0x750
> > 
> > ... I've included the full splats at the end of the mail.
> > 
> > These all happen in the context of the virtio block IRQ handler, so I
> > wonder if this calls something that doesn't expect to be called from IRQ
> > context. Is it valid to call blk_mq_complete_request() or
> > blk_mq_end_request() from an IRQ handler?
> 
> No, it's likely a bug in detection whether IO completion should be deferred
> to a workqueue or not. Does attached patch fix the problem? I don't see
> exactly this being triggered by the syzkaller but it's close enough :)
> 
> 								Honza

That seems to be it!

With the below patch applied, I can't trigger the bug after ~10 minutes,
whereas prior to the patch I can trigger it in ~10 seconds. I'll leave
that running for a while just in case there's another part to the
problem, but FWIW:

Tested-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> From 501d97ed88f5020a55a0de4d546df5ad11461cea Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Mon, 26 Feb 2018 11:36:52 +0100
> Subject: [PATCH] direct-io: Fix sleep in atomic due to sync AIO
> 
> Commit e864f39569f4 "fs: add RWF_DSYNC aand RWF_SYNC" added additional
> way for direct IO to become synchronous and thus trigger fsync from the
> IO completion handler. Then commit 9830f4be159b "fs: Use RWF_* flags for
> AIO operations" allowed these flags to be set for AIO as well. However
> that commit forgot to update the condition checking whether the IO
> completion handling should be defered to a workqueue and thus AIO DIO
> with RWF_[D]SYNC set will call fsync() from IRQ context resulting in
> sleep in atomic.
> 
> Fix the problem by checking directly iocb flags (the same way as it is
> done in dio_complete()) instead of checking all conditions that could
> lead to IO being synchronous.
> 
> CC: Christoph Hellwig <hch@lst.de>
> CC: Goldwyn Rodrigues <rgoldwyn@suse.com>
> CC: stable@vger.kernel.org
> Reported-by: Mark Rutland <mark.rutland@arm.com>
> Fixes: 9830f4be159b29399d107bffb99e0132bc5aedd4
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/direct-io.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index a0ca9e48e993..1357ef563893 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -1274,8 +1274,7 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
>  	 */
>  	if (dio->is_async && iov_iter_rw(iter) == WRITE) {
>  		retval = 0;
> -		if ((iocb->ki_filp->f_flags & O_DSYNC) ||
> -		    IS_SYNC(iocb->ki_filp->f_mapping->host))
> +		if (iocb->ki_flags & IOCB_DSYNC)
>  			retval = dio_set_defer_completion(dio);
>  		else if (!dio->inode->i_sb->s_dio_done_wq) {
>  			/*
> -- 
> 2.13.6
> 
