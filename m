From: Nikola Pajkovsky <nikola.pajkovsky@gooddata.com>
Subject: Re: xfstests generic/130 hang with non-4k block size ext4 on 4.7-rc1 kernel
Date: Thu, 09 Jun 2016 09:23:29 +0200
Message-ID: <87oa7a6d1q.fsf@gooddata.com>
References: <20160531140922.GM5140@eguan.usersys.redhat.com>
	<20160531154017.GC5357@thunk.org>
	<20160601063822.GH10350@eguan.usersys.redhat.com>
	<20160601165800.GI10350@eguan.usersys.redhat.com>
	<20160602085840.GH19636@quack2.suse.cz>
	<20160602121750.GC32574@quack2.suse.cz>
	<20160603101612.GJ10350@eguan.usersys.redhat.com>
	<20160603115844.GB2470@quack2.suse.cz>
	<20160608125631.GA19589@quack2.suse.cz>
	<pan$6abef$45fa540$7a7a0c36$ef55c356@applied-asynchrony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: Holger =?utf-8?Q?Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35101 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbcFIHXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jun 2016 03:23:33 -0400
Received: by mail-wm0-f42.google.com with SMTP id v199so93844838wmv.0
        for <linux-ext4@vger.kernel.org>; Thu, 09 Jun 2016 00:23:32 -0700 (PDT)
