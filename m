From: Jens Pranaitis <pranaitis@phil.hhu.de>
Subject: filesystem unrepairable after resizing from 16TB to 20TB
Date: Wed, 19 Mar 2014 11:34:04 +0100
Message-ID: <5329729C.8020503@phil.hhu.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020701000504050909020609"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.phil-fak.uni-duesseldorf.de ([134.99.24.45]:57263 "EHLO
	smtp4.phil-fak.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757750AbaCSKlT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2014 06:41:19 -0400
Received: from smtp4.phil-fak.uni-duesseldorf.de (localhost [127.0.0.1])
	by smtp4.phil-fak.uni-duesseldorf.de (Postfix) with ESMTP id 8EFB8200C1
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2014 11:33:23 +0100 (CET)
Received: from [134.99.58.201] (sna-lnx1.phil-fak.uni-duesseldorf.de [134.99.58.201])
	by smtp4.phil-fak.uni-duesseldorf.de (Postfix) with ESMTPSA id 823E9200BF
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2014 11:33:23 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020701000504050909020609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Dear all,

after resizing a 64bit ext4 filesystem from 16TB to 20TB, which 
completed without errors, I started a rsync of ~3TB, about 30min into 
the copy the following kernel messages started to pop up:

Mar 17 12:03:31 s_local@backup1/backup1 kernel: [2081501.742613] EXT4-fs 
(dm-2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.489419] EXT4-fs 
error (device dm-2): ext4_mb_generate_buddy:755: group 1, 30820 clusters 
in bitmap, 30207 in gd
[...]

I attached the full kernel log from the day of the resize.

There are a lot of broken files and when trying to fix them with e2fsck 
the program exits:

Inode 2195807 has an invalid extent node (blk 35192760, lblk 0) 

Clear? yes

e2fsck: e2fsck_read_bitmaps: illegal bitmap block(s) for /dev/vg-data/backup

/dev/vg-data/backup: ***** FILE SYSTEM WAS MODIFIED *****
e2fsck: aborted

You can find the output of e2fsck -n /dev/vg-data/backup at
http://user.phil.hhu.de/~pranaitis/e2fsck.log.xz
the uncompressed log size is 357MB so I thought I'd rather not send it 
via this list.

The kernel version is 3.11-0.bpo.2-amd64 from Debian backports. The 
e2fsprogs version is vanilla 1.42.9.

The machine itself is a VM created with VMWare ESXi 5.5.0 using Thick 
Provisioned disks.

I don't have any hope of salvaging the filesystem, but is there anything 
I can do to help in preventing such issues in the future?

Kind regards,

Jens Pranaitis
-- 
IKM-Serviceteam der Philosophischen Fakultät
HHU Düsseldorf
Gebäude 23.21, Ebene 04, Raum 88
Tel.: 0211/81-13077

--------------020701000504050909020609
Content-Type: text/x-log;
 name="kernel-ext4-mar17.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kernel-ext4-mar17.log"

Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.701826] scsi 0:0:3:0: Direct-Access     VMware   Virtual disk     1.0  PQ: 0 ANSI: 2
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.701859] scsi target0:0:3: Beginning Domain Validation
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.702784] scsi target0:0:3: Domain Validation skipping write tests
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.702787] scsi target0:0:3: Ending Domain Validation
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.702851] scsi target0:0:3: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.703410] sd 0:0:3:0: [sdf] Very big device. Trying to use READ CAPACITY(16).
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.703468] sd 0:0:3:0: [sdf] 8589934592 512-byte logical blocks: (4.39 TB/4.00 TiB)
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.703516] sd 0:0:3:0: [sdf] Write Protect is off
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.703522] sd 0:0:3:0: [sdf] Mode Sense: 61 00 00 00
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.703655] sd 0:0:3:0: [sdf] Cache data unavailable
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.703660] sd 0:0:3:0: [sdf] Assuming drive cache: write through
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.704728] sd 0:0:3:0: Attached scsi generic sg6 type 0
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.704841] sd 0:0:3:0: [sdf] Very big device. Trying to use READ CAPACITY(16).
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.705008] sd 0:0:3:0: [sdf] Cache data unavailable
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.705014] sd 0:0:3:0: [sdf] Assuming drive cache: write through
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.707892]  sdf: unknown partition table
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.708146] sd 0:0:3:0: [sdf] Very big device. Trying to use READ CAPACITY(16).
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.708281] sd 0:0:3:0: [sdf] Cache data unavailable
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.708286] sd 0:0:3:0: [sdf] Assuming drive cache: write through
Mar 17 11:08:28 s_local@backup1/backup1 kernel: [2078195.708478] sd 0:0:3:0: [sdf] Attached SCSI disk
Mar 17 11:08:53 s_local@backup1/backup1 kernel: [2078221.071695] sd 0:0:3:0: [sdf] Very big device. Trying to use READ CAPACITY(16).
Mar 17 11:08:53 s_local@backup1/backup1 kernel: [2078221.071849] sd 0:0:3:0: [sdf] Cache data unavailable
Mar 17 11:08:53 s_local@backup1/backup1 kernel: [2078221.071855] sd 0:0:3:0: [sdf] Assuming drive cache: write through
Mar 17 11:08:53 s_local@backup1/backup1 kernel: [2078221.075132]  sdf: sdf1
Mar 17 12:03:31 s_local@backup1/backup1 kernel: [2081501.742613] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.489419] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 1, 30820 clusters in bitmap, 30207 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.490021] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 2, 30812 clusters in bitmap, 32768 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.490369] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 3, 30628 clusters in bitmap, 30207 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.490675] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 4, 30820 clusters in bitmap, 32768 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.491144] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 5, 30636 clusters in bitmap, 30207 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.491536] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 6, 30628 clusters in bitmap, 32768 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.491882] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 7, 30444 clusters in bitmap, 30207 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.492239] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 8, 30820 clusters in bitmap, 32768 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.492523] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 9, 30620 clusters in bitmap, 30207 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.492698] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 10, 30628 clusters in bitmap, 32768 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.492870] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 11, 30428 clusters in bitmap, 32768 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.493043] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 12, 30636 clusters in bitmap, 32768 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.493215] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 13, 30436 clusters in bitmap, 32768 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.493397] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 14, 30444 clusters in bitmap, 32768 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.494014] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 15, 30244 clusters in bitmap, 32768 in gd
Mar 17 12:37:10 s_local@backup1/backup1 kernel: [2083523.517545] JBD2: Spotted dirty metadata buffer (dev = dm-2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
Mar 17 12:37:36 s_local@backup1/backup1 kernel: [2083549.233904] EXT4-fs error (device dm-2): mb_free_blocks:1426: group 1607, block 52661289:freeing already freed block (bit 3113)
Mar 17 12:37:36 s_local@backup1/backup1 kernel: [2083549.234045] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:755: group 1607, 32768 clusters in bitmap, 32769 in gd

--------------020701000504050909020609--
