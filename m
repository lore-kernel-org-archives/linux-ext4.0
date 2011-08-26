From: Dave Chinner <david@fromorbit.com>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
Date: Fri, 26 Aug 2011 17:35:07 +1000
Message-ID: <20110826073507.GZ3162@dastard>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jiaying Zhang <jiayingz@google.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:47519 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704Ab1HZHfM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Aug 2011 03:35:12 -0400
Content-Disposition: inline
In-Reply-To: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 25, 2011 at 11:33:44PM -0400, Theodore Ts'o wrote:
> 
> Note: this will probably need to be sent to Linus as an emergency
> bugfix ASAP, since it was introduced in 3.1-rc1, so it represents a
> regression.

It doesn't appear to be a bug. All of the new ext4 lockdep reports
in 3.1 I've seen (except for the mmap_sem/i_mutex one) are false
positives....

.....
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.1.0-rc3-00012-g2a22fc1 #1839
> -------------------------------------------------------
> dd/7677 is trying to acquire lock:
>  (&type->s_umount_key#18){++++..}, at: [<c021ea77>] writeback_inodes_sb_if_idle+0x26/0x3d
> 
> but task is already holding lock:
>  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<c01d5956>] generic_file_aio_write+0x52/0xba
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&sb->s_type->i_mutex_key#3){+.+.+.}:
>        [<c018eb02>] lock_acquire+0x99/0xbd
>        [<c06a53b5>] __mutex_lock_common+0x33/0x2fb
>        [<c06a572b>] mutex_lock_nested+0x26/0x2f
>        [<c026c2db>] ext4_evict_inode+0x3e/0x2bd
>        [<c0214bb0>] evict+0x8e/0x131
>        [<c0214de6>] dispose_list+0x36/0x40
>        [<c0215239>] evict_inodes+0xcd/0xd5
>        [<c0204a23>] generic_shutdown_super+0x3d/0xaa
>        [<c0204ab2>] kill_block_super+0x22/0x5e
>        [<c0204cb8>] deactivate_locked_super+0x22/0x4e
>        [<c02055b2>] deactivate_super+0x3d/0x43
>        [<c0218427>] mntput_no_expire+0xda/0xdf
>        [<c0219486>] sys_umount+0x286/0x2ab
>        [<c02194bd>] sys_oldumount+0x12/0x14
>        [<c06a6ac5>] syscall_call+0x7/0xb
> 
> -> #0 (&type->s_umount_key#18){++++..}:
>        [<c018e262>] __lock_acquire+0x967/0xbd2
>        [<c018eb02>] lock_acquire+0x99/0xbd
>        [<c06a5991>] down_read+0x28/0x65
>        [<c021ea77>] writeback_inodes_sb_if_idle+0x26/0x3d
>        [<c0269630>] ext4_nonda_switch+0xd0/0xe1
>        [<c026e953>] ext4_da_write_begin+0x3c/0x1cf
>        [<c01d46ad>] generic_file_buffered_write+0xc0/0x1b4
>        [<c01d58d3>] __generic_file_aio_write+0x254/0x285
>        [<c01d596e>] generic_file_aio_write+0x6a/0xba
>        [<c026732f>] ext4_file_write+0x1d6/0x227
>        [<c0202789>] do_sync_write+0x8f/0xca
>        [<c02030d5>] vfs_write+0x85/0xe3
>        [<c02031d4>] sys_write+0x40/0x65
>        [<c06a6ac5>] syscall_call+0x7/0xb

That's definitely a false positive - sys_write() will have an active
reference to the inode, and evict is only called on inodes without
active references. Hence you can never get a deadlock between an
inode context with an active reference and the same inode in the
evict/dispose path because inode cannot be in both places at once...

This is why XFS changes the lockdep context for the its iolock as
soon as .evict is called on the inode - to stop these false
positives from being emitted whenever memory reclaim or unmount
evicts inodes.

Cheers,

dave.
-- 
Dave Chinner
david@fromorbit.com
