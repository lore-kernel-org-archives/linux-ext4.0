From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: softlockup in xfstests 083
Date: Mon, 26 Nov 2012 14:30:32 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211261423090.24277@dhcp-1-104.brq.redhat.com>
References: <20121122193600.GA31635@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab2KZNcu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 08:32:50 -0500
In-Reply-To: <20121122193600.GA31635@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 22 Nov 2012, Christoph Hellwig wrote:

> Date: Thu, 22 Nov 2012 14:36:00 -0500
> From: Christoph Hellwig <hch@infradead.org>
> To: linux-ext4@vger.kernel.org
> Subject: softlockup in xfstests 083
> 
> Running xfstests on ext4 using current Linus' tree I can reasily
> reproduce the following softlockup in xfstests 083:

Hi Christoph,

I am unable to reproduce the problem even after 70 iteration of 083
on 3.7.0-rc7. It is not immediately obvious what would block you in
ext4_ext_remove_space() other reading the extent tree from the disk,
but it should not take so long, is the trace always the same ?

Thanks!
-Lukas

> 
> 083 9s ...[ 1124.995740] EXT4-fs (vdb2): mounted filesystem with ordered
> data mode. Opts: acl,user_xattr
> [ 1156.073356] BUG: soft lockup - CPU#0 stuck for 22s! [fsstress:912]
> [ 1156.074733] Modules linked in:
> [ 1156.075471] CPU 0 
> [ 1156.075887] Pid: 912, comm: fsstress Not tainted 3.7.0-rc6+ #212 Bochs Bochs
> [ 1156.076558] RIP: 0010:[<ffffffff81152b64>]  [<ffffffff81152b64>] kfree+0xc4/0x140
> [ 1156.076558] RSP: 0018:ffff880047235c58  EFLAGS: 00000282
> [ 1156.076558] RAX: 0000000000000056 RBX: ffff880047235bd0 RCX: 0000000000000065
> [ 1156.076558] RDX: 0000000000000055 RSI: 0000000000000046 RDI: 0000000000000000
> [ 1156.076558] RBP: ffff880047235c78 R08: ffe2001390ac0000 R09: 002dffe4ef58e42b
> [ 1156.076558] R10: ff8707731e20e802 R11: 000000000000086d R12: ffffffff8167f60c
> [ 1156.076558] R13: ffff880047235c48 R14: 0000000000000046 R15: ffff880057594400
> [ 1156.076558] FS:  0000000000000000(0000) GS:ffff88005d800000(0063) knlGS:00000000f75be6c0
> [ 1156.076558] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [ 1156.076558] CR2: 00000000f714b004 CR3: 00000000592cc000 CR4: 00000000000006f0
> [ 1156.076558] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1156.076558] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1156.076558] Process fsstress (pid: 912, threadinfo ffff880047234000, task ffff8800582bc0c0)
> [ 1156.076558] Stack:
> [ 1156.076558]  0000000000000001 00000000ffffffff 0000000000000008 ffff88005aed6648
> [ 1156.076558]  ffff880047235d78 ffffffff812547fc ffff880053965390 ffff88005aed6648
> [ 1156.076558]  ffff880047235d30 ffff88005af8a3a0 ffff88005aed6598 ffff88003a5fe900
> [ 1156.076558] Call Trace:
> [ 1156.076558]  [<ffffffff812547fc>] ext4_ext_remove_space+0x49c/0xeb0
> [ 1156.076558]  [<ffffffff81257251>] ? ext4_ext_truncate+0x151/0x1b0
> [ 1156.076558]  [<ffffffff81257273>] ext4_ext_truncate+0x173/0x1b0
> [ 1156.076558]  [<ffffffff81229445>] ext4_truncate+0xd5/0xe0
> [ 1156.076558]  [<ffffffff8122c3ba>] ext4_setattr+0x37a/0x570
> [ 1156.076558]  [<ffffffff810882c1>] ? current_fs_time+0x11/0x60
> [ 1156.076558]  [<ffffffff8116f024>] notify_change+0x164/0x390
> [ 1156.076558]  [<ffffffff81164723>] ? user_path_at_empty+0x63/0xa0
> [ 1156.076558]  [<ffffffff81154a2d>] do_truncate+0x5d/0xa0
> [ 1156.076558]  [<ffffffff81154bf4>] sys_truncate+0x184/0x1a0
> [ 1156.076558]  [<ffffffff8107bc93>] sys32_truncate64+0x13/0x20
> [ 1156.076558]  [<ffffffff81b04e61>] sysenter_dispatch+0x7/0x1e
> [ 1156.076558] Code: 1c b0 00 00 48 98 49 8b 9c c6 80 00 00 00 8b 43 04 39 03 73 79 0f 1f 44 00 00 8b 03 89 c2 83 c0 01 4c 89 64 d3 18 89 03 41 55 9d <5b> 41 5c 41 5d 41 5e 5d c3 0f 1f 00 48 8b 1d b9 d6 f4 00 48 85
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