In-Reply-To: <pan$6abef$45fa540$7a7a0c36$ef55c356@applied-asynchrony.com>
	("Holger =?utf-8?Q?Hoffst=C3=A4tte=22's?= message of "Wed, 8 Jun 2016
 14:23:49 +0000
	(UTC)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Holger Hoffst=C3=A4tte <holger@applied-asynchrony.com> writes:

> On Wed, 08 Jun 2016 14:56:31 +0200, Jan Kara wrote:
> (snip)
>> Attached patch fixes the issue for me. I'll submit it once a full xf=
stests
>> run finishes for it (which may take a while as our server room is cu=
rrently
>> moving to a different place).
>>=20
>> 								Honza
>> --=20
>> Jan Kara <jack@suse.com>
>> SUSE Labs, CR
>> From 3a120841a5d9a6c42bf196389467e9e663cf1cf8 Mon Sep 17 00:00:00 20=
01
>> From: Jan Kara <jack@suse.cz>
>> Date: Wed, 8 Jun 2016 10:01:45 +0200
>> Subject: [PATCH] ext4: Fix deadlock during page writeback
>>=20
>> Commit 06bd3c36a733 (ext4: fix data exposure after a crash) uncovere=
d a
>> deadlock in ext4_writepages() which was previously much harder to hi=
t.
>> After this commit xfstest generic/130 reproduces the deadlock on sma=
ll
>> filesystems.
>
> Since you marked this for -stable, just a heads-up that the previous =
patch
> for the data exposure was rejected from -stable (see [1]) because it
> has the mismatching "!IS_NOQUOTA(inode) &&" line, which didn't exist
> until 4.6. I removed it locally but Greg probably wants an official p=
atch.
>
> So both this and the previous patch need to be submitted.
>
> [1] http://permalink.gmane.org/gmane.linux.kernel.stable/18074{4,5,6}

I'm just wondering if the Jan's patch is not related to blocked
processes in following trace. It very hard to hit it and I don't have
any reproducer.

kernel: INFO: task jbd2/vdc-8:4710 blocked for more than 120 seconds. s=
everity=3Derr
kernel:      Not tainted 3.18.21-1.el6.gdc.x86_64 #1 severity=3Derr
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables thi=
s message. severity=3Derr
kernel: jbd2/vdc-8      D 0000000000000002     0  4710      2 0x0000008=
0 severity=3Dinfo
kernel: ffff88273a373b38 0000000000000046 ffff88273a373ae8 ffff88273a37=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88273c76c7e0 ffff88273e32=
2b20 severity=3Dwarning
kernel: ffff88273a373b38 ffff88277f092c40 ffff88273c76c7e0 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffff8121021e>] __wait_on_buffer+0x2e/0x30 severity=3Dwarn=
ing
kernel: [<ffffffffa01180a1>] jbd2_journal_commit_transaction+0x861/0x16=
e0 [jbd2] severity=3Dwarning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011d847>] kjournald2+0x127/0x340 [jbd2] severity=3Dw=
arning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011d720>] ? jbd2_journal_clear_features+0x90/0x90 [j=
bd2] severity=3Dwarning
kernel: [<ffffffff8108b31e>] kthread+0xce/0xf0 severity=3Dwarning
kernel: [<ffffffff8108b250>] ? kthread_freezable_should_stop+0x70/0x70 =
severity=3Dwarning
kernel: [<ffffffff81618c58>] ret_from_fork+0x58/0x90 severity=3Dwarning
kernel: [<ffffffff8108b250>] ? kthread_freezable_should_stop+0x70/0x70 =
severity=3Dwarning
kernel: INFO: task postmaster:25406 blocked for more than 120 seconds. =
severity=3Derr
kernel:      Not tainted 3.18.21-1.el6.gdc.x86_64 #1 severity=3Derr
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables thi=
s message. severity=3Derr
kernel: postmaster      D 000000000000000f     0 25406  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff882485e5f9a8 0000000000000086 ffff882485e5f958 ffff882485e5=
c010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff882657c9d640 ffff88273e3b=
8000 severity=3Dwarning
kernel: ffff882485e5f9a8 ffff88277f3d2c40 ffff882657c9d640 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff81210a9a>] ? __getblk_gfp+0x3a/0x80 severity=3Dwarnin=
g
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa0146c08>] ext4_reserve_inode_write+0x78/0xa0 [ext4] =
severity=3Dwarning
kernel: [<ffffffffa0146c82>] ext4_mark_inode_dirty+0x52/0x240 [ext4] se=
verity=3Dwarning
kernel: [<ffffffffa0146eba>] ext4_dirty_inode+0x4a/0x70 [ext4] severity=
=3Dwarning
kernel: [<ffffffff8120644a>] __mark_inode_dirty+0x3a/0x290 severity=3Dw=
arning
kernel: [<ffffffff811f6f91>] update_time+0x81/0xc0 severity=3Dwarning
kernel: [<ffffffff811f7068>] file_update_time+0x98/0xe0 severity=3Dwarn=
ing
kernel: [<ffffffff811630b2>] __generic_file_write_iter+0x162/0x390 seve=
rity=3Dwarning
kernel: [<ffffffffa013deb9>] ext4_file_write_iter+0x119/0x430 [ext4] se=
verity=3Dwarning
kernel: [<ffffffff811dbf22>] new_sync_write+0x92/0xd0 severity=3Dwarnin=
g
kernel: [<ffffffff811dc43e>] vfs_write+0xce/0x180 severity=3Dwarning
kernel: [<ffffffff811dca86>] SyS_write+0x56/0xd0 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: INFO: task kworker/u36:2:20256 blocked for more than 120 second=
s. severity=3Derr
kernel:      Not tainted 3.18.21-1.el6.gdc.x86_64 #1 severity=3Derr
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables thi=
s message. severity=3Derr
kernel: kworker/u36:2   D 0000000000000002     0 20256      2 0x0000008=
0 severity=3Dinfo
kernel: Workqueue: writeback bdi_writeback_workfn (flush-253:32) severi=
ty=3Dinfo
kernel: ffff881b4ef83448 0000000000000046 ffff881b4ef833f8 ffff881b4ef8=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88273a238e60 ffff88273e32=
2b20 severity=3Dwarning
kernel: ffff881b4ef83418 ffff88277f092c40 ffff88273a238e60 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffffa0175f37>] ? mb_mark_used+0x297/0x350 [ext4] severity=
=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff81210a9a>] ? __getblk_gfp+0x3a/0x80 severity=3Dwarnin=
g
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa013c61a>] ? ext4_read_block_bitmap+0x3a/0x60 [ext4] =
severity=3Dwarning
kernel: [<ffffffffa0177139>] ext4_mb_mark_diskspace_used+0x79/0x320 [ex=
t4] severity=3Dwarning
kernel: [<ffffffffa017f341>] ext4_mb_new_blocks+0x331/0x510 [ext4] seve=
rity=3Dwarning
kernel: [<ffffffffa01722d7>] ext4_ext_map_blocks+0x877/0xae0 [ext4] sev=
erity=3Dwarning
kernel: [<ffffffff8116f9e1>] ? release_pages+0x1e1/0x250 severity=3Dwar=
ning
kernel: [<ffffffffa0143fc6>] ext4_map_blocks+0x176/0x4b0 [ext4] severit=
y=3Dwarning
kernel: [<ffffffffa01449c4>] ? mpage_prepare_extent_to_map+0x304/0x350 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa0144591>] mpage_map_one_extent+0x71/0x1a0 [ext4] sev=
erity=3Dwarning
kernel: [<ffffffffa01484ab>] mpage_map_and_submit_extent+0x4b/0x220 [ex=
t4] severity=3Dwarning
kernel: [<ffffffffa01746a4>] ? __ext4_journal_start_sb+0x74/0x100 [ext4=
] severity=3Dwarning
kernel: [<ffffffffa0148b4b>] ext4_writepages+0x4cb/0x630 [ext4] severit=
y=3Dwarning
kernel: [<ffffffff812c37e5>] ? blk_mq_flush_plug_list+0x135/0x150 sever=
ity=3Dwarning
kernel: [<ffffffff810a4073>] ? set_next_entity+0x93/0xa0 severity=3Dwar=
ning
kernel: [<ffffffff8116cb20>] do_writepages+0x20/0x40 severity=3Dwarning
kernel: [<ffffffff81205990>] __writeback_single_inode+0x40/0x220 severi=
ty=3Dwarning
kernel: [<ffffffff810ad72f>] ? wake_up_bit+0x2f/0x40 severity=3Dwarning
kernel: [<ffffffff81206c44>] writeback_sb_inodes+0x2b4/0x3c0 severity=3D=
warning
kernel: [<ffffffff811deef1>] ? put_super+0x31/0x40 severity=3Dwarning
kernel: [<ffffffff81206dee>] __writeback_inodes_wb+0x9e/0xd0 severity=3D=
warning
kernel: [<ffffffff81207063>] wb_writeback+0x243/0x2d0 severity=3Dwarnin=
g
kernel: [<ffffffff812071eb>] wb_do_writeback+0xfb/0x1e0 severity=3Dwarn=
ing
kernel: [<ffffffff81207340>] bdi_writeback_workfn+0x70/0x210 severity=3D=
warning
kernel: [<ffffffff810848c3>] process_one_work+0x143/0x4b0 severity=3Dwa=
rning
kernel: [<ffffffff81085a33>] worker_thread+0x123/0x520 severity=3Dwarni=
ng
kernel: [<ffffffff81614095>] ? __schedule+0x375/0x750 severity=3Dwarnin=
g
kernel: [<ffffffff81085910>] ? maybe_create_worker+0x130/0x130 severity=
=3Dwarning
kernel: [<ffffffff8108b31e>] kthread+0xce/0xf0 severity=3Dwarning
kernel: [<ffffffff8108b250>] ? kthread_freezable_should_stop+0x70/0x70 =
severity=3Dwarning
kernel: [<ffffffff81618c58>] ret_from_fork+0x58/0x90 severity=3Dwarning
kernel: [<ffffffff8108b250>] ? kthread_freezable_should_stop+0x70/0x70 =
severity=3Dwarning
kernel: INFO: task postmaster:14855 blocked for more than 120 seconds. =
severity=3Derr
kernel:      Not tainted 3.18.21-1.el6.gdc.x86_64 #1 severity=3Derr
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables thi=
s message. severity=3Derr
kernel: postmaster      D 0000000000000009     0 14855  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff8822bf3877b8 0000000000000082 ffff8822bf387768 ffff8822bf38=
4010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff8825d71f5640 ffff88273e39=
1cc0 severity=3Dwarning
kernel: ffff8822bf387788 ffff88277f252c40 ffff8825d71f5640 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffff8120f780>] ? bh_lru_install+0x170/0x1a0 severity=3Dwa=
rning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa013c61a>] ? ext4_read_block_bitmap+0x3a/0x60 [ext4] =
severity=3Dwarning
kernel: [<ffffffffa01771ab>] ext4_mb_mark_diskspace_used+0xeb/0x320 [ex=
t4] severity=3Dwarning
kernel: [<ffffffffa017f341>] ext4_mb_new_blocks+0x331/0x510 [ext4] seve=
rity=3Dwarning
kernel: [<ffffffffa01722d7>] ext4_ext_map_blocks+0x877/0xae0 [ext4] sev=
erity=3Dwarning
kernel: [<ffffffff8116f9e1>] ? release_pages+0x1e1/0x250 severity=3Dwar=
ning
kernel: [<ffffffffa0143fc6>] ext4_map_blocks+0x176/0x4b0 [ext4] severit=
y=3Dwarning
kernel: [<ffffffffa01449c4>] ? mpage_prepare_extent_to_map+0x304/0x350 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa0144591>] mpage_map_one_extent+0x71/0x1a0 [ext4] sev=
erity=3Dwarning
kernel: [<ffffffffa01484ab>] mpage_map_and_submit_extent+0x4b/0x220 [ex=
t4] severity=3Dwarning
kernel: [<ffffffffa0148b4b>] ext4_writepages+0x4cb/0x630 [ext4] severit=
y=3Dwarning
kernel: [<ffffffff81193472>] ? handle_mm_fault+0xb2/0x1a0 severity=3Dwa=
rning
kernel: [<ffffffff8116cb20>] do_writepages+0x20/0x40 severity=3Dwarning
kernel: [<ffffffff81160a69>] __filemap_fdatawrite_range+0x59/0x60 sever=
ity=3Dwarning
kernel: [<ffffffff81160b1a>] filemap_write_and_wait_range+0xaa/0x100 se=
verity=3Dwarning
kernel: [<ffffffffa013eac3>] ext4_sync_file+0xf3/0x260 [ext4] severity=3D=
warning
kernel: [<ffffffff8120cf91>] vfs_fsync_range+0x21/0x30 severity=3Dwarni=
ng
kernel: [<ffffffff8120cfbc>] vfs_fsync+0x1c/0x20 severity=3Dwarning
kernel: [<ffffffff8120d1ad>] do_fsync+0x3d/0x70 severity=3Dwarning
kernel: [<ffffffff8120d210>] SyS_fsync+0x10/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: INFO: task postmaster:14856 blocked for more than 120 seconds. =
severity=3Derr
kernel:      Not tainted 3.18.21-1.el6.gdc.x86_64 #1 severity=3Derr
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables thi=
s message. severity=3Derr
kernel: postmaster      D 0000000000000006     0 14856  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff88262affb8a8 0000000000000086 ffff88262affb858 ffff88262aff=
8010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88266aab1cc0 ffff88273e32=
64a0 severity=3Dwarning
kernel: ffff88225c97d6a0 ffff88277f192c40 ffff88266aab1cc0 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffffa011576e>] ? start_this_handle+0x28e/0x520 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa01406d4>] __ext4_new_inode+0x3a4/0x1110 [ext4] sever=
ity=3Dwarning
kernel: [<ffffffff8123c960>] ? __dquot_initialize+0x30/0x1e0 severity=3D=
warning
kernel: [<ffffffffa0150bbb>] ext4_create+0xab/0x170 [ext4] severity=3Dw=
arning
kernel: [<ffffffff811e9118>] vfs_create+0xd8/0x100 severity=3Dwarning
kernel: [<ffffffff811e982e>] lookup_open+0x13e/0x1d0 severity=3Dwarning
kernel: [<ffffffff811ed006>] do_last+0x416/0x820 severity=3Dwarning
kernel: [<ffffffff811ed4d4>] path_openat+0xc4/0x480 severity=3Dwarning
kernel: [<ffffffff811e77a9>] ? putname+0x29/0x40 severity=3Dwarning
kernel: [<ffffffff811ed9ca>] do_filp_open+0x4a/0xa0 severity=3Dwarning
kernel: [<ffffffff811fa64c>] ? __alloc_fd+0xac/0x150 severity=3Dwarning
kernel: [<ffffffff811db9ea>] do_sys_open+0x11a/0x230 severity=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff8110f3e6>] ? __audit_syscall_exit+0x246/0x2f0 severit=
y=3Dwarning
kernel: [<ffffffff811dbb3e>] SyS_open+0x1e/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: INFO: task postmaster:14857 blocked for more than 120 seconds. =
severity=3Derr
kernel:      Not tainted 3.18.21-1.el6.gdc.x86_64 #1 severity=3Derr
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables thi=
s message. severity=3Derr
kernel: postmaster      D 0000000000000010     0 14857  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff880748203df8 0000000000000082 ffff8826a94e67c8 ffff88074820=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88266aab5640 ffff88273e3b=
8e60 severity=3Dwarning
kernel: ffff880748203e08 00000000023bc691 ffff882737c2e800 ffff88074820=
3e38 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffffa011db45>] jbd2_log_wait_commit+0xe5/0x170 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011de47>] jbd2_complete_transaction+0x57/0x90 [jbd2]=
 severity=3Dwarning
