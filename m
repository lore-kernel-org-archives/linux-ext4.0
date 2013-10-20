From: "Markus Moeller" <huaraz@moeller.plus.com>
Subject: Re: linux ext filesystem errors
Date: Sun, 20 Oct 2013 15:47:00 +0100
Message-ID: <l40qcs$o7e$1@ger.gmane.org>
References: <l40job$n86$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52634 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab3JTOrO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Oct 2013 10:47:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1VXuHh-0004aC-2k
	for linux-ext4@vger.kernel.org; Sun, 20 Oct 2013 16:47:13 +0200
Received: from moeller.plus.com ([81.174.172.105])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 20 Oct 2013 16:47:13 +0200
Received: from huaraz by moeller.plus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 20 Oct 2013 16:47:13 +0200
In-Reply-To: <l40job$n86$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

  I did  created a new filesystem and it looks fine, which I think excludes 
a disk HW problems.  So how can I fix the ext4 filesystem ?

Thank you
Markus


"Markus Moeller"  wrote in message news:l40job$n86$1@ger.gmane.org...



Hi,

  I have an SD disk which was running fine with an ext4 filesystem.   Lately
I got the following errors:

[  133.736890] EXT4-fs error (device mmcblk0p2): ext4_ext_check_inode:462:
inode #131171: comm tput: bad header/extent: invalid eh_entries - magic
f30a, entries 65, max 4(4), depth 0(0)
[  133.775135] EXT4-fs error (device mmcblk0p2): ext4_ext_check_inode:462:
inode #131171: comm tput: bad header/extent: invalid eh_entries - magic
f30a, entries 65, max 4(4), depth 0(0)
[  133.874077] EXT4-fs error (device mmcblk0p2): ext4_iget:3811: inode #46:
comm start-stop-daem: bad extra_isize (32924 != 256)
[  134.298519] EXT4-fs error (device mmcblk0p2): ext4_iget:3811: inode #46:
comm startpar: bad extra_isize (32924 != 256)
[  134.317035] EXT4-fs error (device mmcblk0p2): ext4_iget:3811: inode #46:
comm startpar: bad extra_isize (32924 != 256)
[  134.815006] EXT4-fs error (device mmcblk0p2): ext4_iget:3811: inode #46:
comm init: bad extra_isize (32924 != 256)
[  134.845380] EXT4-fs error (device mmcblk0p2): ext4_iget:3811: inode #46:
comm init: bad extra_isize (32924 != 256)
[  134.866181] EXT4-fs error (device mmcblk0p2): ext4_iget:3811: inode #46:
comm init: bad extra_isize (32924 != 256)
[  134.894042] EXT4-fs error (device mmcblk0p2): ext4_iget:3811: inode #46:
comm sulogin: bad extra_isize (32924 != 256)
[  134.912231] EXT4-fs error (device mmcblk0p2): ext4_iget:3811: inode #46:
comm sulogin: bad extra_isize (32924 != 256)

which I tried to fix with fsck  but it gets killed.

linux:~ # e2fsck -y /dev/sdb2
e2fsck 1.42.6 (21-Sep-2012)
Backing up journal inode block information.

/dev/sdb2 contains a file system with errors, check forced.
Resize inode not valid.  Recreate? yes

Pass 1: Checking inodes, blocks, and sizes
Inode 131179 has an invalid extent
        (logical block 0, invalid physical block 1342766638, len 1)
Clear? yes

Inode 131179, i_blocks is 8, should be 0.  Fix? yes

Inodes that were part of a corrupted orphan linked list found.  Fix? yes

Inode 131180 was part of the orphaned inode list.  FIXED.
Inode 131180 has a extra size (2076) which is invalid
Fix? yes

Error while reading over extent tree in inode 131180: Corrupt extent header
Clear inode? yes

Inode 131180, i_blocks is 8, should be 0.  Fix? yes

Inode 131185 was part of the orphaned inode list.  FIXED.
Inode 131185, i_size is 144185556820644144, should be 614400.  Fix? yes

Inode 131186 was part of the orphaned inode list.  FIXED.
Inode 131186 has a extra size (540) which is invalid
Fix? yes

Inode 131186 has an invalid extent
        (logical block 0, invalid physical block 155898722910210, len 2)
Clear? yes

Inode 131186, i_blocks is 16, should be 0.  Fix? yes

Error while reading over extent tree in inode 131187: Corrupt extent header
Clear inode? yes

Inode 131187, i_blocks is 9, should be 0.  Fix? yes

Inode 131188 has an invalid extent
        (logical block 0, invalid physical block 4400194552889, len 1)
Clear? yes

Inode 131188, i_blocks is 24, should be 0.  Fix? yes

Inode 131193, i_size is 18014398509484072, should be 2199023259648.  Fix?
yes

Killed

Does this mean it is a HW error ?


Thank you
Markus



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html 


