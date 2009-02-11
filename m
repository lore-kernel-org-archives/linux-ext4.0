From: Raimund andersen <anderse@gmx.de>
Subject: Filesystem still has errors
Date: Wed, 11 Feb 2009 22:13:36 +0000 (UTC)
Message-ID: <loom.20090211T220951-175@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41104 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821AbZBKWPI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 17:15:08 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LXNMF-0003CO-2P
	for linux-ext4@vger.kernel.org; Wed, 11 Feb 2009 22:15:03 +0000
Received: from 77-20-221-137-dynip.superkabel.de ([77.20.221.137])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 22:15:03 +0000
Received: from anderse by 77-20-221-137-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 22:15:03 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm using ext4 as a root fs on my 2.6.28-gentoo-r1 (x86_64), and after a few
locks due to X misconfiguration, which forced me to hard-reset, I sometimes get
the 'no space left on device' error message when trying to create new files. But
that's not true:

#>df
Filesystem           1K-blocks      Used Available Use% Mounted on
rootfs               201585632  16234952 175110680   9% /
/dev/root            201585632  16234952 175110680   9% /
(...)

#>df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
rootfs               12804096  520672 12283424    5% /
/dev/root            12804096  520672 12283424    5% /
(...)

#>fsck.ext4 -fnv /dev/sda9
e2fsck 1.41.4 (27-Jan-2009)
Warning!  /dev/sda9 is mounted.
Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Deleted inode 447291 has zero dtime.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Inode bitmap differences:  -447291
Fix? no


/dev/sda9: ********** WARNING: Filesystem still has errors **********


  520672 inodes used (4.07%)
     379 non-contiguous files (0.1%)
     258 non-contiguous directories (0.0%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 512092/62
 4862330 blocks used (9.50%)
       0 bad blocks
       2 large files

  468666 regular files
   42140 directories
     157 character device files
      31 block device files
       2 fifos
    5149 links
    9643 symbolic links (8294 fast symbolic links)
      23 sockets
--------
  525811 files


One reboot earlier, the messages where similar:

#> fsck.ext4 -nv /dev/sda9
e2fsck 1.41.4 (27-Jan-2009)
Warning!  /dev/sda9 is mounted.
Warning: skipping journal recovery because doing a read-only filesystem check.
/dev/sda9 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Deleted inode 447291 has zero dtime.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (46338006, counted=46337933).
Fix? no

Inode bitmap differences:  -447291
Fix? no

Free inodes count wrong (12283475, counted=12283437).
Fix? no


/dev/sda9: ********** WARNING: Filesystem still has errors **********


  520621 inodes used (4.07%)
     378 non-contiguous files (0.1%)
     258 non-contiguous directories (0.0%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 512079/62
 4861994 blocks used (9.50%)
       0 bad blocks
       2 large files
                                             
  468655 regular files
   42138 directories
     157 character device files
      31 block device files
       2 fifos
    5149 links
    9643 symbolic links (8294 fast symbolic links)
      23 sockets
--------
  525798 files
                                              

of course, I hesitate to call e2fsck.ext4 without -n on my mounted root-fs.
But when being invoked from an outside installed linux, no errors are detected:

#> fsck.ext4 -fnv /dev/sdb9
e2fsck 1.41.4 (27-Jan-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

  520634 inodes used (4.07%)
     379 non-contiguous files (0.1%)
     258 non-contiguous directories (0.0%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 512068/62
 4862059 blocks used (9.50%)
       0 bad blocks
       2 large files

  468644 regular files
   42138 directories
     157 character device files
      31 block device files
       2 fifos
    5149 links
    9642 symbolic links (8293 fast symbolic links)
      11 sockets
--------
  525774 files


The same is true with putting a '/forcefsck'; the filesystem is checked and no
error message appears.
But when invoking fsck manually after full bootup, fs is still corrupted. 

So what should I do?

Any help is greatly apreciated.

Raimund

