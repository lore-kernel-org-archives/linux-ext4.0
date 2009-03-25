From: Jan Kara <jack@suse.cz>
Subject: Re: next-20090310: ext4 hangs
Date: Wed, 25 Mar 2009 16:15:16 +0100
Message-ID: <20090325151516.GB14881@atrey.karlin.mff.cuni.cz>
References: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com> <20090310124658.GE8840@mit.edu> <a4423d670903100718w1a532143he767782ae598d0fb@mail.gmail.com> <20090310154745.GF23075@mit.edu> <a4423d670903110907o7041f4eof92278835aa0c71c@mail.gmail.com> <20090325151122.GA14881@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45452 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762186AbZCYPPS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Mar 2009 11:15:18 -0400
Content-Disposition: inline
In-Reply-To: <20090325151122.GA14881@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > 2009/3/10 Theodore Tso <tytso@mit.edu>:
> > > On Tue, Mar 10, 2009 at 05:18:55PM +0300, Alexander Beregalov wro=
te:
> > >> > Thanks for reporting this; does it show up on stock 2.6.29-rc7=
?
> > >> No, I can not reproduce it.
> > >> It is a slow system, I would not like to bisect it, only if it i=
s the
> > >> last possibility.
> > >
> > > Just to be clear; you weren't able to reproduce it on stock 2.6.2=
9-rc7
> > > ---- does it reproduce easily on linux-next?
> > Right.
> > But now I am not sure 2.6.29-rc7 is not affected, I will try to
> > reproduce it again.
> >=20
> > >
> > > Next question --- does the system hang completely, or just the db=
ench
> > > process (and probably any process that tries touching the filesys=
tem
> > System is responsible.
> > > that's hung up)? =A0Do you have a serial console, or someone of
> > > recording all of the dumps coming from sysrq-t? =A0The two stack =
traces
> > I can read dmesg.
> > > you gave weren't the ones causing the problem, but rather the one=
s
> > > waiting for the journal lock.
> >=20
> > SysRq : Show State
> >=20
> > <..>
> >=20
> > kjournald2    D 0000000000557a0c     0  1547      2
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [0000000000557a0c] jbd2_journal_commit_transaction+0x208/0x1718
> >  [000000000055d758] kjournald2+0x14c/0x318
> >  [0000000000465d34] kthread+0x48/0x7c
> >  [000000000042b364] kernel_thread+0x3c/0x54
> >  [0000000000465c88] kthreadd+0xc8/0x12c
> > pdflush       D 000000000055716c     0  2021      2
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [000000000055716c] start_this_handle+0x374/0x508
> >  [0000000000557500] jbd2_journal_start+0xbc/0x11c
> >  [000000000053a438] ext4_journal_start_sb+0x5c/0x84
> >  [000000000052dd84] ext4_da_writepages+0x1a8/0x404
> >  [0000000000490ec0] do_writepages+0x40/0x78
> >  [00000000004d0ff8] __writeback_single_inode+0x198/0x330
> >  [00000000004d15d8] generic_sync_sb_inodes+0x238/0x3c4
> >  [00000000004d1984] writeback_inodes+0xb0/0x114
> >  [00000000004915c0] background_writeout+0xc8/0x114
> >  [0000000000492004] pdflush+0x128/0x1e0
> >  [0000000000465d34] kthread+0x48/0x7c
> >  [000000000042b364] kernel_thread+0x3c/0x54
> >  [0000000000465c88] kthreadd+0xc8/0x12c
> > dbench        D 000000000055716c     0  2024      1
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [000000000055716c] start_this_handle+0x374/0x508
> >  [0000000000557500] jbd2_journal_start+0xbc/0x11c
> >  [000000000053a438] ext4_journal_start_sb+0x5c/0x84
> >  [000000000052a9b8] ext4_dirty_inode+0xd4/0xf0
> >  [00000000004d1a14] __mark_inode_dirty+0x2c/0x188
> >  [00000000004c7714] touch_atime+0x160/0x178
> >  [00000000004c2a3c] vfs_readdir+0x88/0xb0
> >  [00000000004eab90] compat_sys_getdents+0x3c/0x8c
> >  [0000000000406154] linux_sparc_syscall32+0x34/0x40
> > dbench        D 000000000055716c     0  2025      1
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [000000000055716c] start_this_handle+0x374/0x508
> >  [0000000000557500] jbd2_journal_start+0xbc/0x11c
> >  [000000000053a438] ext4_journal_start_sb+0x5c/0x84
> >  [000000000052a9b8] ext4_dirty_inode+0xd4/0xf0
> >  [00000000004d1a14] __mark_inode_dirty+0x2c/0x188
> >  [00000000004c7714] touch_atime+0x160/0x178
> >  [00000000004c2a3c] vfs_readdir+0x88/0xb0
> >  [00000000004eab90] compat_sys_getdents+0x3c/0x8c
> >  [0000000000406154] linux_sparc_syscall32+0x34/0x40
> > dbench        D 000000000055716c     0  2026      1
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [000000000055716c] start_this_handle+0x374/0x508
> >  [0000000000557500] jbd2_journal_start+0xbc/0x11c
> >  [000000000053a438] ext4_journal_start_sb+0x5c/0x84
> >  [000000000052a9b8] ext4_dirty_inode+0xd4/0xf0
> >  [00000000004d1a14] __mark_inode_dirty+0x2c/0x188
> >  [00000000004c7714] touch_atime+0x160/0x178
> >  [000000000048b56c] generic_file_aio_read+0x578/0x620
> >  [00000000004b5254] do_sync_read+0x90/0xe0
> >  [00000000004b5c40] vfs_read+0x7c/0x11c
> >  [00000000004b5d30] SyS_pread64+0x50/0x7c
> >  [000000000043f778] sys32_pread64+0x20/0x34
> >  [0000000000406154] linux_sparc_syscall32+0x34/0x40
> > dbench        D 000000000055716c     0  2027      1
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [000000000055716c] start_this_handle+0x374/0x508
> >  [0000000000557500] jbd2_journal_start+0xbc/0x11c
> >  [000000000053a438] ext4_journal_start_sb+0x5c/0x84
> >  [000000000052a9b8] ext4_dirty_inode+0xd4/0xf0
> >  [00000000004d1a14] __mark_inode_dirty+0x2c/0x188
> >  [00000000004c757c] file_update_time+0xe0/0x118
> >  [000000000048aef4] __generic_file_aio_write_nolock+0x280/0x380
> >  [000000000048b930] generic_file_aio_write+0x58/0xc8
> >  [0000000000526274] ext4_file_write+0xa8/0x15c
> >  [00000000004b5174] do_sync_write+0x90/0xe0
> >  [00000000004b5a40] vfs_write+0x7c/0x11c
> >  [00000000004b5b30] SyS_pwrite64+0x50/0x7c
> >  [000000000043f744] sys32_pwrite64+0x20/0x34
> >  [0000000000406154] linux_sparc_syscall32+0x34/0x40
> > dbench        D 000000000055716c     0  2028      1
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [000000000055716c] start_this_handle+0x374/0x508
> >  [0000000000557500] jbd2_journal_start+0xbc/0x11c
> >  [000000000053a438] ext4_journal_start_sb+0x5c/0x84
> >  [000000000052b958] ext4_da_write_begin+0x98/0x1a0
> >  [000000000048a8dc] generic_file_buffered_write+0xe4/0x2b8
> >  [000000000048afd0] __generic_file_aio_write_nolock+0x35c/0x380
> >  [000000000048b930] generic_file_aio_write+0x58/0xc8
> >  [0000000000526274] ext4_file_write+0xa8/0x15c
> >  [00000000004b5174] do_sync_write+0x90/0xe0
> >  [00000000004b5a40] vfs_write+0x7c/0x11c
> >  [00000000004b5b30] SyS_pwrite64+0x50/0x7c
> >  [000000000043f744] sys32_pwrite64+0x20/0x34
> >  [0000000000406154] linux_sparc_syscall32+0x34/0x40
> > dbench        D 000000000055c010     0  2029      1
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [000000000055c010] jbd2_journal_release_jbd_inode+0x94/0xd8
> >  [0000000000535bb4] ext4_clear_inode+0x2c/0x3c
> >  [00000000004c7b1c] clear_inode+0xac/0x124
> >  [0000000000527e48] ext4_free_inode+0x7c/0x3d4
> >  [000000000052f884] ext4_delete_inode+0x218/0x29c
> >  [00000000004c86b4] generic_delete_inode+0x8c/0x124
> >  [00000000004c876c] generic_drop_inode+0x20/0x19c
> >  [00000000004c77a4] iput+0x78/0x88
> >  [00000000004c0200] do_unlinkat+0xf8/0x154
> >  [00000000004c0270] SyS_unlink+0x14/0x24
> >  [0000000000406154] linux_sparc_syscall32+0x34/0x40
> > dbench        D 000000000055cf84     0  2030      1
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [000000000055cf84] jbd2_log_wait_commit+0x144/0x1a8
> >  [0000000000555cdc] jbd2_journal_stop+0x32c/0x37c
> >  [0000000000557594] jbd2_journal_force_commit+0x34/0x48
> >  [0000000000536d14] ext4_force_commit+0x30/0x50
> >  [00000000005296b8] ext4_write_inode+0x80/0xa0
> >  [00000000004d1044] __writeback_single_inode+0x1e4/0x330
> >  [00000000004d11b0] sync_inode+0x20/0x40
> >  [00000000005263ec] ext4_sync_file+0xc4/0x118
> >  [00000000004d46f0] vfs_fsync+0x6c/0xa0
> >  [00000000004d474c] do_fsync+0x28/0x44
> >  [00000000004d47a4] SyS_fsync+0x14/0x28
> >  [0000000000406154] linux_sparc_syscall32+0x34/0x40
> > dbench        D 000000000055716c     0  2031      1
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [000000000055716c] start_this_handle+0x374/0x508
> >  [0000000000557500] jbd2_journal_start+0xbc/0x11c
> >  [000000000053a438] ext4_journal_start_sb+0x5c/0x84
> >  [000000000052b958] ext4_da_write_begin+0x98/0x1a0
> >  [000000000048a8dc] generic_file_buffered_write+0xe4/0x2b8
> >  [000000000048afd0] __generic_file_aio_write_nolock+0x35c/0x380
> >  [000000000048b930] generic_file_aio_write+0x58/0xc8
> >  [0000000000526274] ext4_file_write+0xa8/0x15c
> >  [00000000004b5174] do_sync_write+0x90/0xe0
> >  [00000000004b5a40] vfs_write+0x7c/0x11c
> >  [00000000004b5b30] SyS_pwrite64+0x50/0x7c
> >  [000000000043f744] sys32_pwrite64+0x20/0x34
> >  [0000000000406154] linux_sparc_syscall32+0x34/0x40
> > dbench        D 000000000055716c     0  2032      1
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [000000000055716c] start_this_handle+0x374/0x508
> >  [0000000000557500] jbd2_journal_start+0xbc/0x11c
> >  [000000000053a438] ext4_journal_start_sb+0x5c/0x84
> >  [000000000052a9b8] ext4_dirty_inode+0xd4/0xf0
> >  [00000000004d1a14] __mark_inode_dirty+0x2c/0x188
> >  [00000000004c7714] touch_atime+0x160/0x178
> >  [00000000004c2a3c] vfs_readdir+0x88/0xb0
> >  [00000000004eab90] compat_sys_getdents+0x3c/0x8c
> >  [0000000000406154] linux_sparc_syscall32+0x34/0x40
> > dbench        D 000000000055716c     0  2033      1
> > Call Trace:
> >  [0000000000768bcc] schedule+0x18/0x40
> >  [000000000055716c] start_this_handle+0x374/0x508
> >  [0000000000557500] jbd2_journal_start+0xbc/0x11c
> >  [000000000053a438] ext4_journal_start_sb+0x5c/0x84
> >  [000000000052a9b8] ext4_dirty_inode+0xd4/0xf0
> >  [00000000004d1a14] __mark_inode_dirty+0x2c/0x188
> >  [00000000004c7714] touch_atime+0x160/0x178
> >  [000000000048b56c] generic_file_aio_read+0x578/0x620
> >  [00000000004b5254] do_sync_read+0x90/0xe0
> >  [00000000004b5c40] vfs_read+0x7c/0x11c
> >  [00000000004b5d30] SyS_pread64+0x50/0x7c
> >  [000000000043f778] sys32_pread64+0x20/0x34
> >  [0000000000406154] linux_sparc_syscall32+0x34/0x40
> >=20
> >=20
> > >
> > > I don't think is related to BZ #12579, although some of the sympt=
oms
> > > look superficially the same.
> > >
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
> > >
> > > P.S. =A0What are your dbench parameters, and how big is your file=
system,
> > > so I can try to reproduce it on my side? =A0And how long do you
> > > typically need to run before this triggers? =A0Thanks!
> >=20
> > It is 2G filesystem, I run
> > `dbench -c /usr/share/dbench/client.txt 10` or 5 clients.
> >=20
> > Yesterday it happened when I run it for the first time, but today I
> > run it 10 times before I got the deadlock.
> >=20
> > So, I think I need to try it on 2.6.29-rc7 again.
>   I've looked into this. Obviously, what's happenning is that we dele=
te
> an inode and jbd2_journal_release_jbd_inode() finds inode is just und=
er
> writeout in transaction commit and thus it waits. But it gets never w=
oken
> up and because it has a handle from the transaction, every one eventu=
ally
> blocks on waiting for a transaction to finish.
>   But I don't really see how that can happen. The code is really
> straightforward and everything happens under j_list_lock... Strange.
  BTW: Is the system SMP?

								Honza
--=20
Jan Kara <jack@suse.cz>
SuSE CR Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