kernel: [<ffffffffa013ebcd>] ext4_sync_file+0x1fd/0x260 [ext4] severity=
=3Dwarning
kernel: [<ffffffff8120cf91>] vfs_fsync_range+0x21/0x30 severity=3Dwarni=
ng
kernel: [<ffffffff8120cfbc>] vfs_fsync+0x1c/0x20 severity=3Dwarning
kernel: [<ffffffff8120d1ad>] do_fsync+0x3d/0x70 severity=3Dwarning
kernel: [<ffffffff8120d210>] SyS_fsync+0x10/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: INFO: task postmaster:14859 blocked for more than 120 seconds. =
severity=3Derr
kernel:      Not tainted 3.18.21-1.el6.gdc.x86_64 #1 severity=3Derr
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables thi=
s message. severity=3Derr
kernel: postmaster      D 0000000000000001     0 14859  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff8820d2017c38 0000000000000082 ffff882700000000 ffff8820d201=
4010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff882657c99cc0 ffff88273e32=
1cc0 severity=3Dwarning
kernel: ffff882657c99cc0 ffff8826feadc068 ffff882657c99cc0 ffff8826fead=
c06c severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616535>] __mutex_lock_slowpath+0x95/0x100 severity=3D=
warning
kernel: [<ffffffff816165c3>] mutex_lock+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811ecfec>] do_last+0x3fc/0x820 severity=3Dwarning
kernel: [<ffffffff811ed4d4>] path_openat+0xc4/0x480 severity=3Dwarning
kernel: [<ffffffff816165b6>] ? mutex_lock+0x16/0x40 severity=3Dwarning
kernel: [<ffffffff811ed9ca>] do_filp_open+0x4a/0xa0 severity=3Dwarning
kernel: [<ffffffff811fa64c>] ? __alloc_fd+0xac/0x150 severity=3Dwarning
kernel: [<ffffffff811db9ea>] do_sys_open+0x11a/0x230 severity=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff8110f3e6>] ? __audit_syscall_exit+0x246/0x2f0 severit=
y=3Dwarning
kernel: [<ffffffff811dbb3e>] SyS_open+0x1e/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: INFO: task postmaster:14860 blocked for more than 120 seconds. =
severity=3Derr
kernel:      Not tainted 3.18.21-1.el6.gdc.x86_64 #1 severity=3Derr
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables thi=
s message. severity=3Derr
kernel: postmaster      D 000000000000000e     0 14860  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff8820d22fbdf8 0000000000000086 ffff8826947ba4d8 ffff8820d22f=
8010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88266a93e4a0 ffff88273e39=
64a0 severity=3Dwarning
kernel: ffff8820d22fbe08 00000000023bc691 ffff882737c2e800 ffff8820d22f=
be38 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffffa011db45>] jbd2_log_wait_commit+0xe5/0x170 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011de47>] jbd2_complete_transaction+0x57/0x90 [jbd2]=
 severity=3Dwarning
kernel: [<ffffffffa013ebcd>] ext4_sync_file+0x1fd/0x260 [ext4] severity=
=3Dwarning
kernel: [<ffffffff8120cf91>] vfs_fsync_range+0x21/0x30 severity=3Dwarni=
ng
kernel: [<ffffffff8120cfbc>] vfs_fsync+0x1c/0x20 severity=3Dwarning
kernel: [<ffffffff8120d1ad>] do_fsync+0x3d/0x70 severity=3Dwarning
kernel: [<ffffffff8120d210>] SyS_fsync+0x10/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: INFO: task postmaster:14861 blocked for more than 120 seconds. =
severity=3Derr
kernel:      Not tainted 3.18.21-1.el6.gdc.x86_64 #1 severity=3Derr
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables thi=
s message. severity=3Derr
kernel: postmaster      D 0000000000000007     0 14861  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff88041dfdfc38 0000000000000082 0000000000000000 ffff88041dfd=
c010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88266a939cc0 ffff88273e39=
0000 severity=3Dwarning
kernel: ffff88281ffd8d80 ffff8826feadc068 ffff88266a939cc0 ffff8826fead=
c06c severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616535>] __mutex_lock_slowpath+0x95/0x100 severity=3D=
warning
kernel: [<ffffffff816165c3>] mutex_lock+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811ecfec>] do_last+0x3fc/0x820 severity=3Dwarning
kernel: [<ffffffff811ed4d4>] path_openat+0xc4/0x480 severity=3Dwarning
kernel: [<ffffffff811ed9ca>] do_filp_open+0x4a/0xa0 severity=3Dwarning
kernel: [<ffffffff811fa64c>] ? __alloc_fd+0xac/0x150 severity=3Dwarning
kernel: [<ffffffff811db9ea>] do_sys_open+0x11a/0x230 severity=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811dbb3e>] SyS_open+0x1e/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: INFO: task postmaster:14868 blocked for more than 120 seconds. =
severity=3Derr
kernel:      Not tainted 3.18.21-1.el6.gdc.x86_64 #1 severity=3Derr
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables thi=
s message. severity=3Derr
kernel: postmaster      D 000000000000000a     0 14868  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff8821bd68fdf8 0000000000000086 ffff88269980e7c8 ffff8821bd68=
c010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88273dd68e60 ffff88273e39=
2b20 severity=3Dwarning
kernel: ffff8821bd68fe08 00000000023bc691 ffff882737c2e800 ffff8821bd68=
fe38 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffffa011db45>] jbd2_log_wait_commit+0xe5/0x170 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011de47>] jbd2_complete_transaction+0x57/0x90 [jbd2]=
 severity=3Dwarning
