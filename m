From: Sandon Van Ness <sandon@van-ness.com>
Subject: linux-ext4@vger.kernel.org
Date: Sat, 24 Dec 2011 00:18:07 -0800
Message-ID: <4EF58ABF.8020404@van-ness.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from box.houkouonchi.jp ([208.97.140.21]:34721 "EHLO
	box.houkouonchi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1LXIRM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Dec 2011 03:17:12 -0500
Received: from [192.168.120.87] (ace.ops.newdream.net [64.111.111.110])
	by box.houkouonchi.net (Postfix) with ESMTPA id E2595167382
	for <linux-ext4@vger.kernel.org>; Sat, 24 Dec 2011 00:16:57 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Most of our machines are ext3 and have seen the card get reset on ext3 
and it never went read-only like it always does in ext4 now. The I/O 
goes unresponsive for a few minutes as it detects I/O is unresponsive 
and then the controller is reset and the machine would recover (on 
ext3/jfs, and other fs's) on ext4 the journal is aborted and it goes 
into read-only:

Anyone ever see something like this?


[605458.429395] scsi cmnd aborted, scsi_cmnd(0xffff88041c4dac80), 
cmnd[0x28,0x 0,0xcb,0x 4,0x13,0x40,0x 0,0x 0,0x 8,0x 0,0x 0,0x 0], 
scsi_id = 0x 0, scsi_lun = 0x 1.
[605458.444011] arcmsr1: executing eh bus reset .....num_resets = 0, 
num_aborts = 114
[605458.451724] arcmsr1: executing hw bus reset .....
[605480.472827] arcmsr1: waiting for hw bus reset return, retry=1
[605500.486408] arcmsr1: waiting for hw bus reset return, retry=2
[605520.516017] Areca RAID Controller1: F/W V1.49 2010-12-02 & Model 
ARC-1222
[606900.929121] EXT4-fs error (device sdb1): mb_free_blocks:1397: group 
39137block 1282445473:freeing already freed block (bit 4257)
[606900.941415] Aborting journal on device sdb1-8.
[606900.941561] EXT4-fs error (device sdb1) in ext4_setattr:5462: 
Readonly filesystem
[606900.955051] Aborting journal on device sdb1-8.

Seconds after the card is reset and recovers the journal is aborted and 
read-only. Here is another case where it happens even before the card is 
reset:

[574763.342694] scsi cmnd aborted, scsi_cmnd(0xffff8803d5fff1c0), 
cmnd[0x2a,0x 0,0x 0,0x 0,0x a,0xd0,0x 0,0x 0,0x 8,0x 0,0x 0,0x 0], 
scsi_id = 0x 0, scsi_lun = 0x 1.
[574763.357267] scsi cmnd aborted, scsi_cmnd(0xffff8800712a1480), 
cmnd[0x2a,0x 0,0x 0,0x 0,0x a,0xf0,0x 0,0x 0,0x 8,0x 0,0x 0,0x 0], 
scsi_id = 0x 0, scsi_lun = 0x 1.
--------------------------SNIP----------------------------------------
[584376.272002] scsi cmnd aborted, scsi_cmnd(0xffff8802407f63c0), 
cmnd[0x88,0x 0,0x 0,0x 0,0x 0,0x 2,0x62,0x44,0xe7,0x28,0x 0,0x 0], 
scsi_id = 0x 0, scsi_lun = 0x 1.
[584376.286524] arcmsr1: executing eh bus reset .....num_resets = 2, 
num_aborts = 497
[584376.612598] arcmsr1: wait 'abort all outstanding command' timeout
[587971.898239] EXT4-fs error (device sdb1): ext4_mb_generate_buddy:731: 
group 4216017413 blocks in bitmap, 17416 in gd
[587971.908788] Aborting journal on device sdb1-8.
[587972.072416] EXT4-fs (sdb1): Remounting filesystem read-only
[587972.072513] EXT4-fs error (device sdb1): ext4_journal_start_sb:260: 
Detected aborted journal
[587972.072518] EXT4-fs (sdb1): Remounting filesystem read-only
[587972.092489] EXT4-fs error (device sdb1) in 
ext4_reserve_inode_write:5657: Journal has aborted
[587974.432255] EXT4-fs error (device sdb1) in ext4_evict_inode:210: 
Journal has aborted
[587974.443945] EXT4-fs (sdb1): ext4_da_writepages: jbd2_start: 778 
pages, ino 76182150; err -30
[587974.446615] EXT4-fs (sdb1): ext4_da_writepages: jbd2_start: 
9223372036854775773 pages, ino 88873701; err -30

Any ideas why ext4 has this behavior when ext3 did not?
