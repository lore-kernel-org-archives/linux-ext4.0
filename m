From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 bug and/or e2fsck hole
Date: Tue, 07 Apr 2009 16:51:40 -0700
Message-ID: <20090407235140.GH3204@webber.adilger.int>
References: <20090407204811.GA4495@kulgan>
 <20090407231324.GF3204@webber.adilger.int> <20090407233955.GA4328@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:34530 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZDGXvn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 19:51:43 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n37NpglF027948
	for <linux-ext4@vger.kernel.org>; Tue, 7 Apr 2009 16:51:42 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KHR00J008WTC700@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 07 Apr 2009 16:51:42 -0700 (PDT)
In-reply-to: <20090407233955.GA4328@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 08, 2009  09:09 +0930, Kevin Shanahan wrote:
> On Tue, Apr 07, 2009 at 04:13:24PM -0700, Andreas Dilger wrote:
> > What version of e2fsprogs is this?  It definitely appears that the
> > inode is corrupted (bad i_file_acl field), and e2fsck isn't fixing it.
> 
> Using current Debian stable release:
> 
> hermes:~# e2fsck -V
> e2fsck 1.41.3 (12-Oct-2008)
>         Using EXT2FS Library version 1.41.3, 12-Oct-2008
> 
> > Can you please dump this inode using "debugfs -c -R 'imap 383' /dev/dm-0"
> > and "dd if=/dev/dm-0 of=/tmp/bad_inode.383.bin bs=4k count=1 skip={blocknr}".
> 
> hermes:~# debugfs -c -R 'imap 383' /dev/dm-0
> debugfs 1.41.3 (12-Oct-2008)
> /dev/dm-0: catastrophic mode - not reading inode or group bitmaps
> 383: File not found by ext2_lookup 
> hermes:~# debugfs -c -R 'imap <383>' /dev/dm-0
> debugfs 1.41.3 (12-Oct-2008)
> /dev/dm-0: catastrophic mode - not reading inode or group bitmaps
> Inode 383 is part of block group 0
>         located at block 312, offset 0x0e00

000e00 845ac901 00000000 5d648154 9f6a0b23
000e10 22344c51 00000000 0001e064 00000000
000e20 c4a8c000 c591d204 9105f87d c6cf35c8
000e30 82016f23 d3a7defb af4ab245 d3123ef4
000e40 87cd5ebe fa60d394 db745504 a6f3a34d
000e50 6a5985d4 ac8cebf1 a605db29 548c8e6e
000e60 f665b0c8 e58c1934 00000000 00000000
000e70 00000000 5db50000 b6ae09f5 6bc9469f
000e80 9c950004 5b8f755b e31b8760 e49bfe80
000e90 215242b0 f708f501 ab1d808d 4143a941
000ea0 83ff4c83 36858a3e db376e67 c87ee64e
000eb0 c10e0487 8dc325a1 4e7327aa 71a6c841
000ec0 4014140b d18816c7 87898dba b986e891
000ed0 2dab53ed 8fef04ef f33deb1c 47010862
000ee0 c551c546 2c463176 0b0c554a 76af3850
000ef0 271cc4fa 457664de 79b808d5 4456415a

This inode looks like total garbage, unlike the ones immediately before
and after it in the same block.  Why e2fsck doesn't complain about this
inode is a bit of a mystery.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

