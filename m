From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Wed, 16 May 2018 22:05:06 +0900
Message-ID: <b9c33b04-08d7-87a1-3d93-d81a84e6af12@I-love.SAKURA.ne.jp>
References: <0000000000009b212b056ae6dbad@google.com>
 <343bbbf6-64eb-879e-d19e-96aebb037d47@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        dvyukov@google.com,
        Alan Jenkins <alan.christopher.jenkins@gmail.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Keith Busch <keith.busch@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Ming Lei <ming.lei@redhat.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: syzbot <syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com>,
        linux-block@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Dan Williams <dan.j.williams@intel.com>,
        Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <343bbbf6-64eb-879e-d19e-96aebb037d47@I-love.SAKURA.ne.jp>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Tetsuo Handa wrote:
> I couldn't check whether freeze_depth in blk_freeze_queue_start() was 1,
> but presumably q->mq_freeze_depth > 0 because syz-executor7(PID=5010) is
> stuck at wait_event() in blk_queue_enter().
> 
> Since flags == 0, preempt == false. Since stuck at wait_event(), success == false.
> Thus, atomic_read(&q->mq_freeze_depth) > 0 if blk_queue_dying(q) == false. And I
> guess blk_queue_dying(q) == false because we are just trying to freeze/unfreeze.
> 

I was able to reproduce the hung up using modified reproducer, and got values
using below debug printk() patch.

  --- a/block/blk-core.c
  +++ b/block/blk-core.c
  @@ -950,10 +950,12 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
   		 */
   		smp_rmb();
   
  -		wait_event(q->mq_freeze_wq,
  -			   (atomic_read(&q->mq_freeze_depth) == 0 &&
  -			    (preempt || !blk_queue_preempt_only(q))) ||
  -			   blk_queue_dying(q));
  +		while (wait_event_timeout(q->mq_freeze_wq,
  +					  (atomic_read(&q->mq_freeze_depth) == 0 &&
  +					   (preempt || !blk_queue_preempt_only(q))) ||
  +					  blk_queue_dying(q), 10 * HZ) == 0)
  +			printk("%s(%u): q->mq_freeze_depth=%d preempt=%d blk_queue_preempt_only(q)=%d blk_queue_dying(q)=%d\n",
  +			       current->comm, current->pid, atomic_read(&q->mq_freeze_depth), preempt, blk_queue_preempt_only(q), blk_queue_dying(q));
   		if (blk_queue_dying(q))
   			return -ENODEV;
   	}

[   75.869126] print_req_error: I/O error, dev loop0, sector 0
[   85.983146] a.out(8838): q->mq_freeze_depth=1 preempt=0 blk_queue_preempt_only(q)=0 blk_queue_dying(q)=0
[   96.222884] a.out(8838): q->mq_freeze_depth=1 preempt=0 blk_queue_preempt_only(q)=0 blk_queue_dying(q)=0
[  106.463322] a.out(8838): q->mq_freeze_depth=1 preempt=0 blk_queue_preempt_only(q)=0 blk_queue_dying(q)=0
[  116.702912] a.out(8838): q->mq_freeze_depth=1 preempt=0 blk_queue_preempt_only(q)=0 blk_queue_dying(q)=0

One ore more threads are waiting for q->mq_freeze_depth to become 0. But the
thread who incremented q->mq_freeze_depth at blk_freeze_queue_start(q) from
blk_freeze_queue() is waiting at blk_mq_freeze_queue_wait(). Therefore,
atomic_read(&q->mq_freeze_depth) == 0 condition for wait_event() in
blk_queue_enter() will never be satisfied. But what does that wait_event()
want to do? Isn't "start freezing" a sort of blk_queue_dying(q) == true?
Since percpu_ref_tryget_live(&q->q_usage_counter) failed and the queue is
about to be frozen, shouldn't we treat atomic_read(&q->mq_freeze_depth) != 0
as if blk_queue_dying(q) == true? That is, something like below:

diff --git a/block/blk-core.c b/block/blk-core.c
index 85909b4..59e2496 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -951,10 +951,10 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 		smp_rmb();
 
 		wait_event(q->mq_freeze_wq,
-			   (atomic_read(&q->mq_freeze_depth) == 0 &&
-			    (preempt || !blk_queue_preempt_only(q))) ||
+			   atomic_read(&q->mq_freeze_depth) ||
+			   (preempt || !blk_queue_preempt_only(q)) ||
 			   blk_queue_dying(q));
-		if (blk_queue_dying(q))
+		if (atomic_read(&q->mq_freeze_depth) || blk_queue_dying(q))
 			return -ENODEV;
 	}
 }
