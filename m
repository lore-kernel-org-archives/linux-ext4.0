From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Tue, 15 May 2018 20:45:26 +0900
Message-ID: <343bbbf6-64eb-879e-d19e-96aebb037d47@I-love.SAKURA.ne.jp>
References: <0000000000009b212b056ae6dbad@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        dvyukov@google.com
To: syzbot <syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com>,
        axboe@kernel.dk, linux-block@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000009b212b056ae6dbad@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I managed to obtain SysRq-t when khungtaskd fires using debug printk()
( https://groups.google.com/forum/#!topic/syzkaller-bugs/OTuOsVebAiE ).
Only 4 threads shown below seems to be relevant to this problem.

[  246.929688]   task                        PC stack   pid father
[  249.888937] jbd2/sda1-8     D17736  2271      2 0x80000000
[  249.894586] Call Trace:
[  249.897193]  __schedule+0x801/0x1e30
[  249.900954]  schedule+0xef/0x430
[  249.904356]  io_schedule+0x1c/0x70
[  249.907935]  bit_wait_io+0x18/0x90
[  249.911492]  __wait_on_bit+0xb3/0x130
[  249.915313]  out_of_line_wait_on_bit+0x204/0x3a0
[  249.920105]  __wait_on_buffer+0x76/0x90
[  249.924102]  jbd2_journal_commit_transaction+0x655b/0x8c18
[  249.929893]  kjournald2+0x26c/0xb30
[  249.933579]  kthread+0x345/0x410
[  249.936966]  ret_from_fork+0x3a/0x50
[  254.408972] syz-executor7   D18976  5010   4828 0x00000004
[  254.414639] Call Trace:
[  254.417263]  __schedule+0x801/0x1e30
[  254.421070]  schedule+0xef/0x430
[  254.424467]  blk_queue_enter+0x8da/0xdf0
[  254.428584]  generic_make_request+0x144/0x1510
[  254.433217]  blk_queue_split+0x374/0x2090
[  254.437425]  blk_mq_make_request+0x2d0/0x25c0
[  254.442004]  generic_make_request+0x795/0x1510
[  254.446663]  submit_bio+0xba/0x460
[  254.451104]  mpage_readpages+0x6d7/0x970
[  254.455224]  blkdev_readpages+0x2c/0x40
[  254.459220]  __do_page_cache_readahead+0x79a/0xdc0
[  254.464205]  ondemand_readahead+0x550/0xc40
[  254.468559]  page_cache_sync_readahead+0xd1/0x110
[  254.473430]  generic_file_read_iter+0x1a74/0x2f00
[  254.478423]  blkdev_read_iter+0x120/0x190
[  254.482594]  generic_file_splice_read+0x552/0x910
[  254.487484]  do_splice_to+0x12e/0x190
[  254.491311]  splice_direct_to_actor+0x268/0x8d0
[  254.496017]  do_splice_direct+0x2cc/0x400
[  254.500224]  do_sendfile+0x60f/0xe00
[  254.503971]  __x64_sys_sendfile64+0x155/0x240
[  254.508507]  do_syscall_64+0x1b1/0x800
[  254.512431]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  254.568779] syz-executor7   D25408  5021   4828 0x00000004
[  254.574429] Call Trace:
[  254.577125]  __schedule+0x801/0x1e30
[  254.580882]  schedule+0xef/0x430
[  254.584297]  blk_mq_freeze_queue_wait+0x1ce/0x460
[  254.589192]  blk_freeze_queue+0x4a/0x80
[  254.593209]  blk_mq_freeze_queue+0x15/0x20
[  254.597464]  loop_clr_fd+0x226/0xb80
[  254.601208]  lo_ioctl+0x642/0x2130
[  254.604774]  blkdev_ioctl+0x9b6/0x2020
[  254.608715]  block_ioctl+0xee/0x130
[  254.612362]  do_vfs_ioctl+0x1cf/0x16a0
[  254.616294]  ksys_ioctl+0xa9/0xd0
[  254.619770]  __x64_sys_ioctl+0x73/0xb0
[  254.623674]  do_syscall_64+0x1b1/0x800
[  254.627596]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  255.022839] 1 lock held by syz-executor7/5021:
[  255.028209]  #0:         (ptrval) (&lo->lo_ctl_mutex/1){+.+.}, at: lo_ioctl+0x8d/0x2130
[  254.719133] blkid           D23880  5071   2713 0x00000000
[  254.724791] Call Trace:
[  254.727402]  __schedule+0x801/0x1e30
[  254.731159]  schedule+0xef/0x430
[  254.734562]  schedule_preempt_disabled+0x10/0x20
[  254.739333]  __mutex_lock+0xe38/0x17f0
[  254.743280]  mutex_lock_killable_nested+0x16/0x20
[  254.748135]  lo_ioctl+0x8d/0x2130
[  254.751611]  blkdev_ioctl+0x9b6/0x2020
[  254.755550]  block_ioctl+0xee/0x130
[  254.759200]  do_vfs_ioctl+0x1cf/0x16a0
[  254.763123]  ksys_ioctl+0xa9/0xd0
[  254.766601]  __x64_sys_ioctl+0x73/0xb0
[  254.770506]  do_syscall_64+0x1b1/0x800
[  254.774425]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  255.036399] 1 lock held by blkid/5071:
[  255.041075]  #0:         (ptrval) (&lo->lo_ctl_mutex/1){+.+.}, at: lo_ioctl+0x8d/0x2130



