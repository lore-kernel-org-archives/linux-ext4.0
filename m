From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: All processes accessing etx4 partition stuck in 'D' state
Date: Tue, 10 Feb 2009 14:02:03 -0600
Message-ID: <4991DD3B.9020909@redhat.com>
References: <87ljt7zt9q.fsf@newton.gmurray.org.uk>	<20090119124305.GB7598@mit.edu> <87skmmoyk1.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Graham Murray <graham@gmurray.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46877 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbZBJUCO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2009 15:02:14 -0500
In-Reply-To: <87skmmoyk1.fsf@newton.gmurray.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Graham Murray wrote:
> Theodore Tso <tytso@mit.edu> writes:
> 
>> On Mon, Jan 19, 2009 at 06:47:45AM +0000, Graham Murray wrote:
>>> I do not know if this is ext4 related or not, so my apologies if it is
>>> not.
>>>
>>> I am running the latest linus 2.6.29-rc2 git kernel together with the
>>> master branch of the ext4 git tree announced here a couple of days ago.
>>>
>>> Yesterday evening, all processes accessing /home which is formatted as
>>> ext4 (created as ext4 under 2.6.26 with the ext4 patches applied, not
>>> converted from ext3) were stuck in 'D' state and top showed both cores
>>> of the core2 CPU in 100% Waiting state. Everything not accessing /home
>>> was responsive. To eliminate a physical problem I ran a SMART self-test
>>> on the drive containing /home and it passed with no errors. / is also
>>> etx4, but was converted from ext3. There were no kernel messages, just
>>> the hung processes. The system would not reboot normally (because of the
>>> processes in 'D' state), but following sysrq sync, mount r/o and reboot,
>>> the filesystem showed as clean when restarted. To be sure, the first
>>> thing I did was to unmount it and manually ran fsck -f and that did not
>>> report any problems. 
>> If this happens again, could you use sysrq-l and capture resulting the
>> stack backtraces?  That would help determine what parts of the kernel
>> are responsible.
> 
> It has happened again for the third time, and this time I was able to
> use sysrq. In all three cases, the first process to hang was emacs when
> exiting a group in gnus and top showed it in WCHAN page_sync.
> 
> Now using:- Linux newton 2.6.29-rc4-00026-gf06da26 #1 SMP Mon Feb 9 21:17:53 GMT 2009 i686 Intel(R) Core(TM)2 CPU 6700 @ 2.66GHz GenuineIntel GNU/Linux

this too looks similar to
http://bugzilla.kernel.org/show_bug.cgi?id=12579, which I keep trying to
find time to really dig into....

-Eric

