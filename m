From: Chris Worley <worleys@gmail.com>
Subject: Overwriting w/ discard-capable drive causes soft-lockup in ext4
	journal code, 2.6.28.8
Date: Tue, 17 Mar 2009 11:29:56 -0600
Message-ID: <f3177b9e0903171029l13e7dbafyba30ece01172ce6d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:21245 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZCQR37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Mar 2009 13:29:59 -0400
Received: by yx-out-2324.google.com with SMTP id 31so78670yxl.1
        for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2009 10:29:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The issue I'm seeing is caused by running this repeatedly on an ext4
fs (2.6.28.8 kernel) w/ discards enabled (a ram-based MTD device
contains the fs):

while `true`
do  i=0
     while [ $i -lt 100 ]
     do dd of=foo"$i" if=/dev/zero bs=1024k oflag=direct &
          let i=$i+1
     done
     wait
done

(Note: the loop is intended to fill-up the fs w/ 100 dd threads...
successive re-runs of the loop will rewrite the same files from
scratch.)

... It causes "soft-lockup" issues on successive iterations,
immediately as the DD's are launched, as previous foo files get their
blocks discarded.

There are two backtraces (stuck at either do_get_write_access or
unlock_buffer)  that are generated periodically (for different dd
threads), with the system unresponsive.  I don't think the "barrier
based sync failed" message is significant, as I've seen this happen
w/o that message:

