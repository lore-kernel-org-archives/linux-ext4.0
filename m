From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] Fix potential dead lock for tty_write_message() if
 CONFIG_PRINT_QUOTA_WARNING is enabled
Date: Mon, 2 Jul 2012 11:32:45 +0200
Message-ID: <20120702093245.GB6679@quack.suse.cz>
References: <4FEEC961.7050409@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-serial@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	gregkh@linuxfoundation.org, Jan Kara <jack@suse.cz>,
	Ted Ts'o <tytso@mit.edu>
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FEEC961.7050409@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

On Sat 30-06-12 17:39:45, Jeff Liu wrote:
> I observed the below lockdep warning info at syslog on 3.5-rc4, it could be simply reproduced by creating
> files more than the soft limits of inode quota on ext4 if CONFIG_PRINT_QUOTA_WARNING is enabled.
> 
> jeff@pibroch:~$ uname -a
> Linux pibroch 3.5.0-rc4-dirty #220 SMP Fri Jun 29 11:30:20 CST 2012 i686 GNU/Linux
> jeff@pibroch:~$ quota -u jeff
> Disk quotas for user jeff (uid 1000):
> Filesystem  blocks   quota   limit   grace   files   quota   limit   grace
> /dev/sda8       0       0       0               1     100    6000 
> 
> So creating 110 a files could got quota warns.
> $ for((i=0;i<110;i++));do touch "/ext4_mount_path/testme.".$i;done
  Yeah, situations like the one reported below can possibly cause problems
(e.g. when you have application with redirected output to /mnt/out and the
application writes to /mnt/b which exceeds quota - you try to write message
to /mnt/out in the middle of writing to /mnt/b). These problems are rather
hard to overcome and that's why CONFIG_PRINT_QUOTA_WARNING is marked as
obsolete and CONFIG_QUOTA_NETLINK_INTERFACE should be used instead.

									Honza
 