kernel: [<ffffffffa013ebcd>] ext4_sync_file+0x1fd/0x260 [ext4] severity=
=3Dwarning
kernel: [<ffffffff8120cf91>] vfs_fsync_range+0x21/0x30 severity=3Dwarni=
ng
kernel: [<ffffffff8120cfbc>] vfs_fsync+0x1c/0x20 severity=3Dwarning
kernel: [<ffffffff8120d1ad>] do_fsync+0x3d/0x70 severity=3Dwarning
kernel: [<ffffffff8120d210>] SyS_fsync+0x10/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: SysRq : Show Blocked State severity=3Dinfo
kernel:  task                        PC stack   pid father severity=3Di=
nfo
kernel: jbd2/vdc-8      D 0000000000000002     0  4710      2 0x0000008=
0 severity=3Dinfo
kernel: ffff88273a373b38 0000000000000046 ffff88273a373ae8 ffff88273a37=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88273c76c7e0 ffff88273e32=
2b20 severity=3Dwarning
kernel: ffff88273a373b38 ffff88277f092c40 ffff88273c76c7e0 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffff8121021e>] __wait_on_buffer+0x2e/0x30 severity=3Dwarn=
ing
kernel: [<ffffffffa01180a1>] jbd2_journal_commit_transaction+0x861/0x16=
e0 [jbd2] severity=3Dwarning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011d847>] kjournald2+0x127/0x340 [jbd2] severity=3Dw=
arning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011d720>] ? jbd2_journal_clear_features+0x90/0x90 [j=
bd2] severity=3Dwarning
kernel: [<ffffffff8108b31e>] kthread+0xce/0xf0 severity=3Dwarning
kernel: [<ffffffff8108b250>] ? kthread_freezable_should_stop+0x70/0x70 =
severity=3Dwarning
kernel: [<ffffffff81618c58>] ret_from_fork+0x58/0x90 severity=3Dwarning
kernel: [<ffffffff8108b250>] ? kthread_freezable_should_stop+0x70/0x70 =
severity=3Dwarning
kernel: postmaster      D 000000000000000f     0 25406  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff882485e5f9a8 0000000000000086 ffff882485e5f958 ffff882485e5=
c010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff882657c9d640 ffff88273e3b=
8000 severity=3Dwarning
kernel: ffff882485e5f9a8 ffff88277f3d2c40 ffff882657c9d640 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff81210a9a>] ? __getblk_gfp+0x3a/0x80 severity=3Dwarnin=
g
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa0146c08>] ext4_reserve_inode_write+0x78/0xa0 [ext4] =
severity=3Dwarning
kernel: [<ffffffffa0146c82>] ext4_mark_inode_dirty+0x52/0x240 [ext4] se=
verity=3Dwarning
kernel: [<ffffffffa0146eba>] ext4_dirty_inode+0x4a/0x70 [ext4] severity=
=3Dwarning
kernel: [<ffffffff8120644a>] __mark_inode_dirty+0x3a/0x290 severity=3Dw=
arning
kernel: [<ffffffff811f6f91>] update_time+0x81/0xc0 severity=3Dwarning
kernel: [<ffffffff811f7068>] file_update_time+0x98/0xe0 severity=3Dwarn=
ing
kernel: [<ffffffff811630b2>] __generic_file_write_iter+0x162/0x390 seve=
rity=3Dwarning
kernel: [<ffffffffa013deb9>] ext4_file_write_iter+0x119/0x430 [ext4] se=
verity=3Dwarning
kernel: [<ffffffff811dbf22>] new_sync_write+0x92/0xd0 severity=3Dwarnin=
g
kernel: [<ffffffff811dc43e>] vfs_write+0xce/0x180 severity=3Dwarning
kernel: [<ffffffff811dca86>] SyS_write+0x56/0xd0 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 000000000000000b     0 26139  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff882451267e28 0000000000000082 ffff882737404020 ffff88245126=
4010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff882641ea8e60 ffff88273e39=
3980 severity=3Dwarning
kernel: 0000000000000003 ffff8826feadc068 ffff882641ea8e60 ffff8826fead=
c06c severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616694>] __mutex_lock_killable_slowpath+0xb4/0x140 =
severity=3Dwarning
kernel: [<ffffffff81616762>] mutex_lock_killable+0x42/0x50 severity=3Dw=
arning
kernel: [<ffffffff811efc77>] iterate_dir+0x77/0x140 severity=3Dwarning
kernel: [<ffffffff8110e0cc>] ? __audit_syscall_entry+0xac/0x110 severit=
y=3Dwarning
kernel: [<ffffffff811efef1>] SyS_getdents+0xb1/0x100 severity=3Dwarning
kernel: [<ffffffff811effd0>] ? SyS_old_readdir+0x90/0x90 severity=3Dwar=
ning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: kworker/u36:2   D 0000000000000002     0 20256      2 0x0000008=
0 severity=3Dinfo
kernel: Workqueue: writeback bdi_writeback_workfn (flush-253:32) severi=
ty=3Dinfo
kernel: ffff881b4ef83448 0000000000000046 ffff881b4ef833f8 ffff881b4ef8=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88273a238e60 ffff88273e32=
2b20 severity=3Dwarning
kernel: ffff881b4ef83418 ffff88277f092c40 ffff88273a238e60 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffffa0175f37>] ? mb_mark_used+0x297/0x350 [ext4] severity=
=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff81210a9a>] ? __getblk_gfp+0x3a/0x80 severity=3Dwarnin=
g
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa013c61a>] ? ext4_read_block_bitmap+0x3a/0x60 [ext4] =
severity=3Dwarning
kernel: [<ffffffffa0177139>] ext4_mb_mark_diskspace_used+0x79/0x320 [ex=
t4] severity=3Dwarning
kernel: [<ffffffffa017f341>] ext4_mb_new_blocks+0x331/0x510 [ext4] seve=
rity=3Dwarning
kernel: [<ffffffffa01722d7>] ext4_ext_map_blocks+0x877/0xae0 [ext4] sev=
erity=3Dwarning
kernel: [<ffffffff8116f9e1>] ? release_pages+0x1e1/0x250 severity=3Dwar=
ning
kernel: [<ffffffffa0143fc6>] ext4_map_blocks+0x176/0x4b0 [ext4] severit=
y=3Dwarning
kernel: [<ffffffffa01449c4>] ? mpage_prepare_extent_to_map+0x304/0x350 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa0144591>] mpage_map_one_extent+0x71/0x1a0 [ext4] sev=
erity=3Dwarning
kernel: [<ffffffffa01484ab>] mpage_map_and_submit_extent+0x4b/0x220 [ex=
t4] severity=3Dwarning
kernel: [<ffffffffa01746a4>] ? __ext4_journal_start_sb+0x74/0x100 [ext4=
] severity=3Dwarning
kernel: [<ffffffffa0148b4b>] ext4_writepages+0x4cb/0x630 [ext4] severit=
y=3Dwarning
kernel: [<ffffffff812c37e5>] ? blk_mq_flush_plug_list+0x135/0x150 sever=
ity=3Dwarning
kernel: [<ffffffff810a4073>] ? set_next_entity+0x93/0xa0 severity=3Dwar=
ning
kernel: [<ffffffff8116cb20>] do_writepages+0x20/0x40 severity=3Dwarning
kernel: [<ffffffff81205990>] __writeback_single_inode+0x40/0x220 severi=
ty=3Dwarning
kernel: [<ffffffff810ad72f>] ? wake_up_bit+0x2f/0x40 severity=3Dwarning
kernel: [<ffffffff81206c44>] writeback_sb_inodes+0x2b4/0x3c0 severity=3D=
warning
kernel: [<ffffffff811deef1>] ? put_super+0x31/0x40 severity=3Dwarning
kernel: [<ffffffff81206dee>] __writeback_inodes_wb+0x9e/0xd0 severity=3D=
warning
kernel: [<ffffffff81207063>] wb_writeback+0x243/0x2d0 severity=3Dwarnin=
g
kernel: [<ffffffff812071eb>] wb_do_writeback+0xfb/0x1e0 severity=3Dwarn=
ing
kernel: [<ffffffff81207340>] bdi_writeback_workfn+0x70/0x210 severity=3D=
warning
kernel: [<ffffffff810848c3>] process_one_work+0x143/0x4b0 severity=3Dwa=
rning
kernel: [<ffffffff81085a33>] worker_thread+0x123/0x520 severity=3Dwarni=
ng
kernel: [<ffffffff81614095>] ? __schedule+0x375/0x750 severity=3Dwarnin=
g
kernel: [<ffffffff81085910>] ? maybe_create_worker+0x130/0x130 severity=
=3Dwarning
kernel: [<ffffffff8108b31e>] kthread+0xce/0xf0 severity=3Dwarning
kernel: [<ffffffff8108b250>] ? kthread_freezable_should_stop+0x70/0x70 =
severity=3Dwarning
kernel: [<ffffffff81618c58>] ret_from_fork+0x58/0x90 severity=3Dwarning
kernel: [<ffffffff8108b250>] ? kthread_freezable_should_stop+0x70/0x70 =
severity=3Dwarning
kernel: postmaster      D 0000000000000009     0 14855  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff8822bf3877b8 0000000000000082 ffff8822bf387768 ffff8822bf38=
4010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff8825d71f5640 ffff88273e39=
1cc0 severity=3Dwarning
kernel: ffff8822bf387788 ffff88277f252c40 ffff8825d71f5640 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffff8120f780>] ? bh_lru_install+0x170/0x1a0 severity=3Dwa=
rning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa013c61a>] ? ext4_read_block_bitmap+0x3a/0x60 [ext4] =
severity=3Dwarning
kernel: [<ffffffffa01771ab>] ext4_mb_mark_diskspace_used+0xeb/0x320 [ex=
t4] severity=3Dwarning
kernel: [<ffffffffa017f341>] ext4_mb_new_blocks+0x331/0x510 [ext4] seve=
rity=3Dwarning
kernel: [<ffffffffa01722d7>] ext4_ext_map_blocks+0x877/0xae0 [ext4] sev=
erity=3Dwarning
kernel: [<ffffffff8116f9e1>] ? release_pages+0x1e1/0x250 severity=3Dwar=
ning
kernel: [<ffffffffa0143fc6>] ext4_map_blocks+0x176/0x4b0 [ext4] severit=
y=3Dwarning
kernel: [<ffffffffa01449c4>] ? mpage_prepare_extent_to_map+0x304/0x350 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa0144591>] mpage_map_one_extent+0x71/0x1a0 [ext4] sev=
erity=3Dwarning
kernel: [<ffffffffa01484ab>] mpage_map_and_submit_extent+0x4b/0x220 [ex=
t4] severity=3Dwarning
kernel: [<ffffffffa0148b4b>] ext4_writepages+0x4cb/0x630 [ext4] severit=
y=3Dwarning
kernel: [<ffffffff81193472>] ? handle_mm_fault+0xb2/0x1a0 severity=3Dwa=
rning
kernel: [<ffffffff8116cb20>] do_writepages+0x20/0x40 severity=3Dwarning
kernel: [<ffffffff81160a69>] __filemap_fdatawrite_range+0x59/0x60 sever=
ity=3Dwarning
kernel: [<ffffffff81160b1a>] filemap_write_and_wait_range+0xaa/0x100 se=
verity=3Dwarning
kernel: [<ffffffffa013eac3>] ext4_sync_file+0xf3/0x260 [ext4] severity=3D=
warning
kernel: [<ffffffff8120cf91>] vfs_fsync_range+0x21/0x30 severity=3Dwarni=
ng
kernel: [<ffffffff8120cfbc>] vfs_fsync+0x1c/0x20 severity=3Dwarning
kernel: [<ffffffff8120d1ad>] do_fsync+0x3d/0x70 severity=3Dwarning
kernel: [<ffffffff8120d210>] SyS_fsync+0x10/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000006     0 14856  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff88262affb8a8 0000000000000086 ffff88262affb858 ffff88262aff=
8010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88266aab1cc0 ffff88273e32=
64a0 severity=3Dwarning
kernel: ffff88225c97d6a0 ffff88277f192c40 ffff88266aab1cc0 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffffa011576e>] ? start_this_handle+0x28e/0x520 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa01406d4>] __ext4_new_inode+0x3a4/0x1110 [ext4] sever=
ity=3Dwarning
kernel: [<ffffffff8123c960>] ? __dquot_initialize+0x30/0x1e0 severity=3D=
warning
kernel: [<ffffffffa0150bbb>] ext4_create+0xab/0x170 [ext4] severity=3Dw=
arning
kernel: [<ffffffff811e9118>] vfs_create+0xd8/0x100 severity=3Dwarning
kernel: [<ffffffff811e982e>] lookup_open+0x13e/0x1d0 severity=3Dwarning
kernel: [<ffffffff811ed006>] do_last+0x416/0x820 severity=3Dwarning
kernel: [<ffffffff811ed4d4>] path_openat+0xc4/0x480 severity=3Dwarning
kernel: [<ffffffff811e77a9>] ? putname+0x29/0x40 severity=3Dwarning
kernel: [<ffffffff811ed9ca>] do_filp_open+0x4a/0xa0 severity=3Dwarning
kernel: [<ffffffff811fa64c>] ? __alloc_fd+0xac/0x150 severity=3Dwarning
kernel: [<ffffffff811db9ea>] do_sys_open+0x11a/0x230 severity=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff8110f3e6>] ? __audit_syscall_exit+0x246/0x2f0 severit=
y=3Dwarning
kernel: [<ffffffff811dbb3e>] SyS_open+0x1e/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000010     0 14857  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff880748203df8 0000000000000082 ffff8826a94e67c8 ffff88074820=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88266aab5640 ffff88273e3b=
8e60 severity=3Dwarning
kernel: ffff880748203e08 00000000023bc691 ffff882737c2e800 ffff88074820=
3e38 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffffa011db45>] jbd2_log_wait_commit+0xe5/0x170 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011de47>] jbd2_complete_transaction+0x57/0x90 [jbd2]=
 severity=3Dwarning
