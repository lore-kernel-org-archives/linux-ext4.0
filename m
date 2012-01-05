From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: 3.2.0-rc5 NULL dereference BUG
Date: Thu, 5 Jan 2012 09:56:09 +0800
Message-ID: <20120105015609.GA7913@localhost>
References: <20111218055359.GA17182@localhost>
 <20111218063054.GA4979@localhost>
 <CAGBYx2bxdnkXcZF+A1iOvnsW=xdtDJR7Fx3Rz-HWeWH5n0ByKg@mail.gmail.com>
 <20111218113237.GA1359@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111218113237.GA1359@localhost>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Dec 18, 2011 at 07:32:37PM +0800, Wu Fengguang wrote:
> Yongqiang,
> 
> Thanks for the quick fix!
> 
> On Sun, Dec 18, 2011 at 03:17:18PM +0800, Yongqiang Yang wrote:
> > Hi Fengguang,
> > 
> > Could you try the patch [ext4: do not reference pa_inode from group_pa]?
> 
> It works! You can add my tested-by and CC stable.

The patch seems to only fix part of the problem. Today I get this slightly
different dmesg (the kernel has been patched with [ext4: do not reference
pa_inode from group_pa]):

[  646.026574] BUG: unable to handle kernel NULL pointer dereference at 0000000000000178
[  646.027004] IP: [<ffffffff810a5092>] __lock_acquire+0x8b/0x932
[  646.027004] PGD 4f85067 PUD 99cb4067 PMD 0
[  646.027004] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[  646.027004] CPU 6
[  646.051405] Modules linked in:
[  646.051405]
[  646.051405] Pid: 6149, comm: dd Not tainted 3.2.0-rc5-ioless-full+ #1009 Supermicro X7DW3/X7DWN
[  646.051405] RIP: 0010:[<ffffffff810a5092>]  [<ffffffff810a5092>] __lock_acquire+0x8b/0x932
[  646.051405] RSP: 0018:ffff880004ee18d8  EFLAGS: 00010097
[  646.051405] RAX: 0000000000000000 RBX: 0000000000000170 RCX: 0000000000000000
[  646.051405] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000170
[  646.051405] RBP: ffff880004ee1948 R08: 0000000000000000 R09: 0000000000000000
[  646.051405] R10: 0000000000000170 R11: ffffffff81175de4 R12: 0000000000000000
[  646.051405] R13: 0000000000000000 R14: ffff880004fc4540 R15: 0000000000000000
[  646.051405] FS:  00007f193aa90700(0000) GS:ffff880226a00000(0000) knlGS:0000000000000000
[  646.051405] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  646.051405] CR2: 0000000000000178 CR3: 00000000b17cb000 CR4: 00000000000006e0
[  646.051405] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  646.051405] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  646.051405] Process dd (pid: 6149, threadinfo ffff880004ee0000, task ffff880004fc4540)
[  646.051405] Stack:
[  646.051405]  ffff880004ee18f8 ffffffff81099aa3 0000000000000006 0000000000000002
[  646.051405]  0000000000000000 0000000000008010 ffff880225806b00 ffff88005fc08d68
[  646.051405]  ffff880004ee1978 0000000000000000 0000000000000170 0000000000000000
[  646.051405] Call Trace:
[  646.051405]  [<ffffffff81099aa3>] ? sched_clock_local+0x12/0x75
[  646.051405]  [<ffffffff810a5a16>] lock_acquire+0xdd/0x10a
[  646.051405]  [<ffffffff81175de4>] ? create_empty_buffers+0x4a/0xc1
[  646.051405]  [<ffffffff8199f623>] _raw_spin_lock+0x36/0x69
[  646.051405]  [<ffffffff81175de4>] ? create_empty_buffers+0x4a/0xc1
[  646.051405]  [<ffffffff81175de4>] create_empty_buffers+0x4a/0xc1
[  646.051405]  [<ffffffff811efd2f>] ext4_discard_partial_page_buffers_no_lock+0x9f/0x406
[  646.051405]  [<ffffffff8199ffeb>] ? _raw_spin_unlock+0x2b/0x2f
[  646.051405]  [<ffffffff81170c26>] ? __mark_inode_dirty+0x1ac/0x1cc
[  646.051405]  [<ffffffff811767f3>] ? generic_write_end+0x6d/0x7f
[  646.051405]  [<ffffffff811f15e5>] ext4_da_write_end+0x244/0x2ed
[  646.051405]  [<ffffffff810ffeec>] generic_file_buffered_write+0x183/0x22d
[  646.051405]  [<ffffffff8107946a>] ? current_fs_time+0x27/0x2e
[  646.051405]  [<ffffffff8110198c>] __generic_file_aio_write+0x334/0x364
[  646.051405]  [<ffffffff8199e55c>] ? mutex_lock_nested+0x2e2/0x2f1
[  646.051405]  [<ffffffff81101a06>] ? generic_file_aio_write+0x4a/0xc1
[  646.051405]  [<ffffffff81101a22>] generic_file_aio_write+0x66/0xc1
[  646.051405]  [<ffffffff811ea020>] ext4_file_write+0x1f9/0x251
[  646.051405]  [<ffffffff8103c24b>] ? sched_clock+0x9/0xd
[  646.051405]  [<ffffffff8118180e>] ? fsnotify+0x216/0x26f
[  646.051405]  [<ffffffff8114d45e>] do_sync_write+0xce/0x10b
[  646.051405]  [<ffffffff8118180e>] ? fsnotify+0x216/0x26f
[  646.051405]  [<ffffffff8118166e>] ? fsnotify+0x76/0x26f
[  646.051405]  [<ffffffff8114dc1b>] vfs_write+0xb8/0x157
[  646.051405]  [<ffffffff8114ded2>] sys_write+0x4d/0x77
[  646.051405]  [<ffffffff819a6c02>] system_call_fastpath+0x16/0x1b
[  646.051405] Code: bd 08 00 00 be d5 0b 00 00 48 c7 c7 86 41 d3 81 83 3d 82 f2 9f 01 00 0f 85 a4 08 00 00 e9 bb 03 00 00 41 83 fc 01 77 13 44 89 e0 <4c> 8b 6c c3 08 4d 85 ed 0f 85 5b 03 00 00 eb 34 41 83 fc 07 76
[  646.051405] RIP  [<ffffffff810a5092>] __lock_acquire+0x8b/0x932
[  646.051405]  RSP <ffff880004ee18d8>
[  646.051405] CR2: 0000000000000178
[  646.051405] ---[ end trace ebd0c8e3a842a6f1 ]---

The test case is about running 100 dd tasks on each of the 10 JBOD disks:

        lkp-st02-x8664/JBOD-10HDD-thresh=100M/ext4-100dd-1-3.2.0-rc5-ioless-full+

Thanks,
Fengguang
