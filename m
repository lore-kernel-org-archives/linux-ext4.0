From: Jasper Wallace <jasper@pointless.net>
Subject: All of my backup superblocks are zero'd out
Date: Sat, 25 Jun 2011 04:09:15 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1106242204040.6390@yvzcvg>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thingy.pointless.net ([91.209.244.43]:52292 "EHLO
	thingy.pointless.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1FYDpb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jun 2011 23:45:31 -0400
Received: from 93-97-176-250.zone5.bethere.co.uk ([93.97.176.250]:50177 helo=limpit.lan.london.hackspace.org.uk)
	by thingy.pointless.net with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.71)
	(envelope-from <jasper@pointless.net>)
	id 1QaJFD-0001IF-W7
	for linux-ext4@vger.kernel.org; Sat, 25 Jun 2011 04:09:16 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

(apologies in advance if this is the wrong place to post this, but the 
e2fsprogs mailing list on sf seems to be dead).

I have a machine that dual boots NetBSD-current and Ubuntu 10.04.2 LTS so /home is ext2
for it to work with both.

A while ago (i think after an ubuntu release upgrade) the netbsd ext2 fsck 
started to core dump when checking /home. I checked the fs with the fsck 
from e2fsprogs and it passed so i assumed it was a netbsd bug and 
ignored it.

Recently i came back to the problem intending to fix netbsd's ext2 fsck 
and discovered that all the backup super blocks on the fs where compleatly 
zeroed out.

If the e2fs progs fsck can't find the first backup superblock it checks 
the 2nd one and so on, but it exits cleanly if it dosen't find any.

I assume that not having any backup super blocks is a bad thing and the 
e2fsprogs fsck should check for that case and offer to copy the main 
superblock to all the backup positions.


Here's the output of fsck patched to print the block groups (bg) and block 
numbers of where it's trying to find super blocks, the ignoreing happens 
if the (backup_sb->s_magic != EXT2_SUPER_MAGIC) || (backup_sb->s_rev_level >
EXT2_LIB_CURRENT_REV) || [other stuff] test fails in e2fsck/super.c, 
line 930 ish:

root@limpit:~/e2fs/e2fsprogs-1.41.11/e2fsck# ./e2fsck /dev/sda3
e2fsck 1.41.11 (14-Mar-2010)
looking for backup sb at blk 32768 (bg 1)
ignoring backup sb at blk 32768
looking for backup sb at blk 98304 (bg 3)
ignoring backup sb at blk 98304
looking for backup sb at blk 163840 (bg 5)
ignoring backup sb at blk 163840
looking for backup sb at blk 229376 (bg 7)
ignoring backup sb at blk 229376
looking for backup sb at blk 294912 (bg 9)
ignoring backup sb at blk 294912
looking for backup sb at blk 819200 (bg 25)
ignoring backup sb at blk 819200
looking for backup sb at blk 884736 (bg 27)
ignoring backup sb at blk 884736
looking for backup sb at blk 1605632 (bg 49)
ignoring backup sb at blk 1605632
looking for backup sb at blk 2654208 (bg 81)
ignoring backup sb at blk 2654208
looking for backup sb at blk 4096000 (bg 125)
ignoring backup sb at blk 4096000
looking for backup sb at blk 7962624 (bg 243)
ignoring backup sb at blk 7962624
looking for backup sb at blk 11239424 (bg 343)
ignoring backup sb at blk 11239424
looking for backup sb at blk 20480000 (bg 625)
ignoring backup sb at blk 20480000
looking for backup sb at blk 23887872 (bg 729)
ignoring backup sb at blk 23887872
WARNING: no backup superblocks found
Home: clean, 1047277/7806976 files, 21507366/31208652 blocks

I've saved each backup superblock to a file and confirmed that they are 
all zero's (0x00).

If i use findsuper on the partition i get:

root@limpit:~/e2fs/e2fsprogs-1.41.11/misc# ./findsuper /dev/sda3
starting at 0, with 512 byte increments
byte_offset  byte_start     byte_end  fs_blocks blksz  grp  last_mount_time           sb_uuid label
       1024           0  127830638592   31208652  4096    0  Fri Jun 24 19:00:34 2011 8e19240c Home
34359738368 44452740608 44452739584  2051003513344  1959522240  1024    0  Wed Feb  4 15:42:08 2032 1c000000 E
67366390784 18314584675153709056  18314584675153709056          0  1024 38051  Sun May 11 07:34:55 1952 f7fff7ff
89764110848 89764109824  89768720896       4503  1024    0  Thu Jan  1 01:00:00 1970 00000000 
89768768000 89768766976  89785544192      16384  1024    0  Thu Jan  1 01:00:00 1970 00000000 
89790432256 89790431232  89854443520      62512  1024    0  Thu Jun 12 09:47:43 1980 4608c91f 
89799914496 89791524864  89855537152      62512  1024    1  Thu Jan  1 01:00:00 1970 4608c91f 
89816708096 89791541248  89855553536      62512  1024    3  Thu Jan  1 01:00:00 1970 4608c91f 
89833501696 89791557632  89855569920      62512  1024    5  Thu Jan  1 01:00:00 1970 4608c91f 
89850295296 89791574016  89855586304      62512  1024    7  Thu Jan  1 01:00:00 1970 4608c91f 
104213687296 104213686272  104217880576       4096  1024    0  Sun Dec 31 14:46:17 2006 3acdc9d5 
124554051584:   220752kB/s @ Fri Jun 24 19:45:34 2011
127830640640: finished with errno 2

[the output above was captured with typescript, it got slightly mangled].

Apart from the 1st one, which is valid, i don't think any of the other
superblocks are relevent, in particular the blocksize should be 4096, and
the dates are bogus. The sequence of superblocks with 62512 fs_blocks and
4608c91f sb_uuid might be from a filesystem image, but it's too small to be
my /home.

Does anyone know what could cause the lack of backup super blocks to 
happen?

Has anyone heard of this happening to anyone else?

P.S. see also related netbsd problem report: http://gnats.netbsd.org/45072 

-- 
[http://pointless.net/]                                   [0x2ECA0975]
