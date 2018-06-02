From: Ming Lei <ming.lei@redhat.com>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Sat, 2 Jun 2018 10:36:30 +0800
Message-ID: <20180602023622.GA2306@ming.t460p>
References: <b9c33b04-08d7-87a1-3d93-d81a84e6af12@I-love.SAKURA.ne.jp>
 <43327033306c3dd2f7c3717d64ce22415b6f3451.camel@wdc.com>
 <CACT4Y+ZJwvROpBmKWF08fTd2AH=dO-a5+dzCzZua_vVFjiCRBw@mail.gmail.com>
 <6db16aa3a7c56b6dcca2d10b4e100a780c740081.camel@wdc.com>
 <201805220652.BFH82351.SMQFFOJOtFOVLH@I-love.SAKURA.ne.jp>
 <201805222020.FEJ82897.OFtJMFHOVLQOSF@I-love.SAKURA.ne.jp>
 <25708e84-6f35-04c3-a2e4-6854f0ed9e78@I-love.SAKURA.ne.jp>
 <dc9862c7-ec16-8b11-04e4-422b435d41ef@kernel.dk>
 <20180601234946.GA655@ming.t460p>
 <95c419d8-7f19-f9c0-a53f-3d381fe93176@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Bart.VanAssche@wdc.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        jthumshirn@suse.de, alan.christopher.jenkins@gmail.com,
        syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com,
        martin.petersen@oracle.com, dan.j.williams@intel.com, hch@lst.de,
        oleksandr@natalenko.name, martin@lichtvoll.de, hare@suse.com,
        syzkaller-bugs@googlegroups.com, ross.zwisler@linux.intel.com,
        keith.busch@intel.com, linux-ext4@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <95c419d8-7f19-f9c0-a53f-3d381fe93176@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 01, 2018 at 06:49:10PM -0600, Jens Axboe wrote:
> On 6/1/18 5:49 PM, Ming Lei wrote:
> > On Fri, Jun 01, 2018 at 11:52:45AM -0600, Jens Axboe wrote:
> >> On 6/1/18 4:10 AM, Tetsuo Handa wrote:
> >>> Tetsuo Handa wrote:
> >>>> Since sum of percpu_count did not change after percpu_ref_kill(), this is
> >>>> not a race condition while folding percpu counter values into atomic counter
> >>>> value. That is, for some reason, someone who is responsible for calling
> >>>> percpu_ref_put(&q->q_usage_counter) (presumably via blk_queue_exit()) is
> >>>> unable to call percpu_ref_put().
> >>>> But I don't know how to find someone who is failing to call percpu_ref_put()...
> >>>
> >>> I found the someone. It was already there in the backtrace...
> >>>
> >>> ----------------------------------------
> >>> [   62.065852] a.out           D    0  4414   4337 0x00000000
> >>> [   62.067677] Call Trace:
> >>> [   62.068545]  __schedule+0x40b/0x860
> >>> [   62.069726]  schedule+0x31/0x80
> >>> [   62.070796]  schedule_timeout+0x1c1/0x3c0
> >>> [   62.072159]  ? __next_timer_interrupt+0xd0/0xd0
> >>> [   62.073670]  blk_queue_enter+0x218/0x520
> >>> [   62.074985]  ? remove_wait_queue+0x70/0x70
> >>> [   62.076361]  generic_make_request+0x3d/0x540
> >>> [   62.077785]  ? __bio_clone_fast+0x6b/0x80
> >>> [   62.079147]  ? bio_clone_fast+0x2c/0x70
> >>> [   62.080456]  blk_queue_split+0x29b/0x560
> >>> [   62.081772]  ? blk_queue_split+0x29b/0x560
> >>> [   62.083162]  blk_mq_make_request+0x7c/0x430
> >>> [   62.084562]  generic_make_request+0x276/0x540
> >>> [   62.086034]  submit_bio+0x6e/0x140
> >>> [   62.087185]  ? submit_bio+0x6e/0x140
> >>> [   62.088384]  ? guard_bio_eod+0x9d/0x1d0
> >>> [   62.089681]  do_mpage_readpage+0x328/0x730
> >>> [   62.091045]  ? __add_to_page_cache_locked+0x12e/0x1a0
> >>> [   62.092726]  mpage_readpages+0x120/0x190
> >>> [   62.094034]  ? check_disk_change+0x70/0x70
> >>> [   62.095454]  ? check_disk_change+0x70/0x70
> >>> [   62.096849]  ? alloc_pages_current+0x65/0xd0
> >>> [   62.098277]  blkdev_readpages+0x18/0x20
> >>> [   62.099568]  __do_page_cache_readahead+0x298/0x360
> >>> [   62.101157]  ondemand_readahead+0x1f6/0x490
> >>> [   62.102546]  ? ondemand_readahead+0x1f6/0x490
> >>> [   62.103995]  page_cache_sync_readahead+0x29/0x40
> >>> [   62.105539]  generic_file_read_iter+0x7d0/0x9d0
> >>> [   62.107067]  ? futex_wait+0x221/0x240
> >>> [   62.108303]  ? trace_hardirqs_on+0xd/0x10
> >>> [   62.109654]  blkdev_read_iter+0x30/0x40
> >>> [   62.110954]  generic_file_splice_read+0xc5/0x140
> >>> [   62.112538]  do_splice_to+0x74/0x90
> >>> [   62.113726]  splice_direct_to_actor+0xa4/0x1f0
> >>> [   62.115209]  ? generic_pipe_buf_nosteal+0x10/0x10
> >>> [   62.116773]  do_splice_direct+0x8a/0xb0
> >>> [   62.118056]  do_sendfile+0x1aa/0x390
> >>> [   62.119255]  __x64_sys_sendfile64+0x4e/0xc0
> >>> [   62.120666]  do_syscall_64+0x6e/0x210
> >>> [   62.121909]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >>> ----------------------------------------
> >>>
> >>> The someone is blk_queue_split() from blk_mq_make_request() who depends on an
> >>> assumption that blk_queue_enter() from recursively called generic_make_request()
> >>> does not get blocked due to percpu_ref_tryget_live(&q->q_usage_counter) failure.
> >>>
> >>> ----------------------------------------
> >>> generic_make_request(struct bio *bio) {
> >>>   if (blk_queue_enter(q, flags) < 0) { /* <= percpu_ref_tryget_live() succeeds. */
> >>>     if (!blk_queue_dying(q) && (bio->bi_opf & REQ_NOWAIT))
> >>>       bio_wouldblock_error(bio);
> >>>     else
> >>>       bio_io_error(bio);
> >>>     return ret;
> >>>   }
> >>> (...snipped...)
> >>>   ret = q->make_request_fn(q, bio);
> >>> (...snipped...)
> >>>   if (q)
> >>>     blk_queue_exit(q);
> >>> }
> >>> ----------------------------------------
> >>>
> >>> where q->make_request_fn == blk_mq_make_request which does
> >>>
> >>> ----------------------------------------
> >>> blk_mq_make_request(struct request_queue *q, struct bio *bio) {
> >>>    blk_queue_split(q, &bio);
> >>> }
> >>>
> >>> blk_queue_split(struct request_queue *q, struct bio **bio) {
> >>>   generic_make_request(*bio); /* <= percpu_ref_tryget_live() fails and waits until atomic_read(&q->mq_freeze_depth) becomes 0. */
> >>> }
> >>> ----------------------------------------
> >>>
> >>> and meanwhile atomic_inc_return(&q->mq_freeze_depth) and
> >>> percpu_ref_kill() are called by	blk_freeze_queue_start()...
> >>>
> >>> Now, it is up to you about how to fix this race problem.
> >>
> >> Ahh, nicely spotted! One idea would be the one below. For this case,
> >> we're recursing, so we can either do a non-block queue enter, or we
> >> can just do a live enter.
> >>
> >> diff --git a/block/blk-core.c b/block/blk-core.c
> >> index 85909b431eb0..7de12e0dcc3d 100644
> >> --- a/block/blk-core.c
> >> +++ b/block/blk-core.c
> >> @@ -2392,7 +2392,9 @@ blk_qc_t generic_make_request(struct bio *bio)
> >>  
> >>  	if (bio->bi_opf & REQ_NOWAIT)
> >>  		flags = BLK_MQ_REQ_NOWAIT;
> >> -	if (blk_queue_enter(q, flags) < 0) {
> >> +	if (bio->bi_opf & REQ_QUEUE_ENTERED)
> >> +		blk_queue_enter_live(q);
> >> +	else if (blk_queue_enter(q, flags) < 0) {
> >>  		if (!blk_queue_dying(q) && (bio->bi_opf & REQ_NOWAIT))
> >>  			bio_wouldblock_error(bio);
> >>  		else
> >> diff --git a/block/blk-merge.c b/block/blk-merge.c
> >> index 782940c65d8a..e1063e8f7eda 100644
> >> --- a/block/blk-merge.c
> >> +++ b/block/blk-merge.c
> >> @@ -210,6 +210,16 @@ void blk_queue_split(struct request_queue *q, struct bio **bio)
> >>  		/* there isn't chance to merge the splitted bio */
> >>  		split->bi_opf |= REQ_NOMERGE;
> >>  
> >> +		/*
> >> +		 * Since we're recursing into make_request here, ensure
> >> +		 * that we mark this bio as already having entered the queue.
> >> +		 * If not, and the queue is going away, we can get stuck
> >> +		 * forever on waiting for the queue reference to drop. But
> >> +		 * that will never happen, as we're already holding a
> >> +		 * reference to it.
> >> +		 */
> >> +		(*bio)->bi_opf |= REQ_QUEUE_ENTERED;
> >> +
> >>  		bio_chain(split, *bio);
> >>  		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
> >>  		generic_make_request(*bio);
> >> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> >> index 17b18b91ebac..a6bc789b83e7 100644
> >> --- a/include/linux/blk_types.h
> >> +++ b/include/linux/blk_types.h
> >> @@ -282,6 +282,8 @@ enum req_flag_bits {
> >>  	/* command specific flags for REQ_OP_WRITE_ZEROES: */
> >>  	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
> >>  
> >> +	__REQ_QUEUE_ENTERED,	/* queue already entered for this request */
> >> +
> >>  	/* for driver use */
> >>  	__REQ_DRV,
> >>  
> >> @@ -302,9 +304,8 @@ enum req_flag_bits {
> >>  #define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
> >>  #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
> >>  #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
> >> -
> >>  #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
> >> -
> >> +#define REQ_QUEUE_ENTERED	(1ULL << __REQ_QUEUE_ENTERED)
> >>  #define REQ_DRV			(1ULL << __REQ_DRV)
> >>  
> >>  #define REQ_FAILFAST_MASK \
> > 
> > bio clone inherits .bi_opf, so this way may not work for cloned bio.
> > 
> > Given most of bio_split() is run in .make_request_fn(), holding the
> > queue ref may not be needed in case of bio splitting, so another
> > candidate fix might be to introduce one extra parameter of
> > 'need_queue_ref' to generic_make_request().
> 
> I did consider that, but that's pretty silly for a corner case and you'd
> have to change a crap ton of calls to it. I think it'd be cleaner to

Seems not necessary to change any call to it, since all blk_queue_split()
are called from q->make_request_fn() now.

> clear the bit when we need to, potentially even adding a debug check to
> blk_queue_enter_live() that complains if the ref was not already
> elevated. Though that would be expensive, compared to the percpu inc
> now. Not saying the bit is necessarily the best way forward, but I do
> like it a LOT more than adding an argument to generic_make_request.

We may introduce generic_make_request_with_ref() for blk_queue_split(),
what do you think of the following patch?

diff --git a/block/blk-core.c b/block/blk-core.c
index cee03cad99f2..e10ee3f9f338 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2363,7 +2363,7 @@ generic_make_request_checks(struct bio *bio)
  * a lower device by calling into generic_make_request recursively, which
  * means the bio should NOT be touched after the call to ->make_request_fn.
  */
-blk_qc_t generic_make_request(struct bio *bio)
+blk_qc_t __generic_make_request(struct bio *bio, bool got_ref)
 {
 	/*
 	 * bio_list_on_stack[0] contains bios submitted by the current
@@ -2379,12 +2379,14 @@ blk_qc_t generic_make_request(struct bio *bio)
 
 	if (bio->bi_opf & REQ_NOWAIT)
 		flags = BLK_MQ_REQ_NOWAIT;
-	if (blk_queue_enter(q, flags) < 0) {
-		if (!blk_queue_dying(q) && (bio->bi_opf & REQ_NOWAIT))
-			bio_wouldblock_error(bio);
-		else
-			bio_io_error(bio);
-		return ret;
+	if (!got_ref) {
+		if (blk_queue_enter(q, flags) < 0) {
+			if (!blk_queue_dying(q) && (bio->bi_opf & REQ_NOWAIT))
+				bio_wouldblock_error(bio);
+			else
+				bio_io_error(bio);
+			return ret;
+		}
 	}
 
 	if (!generic_make_request_checks(bio))
@@ -2426,8 +2428,9 @@ blk_qc_t generic_make_request(struct bio *bio)
 		bool enter_succeeded = true;
 
 		if (unlikely(q != bio->bi_disk->queue)) {
-			if (q)
+			if (q && !got_ref)
 				blk_queue_exit(q);
+			got_ref = false;
 			q = bio->bi_disk->queue;
 			flags = 0;
 			if (bio->bi_opf & REQ_NOWAIT)
@@ -2476,7 +2479,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 		blk_queue_exit(q);
 	return ret;
 }
-EXPORT_SYMBOL(generic_make_request);
+EXPORT_SYMBOL(__generic_make_request);
 
 /**
  * direct_make_request - hand a buffer directly to its device driver for I/O
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5573d0fbec53..997616f1c85e 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -180,6 +180,9 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 	return do_split ? new : NULL;
 }
 
+/*
+ * This function has to be called from q->make_request_fn().
+ */
 void blk_queue_split(struct request_queue *q, struct bio **bio)
 {
 	struct bio *split, *res;
@@ -212,7 +215,7 @@ void blk_queue_split(struct request_queue *q, struct bio **bio)
 
 		bio_chain(split, *bio);
 		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
-		generic_make_request(*bio);
+		generic_make_request_with_ref(*bio);
 		*bio = split;
 	}
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4efd9af62e25..051018e0126e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -956,9 +956,18 @@ static inline void rq_flush_dcache_pages(struct request *rq)
 }
 #endif
 
+blk_qc_t generic_make_request(struct bio *bio)
+{
+	return __generic_make_request(bio, false);
+}
+
+blk_qc_t generic_make_request_with_ref(struct bio *bio)
+{
+	return __generic_make_request(bio, true);
+}
+
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
-extern blk_qc_t generic_make_request(struct bio *bio);
 extern blk_qc_t direct_make_request(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_init_request_from_bio(struct request *req, struct bio *bio);
> 
> It should have been a bio flag to begin with, that better captures the
> scope and also avoids clones inheriting anything they shouldn't. It's
> also not applicable to a request.
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 85909b431eb0..8f1063f50863 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2392,7 +2392,9 @@ blk_qc_t generic_make_request(struct bio *bio)
>  
>  	if (bio->bi_opf & REQ_NOWAIT)
>  		flags = BLK_MQ_REQ_NOWAIT;
> -	if (blk_queue_enter(q, flags) < 0) {
> +	if (bio->bi_flags & BIO_QUEUE_ENTERED)
> +		blk_queue_enter_live(q);
> +	else if (blk_queue_enter(q, flags) < 0) {
>  		if (!blk_queue_dying(q) && (bio->bi_opf & REQ_NOWAIT))
>  			bio_wouldblock_error(bio);
>  		else
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 782940c65d8a..9ee9474e579c 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -210,6 +210,16 @@ void blk_queue_split(struct request_queue *q, struct bio **bio)
>  		/* there isn't chance to merge the splitted bio */
>  		split->bi_opf |= REQ_NOMERGE;
>  
> +		/*
> +		 * Since we're recursing into make_request here, ensure
> +		 * that we mark this bio as already having entered the queue.
> +		 * If not, and the queue is going away, we can get stuck
> +		 * forever on waiting for the queue reference to drop. But
> +		 * that will never happen, as we're already holding a
> +		 * reference to it.
> +		 */
> +		(*bio)->bi_flags |= BIO_QUEUE_ENTERED;
> +
>  		bio_chain(split, *bio);
>  		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
>  		generic_make_request(*bio);
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 17b18b91ebac..4687d7c99076 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -186,6 +186,8 @@ struct bio {
>  				 * throttling rules. Don't do it again. */
>  #define BIO_TRACE_COMPLETION 10	/* bio_endio() should trace the final completion
>  				 * of this bio. */
> +#define BIO_QUEUE_ENTERED 11	/* can use blk_queue_enter_live() */
> +
>  /* See BVEC_POOL_OFFSET below before adding new flags */

In DM or MD, there is the following use case:

1) bio comes from fs, then one clone is made from this bio

2) the cloned bio is submitted via generic_make_request() from
another context, such as wq.

3) then the flag of BIO_QUEUE_ENTERED is inherited and causes
the queue usage counter isn't held.


Thanks,
Ming