Mar 17 11:06:57 yournamehere kernel:  ftla: unknown partition table
Mar 17 11:07:20 yournamehere kernel: EXT4-fs: barriers enabled
Mar 17 11:07:20 yournamehere kernel: kjournald2 starting.  Commit
interval 5 secondsMar 17 11:07:20 yournamehere kernel: EXT4 FS on
ftla, internal journal on ftla:8Mar 17 11:07:20 yournamehere kernel:
EXT4-fs: delayed allocation enabledMar 17 11:07:20 yournamehere
kernel: EXT4-fs: file extents enabled
Mar 17 11:07:20 yournamehere kernel: EXT4-fs: mballoc enabled
Mar 17 11:07:20 yournamehere kernel: EXT4-fs: mounted filesystem with
ordered data mode.
JBD: barrier-based sync failed on ftla:8 - disabling barriers
Mar 17 11:09:36 yournamehere kernel: JBD: barrier-based sync failed on
ftla:8 - disabling barriers
BUG: soft lockup - CPU#5 stuck for 61s! [dd:28510]
Modules linked in: ext4 jbd2 crc16 ftl mtd_blkdevs mtdchar mtdram mtd
igb autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 ib_ipoib ib_sa
inet_lro ib_uverbs ib_umad ib_mthca ib_mad ib_core dm_multipath rfkill
input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp
parport sg i2c
_i801 serio_raw button i2c_core shpchp pcspkr dm_snapshot dm_zero
dm_mirror dm_region_hash dm_log dm_mod ata_piix libata sd_mod scsi_mod
ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: e1000e]Modules
linked in: ext4 jbd2 crc16 ftl mtd_blkdevs mtdchar mtdram mtd igb
autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 ib_ipoib ib_sa
inet_lro ib_uverbs ib_umad ib_mthca ib_mad ib_core dm_multipath rfkill
input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp
parport sg i2c
_i801 serio_raw button i2c_core shpchp pcspkr dm_snapshot dm_zero
dm_mirror dm_region_hash dm_log dm_mod ata_piix libata sd_mod scsi_mod
ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: e1000e]
Call Trace:
 [<ffffffffa04d9560>] ? do_get_write_access+0x4a/0x3eb [jbd2]
 [<ffffffff802b7d7a>] ? __getblk+0x28/0x227
 [<ffffffffa04d9923>] jbd2_journal_get_write_access+0x22/0x33 [jbd2]
 [<ffffffffa050952e>] __ext4_journal_get_write_access+0x1f/0x48 [ext4]
 [<ffffffffa051035a>] ext4_mb_mark_diskspace_used+0x72/0x392 [ext4]
 [<ffffffffa0510844>] ext4_mb_new_blocks+0x1ca/0x376 [ext4]
 [<ffffffffa05091e1>] ext4_ext_get_blocks+0xb96/0xda1 [ext4]
 [<ffffffff8027ac28>] ? zone_statistics+0x60/0x65
 [<ffffffff804ad9f8>] ? __down_write_nested+0x17/0x92
 [<ffffffff804ada97>] ? __down_read+0x17/0x92
 [<ffffffffa04f77f2>] ext4_get_blocks_wrap+0xf1/0x210 [ext4]
 [<ffffffffa04f7bda>] ext4_get_block+0xb4/0xf2 [ext4]
 [<ffffffff802be21f>] __blockdev_direct_IO+0x50a/0xa08
 [<ffffffffa04f9ff0>] ext4_direct_IO+0x105/0x1ea [ext4]
 [<ffffffffa04f7b26>] ? ext4_get_block+0x0/0xf2 [ext4]
 [<ffffffff8026f07e>] generic_file_direct_write+0xd7/0x18d
 [<ffffffff8026f3c8>] __generic_file_aio_write_nolock+0x294/0x3bc
 [<ffffffff8027b15e>] ? __inc_zone_page_state+0x29/0x2b
 [<ffffffff8026f708>] generic_file_aio_write+0x64/0xc0
 [<ffffffffa04f3941>] ext4_file_write+0xa4/0x12f [ext4]
 [<ffffffff8029af28>] do_sync_write+0xe2/0x126
 [<ffffffff8024b078>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff80339fc9>] ? __clear_user+0x2e/0x50
 [<ffffffff80339fad>] ? __clear_user+0x12/0x50
 [<ffffffff803049f5>] ? security_file_permission+0x11/0x13
 [<ffffffff8029b6d0>] vfs_write+0xae/0x137
 [<ffffffff8029bb79>] sys_write+0x47/0x6f
 [<ffffffff8020bddb>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#0 stuck for 61s! [dd:28522]
Modules linked in: ext4 jbd2 crc16 ftl mtd_blkdevs mtdchar mtdram mtd
igb autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 ib_ipoib ib_sa
inet_lro ib_uverbs ib_umad ib_mthca ib_mad ib_core dm_multipath rfkill
input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp
parport sg i2c_i801 serio_raw button i2c_core shpchp pcspkr
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix
libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last
unloaded: e1000e]
Modules linked in: ext4 jbd2 crc16 ftl mtd_blkdevs mtdchar mtdram mtd
igb autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 ib_ipoib ib_sa
inet_lro ib_uverbs ib_umad ib_mthca ib_mad ib_core dm_multipath rfkill
input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp
parport sg i2c_i801 serio_raw button i2c_core shpchp pcspkr
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix
libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last
unloaded: e1000e]
Call Trace:
 [<ffffffffa04d9560>] ? do_get_write_access+0x4a/0x3eb [jbd2]
 [<ffffffffa04d9923>] jbd2_journal_get_write_access+0x22/0x33 [jbd2]
 [<ffffffffa050952e>] __ext4_journal_get_write_access+0x1f/0x48 [ext4]
 [<ffffffffa04f6055>] ext4_reserve_inode_write+0x40/0x7d [ext4]
 [<ffffffffa04f60d2>] ext4_mark_inode_dirty+0x40/0x185 [ext4]
 [<ffffffffa04d9d5b>] ? jbd2_journal_start+0xa2/0xda [jbd2]
 [<ffffffffa04fa430>] ext4_dirty_inode+0x6c/0x83 [ext4]
 [<ffffffff802b4467>] __mark_inode_dirty+0x33/0x178
 [<ffffffff802ace04>] inode_setattr+0x11b/0x125
 [<ffffffffa04fa341>] ext4_setattr+0x26c/0x2ef [ext4]
 [<ffffffff802acfa2>] notify_change+0x194/0x2d6
 [<ffffffff8029a0c1>] do_truncate+0x63/0x81
 [<ffffffff802a21b5>] ? get_write_access+0x18/0x41
 [<ffffffff802a38a1>] may_open+0x1a8/0x1ff
 [<ffffffff802a5ead>] do_filp_open+0x429/0x817
 [<ffffffff8033a006>] ? __strncpy_from_user+0x1b/0x45
 [<ffffffff802996f1>] do_sys_open+0x53/0xd3
 [<ffffffff8029979a>] sys_open+0x1b/0x1d
 [<ffffffff8020bddb>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#7 stuck for 61s! [dd:28513]
Modules linked in: ext4 jbd2 crc16 ftl mtd_blkdevs mtdchar mtdram mtd
igb autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 ib_ipoib ib_sa
inet_lro ib_uverbs ib_umad ib_mthca ib_mad ib_core dm_multipath rfkill
input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp
parport sg i2c_i801 serio_raw button i2c_core shpchp pcspkr
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix
libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last
unloaded: e1000e]
Modules linked in: ext4 jbd2 crc16 ftl mtd_blkdevs mtdchar mtdram mtd
igb autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 ib_ipoib ib_sa
inet_lro ib_uverbs ib_umad ib_mthca ib_mad ib_core dm_multipath rfkill
input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp
parport sg i2c_i801 serio_raw button i2c_core shpchp pcspkr
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix
libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last
unloaded: e1000e]
Call Trace:
 [<ffffffff802b866d>] ? unlock_buffer+0x12/0x14
 [<ffffffffa04d97db>] do_get_write_access+0x2c5/0x3eb [jbd2]
 [<ffffffff802b7d7a>] ? __getblk+0x28/0x227
 [<ffffffffa04d9923>] jbd2_journal_get_write_access+0x22/0x33 [jbd2]
 [<ffffffffa050952e>] __ext4_journal_get_write_access+0x1f/0x48 [ext4]
 [<ffffffffa051035a>] ext4_mb_mark_diskspace_used+0x72/0x392 [ext4]
 [<ffffffffa0510844>] ext4_mb_new_blocks+0x1ca/0x376 [ext4]
 [<ffffffffa05091e1>] ext4_ext_get_blocks+0xb96/0xda1 [ext4]
 [<ffffffff8027ac28>] ? zone_statistics+0x60/0x65
 [<ffffffff804ad9f8>] ? __down_write_nested+0x17/0x92
 [<ffffffff804ada97>] ? __down_read+0x17/0x92
 [<ffffffffa04f77f2>] ext4_get_blocks_wrap+0xf1/0x210 [ext4]
 [<ffffffffa04f7bda>] ext4_get_block+0xb4/0xf2 [ext4]
