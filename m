From: Nikolay Borisov <n.borisov@siteground.com>
Subject: LOCKDEP warning around ext4_iget
Date: Thu, 18 Jun 2015 11:58:47 +0300
Message-ID: <55828847.5010700@siteground.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Marian Marinov <mm@1h.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

During a debugging session of my local code I encountered the following
lockdep splat but my machine did not deadlock, on subsequent repeats of
the same operations that led to this splat (enqueuing my rcu callback) I
couldn't reproduce it:
=================================
[ INFO: inconsistent lock state ]
4.0.0-fmon+ #189 Not tainted
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
ksoftirqd/0/3 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (&sb->s_type->i_lock_key#16){+.?...}, at: [<ffffffff81207a7e>]
fsnotify_find_inode_mark+0x2e/0x60
{SOFTIRQ-ON-W} state was registered at:
  [<ffffffff810a7c20>] mark_irqflags+0x110/0x170
  [<ffffffff810a93d2>] __lock_acquire+0x292/0x560
  [<ffffffff810a9869>] lock_acquire+0x1c9/0x230
  [<ffffffff8161f788>] _raw_spin_lock+0x38/0x50
  [<ffffffff811e1711>] iget_locked+0x111/0x1f0
  [<ffffffff81259031>] ext4_iget+0x41/0xaf0
  [<ffffffff8126efef>] ext4_get_journal+0x3f/0x130
  [<ffffffff812723b7>] ext4_load_journal+0x167/0x3d0
  [<ffffffff8127c07f>] ext4_fill_super+0x137f/0x2090
  [<ffffffff811c627a>] mount_bdev+0x17a/0x200
  [<ffffffff8126bac5>] ext4_mount+0x15/0x20
  [<ffffffff811c5e8d>] mount_fs+0x8d/0x180
  [<ffffffff811e8299>] vfs_kern_mount+0x79/0x160
  [<ffffffff811e90e0>] do_new_mount+0xd0/0x1d0
  [<ffffffff811e9645>] do_mount+0x165/0x230
  [<ffffffff811e9798>] SyS_mount+0x88/0xc0
  [<ffffffff81620609>] system_call_fastpath+0x12/0x17
irq event stamp: 231650
hardirqs last  enabled at (231650): [<ffffffff811a50ad>] kfree+0x20d/0x2a0
hardirqs last disabled at (231649): [<ffffffff811a507f>] kfree+0x1df/0x2a0
softirqs last  enabled at (231572): [<ffffffff810592ce>] __do_softirq+0x47e/0x580
softirqs last disabled at (231577): [<ffffffff810593f5>]
run_ksoftirqd+0x25/0x90

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sb->s_type->i_lock_key#16);
  <Interrupt>
    lock(&sb->s_type->i_lock_key#16);

 *** DEADLOCK ***

1 lock held by ksoftirqd/0/3:
 #0:  (rcu_callback){......}, at: [<ffffffff810be940>]
rcu_do_batch+0x180/0x410

stack backtrace:
CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 4.0.0-fmon+ #189
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
 ffff88000655a600 ffff8800065779e8 ffffffff816190ab 0000000000000000
 ffffffff819f3668 ffff880006577a48 ffffffff810a6aee 0000000000000001
 ffffffff00000001 ffff880000000000 0000000081e4d528 0000000000000001
Call Trace:
 [<ffffffff816190ab>] dump_stack+0x4f/0x6c
 [<ffffffff810a6aee>] print_usage_bug+0x1be/0x1f0
 [<ffffffff810a71b0>] ? print_circular_bug+0x150/0x150
 [<ffffffff810a7799>] mark_lock_irq+0xd9/0x2a0
 [<ffffffff810a7a73>] mark_lock+0x113/0x1b0
 [<ffffffff810a7ba5>] mark_irqflags+0x95/0x170
 [<ffffffff810a93d2>] __lock_acquire+0x292/0x560
 [<ffffffff8114d34d>] ? free_one_page+0x27d/0x360
 [<ffffffff810a9869>] lock_acquire+0x1c9/0x230
 [<ffffffff81207a7e>] ? fsnotify_find_inode_mark+0x2e/0x60
 [<ffffffff8114fb95>] ? __free_pages_ok+0xe5/0x110
 [<ffffffff81208e60>] ? filemon_dirtycount_show+0x50/0x50
 [<ffffffff8161f788>] _raw_spin_lock+0x38/0x50
 [<ffffffff81207a7e>] ? fsnotify_find_inode_mark+0x2e/0x60
 [<ffffffff81207a7e>] fsnotify_find_inode_mark+0x2e/0x60
 [<ffffffff8120a109>] dnotify_flush+0x49/0x130
 [<ffffffff81208e60>] ? filemon_dirtycount_show+0x50/0x50
 [<ffffffff811bf4b6>] filp_close+0x66/0x90
 [<ffffffff81208e7d>] filemon_free_dir_entry_rcu+0x1d/0x30
 [<ffffffff81208e60>] ? filemon_dirtycount_show+0x50/0x50
 [<ffffffff810be9ae>] rcu_do_batch+0x1ee/0x410
 [<ffffffff810be940>] ? rcu_do_batch+0x180/0x410
 [<ffffffff810bd495>] ? note_gp_changes+0x95/0xf0
 [<ffffffff810bed21>] __rcu_process_callbacks+0x151/0x190
 [<ffffffff810bff38>] rcu_process_callbacks+0x178/0x320
 [<ffffffff8105909e>] __do_softirq+0x24e/0x580
 [<ffffffff8107c8c0>] ? smpboot_create_threads+0x80/0x80
 [<ffffffff810593f5>] run_ksoftirqd+0x25/0x90
 [<ffffffff8107cab1>] smpboot_thread_fn+0x1f1/0x200
 [<ffffffff81078710>] kthread+0x110/0x120
 [<ffffffff81078600>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff81620558>] ret_from_fork+0x58/0x90
 [<ffffffff81078600>] ? __init_kthread_worker+0x70/0x70

I'm having a hard time debugging the first backtrace, particularly what
does the "inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage." and
following lines are trying to tell me? The bottom backtrace indicates
that my custom rcu callback was executing at the time, here is the code
for that:

static void filemon_free_dir_entry_rcu(struct rcu_head *head)
{
        struct filemon_dir_entry *entry = container_of(head,
					struct filemon_dir_entry,
                                                       rcu);

        filp_close(entry->file, NULL);
        kfree(entry);
}

Pretty straightforward and I don't see how this code has anything to do
with ext4 or with superblock locking. I've tested this on a single core
QEMU, with SMP enabled in the kernel. Is it possible I've hit some 
lingering issue ? The version used is kernel 4.0.0 with my custom code, 
but I have never touched any ext4 code. Any pointer as to what 
might be the root cause?