> Sysrq-l does not show much
> Feb 10 17:13:01 newton SysRq : Show backtrace of all active CPUs
> Feb 10 17:13:01 newton CPU0:
> Feb 10 17:13:01 newton
> Feb 10 17:13:01 newton Pid: 0, comm: swapper Not tainted (2.6.29-rc4-00026-gf06da26 #1) P5W DH Deluxe
> Feb 10 17:13:01 newton EIP: 0060:[<c0109492>] EFLAGS: 00000246 CPU: 0
> Feb 10 17:13:01 newton EIP is at mwait_idle+0x32/0x40
> Feb 10 17:13:01 newton EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
> Feb 10 17:13:01 newton ESI: c0741200 EDI: c06df814 EBP: c06e7fb0 ESP: c06e7fb0
> Feb 10 17:13:01 newton DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Feb 10 17:13:01 newton CR0: 8005003b CR2: 0a1d2000 CR3: 357b6000 CR4: 000006f0
> Feb 10 17:13:01 newton DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> Feb 10 17:13:01 newton DR6: ffff0ff0 DR7: 00000400
> Feb 10 17:13:01 newton Call Trace:
> Feb 10 17:13:01 newton [<c0101e98>] cpu_idle+0x68/0xc0
> Feb 10 17:13:01 newton [<c050d52e>] rest_init+0x4e/0x60
> 
> But Sysrq-w shows
> Feb 10 17:13:28 newton [<c02877cf>] ? security_file_permission+0xf/0x20
> Feb 10 17:13:28 newton [<c01a2bf8>] ? rw_verify_area+0x48/0xc0
> Feb 10 17:13:28 newton [<c01a310c>] vfs_write+0x9c/0x160
> Feb 10 17:13:28 newton [<c01a2990>] ? do_sync_write+0x0/0x110
> Feb 10 17:13:28 newton [<c01a328d>] sys_write+0x3d/0x70
> Feb 10 17:13:28 newton [<c01033c1>] sysenter_do_call+0x12/0x21
> Feb 10 17:13:28 newton bash          D 00000000     0  6734      1
> Feb 10 17:13:28 newton ebfb3dbc 00000082 001200d2 00000000 80000000 00000001 bed82067 ced0c7f3
> Feb 10 17:13:28 newton 00003399 80000000 09f2a060 ea8f8f78 ebfde000 c0741300 e71c5630 e71c58a4
> Feb 10 17:13:28 newton c2816300 00000000 80000000 ced1303c 00003399 80000000 e71c58a4 00100073
> Feb 10 17:13:28 newton Call Trace:
> Feb 10 17:13:28 newton [<c05216f8>] __mutex_lock_slowpath+0xb8/0x250
> Feb 10 17:13:28 newton [<c05218a2>] mutex_lock+0x12/0x20
> Feb 10 17:13:28 newton [<c01ac1d7>] do_lookup+0xd7/0x1d0
> Feb 10 17:13:28 newton [<c01ac536>] __link_path_walk+0x266/0xd80
> Feb 10 17:13:28 newton [<c0524db5>] ? do_page_fault+0x235/0x950
> Feb 10 17:13:28 newton [<c01ad204>] path_walk+0x54/0xc0
> Feb 10 17:13:28 newton [<c01ad3c9>] do_path_lookup+0xb9/0x1a0
> Feb 10 17:13:28 newton [<c01ae00a>] user_path_at+0x4a/0x80
> Feb 10 17:13:28 newton [<c0109f4c>] ? restore_i387_xstate+0xfc/0x1f0
> Feb 10 17:13:28 newton [<c01af6c8>] ? vfs_ioctl+0x28/0x90
> Feb 10 17:13:28 newton [<c01a68d1>] vfs_stat_fd+0x21/0x50
> Feb 10 17:13:28 newton [<c01a69e1>] vfs_stat+0x11/0x20
> Feb 10 17:13:28 newton [<c01a6a04>] sys_stat64+0x14/0x30
> Feb 10 17:13:28 newton [<c0102875>] ? sys_sigreturn+0xc5/0xe0
> Feb 10 17:13:28 newton [<c01033c1>] sysenter_do_call+0x12/0x21
> Feb 10 17:13:28 newton emacs         D 00000000     0  6766   6751
> Feb 10 17:13:28 newton e57abd44 00000082 c281633c 00000000 c281201c 00000000 00000001 7740f708
> Feb 10 17:13:28 newton 00003372 f6fc0034 e57abd08 c0123657 e57abd20 c0741300 e71c24f0 e71c2764
> Feb 10 17:13:28 newton c2816300 00000000 00d6a406 0000001c e57abdf8 e4c25d28 e71c2764 00000000
> Feb 10 17:13:28 newton Call Trace:
> Feb 10 17:13:28 newton [<c0123657>] ? set_next_entity+0x97/0x180
> Feb 10 17:13:28 newton [<c0149b48>] ? ktime_get_ts+0x48/0x50
> Feb 10 17:13:28 newton [<c0520775>] io_schedule+0x55/0x90
> Feb 10 17:13:28 newton [<c017999d>] sync_page+0x2d/0x60
> Feb 10 17:13:28 newton [<c0520bea>] __wait_on_bit_lock+0x4a/0xa0
> Feb 10 17:13:28 newton [<c0179970>] ? sync_page+0x0/0x60
> Feb 10 17:13:28 newton [<c0179947>] __lock_page+0x87/0xa0
> Feb 10 17:13:28 newton [<c0146410>] ? wake_bit_function+0x0/0x60
> Feb 10 17:13:28 newton [<c01801b6>] write_cache_pages+0x196/0x370
> Feb 10 17:13:28 newton [<c021c290>] ? __mpage_da_writepage+0x0/0x150
> Feb 10 17:13:28 newton [<c021bf4e>] ext4_da_writepages+0x1fe/0x470
> Feb 10 17:13:28 newton [<c0520f68>] ? mutex_unlock+0x8/0x10
> Feb 10 17:13:28 newton [<c017bbb4>] ? generic_file_aio_write+0x64/0xd0
> Feb 10 17:13:28 newton [<c01a2a61>] ? do_sync_write+0xd1/0x110
> Feb 10 17:13:28 newton [<c021df70>] ? ext4_da_get_block_write+0x0/0x210
> Feb 10 17:13:28 newton [<c021bd50>] ? ext4_da_writepages+0x0/0x470
> Feb 10 17:13:28 newton [<c01803ee>] do_writepages+0x2e/0x50
> Feb 10 17:13:28 newton [<c017a491>] __filemap_fdatawrite_range+0x61/0x70
> Feb 10 17:13:28 newton [<c017aa86>] filemap_fdatawrite+0x26/0x30
> Feb 10 17:13:28 newton [<c01c127f>] vfs_fsync+0x4f/0xd0
> Feb 10 17:13:28 newton [<c01c132d>] do_fsync+0x2d/0x50
> Feb 10 17:13:28 newton [<c01c137d>] sys_fsync+0xd/0x10
> Feb 10 17:13:28 newton [<c01033c1>] sysenter_do_call+0x12/0x21
> Feb 10 17:13:28 newton procmail      D bf93d025     0 11337  11336
> Feb 10 17:13:28 newton f5387df4 00200082 f1da6910 bf93d025 c149978c b7f59238 eeebb790 3f0bfa17
> Feb 10 17:13:28 newton 00003388 c1499780 c27f27a0 00000000 f1d68070 c0741300 eee40000 eee40274
> Feb 10 17:13:28 newton c2816300 00000000 00d6ff4f c01b239a 00000000 e6411d48 eee40274 c01b378b
> Feb 10 17:13:28 newton Call Trace:
> Feb 10 17:13:28 newton [<c01b239a>] ? d_rehash+0x2a/0x40
> Feb 10 17:13:28 newton [<c01b378b>] ? d_splice_alias+0x3b/0xd0
> Feb 10 17:13:28 newton [<c014661a>] ? prepare_to_wait+0x3a/0x70
> Feb 10 17:13:28 newton [<c0244d3d>] start_this_handle+0x1fd/0x4f0
> Feb 10 17:13:28 newton [<c01b8a8d>] ? mntput_no_expire+0x1d/0x130
> Feb 10 17:13:28 newton [<c02a97af>] ? _atomic_dec_and_lock+0x4f/0x70
> Feb 10 17:13:28 newton [<c01463d0>] ? autoremove_wake_function+0x0/0x40
> Feb 10 17:13:28 newton [<c02451e3>] jbd2_journal_start+0x93/0xd0
> Feb 10 17:13:28 newton [<c02268d5>] ext4_journal_start_sb+0x55/0x80
> Feb 10 17:13:28 newton [<c0223366>] ext4_create+0x76/0x110
> Feb 10 17:13:28 newton [<c01abef4>] vfs_create+0x94/0xb0
> Feb 10 17:13:28 newton [<c01ae8b1>] do_filp_open+0x731/0x7e0
> Feb 10 17:13:28 newton [<c01a0ed9>] do_sys_open+0x59/0xf0
> Feb 10 17:13:28 newton [<c01347d7>] ? sys_wait4+0x87/0xd0
> Feb 10 17:13:28 newton [<c01a0fd9>] sys_open+0x29/0x40
> Feb 10 17:13:28 newton [<c01033c1>] sysenter_do_call+0x12/0x21
> Feb 10 17:13:28 newton [<c0520000>] ? schedule+0x2c0/0x9e0
> Feb 10 17:13:28 newton procmail      D e70d7f44     0 11339  11338
> Feb 10 17:13:28 newton e4c4ddbc 00200082 f7009eec e70d7f44 00000000 00000000 00000000 7793278a
> Feb 10 17:13:28 newton 00003388 c0179ac1 c16aaa8c e4c4ddc4 c018e717 c0741300 eee46ed0 eee47144
> Feb 10 17:13:28 newton c2816300 00000000 00d70055 b7eed238 e4c21370 e5767880 eee47144 c16aaa80
> Feb 10 17:13:28 newton Call Trace:
> Feb 10 17:13:28 newton [<c0179ac1>] ? unlock_page+0x41/0x50
> Feb 10 17:13:28 newton [<c018e717>] ? __do_fault+0x187/0x3f0
> Feb 10 17:13:28 newton [<c05216f8>] __mutex_lock_slowpath+0xb8/0x250
> Feb 10 17:13:28 newton [<c018f0bb>] ? handle_mm_fault+0x13b/0x780
> Feb 10 17:13:28 newton [<c05218a2>] mutex_lock+0x12/0x20
> Feb 10 17:13:28 newton [<c01ac1d7>] do_lookup+0xd7/0x1d0
> Feb 10 17:13:28 newton [<c01ac536>] __link_path_walk+0x266/0xd80
> Feb 10 17:13:28 newton [<c0524db5>] ? do_page_fault+0x235/0x950
> Feb 10 17:13:28 newton [<c013f975>] ? in_group_p+0x25/0x30
> Feb 10 17:13:28 newton [<c01a3cff>] ? file_move+0x1f/0x50
> Feb 10 17:13:28 newton [<c01ad204>] path_walk+0x54/0xc0
> Feb 10 17:13:28 newton [<c01ad3c9>] do_path_lookup+0xb9/0x1a0
> Feb 10 17:13:28 newton [<c01ae00a>] user_path_at+0x4a/0x80
> Feb 10 17:13:28 newton [<c0146688>] ? remove_wait_queue+0x38/0x50
> Feb 10 17:13:28 newton [<c01a67ce>] vfs_lstat_fd+0x1e/0x50
> Feb 10 17:13:28 newton [<c01a6871>] vfs_lstat+0x11/0x20
> Feb 10 17:13:28 newton [<c01a6894>] sys_lstat64+0x14/0x30
> Feb 10 17:13:28 newton [<c01347d7>] ? sys_wait4+0x87/0xd0
> Feb 10 17:13:28 newton [<c01360a9>] ? sys_time+0x19/0x50
> Feb 10 17:13:28 newton [<c01033c1>] sysenter_do_call+0x12/0x21
> Feb 10 17:13:28 newton [<c0520000>] ? schedule+0x2c0/0x9e0
> Feb 10 17:13:28 newton sshd          D c0179edd     0 11344   6175
> Feb 10 17:13:28 newton e70e8d98 00000082 e70e8d64 c0179edd 00000003 00000044 c01b8a8d bd47338f
> Feb 10 17:13:28 newton 0000338e ebfc43c8 eabd8300 f7009eec eabd8344 c0741300 eee449e0 eee44c54
> Feb 10 17:13:28 newton c2816300 00000000 00d71ab9 c155246c e70e8dc4 c018e717 eee44c54 ea923268
> Feb 10 17:13:28 newton Call Trace:
> Feb 10 17:13:28 newton [<c0179edd>] ? filemap_fault+0x12d/0x3d0
> Feb 10 17:13:28 newton [<c01b8a8d>] ? mntput_no_expire+0x1d/0x130
> Feb 10 17:13:28 newton [<c018e717>] ? __do_fault+0x187/0x3f0
> Feb 10 17:13:28 newton [<c05216f8>] __mutex_lock_slowpath+0xb8/0x250
> Feb 10 17:13:28 newton [<c05218a2>] mutex_lock+0x12/0x20
> Feb 10 17:13:28 newton [<c01ac1d7>] do_lookup+0xd7/0x1d0
> Feb 10 17:13:28 newton [<c01ac424>] __link_path_walk+0x154/0xd80
> Feb 10 17:13:28 newton [<c01ad204>] path_walk+0x54/0xc0
> Feb 10 17:13:28 newton [<c01ad3c9>] do_path_lookup+0xb9/0x1a0
> Feb 10 17:13:28 newton [<c01ad55b>] path_lookup_open+0x4b/0xb0
> Feb 10 17:13:28 newton [<c01ae231>] do_filp_open+0xb1/0x7e0
> Feb 10 17:13:28 newton [<c0120248>] ? sched_slice+0x58/0x90
> Feb 10 17:13:28 newton [<c01a0ed9>] do_sys_open+0x59/0xf0
> Feb 10 17:13:28 newton [<c014c1ee>] ? commit_creds+0xce/0x150
> Feb 10 17:13:28 newton [<c01a0fd9>] sys_open+0x29/0x40
> Feb 10 17:13:28 newton [<c01033c1>] sysenter_do_call+0x12/0x21
> Feb 10 17:13:28 newton [<c0520000>] ? schedule+0x2c0/0x9e0
> Feb 10 17:13:28 newton sshd          D c06c6b40     0 11355   6175
> Feb 10 17:13:28 newton e5795d98 00000086 c073e220 c06c6b40 00000002 00000000 00000000 da8d6e19
> Feb 10 17:13:28 newton 0000339a 00000246 00000001 c06c6c80 00000000 c0741300 e71c6ed0 e71c7144
> Feb 10 17:13:28 newton c2816300 00000000 00d74d56 e71c6ed0 00000010 e5795dc4 e71c7144 c06c73c0
> Feb 10 17:13:28 newton Call Trace:
> Feb 10 17:13:28 newton [<c05216f8>] __mutex_lock_slowpath+0xb8/0x250
> Feb 10 17:13:28 newton [<c05218a2>] mutex_lock+0x12/0x20
> Feb 10 17:13:28 newton [<c01ac1d7>] do_lookup+0xd7/0x1d0
> Feb 10 17:13:28 newton [<c01ac424>] __link_path_walk+0x154/0xd80
> Feb 10 17:13:28 newton [<c01ad204>] path_walk+0x54/0xc0
> Feb 10 17:13:28 newton [<c01ad3c9>] do_path_lookup+0xb9/0x1a0
> Feb 10 17:13:28 newton [<c01ad55b>] path_lookup_open+0x4b/0xb0
> Feb 10 17:13:28 newton [<c01ae231>] do_filp_open+0xb1/0x7e0
> Feb 10 17:13:28 newton [<c0120248>] ? sched_slice+0x58/0x90
> Feb 10 17:13:28 newton [<c01a0ed9>] do_sys_open+0x59/0xf0
> Feb 10 17:13:28 newton [<c014c1ee>] ? commit_creds+0xce/0x150
> Feb 10 17:13:28 newton [<c01a0fd9>] sys_open+0x29/0x40
> Feb 10 17:13:28 newton [<c01033c1>] sysenter_do_call+0x12/0x21
> Feb 10 17:13:28 newton sshd          D c06c6b40     0 11370   6175
> Feb 10 17:13:28 newton ea944d98 00000086 c073e220 c06c6b40 00000002 00000000 00000000 0673d3f6
> Feb 10 17:13:28 newton 000033c0 00000246 00000001 c06c6c80 e4c63000 c0741300 e71c18a0 e71c1b14
> Feb 10 17:13:28 newton c281f300 00000001 c06c6b40 067677ce 000033c0 ea944dc4 e71c1b14 c06c73c0
> Feb 10 17:13:28 newton Call Trace:
> Feb 10 17:13:28 newton [<c05216f8>] __mutex_lock_slowpath+0xb8/0x250
> Feb 10 17:13:28 newton [<c05218a2>] mutex_lock+0x12/0x20
> Feb 10 17:13:28 newton [<c01ac1d7>] do_lookup+0xd7/0x1d0
> Feb 10 17:13:28 newton [<c01ac424>] __link_path_walk+0x154/0xd80
> Feb 10 17:13:28 newton [<c01ad204>] path_walk+0x54/0xc0
> Feb 10 17:13:28 newton [<c01ad3c9>] do_path_lookup+0xb9/0x1a0
> Feb 10 17:13:28 newton [<c01ad55b>] path_lookup_open+0x4b/0xb0
> Feb 10 17:13:28 newton [<c01ae231>] do_filp_open+0xb1/0x7e0
> Feb 10 17:13:28 newton [<c0120248>] ? sched_slice+0x58/0x90
> Feb 10 17:13:28 newton [<c01a0ed9>] do_sys_open+0x59/0xf0
> Feb 10 17:13:28 newton [<c014c1ee>] ? commit_creds+0xce/0x150
> Feb 10 17:13:28 newton [<c01a0fd9>] sys_open+0x29/0x40
> Feb 10 17:13:28 newton [<c01033c1>] sysenter_do_call+0x12/0x21
> Feb 10 17:13:28 newton procmail      D eaba8bc4     0 11408  11407
> Feb 10 17:13:28 newton f3160dbc 00200082 f7009eec eaba8bc4 00000000 00000000 00000000 1359ca9e
> Feb 10 17:13:28 newton 000033f4 c0179ac1 c149822c f3160dc4 c018e717 c0741300 ea820c50 ea820ec4
> Feb 10 17:13:28 newton c281f300 00000001 00d8c333 b7fb1238 eaa28738 e5766540 ea820ec4 c1498220
> Feb 10 17:13:28 newton Call Trace:
> Feb 10 17:13:28 newton [<c0179ac1>] ? unlock_page+0x41/0x50
> Feb 10 17:13:28 newton [<c018e717>] ? __do_fault+0x187/0x3f0
> Feb 10 17:13:28 newton [<c05216f8>] __mutex_lock_slowpath+0xb8/0x250
> Feb 10 17:13:28 newton [<c018f0bb>] ? handle_mm_fault+0x13b/0x780
> Feb 10 17:13:28 newton [<c05218a2>] mutex_lock+0x12/0x20
> Feb 10 17:13:28 newton [<c01ac1d7>] do_lookup+0xd7/0x1d0
> Feb 10 17:13:28 newton [<c01ac536>] __link_path_walk+0x266/0xd80
> Feb 10 17:13:28 newton [<c0524db5>] ? do_page_fault+0x235/0x950
> Feb 10 17:13:28 newton [<c013f975>] ? in_group_p+0x25/0x30
> Feb 10 17:13:28 newton [<c01a3cff>] ? file_move+0x1f/0x50
> Feb 10 17:13:28 newton [<c01ad204>] path_walk+0x54/0xc0
> Feb 10 17:13:28 newton [<c01ad3c9>] do_path_lookup+0xb9/0x1a0
> Feb 10 17:13:28 newton [<c01ae00a>] user_path_at+0x4a/0x80
> Feb 10 17:13:28 newton [<c0146688>] ? remove_wait_queue+0x38/0x50
> Feb 10 17:13:28 newton [<c01a67ce>] vfs_lstat_fd+0x1e/0x50
> Feb 10 17:13:28 newton [<c01a6871>] vfs_lstat+0x11/0x20
> Feb 10 17:13:28 newton [<c01a6894>] sys_lstat64+0x14/0x30
> Feb 10 17:13:28 newton [<c01347d7>] ? sys_wait4+0x87/0xd0
> Feb 10 17:13:28 newton [<c01360a9>] ? sys_time+0x19/0x50
> Feb 10 17:13:28 newton [<c01033c1>] sysenter_do_call+0x12/0x21
> Feb 10 17:13:28 newton [<c0520000>] ? schedule+0x2c0/0x9e0
> Feb 10 17:13:28 newton procmail      D e714a6c4     0 11420  11419
> Feb 10 17:13:28 newton eaaf9dbc 00200082 f7009eec e714a6c4 00000000 00000000 00000000 ced77a41
> Feb 10 17:13:28 newton 000033fd c0179ac1 c149b70c eaaf9dc4 c018e717 c0741300 ea823d90 ea824004
> Feb 10 17:13:28 newton c281f300 00000001 00d8ec3a b7eef238 f5734898 e5766380 ea824004 c149b700
> Feb 10 17:13:28 newton Call Trace:
> Feb 10 17:13:28 newton [<c0179ac1>] ? unlock_page+0x41/0x50
> Feb 10 17:13:28 newton [<c018e717>] ? __do_fault+0x187/0x3f0
> Feb 10 17:13:28 newton [<c05216f8>] __mutex_lock_slowpath+0xb8/0x250
> Feb 10 17:13:28 newton [<c018f0bb>] ? handle_mm_fault+0x13b/0x780
> Feb 10 17:13:28 newton [<c05218a2>] mutex_lock+0x12/0x20
> Feb 10 17:13:28 newton [<c01ac1d7>] do_lookup+0xd7/0x1d0
> Feb 10 17:13:28 newton [<c01ac536>] __link_path_walk+0x266/0xd80
> Feb 10 17:13:28 newton [<c0524db5>] ? do_page_fault+0x235/0x950
> Feb 10 17:13:28 newton [<c013f975>] ? in_group_p+0x25/0x30
> Feb 10 17:13:28 newton [<c01a3cff>] ? file_move+0x1f/0x50
> Feb 10 17:13:28 newton [<c01ad204>] path_walk+0x54/0xc0
> Feb 10 17:13:28 newton [<c01ad3c9>] do_path_lookup+0xb9/0x1a0
> Feb 10 17:13:28 newton [<c01ae00a>] user_path_at+0x4a/0x80
> Feb 10 17:13:28 newton [<c0146688>] ? remove_wait_queue+0x38/0x50
> Feb 10 17:13:28 newton [<c01a67ce>] vfs_lstat_fd+0x1e/0x50
> Feb 10 17:13:28 newton [<c01a6871>] vfs_lstat+0x11/0x20
> Feb 10 17:13:28 newton [<c01a6894>] sys_lstat64+0x14/0x30
> Feb 10 17:13:28 newton [<c01347d7>] ? sys_wait4+0x87/0xd0
> Feb 10 17:13:28 newton [<c01360a9>] ? sys_time+0x19/0x50
> Feb 10 17:13:28 newton [<c01033c1>] sysenter_do_call+0x12/0x21
> Feb 10 17:13:28 newton [<c0520000>] ? schedule+0x2c0/0x9e0
> 
> and quite a few more procmails which had been launched after it started
> hanging.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

