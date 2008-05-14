From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Soft lockups in mballoc code
Date: Wed, 14 May 2008 10:18:37 -0700
Message-ID: <1210785517.3657.42.camel@localhost.localdomain>
References: <25037.1210612895@alphaville.zko.hp.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42936 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbYENRSq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 May 2008 13:18:46 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4EHIjeZ018623
	for <linux-ext4@vger.kernel.org>; Wed, 14 May 2008 13:18:45 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4EHIjTL137798
	for <linux-ext4@vger.kernel.org>; Wed, 14 May 2008 13:18:45 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4EHIjsQ006713
	for <linux-ext4@vger.kernel.org>; Wed, 14 May 2008 13:18:45 -0400
In-Reply-To: <25037.1210612895@alphaville.zko.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-05-12 at 13:21 -0400, Nick Dokos wrote:
> I keep getting soft lockups in mballoc code, running fsstress.
> I'm running a 2.6.25.2 kernel, with 1.40.8 e2fsprogs. Here
> is sample console output on a 2-cpu Opteron box with a 2Tb filesystem -
> the two stack traces keep repeating every minute or so and the only
> way to get out is to reset the box:
> 
Nick, thanks for reporting this. I remember saw soft lockup issue with
mballoc on 2.6.25-rc kernels.  Could you run the latest 2.6.26-rc2
kernel? There are lots of bug fixes have been pushed to 2.6.26-rc1.
Aneesh, do you know if this is a new issue?

