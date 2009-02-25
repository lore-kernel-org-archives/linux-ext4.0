From: Ron Johnson <ron.l.johnson@cox.net>
Subject: EXT4-fs: group descriptors corrupted!
Date: Wed, 25 Feb 2009 14:39:31 -0600
Message-ID: <49A5AC83.1020009@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Linux-Ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmmtao103.cox.net ([68.230.240.9]:39576 "EHLO
	eastrmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbZBYUjf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 15:39:35 -0500
Received: from eastrmimpo01.cox.net ([68.1.16.119])
          by eastrmmtao103.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20090225203932.BVQV11476.eastrmmtao103.cox.net@eastrmimpo01.cox.net>
          for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 15:39:32 -0500
Received: from [192.168.1.10] (haggis.homelan [192.168.1.10])
	by haggis.homelan (Postfix) with ESMTP id 3E39B87CF9
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 14:39:32 -0600 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,


I get an error that seems to be the same as in this thread:
http://kerneltrap.org/mailarchive/linux-ext4/2009/1/5/4598534

Below is the link to a dumpe2fs.

$ dmesg | grep EXT4
[   45.995261] EXT4-fs: barriers enabled
[   46.014833] EXT4 FS on hda1, internal journal on hda1:8
[   46.014873] EXT4-fs: delayed allocation enabled
[   46.014912] EXT4-fs: file extents enabled
[   46.015883] EXT4-fs: mballoc enabled
[   46.015926] EXT4-fs: mounted filesystem with ordered data mode.
[ 1392.640482] EXT4-fs: ext4_check_descriptors: Block bitmap for 
group 0 not in group (block 3120627712)!
[ 1392.640490] EXT4-fs: group descriptors corrupted!

These are the relevant Debian Sid package versions:
e2fsprogs                1.41.3-1
linux-source-2.6.28      2.6.28-2~snapshot.12850

Since I built the fs with extents enabled, I am hesitant to run fsck 
on it because I've read that it doesn't yet support extents.

As you can see from the dmesg snippets, one of my ext4 file systems 
mounted perfectly.  The one that didn't is an lvm2 "array", which 
seems to be consistent.

# lvdisplay
     Logging initialised at Wed Feb 25 14:31:23 2009
     Set umask to 0077
lvdisplay    Finding all logical volumes
lvdisplay  --- Logical volume ---
lvdisplay  LV Name                /dev/main_huge_vg/main_huge_lv
lvdisplay  VG Name                main_huge_vg
lvdisplay  LV UUID                Pgrlks-mtmc-GuYh-kvPU-Mr78-w9b6-uykW8A
lvdisplay  LV Write Access        read/write
lvdisplay  LV Status              available
lvdisplay  # open                 0
lvdisplay  LV Size                2.69 TB
lvdisplay  Current LE             22023
lvdisplay  Segments               9
lvdisplay  Allocation             inherit
lvdisplay  Read ahead sectors     auto
lvdisplay  - currently set to     256
lvdisplay  Block device           254:0
lvdisplay
lvdisplay    Wiping internal VG cache

# dumpe2fs  -f/dev/main_huge_vg/main_huge_lv | head -n800 > 
main_huge_lv.dump.txt
dumpe2fs 1.41.3 (12-Oct-2008)
ext2fs_read_bb_inode: Invalid argument
http://members.cox.net/ron.l.johnson/main_huge_lv.dump.txt

TIA

-- 
Ron Johnson, Jr.
Jefferson LA  USA