syz-executor7(PID=5021) is doing ioctl(LOOP_CLR_FD).

blkid(PID=5071) is doing ioctl() but is blocked on lo_ctl_mutex which is
held by syz-executor7(PID=5021). Therefore, I assume that blkid(PID=5071)
is irrelevant for this hung up problem.



syz-executor7(PID=5021) is stuck at blk_mq_freeze_queue_wait() from
blk_freeze_queue() from blk_mq_freeze_queue() from loop_clr_fd().

/*
 * Guarantee no request is in use, so we can change any data structure of
 * the queue afterward.
 */
void blk_freeze_queue(struct request_queue *q)
{
	/*
	 * In the !blk_mq case we are only calling this to kill the
	 * q_usage_counter, otherwise this increases the freeze depth
	 * and waits for it to return to zero.  For this reason there is
	 * no blk_unfreeze_queue(), and blk_freeze_queue() is not
	 * exported to drivers as the only user for unfreeze is blk_mq.
	 */
	blk_freeze_queue_start(q);
	if (!q->mq_ops)
		blk_drain_queue(q);
	blk_mq_freeze_queue_wait(q);
}

q->mq_freeze_depth is incremented at blk_freeze_queue_start() and
the caller waits until q->q_usage_counter becomes 0.

void blk_freeze_queue_start(struct request_queue *q)
{
	int freeze_depth;

	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
	if (freeze_depth == 1) {
		percpu_ref_kill(&q->q_usage_counter);
		if (q->mq_ops)
			blk_mq_run_hw_queues(q, false);
	}
}

void blk_mq_freeze_queue_wait(struct request_queue *q)
{
	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
}

I couldn't check whether freeze_depth in blk_freeze_queue_start() was 1,
but presumably q->mq_freeze_depth > 0 because syz-executor7(PID=5010) is
stuck at wait_event() in blk_queue_enter().

