From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12896] ext3 FS problem or harddisk problem?
Date: Sun, 22 Mar 2009 16:37:05 -0700 (PDT)
Message-ID: <20090322233706.28427108040@picon.linux-foundation.org>
References: <bug-12896-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756635AbZCVXhq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Mar 2009 19:37:46 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2MNb6pM025007
	for <linux-ext4@vger.kernel.org>; Sun, 22 Mar 2009 16:37:42 -0700
In-Reply-To: <bug-12896-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12896


htmldeveloper@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |htmldeveloper@gmail.com




------- Comment #2 from htmldeveloper@gmail.com  2009-03-22 16:37 -------
The /var/log/messages are as follows:

(COmments:   hardware pluggin at about 16:45hours, and noticed the
autoremounting at about 17:05hours, no pluging out of harddisk done, physical
removal preceded by umounting was finally done at 17:22hours)

Mar 20 15:35:35 localhost kernel: end_request: I/O error, dev fd0, sector 0
Mar 20 15:35:47 localhost kernel: end_request: I/O error, dev fd0, sector 0
Mar 20 15:35:47 localhost kernel: Buffer I/O error on device fd0, logical block
0
Mar 20 15:35:59 localhost kernel: end_request: I/O error, dev fd0, sector 0
Mar 20 15:35:59 localhost kernel: Buffer I/O error on device fd0, logical block
0
Mar 20 15:36:13 localhost kernel: end_request: I/O error, dev fd0, sector 0
Mar 20 15:36:26 localhost kernel: end_request: I/O error, dev fd0, sector 0
Mar 20 15:36:26 localhost kernel: Buffer I/O error on device fd0, logical block
0
Mar 20 15:36:38 localhost kernel: end_request: I/O error, dev fd0, sector 0
Mar 20 15:36:38 localhost kernel: Buffer I/O error on device fd0, logical block
0
Mar 20 16:45:57 localhost kernel: usb 1-6: new high speed USB device using
ehci_hcd and address 4
Mar 20 16:45:57 localhost kernel: usb 1-6: New USB device found, idVendor=1058,
idProduct=1010
Mar 20 16:45:57 localhost kernel: usb 1-6: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Mar 20 16:45:57 localhost kernel: usb 1-6: Product: External HDD    
Mar 20 16:45:57 localhost kernel: usb 1-6: Manufacturer: Western Digital 
Mar 20 16:45:57 localhost kernel: usb 1-6: SerialNumber:
575845383037353330303332
Mar 20 16:45:57 localhost kernel: usb 1-6: configuration #1 chosen from 1
choice
Mar 20 16:45:57 localhost kernel: scsi9 : SCSI emulation for USB Mass Storage
devices
Mar 20 16:46:02 localhost kernel: scsi 9:0:0:0: Direct-Access     WD      
1600BEAExternal  1.02 PQ: 0 ANSI: 0
Mar 20 16:46:02 localhost kernel: sd 9:0:0:0: [sde] 312581808 512-byte hardware
sectors: (160 GB/149 GiB)
Mar 20 16:46:02 localhost kernel: sd 9:0:0:0: [sde] Write Protect is off
Mar 20 16:46:02 localhost kernel: sd 9:0:0:0: [sde] Assuming drive cache: write
through
Mar 20 16:46:02 localhost kernel: sd 9:0:0:0: [sde] 312581808 512-byte hardware
sectors: (160 GB/149 GiB)
Mar 20 16:46:02 localhost kernel: sd 9:0:0:0: [sde] Write Protect is off
Mar 20 16:46:02 localhost kernel: sd 9:0:0:0: [sde] Assuming drive cache: write
through
Mar 20 16:46:02 localhost kernel: sde: sde1 sde2 sde3 < sde5 > sde4
Mar 20 16:46:02 localhost kernel: sd 9:0:0:0: [sde] Attached SCSI disk
Mar 20 16:46:02 localhost kernel: sd 9:0:0:0: Attached scsi generic sg5 type 0
Mar 20 16:46:04 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 16:46:04 localhost kernel: EXT3 FS on sde1, internal journal
Mar 20 16:46:04 localhost kernel: EXT3-fs: recovery complete.
Mar 20 16:46:04 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 16:46:04 localhost hald: mounted /dev/sde1 on behalf of uid 0
Mar 20 16:46:04 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 16:46:04 localhost kernel: EXT3 FS on sde4, internal journal
Mar 20 16:46:04 localhost kernel: EXT3-fs: recovery complete.
Mar 20 16:46:04 localhost hald: mounted /dev/sde4 on behalf of uid 0
Mar 20 16:46:04 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 16:46:04 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 16:46:04 localhost kernel: EXT3 FS on sde2, internal journal
Mar 20 16:46:04 localhost kernel: EXT3-fs: recovery complete.
Mar 20 16:46:04 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 16:46:04 localhost hald: mounted /dev/sde2 on behalf of uid 0
Mar 20 16:46:05 localhost kernel: CIFS VFS: No response for cmd 114 mid 13309
Mar 20 16:46:06 localhost ntfs-3g[30323]: Version 2009.1.1 integrated FUSE 27
Mar 20 16:46:06 localhost ntfs-3g[30323]: Mounted /dev/sde5 (Read-Write, label
"", NTFS 3.1)
Mar 20 16:46:06 localhost ntfs-3g[30323]: Cmdline options:
rw,nosuid,nodev,uhelper=hal,locale=en_US.UTF-8
Mar 20 16:46:06 localhost ntfs-3g[30323]: Mount options:
rw,nosuid,nodev,uhelper=hal,silent,allow_other,nonempty,relatime,fsname=/dev/sde5,blkdev,blksize=4096
Mar 20 16:46:06 localhost hald: mounted /dev/sde5 on behalf of uid 0
Mar 20 16:46:47 localhost kernel: usb 1-6: USB disconnect, address 4
Mar 20 16:46:48 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sde5 as enclosing drive was disconnected
Mar 20 16:46:48 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sde4 as enclosing drive was disconnected
Mar 20 16:46:48 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sde2 as enclosing drive was disconnected
Mar 20 16:46:48 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sde1 as enclosing drive was disconnected
Mar 20 16:46:48 localhost hald: unmounted /dev/sde4 from '/media/_1' on behalf
of uid 0
Mar 20 16:46:48 localhost hald: unmounted /dev/sde1 from '/media/disk' on
behalf of uid 0
Mar 20 16:46:48 localhost ntfs-3g[30323]: Unmounting /dev/sde5 ()
Mar 20 16:46:48 localhost hald: unmounted /dev/sde5 from '/media/disk-2' on
behalf of uid 0
Mar 20 16:46:48 localhost hald: unmounted /dev/sde2 from '/media/disk-1' on
behalf of uid 0
Mar 20 16:46:53 localhost kernel: usb 1-6: new high speed USB device using
ehci_hcd and address 5
Mar 20 16:46:53 localhost kernel: usb 1-6: New USB device found, idVendor=1058,
idProduct=1010
Mar 20 16:46:53 localhost kernel: usb 1-6: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Mar 20 16:46:53 localhost kernel: usb 1-6: Product: External HDD    
Mar 20 16:46:53 localhost kernel: usb 1-6: Manufacturer: Western Digital 
Mar 20 16:46:53 localhost kernel: usb 1-6: SerialNumber:
575845383037353330303332
Mar 20 16:46:53 localhost kernel: usb 1-6: configuration #1 chosen from 1
choice
Mar 20 16:46:53 localhost kernel: scsi10 : SCSI emulation for USB Mass Storage
devices
Mar 20 16:46:58 localhost kernel: scsi 10:0:0:0: Direct-Access     WD      
1600BEAExternal  1.02 PQ: 0 ANSI: 0
Mar 20 16:46:58 localhost kernel: sd 10:0:0:0: [sdf] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 16:46:58 localhost kernel: sd 10:0:0:0: [sdf] Write Protect is off
Mar 20 16:46:58 localhost kernel: sd 10:0:0:0: [sdf] Assuming drive cache:
write through
Mar 20 16:46:58 localhost kernel: sd 10:0:0:0: [sdf] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 16:46:58 localhost kernel: sd 10:0:0:0: [sdf] Write Protect is off
Mar 20 16:46:58 localhost kernel: sd 10:0:0:0: [sdf] Assuming drive cache:
write through
Mar 20 16:46:58 localhost kernel: sdf: sdf1 sdf2 sdf3 < sdf5 > sdf4
Mar 20 16:46:58 localhost kernel: sd 10:0:0:0: [sdf] Attached SCSI disk
Mar 20 16:46:58 localhost kernel: sd 10:0:0:0: Attached scsi generic sg5 type 0
Mar 20 16:47:00 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 16:47:00 localhost kernel: EXT3 FS on sdf4, internal journal
Mar 20 16:47:00 localhost kernel: EXT3-fs: recovery complete.
Mar 20 16:47:00 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 16:47:00 localhost hald: mounted /dev/sdf4 on behalf of uid 0
Mar 20 16:47:00 localhost kernel: EXT3-fs error (device sde1):
ext3_get_inode_loc: unable to read inode block - inode=2, block=1027
Mar 20 16:47:00 localhost kernel: EXT3-fs error (device sde1) in
ext3_reserve_inode_write: IO failure
Mar 20 16:47:00 localhost kernel: ------------[ cut here ]------------
Mar 20 16:47:00 localhost kernel: WARNING: at fs/buffer.c:1251
mark_buffer_dirty+0x34/0x86()
Mar 20 16:47:00 localhost kernel: Hardware name: System Product Name
Mar 20 16:47:00 localhost kernel: Modules linked in: vfat fat usb_storage
nls_utf8 cifs ipt_MASQUERADE iptable_nat nf_nat sco bridge stp bnep l2cap
bluetooth sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6
ext2 ext4 jbd2 crc16 fuse dm_multipath uinput snd_mpu401 snd_intel8x0
snd_mpu401_uart snd_ac97_codec ac97_bus snd_seq_dummy snd_rawmidi snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_seq_device snd_pcm
ppdev snd_timer parport_pc snd ns558 i2c_nforce2 firewire_ohci sata_sil24
i2c_core floppy k8temp hwmon parport forcedeth sky2 firewire_core pcspkr
crc_itu_t gameport snd_page_alloc soundcore sata_nv ata_generic pata_acpi
pata_amd [last unloaded: freq_table]
Mar 20 16:47:00 localhost kernel: Pid: 30504, comm: ls Not tainted 2.6.29-rc8
#23
Mar 20 16:47:00 localhost kernel: Call Trace:
Mar 20 16:47:00 localhost kernel: [<ffffffff81049c06>] warn_slowpath+0xb6/0xf2
Mar 20 16:47:00 localhost kernel: [<ffffffff810978d0>] ?
trace_hardirqs_off+0x2b/0x2d
Mar 20 16:47:00 localhost kernel: [<ffffffff81381e3d>] ?
_spin_unlock_irqrestore+0x2c/0x43
Mar 20 16:47:00 localhost kernel: [<ffffffff8112edf3>] ? ext3_error+0x7b/0x86
Mar 20 16:47:00 localhost kernel: [<ffffffff810ed89a>]
mark_buffer_dirty+0x34/0x86
Mar 20 16:47:00 localhost kernel: [<ffffffff8112d3fe>]
ext3_commit_super+0x55/0x6f
Mar 20 16:47:00 localhost kernel: [<ffffffff8112ece4>]
ext3_handle_error+0x8b/0xb2
Mar 20 16:47:00 localhost kernel: [<ffffffff8112ed70>]
__ext3_std_error+0x65/0x6d
Mar 20 16:47:00 localhost kernel: [<ffffffff81125fcf>]
ext3_reserve_inode_write+0x70/0x7b
Mar 20 16:47:00 localhost kernel: [<ffffffff8112601a>]
ext3_mark_inode_dirty+0x40/0x5d
Mar 20 16:47:00 localhost kernel: [<ffffffff81126185>]
ext3_dirty_inode+0x71/0x88
Mar 20 16:47:00 localhost kernel: [<ffffffff810e9351>]
__mark_inode_dirty+0x38/0x193
Mar 20 16:47:00 localhost kernel: [<ffffffff810db041>] ? filldir+0x0/0xc2
Mar 20 16:47:00 localhost kernel: [<ffffffff810dfb16>] touch_atime+0xf6/0x101
Mar 20 16:47:00 localhost kernel: [<ffffffff810db266>] vfs_readdir+0x97/0xb4
Mar 20 16:47:00 localhost kernel: [<ffffffff810db3cf>] sys_getdents+0x86/0xe3
Mar 20 16:47:00 localhost kernel: [<ffffffff8101152a>]
system_call_fastpath+0x16/0x1b
Mar 20 16:47:00 localhost kernel: ---[ end trace 130e197f0f1f07f6 ]---
Mar 20 16:47:00 localhost ntfs-3g[30507]: Version 2009.1.1 integrated FUSE 27
Mar 20 16:47:00 localhost ntfs-3g[30507]: Mounted /dev/sdf5 (Read-Write, label
"", NTFS 3.1)
Mar 20 16:47:00 localhost ntfs-3g[30507]: Cmdline options:
rw,nosuid,nodev,uhelper=hal,locale=en_US.UTF-8
Mar 20 16:47:00 localhost ntfs-3g[30507]: Mount options:
rw,nosuid,nodev,uhelper=hal,silent,allow_other,nonempty,relatime,fsname=/dev/sdf5,blkdev,blksize=4096
Mar 20 16:47:00 localhost hald: mounted /dev/sdf5 on behalf of uid 0
Mar 20 16:47:01 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 16:47:01 localhost kernel: EXT3 FS on sdf1, internal journal
Mar 20 16:47:01 localhost kernel: EXT3-fs: recovery complete.
Mar 20 16:47:01 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 16:47:01 localhost hald: mounted /dev/sdf1 on behalf of uid 0
Mar 20 16:47:01 localhost kernel: usb 1-6: USB disconnect, address 5
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Unhandled error code
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 16:47:01 localhost kernel: end_request: I/O error, dev sdf, sector
172297948
Mar 20 16:47:01 localhost kernel: EXT3-fs error (device sdf4):
ext3_get_inode_loc: unable to read inode block - inode=1771302, block=1769261
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Unhandled error code
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 16:47:01 localhost kernel: end_request: I/O error, dev sdf, sector 12367
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Unhandled error code
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 16:47:01 localhost kernel: end_request: I/O error, dev sdf, sector
80019765
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Unhandled error code
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 16:47:01 localhost kernel: end_request: I/O error, dev sdf, sector
158143860
Mar 20 16:47:01 localhost kernel: Buffer I/O error on device sdf4, logical
block 0
Mar 20 16:47:01 localhost kernel: lost page write due to I/O error on sdf4
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Unhandled error code
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 16:47:01 localhost kernel: end_request: I/O error, dev sdf, sector 12367
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Unhandled error code
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 16:47:01 localhost kernel: end_request: I/O error, dev sdf, sector 12367
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Unhandled error code
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 16:47:01 localhost kernel: end_request: I/O error, dev sdf, sector
213704836
Mar 20 16:47:01 localhost kernel: EXT3-fs error (device sdf4):
ext3_get_inode_loc: unable to read inode block - inode=6926465, block=6945122
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Unhandled error code
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 16:47:01 localhost kernel: end_request: I/O error, dev sdf, sector 12367
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Unhandled error code
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 16:47:01 localhost kernel: end_request: I/O error, dev sdf, sector
158143860
Mar 20 16:47:01 localhost kernel: Buffer I/O error on device sdf4, logical
block 0
Mar 20 16:47:01 localhost kernel: lost page write due to I/O error on sdf4
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Unhandled error code
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 16:47:01 localhost kernel: end_request: I/O error, dev sdf, sector 12367
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Unhandled error code
Mar 20 16:47:01 localhost kernel: sd 10:0:0:0: [sdf] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 16:47:01 localhost kernel: end_request: I/O error, dev sdf, sector 12367
Mar 20 16:47:01 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sdf5 as enclosing drive was disconnected
Mar 20 16:47:01 localhost kernel: Aborting journal on device sdf4.
Mar 20 16:47:01 localhost kernel: journal commit I/O error
Mar 20 16:47:01 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sdf4 as enclosing drive was disconnected
Mar 20 16:47:01 localhost kernel: EXT3-fs error (device sdf4): ext3_find_entry:
reading directory #2 offset 0
Mar 20 16:47:01 localhost kernel: EXT3-fs: Can't read superblock on 2nd try.
Mar 20 16:47:01 localhost kernel: Aborting journal on device sdf1.
Mar 20 16:47:01 localhost kernel: journal commit I/O error
Mar 20 16:47:01 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sdf1 as enclosing drive was disconnected
Mar 20 16:47:01 localhost ntfs-3g[30507]: Unmounting /dev/sdf5 ()
Mar 20 16:47:01 localhost hald: unmounted /dev/sdf5 from '/media/disk' on
behalf of uid 0
Mar 20 16:47:01 localhost kernel: ext3_abort called.
Mar 20 16:47:01 localhost kernel: EXT3-fs error (device sdf1): ext3_put_super:
Couldn't clean up the journal
Mar 20 16:47:01 localhost kernel: Remounting filesystem read-only
Mar 20 16:47:01 localhost hald: unmounted /dev/sdf1 from '/media/disk-1' on
behalf of uid 0
Mar 20 16:47:01 localhost kernel: ext3_abort called.
Mar 20 16:47:01 localhost kernel: EXT3-fs error (device sdf4): ext3_put_super:
Couldn't clean up the journal
Mar 20 16:47:01 localhost kernel: Remounting filesystem read-only
Mar 20 16:47:01 localhost hald: unmounted /dev/sdf4 from '/media/_1' on behalf
of uid 0
Mar 20 16:47:05 localhost kernel: journal_bmap: journal block not found at
offset 14 on sde1
Mar 20 16:47:05 localhost kernel: Aborting journal on device sde1.
Mar 20 16:47:07 localhost kernel: usb 1-6: new high speed USB device using
ehci_hcd and address 6
Mar 20 16:47:07 localhost kernel: usb 1-6: New USB device found, idVendor=1058,
idProduct=1010
Mar 20 16:47:07 localhost kernel: usb 1-6: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Mar 20 16:47:07 localhost kernel: usb 1-6: Product: External HDD    
Mar 20 16:47:07 localhost kernel: usb 1-6: Manufacturer: Western Digital 
Mar 20 16:47:07 localhost kernel: usb 1-6: SerialNumber:
575845383037353330303332
Mar 20 16:47:07 localhost kernel: usb 1-6: configuration #1 chosen from 1
choice
Mar 20 16:47:07 localhost kernel: scsi11 : SCSI emulation for USB Mass Storage
devices
Mar 20 16:47:12 localhost kernel: usb 1-6: reset high speed USB device using
ehci_hcd and address 6
Mar 20 16:47:12 localhost kernel: scsi 11:0:0:0: Direct-Access     WD      
1600BEAExternal  1.02 PQ: 0 ANSI: 0
Mar 20 16:47:12 localhost kernel: sd 11:0:0:0: [sdf] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 16:47:12 localhost kernel: sd 11:0:0:0: [sdf] Write Protect is off
Mar 20 16:47:12 localhost kernel: sd 11:0:0:0: [sdf] Assuming drive cache:
write through
Mar 20 16:47:12 localhost kernel: sd 11:0:0:0: [sdf] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 16:47:12 localhost kernel: sd 11:0:0:0: [sdf] Write Protect is off
Mar 20 16:47:12 localhost kernel: sd 11:0:0:0: [sdf] Assuming drive cache:
write through
Mar 20 16:47:12 localhost kernel: sdf: sdf1 sdf2 sdf3 < sdf5 > sdf4
Mar 20 16:47:12 localhost kernel: sd 11:0:0:0: [sdf] Attached SCSI disk
Mar 20 16:47:12 localhost kernel: sd 11:0:0:0: Attached scsi generic sg5 type 0
Mar 20 16:47:13 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 16:47:13 localhost kernel: EXT3 FS on sdf1, internal journal
Mar 20 16:47:13 localhost kernel: EXT3-fs: recovery complete.
Mar 20 16:47:13 localhost hald: mounted /dev/sdf1 on behalf of uid 0
Mar 20 16:47:13 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 16:47:13 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 16:47:13 localhost kernel: EXT3 FS on sdf4, internal journal
Mar 20 16:47:13 localhost kernel: EXT3-fs: recovery complete.
Mar 20 16:47:13 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 16:47:13 localhost hald: mounted /dev/sdf4 on behalf of uid 0
Mar 20 16:47:15 localhost ntfs-3g[30663]: Version 2009.1.1 integrated FUSE 27
Mar 20 16:47:15 localhost ntfs-3g[30663]: Mounted /dev/sdf5 (Read-Write, label
"", NTFS 3.1)
Mar 20 16:47:15 localhost ntfs-3g[30663]: Cmdline options:
rw,nosuid,nodev,uhelper=hal,locale=en_US.UTF-8
Mar 20 16:47:15 localhost ntfs-3g[30663]: Mount options:
rw,nosuid,nodev,uhelper=hal,silent,allow_other,nonempty,relatime,fsname=/dev/sdf5,blkdev,blksize=4096
Mar 20 16:47:15 localhost hald: mounted /dev/sdf5 on behalf of uid 0
Mar 20 16:47:15 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 16:47:15 localhost kernel: EXT3 FS on sdf2, internal journal
Mar 20 16:47:15 localhost kernel: EXT3-fs: recovery complete.
Mar 20 16:47:15 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 16:47:15 localhost hald: mounted /dev/sdf2 on behalf of uid 0
Mar 20 16:47:46 localhost kerneloops: Submitted 1 kernel oopses to
www.kerneloops.org
Mar 20 16:48:56 localhost kernel: ext3_abort called.
Mar 20 16:48:56 localhost kernel: EXT3-fs error (device sde1):
ext3_journal_start_sb: Detected aborted journal
Mar 20 16:48:56 localhost kernel: Remounting filesystem read-only
Mar 20 16:49:08 localhost kernel: ext3_abort called.
Mar 20 16:49:08 localhost kernel: EXT3-fs error (device sde1): ext3_put_super:
Couldn't clean up the journal
Mar 20 17:00:37 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 17:00:37 localhost hald: mounted /dev/sdf1 on behalf of uid 0
Mar 20 17:00:37 localhost kernel: EXT3 FS on sdf1, internal journal
Mar 20 17:00:37 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 17:04:47 localhost kernel: usb 1-6: USB disconnect, address 6
Mar 20 17:04:47 localhost kernel: sd 11:0:0:0: [sdf] Unhandled error code
Mar 20 17:04:47 localhost kernel: sd 11:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:04:47 localhost kernel: end_request: I/O error, dev sdf, sector
187007348
Mar 20 17:04:47 localhost kernel: sd 11:0:0:0: [sdf] Unhandled error code
Mar 20 17:04:47 localhost kernel: sd 11:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:04:47 localhost kernel: end_request: I/O error, dev sdf, sector
187007588
Mar 20 17:04:47 localhost kernel: sd 11:0:0:0: [sdf] Unhandled error code
Mar 20 17:04:47 localhost kernel: sd 11:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:04:47 localhost kernel: end_request: I/O error, dev sdf, sector
187007604
Mar 20 17:04:47 localhost kernel: sd 11:0:0:0: [sdf] Unhandled error code
Mar 20 17:04:47 localhost kernel: sd 11:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:04:47 localhost kernel: end_request: I/O error, dev sdf, sector
187007844
Mar 20 17:04:47 localhost kernel: sd 11:0:0:0: [sdf] Unhandled error code
Mar 20 17:04:47 localhost kernel: sd 11:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:04:47 localhost kernel: end_request: I/O error, dev sdf, sector
187007348
Mar 20 17:04:47 localhost kernel: ext3_journal_dirty_data: aborting
transaction: IO failure in ext3_journal_dirty_data
Mar 20 17:04:47 localhost kernel: EXT3-fs error (device sdf2) in
ext3_ordered_writepage: IO failure
Mar 20 17:04:47 localhost kernel: ext3_journal_dirty_data: aborting
transaction: IO failure in ext3_journal_dirty_data
Mar 20 17:04:47 localhost kernel: EXT3-fs error (device sdf2) in
ext3_ordered_writepage: IO failure
Mar 20 17:04:47 localhost kernel: Aborting journal on device sdf4.
Mar 20 17:04:47 localhost kernel: journal commit I/O error
Mar 20 17:04:47 localhost kernel: ext3_journal_dirty_data: aborting
transaction: IO failure in ext3_journal_dirty_data
Mar 20 17:04:47 localhost kernel: EXT3-fs error (device sdf2) in
ext3_ordered_writepage: IO failure
Mar 20 17:04:47 localhost kernel: ext3_journal_dirty_data: aborting
transaction: IO failure in ext3_journal_dirty_data
Mar 20 17:04:47 localhost kernel: EXT3-fs error (device sdf2) in
ext3_ordered_writepage: IO failure
Mar 20 17:04:47 localhost kernel: ext3_journal_dirty_data: aborting
transaction: IO failure in ext3_journal_dirty_data
Mar 20 17:04:47 localhost kernel: EXT3-fs error (device sdf2) in
ext3_ordered_writepage: IO failure
Mar 20 17:04:47 localhost kernel: ext3_journal_dirty_data: aborting
transaction: IO failure in ext3_journal_dirty_data
Mar 20 17:04:47 localhost kernel: EXT3-fs error (device sdf2) in
ext3_ordered_writepage: IO failure
Mar 20 17:04:47 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sdf5 as enclosing drive was disconnected
Mar 20 17:04:47 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sdf4 as enclosing drive was disconnected
Mar 20 17:04:48 localhost kernel: JBD: Detected IO errors while flushing file
data on sdf2
Mar 20 17:04:48 localhost kernel: Aborting journal on device sdf2.
Mar 20 17:04:48 localhost hald: unmounted /dev/sdf4 from '/media/_1' on behalf
of uid 0
Mar 20 17:04:48 localhost ntfs-3g[30663]: Unmounting /dev/sdf5 ()
Mar 20 17:04:48 localhost hald: unmounted /dev/sdf5 from '/media/disk-1' on
behalf of uid 0
Mar 20 17:04:48 localhost kernel: JBD: Detected IO errors while flushing file
data on sdf2
Mar 20 17:04:48 localhost kernel: __journal_remove_journal_head: freeing
b_committed_data
Mar 20 17:04:48 localhost kernel: __journal_remove_journal_head: freeing
b_committed_data
Mar 20 17:04:48 localhost kernel: __journal_remove_journal_head: freeing
b_committed_data
Mar 20 17:04:48 localhost kernel: journal commit I/O error
Mar 20 17:04:48 localhost kernel: ext3_abort called.
Mar 20 17:04:48 localhost kernel: EXT3-fs error (device sdf2):
ext3_journal_start_sb: Detected aborted journal
Mar 20 17:04:48 localhost kernel: Remounting filesystem read-only
Mar 20 17:04:48 localhost gnome-keyring-daemon[2886]: Error retrieving
volume.is_mounted on
'/org/freedesktop/Hal/devices/volume_uuid_77BCDF994BB0A751': Error:
'org.freedesktop.Hal.NoSuchDevice' Message: 'No device with id
/org/freedesktop/Hal/devices/volume_uuid_77BCDF994BB0A751'
Mar 20 17:04:48 localhost kernel: __journal_remove_journal_head: freeing
b_committed_data
Mar 20 17:04:48 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sdf1 as enclosing drive was disconnected
Mar 20 17:04:48 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sdf2 as enclosing drive was disconnected
Mar 20 17:04:48 localhost hald: unmounted /dev/sdf1 from '/media/disk' on
behalf of uid 0
Mar 20 17:04:48 localhost kernel: ext3_abort called.
Mar 20 17:04:48 localhost kernel: EXT3-fs error (device sdf2): ext3_put_super:
Couldn't clean up the journal
Mar 20 17:04:48 localhost hald: unmounted /dev/sdf2 from '/media/disk-2' on
behalf of uid 0
Mar 20 17:04:53 localhost kernel: usb 1-6: new high speed USB device using
ehci_hcd and address 7
Mar 20 17:04:53 localhost kernel: usb 1-6: New USB device found, idVendor=1058,
idProduct=1010
Mar 20 17:04:53 localhost kernel: usb 1-6: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Mar 20 17:04:53 localhost kernel: usb 1-6: Product: External HDD    
Mar 20 17:04:53 localhost kernel: usb 1-6: Manufacturer: Western Digital 
Mar 20 17:04:53 localhost kernel: usb 1-6: SerialNumber:
575845383037353330303332
Mar 20 17:04:53 localhost kernel: usb 1-6: configuration #1 chosen from 1
choice
Mar 20 17:04:53 localhost kernel: scsi12 : SCSI emulation for USB Mass Storage
devices
Mar 20 17:04:58 localhost kernel: usb 1-6: reset high speed USB device using
ehci_hcd and address 7
Mar 20 17:04:58 localhost kernel: scsi 12:0:0:0: Direct-Access     WD      
1600BEAExternal  1.02 PQ: 0 ANSI: 0
Mar 20 17:04:58 localhost kernel: sd 12:0:0:0: [sde] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 17:04:58 localhost kernel: sd 12:0:0:0: [sde] Write Protect is off
Mar 20 17:04:58 localhost kernel: sd 12:0:0:0: [sde] Assuming drive cache:
write through
Mar 20 17:04:58 localhost kernel: sd 12:0:0:0: [sde] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 17:04:58 localhost kernel: sd 12:0:0:0: [sde] Write Protect is off
Mar 20 17:04:58 localhost kernel: sd 12:0:0:0: [sde] Assuming drive cache:
write through
Mar 20 17:04:58 localhost kernel: sde: sde1 sde2 sde3 < sde5 > sde4
Mar 20 17:04:58 localhost kernel: sd 12:0:0:0: [sde] Attached SCSI disk
Mar 20 17:04:58 localhost kernel: sd 12:0:0:0: Attached scsi generic sg5 type 0
Mar 20 17:04:59 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 17:04:59 localhost kernel: EXT3 FS on sde1, internal journal
Mar 20 17:04:59 localhost kernel: EXT3-fs: recovery complete.
Mar 20 17:04:59 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 17:04:59 localhost hald: mounted /dev/sde1 on behalf of uid 0
Mar 20 17:05:00 localhost ntfs-3g[31010]: Version 2009.1.1 integrated FUSE 27
Mar 20 17:05:00 localhost hald: mounted /dev/sde5 on behalf of uid 0
Mar 20 17:05:00 localhost ntfs-3g[31010]: Mounted /dev/sde5 (Read-Write, label
"", NTFS 3.1)
Mar 20 17:05:00 localhost ntfs-3g[31010]: Cmdline options:
rw,nosuid,nodev,uhelper=hal,locale=en_US.UTF-8
Mar 20 17:05:00 localhost ntfs-3g[31010]: Mount options:
rw,nosuid,nodev,uhelper=hal,silent,allow_other,nonempty,relatime,fsname=/dev/sde5,blkdev,blksize=4096
Mar 20 17:05:01 localhost kernel: usb 1-6: USB disconnect, address 7
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Unhandled error code
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:01 localhost kernel: end_request: I/O error, dev sde, sector
177121908
Mar 20 17:05:01 localhost kernel: Buffer I/O error on device sde4, logical
block 2372256
Mar 20 17:05:01 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Unhandled error code
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:01 localhost kernel: end_request: I/O error, dev sde, sector
177130356
Mar 20 17:05:01 localhost kernel: Buffer I/O error on device sde4, logical
block 2373312
Mar 20 17:05:01 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Unhandled error code
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:01 localhost kernel: end_request: I/O error, dev sde, sector
177138556
Mar 20 17:05:01 localhost kernel: Buffer I/O error on device sde4, logical
block 2374337
Mar 20 17:05:01 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Unhandled error code
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:01 localhost kernel: end_request: I/O error, dev sde, sector
177147140
Mar 20 17:05:01 localhost kernel: Buffer I/O error on device sde4, logical
block 2375410
Mar 20 17:05:01 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Unhandled error code
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:01 localhost kernel: end_request: I/O error, dev sde, sector
177155340
Mar 20 17:05:01 localhost kernel: Buffer I/O error on device sde4, logical
block 2376435
Mar 20 17:05:01 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Unhandled error code
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:01 localhost kernel: end_request: I/O error, dev sde, sector
177164252
Mar 20 17:05:01 localhost kernel: Buffer I/O error on device sde4, logical
block 2377549
Mar 20 17:05:01 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Unhandled error code
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:01 localhost kernel: end_request: I/O error, dev sde, sector
177172452
Mar 20 17:05:01 localhost kernel: Buffer I/O error on device sde4, logical
block 2378574
Mar 20 17:05:01 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Unhandled error code
Mar 20 17:05:01 localhost kernel: sd 12:0:0:0: [sde] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:01 localhost kernel: end_request: I/O error, dev sde, sector
177181028
Mar 20 17:05:01 localhost kernel: Buffer I/O error on device sde4, logical
block 2379646
Mar 20 17:05:01 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:01 localhost kernel: JBD: recovery failed
Mar 20 17:05:01 localhost kernel: EXT3-fs: error loading journal.
Mar 20 17:05:01 localhost kernel: Aborting journal on device sde1.
Mar 20 17:05:01 localhost kernel: journal commit I/O error
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_attr_pread_i: ntfs_pread failed:
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: Error reading $Mft record(s):
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_mft_record_read failed:
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_attr_pread_i: ntfs_pread failed:
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: Error reading $Mft record(s):
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_mft_record_read failed:
Input/output error
Mar 20 17:05:01 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:05:01 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_attr_pread_i: ntfs_pread failed:
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: Error reading $Mft record(s):
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_mft_record_read failed:
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_attr_pread_i: ntfs_pread failed:
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: Error reading $Mft record(s):
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_mft_record_read failed:
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_attr_pread_i: ntfs_pread failed:
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: Error reading $Mft record(s):
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_mft_record_read failed:
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_attr_pread_i: ntfs_pread failed:
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: Error reading $Mft record(s):
Input/output error
Mar 20 17:05:01 localhost ntfs-3g[31010]: ntfs_mft_record_read failed:
Input/output error
Mar 20 17:05:01 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sde5 as enclosing drive was disconnected
Mar 20 17:05:01 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sde1 as enclosing drive was disconnected
Mar 20 17:05:01 localhost ntfs-3g[31010]: Unmounting /dev/sde5 ()
Mar 20 17:05:01 localhost hald: unmounted /dev/sde5 from '/media/disk-1' on
behalf of uid 0
Mar 20 17:05:01 localhost kernel: ext3_abort called.
Mar 20 17:05:01 localhost kernel: EXT3-fs error (device sde1): ext3_put_super:
Couldn't clean up the journal
Mar 20 17:05:01 localhost kernel: Remounting filesystem read-only
Mar 20 17:05:01 localhost hald: unmounted /dev/sde1 from '/media/disk' on
behalf of uid 0
Mar 20 17:05:06 localhost kernel: usb 1-6: new high speed USB device using
ehci_hcd and address 8
Mar 20 17:05:06 localhost kernel: usb 1-6: New USB device found, idVendor=1058,
idProduct=1010
Mar 20 17:05:06 localhost kernel: usb 1-6: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Mar 20 17:05:06 localhost kernel: usb 1-6: Product: External HDD    
Mar 20 17:05:06 localhost kernel: usb 1-6: Manufacturer: Western Digital 
Mar 20 17:05:06 localhost kernel: usb 1-6: SerialNumber:
575845383037353330303332
Mar 20 17:05:06 localhost kernel: usb 1-6: configuration #1 chosen from 1
choice
Mar 20 17:05:06 localhost kernel: scsi13 : SCSI emulation for USB Mass Storage
devices
Mar 20 17:05:11 localhost kernel: usb 1-6: reset high speed USB device using
ehci_hcd and address 8
Mar 20 17:05:11 localhost kernel: scsi 13:0:0:0: Direct-Access     WD      
1600BEAExternal  1.02 PQ: 0 ANSI: 0
Mar 20 17:05:11 localhost kernel: sd 13:0:0:0: [sde] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 17:05:11 localhost kernel: sd 13:0:0:0: [sde] Write Protect is off
Mar 20 17:05:11 localhost kernel: sd 13:0:0:0: [sde] Assuming drive cache:
write through
Mar 20 17:05:11 localhost kernel: sd 13:0:0:0: [sde] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 17:05:11 localhost kernel: sd 13:0:0:0: [sde] Write Protect is off
Mar 20 17:05:11 localhost kernel: sd 13:0:0:0: [sde] Assuming drive cache:
write through
Mar 20 17:05:11 localhost kernel: sde: sde1 sde2 sde3 < sde5 > sde4
Mar 20 17:05:11 localhost kernel: sd 13:0:0:0: [sde] Attached SCSI disk
Mar 20 17:05:11 localhost kernel: sd 13:0:0:0: Attached scsi generic sg5 type 0
Mar 20 17:05:13 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 17:05:13 localhost kernel: EXT3 FS on sde1, internal journal
Mar 20 17:05:13 localhost kernel: EXT3-fs: recovery complete.
Mar 20 17:05:13 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 17:05:13 localhost hald: mounted /dev/sde1 on behalf of uid 0
Mar 20 17:05:13 localhost kernel: usb 1-6: USB disconnect, address 8
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177172452
Mar 20 17:05:13 localhost kernel: Buffer I/O error on device sde4, logical
block 2378574
Mar 20 17:05:13 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177181028
Mar 20 17:05:13 localhost kernel: Buffer I/O error on device sde4, logical
block 2379646
Mar 20 17:05:13 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177189228
Mar 20 17:05:13 localhost kernel: Buffer I/O error on device sde4, logical
block 2380671
Mar 20 17:05:13 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177203852
Mar 20 17:05:13 localhost kernel: Buffer I/O error on device sde4, logical
block 2382499
Mar 20 17:05:13 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177218484
Mar 20 17:05:13 localhost kernel: Buffer I/O error on device sde4, logical
block 2384328
Mar 20 17:05:13 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177226692
Mar 20 17:05:13 localhost kernel: Buffer I/O error on device sde4, logical
block 2385354
Mar 20 17:05:13 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177241140
Mar 20 17:05:13 localhost kernel: Buffer I/O error on device sde4, logical
block 2387160
Mar 20 17:05:13 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177249516
Mar 20 17:05:13 localhost kernel: Buffer I/O error on device sde4, logical
block 2388207
Mar 20 17:05:13 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177257716
Mar 20 17:05:13 localhost kernel: Buffer I/O error on device sde4, logical
block 2389232
Mar 20 17:05:13 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177272564
Mar 20 17:05:13 localhost kernel: Buffer I/O error on device sde4, logical
block 2391088
Mar 20 17:05:13 localhost kernel: lost page write due to I/O error on sde4
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177275700
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177275716
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177288956
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177297156
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Unhandled error code
Mar 20 17:05:13 localhost kernel: sd 13:0:0:0: [sde] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:05:13 localhost kernel: end_request: I/O error, dev sde, sector
177305356
Mar 20 17:05:13 localhost kernel: JBD: recovery failed
Mar 20 17:05:13 localhost kernel: EXT3-fs: error loading journal.
Mar 20 17:05:13 localhost kernel: Aborting journal on device sde1.
Mar 20 17:05:13 localhost kernel: journal commit I/O error
Mar 20 17:05:13 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:05:13 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:05:13 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:05:13 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:05:13 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:05:13 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:05:13 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:05:13 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:05:14 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sde1 as enclosing drive was disconnected
Mar 20 17:05:14 localhost kernel: ext3_abort called.
Mar 20 17:05:14 localhost kernel: EXT3-fs error (device sde1): ext3_put_super:
Couldn't clean up the journal
Mar 20 17:05:14 localhost kernel: Remounting filesystem read-only
Mar 20 17:05:14 localhost hald: unmounted /dev/sde1 from '/media/disk' on
behalf of uid 0
Mar 20 17:05:19 localhost kernel: usb 1-6: new high speed USB device using
ehci_hcd and address 9
Mar 20 17:05:19 localhost kernel: usb 1-6: New USB device found, idVendor=1058,
idProduct=1010
Mar 20 17:05:19 localhost kernel: usb 1-6: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Mar 20 17:05:19 localhost kernel: usb 1-6: Product: External HDD    
Mar 20 17:05:19 localhost kernel: usb 1-6: Manufacturer: Western Digital 
Mar 20 17:05:19 localhost kernel: usb 1-6: SerialNumber:
575845383037353330303332
Mar 20 17:05:19 localhost kernel: usb 1-6: configuration #1 chosen from 1
choice
Mar 20 17:05:19 localhost kernel: scsi14 : SCSI emulation for USB Mass Storage
devices
Mar 20 17:05:24 localhost kernel: usb 1-6: reset high speed USB device using
ehci_hcd and address 9
Mar 20 17:05:24 localhost kernel: scsi 14:0:0:0: Direct-Access     WD      
1600BEAExternal  1.02 PQ: 0 ANSI: 0
Mar 20 17:05:24 localhost kernel: sd 14:0:0:0: [sde] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 17:05:24 localhost kernel: sd 14:0:0:0: [sde] Write Protect is off
Mar 20 17:05:24 localhost kernel: sd 14:0:0:0: [sde] Assuming drive cache:
write through
Mar 20 17:05:24 localhost kernel: sd 14:0:0:0: [sde] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 17:05:24 localhost kernel: sd 14:0:0:0: [sde] Write Protect is off
Mar 20 17:05:24 localhost kernel: sd 14:0:0:0: [sde] Assuming drive cache:
write through
Mar 20 17:05:24 localhost kernel: sde: sde1 sde2 sde3 < sde5 > sde4
Mar 20 17:05:24 localhost kernel: sd 14:0:0:0: [sde] Attached SCSI disk
Mar 20 17:05:24 localhost kernel: sd 14:0:0:0: Attached scsi generic sg5 type 0
Mar 20 17:05:25 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 17:05:25 localhost kernel: EXT3 FS on sde1, internal journal
Mar 20 17:05:25 localhost kernel: EXT3-fs: recovery complete.
Mar 20 17:05:25 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 17:05:25 localhost hald: mounted /dev/sde1 on behalf of uid 0
Mar 20 17:05:26 localhost ntfs-3g[31274]: Version 2009.1.1 integrated FUSE 27
Mar 20 17:05:26 localhost ntfs-3g[31274]: Mounted /dev/sde5 (Read-Write, label
"", NTFS 3.1)
Mar 20 17:05:26 localhost ntfs-3g[31274]: Cmdline options:
rw,nosuid,nodev,uhelper=hal,locale=en_US.UTF-8
Mar 20 17:05:26 localhost ntfs-3g[31274]: Mount options:
rw,nosuid,nodev,uhelper=hal,silent,allow_other,nonempty,relatime,fsname=/dev/sde5,blkdev,blksize=4096
Mar 20 17:05:26 localhost hald: mounted /dev/sde5 on behalf of uid 0
Mar 20 17:05:27 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 17:05:27 localhost kernel: EXT3 FS on sde2, internal journal
Mar 20 17:05:27 localhost kernel: EXT3-fs: recovery complete.
Mar 20 17:05:27 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 17:05:27 localhost hald: mounted /dev/sde2 on behalf of uid 0
Mar 20 17:05:31 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 17:05:31 localhost kernel: EXT3 FS on sde4, internal journal
Mar 20 17:05:31 localhost kernel: EXT3-fs: recovery complete.
Mar 20 17:05:31 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 17:05:31 localhost hald: mounted /dev/sde4 on behalf of uid 0
Mar 20 17:06:16 localhost kernel: ext3_abort called.
Mar 20 17:06:16 localhost kernel: EXT3-fs error (device sdf4):
ext3_journal_start_sb: Detected aborted journal
Mar 20 17:06:16 localhost kernel: Remounting filesystem read-only
Mar 20 17:06:17 localhost kernel: ext3_abort called.
Mar 20 17:06:17 localhost kernel: EXT3-fs error (device sdf4): ext3_put_super:
Couldn't clean up the journal
Mar 20 17:20:40 localhost kernel: usb 1-6: USB disconnect, address 9
Mar 20 17:20:40 localhost kernel: sd 14:0:0:0: [sde] Unhandled error code
Mar 20 17:20:40 localhost kernel: sd 14:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:20:40 localhost kernel: end_request: I/O error, dev sde, sector
8481079
Mar 20 17:20:40 localhost kernel: sd 14:0:0:0: [sde] Unhandled error code
Mar 20 17:20:40 localhost kernel: sd 14:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:20:40 localhost kernel: end_request: I/O error, dev sde, sector
8481319
Mar 20 17:20:40 localhost kernel: sd 14:0:0:0: [sde] Unhandled error code
Mar 20 17:20:40 localhost kernel: sd 14:0:0:0: [sde] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:20:40 localhost kernel: end_request: I/O error, dev sde, sector
8481335
Mar 20 17:20:40 localhost kernel: sd 14:0:0:0: [sde] Unhandled error code
Mar 20 17:20:40 localhost kernel: sd 14:0:0:0: [sde] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Mar 20 17:20:40 localhost kernel: end_request: I/O error, dev sde, sector
8481575
Mar 20 17:20:40 localhost kernel: journal_bmap: journal block not found at
offset 103 on sde4
Mar 20 17:20:40 localhost kernel: Aborting journal on device sde4.
Mar 20 17:20:40 localhost kernel: journal commit I/O error
Mar 20 17:20:41 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:20:41 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:20:41 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:20:41 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:20:41 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sde4 as enclosing drive was disconnected
Mar 20 17:20:41 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sde2 as enclosing drive was disconnected
Mar 20 17:20:41 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sde5 as enclosing drive was disconnected
Mar 20 17:20:41 localhost hald[2095]: forcibly attempting to lazy unmount
/dev/sde1 as enclosing drive was disconnected
Mar 20 17:20:45 localhost kernel: usb 1-6: new high speed USB device using
ehci_hcd and address 10
Mar 20 17:20:46 localhost kernel: usb 1-6: New USB device found, idVendor=1058,
idProduct=1010
Mar 20 17:20:46 localhost kernel: usb 1-6: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Mar 20 17:20:46 localhost kernel: usb 1-6: Product: External HDD    
Mar 20 17:20:46 localhost kernel: usb 1-6: Manufacturer: Western Digital 
Mar 20 17:20:46 localhost kernel: usb 1-6: SerialNumber:
575845383037353330303332
Mar 20 17:20:46 localhost kernel: usb 1-6: configuration #1 chosen from 1
choice
Mar 20 17:20:46 localhost kernel: scsi15 : SCSI emulation for USB Mass Storage
devices
Mar 20 17:20:46 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:20:47 localhost ntfs-3g[31274]: Unmounting /dev/sde5 ()
Mar 20 17:20:48 localhost hald: unmounted /dev/sde5 from '/media/disk-3' on
behalf of uid 0
Mar 20 17:20:48 localhost kernel: EXT3-fs error (device sde4): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:20:48 localhost kernel: EXT3-fs error (device sde4): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:20:48 localhost kernel: EXT3-fs error (device sde2): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:20:48 localhost kernel: EXT3-fs error (device sde2): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:20:48 localhost kernel: EXT3-fs error (device sde1): ext3_find_entry:
reading directory #2 offset 0
Mar 20 17:20:49 localhost kernel: ext3_abort called.
Mar 20 17:20:49 localhost kernel: EXT3-fs error (device sde4): ext3_put_super:
Couldn't clean up the journal
Mar 20 17:20:49 localhost kernel: Remounting filesystem read-only
Mar 20 17:20:49 localhost hald: unmounted /dev/sde4 from '/media/_1' on behalf
of uid 0
Mar 20 17:20:49 localhost hald: unmounted /dev/sde2 from '/media/disk-4' on
behalf of uid 0
Mar 20 17:20:49 localhost hald: unmounted /dev/sde1 from '/media/disk' on
behalf of uid 0
Mar 20 17:20:51 localhost kernel: usb 1-6: reset high speed USB device using
ehci_hcd and address 10
Mar 20 17:20:51 localhost kernel: scsi 15:0:0:0: Direct-Access     WD      
1600BEAExternal  1.02 PQ: 0 ANSI: 0
Mar 20 17:20:51 localhost kernel: sd 15:0:0:0: [sde] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 17:20:51 localhost kernel: sd 15:0:0:0: [sde] Write Protect is off
Mar 20 17:20:51 localhost kernel: sd 15:0:0:0: [sde] Assuming drive cache:
write through
Mar 20 17:20:51 localhost kernel: sd 15:0:0:0: [sde] 312581808 512-byte
hardware sectors: (160 GB/149 GiB)
Mar 20 17:20:51 localhost kernel: sd 15:0:0:0: [sde] Write Protect is off
Mar 20 17:20:51 localhost kernel: sd 15:0:0:0: [sde] Assuming drive cache:
write through
Mar 20 17:20:51 localhost kernel: sde: sde1 sde2 sde3 < sde5 > sde4
Mar 20 17:20:51 localhost kernel: sd 15:0:0:0: [sde] Attached SCSI disk
Mar 20 17:20:51 localhost kernel: sd 15:0:0:0: Attached scsi generic sg5 type 0
Mar 20 17:20:55 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 17:20:55 localhost kernel: EXT3 FS on sde1, internal journal
Mar 20 17:20:55 localhost kernel: EXT3-fs: recovery complete.
Mar 20 17:20:55 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 17:20:55 localhost hald: mounted /dev/sde1 on behalf of uid 0
Mar 20 17:20:55 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 17:20:55 localhost kernel: EXT3 FS on sde4, internal journal
Mar 20 17:20:55 localhost kernel: EXT3-fs: recovery complete.
Mar 20 17:20:55 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 17:20:55 localhost hald: mounted /dev/sde4 on behalf of uid 0
Mar 20 17:20:55 localhost kernel: kjournald starting.  Commit interval 5
seconds
Mar 20 17:20:55 localhost kernel: EXT3 FS on sde2, internal journal
Mar 20 17:20:55 localhost kernel: EXT3-fs: recovery complete.
Mar 20 17:20:55 localhost hald: mounted /dev/sde2 on behalf of uid 0
Mar 20 17:20:55 localhost kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 20 17:20:57 localhost hald: mounted /dev/sde5 on behalf of uid 0
Mar 20 17:20:57 localhost ntfs-3g[31630]: Version 2009.1.1 integrated FUSE 27
Mar 20 17:20:57 localhost ntfs-3g[31630]: Mounted /dev/sde5 (Read-Write, label
"", NTFS 3.1)
Mar 20 17:20:57 localhost ntfs-3g[31630]: Cmdline options:
rw,nosuid,nodev,uhelper=hal,locale=en_US.UTF-8
Mar 20 17:20:57 localhost ntfs-3g[31630]: Mount options:
rw,nosuid,nodev,uhelper=hal,silent,allow_other,nonempty,relatime,fsname=/dev/sde5,blkdev,blksize=4096
Mar 20 17:22:59 localhost ntfs-3g[31630]: Unmounting /dev/sde5 ()
Mar 20 17:23:13 localhost kernel: usb 1-6: USB disconnect, address 10
Mar 21 04:02:07 localhost pcscd: winscard.c:302:SCardConnect() Reader E-Gate 0
0 Not Found
Mar 21 04:02:07 localhost pcscd: winscard.c:302:SCardConnect() Reader E-Gate 0
0 Not Found
Mar 21 04:02:07 localhost pcscd: winscard.c:302:SCardConnect() Reader E-Gate 0
0 Not Found
Mar 21 04:02:07 localhost pcscd: winscard.c:302:SCardConnect() Reader E-Gate 0
0 Not Found
Mar 22 04:02:04 localhost pcscd: winscard.c:302:SCardConnect() Reader E-Gate 0
0 Not Found
Mar 22 04:02:04 localhost pcscd: winscard.c:302:SCardConnect() Reader E-Gate 0
0 Not Found
Mar 22 04:02:04 localhost pcscd: winscard.c:302:SCardConnect() Reader E-Gate 0
0 Not Found


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
