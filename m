From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Tue, 23 Nov 2010 12:26:31 +0200
Message-ID: <4CEB96D7.80105@panasas.com>
References: <20101123100239.GA4232@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:52988 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab0KWK0f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Nov 2010 05:26:35 -0500
In-Reply-To: <20101123100239.GA4232@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/23/2010 12:02 PM, Nick Piggin wrote:
> 
> Taking s_umount lock inside i_mutex can result in an ABBA deadlock:
> 
>  =======================================================
>  [ INFO: possible circular locking dependency detected ]
>  2.6.37-rc3+ #26
>  -------------------------------------------------------
>  append_writer/12828 is trying to acquire lock:
>   (&type->s_umount_key#24){+++++.}, at:
> 	[<ffffffff8113d6d2>] writeback_inodes_sb_if_idle+0x32/0x60
>  
>  but task is already holding lock:
>   (&sb->s_type->i_mutex_key#14){+.+.+.}, at:
> 	[<ffffffff810cc863>] generic_file_aio_write+0x53/0xd0
>  
>  which lock already depends on the new lock.
>  
>  
>  the existing dependency chain (in reverse order) is:
>  
>  -> #3 (&sb->s_type->i_mutex_key#14){+.+.+.}:
>         [<ffffffff810852c5>] lock_acquire+0x95/0x1b0
>         [<ffffffff81601329>] __mutex_lock_common+0x59/0x480
>         [<ffffffff8160182e>] mutex_lock_nested+0x3e/0x50
>         [<ffffffffa003a147>] ext4_end_io_work+0x37/0xb0 [ext4]
>         [<ffffffff81068378>] process_one_work+0x1b8/0x5a0
>         [<ffffffff81069675>] worker_thread+0x175/0x3a0
>         [<ffffffff8106e246>] kthread+0x96/0xa0
>         [<ffffffff81003ed4>] kernel_thread_helper+0x4/0x10
>  
>  -> #2 ((&io->work)){+.+...}:
>         [<ffffffff810852c5>] lock_acquire+0x95/0x1b0
>         [<ffffffff81068364>] process_one_work+0x1a4/0x5a0
>         [<ffffffff81069675>] worker_thread+0x175/0x3a0
>         [<ffffffff8106e246>] kthread+0x96/0xa0
>         [<ffffffff81003ed4>] kernel_thread_helper+0x4/0x10
>  
>  -> #1 (ext4-dio-unwritten){+.+...}:
>         [<ffffffff810852c5>] lock_acquire+0x95/0x1b0
>         [<ffffffff81067bc8>] flush_workqueue+0x148/0x540
>         [<ffffffffa004761b>] ext4_sync_fs+0x3b/0x100 [ext4]
>         [<ffffffff8114304e>] __sync_filesystem+0x5e/0x90
>         [<ffffffff81143132>] sync_filesystem+0x32/0x60
>         [<ffffffff8111a97f>] generic_shutdown_super+0x2f/0x100
>         [<ffffffff8111aa7c>] kill_block_super+0x2c/0x50
>         [<ffffffff8111b1e5>] deactivate_locked_super+0x45/0x60
>         [<ffffffff8111b415>] deactivate_super+0x45/0x60
>         [<ffffffff81136430>] mntput_no_expire+0xf0/0x190
>         [<ffffffff811376a9>] sys_umount+0x79/0x3a0
>         [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
>  
>  -> #0 (&type->s_umount_key#24){+++++.}:
>         [<ffffffff81085122>] __lock_acquire+0x1382/0x1490
>         [<ffffffff810852c5>] lock_acquire+0x95/0x1b0
>         [<ffffffff81601ba2>] down_read+0x42/0x60
>         [<ffffffff8113d6d2>] writeback_inodes_sb_if_idle+0x32/0x60
>         [<ffffffffa0037efd>] ext4_da_write_begin+0x20d/0x310 [ext4]
>         [<ffffffff810cbbf4>] generic_file_buffered_write+0x114/0x2a0
>         [<ffffffff810cc5e0>] __generic_file_aio_write+0x240/0x470
>         [<ffffffff810cc876>] generic_file_aio_write+0x66/0xd0
>         [<ffffffffa002cfad>] ext4_file_write+0x3d/0xd0 [ext4]
>         [<ffffffff81117702>] do_sync_write+0xd2/0x110
>         [<ffffffff811179c8>] vfs_write+0xc8/0x190
>         [<ffffffff811183ec>] sys_write+0x4c/0x80
>         [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
>  
>  other info that might help us debug this:
>  
>  1 lock held by append_writer/12828:
>   #0:  (&sb->s_type->i_mutex_key#14){+.+.+.}, at:
> 	[<ffffffff810cc863>] generic_file_aio_write+0x53/0xd0
>  
>  stack backtrace:
>  Pid: 12828, comm: append_writer Not tainted 2.6.37-rc3+ #26
>  Call Trace:
>   [<ffffffff81082c39>] print_circular_bug+0xe9/0xf0
>   [<ffffffff81085122>] __lock_acquire+0x1382/0x1490
>   [<ffffffff810852c5>] lock_acquire+0x95/0x1b0
>   [<ffffffff8113d6d2>] ? writeback_inodes_sb_if_idle+0x32/0x60
>   [<ffffffff81606c3d>] ? sub_preempt_count+0x9d/0xd0
>   [<ffffffff81601ba2>] down_read+0x42/0x60
>   [<ffffffff8113d6d2>] ? writeback_inodes_sb_if_idle+0x32/0x60
>   [<ffffffff8113d6d2>] writeback_inodes_sb_if_idle+0x32/0x60
>   [<ffffffffa0037efd>] ext4_da_write_begin+0x20d/0x310 [ext4]
>   [<ffffffff81073dde>] ? up_read+0x1e/0x40
>   [<ffffffff810cbbf4>] generic_file_buffered_write+0x114/0x2a0
>   [<ffffffff8104fa22>] ? current_fs_time+0x22/0x30
>   [<ffffffff810cc5e0>] __generic_file_aio_write+0x240/0x470
>   [<ffffffff810cc863>] ? generic_file_aio_write+0x53/0xd0
>   [<ffffffff810cc876>] generic_file_aio_write+0x66/0xd0
>   [<ffffffffa002cfad>] ext4_file_write+0x3d/0xd0 [ext4]
>   [<ffffffff81150db8>] ? fsnotify+0x88/0x5e0
>   [<ffffffff81117702>] do_sync_write+0xd2/0x110
>   [<ffffffff81606c3d>] ? sub_preempt_count+0x9d/0xd0
>   [<ffffffff816027b9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>   [<ffffffff81022e9a>] ? smp_apic_timer_interrupt+0x6a/0xa0
>   [<ffffffff811179c8>] vfs_write+0xc8/0x190
>   [<ffffffff811183ec>] sys_write+0x4c/0x80
>   [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
> 
> Also, there can be an AA deadlock if the filesystem takes i_mutex in a
> workqueue, if it also waits for work completion while holding i_mutex.
> 
> SysRq : Show Blocked State
> task                        PC stack   pid father
> kworker/9:1   D 0000000000000000  6296   118      2
> Call Trace:
> [<ffffffff81039431>] ? get_parent_ip+0x11/0x50
> [<ffffffff8160145c>] __mutex_lock_common+0x18c/0x480
> [<ffffffffa0042147>] ? ext4_end_io_work+0x37/0xb0 [ext4]
> [<ffffffffa0042147>] ? ext4_end_io_work+0x37/0xb0 [ext4]
> [<ffffffff8160182e>] mutex_lock_nested+0x3e/0x50
> [<ffffffffa0042147>] ext4_end_io_work+0x37/0xb0 [ext4]
> [<ffffffff81068378>] process_one_work+0x1b8/0x5a0
> [<ffffffff8106830e>] ? process_one_work+0x14e/0x5a0
> [<ffffffffa0042110>] ? ext4_end_io_work+0x0/0xb0 [ext4]
> [<ffffffff81069675>] worker_thread+0x175/0x3a0
> [<ffffffff81069500>] ? worker_thread+0x0/0x3a0
> [<ffffffff8106e246>] kthread+0x96/0xa0
> [<ffffffff81003ed4>] kernel_thread_helper+0x4/0x10
> [<ffffffff81039878>] ? finish_task_switch+0x78/0x110
> [<ffffffff816036c0>] ? restore_args+0x0/0x30
> [<ffffffff8106e1b0>] ? kthread+0x0/0xa0
> [<ffffffff81003ed0>] ? kernel_thread_helper+0x0/0x10
> 
> dbench        D 0000000000000000  2872  2916      1
> Call Trace:
> [<ffffffff810806fd>] ? trace_hardirqs_off+0xd/0x10
> [<ffffffff81600bb5>] schedule_timeout+0x1f5/0x350
> [<ffffffff8108380b>] ? mark_held_locks+0x6b/0xa0
> [<ffffffff8160314b>] ? _raw_spin_unlock_irq+0x2b/0x60
> [<ffffffff81039431>] ? get_parent_ip+0x11/0x50
> [<ffffffff81606c3d>] ? sub_preempt_count+0x9d/0xd0
> [<ffffffff815ffacd>] wait_for_common+0x10d/0x190
> [<ffffffff810426e0>] ? default_wake_function+0x0/0x10
> [<ffffffff81602ec9>] ? _raw_spin_unlock_bh+0x39/0x40
> [<ffffffff815ffbf8>] wait_for_completion+0x18/0x20
> [<ffffffff8113d1e7>] writeback_inodes_sb_nr+0xf7/0x120
> [<ffffffff8113d68d>] writeback_inodes_sb+0x4d/0x60
> [<ffffffff8113d6d2>] ?  writeback_inodes_sb_if_idle+0x32/0x60
> [<ffffffff8113d6da>] writeback_inodes_sb_if_idle+0x3a/0x60
> [<ffffffffa003fefd>] ext4_da_write_begin+0x20d/0x310
> [<ffffffff810cbbf4>] generic_file_buffered_write+0x114/0x2a0
> 
> Avoid both these issues by issuing completely asynchronous writeback request in
> writeback_inodes_sb_if_idle. Don't let that fool you into thinking these
> functions don't suck any more.
> 
> ext4 now passes extensive stress testing with xfstests, fs_mark, dbench,
> with a writeback_inodes_if_idle call added directly into ext4_da_write_begin
> to trigger the path frequently. Previously it would spew lockdep stuff and
> hang in a number of ways very quickly.
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> 
> ---
>  fs/fs-writeback.c |   32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c	2010-11-23 20:57:23.000000000 +1100
> +++ linux-2.6/fs/fs-writeback.c	2010-11-23 20:59:10.000000000 +1100
> @@ -1152,16 +1152,17 @@ EXPORT_SYMBOL(writeback_inodes_sb);
>   *
>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>   * Returns 1 if writeback was started, 0 if not.
> + *
> + * Even if 1 is returned, writeback may not be started if memory allocation
> + * fails. This function makes no guarantees about anything.
>   */
>  int writeback_inodes_sb_if_idle(struct super_block *sb)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
> -		down_read(&sb->s_umount);
> -		writeback_inodes_sb(sb);
> -		up_read(&sb->s_umount);
> +		bdi_start_writeback(sb->s_bdi, get_nr_dirty_pages());
>  		return 1;
> -	} else
> -		return 0;
> +	}
> +	return 0;
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
>  
> @@ -1172,17 +1173,18 @@ EXPORT_SYMBOL(writeback_inodes_sb_if_idl
>   *
>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>   * Returns 1 if writeback was started, 0 if not.
> + *
> + * Even if 1 is returned, writeback may not be started if memory allocation
> + * fails. This function makes no guarantees about anything.
>   */
>  int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
>  				   unsigned long nr)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
> -		down_read(&sb->s_umount);
> -		writeback_inodes_sb_nr(sb, nr);
> -		up_read(&sb->s_umount);
> +		bdi_start_writeback(sb->s_bdi, nr);
>  		return 1;
> -	} else
> -		return 0;
> +	}
> +	return 0;
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
>  

static inline int writeback_inodes_sb_if_idle(struct super_block *sb)
{
	return writeback_inodes_sb_nr_if_idle(sb, get_nr_dirty_pages());
}

In writeback.h, No?
But it has a single user so please just kill it.

Also writeback_inodes_sb_nr_if_idle() has a single user. Combined with above,
two users. Why not open code it in the two sites. It should be much
clearer to understand what the magic is all about?

Thanks
Boaz