syz-executor7   D18976  5010   4828 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2859 [inline]
  __schedule+0x801/0x1e30 kernel/sched/core.c:3501
  schedule+0xef/0x430 kernel/sched/core.c:3545
  blk_queue_enter+0x8da/0xdf0 block/blk-core.c:953
  generic_make_request+0x144/0x1510 block/blk-core.c:2395
  blk_queue_split+0x374/0x2090 block/blk-merge.c:215
  blk_mq_make_request+0x2d0/0x25c0 block/blk-mq.c:1861
  generic_make_request+0x795/0x1510 block/blk-core.c:2460
  submit_bio+0xba/0x460 block/blk-core.c:2568
  mpage_bio_submit fs/mpage.c:66 [inline]
  mpage_readpages+0x6d7/0x970 fs/mpage.c:393
  blkdev_readpages+0x2c/0x40 fs/block_dev.c:577
  read_pages mm/readahead.c:121 [inline]
  __do_page_cache_readahead+0x79a/0xdc0 mm/readahead.c:199
  ra_submit mm/internal.h:66 [inline]
  ondemand_readahead+0x550/0xc40 mm/readahead.c:478
  page_cache_sync_readahead+0xd1/0x110 mm/readahead.c:510
  generic_file_buffered_read mm/filemap.c:2092 [inline]
  generic_file_read_iter+0x1a74/0x2f00 mm/filemap.c:2362
  blkdev_read_iter+0x120/0x190 fs/block_dev.c:1930
  call_read_iter include/linux/fs.h:1778 [inline]
  generic_file_splice_read+0x552/0x910 fs/splice.c:307
  do_splice_to+0x12e/0x190 fs/splice.c:880
  splice_direct_to_actor+0x268/0x8d0 fs/splice.c:952
  do_splice_direct+0x2cc/0x400 fs/splice.c:1061
  do_sendfile+0x60f/0xe00 fs/read_write.c:1440
  __do_sys_sendfile64 fs/read_write.c:1495 [inline]
  __se_sys_sendfile64 fs/read_write.c:1487 [inline]
  __x64_sys_sendfile64+0x155/0x240 fs/read_write.c:1487
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Since flags == 0, preempt == false. Since stuck at wait_event(), success == false.
Thus, atomic_read(&q->mq_freeze_depth) > 0 if blk_queue_dying(q) == false. And I
guess blk_queue_dying(q) == false because we are just trying to freeze/unfreeze.

/**
 * blk_queue_enter() - try to increase q->q_usage_counter
 * @q: request queue pointer
 * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
 */
int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
{
	const bool preempt = flags & BLK_MQ_REQ_PREEMPT;

	while (true) {
		bool success = false;

		rcu_read_lock();
		if (percpu_ref_tryget_live(&q->q_usage_counter)) {
			/*
			 * The code that sets the PREEMPT_ONLY flag is
			 * responsible for ensuring that that flag is globally
			 * visible before the queue is unfrozen.
			 */
			if (preempt || !blk_queue_preempt_only(q)) {
				success = true;
			} else {
				percpu_ref_put(&q->q_usage_counter);
			}
		}
		rcu_read_unlock();

		if (success)
			return 0;

		if (flags & BLK_MQ_REQ_NOWAIT)
			return -EBUSY;

		/*
		 * read pair of barrier in blk_freeze_queue_start(),
		 * we need to order reading __PERCPU_REF_DEAD flag of
		 * .q_usage_counter and reading .mq_freeze_depth or
		 * queue dying flag, otherwise the following wait may
		 * never return if the two reads are reordered.
		 */
		smp_rmb();

		wait_event(q->mq_freeze_wq,
			   (atomic_read(&q->mq_freeze_depth) == 0 &&
			    (preempt || !blk_queue_preempt_only(q))) ||
			   blk_queue_dying(q));
		if (blk_queue_dying(q))
			return -ENODEV;
	}
}



jbd2/sda1-8(PID=2271) is stuck waiting for journal commit operation.
I don't know how this thread is involved to this problem.

jbd2/sda1-8     D17736  2271      2 0x80000000
Call Trace:
  context_switch kernel/sched/core.c:2859 [inline]
  __schedule+0x801/0x1e30 kernel/sched/core.c:3501
  schedule+0xef/0x430 kernel/sched/core.c:3545
  io_schedule+0x1c/0x70 kernel/sched/core.c:5165
  bit_wait_io+0x18/0x90 kernel/sched/wait_bit.c:207
  __wait_on_bit+0xb3/0x130 kernel/sched/wait_bit.c:48
  out_of_line_wait_on_bit+0x204/0x3a0 kernel/sched/wait_bit.c:63
  wait_on_bit_io include/linux/wait_bit.h:101 [inline]
  __wait_on_buffer+0x76/0x90 fs/buffer.c:118
  wait_on_buffer include/linux/buffer_head.h:356 [inline]
  journal_wait_on_commit_record fs/jbd2/commit.c:174 [inline]
  jbd2_journal_commit_transaction+0x655b/0x8c18 fs/jbd2/commit.c:865
  kjournald2+0x26c/0xb30 fs/jbd2/journal.c:229
  kthread+0x345/0x410 kernel/kthread.c:240
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412



Can we find the culprit from these hints?