kernel: [<ffffffffa013ebcd>] ext4_sync_file+0x1fd/0x260 [ext4] severity=
=3Dwarning
kernel: [<ffffffff8120cf91>] vfs_fsync_range+0x21/0x30 severity=3Dwarni=
ng
kernel: [<ffffffff8120cfbc>] vfs_fsync+0x1c/0x20 severity=3Dwarning
kernel: [<ffffffff8120d1ad>] do_fsync+0x3d/0x70 severity=3Dwarning
kernel: [<ffffffff8120d210>] SyS_fsync+0x10/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000001     0 14859  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff8820d2017c38 0000000000000082 ffff882700000000 ffff8820d201=
4010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff882657c99cc0 ffff88273e32=
1cc0 severity=3Dwarning
kernel: ffff882657c99cc0 ffff8826feadc068 ffff882657c99cc0 ffff8826fead=
c06c severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616535>] __mutex_lock_slowpath+0x95/0x100 severity=3D=
warning
kernel: [<ffffffff816165c3>] mutex_lock+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811ecfec>] do_last+0x3fc/0x820 severity=3Dwarning
kernel: [<ffffffff811ed4d4>] path_openat+0xc4/0x480 severity=3Dwarning
kernel: [<ffffffff816165b6>] ? mutex_lock+0x16/0x40 severity=3Dwarning
kernel: [<ffffffff811ed9ca>] do_filp_open+0x4a/0xa0 severity=3Dwarning
kernel: [<ffffffff811fa64c>] ? __alloc_fd+0xac/0x150 severity=3Dwarning
kernel: [<ffffffff811db9ea>] do_sys_open+0x11a/0x230 severity=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff8110f3e6>] ? __audit_syscall_exit+0x246/0x2f0 severit=
y=3Dwarning
kernel: [<ffffffff811dbb3e>] SyS_open+0x1e/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 000000000000000e     0 14860  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff8820d22fbdf8 0000000000000086 ffff8826947ba4d8 ffff8820d22f=
8010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88266a93e4a0 ffff88273e39=
64a0 severity=3Dwarning
kernel: ffff8820d22fbe08 00000000023bc691 ffff882737c2e800 ffff8820d22f=
be38 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffffa011db45>] jbd2_log_wait_commit+0xe5/0x170 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011de47>] jbd2_complete_transaction+0x57/0x90 [jbd2]=
 severity=3Dwarning
