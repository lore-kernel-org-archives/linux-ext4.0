From: Ming Lei <ming.lei@redhat.com>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Tue, 5 Jun 2018 08:41:35 +0800
Message-ID: <20180605004128.GA28826@ming.t460p>
References: <25708e84-6f35-04c3-a2e4-6854f0ed9e78@I-love.SAKURA.ne.jp>
 <dc9862c7-ec16-8b11-04e4-422b435d41ef@kernel.dk>
 <201806050027.w550RfJl010157@www262.sakura.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>, Bart.VanAssche@wdc.com,
        dvyukov@google.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, jthumshirn@suse.de,
        alan.christopher.jenkins@gmail.com,
        syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com,
        martin.petersen@oracle.com, dan.j.williams@intel.com, hch@lst.de,
        oleksandr@natalenko.name, martin@lichtvoll.de, hare@suse.com,
        syzkaller-bugs@googlegroups.com, ross.zwisler@linux.intel.com,
        keith.busch@intel.com, linux-ext4@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201806050027.w550RfJl010157@www262.sakura.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 05, 2018 at 09:27:41AM +0900, Tetsuo Handa wrote:
> Jens Axboe wrote:
> > On 6/1/18 4:10 AM, Tetsuo Handa wrote:
> > > Tetsuo Handa wrote:
> > >> Since sum of percpu_count did not change after percpu_ref_kill(), this is
> > >> not a race condition while folding percpu counter values into atomic counter
> > >> value. That is, for some reason, someone who is responsible for calling
> > >> percpu_ref_put(&q->q_usage_counter) (presumably via blk_queue_exit()) is
> > >> unable to call percpu_ref_put().
> > >> But I don't know how to find someone who is failing to call percpu_ref_put()...
> > > 
> > > I found the someone. It was already there in the backtrace...
> > > 
> > 
> > Ahh, nicely spotted! One idea would be the one below. For this case,
> > we're recursing, so we can either do a non-block queue enter, or we
> > can just do a live enter.
> > 
> 
> While "block: don't use blocking queue entered for recursive bio submits" was
> already applied, syzbot is still reporting a hung task with same signature but
> different trace.
> 
> https://syzkaller.appspot.com/text?tag=CrashLog&x=1432cedf800000
> ----------------------------------------
> [  492.512243] INFO: task syz-executor1:20263 blocked for more than 120 seconds.
> [  492.519604]       Not tainted 4.17.0+ #83
> [  492.523793] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  492.531787] syz-executor1   D23384 20263   4574 0x00000004
> [  492.537443] Call Trace:
> [  492.540041]  __schedule+0x801/0x1e30
> [  492.580958]  schedule+0xef/0x430
> [  492.610154]  blk_queue_enter+0x8da/0xdf0
> [  492.716327]  generic_make_request+0x651/0x1790
> [  492.765680]  submit_bio+0xba/0x460
> [  492.793198]  submit_bio_wait+0x134/0x1e0
> [  492.801891]  blkdev_issue_flush+0x204/0x300
> [  492.806236]  blkdev_fsync+0x93/0xd0
> [  492.813620]  vfs_fsync_range+0x140/0x220
> [  492.817702]  vfs_fsync+0x29/0x30
> [  492.821081]  __loop_update_dio+0x4de/0x6a0
> [  492.825341]  lo_ioctl+0xd28/0x2190
> [  492.833442]  blkdev_ioctl+0x9b6/0x2020
> [  492.872146]  block_ioctl+0xee/0x130
> [  492.880139]  do_vfs_ioctl+0x1cf/0x16a0
> [  492.927550]  ksys_ioctl+0xa9/0xd0
> [  492.931036]  __x64_sys_ioctl+0x73/0xb0
> [  492.934952]  do_syscall_64+0x1b1/0x800
> [  492.963624]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  493.212768] 1 lock held by syz-executor1/20263:
> [  493.217448]  #0: 00000000956bf5a3 (&lo->lo_ctl_mutex/1){+.+.}, at: lo_ioctl+0x8d/0x2190
> ----------------------------------------
> 
> Is it OK to call [__]loop_update_dio() between blk_mq_freeze_queue() and
> blk_mq_unfreeze_queue(), for vfs_fsync() from __loop_update_dio() is calling
> blk_queue_enter() after blk_mq_freeze_queue() started blocking blk_queue_enter()
> by caling atomic_inc_return() and percpu_ref_kill() ?
>  

The vfs_fsync() isn't necessary in loop_update_dio() since both
generic_file_write_iter() and generic_file_read_iter() can handle
buffered io vs dio well.

I will send one patch to remove the vfs_sync() later.

Thanks,
Ming
