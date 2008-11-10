From: Li Zefan <lizf@cn.fujitsu.com>
Subject: kernel BUG at fs/ext4/mballoc.c:1240!
Date: Mon, 10 Nov 2008 09:09:22 +0800
Message-ID: <491789C2.7000902@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56048 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbYKJBMJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Nov 2008 20:12:09 -0500
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id 6C12617008D
	for <linux-ext4@vger.kernel.org>; Mon, 10 Nov 2008 09:12:31 +0800 (CST)
Received: from fnst.cn.fujitsu.com (localhost.localdomain [127.0.0.1])
	by tang.cn.fujitsu.com (8.13.1/8.13.1) with ESMTP id mAA1BvIC011116
	for <linux-ext4@vger.kernel.org>; Mon, 10 Nov 2008 09:11:57 +0800
Received: from localhost.localdomain (unknown [10.167.141.140])
	by fnst.cn.fujitsu.com (Postfix) with ESMTPA id F17FA292BB8
	for <linux-ext4@vger.kernel.org>; Mon, 10 Nov 2008 09:12:49 +0800 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I used soft raid on IA64 and got the following oops.

# fdisk -l

Disk /dev/sdc: 881.0 GB, 881005166592 bytes
255 heads, 63 sectors/track, 107109 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x0000544c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      107109   860353011   fd  Linux raid autodetect
...
   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1      107109   860353011   fd  Linux raid autodetect
...
   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1      107109   860353011   fd  Linux raid autodetect
...
   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1      107109   860353011   fd  Linux raid autodetect

# mdadm --create /dev/md0 --level=0 --raid-devices=4 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
# mkfs.ext4 -b 65536 /dev/md0
# mount -t ext4 /dev/md0 /mnt
# cd /mnt
# dd if=/dev/zero of=tmp_file bs=1M count=700
(stuck)

(another console)
EXT4-fs: barriers enabled
kjournald2 starting.  Commit interval 5 seconds
EXT4 FS on md0, internal journal on md0:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem with ordered data mode.
JBD: barrier-based sync failed on md0:8 - disabling barriers
kernel BUG at fs/ext4/mballoc.c:1240!
pdflush[12068]: bugcheck! 0 [1]
Modules linked in: ext4 jbd2 crc16 raid0 nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc ipmi_watchdog mptctl ipmi_devintf ipmi_si ipmi_msghandler vfat fat dm_mirror dm_region_hash dm_log dm_multipath dm_mod e100 mii rng_core iTCO_wdt iTCO_vendor_support lpfc tg3 scsi_transport_fc libphy button sg usb_storage shpchp mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: ipmi_watchdog]

Pid: 12068, CPU 0, comm:              pdflush
psr : 0000101008526030 ifs : 8000000000000814 ip  : [<a000000207dde590>]    Not tainted (2.6.28-rc3-git4)
ip is at ext4_mb_use_best_found+0xd0/0xb00 [ext4]
unat: 0000000000000000 pfs : 0000000000000814 rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 0000000000001941
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000207dde590 b6  : a000000100039260 b7  : a00000010000bb00
f6  : 000000000000000000000 f7  : 1003e0000000000000020
f8  : 1003ee0000040878b0000 f9  : 1003e0000000000000000
f10 : 1003ee0000040a19c0000 f11 : 1003e0000000000000000
r1  : a000000100e24b80 r2  : a000000100bc5210 r3  : 0000000000004000
r8  : 0000000000000029 r9  : 0000000000000001 r10 : a000000100a50000
r11 : ffffffffffff0420 r12 : e00000005bfbfa40 r13 : e00000005bfb0000
r14 : a000000100bc5218 r15 : e00001200ac5fe18 r16 : ffffffffffff6fd0
r17 : a000000100c3f7c8 r18 : 000000000000000a r19 : 0000000000000026
r20 : 0000000000020000 r21 : a000000100c3cb78 r22 : a000000100c3cb74
r23 : a000000100c3cb88 r24 : a000000100c3f7a0 r25 : a000000100c2dba0
r26 : a000000100c3cb74 r27 : 0000001008522030 r28 : 0000000000000034
r29 : a0000001012ce0e3 r30 : 0000000000000000 r31 : a000000100bef7d8