kernel: [<ffffffffa013ebcd>] ext4_sync_file+0x1fd/0x260 [ext4] severity=
=3Dwarning
kernel: [<ffffffff8120cf91>] vfs_fsync_range+0x21/0x30 severity=3Dwarni=
ng
kernel: [<ffffffff8120cfbc>] vfs_fsync+0x1c/0x20 severity=3Dwarning
kernel: [<ffffffff8120d1ad>] do_fsync+0x3d/0x70 severity=3Dwarning
kernel: [<ffffffff8120d210>] SyS_fsync+0x10/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000007     0 14861  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff88041dfdfc38 0000000000000082 0000000000000000 ffff88041dfd=
c010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88266a939cc0 ffff88273e39=
0000 severity=3Dwarning
kernel: ffff88281ffd8d80 ffff8826feadc068 ffff88266a939cc0 ffff8826fead=
c06c severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616535>] __mutex_lock_slowpath+0x95/0x100 severity=3D=
warning
kernel: [<ffffffff816165c3>] mutex_lock+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811ecfec>] do_last+0x3fc/0x820 severity=3Dwarning
kernel: [<ffffffff811ed4d4>] path_openat+0xc4/0x480 severity=3Dwarning
kernel: [<ffffffff811ed9ca>] do_filp_open+0x4a/0xa0 severity=3Dwarning
kernel: [<ffffffff811fa64c>] ? __alloc_fd+0xac/0x150 severity=3Dwarning
kernel: [<ffffffff811db9ea>] do_sys_open+0x11a/0x230 severity=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811dbb3e>] SyS_open+0x1e/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 000000000000000a     0 14868  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff8821bd68fdf8 0000000000000086 ffff88269980e7c8 ffff8821bd68=
c010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88273dd68e60 ffff88273e39=
2b20 severity=3Dwarning
kernel: ffff8821bd68fe08 00000000023bc691 ffff882737c2e800 ffff8821bd68=
fe38 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffffa011db45>] jbd2_log_wait_commit+0xe5/0x170 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011de47>] jbd2_complete_transaction+0x57/0x90 [jbd2]=
 severity=3Dwarning
kernel: [<ffffffffa013ebcd>] ext4_sync_file+0x1fd/0x260 [ext4] severity=
=3Dwarning
kernel: [<ffffffff8120cf91>] vfs_fsync_range+0x21/0x30 severity=3Dwarni=
ng
kernel: [<ffffffff8120cfbc>] vfs_fsync+0x1c/0x20 severity=3Dwarning
kernel: [<ffffffff8120d1ad>] do_fsync+0x3d/0x70 severity=3Dwarning
kernel: [<ffffffff8120d210>] SyS_fsync+0x10/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000001     0 14869  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff880ed01d3df8 0000000000000082 ffff8826995ed418 ffff880ed01d=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88273dd6d640 ffff88273e32=
1cc0 severity=3Dwarning
kernel: ffff880ed01d3e08 00000000023bc691 ffff882737c2e800 ffff880ed01d=
3e38 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffffa011db45>] jbd2_log_wait_commit+0xe5/0x170 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011de47>] jbd2_complete_transaction+0x57/0x90 [jbd2]=
 severity=3Dwarning
kernel: [<ffffffffa013ebcd>] ext4_sync_file+0x1fd/0x260 [ext4] severity=
=3Dwarning
kernel: [<ffffffff8120cf91>] vfs_fsync_range+0x21/0x30 severity=3Dwarni=
ng
kernel: [<ffffffff8120cfbc>] vfs_fsync+0x1c/0x20 severity=3Dwarning
kernel: [<ffffffff8120d1ad>] do_fsync+0x3d/0x70 severity=3Dwarning
kernel: [<ffffffff8120d210>] SyS_fsync+0x10/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 000000000000000b     0 14905  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff8824d12979a8 0000000000000086 ffff8824d1297958 ffff8824d129=
4010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff8826317f3980 ffff88273e39=
3980 severity=3Dwarning
kernel: 000000000000008d ffff88277f2d2c40 ffff8826317f3980 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff81210a9a>] ? __getblk_gfp+0x3a/0x80 severity=3Dwarnin=
g
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa0146c08>] ext4_reserve_inode_write+0x78/0xa0 [ext4] =
severity=3Dwarning
kernel: [<ffffffffa0146c82>] ext4_mark_inode_dirty+0x52/0x240 [ext4] se=
verity=3Dwarning
kernel: [<ffffffffa0146eba>] ext4_dirty_inode+0x4a/0x70 [ext4] severity=
=3Dwarning
kernel: [<ffffffff8120644a>] __mark_inode_dirty+0x3a/0x290 severity=3Dw=
arning
kernel: [<ffffffff811f6f91>] update_time+0x81/0xc0 severity=3Dwarning
kernel: [<ffffffff811fcc63>] ? mntput+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811f7068>] file_update_time+0x98/0xe0 severity=3Dwarn=
ing
kernel: [<ffffffff811e6925>] ? terminate_walk+0x35/0x40 severity=3Dwarn=
ing
kernel: [<ffffffff811630b2>] __generic_file_write_iter+0x162/0x390 seve=
rity=3Dwarning
kernel: [<ffffffffa013deb9>] ext4_file_write_iter+0x119/0x430 [ext4] se=
verity=3Dwarning
kernel: [<ffffffff81170c3b>] ? invalidate_mapping_pages+0x8b/0x210 seve=
rity=3Dwarning
kernel: [<ffffffff811dbf22>] new_sync_write+0x92/0xd0 severity=3Dwarnin=
g
kernel: [<ffffffff811dc43e>] vfs_write+0xce/0x180 severity=3Dwarning
kernel: [<ffffffff811dca86>] SyS_write+0x56/0xd0 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000000     0 14910  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff882641f7bdf8 0000000000000086 ffff8802a90d7398 ffff882641f7=
8010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff8800db8c0000 ffffffff81c1=
b4c0 severity=3Dwarning
kernel: ffff882641f7be08 00000000023bc691 ffff882737c2e800 ffff882641f7=
be38 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffffa011db45>] jbd2_log_wait_commit+0xe5/0x170 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff810ad240>] ? woken_wake_function+0x20/0x20 severity=3D=
warning
kernel: [<ffffffffa011de47>] jbd2_complete_transaction+0x57/0x90 [jbd2]=
 severity=3Dwarning