[<ffffffff802be21f>] __blockdev_direct_IO+0x50a/0xa08
 [<ffffffffa04f9ff0>] ext4_direct_IO+0x105/0x1ea [ext4]
[<ffffffffa04f7b26>] ? ext4_get_block+0x0/0xf2 [ext4]
 [<ffffffff8026f07e>] generic_file_direct_write+0xd7/0x18d
 [<ffffffff8026f3c8>] __generic_file_aio_write_nolock+0x294/0x3bc
 [<ffffffff8027b15e>] ? __inc_zone_page_state+0x29/0x2b
 [<ffffffff8026f708>] generic_file_aio_write+0x64/0xc0
 [<ffffffffa04f3941>] ext4_file_write+0xa4/0x12f [ext4]
 [<ffffffff8029af28>] do_sync_write+0xe2/0x126
 [<ffffffff8024b078>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff80339fc9>] ? __clear_user+0x2e/0x50
 [<ffffffff80339fad>] ? __clear_user+0x12/0x50
 [<ffffffff803049f5>] ? security_file_permission+0x11/0x13
 [<ffffffff8029b6d0>] vfs_write+0xae/0x137
 [<ffffffff8029bb79>] sys_write+0x47/0x6f
 [<ffffffff8020bddb>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#2 stuck for 61s! [dd:28536]
Modules linked in: ext4 jbd2 crc16 ftl mtd_blkdevs mtdchar mtdram mtd
igb autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 ib_ipoib ib_sa
inet_lro ib_uverbs ib_umad ib_mthca ib_mad ib_core dm_multipath rfkill
input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp
parport sg i2c_i801 serio_raw button i2c_core shpchp pcspkr
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix
libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last
unloaded: e1000e]
Modules linked in: ext4 jbd2 crc16 ftl mtd_blkdevs mtdchar mtdram mtd
igb autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 ib_ipoib ib_sa
inet_lro ib_uverbs ib_umad ib_mthca ib_mad ib_core dm_multipath rfkill
input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp
parport sg i2c_i801 serio_raw button i2c_core shpchp pcspkr
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix
libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last
unloaded: e1000e]
Call Trace:
 [<ffffffff802b866d>] ? unlock_buffer+0x12/0x14

...

The file system was created from a ram-based MTD device (but also
occurs w/ a real SSD that understands discards):

# modprobe mtdram total_size=2000000
# modprobe mtdchar
# cd mtd-utils/
# ./ftl_format /dev/mtd0
Partition size = 3805696 kb, erase unit size = 128 kb, 1 transfer units
Reserved 5%, formatted size = -464495104 bytes
Erasing all blocks...
+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*
 +++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*++++++
 +*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*++++
 +++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*++
 +++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*++++
Writing erase unit headers...
format successful.
# modprobe ftl
# mkfs.ext4 /dev/ftla
# mount -t ext4 /dev/ftla /mnt

(then "cd /mnt" and run the "dd" loop at the top.)

Note that if the "foo" files are rm'd before launching the DD to
overwrite them, the problem does not reproduce.

FAT file systems, which also support discards, didn't repeat this behavior.

I've also seen successive iterations act as if the disk is full...
i.e. overwriting the file should make the disk space free that the
file was occupying, but sometimes it acts as though it hasn't deleted
the file's current blocks before starting the write and gives up as if
the disk is full.

Chris
