From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 13232] New: ext3/4 with synchronous writes
 gets wedged by Postfix
Date: Tue, 5 May 2009 14:55:25 -0700
Message-ID: <20090505145525.92e9551a.akpm@linux-foundation.org>
References: <bug-13232-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, kernel-nospam@dbwatson.ukfsn.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559AbZEEV6U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 May 2009 17:58:20 -0400
In-Reply-To: <bug-13232-10286@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sun, 3 May 2009 19:48:21 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13232
> 
>            Summary: ext3/4 with synchronous writes gets wedged by Postfix
>            Product: File System
>            Version: 2.5
>     Kernel Version: 2.6.29.2
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext3
>         AssignedTo: fs_ext3@kernel-bugs.osdl.org
>         ReportedBy: kernel-nospam@dbwatson.ukfsn.org
>         Regression: Yes
> 
> 
> Latest working kernel version: 2.6.28.9
> Earliest failing kernel version: 2.6.29

A very very bad regression.

> Distribution: Ubuntu 8.04 LTS
> Hardware Environment: Intel 875p chipset (ICH5), P4 with HT
> Software Environment: Postfix 2.5.1-2ubuntu1.2
> 
> Problem Description:
> 
> With its queue directory on an ext3 or journalled ext4 file
> system, mounted with the 'sync' option (or with the 'S' attribute
> on the individual queue directories, which is a config option for
> the Ubuntu package), sending more than a few messages in quick
> succession through Postfix causes Postfix and any other process
> attempting to modify the file system afterwards (e.g. by updating
> the atime when listing a directory) to hang in uninterruptible
> sleep.  sync(1) will also hang afterwards.  If the FS is mounted
> noatime, it is still possible to read from it, although trying to
> list the affected queue directories still causes ls to hang (the
> list of affected directories seems to vary, but may include at
> least "active" and "maildrop").
> 
> This happens whether the filesystem is on a hard disk or a RAM
> disk (/dev/ramX, not tmpfs).  Enabling or disabling barriers, or
> changing the journalling mode doesn't help.
> 
> Ext2 seems to be unaffected, as does non-journalled ext4.  XFS,
> Reiser and JFS are also fine.  The hang doesn't occur if the
> queue directories have the 'D' attribute (and a non-sync mount)
> instead of 'S'.
> 
> Nothing appears in dmesg at the time of the hang, but here's the
> output from SysRq-W afterwards (ext3 FS, kernel 2.6.29.2,
> non-SMP, PREEMPT_NONE):
> 
> SysRq : Show Blocked State
>   task                PC stack   pid father
> kjournald     D c01384df     0  2525      2
>  cfcb5f0c 00000082 de27d500 c01384df cfcb5ef4 c02cb5c0 00000001 de32ca00
>  de324814 dd037ebc de324814 de324934 dd037ebc cfcb5f5c cfcb5f90 c01bd4bb
>  00000046 c0424110 de324a0c de324814 de324800 00000000 00000002 dd037e80
> Call Trace:
>  [<c01384df>] ? trace_hardirqs_on+0xb/0xd
>  [<c01bd4bb>] journal_commit_transaction+0xea/0xeaf
>  [<c02c534a>] ? _spin_unlock_irqrestore+0x38/0x3f
>  [<c0138489>] ? trace_hardirqs_on_caller+0x145/0x190
>  [<c012b6ee>] ? autoremove_wake_function+0x0/0x38
>  [<c0122a25>] ? del_timer+0x50/0x59
>  [<c01c0c75>] kjournald+0xad/0x1bb
>  [<c012b6ee>] ? autoremove_wake_function+0x0/0x38
>  [<c01c0bc8>] ? kjournald+0x0/0x1bb
>  [<c012b442>] kthread+0x37/0x59
>  [<c012b40b>] ? kthread+0x0/0x59
>  [<c0103667>] kernel_thread_helper+0x7/0x10

