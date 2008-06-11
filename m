From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Wed, 11 Jun 2008 20:21:50 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806111959270.3720@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
 <20080611135443.GK8397@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:48293 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbYFKUVy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 16:21:54 -0400
Received: from localhost (localhost [127.0.0.1])
	by node6.dwd.de (Postfix) with ESMTP id 6CEB6C583AC
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 20:21:53 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node6.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 15391-49 for <linux-ext4@vger.kernel.org>;
	Wed, 11 Jun 2008 20:21:53 +0000 (UTC)
In-Reply-To: <20080611135443.GK8397@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 11 Jun 2008, Theodore Tso wrote:

> On Wed, Jun 11, 2008 at 08:02:32AM +0000, Holger Kiehl wrote:
>>
>> Doing some performance test between ext3 and ext4 I noticed that ext4
>> is not much faster or in some cases slower then ext3. Two years ago when
>> I tested ext4 it was a lot faster then ext3 (see my mail:
>> http://lkml.org/lkml/2006/6/6/65). Doing some simple tests with bonnie++
>> I got the following results:
>
> Hi Holger,
>
> You didn't say exactly which version of the kernel/ext4 you were
> testing, but a recent change which we made to ext4, but which hasn't
> been made to ext3 yet is that barrier support has been enabled to
> improve filesystem safety; unfortunately this does imply with it a
> slight performance slowdown, which would be more pronounced on
> benchmarks with small filesystems.
>
I think you mean 'small files'? The test where done with a plain 2.6.25.4,
does that already have barriers enabled? While I did some test I hit this bug:

Jun 11 19:27:39 helena kernel: EXT4-fs: mballoc: 62053 blocks 62053 reqs (0 success)
Jun 11 19:27:39 helena kernel: EXT4-fs: mballoc: 62053 extents scanned, 14086 goal hits, 47967 2^N hits, 0 breaks, 0 lost
Jun 11 19:27:39 helena kernel: EXT4-fs: mballoc: 561 generated and it took 4080175
Jun 11 19:27:39 helena kernel: EXT4-fs: mballoc: 20889593 preallocated, 2761463 discarded
Jun 11 19:28:05 helena kernel: kjournald2 starting.  Commit interval 15 seconds
Jun 11 19:28:05 helena kernel: EXT4 FS on md7, internal journal
Jun 11 19:28:05 helena kernel: EXT4-fs: mounted filesystem with ordered data mode.
Jun 11 19:28:05 helena kernel: EXT4-fs: file extents enabled
Jun 11 19:28:05 helena kernel: EXT4-fs: mballoc enabled
Jun 11 19:28:50 helena kernel: JBD: barrier-based sync failed on md7 - disabling barriers
Jun 11 19:28:50 helena kernel: ------------[ cut here ]------------
Jun 11 19:28:50 helena kernel: kernel BUG at fs/buffer.c:2879!
Jun 11 19:28:50 helena kernel: invalid opcode: 0000 [1] SMP
Jun 11 19:28:50 helena kernel: CPU 0
Jun 11 19:28:50 helena kernel: Modules linked in: w83627hf lm85 hwmon_vid bonding ipt_REJECT xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables binfmt_misc floppy i2c_amd756 k8temp i2c_core sg ohci_hcd button usbcore
Jun 11 19:28:50 helena kernel: Pid: 26731, comm: kjournald2 Not tainted 2.6.25.4 #12
Jun 11 19:28:50 helena kernel: RIP: 0010:[submit_bh+16/253]  [submit_bh+16/253] submit_bh+0x10/0xfd
Jun 11 19:28:50 helena kernel: RSP: 0018:ffff8101775fdce0  EFLAGS: 00010246
Jun 11 19:28:50 helena kernel: RAX: 000000000000a02b RBX: ffff81005a182d90 RCX: ffff81027d7c7e60
Jun 11 19:28:50 helena kernel: RDX: 0000000100000000 RSI: ffff81005a182d90 RDI: 0000000000000001
Jun 11 19:28:50 helena kernel: RBP: 0000000000000001 R08: ffffffff8054cdd0 R09: 00000000fffff7e8
Jun 11 19:28:50 helena kernel: R10: ffff810001009940 R11: 0000000000000046 R12: ffff8101972ee000
Jun 11 19:28:50 helena kernel: R13: ffff81007ee79d00 R14: ffff8101775fde48 R15: 00000000fffffffb
Jun 11 19:28:50 helena kernel: FS:  00007f31d2ed67a0(0000) GS:ffffffff8057c000(0000) knlGS:0000000000000000
Jun 11 19:28:50 helena kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Jun 11 19:28:50 helena kernel: CR2: 00007f13a584a000 CR3: 000000027ee35000 CR4: 00000000000006e0
Jun 11 19:28:50 helena kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 11 19:28:50 helena kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 11 19:28:50 helena kernel: Process kjournald2 (pid: 26731, threadinfo ffff8101775fc000, task ffff81013773d680)
Jun 11 19:28:50 helena kernel: Stack:  ffff8101972ee024 ffff81005a182d90 ffff8101972ee000 ffffffff802f5f96
Jun 11 19:28:50 helena kernel:  ffff81000037646d ffffffff8023c8cf 0000000000000003 0000000000000287
Jun 11 19:28:50 helena kernel:  ffff81005a182850 ffff810075df7240 0000000000000000 ffff8101972ee000
Jun 11 19:28:50 helena kernel: Call Trace:
Jun 11 19:28:50 helena kernel:  [journal_submit_commit_record+315/331] ? journal_submit_commit_record+0x13b/0x14b
Jun 11 19:28:50 helena kernel:  [bit_waitqueue+16/163] ? bit_waitqueue+0x10/0xa3
Jun 11 19:28:50 helena kernel:  [jbd2_journal_commit_transaction+2811/3994] ? jbd2_journal_commit_transaction+0xafb/0xf9a
Jun 11 19:28:50 helena kernel:  [lock_timer_base+38/76] ? lock_timer_base+0x26/0x4c
Jun 11 19:28:50 helena kernel:  [kjournald2+223/514] ? kjournald2+0xdf/0x202
Jun 11 19:28:50 helena kernel:  [autoremove_wake_function+0/46] ? autoremove_wake_function+0x0/0x2e
Jun 11 19:28:50 helena kernel:  [kjournald2+0/514] ? kjournald2+0x0/0x202
Jun 11 19:28:50 helena kernel:  [kthread+71/115] ? kthread+0x47/0x73
Jun 11 19:28:50 helena kernel:  [child_rip+10/18] ? child_rip+0xa/0x12
Jun 11 19:28:50 helena kernel:  [kthread+0/115] ? kthread+0x0/0x73
Jun 11 19:28:50 helena kernel:  [child_rip+0/18] ? child_rip+0x0/0x12
Jun 11 19:28:50 helena kernel:
Jun 11 19:28:50 helena kernel:
Jun 11 19:28:50 helena kernel: Code: 5f 08 e8 14 fb ff ff 48 3b 5c 24 08 48 89 df eb eb 41 5b 5b 5b 89 e8 5d 41 5c c3 41 54 55 89 fd 53 48 8b 06 48 89 f3 a8 04 75 04 <0f> 0b eb fe a8 20 75 04 0f 0b eb fe 48 83 7e 38 00 75 04 0f 0b
Jun 11 19:28:50 helena kernel: RIP  [submit_bh+16/253] submit_bh+0x10/0xfd
Jun 11 19:28:50 helena kernel:  RSP <ffff8101775fdce0>
Jun 11 19:28:50 helena kernel: ---[ end trace 5b73613cd770052b ]---

That happened when the filesystem (mounted with barrier=0) was unmounted
and then mounted with barrier=1.

> So when you mount the filesystem
> for ext3 and ext4 for benchmarking purposes, you should consistently
> use a mount options of barrier=1 or barrier=0.  With ext4, you can use
> the mount option "barrier=1,journal_async_commit" which should
> ameliorate part of the performance decrease.  The reason why it is not
> yet the default is it requires support from e2fsprogs that has not
> been released except in development git branches; but as long as you
> don't require running e2fsck on uncleanly shutdown systems (probably
> not necessary if you are just benchmarking), you can use
> journal_async_commit in good health.
>
> Another change which might help out the bonnie benchmark, but which
> again requires the latest version of e2fsprogs is to create the
> filesystem with flex_bg filesystem feature.  In fact, for
> convenience's sake, if you are using the latest development version of
> e2fsprogs, you can just use the command "mke2fs -t ext4dev /dev/hdXX"
> and it will set up the filesystem with the correct filesystem features
> for ext4.  (The "ext4dev" sets the test_fs feature, and is basically
> there so it's clear we are still trying to finish up ext4 support.)
>
Thank you for the detailed suggestions. I will try those and post the
results as soon as I have them.

Holger