Call Trace:
 [<a000000100015ca0>] show_stack+0x40/0xa0
                                sp=e00000005bfbf610 bsp=e00000005bfb1618
 [<a0000001000165b0>] show_regs+0x850/0x8a0
                                sp=e00000005bfbf7e0 bsp=e00000005bfb15b8
 [<a000000100039970>] die+0x1b0/0x2c0
                                sp=e00000005bfbf7e0 bsp=e00000005bfb1570
 [<a000000100039ad0>] die_if_kernel+0x50/0x80
                                sp=e00000005bfbf7e0 bsp=e00000005bfb1540
 [<a00000010066a010>] ia64_bad_break+0x230/0x460
                                sp=e00000005bfbf7e0 bsp=e00000005bfb1518
 [<a00000010000c300>] ia64_native_leave_kernel+0x0/0x270
                                sp=e00000005bfbf870 bsp=e00000005bfb1518
 [<a000000207dde590>] ext4_mb_use_best_found+0xd0/0xb00 [ext4]
                                sp=e00000005bfbfa40 bsp=e00000005bfb1478
 [<a000000207ddf130>] ext4_mb_check_limits+0x170/0x1a0 [ext4]
                                sp=e00000005bfbfa50 bsp=e00000005bfb1440
 [<a000000207de8e90>] ext4_mb_regular_allocator+0x1910/0x1f20 [ext4]
                                sp=e00000005bfbfa70 bsp=e00000005bfb13a8
 [<a000000207dec6d0>] ext4_mb_new_blocks+0x3b0/0x1400 [ext4]
                                sp=e00000005bfbfad0 bsp=e00000005bfb1328
 [<a000000207dda050>] ext4_ext_get_blocks+0x16d0/0x1b40 [ext4]
                                sp=e00000005bfbfae0 bsp=e00000005bfb1248
 [<a000000207dae570>] ext4_get_blocks_wrap+0x1d0/0x4c0 [ext4]
                                sp=e00000005bfbfb50 bsp=e00000005bfb11d0
 [<a000000207db6c70>] ext4_da_get_block_write+0xd0/0x300 [ext4]
                                sp=e00000005bfbfb50 bsp=e00000005bfb1180
 [<a000000207dabc10>] mpage_da_map_blocks+0xf0/0xce0 [ext4]
                                sp=e00000005bfbfb50 bsp=e00000005bfb1118
 [<a000000207db4240>] ext4_da_writepages+0x4a0/0x780 [ext4]
                                sp=e00000005bfbfc40 bsp=e00000005bfb1088
 [<a000000100126c90>] do_writepages+0xb0/0x120
                                sp=e00000005bfbfcf0 bsp=e00000005bfb1060
 [<a0000001001d1070>] __writeback_single_inode+0x370/0x6e0
                                sp=e00000005bfbfcf0 bsp=e00000005bfb1018
 [<a0000001001d1cb0>] generic_sync_sb_inodes+0x4b0/0x7a0
                                sp=e00000005bfbfd30 bsp=e00000005bfb0fc8
 [<a0000001001d1fd0>] sync_sb_inodes+0x30/0x60
                                sp=e00000005bfbfd30 bsp=e00000005bfb0fa0
 [<a0000001001d28f0>] writeback_inodes+0x130/0x260
                                sp=e00000005bfbfd30 bsp=e00000005bfb0f70
 [<a0000001001283a0>] background_writeout+0x140/0x1e0
                                sp=e00000005bfbfd30 bsp=e00000005bfb0f38
 [<a000000100129460>] pdflush+0x2e0/0x4e0
                                sp=e00000005bfbfd80 bsp=e00000005bfb0f18
 [<a0000001000b8ba0>] kthread+0xa0/0x120
                                sp=e00000005bfbfe30 bsp=e00000005bfb0ee8
 [<a000000100014430>] kernel_thread_helper+0x30/0x60
                                sp=e00000005bfbfe30 bsp=e00000005bfb0ec0
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e00000005bfbfe30 bsp=e00000005bfb0ec0
