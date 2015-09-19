From: Dave Chinner <david@fromorbit.com>
Subject: Re: resize2fs: Should never happen: resize inode corrupt! - lost key
 inodes
Date: Sat, 19 Sep 2015 12:47:25 +1000
Message-ID: <20150919024725.GV3902@dastard>
References: <55CA3BDE.7020401@harvyl.se>
 <20150811224718.GD20658@thunk.org>
 <55CBC212.6000507@harvyl.se>
 <20150813132716.GB26095@thunk.org>
 <55CCDE20.3010108@harvyl.se>
 <55E8C6AC.5000308@harvyl.se>
 <55F3FE07.9030807@harvyl.se>
 <55F73DAD.6020807@harvyl.se>
 <55F85B90.3000709@harvyl.se>
 <B9C846A3-35D0-480C-9888-3F46E8A9C6A5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Johan Harvyl <johan@harvyl.se>, Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:18346 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752AbbISCr2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2015 22:47:28 -0400
Content-Disposition: inline
In-Reply-To: <B9C846A3-35D0-480C-9888-3F46E8A9C6A5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 16, 2015 at 07:21:59PM -0600, Andreas Dilger wrote:
> If you add "-b 1024" to the mke2fs command line to use 1KB instead of 4KB blocks, and reduce the sizes by a factor of 4 does the problem still happen? That would make it easier for someone else to test, since it would only need a 4-5TB disk instead of a 19Tb array. 

Sparse files on XFS using loopback will allow you to simulate
devices larger than 16TB easily. You can turtle it all the way down,
too, to create the xfs filesystem on a loopback device on a sparse
file on ext4....

Doing this sort of thing lets me know, for example, that the
mkfs.ext4 defaults fail on a 500TB device...

# xfs_io -f -c 'truncate 500t' /mnt/xfs/fs.img
# ls -lh /mnt/xfs
total 0
-rw------- 1 root root 500T Sep 19 12:41 fs.img
# mkfs.ext4 /mnt/xfs/fs.img
mke2fs 1.42.13 (17-May-2015)
/mnt/xfs/fs.img: Cannot create filesystem with requested number of inodes while setting up superblock
#

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
