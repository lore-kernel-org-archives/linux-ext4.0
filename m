From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12672] New: lockdep warning when using ext4 on x86_64
Date: Sun,  8 Feb 2009 23:21:54 -0800 (PST)
Message-ID: <bug-12672-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943AbZBIHV4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 02:21:56 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n197LsnY027566
	for <linux-ext4@vger.kernel.org>; Sun, 8 Feb 2009 23:21:55 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12672

           Summary: lockdep warning when using ext4 on x86_64
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc4-git1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: miaox@cn.fujitsu.com


Latest working kernel version: ?
Earliest failing kernel version: 2.6.29-rc4-git1
Distribution: Fedora10
Hardware Environment: 1G partition on x86_64 box
Software Environment: e2fsprogs version - 1.41.3, ffsb version - 5.2.1

Problem Description and Steps to reproduce:
We triggered lockdep warnining when using ext4.

# mkfs.ext4 -I 256 -b 1024 /dev/sdb2
# tune2fs -E test_fs -O extents /dev/sdb2
# mount -t ext4 -o delalloc,reservation /dev/sdb2 mnt_point
# run ffsb

some time later, lockdep warning was reported:
# dmesg
EXT4-fs: barriers enabled
kjournald2 starting: pid 3062, dev sdb2:8, commit interval 5 seconds
EXT4 FS on sdb2, internal journal on sdb2:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem sdb2 with ordered data mode

=============================================
[ INFO: possible recursive locking detected ]
2.6.29-rc4-git1-dirty #124
---------------------------------------------
ffsb/3116 is trying to acquire lock:
 (&meta_group_info[i]->alloc_sem){----}, at: [<ffffffff8035a6e8>]
ext4_mb_load_buddy+0xd2/0x343

but task is already holding lock:
 (&meta_group_info[i]->alloc_sem){----}, at: [<ffffffff8035a6e8>]
ext4_mb_load_buddy+0xd2/0x343

other info that might help us debug this:
6 locks held by ffsb/3116:
 #0:  (&sb->s_type->i_mutex_key#10){--..}, at: [<ffffffff80285419>]
generic_file_aio_write+0x52/0xc5
 #1:  (&type->s_umount_key#16){----}, at: [<ffffffff802d2a39>]
writeback_inodes+0x7b/0xe9
 #2:  (jbd2_handle){--..}, at: [<ffffffff8036c36d>]
jbd2_journal_start+0xef/0x119
 #3:  (&ei->i_data_sem){----}, at: [<ffffffff803470fa>]
ext4_get_blocks_wrap+0xbc/0x20d
 #4:  (&lg->lg_mutex){--..}, at: [<ffffffff8035b5b7>]
ext4_mb_initialize_context+0x18e/0x19d
 #5:  (&meta_group_info[i]->alloc_sem){----}, at: [<ffffffff8035a6e8>]
ext4_mb_load_buddy+0xd2/0x343

stack backtrace:
Pid: 3116, comm: ffsb Not tainted 2.6.29-rc4-git1-dirty #124
Call Trace:
 [<ffffffff80262335>] __lock_acquire+0xe42/0x161a
 [<ffffffff80262b62>] lock_acquire+0x55/0x71
 [<ffffffff8035a6e8>] ? ext4_mb_load_buddy+0xd2/0x343
 [<ffffffff80607988>] down_read+0x34/0x41
 [<ffffffff8035a6e8>] ? ext4_mb_load_buddy+0xd2/0x343
 [<ffffffff8035a6e8>] ext4_mb_load_buddy+0xd2/0x343
 [<ffffffff8035c8d6>] ext4_mb_discard_lg_preallocations+0x156/0x2ac
 [<ffffffff8035cc2b>] ext4_mb_release_context+0x1ff/0x451
 [<ffffffff8035caa5>] ? ext4_mb_release_context+0x79/0x451
 [<ffffffff8035f654>] ext4_mb_new_blocks+0x294/0x374
 [<ffffffff803579a2>] ext4_ext_get_blocks+0xbe7/0xde1
 [<ffffffff80260a12>] ? mark_held_locks+0x67/0x82
 [<ffffffff80608a44>] ? _spin_unlock_irq+0x2b/0x30
 [<ffffffff80260bd3>] ? trace_hardirqs_on_caller+0x114/0x138
 [<ffffffff80260c04>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff80347133>] ext4_get_blocks_wrap+0xf5/0x20d
 [<ffffffff803474a4>] ext4_da_get_block_write+0x67/0x15e
 [<ffffffff802832d0>] ? find_get_pages_tag+0x0/0x122
 [<ffffffff8034594d>] mpage_da_map_blocks+0x7f/0x4e3
 [<ffffffff8028a92c>] ? write_cache_pages+0x18a/0x394
 [<ffffffff8034634c>] ? __mpage_da_writepage+0x0/0x163
 [<ffffffff8036c36d>] ? jbd2_journal_start+0xef/0x119
 [<ffffffff8036c36d>] ? jbd2_journal_start+0xef/0x119
 [<ffffffff80346180>] ext4_da_writepages+0x25f/0x371
 [<ffffffff8034743d>] ? ext4_da_get_block_write+0x0/0x15e
 [<ffffffff8028ab89>] do_writepages+0x2b/0x3b
 [<ffffffff802d2035>] __writeback_single_inode+0x197/0x3a8
 [<ffffffff802d26c6>] generic_sync_sb_inodes+0x291/0x435
 [<ffffffff802d2a4f>] writeback_inodes+0x91/0xe9
 [<ffffffff8028b3b4>] balance_dirty_pages_ratelimited_nr+0x184/0x309
 [<ffffffff802845bb>] generic_file_buffered_write+0x1fa/0x2e5
 [<ffffffff80284b9e>] __generic_file_aio_write_nolock+0x358/0x38c
 [<ffffffff806073c9>] ? mutex_lock_nested+0x28e/0x29d
 [<ffffffff80285419>] ? generic_file_aio_write+0x52/0xc5
 [<ffffffff80285430>] generic_file_aio_write+0x69/0xc5
 [<ffffffff80340ec3>] ext4_file_write+0x9d/0x12a
 [<ffffffff802b7d02>] do_sync_write+0xe7/0x12d
 [<ffffffff80252838>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff802b859b>] vfs_write+0xae/0x137
 [<ffffffff802b86e8>] sys_write+0x47/0x70
 [<ffffffff8020b5db>] system_call_fastpath+0x16/0x1b

The config of ffsb is following:
# cat ffsb-config
num_filesystems=1
num_threadgroups=1
directio=0
time=500

[filesystem0]
location=mnt_point
num_files=100000
num_dirs=40
max_filesize=40960
min_filesize=4096
[end0]


[threadgroup0]
num_threads=10
read_weight=3
write_weight=1
append_weight=1
write_random=1
write_size=4096
write_blocksize=4096
read_size=4096
read_blocksize=4096
[end0]


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
