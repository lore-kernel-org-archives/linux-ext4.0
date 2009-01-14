From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Tue, 13 Jan 2009 16:48:42 -0800
Message-ID: <20090113164842.c6aa7095.akpm@linux-foundation.org>
References: <20090110003645.GA16107@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292AbZANAtc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jan 2009 19:49:32 -0500
In-Reply-To: <20090110003645.GA16107@linux-os.sc.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(this is ext3)

On Fri, 9 Jan 2009 16:36:45 -0800
"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

> 
> I started seeing this BUG on one of my test systems during file system unmount
> on the way to shutdown/reboot. The problem is present with latest git and not
> present in 2.6.28.
> 
> Hoping that someone has already seen this and fix available before I go
> git bisect way...
> 
> Let me know if you need any more detais about the bug or test system.
> 
> Thanks,
> Venki
> 
> 
> [  212.222623] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [  213.824126] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: R
> X/TX
> [  213.832083] 0000:06:00.0: eth0: 10/100 speed: disabling TSO
> [  213.842423] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [  579.820973] sb orphan head is 291585
> [  579.824856] sb_info orphan list:
> [  579.828373]   inode sda3:291585 at ffff880220449c00: mode 100600, nlink 0, ne
> xt 0
> [  579.836381] ------------[ cut here ]------------
> [  579.841264] kernel BUG at /home/venkip/src/linus/linux-2.6/fs/ext3/super.c:42
> 8!
> [  579.849065] invalid opcode: 0000 [#1] SMP
> [  579.853602] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:0b:01.
> 0/irq
> [  579.861638] CPU 0
> [  579.863974] Modules linked in:
> [  579.867387] Pid: 7027, comm: umount Not tainted 2.6.28-05716-gfe0bdec-dirty #
> 587
> [  579.875244] RIP: 0010:[<ffffffff80321151>]  [<ffffffff80321151>] ext3_put_sup
> er+0x198/0x1f6
> [  579.884162] RSP: 0018:ffff88022c9a7e18  EFLAGS: 00010287
> [  579.889753] RAX: ffff880220449b68 RBX: ffff880229151278 RCX: 0000000000000000
> [  579.897162] RDX: 0000000000007675 RSI: 0000000000000001 RDI: 000000000000000f
> [  579.904573] RBP: ffff88022c9a7e48 R08: 0000000000000086 R09: 0000000000000086
> [  579.911982] R10: ffffffff8024ee4b R11: 0000000000000086 R12: ffff880229150000
> [  579.919410] R13: ffff88022ae6b000 R14: ffff880229151278 R15: ffff88022cbf8498
> [  579.926820] FS:  00007fa202bdd6d0(0000) GS:ffffffff80a83080(0000) knlGS:00000
> 00000000000
> [  579.935408] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  579.941422] CR2: 000000000059d4b8 CR3: 00000002299d7000 CR4: 00000000000406e0
> [  579.948832] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  579.956244] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  579.963669] Process umount (pid: 7027, threadinfo ffff88022c9a6000, task ffff
> 88022993e180)
> [  579.972422] Stack:
> [  579.974695]  0000000000000000 ffffffff80a70c80 ffff88022ae6b000 ffffffff806c2
> 440
> [  579.982414]  0000000000000008 ffffffff80a70c80 ffff88022c9a7e68 ffffffff802a5
> e6a
> [  579.990643]  ffff88022a9d5040 0000000000000003 ffff88022c9a7e88 ffffffff802a5
> f18
> [  579.999317] Call Trace:
> [  580.002027]  [<ffffffff802a5e6a>] generic_shutdown_super+0x63/0xf7
> [  580.008553]  [<ffffffff802a5f18>] kill_block_super+0x1a/0x32
> [  580.014584]  [<ffffffff802a5fe5>] deactivate_super+0x4c/0x61
> [  580.020609]  [<ffffffff802b8e4a>] mntput_no_expire+0x10d/0x13d
> [  580.026814]  [<ffffffff802b93ec>] sys_umount+0x2c0/0x2ed
> [  580.032473]  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
> [  580.038826] Code: ff ff 48 81 c6 50 04 00 00 89 04 24 31 c0 e8 c8 4f 37 00 48
>  8b 1b 48 8b 03 4c 39 f3 0f 18 08 75 a9 4d 39 b4 24 78 12 00 00 74 04 <0f> 0b eb
>  fe 49 8b bd d0 01 00 00 e8 0c 18 fa ff 49 8b bc 24 90
> [  580.062926] RIP  [<ffffffff80321151>] ext3_put_super+0x198/0x1f6

Well that's not good.  I don't recall us making any changes which
affect the orphan list handling.  Perhaps "filesystem freeze: add error
handling of write_super_lockfs/unlockfs", but only indirectly.

Does Arjan's new async stuff play with filesystems at umount/shutdown
time?  Don't think so.

A bisect would be nice, please ;)
