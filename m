From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Mon, 4 Jun 2018 13:46:21 +0200
Message-ID: <CACT4Y+bd8oc3Y5o+mxwktefGc07aU8N25doQRDvD8g8v3TyaZw@mail.gmail.com>
References: <b9c33b04-08d7-87a1-3d93-d81a84e6af12@I-love.SAKURA.ne.jp>
 <43327033306c3dd2f7c3717d64ce22415b6f3451.camel@wdc.com> <CACT4Y+ZJwvROpBmKWF08fTd2AH=dO-a5+dzCzZua_vVFjiCRBw@mail.gmail.com>
 <6db16aa3a7c56b6dcca2d10b4e100a780c740081.camel@wdc.com> <201805220652.BFH82351.SMQFFOJOtFOVLH@I-love.SAKURA.ne.jp>
 <201805222020.FEJ82897.OFtJMFHOVLQOSF@I-love.SAKURA.ne.jp> <25708e84-6f35-04c3-a2e4-6854f0ed9e78@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Alan Jenkins <alan.christopher.jenkins@gmail.com>,
        syzbot <syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>, oleksandr@natalenko.name,
        ming.lei@redhat.com, martin@lichtvoll.de,
        Hannes Reinecke <hare@suse.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        keith.busch@intel.com, linux-ext4@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <25708e84-6f35-04c3-a2e4-6854f0ed9e78@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 1, 2018 at 12:10 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Tetsuo Handa wrote:
>> Since sum of percpu_count did not change after percpu_ref_kill(), this is
>> not a race condition while folding percpu counter values into atomic counter
>> value. That is, for some reason, someone who is responsible for calling
>> percpu_ref_put(&q->q_usage_counter) (presumably via blk_queue_exit()) is
>> unable to call percpu_ref_put().
>> But I don't know how to find someone who is failing to call percpu_ref_put()...
>
> I found the someone. It was already there in the backtrace...

Nice!

Do I understand it correctly that this bug is probably the root cause
of a whole lot of syzbot "task hung" reports? E.g. this one too?
https://syzkaller.appspot.com/bug?id=cdc4add60bb95a4da3fec27c5fe6d75196b7f976
I guess we will need to sweep close everything related to
filesystems/block devices when this is committed?


> ----------------------------------------
> [   62.065852] a.out           D    0  4414   4337 0x00000000
> [   62.067677] Call Trace:
> [   62.068545]  __schedule+0x40b/0x860
> [   62.069726]  schedule+0x31/0x80
> [   62.070796]  schedule_timeout+0x1c1/0x3c0
> [   62.072159]  ? __next_timer_interrupt+0xd0/0xd0
> [   62.073670]  blk_queue_enter+0x218/0x520
> [   62.074985]  ? remove_wait_queue+0x70/0x70
> [   62.076361]  generic_make_request+0x3d/0x540
> [   62.077785]  ? __bio_clone_fast+0x6b/0x80
> [   62.079147]  ? bio_clone_fast+0x2c/0x70
> [   62.080456]  blk_queue_split+0x29b/0x560
> [   62.081772]  ? blk_queue_split+0x29b/0x560
> [   62.083162]  blk_mq_make_request+0x7c/0x430
> [   62.084562]  generic_make_request+0x276/0x540
> [   62.086034]  submit_bio+0x6e/0x140
> [   62.087185]  ? submit_bio+0x6e/0x140
> [   62.088384]  ? guard_bio_eod+0x9d/0x1d0
> [   62.089681]  do_mpage_readpage+0x328/0x730
> [   62.091045]  ? __add_to_page_cache_locked+0x12e/0x1a0
> [   62.092726]  mpage_readpages+0x120/0x190
> [   62.094034]  ? check_disk_change+0x70/0x70
> [   62.095454]  ? check_disk_change+0x70/0x70
> [   62.096849]  ? alloc_pages_current+0x65/0xd0
> [   62.098277]  blkdev_readpages+0x18/0x20
> [   62.099568]  __do_page_cache_readahead+0x298/0x360
> [   62.101157]  ondemand_readahead+0x1f6/0x490
> [   62.102546]  ? ondemand_readahead+0x1f6/0x490
> [   62.103995]  page_cache_sync_readahead+0x29/0x40
> [   62.105539]  generic_file_read_iter+0x7d0/0x9d0
> [   62.107067]  ? futex_wait+0x221/0x240
> [   62.108303]  ? trace_hardirqs_on+0xd/0x10
> [   62.109654]  blkdev_read_iter+0x30/0x40
> [   62.110954]  generic_file_splice_read+0xc5/0x140
> [   62.112538]  do_splice_to+0x74/0x90
> [   62.113726]  splice_direct_to_actor+0xa4/0x1f0
> [   62.115209]  ? generic_pipe_buf_nosteal+0x10/0x10
> [   62.116773]  do_splice_direct+0x8a/0xb0
> [   62.118056]  do_sendfile+0x1aa/0x390
> [   62.119255]  __x64_sys_sendfile64+0x4e/0xc0
> [   62.120666]  do_syscall_64+0x6e/0x210
> [   62.121909]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> ----------------------------------------
>
> The someone is blk_queue_split() from blk_mq_make_request() who depends on an
> assumption that blk_queue_enter() from recursively called generic_make_request()
> does not get blocked due to percpu_ref_tryget_live(&q->q_usage_counter) failure.
>
> ----------------------------------------
> generic_make_request(struct bio *bio) {
>   if (blk_queue_enter(q, flags) < 0) { /* <= percpu_ref_tryget_live() succeeds. */
>     if (!blk_queue_dying(q) && (bio->bi_opf & REQ_NOWAIT))
>       bio_wouldblock_error(bio);
>     else
>       bio_io_error(bio);
>     return ret;
>   }
> (...snipped...)
>   ret = q->make_request_fn(q, bio);
> (...snipped...)
>   if (q)
>     blk_queue_exit(q);
> }
> ----------------------------------------
>
> where q->make_request_fn == blk_mq_make_request which does
>
> ----------------------------------------
> blk_mq_make_request(struct request_queue *q, struct bio *bio) {
>    blk_queue_split(q, &bio);
> }
>
> blk_queue_split(struct request_queue *q, struct bio **bio) {
>   generic_make_request(*bio); /* <= percpu_ref_tryget_live() fails and waits until atomic_read(&q->mq_freeze_depth) becomes 0. */
> }
> ----------------------------------------
>
> and meanwhile atomic_inc_return(&q->mq_freeze_depth) and
> percpu_ref_kill() are called by blk_freeze_queue_start()...
>
> Now, it is up to you about how to fix this race problem.
>