> [  213.324324] =====================================================
> [  213.324337] [ INFO: possible circular locking dependency detected ]
> [  213.324353] 3.5.0-rc4 #201 Not tainted
> [  213.324364] -------------------------------------------------------
> [  213.324376] touch/2237 is trying to acquire lock:
> [  213.324413]  (&tty->atomic_write_lock){+.+...}, at: [<c14dcc02>] tty_write_message+0x40/0x103
> [  213.324426] [  213.324426] but task is already holding lock:
> [  213.324469]  (jbd2_handle){+.+...}, at: [<f8202060>] start_this_handle+0xa19/0xa8a [jbd2]
> [  213.324482] [  213.324482] which lock already depends on the new lock.
> [  213.324482] [  213.324497] [  213.324497] the existing dependency chain (in reverse order) is:
> [  213.324525] [  213.324525] -> #2 (jbd2_handle){+.+...}:
> [  213.324546]        [<c1101e89>] lock_acquire+0x198/0x1d3
> [  213.324576]        [<f82020a4>] start_this_handle+0xa5d/0xa8a [jbd2]
> [  213.324608]        [<f820247a>] jbd2__journal_start+0x11b/0x187 [jbd2]
> [  213.324638]        [<f8202506>] jbd2_journal_start+0x20/0x30 [jbd2]
> [  213.324701]        [<f8a8028c>] ext4_journal_start_sb+0x280/0x296 [ext4]
> [  213.324753]        [<f8a5a9bd>] ext4_dirty_inode+0x27/0x84 [ext4]
> [  213.324767]        [<c127e24e>] __mark_inode_dirty+0x52/0x2e7
> [  213.324781]        [<c12675fe>] update_time+0x10f/0x126
> [  213.324794]        [<c1267c07>] touch_atime+0x235/0x25e
> [  213.324841]        [<f8a49fac>] ext4_file_mmap+0x5c/0x7d [ext4]
> [  213.324856]        [<c1201bf9>] mmap_region+0x449/0x7c4
> [  213.324870]        [<c1202435>] do_mmap_pgoff+0x4c1/0x4db
> [  213.324884]        [<c11e7bb4>] vm_mmap_pgoff+0x98/0xc7
> [  213.324899]        [<c11ffa5e>] sys_mmap_pgoff+0x16a/0x1bf
> [  213.324912]        [<c18a5224>] syscall_call+0x7/0xb
> 
> [  213.324929] [  213.324929] -> #1 (&mm->mmap_sem){++++++}:
> [  213.324943]        [<c1101e89>] lock_acquire+0x198/0x1d3
> [  213.324956]        [<c11f3bcb>] might_fault+0xbf/0xf8
> [  213.324970]        [<c13e1cd3>] _copy_from_user+0x40/0x8a
> [  213.324982]        [<c14da3cf>] copy_from_user+0x16/0x26
> [  213.324994]        [<c14dc80b>] tty_write+0x282/0x3c7
> [  213.325006]        [<c14dca34>] redirected_tty_write+0xe4/0xfd
> [  213.325020]        [<c123f955>] vfs_write+0xf5/0x1a3
> [  213.325033]        [<c123fcb8>] sys_write+0x6c/0xa9
> [  213.325045]        [<c18b169f>] sysenter_do_call+0x12/0x38
> 
> [  213.325062] [  213.325062] -> #0 (&tty->atomic_write_lock){+.+...}:
> [  213.325078]        [<c1100e70>] __lock_acquire+0x15bb/0x1b98
> [  213.325091]        [<c1101e89>] lock_acquire+0x198/0x1d3
> [  213.325105]        [<c189fb16>] __mutex_lock_common+0x52/0x7cd
> [  213.325118]        [<c18a0439>] mutex_lock_nested+0x5c/0x70
> [  213.325130]        [<c14dcc02>] tty_write_message+0x40/0x103
> [  213.325144]        [<c12bf9fd>] flush_warnings+0x17c/0x313
> [  213.325157]        [<c12c47c4>] dquot_alloc_inode+0x1e4/0x1fc
> [  213.325207]        [<f8a4db1e>] ext4_new_inode+0x11f5/0x1576 [ext4]
> [  213.325262]        [<f8a6166d>] ext4_create+0x160/0x230 [ext4]
> [  213.325276]        [<c1253dc2>] vfs_create+0xc4/0x106
> [  213.325297]        [<c1254ee2>] do_last+0x437/0xdcc
> [  213.325310]        [<c125762a>] path_openat+0x10e/0x5a7
> [  213.325323]        [<c1257c57>] do_filp_open+0x39/0xc2
> [  213.325335]        [<c123e362>] do_sys_open+0xb5/0x1bb
> [  213.325347]        [<c123e4a1>] sys_open+0x39/0x5b
> [  213.325360]        [<c18a5224>] syscall_call+0x7/0xb
> [  213.325368] [  213.325368] other info that might help us debug this:
> [  213.325368] [  213.325391] Chain exists of:
> [  213.325391]   &tty->atomic_write_lock --> &mm->mmap_sem --> jbd2_handle
> [  213.325391] [  213.325401]  Possible unsafe locking scenario:
> [  213.325401] [  213.325410]        CPU0                    CPU1
> [  213.325417]        ----                    ----
> [  213.325558]   lock(jbd2_handle);
> [  213.325571]                                lock(&mm->mmap_sem);
> [  213.325583]                                lock(jbd2_handle);
> [  213.325595]   lock(&tty->atomic_write_lock);
> [  213.325602] [  213.325602]  *** DEADLOCK ***
> [  213.325602] [  213.325613] 2 locks held by touch/2237:
> [  213.325639]  #0:  (&type->i_mutex_dir_key#3){+.+.+.}, at: [<c1254da1>] do_last+0x2f6/0xdcc
> [  213.325673]  #1:  (jbd2_handle){+.+...}, at: [<f8202060>] start_this_handle+0xa19/0xa8a [jbd2]
> [  213.325682] [  213.325682] stack backtrace:
> [  213.325693] Pid: 2237, comm: touch Not tainted 3.5.0-rc4 #201
> [  213.325702] Call Trace:
> [  213.325717]  [<c10faac9>] print_circular_bug+0x3fa/0x412
> [  213.325732]  [<c1100e70>] __lock_acquire+0x15bb/0x1b98
> [  213.325747]  [<c1101e89>] lock_acquire+0x198/0x1d3
> [  213.325761]  [<c14dcc02>] ? tty_write_message+0x40/0x103
> [  213.325776]  [<c189fb16>] __mutex_lock_common+0x52/0x7cd
> [  213.325789]  [<c14dcc02>] ? tty_write_message+0x40/0x103
> [  213.325804]  [<c18a525d>] ? restore_all+0xf/0xf
> [  213.325819]  [<c10b396c>] ? need_resched+0x22/0x3a
> [  213.325833]  [<c18a0439>] mutex_lock_nested+0x5c/0x70
> [  213.325847]  [<c14dcc02>] ? tty_write_message+0x40/0x103
> [  213.325860]  [<c14dcc02>] tty_write_message+0x40/0x103
> [  213.325874]  [<c12bf9fd>] flush_warnings+0x17c/0x313
> [  213.325888]  [<c12c47c4>] dquot_alloc_inode+0x1e4/0x1fc
> [  213.325941]  [<f8a4db1e>] ext4_new_inode+0x11f5/0x1576 [ext4]
> [  213.326000]  [<f8a6166d>] ext4_create+0x160/0x230 [ext4]
> [  213.326018]  [<c1253dc2>] vfs_create+0xc4/0x106
> [  213.326033]  [<c1254ee2>] do_last+0x437/0xdcc
> [  213.326048]  [<c125762a>] path_openat+0x10e/0x5a7
> [  213.326063]  [<c1257c57>] do_filp_open+0x39/0xc2
> [  213.326077]  [<c1101cdc>] ? lock_release+0x4b3/0x4c8
> [  213.326090]  [<c18a5116>] ? _raw_spin_unlock+0x4c/0x5d
> [  213.326104]  [<c126c821>] ? alloc_fd+0x2fe/0x317
> [  213.326118]  [<c123e362>] do_sys_open+0xb5/0x1bb
> [  213.326132]  [<c123e4a1>] sys_open+0x39/0x5b
> [  213.326145]  [<c18a5224>] syscall_call+0x7/0xb
> 
> looks this issue is caused by the tty_write_message()->....->tty_write() because it will call copy_from_user() which will
> produce page faults and kick off ext4 inode dirty process on another CPU if possible.
> According to my understood, if the current process was be preempted when its time quantum expires, the need_resched field of
> the current process is set, so the scheduler is invoked and the current process will be re-scheduled to run and call
> next tty_write_message() at dquot.c->print_warning(), and it need to acquire atomic_write_lock again, however, this lock has
> already been hold by another process, so the race situation is occurred.
> 
> I know such kind of issue should be better to fix at quota module, I have also tried to fix it there but no luck. :(
> For now, I could only work out a stupid patch set to let lockdep happy by making both tty_write_lock and BTM lock sleepable.
> 
> 
> Thanks,
> -Jeff
> 
> 
> 			
> 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