I assume this is

	while (commit_transaction->t_updates) {
		DEFINE_WAIT(wait);

		prepare_to_wait(&journal->j_wait_updates, &wait,
					TASK_UNINTERRUPTIBLE);
		if (commit_transaction->t_updates) {
			spin_unlock(&commit_transaction->t_handle_lock);
			spin_unlock(&journal->j_state_lock);
			schedule();

I'm wondering about

: commit e219cca082f52e7dfea41f3be264b7b5eb204227
: Author:     Theodore Ts'o <tytso@mit.edu>
: AuthorDate: Thu Nov 6 22:37:59 2008 -0500
: Commit:     Theodore Ts'o <tytso@mit.edu>
: CommitDate: Thu Nov 6 22:37:59 2008 -0500
:
:    jbd: don't give up looking for space so easily in __log_wait_for_space

but that patch was present in 2.6.28.



> pickup        D c01384df     0  2597   2594
>  cfaa9e5c 00000086 df9faa80 c01384df cfaa9e44 00000282 cfaa9e74 de32ca00
>  cfaa9e5c c012b8b7 00000002 de324800 0000014f cfaa9e74 cfaa9e94 c01c0539
>  00000000 de3248c8 de324910 de324814 00000000 df9faa80 c012b6ee de3248e4
> Call Trace:
>  [<c01384df>] ? trace_hardirqs_on+0xb/0xd
>  [<c012b8b7>] ? prepare_to_wait+0x42/0x4a
>  [<c01c0539>] log_wait_commit+0x90/0xf7
>  [<c012b6ee>] ? autoremove_wake_function+0x0/0x38
>  [<c01bba9d>] journal_stop+0x1c8/0x288
>  [<c01b4236>] __ext3_journal_stop+0x1c/0x38
>  [<c01aeb96>] ext3_delete_inode+0x90/0xc2
>  [<c01aeb06>] ? ext3_delete_inode+0x0/0xc2
>  [<c017ab82>] generic_delete_inode+0x72/0x100
>  [<c02c4ee1>] ? _spin_lock+0x3a/0x40
>  [<c017ad4c>] generic_drop_inode+0x13c/0x1da
>  [<c01d4068>] ? _atomic_dec_and_lock+0x10/0x38
>  [<c017a4e7>] iput+0x47/0x4e
>  [<c0173db0>] do_unlinkat+0xc1/0x137
>  [<c0102f87>] ? sysenter_exit+0xf/0x18
>  [<c0138489>] ? trace_hardirqs_on_caller+0x145/0x190
>  [<c0173e36>] sys_unlink+0x10/0x12
>  [<c0102f55>] sysenter_do_call+0x12/0x35
> qmgr          D c01384df     0  2598   2594
>  cfe23e60 00000082 df9fa200 c01384df cfe23e48 c02cb5c0 cfe23e78 de32cf00
>  cfe23e60 c012b8b7 00000002 de324800 0000014f cfe23e78 cfe23e98 c01c0539
>  00000000 de3248c8 de324910 de324814 00000000 df9fa200 c012b6ee cfaa9e80
> Call Trace:
>  [<c01384df>] ? trace_hardirqs_on+0xb/0xd
>  [<c012b8b7>] ? prepare_to_wait+0x42/0x4a
>  [<c01c0539>] log_wait_commit+0x90/0xf7
>  [<c012b6ee>] ? autoremove_wake_function+0x0/0x38
>  [<c01bba9d>] journal_stop+0x1c8/0x288
>  [<c01ac11e>] ? ext3_mark_iloc_dirty+0x1d8/0x34b
>  [<c01b4236>] __ext3_journal_stop+0x1c/0x38
>  [<c01b309d>] ext3_unlink+0x70/0x157
>  [<c0172344>] ? vfs_unlink+0x45/0xb0
>  [<c0172358>] vfs_unlink+0x59/0xb0
>  [<c0173e17>] do_unlinkat+0x128/0x137
>  [<c0102f87>] ? sysenter_exit+0xf/0x18
>  [<c0138489>] ? trace_hardirqs_on_caller+0x145/0x190
>  [<c0173e36>] sys_unlink+0x10/0x12
>  [<c0102f55>] sysenter_do_call+0x12/0x35
> local         D c01384df     0  2654   2594
>  de369c74 00000096 df9f8880 c01384df de369c5c 00000286 00000000 de183b80
>  de324814 de324800 de324814 dd037e80 de324800 de324880 de369cc4 c01bc306
>  c0138489 00000246 00000046 00000001 de324a0c de324814 de324814 df59c060
> Call Trace:
>  [<c01384df>] ? trace_hardirqs_on+0xb/0xd
>  [<c01bc306>] start_this_handle+0x1c2/0x361
>  [<c0138489>] ? trace_hardirqs_on_caller+0x145/0x190
>  [<c012b6ee>] ? autoremove_wake_function+0x0/0x38
>  [<c01bc54a>] journal_start+0xa5/0x100
>  [<c01b43ac>] ext3_journal_start_sb+0x48/0x4d
>  [<c01aec4c>] ext3_write_begin+0x84/0x1c6
>  [<c0139fe2>] ? __lock_acquire+0x32b/0xa21
>  [<c014749e>] generic_file_buffered_write+0xe1/0x292
>  [<c0147a94>] __generic_file_aio_write_nolock+0x25c/0x4ab
>  [<c0138489>] ? trace_hardirqs_on_caller+0x145/0x190
>  [<c0147f63>] generic_file_aio_write+0x66/0xda
>  [<c0138f6b>] ? validate_chain+0x3f5/0x1141
>  [<c01aad03>] ext3_file_write+0x27/0xa8
>  [<c016a972>] do_sync_write+0xcc/0x102
>  [<c012b6ee>] ? autoremove_wake_function+0x0/0x38
>  [<c016b16d>] vfs_write+0x8b/0x11f
>  [<c0102f87>] ? sysenter_exit+0xf/0x18
>  [<c016a8a6>] ? do_sync_write+0x0/0x102
>  [<c016b577>] sys_write+0x3d/0x64
>  [<c0102f55>] sysenter_do_call+0x12/0x35
> postdrop      D c01384df     0  2664   2663
>  cfcbfd6c 00000086 dd13f700 c01384df cfcbfd54 c02cb5c0 00000001 deedc780
>  c03a1690 c1402348 c03a1690 cfcbfd7c c1402348 cfcbfd90 cfcbfd9c c017a55b
>  dd758c48 00000007 00000000 dd13f700 c012b726 c1402364 c1402364 00152b13
> Call Trace:
>  [<c01384df>] ? trace_hardirqs_on+0xb/0xd
>  [<c017a55b>] __wait_on_freeing_inode+0x6d/0x88
>  [<c012b726>] ? wake_bit_function+0x0/0x47
>  [<c017a5b5>] find_inode_fast+0x3f/0x4a
>  [<c017ba05>] insert_inode_locked+0x50/0xeb
>  [<c01ab90b>] ext3_new_inode+0x738/0x88f
>  [<c01bc550>] ? journal_start+0xab/0x100
>  [<c01b259a>] ext3_create+0x59/0xbf
>  [<c01722c4>] vfs_create+0x75/0xb0
>  [<c02c4dda>] ? _spin_unlock+0x1d/0x20
>  [<c01b2541>] ? ext3_create+0x0/0xbf
>  [<c0174bc3>] do_filp_open+0x644/0x713
>  [<c02c4dda>] ? _spin_unlock+0x1d/0x20
>  [<c01692ce>] do_sys_open+0x45/0xce
>  [<c0102f87>] ? sysenter_exit+0xf/0x18
>  [<c0138489>] ? trace_hardirqs_on_caller+0x145/0x190
>  [<c01693a3>] sys_open+0x23/0x2b
>  [<c0102f55>] sysenter_do_call+0x12/0x35
> Sched Debug Version: v0.08, 2.6.29.2-test #1
> now at 166155.025991 msecs
>   .sysctl_sched_latency                    : 20.000000
>   .sysctl_sched_min_granularity            : 4.000000
>   .sysctl_sched_wakeup_granularity         : 5.000000
>   .sysctl_sched_child_runs_first           : 0.000001
>   .sysctl_sched_features                   : 24191
> 
> cpu#0, 2798.181 MHz
>   .nr_running                    : 2
>   .load                          : 2048
>   .nr_switches                   : 284843
>   .nr_load_updates               : 6497
>   .nr_uninterruptible            : 5
>   .jiffies                       : 4294953911
>   .next_balance                  : 0.000000
>   .curr->pid                     : 2466
>   .clock                         : 166154.370058
>   .cpu_load[0]                   : 0
>   .cpu_load[1]                   : 4
>   .cpu_load[2]                   : 76
>   .cpu_load[3]                   : 160
>   .cpu_load[4]                   : 196
> 
> cfs_rq[0]:
>   .exec_clock                    : 0.000000
>   .MIN_vruntime                  : 24407.116340
>   .min_vruntime                  : 24407.114218
>   .max_vruntime                  : 24407.116340
>   .spread                        : 0.000000
>   .spread0                       : 0.000000
>   .nr_running                    : 2
>   .load                          : 2048
>   .nr_spread_over                : 0
> 
> rt_rq[0]:
>   .rt_nr_running                 : 0
>   .rt_throttled                  : 0
>   .rt_time                       : 0.000000
>   .rt_runtime                    : 950.000000
> 
> runnable tasks:
>             task   PID         tree-key  switches  prio     exec-runtime       
>  sum-exec        sum-sleep
> ----------------------------------------------------------------------------------------------------------
>             Xorg  2163     24407.116340     28791   120               0        
>       0               0.000000               0.000000               0.000000
> R           bash  2466     24387.418829       274   120               0        
>       0               0.000000               0.000000               0.000000
> 
> 
> Steps to reproduce:
> 
> # mount -o remount,sync /var
>   (or wherever queue_directory points to in the Postfix config)
> 
> # while true; do sendmail testaddr@localhost </dev/null; done
> 

