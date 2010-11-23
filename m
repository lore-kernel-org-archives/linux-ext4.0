From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Tue, 23 Nov 2010 19:15:05 +1100
Message-ID: <20101123081505.GB3364@amd>
References: <20101117043845.GA3586@amd>
 <4CE362B0.6040607@redhat.com>
 <20101117061057.GA3989@amd>
 <20101118030613.GQ3290@thunk.org>
 <20101117192900.da859ac7.akpm@linux-foundation.org>
 <20101118060000.GA3509@amd>
 <20101117222834.2bb36ee1.akpm@linux-foundation.org>
 <20101119004552.GF5004@quack.suse.cz>
 <20101119051619.GE3284@amd>
 <20101122181655.GF5012@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101122181655.GF5012@quack.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Here is another one. Both i_mutex in writeback and s_umount in write(2)
underneath i_mutex seem like an interesting idea. The former you can
probably get away with (provided you solve the previous AA deadlock),
but the latter seems too problematic. I think my trylock patch solves
it.

[  409.479214] =======================================================
[  409.479527] [ INFO: possible circular locking dependency detected ]
[  409.479689] 2.6.37-rc3+ #26[  409.479837]
-------------------------------------------------------
[  409.479998] umount/4020 is trying to acquire lock:[  409.480155]
(ext4-dio-unwritten){+.+...}, at: [<ffffffff81067a80>]
flush_workqueue+0x0/0x540
[  409.480178] [  409.480178] but task is already holding lock:
[  409.480178]  (&type->s_umount_key#23){++++..}, at:
[<ffffffff8111b40d>] deactivate_super+0x3d
/0x60
[  409.480178] [  409.480178] which lock already depends on the new
lock.
[  409.480178] 
[  409.480178] 
[  409.480178] the existing dependency chain (in reverse order) is:
[  409.480178] 
[  409.480178] -> #3 (&type->s_umount_key#23){++++..}:
[  409.480178]        [<ffffffff810852c5>] lock_acquire+0x95/0x1b0
[  409.480178]        [<ffffffff81601ba2>] down_read+0x42/0x60
[  409.480178]        [<ffffffff8113d6d2>]
writeback_inodes_sb_if_idle+0x32/0x60
[  409.480178]        [<ffffffffa003fef8>]
ext4_da_write_begin+0x208/0x2d0 [ext4]
[  409.480178]        [<ffffffff810cbbf4>]
generic_file_buffered_write+0x114/0x2a0
[  409.480178]        [<ffffffff810cc5e0>]
__generic_file_aio_write+0x240/0x470
[  409.480178]        [<ffffffff810cc876>]
generic_file_aio_write+0x66/0xd0
[  409.480178]        [<ffffffffa0034fad>] ext4_file_write+0x3d/0xd0
[ext4]
[  409.480178]        [<ffffffff81117702>] do_sync_write+0xd2/0x110
[  409.480178]        [<ffffffff811179c8>] vfs_write+0xc8/0x190
[  409.480178]        [<ffffffff8111851a>] sys_pwrite64+0x7a/0x90
[  409.480178]        [<ffffffff8100312b>]
system_call_fastpath+0x16/0x1b
[  409.480178] 
[  409.480178] -> #2 (&sb->s_type->i_mutex_key#13){+.+.+.}:
[  409.480178]        [<ffffffff810852c5>] lock_acquire+0x95/0x1b0
[  409.480178]        [<ffffffff81601329>]
__mutex_lock_common+0x59/0x480
[  409.480178]        [<ffffffff8160182e>] mutex_lock_nested+0x3e/0x50
[  409.480178]        [<ffffffffa0042107>] ext4_end_io_work+0x37/0xb0
[ext4]
[  409.480178]        [<ffffffff81068378>] process_one_work+0x1b8/0x5a0
[  409.480178]        [<ffffffff81069675>] worker_thread+0x175/0x3a0
[  409.480178]        [<ffffffff8106e246>] kthread+0x96/0xa0
[  409.480178]        [<ffffffff81003ed4>] kernel_thread_helper+0x4/0x10
[  409.480178] 
[  409.480178] -> #1 ((&io->work)){+.+...}:
[  409.480178]        [<ffffffff810852c5>] lock_acquire+0x95/0x1b0
[  409.480178]        [<ffffffff81068364>] process_one_work+0x1a4/0x5a0
[  409.480178]        [<ffffffff81069675>] worker_thread+0x175/0x3a0
[  409.480178]        [<ffffffff8106e246>] kthread+0x96/0xa0
[  409.480178]        [<ffffffff81003ed4>] kernel_thread_helper+0x4/0x10
[  409.480178] 
[  409.480178] -> #0 (ext4-dio-unwritten){+.+...}:
[  409.480178]        [<ffffffff81085122>] __lock_acquire+0x1382/0x1490
[  409.480178]        [<ffffffff810852c5>] lock_acquire+0x95/0x1b0
[  409.480178]        [<ffffffff81067bc8>] flush_workqueue+0x148/0x540
[  409.480178]        [<ffffffffa004f5db>] ext4_sync_fs+0x3b/0x100
[ext4]
[  409.480178]        [<ffffffff8114304e>] __sync_filesystem+0x5e/0x90
[  409.480178]        [<ffffffff81143132>] sync_filesystem+0x32/0x60
[  409.480178]        [<ffffffff8111a97f>]
generic_shutdown_super+0x2f/0x100
[  409.480178]        [<ffffffff8111aa7c>] kill_block_super+0x2c/0x50
[  409.480178]        [<ffffffff8111b1e5>]
deactivate_locked_super+0x45/0x60
[  409.480178]        [<ffffffff8111b415>] deactivate_super+0x45/0x60
[  409.480178]        [<ffffffff81136430>] mntput_no_expire+0xf0/0x190
[  409.480178]        [<ffffffff811376a9>] sys_umount+0x79/0x3a0
[  409.480178]        [<ffffffff8100312b>]
system_call_fastpath+0x16/0x1b
[  409.480178] [  409.480178] other info that might help us debug this:
[  409.480178] 
[  409.480178] 1 lock held by umount/4020:
[  409.480178]  #0:  (&type->s_umount_key#23){++++..}, at:
[<ffffffff8111b40d>] deactivate_super
+0x3d/0x60
[  409.480178] 
[  409.480178] stack backtrace:
[  409.480178] Pid: 4020, comm: umount Not tainted 2.6.37-rc3+ #26
[  409.480178] Call Trace:
[  409.480178]  [<ffffffff81082c39>] print_circular_bug+0xe9/0xf0
[  409.480178]  [<ffffffff81085122>] __lock_acquire+0x1382/0x1490
[  409.480178]  [<ffffffff810852c5>] lock_acquire+0x95/0x1b0
[  409.480178]  [<ffffffff81067a80>] ? flush_workqueue+0x0/0x540
[  409.480178]  [<ffffffff81067bc8>] flush_workqueue+0x148/0x540
[  409.480178]  [<ffffffff81067a80>] ? flush_workqueue+0x0/0x540
[  409.480178]  [<ffffffffa004f5db>] ext4_sync_fs+0x3b/0x100 [ext4]
[  409.480178]  [<ffffffff8113d68d>] ? writeback_inodes_sb+0x4d/0x60
[  409.480178]  [<ffffffff8114304e>] __sync_filesystem+0x5e/0x90
[  409.480178]  [<ffffffff81143132>] sync_filesystem+0x32/0x60
[  409.480178]  [<ffffffff8111a97f>] generic_shutdown_super+0x2f/0x100
[  409.480178]  [<ffffffff8111aa7c>] kill_block_super+0x2c/0x50
[  409.480178]  [<ffffffff8111b1e5>] deactivate_locked_super+0x45/0x60
[  409.480178]  [<ffffffff8111b415>] deactivate_super+0x45/0x60
[  409.480178]  [<ffffffff81136430>] mntput_no_expire+0xf0/0x190
[  409.480178]  [<ffffffff811376a9>] sys_umount+0x79/0x3a0
[  409.480178]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b

