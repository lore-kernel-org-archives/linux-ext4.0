From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Wed, 30 May 2012 09:18:31 +0000 (UTC)
Message-ID: <20120530091831.258FC11FD1B@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47734 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab2E3JSf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 May 2012 05:18:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A100B20322
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2012 09:18:33 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 2BA3920300
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2012 09:18:31 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #4 from Jan Kara <jack@suse.cz>  2012-05-30 09:18:30 ---
Hmm, thanks for the data. So jbd2 thread (which is blocking the rest) is
waiting for the following nfsd thread to finish a transaction:
[  128.487611] nfsd            D 0000000000000000     0   750      2 0x00000000
[  128.487613]  ffff880076833050 0000000000000046 ffff880076832f50
ffffffff00000000
[  128.487615]  ffff8800790ea040 ffff880076833fd8 ffff880076833fd8
ffff880076833fd8
[  128.487618]  ffffffff8189b020 ffff8800790ea040 0000000179880938
ffff880079880848
[  128.487620] Call Trace:
[  128.487624]  [<ffffffff81204569>] ? queue_unplugged+0x59/0x110
[  128.487627]  [<ffffffff81187fa0>] ? __wait_on_buffer+0x30/0x30
[  128.487629]  [<ffffffff81421d8f>] schedule+0x3f/0x60
[  128.487631]  [<ffffffff81421e3f>] io_schedule+0x8f/0xd0
[  128.487633]  [<ffffffff81187fae>] sleep_on_buffer+0xe/0x20
[  128.487634]  [<ffffffff814225a0>] __wait_on_bit+0x60/0x90
[  128.487637]  [<ffffffff81187fa0>] ? __wait_on_buffer+0x30/0x30
[  128.487639]  [<ffffffff8142264c>] out_of_line_wait_on_bit+0x7c/0x90
[  128.487641]  [<ffffffff810819f0>] ? autoremove_wake_function+0x40/0x40
[  128.487643]  [<ffffffff81187f9e>] __wait_on_buffer+0x2e/0x30
[  128.487648]  [<ffffffffa01744d3>] ext4_mb_init_cache+0x203/0x9c0 [ext4]
[  128.487651]  [<ffffffff81106e40>] ? __lru_cache_add+0x90/0xb0
[  128.487656]  [<ffffffffa017665e>] ext4_mb_init_group+0x10e/0x210 [ext4]
[  128.487660]  [<ffffffffa0176876>] ext4_mb_good_group+0x116/0x130 [ext4]
[  128.487665]  [<ffffffffa0178a3b>] ext4_mb_regular_allocator+0x19b/0x420
[ext4]
[  128.487669]  [<ffffffffa017620d>] ? ext4_mb_normalize_request+0x20d/0x500
[ext4]
[  128.487674]  [<ffffffffa017a40e>] ext4_mb_new_blocks+0x42e/0x5d0 [ext4]
[  128.487678]  [<ffffffffa0148558>] ext4_alloc_branch+0x528/0x670 [ext4]
[  128.487681]  [<ffffffff81118129>] ? zone_statistics+0x99/0xc0
[  128.487686]  [<ffffffffa014ba78>] ext4_ind_map_blocks+0x328/0x7c0 [ext4]
[  128.487690]  [<ffffffffa014bfea>] ext4_map_blocks+0xda/0x1f0 [ext4]
[  128.487694]  [<ffffffffa014c1a6>] _ext4_get_block+0xa6/0x160 [ext4]
[  128.487698]  [<ffffffffa014c2c6>] ext4_get_block+0x16/0x20 [ext4]
[  128.487701]  [<ffffffff8118a427>] __block_write_begin+0x1c7/0x590
[  128.487705]  [<ffffffffa014c2b0>] ? noalloc_get_block_write+0x30/0x30 [ext4]
[  128.487709]  [<ffffffffa014d9c2>] ext4_write_begin+0x162/0x390 [ext4]
[  128.487711]  [<ffffffff810fa739>] generic_file_buffered_write+0x109/0x260
[  128.487714]  [<ffffffff810fb8d5>] __generic_file_aio_write+0x245/0x460
[  128.487716]  [<ffffffff8142350d>] ? __mutex_lock_slowpath+0x25d/0x350
[  128.487718]  [<ffffffff810fbb5e>] generic_file_aio_write+0x6e/0xe0
[  128.487722]  [<ffffffffa0143dff>] ext4_file_write+0xaf/0x260 [ext4]
[  128.487724]  [<ffffffff811745e9>] ? iget_locked+0x89/0x180
[  128.487727]  [<ffffffffa06293b0>] ? _fh_update.isra.8.part.9+0x60/0x60
[nfsd]
[  128.487729]  [<ffffffff81174902>] ? iput+0x42/0x1c0
[  128.487733]  [<ffffffffa0143d50>] ? ext4_llseek+0x110/0x110 [ext4]
[  128.487735]  [<ffffffff8115a9d2>] do_sync_readv_writev+0xd2/0x110
[  128.487738]  [<ffffffffa06293b0>] ? _fh_update.isra.8.part.9+0x60/0x60
[nfsd]
[  128.487741]  [<ffffffff811449b9>] ? __kmalloc+0x39/0x1a0
[  128.487743]  [<ffffffff811e33ec>] ? security_file_permission+0x2c/0xb0
[  128.487745]  [<ffffffff8115a0f1>] ? rw_verify_area+0x61/0xf0
[  128.487747]  [<ffffffff8115aca4>] do_readv_writev+0xd4/0x1e0
[  128.487751]  [<ffffffffa0143a5f>] ? ext4_file_open+0x6f/0x1e0 [ext4]
[  128.487753]  [<ffffffff8115ade5>] vfs_writev+0x35/0x60
[  128.487757]  [<ffffffffa062a83b>] nfsd_vfs_write.isra.9+0xeb/0x3e0 [nfsd]
[  128.487759]  [<ffffffff811588df>] ? dentry_open+0x4f/0x90
[  128.487762]  [<ffffffffa062b690>] ? nfsd_open+0xa0/0x1a0 [nfsd]
[  128.487766]  [<ffffffffa062ce08>] nfsd_write+0xf8/0x110 [nfsd]
[  128.487770]  [<ffffffffa063476b>] nfsd3_proc_write+0xbb/0x150 [nfsd]
[  128.487773]  [<ffffffffa0626a4e>] nfsd_dispatch+0xfe/0x240 [nfsd]
[  128.487777]  [<ffffffffa054597b>] svc_process+0x4bb/0x840 [sunrpc]
[  128.487779]  [<ffffffff8107143b>] ? recalc_sigpending+0x1b/0x50
[  128.487782]  [<ffffffffa06260c2>] nfsd+0xc2/0x160 [nfsd]
[  128.487785]  [<ffffffffa0626000>] ? 0xffffffffa0625fff
[  128.487786]  [<ffffffff8108102c>] kthread+0x8c/0xa0
[  128.487788]  [<ffffffff814266a4>] kernel_thread_helper+0x4/0x10
[  128.487791]  [<ffffffff81080fa0>] ? kthread_worker_fn+0x180/0x180
[  128.487792]  [<ffffffff814266a0>] ? gs_change+0x13/0x13

That thread waits for block bitmap to be read from disk. The question is why
would reading take so long (or never actually finish).

For start can you maybe switch IO scheduler to deadline. You can do that by:
echo "deadline" >/sys/block/<dev>/queue/scheduler
for all disks, reproduce the problem and post here output from echo w >
/proc/sysrq-trigger again? Thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