Mingming
> ---------------------------------------------------------------------------
> [root@dl385 fsstress]# /home/nick/src/fsstress/fsstress -d /mnt2/fsstress -l 10 -n 100 -p 20
> seed = 1211090909
> BUG: soft lockup - CPU#1 stuck for 61s! [fsstress:3974]
> CPU 1:
> Modules linked in: qla2xxx ext4dev jbd2 crc16 ipv6 autofs4 hidp rfcomm l2cap bluetooth sunrpc cpufreq_ondemand dm_mirror dm_multipath dm_mod sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy ide_cd_mod serio_raw cdrom button tg3 amd_rng k8temp shpchp i2c_amd756 pcspkr hwmon i2c_core scsi_transport_fc mptspi mptscsih scsi_transport_spi mptbase cciss sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: qla2xxx]
> Pid: 3974, comm: fsstress Not tainted 2.6.25.2 #1
> RIP: 0010:[<ffffffff88412790>]  [<ffffffff88412790>] :ext4dev:ext4_mb_new_blocks+0x7bd/0x1618
> RSP: 0018:ffff8101f304b898  EFLAGS: 00000202
> RAX: 00000000ffffffff RBX: ffff8101f4c86918 RCX: 0000000000000007
> RDX: ffff8100f31d35c0 RSI: 00000000000029fd RDI: ffffe200034f6548
> RBP: 00000000000014fe R08: 0000000000000000 R09: ffff8101f4cbd280
> R10: 0000000000000001 R11: ffffffff884174c0 R12: 0000000000000f00
> R13: ffff8100f2de8b58 R14: ffffffff883feadd R15: ffff8101f4c622b8
> FS:  00007f78917726f0(0000) GS:ffff8101ff6b3f40(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000003dca80b9a0 CR3: 00000001f3036000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> 
> Call Trace:
>  [<ffffffff8841274d>] ? :ext4dev:ext4_mb_new_blocks+0x77a/0x1618
>  [<ffffffff8022779f>] ? set_next_entity+0x23/0x73
>  [<ffffffff8026000c>] ? compat_irq_chip_set_default_handler+0x5/0x11
>  [<ffffffff883fbd99>] ? :ext4dev:ext4_new_blocks+0x6a/0x88
>  [<ffffffff883fefb5>] ? :ext4dev:ext4_get_blocks_handle+0x355/0x84f
>  [<ffffffff883ff773>] ? :ext4dev:ext4_get_block+0x0/0xf9
>  [<ffffffff802aa74d>] ? __find_get_block+0x148/0x158
>  [<ffffffff883ff5c0>] ? :ext4dev:ext4_get_blocks_wrap+0x111/0x135
>  [<ffffffff883ff82d>] ? :ext4dev:ext4_get_block+0xba/0xf9
>  [<ffffffff802ab509>] ? __block_prepare_write+0x19d/0x36c
>  [<ffffffff883ff773>] ? :ext4dev:ext4_get_block+0x0/0xf9
>  [<ffffffff802ab775>] ? block_write_begin+0x78/0xc9
>  [<ffffffff88400d67>] ? :ext4dev:ext4_write_begin+0xeb/0x1b1
>  [<ffffffff883ff773>] ? :ext4dev:ext4_get_block+0x0/0xf9
>  [<ffffffff80292ab5>] ? __page_symlink+0x44/0xf7
>  [<ffffffff8840491d>] ? :ext4dev:ext4_symlink+0x136/0x1db
>  [<ffffffff80293915>] ? vfs_symlink+0xbf/0x12e
>  [<ffffffff80295d27>] ? sys_symlinkat+0x87/0xd4
>  [<ffffffff8025cbdf>] ? audit_syscall_exit+0x2e4/0x303
>  [<ffffffff8020bdae>] ? tracesys+0x71/0xe1
>  [<ffffffff8020be19>] ? tracesys+0xdc/0xe1
> 
> BUG: soft lockup - CPU#0 stuck for 61s! [fsstress:3984]
> CPU 0:
> Modules linked in: qla2xxx ext4dev jbd2 crc16 ipv6 autofs4 hidp rfcomm l2cap bluetooth sunrpc cpufreq_ondemand dm_mirror dm_multipath dm_mod sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy ide_cd_mod serio_raw cdrom button tg3 amd_rng k8temp shpchp i2c_amd756 pcspkr hwmon i2c_core scsi_transport_fc mptspi mptscsih scsi_transport_spi mptbase cciss sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: qla2xxx]
> Pid: 3984, comm: fsstress Not tainted 2.6.25.2 #1
> RIP: 0010:[<ffffffff884145e0>]  [<ffffffff884145e0>] :ext4dev:ext4_mb_discard_inode_preallocations+0x1c6/0x27b
> RSP: 0018:ffff8101f3521e18  EFLAGS: 00000202
> RAX: 00000000ffffffff RBX: ffff8100f2def470 RCX: 0000000000000007
> RDX: ffff8100f31d35c0 RSI: 00000000000014fe RDI: ffff8100f2dbd470
> RBP: 0000000000000000 R08: ffff81000900ec80 R09: 0000000000001000
> R10: ffff8100f2debae8 R11: ffff8101fc9d8000 R12: ffff8101f4c8bcc0
> R13: 0000000000001000 R14: 0000000000000000 R15: 000000000a7f0000
> FS:  00007f78917726f0(0000) GS:ffffffff805b9000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000003dca8c2200 CR3: 00000001f4023000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> 
> Call Trace:
>  [<ffffffff88414591>] :ext4dev:ext4_mb_discard_inode_preallocations+0x177/0x27b
>  [<ffffffff883fbe50>] :ext4dev:ext4_discard_reservation+0x24/0x68
>  [<ffffffff883fc872>] :ext4dev:ext4_release_file+0x2d/0x6f
>  [<ffffffff8028d243>] __fput+0xb1/0x17e
>  [<ffffffff8028ab77>] filp_close+0x5d/0x65
>  [<ffffffff8028bcee>] sys_close+0x7e/0xb7
>  [<ffffffff8020be19>] tracesys+0xdc/0xe1
> 
> 
> 
> ...
> 
> ---------------------------------------------------------------------------
> 
> Known bug? Is there a fix somewhere?
> 
> Let me know if more information is needed.
> 
> Thanks very much,
> Nick
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

