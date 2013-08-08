From: Andrey Vagin <avagin@openvz.org>
Subject: ext4: the list debug reports about corruptions
Date: Thu, 8 Aug 2013 13:45:52 +0400
Message-ID: <CANaxB-yikOkwFLtMDJjUyOm6MQPyCr6P+awhp9eZdFL_9vw4ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-next@vger.kernel.org, Glauber Costa <glommer@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

I use akpm branch of linux-next
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/?h=akpm&id=05abc43724793827835728f4f25ba827e1c54902
.
This bug is reproduced, when I do the following sequence of commands:

mkdir /sys/fs/cgroup/memory/xxx
echo 1024000000 >  /sys/fs/cgroup/memory/xxx/memory.kmem.limit_in_bytes
echo $$ > /sys/fs/cgroup/memory/xxx/tasks
find /proc -name abra-kadabra
echo $$ > /sys/fs/cgroup/memory/tasks
rmdir /sys/fs/cgroup/memory/xxx/
echo 3 > /proc/sys/vm/drop_caches

[   88.636551] ------------[ cut here ]------------
[   88.638012] WARNING: CPU: 1 PID: 350 at lib/list_debug.c:62
__list_del_entry+0x82/0xd0()
[   88.639488] list_del corruption. next->prev should be
ffff8800b567f588, but was ffff8800b8b83688
[   88.641274] Modules linked in: binfmt_misc ip6table_filter
ip6_tables iptable_filter ip_tables pcspkr virtio_balloon virtio_net
i2c_piix4 i2c_core floppy
[   88.644445] CPU: 1 PID: 350 Comm: bash Not tainted 3.11.0-rc4+ #35
[   88.647081] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   88.648926]  0000000000000009 ffff880037a6dc10 ffffffff816480dd
ffff880037a6dc58
[   88.651832]  ffff880037a6dc48 ffffffff8105753d ffff8800b8602630
ffff8800b8602000
[   88.654598]  0000000000000001 ffff8800b88b8588 ffff8800b567f588
ffff880037a6dca8
[   88.656581] Call Trace:
[   88.657197]  [<ffffffff816480dd>] dump_stack+0x45/0x56
[   88.658293]  [<ffffffff8105753d>] warn_slowpath_common+0x7d/0xa0
[   88.659444]  [<ffffffff810575ac>] warn_slowpath_fmt+0x4c/0x50
[   88.660549]  [<ffffffff8130ac42>] __list_del_entry+0x82/0xd0
[   88.661622]  [<ffffffff8125e8fb>] __ext4_es_shrink+0x23b/0x2b0
[   88.662734]  [<ffffffff8125ea19>] ext4_es_scan+0xa9/0x100
[   88.663794]  [<ffffffff81142ebf>] shrink_slab+0x1cf/0x380
[   88.666224]  [<ffffffff811f821b>] drop_caches_sysctl_handler+0xab/0xe0
[   88.667683]  [<ffffffff8120da03>] proc_sys_call_handler+0xb3/0xc0
[   88.668924]  [<ffffffff8120da24>] proc_sys_write+0x14/0x20
[   88.670001]  [<ffffffff8119a2dd>] vfs_write+0xbd/0x1e0
[   88.671014]  [<ffffffff8119ad1c>] SyS_write+0x4c/0xa0
[   88.671976]  [<ffffffff81659f99>] system_call_fastpath+0x16/0x1b
[   88.673039] ---[ end trace 9d815cd93e122801 ]---

Then the kernel reports BUG-s about soft lockup and the system hans up.
[  116.077005] BUG: soft lockup - CPU#0 stuck for 23s! [jbd2/sda3-8:114]
[  116.077005] Modules linked in: binfmt_misc ip6table_filter
ip6_tables iptable_filter ip_tables pcspkr virtio_balloon virtio_net
i2c_piix4 i2c_core floppy
[  116.077005] irq event stamp: 6420
[  116.077005] hardirqs last  enabled at (6419): [<ffffffff81650f16>]
_raw_spin_unlock_irqrestore+0x36/0x60
[  116.077005] hardirqs last disabled at (6420): [<ffffffff81650e3d>]
_raw_spin_lock_irq+0x1d/0x50
[  116.077005] softirqs last  enabled at (5776): [<ffffffff8105cdd7>]
__do_softirq+0x197/0x260
[  116.077005] softirqs last disabled at (5761): [<ffffffff8105d065>]
irq_exit+0xc5/0xd0
[  116.077005] CPU: 0 PID: 114 Comm: jbd2/sda3-8 Tainted: G        W
 3.11.0-rc4+ #35
