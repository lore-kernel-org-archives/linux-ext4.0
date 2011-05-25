From: Amir Goldstein <amir73il@gmail.com>
Subject: hang in xfstest 204 with dev branch
Date: Wed, 25 May 2011 22:01:38 +0300
Message-ID: <BANLkTik66Fj7_uHmjsL65j+5s3VQ1_VdoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>,
	Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51723 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1EYTBk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 15:01:40 -0400
Received: by eyx24 with SMTP id 24so4398eyx.19
        for <linux-ext4@vger.kernel.org>; Wed, 25 May 2011 12:01:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

When running xfstests with 4K blocksize, test 204 (Test out ENOSPC
flushing on small filesystems)
hangs in an interruptible sleep (I can release it with ctrl-C).

git bisect points at commit fc0d5c38963ed655e974025c63290563c172038a
    ext4: add flag to ext4_has_free_blocks
as the offender.

Following is the stack dump of hung tasks (immediately after running test 204):

[  406.974191] SysRq : Show Blocked State
[  406.974198]   task                        PC stack   pid father
[  406.974234] 204             D ffff88010b763148     0  2002   1797 0x00000000
[  406.974239]  ffff880109621bd8 0000000000000082 ffff880100000000
0000000300000001
[  406.974243]  ffff880109621b78 ffff880109621fd8 ffff880109620000
ffff880109621fd8
[  406.974247]  ffff880128f34470 ffff88010b762da0 ffff880109621bd8
0000000181084ec0
[  406.974250] Call Trace:
[  406.974260]  [<ffffffff81241d05>] jbd2_log_wait_commit+0xb5/0x130
[  406.974264]  [<ffffffff81084c10>] ? wake_up_bit+0x40/0x40
[  406.974267]  [<ffffffff81243c26>] ? __jbd2_log_start_commit+0x96/0xa0
[  406.974270]  [<ffffffff81243d6b>] jbd2_journal_force_commit_nested+0x5b/0xa0
[  406.974274]  [<ffffffff811f3f1f>] ext4_should_retry_alloc+0x5f/0x70
[  406.974277]  [<ffffffff81205c5b>] ext4_create+0x11b/0x140
[  406.974281]  [<ffffffff8116c101>] vfs_create+0xb1/0x110
[  406.974284]  [<ffffffff8116c796>] do_last+0x636/0x960
[  406.974287]  [<ffffffff8116cc4b>] path_openat+0xcb/0x3c0
[  406.974290]  [<ffffffff8116cf82>] do_filp_open+0x42/0xa0
[  406.974293]  [<ffffffff81179707>] ? alloc_fd+0xf7/0x150
[  406.974297]  [<ffffffff8115d1a1>] do_sys_open+0x101/0x1d0
[  406.974299]  [<ffffffff8115d290>] sys_open+0x20/0x30
[  406.974304]  [<ffffffff815ad242>] system_call_fastpath+0x16/0x1b
[  406.974306] jbd2/sda8-8     D ffff88010f1ac818     0  2167      2 0x00000000
[  406.974309]  ffff88010d3a9bc0 0000000000000046 ffff880100000000
ffffffff81109a89
[  406.974313]  ffff880109fd2958 ffff88010d3a9fd8 ffff88010d3a8000
ffff88010d3a9fd8
[  406.974317]  ffffffff81a0b020 ffff88010f1ac470 ffff88010d3a9b90
000000012fc13fc0

[  406.974320] Call Trace:
[  406.974324]  [<ffffffff81109a89>] ? mempool_alloc+0x59/0x140
[  406.974328]  [<ffffffff8118aa20>] ? __wait_on_buffer+0x30/0x30
[  406.974332]  [<ffffffff815a2c1c>] io_schedule+0x8c/0xd0
[  406.974334]  [<ffffffff8118aa2e>] sleep_on_buffer+0xe/0x20
[  406.974338]  [<ffffffff815a36ef>] __wait_on_bit+0x5f/0x90
[  406.974341]  [<ffffffff8118aa20>] ? __wait_on_buffer+0x30/0x30
[  406.974343]  [<ffffffff815a379c>] out_of_line_wait_on_bit+0x7c/0x90
[  406.974347]  [<ffffffff81084c50>] ? autoremove_wake_function+0x40/0x40
[  406.974350]  [<ffffffff8118aa1e>] __wait_on_buffer+0x2e/0x30
[  406.974353]  [<ffffffff8123e70d>]
jbd2_journal_commit_transaction+0x140d/0x1580
[  406.974357]  [<ffffffff8100a6e0>] ? __switch_to+0xc0/0x2f0
[  406.974360]  [<ffffffff81241e4b>] kjournald2+0xbb/0x220
[  406.974363]  [<ffffffff81084c10>] ? wake_up_bit+0x40/0x40
[  406.974366]  [<ffffffff81241d90>] ? commit_timeout+0x10/0x10
[  406.974369]  [<ffffffff81084476>] kthread+0x96/0xa0
[  406.974372]  [<ffffffff815ae364>] kernel_thread_helper+0x4/0x10
[  406.974375]  [<ffffffff810843e0>] ? flush_kthread_worker+0xb0/0xb0
[  406.974378]  [<ffffffff815ae360>] ? gs_change+0x13/0x13

Amir.
