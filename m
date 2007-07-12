From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Random corruption test for e2fsck
Date: Wed, 11 Jul 2007 23:52:35 -0600
Message-ID: <20070712055235.GA8693@schatzie.adilger.int>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com> <20070710145855.GB27033@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:60730 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbXGLFwi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2007 01:52:38 -0400
Content-Disposition: inline
In-Reply-To: <20070710145855.GB27033@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've got another one, but it isn't a show stopper I think.

If you format a filesystem with both resize_inode and meta_bg you get an
unfixable filesystem.  The bad news is that it appears that running
e2fsck on the filesystem is actually _causing_ the corruption in this case
(trying to rebuild the resize inode)?  For now, the answer is "don't do that".
The resize inode was never intended to be in use when meta_bg is enabled,
so we should just prevent this from the start.


mke2fs  -j -b 4096 -I 512 -O sparse_super,filetype,resize_inode,dir_index,lazy_bg,meta_bg -F /tmp/test.img 57852

I can run e2fsck on this repeatedly and it always complains the same way:

$ e2fsck -fy /tmp/test.img
e2fsck 1.39.cfs9 (7-Apr-2007)
Resize inode not valid.  Recreate? yes

Pass 1: Checking inodes, blocks, and sizes
Inode 8, i_blocks is 0, should be 32816.  Fix? yes

Reserved inode 9 (<Reserved inode 9>) has invalid mode.  Clear? yes
Deleted inode 17 has zero dtime.  Fix? yes
Deleted inode 25 has zero dtime.  Fix? yes
Deleted inode 33 has zero dtime.  Fix? yes
Deleted inode 41 has zero dtime.  Fix? yes
Deleted inode 49 has zero dtime.  Fix? yes
Deleted inode 57 has zero dtime.  Fix? yes
Deleted inode 65 has zero dtime.  Fix? yes
Deleted inode 73 has zero dtime.  Fix? yes
Deleted inode 81 has zero dtime.  Fix? yes
Deleted inode 89 has zero dtime.  Fix? yes

Pass 2: Checking directory structure
Inode 2 (???) has invalid mode (00).
Clear? yes

Entry '..' in ??? (2) has deleted/unused inode 2.  Clear? yes

Inode 11 (???) has invalid mode (00).
Clear? yes

Pass 3: Checking directory connectivity
Root inode not allocated.  Allocate? yes

/lost+found not found.  Create? yes

Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +0 +(2--14) +(16--3619) +(3621--3622) +(3625--7727)
Fix? yes

Free blocks count wrong for group #0 (25039, counted=25041).
Fix? yes

Free blocks count wrong (46503, counted=46505).
Fix? yes

Inode bitmap differences:  +(3--10) -16
Fix? yes

Free inodes count wrong for group #0 (28918, counted=28917).
Fix? yes

Directories count wrong for group #0 (3, counted=2).
Fix? yes

Free inodes count wrong (57846, counted=57845).
Fix? yes


/tmp/test.img: ***** FILE SYSTEM WAS MODIFIED *****
/tmp/test.img: 11/57856 files (9.1% non-contiguous), 11347/57852 blocks


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