[  116.077005] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  116.077005] task: ffff8800b8580000 ti: ffff880037bb0000 task.ti:
ffff880037bb0000
[  116.077005] RIP: 0010:[<ffffffff81009bb0>]  [<ffffffff81009bb0>]
hw_breakpoint_pmu_read+0x10/0x10
[  116.077005] RSP: 0018:ffff880037bb18e0  EFLAGS: 00000202
[  116.077005] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  116.077005] RDX: 000000000000cccb RSI: 0000000000000000 RDI: 0000000000000001
[  116.099005] BUG: soft lockup - CPU#1 stuck for 23s! [bash:350]
[  116.099005] Modules linked in: binfmt_misc ip6table_filter
ip6_tables iptable_filter ip_tables pcspkr virtio_balloon virtio_net
i2c_piix4 i2c_core floppy
[  116.099005] irq event stamp: 0
[  116.099005] hardirqs last  enabled at (0): [<          (null)>]
      (null)
[  116.099005] hardirqs last disabled at (0): [<ffffffff81055586>]
copy_process.part.25+0x5d6/0x1590
[  116.099005] softirqs last  enabled at (0): [<ffffffff81055586>]
copy_process.part.25+0x5d6/0x1590
[  116.099005] softirqs last disabled at (0): [<          (null)>]
      (null)
[  116.099005] CPU: 1 PID: 350 Comm: bash Tainted: G        W    3.11.0-rc4+ #35
[  116.099005] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  116.099005] task: ffff88003782a030 ti: ffff880037a6c000 task.ti:
ffff880037a6c000
[  116.099005] RIP: 0010:[<ffffffff8125e7a6>]  [<ffffffff8125e7a6>]
__ext4_es_shrink+0xe6/0x2b0
[  116.099005] RSP: 0018:ffff880037a6dcc8  EFLAGS: 00000212
[  116.099005] RAX: ffff8800b567f588 RBX: ffffffff81651a73 RCX: 0000100000000000
[  116.099005] RDX: 0000000000000020 RSI: 0000000000000000 RDI: 0000000000000000
[  116.099005] RBP: ffff880037a6dd38 R08: 0000000000000002 R09: 0000000000000000
[  116.099005] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880037a6dc38
[  116.099005] R13: ffff88003782a030 R14: ffff880037a6c000 R15: 0140000000000001
[  116.099005] FS:  00007fc20d80f740(0000) GS:ffff8800bfb00000(0000)
knlGS:0000000000000000
[  116.099005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  116.099005] CR2: 00007f1152f09000 CR3: 0000000037927000 CR4: 00000000000006e0
[  116.099005] Stack:
[  116.099005]  ffff8800b86026c0 0000000081c686f8 0000000000000000
0000000000000000
[  116.099005]  ffff880000000001 ffff8800b567bd50 0000000000000080
ffff880037a6dd00
[  116.099005]  ffff880037a6dd00 0000000000000020 0000000000000080
ffff8800b8601000
[  116.099005] Call Trace:
[  116.099005]  [<ffffffff8125ea19>] ext4_es_scan+0xa9/0x100
[  116.099005]  [<ffffffff81142ebf>] shrink_slab+0x1cf/0x380
[  116.099005]  [<ffffffff811f821b>] drop_caches_sysctl_handler+0xab/0xe0
[  116.099005]  [<ffffffff8120da03>] proc_sys_call_handler+0xb3/0xc0
[  116.099005]  [<ffffffff8120da24>] proc_sys_write+0x14/0x20
[  116.099005]  [<ffffffff8119a2dd>] vfs_write+0xbd/0x1e0
[  116.099005]  [<ffffffff8119ad1c>] SyS_write+0x4c/0xa0
[  116.099005]  [<ffffffff81659f99>] system_call_fastpath+0x16/0x1b
[  116.099005] Code: c4 01 e8 3e c4 0a 00 48 8b 75 d0 48 8d 55 c8 4c
89 ff e8 6e c3 0a 00 4c 39 f3 49 8b 06 0f 84 92 00 00 00 49 8b 94 24
80 06 00 00 <48> 85 d2 0f 8e 81 00 00 00 4d 89 f7 49 89 c6 49 8b 47 18
49 39
