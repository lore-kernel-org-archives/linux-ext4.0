From: Solofo.Ramangalahy@bull.net
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Thu, 6 Nov 2008 14:47:30 +0100
Message-ID: <18706.62834.128486.438267@frecb006361.adech.frec.bull.fr>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
	<20081103134008.GE29102@mit.edu>
	<319012f0811030734s6d14b2b3t13c32a41ac48e852@mail.gmail.com>
	<20081103165144.6514f003@starbug.prg01.itonis.net>
	<18705.63392.489856.682976@frecb006361.adech.frec.bull.fr>
	<20081105195713.GB9266@mit.edu>
	<18705.64906.497902.219660@frecb006361.adech.frec.bull.fr>
	<18706.44.567787.592343@frecb006361.adech.frec.bull.fr>
	<20081105204223.GC9266@mit.edu>
	<20081106101521.GB25194@skywalker>
	<18706.51345.420595.122952@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Jindrich Makovicka <makovick@gmail.com>,
	linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49914 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbYKFNuu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 08:50:50 -0500
In-Reply-To: <18706.51345.420595.122952@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Solofo.Ramangalahy@bull.net writes:
 > Aneesh Kumar K.V writes:
 >  > The patch aneesh-9-fix-lockdeep-recursive-locking-warning
 >  > should add the key in .data.  Do you have a stack trace ?
 > 
 > [   31.068245] kjournald2 starting.  Commit interval 5 seconds
 > [   31.139463] EXT4 FS on hdb, internal journal on hdb:8
 > [   31.201526] EXT4-fs: delayed allocation enabled
 > [   31.253465] EXT4-fs: file extents enabled
 > [   31.305491] BUG: key ca85b5a8 not in .data!
 > [   31.357287] ------------[ cut here ]------------
 > [   31.409201] WARNING: at kernel/lockdep.c:2499 __init_rwsem+0x21/0x47()
 > [   31.481599] Modules linked in: ext4 jbd2 crc16 video output ac battery dm_snapshot dm_mirror dm_region_hash dm_log dm_mod loop serio_raw pcspkr psmouse i2c_piix4 i2c_core parport_pc parport button evdev ext3 jbd mbcache ide_cd_mod cdrom ide_gd_mod ata_generic ata_piix libata scsi_mod ide_pci_generic floppy 8139too piix 8139cp mii ide_core thermal processor fan thermal_sys
 > [   31.873748] Pid: 2032, comm: mount Not tainted 2.6.28-rc3-ext4-patch-queue #1
 > [   31.966325] Call Trace:
 > [   31.987733]  [<c01299dd>] warn_on_slowpath+0x40/0x61
 > [   32.049842]  [<c0129fcd>] release_console_sem+0x19f/0x1cc
 > [   32.111988]  [<c012a48c>] vprintk+0x2dd/0x309
 > [   32.163924]  [<c0188209>] cache_alloc_refill+0x19f/0x450
 > [   32.226049]  [<c02d9179>] printk+0xe/0x15
 > [   32.277932]  [<c0145353>] lockdep_init_map+0x8d/0x420
 > [   32.340000]  [<c0146bea>] debug_check_no_locks_freed+0x110/0x123
 > [   32.412332]  [<c0146aab>] trace_hardirqs_on_caller+0xed/0x114
 > [   32.474575]  [<c020194e>] __init_rwsem+0x21/0x47
 > [   32.536589]  [<ca84807b>] ext4_mb_add_groupinfo+0x117/0x146 [ext4]
 > [   32.609828]  [<ca8482b4>] ext4_mb_init+0x20a/0x60e [ext4]
 > [   32.671977]  [<ca83ab2a>] ext4_fill_super+0x19d6/0x1f47 [ext4]
 > [   32.744330]  [<c0118c76>] pvclock_clocksource_read+0x48/0xa7
 > [   32.806561]  [<c0202cc3>] snprintf+0x16/0x18
 > [   32.858464]  [<c01c25f7>] disk_name+0x1f/0x5b
 > [   32.910343]  [<c018d44f>] get_sb_bdev+0xeb/0x12c
 > [   32.962300]  [<c0146aab>] trace_hardirqs_on_caller+0xed/0x114
 > [   33.034576]  [<ca8376d9>] ext4_get_sb+0x12/0x16 [ext4]
 > [   33.096667]  [<ca839154>] ext4_fill_super+0x0/0x1f47 [ext4]
 > [   33.158809]  [<c018d11c>] vfs_kern_mount+0x81/0xf3
 > [   33.220857]  [<c018d1cc>] do_kern_mount+0x2f/0xb4
 > [   33.272860]  [<c019e2cf>] do_mount+0x63f/0x67a
 > [   33.324749]  [<c018802b>] kmem_cache_alloc+0x85/0xc4
 > [   33.386752]  [<c019e379>] sys_mount+0x6f/0xaa
 > [   33.438659]  [<c0103ac6>] syscall_call+0x7/0xb
 > [   33.490525] ---[ end trace 4cec533a62581305 ]---
 > [   33.546858] EXT4-fs: mballoc enabled
 > [   33.588549] EXT4-fs: mounted filesystem with ordered data mode.

I am not observing it outside of kvm.

-- 
solofo