kernel: [<ffffffffa013ebcd>] ext4_sync_file+0x1fd/0x260 [ext4] severity=
=3Dwarning
kernel: [<ffffffff8120cf91>] vfs_fsync_range+0x21/0x30 severity=3Dwarni=
ng
kernel: [<ffffffff8120cfbc>] vfs_fsync+0x1c/0x20 severity=3Dwarning
kernel: [<ffffffff8120d1ad>] do_fsync+0x3d/0x70 severity=3Dwarning
kernel: [<ffffffff8120d210>] SyS_fsync+0x10/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: smokerd plugin  D 0000000000000009     0 15001  29979 0x0000008=
4 severity=3Dinfo
kernel: ffff88264c437b48 0000000000000082 ffff88264c437af8 ffff88264c43=
4010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff8825d71f1cc0 ffff88273e39=
1cc0 severity=3Dwarning
kernel: ffff8803362adc98 ffff88277f252c40 ffff8825d71f1cc0 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffffa0116cbf>] ? jbd2_journal_dirty_metadata+0xff/0x250 [=
jbd2] severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa014cb7f>] ext4_orphan_add+0xbf/0x2e0 [ext4] severity=
=3Dwarning
kernel: [<ffffffffa0146cb8>] ? ext4_mark_inode_dirty+0x88/0x240 [ext4] =
severity=3Dwarning
kernel: [<ffffffffa0151d3a>] ext4_unlink+0x2aa/0x2d0 [ext4] severity=3D=
warning
kernel: [<ffffffff811e8bc3>] vfs_unlink+0xd3/0x140 severity=3Dwarning
kernel: [<ffffffff811ebd06>] do_unlinkat+0x2d6/0x320 severity=3Dwarning
kernel: [<ffffffff81021c8c>] ? do_audit_syscall_entry+0x6c/0x70 severit=
y=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811ebd66>] SyS_unlink+0x16/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000007     0 15029  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff88206081f8a8 0000000000000086 ffff88206081f858 ffff88206081=
c010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff8825ab41ab20 ffff88273e39=
0000 severity=3Dwarning
kernel: ffff88277ec03700 ffff88277f1d2c40 ffff8825ab41ab20 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffffa011576e>] ? start_this_handle+0x28e/0x520 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa0140ada>] __ext4_new_inode+0x7aa/0x1110 [ext4] sever=
ity=3Dwarning
kernel: [<ffffffff8123c960>] ? __dquot_initialize+0x30/0x1e0 severity=3D=
warning
kernel: [<ffffffff8115fece>] ? find_get_entry+0x1e/0xa0 severity=3Dwarn=
ing
kernel: [<ffffffffa0150bbb>] ext4_create+0xab/0x170 [ext4] severity=3Dw=
arning
kernel: [<ffffffff811e9118>] vfs_create+0xd8/0x100 severity=3Dwarning
kernel: [<ffffffff811e982e>] lookup_open+0x13e/0x1d0 severity=3Dwarning
kernel: [<ffffffff811ed006>] do_last+0x416/0x820 severity=3Dwarning
kernel: [<ffffffff811ed4d4>] path_openat+0xc4/0x480 severity=3Dwarning
kernel: [<ffffffff811ed9ca>] do_filp_open+0x4a/0xa0 severity=3Dwarning
kernel: [<ffffffff811e77a9>] ? putname+0x29/0x40 severity=3Dwarning
kernel: [<ffffffff811fa64c>] ? __alloc_fd+0xac/0x150 severity=3Dwarning
kernel: [<ffffffff811db9ea>] do_sys_open+0x11a/0x230 severity=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811dbb3e>] SyS_open+0x1e/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000000     0 15175  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff88057229bb48 0000000000000086 ffff88057229baf8 ffff88057229=
8010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88245105c7e0 ffffffff81c1=
b4c0 severity=3Dwarning
kernel: ffff88057229bb38 ffff88277f012c40 ffff88245105c7e0 ffffffff8161=
4e10 severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161469c>] io_schedule+0x8c/0xd0 severity=3Dwarning
kernel: [<ffffffff81614e3c>] bit_wait_io+0x2c/0x50 severity=3Dwarning
kernel: [<ffffffff81614bc5>] __wait_on_bit+0x65/0x90 severity=3Dwarning
kernel: [<ffffffffa0116cbf>] ? jbd2_journal_dirty_metadata+0xff/0x250 [=
jbd2] severity=3Dwarning
kernel: [<ffffffff81614e10>] ? bit_wait_timeout+0x70/0x70 severity=3Dwa=
rning
kernel: [<ffffffff81614d18>] out_of_line_wait_on_bit+0x78/0x90 severity=
=3Dwarning
kernel: [<ffffffff810ad2c0>] ? wake_atomic_t_function+0x40/0x40 severit=
y=3Dwarning
kernel: [<ffffffffa011676d>] do_get_write_access+0x1fd/0x4e0 [jbd2] sev=
erity=3Dwarning
kernel: [<ffffffffa0116ba1>] jbd2_journal_get_write_access+0x31/0x50 [j=
bd2] severity=3Dwarning
kernel: [<ffffffffa0174403>] __ext4_journal_get_write_access+0x43/0x90 =
[ext4] severity=3Dwarning
kernel: [<ffffffffa014cb7f>] ext4_orphan_add+0xbf/0x2e0 [ext4] severity=
=3Dwarning
kernel: [<ffffffffa0146cb8>] ? ext4_mark_inode_dirty+0x88/0x240 [ext4] =
severity=3Dwarning
kernel: [<ffffffffa0151d3a>] ext4_unlink+0x2aa/0x2d0 [ext4] severity=3D=
warning
kernel: [<ffffffff811e8bc3>] vfs_unlink+0xd3/0x140 severity=3Dwarning
kernel: [<ffffffff811ebd06>] do_unlinkat+0x2d6/0x320 severity=3Dwarning
kernel: [<ffffffff81021c8c>] ? do_audit_syscall_entry+0x6c/0x70 severit=
y=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811ebd66>] SyS_unlink+0x16/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000003     0 15823  25395 0x0000008=
4 severity=3Dinfo
kernel: ffff880424173db8 0000000000000086 ffff880424173de8 ffff88042417=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff882254f49cc0 ffff88273e32=
3980 severity=3Dwarning
kernel: ffff880424173dd8 ffff8826e845acb8 ffff882254f49cc0 ffff8826e845=
acbc severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616535>] __mutex_lock_slowpath+0x95/0x100 severity=3D=
warning
kernel: [<ffffffff816165c3>] mutex_lock+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811ebb58>] do_unlinkat+0x128/0x320 severity=3Dwarning
kernel: [<ffffffff81021c8c>] ? do_audit_syscall_entry+0x6c/0x70 severit=
y=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811ebd66>] SyS_unlink+0x16/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000007     0 15855  25395 0x0000008=
0 severity=3Dinfo
kernel: ffff88266a8c3db8 0000000000000086 ffff88266a8c3de8 ffff88266a8c=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff8820f680c7e0 ffff88273e39=
0000 severity=3Dwarning
kernel: ffff88266a8c3dd8 ffff8826e845acb8 ffff8820f680c7e0 ffff8826e845=
acbc severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616535>] __mutex_lock_slowpath+0x95/0x100 severity=3D=
warning
kernel: [<ffffffff816165c3>] mutex_lock+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811ebb58>] do_unlinkat+0x128/0x320 severity=3Dwarning
kernel: [<ffffffff81021c8c>] ? do_audit_syscall_entry+0x6c/0x70 severit=
y=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811ebd66>] SyS_unlink+0x16/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000006     0 16102  25395 0x0000008=
4 severity=3Dinfo
kernel: ffff8820d23e7db8 0000000000000086 ffff8820d23e7de8 ffff8820d23e=
4010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff881b4d6147e0 ffff88273e32=
64a0 severity=3Dwarning
kernel: ffff8820d23e7dd8 ffff8826e845acb8 ffff881b4d6147e0 ffff8826e845=
acbc severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616535>] __mutex_lock_slowpath+0x95/0x100 severity=3D=
warning
kernel: [<ffffffff816165c3>] mutex_lock+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811ebb58>] do_unlinkat+0x128/0x320 severity=3Dwarning
kernel: [<ffffffff81021c8c>] ? do_audit_syscall_entry+0x6c/0x70 severit=
y=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811ebd66>] SyS_unlink+0x16/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 000000000000000c     0 16227  25395 0x0000008=
4 severity=3Dinfo
kernel: ffff881b4d8efdb8 0000000000000082 ffff881b4d8efde8 ffff881b4d8e=
c010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88220a8fe4a0 ffff88273e39=
47e0 severity=3Dwarning
kernel: ffff881b4d8efdd8 ffff8826e845acb8 ffff88220a8fe4a0 ffff8826e845=
acbc severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616535>] __mutex_lock_slowpath+0x95/0x100 severity=3D=
warning
kernel: [<ffffffff816165c3>] mutex_lock+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811ebb58>] do_unlinkat+0x128/0x320 severity=3Dwarning
kernel: [<ffffffff81021c8c>] ? do_audit_syscall_entry+0x6c/0x70 severit=
y=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811ebd66>] SyS_unlink+0x16/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 000000000000000d     0 16658  25395 0x0000008=
4 severity=3Dinfo
kernel: ffff88251e143db8 0000000000000082 ffff88251e143de8 ffff88251e14=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88265b268000 ffff88273e39=
5640 severity=3Dwarning
kernel: ffff88251e143dd8 ffff8826e845acb8 ffff88265b268000 ffff8826e845=
acbc severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616535>] __mutex_lock_slowpath+0x95/0x100 severity=3D=
warning
kernel: [<ffffffff816165c3>] mutex_lock+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811ebb58>] do_unlinkat+0x128/0x320 severity=3Dwarning
kernel: [<ffffffff81021c8c>] ? do_audit_syscall_entry+0x6c/0x70 severit=
y=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811ebd66>] SyS_unlink+0x16/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 0000000000000003     0 24648  25395 0x0000008=
4 severity=3Dinfo
kernel: ffff88266abb3db8 0000000000000086 ffff88266abb3de8 ffff88266abb=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff882254f4ab20 ffff88273e32=
3980 severity=3Dwarning
kernel: ffff88266abb3dd8 ffff8826e845acb8 ffff882254f4ab20 ffff8826e845=
acbc severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616535>] __mutex_lock_slowpath+0x95/0x100 severity=3D=
warning
kernel: [<ffffffff816165c3>] mutex_lock+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811ebb58>] do_unlinkat+0x128/0x320 severity=3Dwarning
kernel: [<ffffffff81021c8c>] ? do_audit_syscall_entry+0x6c/0x70 severit=
y=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811ebd66>] SyS_unlink+0x16/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: bash            D 0000000000000004     0 25435  25434 0x0000008=
4 severity=3Dinfo
kernel: ffff88265b2c3e28 0000000000000086 ffff882737404020 ffff88265b2c=
0010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff88217e4764a0 ffff88273e32=
47e0 severity=3Dwarning
kernel: 0000000000000003 ffff88270bfe3c78 ffff88217e4764a0 ffff88270bfe=
3c7c severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616694>] __mutex_lock_killable_slowpath+0xb4/0x140 =
severity=3Dwarning
kernel: [<ffffffff81616762>] mutex_lock_killable+0x42/0x50 severity=3Dw=
arning
kernel: [<ffffffff811efc77>] iterate_dir+0x77/0x140 severity=3Dwarning
kernel: [<ffffffff8110e0cc>] ? __audit_syscall_entry+0xac/0x110 severit=
y=3Dwarning
kernel: [<ffffffff811efef1>] SyS_getdents+0xb1/0x100 severity=3Dwarning
kernel: [<ffffffff811effd0>] ? SyS_old_readdir+0x90/0x90 severity=3Dwar=
ning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning
kernel: postmaster      D 000000000000000b     0 27811  25395 0x0000008=
4 severity=3Dinfo
kernel: ffff8822bf0e7db8 0000000000000086 ffff8822bf0e7de8 ffff8822bf0e=
4010 severity=3Dwarning
kernel: 0000000000012c40 0000000000012c40 ffff882739808000 ffff88273e39=
3980 severity=3Dwarning
kernel: ffff8822bf0e7dd8 ffff8826e845acb8 ffff882739808000 ffff8826e845=
acbc severity=3Dwarning
kernel: Call Trace: severity=3Dwarning
kernel: [<ffffffff816145c9>] schedule+0x29/0x70 severity=3Dwarning
kernel: [<ffffffff8161472e>] schedule_preempt_disabled+0xe/0x10 severit=
y=3Dwarning
kernel: [<ffffffff81616535>] __mutex_lock_slowpath+0x95/0x100 severity=3D=
warning
kernel: [<ffffffff816165c3>] mutex_lock+0x23/0x40 severity=3Dwarning
kernel: [<ffffffff811ebb58>] do_unlinkat+0x128/0x320 severity=3Dwarning
kernel: [<ffffffff81021c8c>] ? do_audit_syscall_entry+0x6c/0x70 severit=
y=3Dwarning
kernel: [<ffffffff81021dc3>] ? syscall_trace_enter_phase1+0x133/0x150 s=
everity=3Dwarning
kernel: [<ffffffff811ebd66>] SyS_unlink+0x16/0x20 severity=3Dwarning
kernel: [<ffffffff81618d09>] system_call_fastpath+0x12/0x17 severity=3D=
warning

--=20
Nikola
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
