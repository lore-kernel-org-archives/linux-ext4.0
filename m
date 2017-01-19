From: Jan Kara <jack@suse.cz>
Subject: Re: Ext4 deadlock (+lockdep splat) during rsync
Date: Thu, 19 Jan 2017 18:45:06 +0100
Message-ID: <20170119174506.GB11602@quack2.suse.cz>
References: <20170108224114.27157.qmail@ns.sciencehorizons.net>
 <20170119173707.GA11602@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@sciencehorizons.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754149AbdASSe1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 19 Jan 2017 13:34:27 -0500
Content-Disposition: inline
In-Reply-To: <20170119173707.GA11602@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 19-01-17 18:37:07, Jan Kara wrote:
> On Sun 08-01-17 17:41:14, George Spelvin wrote:
> > After replacing a drive in a RAID array, I tried to bring some things
> > up to date with rsync and ran into an annoyingly repeatable deadlock.
> > 
> > So I found a chance to boot with a lockdep kernel and immediately turned up the following:
> > 
> > [  755.740865] =============================================
> > [  755.741072] [ INFO: possible recursive locking detected ]
> > [  755.741279] 4.9.1-00126-gfbb9fcc9-dirty #576 Not tainted
> > [  755.741489] ---------------------------------------------
> > [  755.741699] rsync/14818 is trying to acquire lock:
> > [  755.741907]  (&ei->xattr_sem){++++..}, at: [<ffffffff81234603>] ext4_expand_extra_isize_ea+0x63/0x850
> > [  755.742145] but task is already holding lock:
> > [  755.742742]  (&ei->xattr_sem){++++..}, at: [<ffffffff81236f95>] ext4_try_add_inline_entry+0x55/0x1a0
> > [  755.743102] other info that might help us debug this:
> > [  755.743802]  Possible unsafe locking scenario:
> > [  755.743802]        CPU0
> > [  755.743802]        ----
> > [  755.743802]   lock(&ei->xattr_sem);
> > [  755.743802]   lock(&ei->xattr_sem);
> > [  755.743802] *** DEADLOCK ***
> > [  755.743802]  May be due to missing lock nesting notation
> > [  755.743802] 4 locks held by rsync/14818:
> > [  755.743802]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff811a0fef>] mnt_want_write+0x1f/0x50
> > [  755.743802]  #1:  (&type->i_mutex_dir_key){++++++}, at: [<ffffffff8118b058>] path_openat+0x2f8/0x9f0
> > [  755.743802]  #2:  (jbd2_handle){++++..}, at: [<ffffffff81239aa6>] start_this_handle+0x196/0x540
> > [  755.743802]  #3:  (&ei->xattr_sem){++++..}, at: [<ffffffff81236f95>] ext4_try_add_inline_entry+0x55/0x1a0
> > [  755.743802] stack backtrace:
> > [  755.743802] CPU: 0 PID: 14818 Comm: rsync Not tainted 4.9.1-00126-gfbb9fcc9-dirty #576
> > [  755.743802] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./X79-UP4, BIOS F7 03/19/2014
> > [  755.743802]  ffffc9000c273820 ffffffff812a6d05 ffffffff8253a080 ffffffff8253a080
> > [  755.743802]  ffffc9000c2738d8 ffffffff810c7eab ffffc9000c272000 ffffc90000000004
> > [  755.743802]  0000000000000000 ffffffff81e0b100 1a883a7e30ec461a ffffffff8253a080
> > [  755.743802] Call Trace:
> > [  755.743802]  [<ffffffff812a6d05>] dump_stack+0x68/0x93
> > [  755.743802]  [<ffffffff810c7eab>] __lock_acquire+0x7ab/0x1270
> > [  755.743802]  [<ffffffff810c8d10>] lock_acquire+0x60/0x80
> > [  755.743802]  [<ffffffff81234603>] ? ext4_expand_extra_isize_ea+0x63/0x850
> > [  755.743802]  [<ffffffff81793a44>] down_write+0x44/0x80
> > [  755.743802]  [<ffffffff81234603>] ? ext4_expand_extra_isize_ea+0x63/0x850
> > [  755.743802]  [<ffffffff81234603>] ext4_expand_extra_isize_ea+0x63/0x850
> > [  755.743802]  [<ffffffff81795ec2>] ? _raw_read_unlock+0x22/0x30
> > [  755.743802]  [<ffffffff8123a542>] ? jbd2_journal_extend+0x132/0x1b0
> > [  755.743802]  [<ffffffff812002c9>] ext4_mark_inode_dirty+0x129/0x180
> > [  755.743802]  [<ffffffff81235d64>] ext4_add_dirent_to_inline.isra.16+0xe4/0x100
> > [  755.743802]  [<ffffffff81236fd9>] ext4_try_add_inline_entry+0x99/0x1a0
> > [  755.743802]  [<ffffffff8120b102>] ext4_add_entry+0x1d2/0x370
> > [  755.743802]  [<ffffffff8120b2b9>] ext4_add_nondir+0x19/0x70
> > [  755.743802]  [<ffffffff8120b523>] ext4_create+0xc3/0x150
> > [  755.743802]  [<ffffffff8118aaf8>] lookup_open+0x3d8/0x640
> > [  755.743802]  [<ffffffff8118b072>] path_openat+0x312/0x9f0
> > [  755.743802]  [<ffffffff8118d309>] do_filp_open+0x79/0xd0
> > [  755.743802]  [<ffffffff81795bc2>] ? _raw_spin_unlock+0x22/0x30
> > [  755.743802]  [<ffffffff8119d9b3>] ? __alloc_fd+0xf3/0x200
> > [  755.743802]  [<ffffffff8117b4fe>] do_sys_open+0x11e/0x1f0
> > [  755.743802]  [<ffffffff811d2046>] compat_SyS_open+0x16/0x20
> > [  755.743802]  [<ffffffff810027e4>] do_fast_syscall_32+0x94/0x210
> > [  755.743802]  [<ffffffff81797da1>] entry_SYSENTER_compat+0x51/0x60
> 
> OK, the problem is that we call ext4_mark_inode_dirty() while holding
> xattr_sem and that recurses into ext4_expand_extra_isize_ea() which tries
> to grab it again. This may happen in several place in inline.c, generally
> when handling inline directories. I'll try to craft a fix tomorrow...

Ah, I've noticed Ted had already beaten me to it...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
