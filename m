From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Fri, 17 Apr 2009 13:16:46 +0100
Message-ID: <gs9rve$rid$1@ger.gmane.org>
References: <gs9nm5$8m1$1@ger.gmane.org> <20090417115659.GB7117@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48989 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZDQMQ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 08:16:59 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Lun06-0001GH-8H
	for linux-ext4@vger.kernel.org; Fri, 17 Apr 2009 12:16:58 +0000
Received: from xpc17.ast.cam.ac.uk ([131.111.69.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 12:16:58 +0000
Received: from jss by xpc17.ast.cam.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 12:16:58 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> What happened afterwards?   Did fsck complete successfully?

I was waiting to see whether you wanted me to do something else.  I've just 
tried it and it didn't:

[root@xback2 ~]# fsck -a /dev/md0
fsck 1.41.4 (27-Jan-2009)
/dev/md0: Group descriptor 384 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 385 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 386 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 387 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 388 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 389 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 390 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 391 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 392 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 393 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 394 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 395 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 396 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 397 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 398 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 399 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 400 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 401 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 402 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 403 checksum is invalid.  FIXED.
/dev/md0: Group descriptor 404 checksum is invalid.  FIXED.
/dev/md0: Note: if several inode or block bitmap blocks or part
of the inode table require relocation, you may wish to try
running e2fsck with the '-b 32768' option first.  The problem
may lie only with the primary block group descriptors, and
the backup block group descriptors may be OK.

/dev/md0: Block bitmap for group 405 is not in group.  (block 3393946179)


/dev/md0: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
        (i.e., without -a or -p options)


** When I run it manually I get:

Pass 1: Checking inodes, blocks, and sizes
Inode 8355 has imagic flag set.  Clear<y>? yes

Inode 8355 has a extra size (62017) which is invalid
Fix<y>? yes

Inode 8355 has compression flag set on filesystem without compression 
support.  Clear<y>? yes

Inode 8355 has a bad extended attribute block 2170352193.  Clear<y>? yes

Inode 8355 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes

Inode 8355, i_size is 9321591691907232321, should be 0.  Fix<y>? yes

Inode 8355, i_blocks is 266363157148225, should be 0.  Fix<y>? yes

Inode 8356 is in use, but has dtime set.  Fix<y>? yes

Inode 8356 has imagic flag set.  Clear<y>? yes

Inode 8356 has a extra size (62017) which is invalid
Fix<y>? yes

Inode 8356 has compression flag set on filesystem without compression 
support.  Clear<y>? yes

Inode 8356 has a bad extended attribute block 2170352193.  Clear<y>? yes

Inode 8356 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes

Inode 8356, i_size is 9321591691907232321, should be 0.  Fix<y>? yes

Inode 8356, i_blocks is 266363157148225, should be 0.  Fix<y>? yes

Inode 8357 is in use, but has dtime set.  Fix<y>? yes

Inode 8357 has imagic flag set.  Clear<y>? yes

Inode 8357 has a extra size (62017) which is invalid
Fix<y>? yes

Inode 8357 has compression flag set on filesystem without compression 
support.  Clear<y>? yes

Inode 8357 has a bad extended attribute block 2170352193.  Clear<y>? yes

Inode 8357 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes


> I see from the dumpe2fs that you sent it had only been in use for a
> week.  How were you using the filesystem?  Did you try using the
> online resize feature at any time?

No. The filesystem was used to store rsync snapshots of other file systems 
(using the hard link feature). I had only rsynced the initial data and run a 
couple of rsync backups on to it. The filesystem was created using:

mkfs.ext4 -m0 -b 4096 -E stride=8,stripe-width=72  /dev/md0

> The problem is that any number of things could have caused the block
> group descriptors to be corrupted.

Oh dear. The system has ECC ram (though linux doesn't know about it, so it 
may not be working) and the md device is using 10 drives on raid5 and a 
3ware controller.

Maybe I should force a md raid5 resync to check the drives agree with each 
other.

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053


