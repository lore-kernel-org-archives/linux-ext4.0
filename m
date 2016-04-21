From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Subject: Re: Backport commit 5e1021f2b6dff
Date: Thu, 21 Apr 2016 11:43:01 +0200
Message-ID: <b6c83e47-cc27-f934-5589-8cb8e185b929@fold.natur.cuni.cz>
References: <20160414133056.GC22053@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160414133056.GC22053@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jan Kara wrote:
> Hello,
>
> I'd like to ask for commit 5e1021f2b6dff (ext4: fix NULL pointer dereference
> in ext4_mark_inode_dirty()) to be pulled into stable kernels as far as
> easily possible (the problem is there at least since 3.0 kernel) since I've
> got report of kernel crashes due to this bug on accidental USB disk
> removal. Thanks!

Hi,
    just for completeness, I am observing the kernel OOPs/lockup issue when external
USB hub chokes and resets itself and access to external drives is lost.
Another scenario is one of the external drives gets disconnected from USB hub and
kernel while being unhappy the device is gone somehow decides to reset host
controller (so that devices on other host ports are also re-enumerated).
The latter is worse because I loose connection also to other USB drives.
    Here is the stacktrace I received with OOPs. The kernel however locked up
during shutdown and camera snapshot showed same stacktrace. Disconnecting an
ext4-formatted USB drive often causes a kernel lockup. I just patched my 4.5.1
and 4.5.2 kernels and will eventually report back would the issue re-appear.
However, the analysis of Jan Kara seemed this particular patch should fix the
issue for me and so far my system survived a couple of tests when I just unplugged
and re-plugged USB data cables hooking up my external drives. Tested on 4.6-rc4
which has this commit 5e1021f2b6dff already.

Tested-by: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>


Mar 23 13:29:15 vostro kernel: EXT4-fs warning (device sdh1): dx_probe:740: inode #2: lblock 0: comm find: error -5 reading directory block
Mar 23 13:29:15 vostro kernel: EXT4-fs warning (device sdk1): htree_dirblock_to_tree:959: inode #2: lblock 0: comm find: error -5 reading directory block
Mar 23 13:29:15 vostro kernel: EXT4-fs error (device sdk1): __ext4_get_inode_loc:3981: inode #2: block 1057: comm find: unable to read itable block
Mar 23 13:29:15 vostro kernel: EXT4-fs error (device sdk1) in ext4_reserve_inode_write:5024: IO failure
Mar 23 13:29:15 vostro kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
Mar 23 13:29:15 vostro kernel: IP: [<ffffffff8128e42f>] ext4_mark_inode_dirty+0x11f/0x1d0
Mar 23 13:29:15 vostro kernel: PGD 10dfbf067 PUD 10dfbe067 PMD 0
Mar 23 13:29:15 vostro kernel: Oops: 0000 [#1] SMP
Mar 23 13:29:15 vostro kernel: Modules linked in: vfat fat ppp_deflate bsd_comp ppp_async ppp_generic slhc option usb_wwan fuse iwldvm iwlwifi uvcvideo x86_pkg_temp_thermal intel_powerclamp kvm_intel ums_realtek videobuf2_vmalloc videobuf2_memops uas usb_storage kvm videobuf2_v4l2 videobuf2_core irqbypass
Mar 23 13:29:15 vostro kernel: CPU: 1 PID: 8476 Comm: find Tainted: G        W       4.4.1-default-pciehp #1
Mar 23 13:29:15 vostro kernel: Hardware name: Dell Inc. Vostro 3550/, BIOS A12 02/18/2014
Mar 23 13:29:15 vostro kernel: task: ffff8802a5005300 ti: ffff88010da8c000 task.ti: ffff88010da8c000
Mar 23 13:29:15 vostro kernel: RIP: 0010:[<ffffffff8128e42f>]  [<ffffffff8128e42f>] ext4_mark_inode_dirty+0x11f/0x1d0
Mar 23 13:29:15 vostro kernel: RSP: 0018:ffff88010da8fda0  EFLAGS: 00010212
Mar 23 13:29:15 vostro kernel: RAX: 0000000000000100 RBX: 00000000fffffffb RCX: 0000000000000000
Mar 23 13:29:15 vostro kernel: RDX: 000000000000001c RSI: 0000000000000000 RDI: ffff8800038ec0e8
Mar 23 13:29:15 vostro kernel: RBP: ffff88010da8fde0 R08: 0000000000000000 R09: 0000000000000000
Mar 23 13:29:15 vostro kernel: R10: 0000000000000001 R11: 0000000000000000 R12: ffff88003bd58858
Mar 23 13:29:15 vostro kernel: R13: 0000000000000020 R14: ffff880106678d68 R15: ffff8801fc28c060
Mar 23 13:29:15 vostro kernel: FS:  00007f89dfc00700(0000) GS:ffff88041fa80000(0000) knlGS:0000000000000000
Mar 23 13:29:15 vostro kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 23 13:29:15 vostro kernel: CR2: 0000000000000028 CR3: 000000010dfbc000 CR4: 00000000000406e0
Mar 23 13:29:15 vostro kernel: Stack:
Mar 23 13:29:15 vostro kernel:  0000000000000000 0000000000000100 0000141700000000 ffff88003bd58858
Mar 23 13:29:15 vostro kernel:  ffff880106678d68 ffff88003bd58858 ffff8801fc28e090 ffff88003bd58928
Mar 23 13:29:15 vostro kernel:  ffff88010da8fe00 ffffffff81291913 ffff88003bd58858 0000000000000801
Mar 23 13:29:15 vostro kernel: Call Trace:
Mar 23 13:29:15 vostro kernel:  [<ffffffff81291913>] ext4_dirty_inode+0x43/0x60
Mar 23 13:29:15 vostro kernel:  [<ffffffff8122fcea>] __mark_inode_dirty+0x18a/0x350
Mar 23 13:29:15 vostro kernel:  [<ffffffff81220421>] generic_update_time+0x71/0xc0
Mar 23 13:29:15 vostro kernel:  [<ffffffff81221e23>] touch_atime+0x83/0xa0
Mar 23 13:29:15 vostro kernel:  [<ffffffff81217f8b>] iterate_dir+0xfb/0x110
Mar 23 13:29:15 vostro kernel:  [<ffffffff81218403>] SyS_getdents+0x83/0x100
Mar 23 13:29:15 vostro kernel:  [<ffffffff81217fa0>] ? iterate_dir+0x110/0x110
Mar 23 13:29:15 vostro kernel:  [<ffffffff819fcd9b>] entry_SYSCALL_64_fastpath+0x16/0x73
Mar 23 13:29:15 vostro kernel: Code: c0 0f 85 68 ff ff ff 41 0f b7 84 24 74 04 00 00 45 8b af d8 03 00 00 48 89 c2 41 39 c5 0f 86 4c ff ff ff 48 8b 4d c0 48 8b 45 c8 <48> 03 41 28 48 8d 8c 10 80 00 00 00 49 8b 94 24 e0 fe ff ff 48
Mar 23 13:29:15 vostro kernel: RIP  [<ffffffff8128e42f>] ext4_mark_inode_dirty+0x11f/0x1d0
Mar 23 13:29:15 vostro kernel:  RSP <ffff88010da8fda0>
Mar 23 13:29:15 vostro kernel: CR2: 0000000000000028
Mar 23 13:29:15 vostro kernel: ---[ end trace 1ed8f85c43f0f860 ]---
