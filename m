From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: resize2fs: Should never happen: resize inode corrupt! - lost key
 inodes
Date: Fri, 18 Sep 2015 22:23:46 -0700
Message-ID: <20150919052346.GF10390@birch.djwong.org>
References: <20150811224718.GD20658@thunk.org>
 <55CBC212.6000507@harvyl.se>
 <20150813132716.GB26095@thunk.org>
 <55CCDE20.3010108@harvyl.se>
 <55E8C6AC.5000308@harvyl.se>
 <55F3FE07.9030807@harvyl.se>
 <55F73DAD.6020807@harvyl.se>
 <55F85B90.3000709@harvyl.se>
 <B9C846A3-35D0-480C-9888-3F46E8A9C6A5@dilger.ca>
 <20150919024725.GV3902@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Johan Harvyl <johan@harvyl.se>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26705 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbbISFXy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Sep 2015 01:23:54 -0400
Content-Disposition: inline
In-Reply-To: <20150919024725.GV3902@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 19, 2015 at 12:47:25PM +1000, Dave Chinner wrote:
> On Wed, Sep 16, 2015 at 07:21:59PM -0600, Andreas Dilger wrote:
> > If you add "-b 1024" to the mke2fs command line to use 1KB instead of 4KB blocks, and reduce the sizes by a factor of 4 does the problem still happen? That would make it easier for someone else to test, since it would only need a 4-5TB disk instead of a 19Tb array. 
> 
> Sparse files on XFS using loopback will allow you to simulate
> devices larger than 16TB easily. You can turtle it all the way down,
> too, to create the xfs filesystem on a loopback device on a sparse
> file on ext4....
> 
> Doing this sort of thing lets me know, for example, that the
> mkfs.ext4 defaults fail on a 500TB device...
> 
> # xfs_io -f -c 'truncate 500t' /mnt/xfs/fs.img
> # ls -lh /mnt/xfs
> total 0
> -rw------- 1 root root 500T Sep 19 12:41 fs.img
> # mkfs.ext4 /mnt/xfs/fs.img
> mke2fs 1.42.13 (17-May-2015)
> /mnt/xfs/fs.img: Cannot create filesystem with requested number of inodes while setting up superblock

Whee.  I guess one would need to turn on meta_bg at mkfs time (which scatters
the group descriptors across the disk instead of (failing to) sandwich them in
a single blockgroup... and fix the overhead calculation in ext2fs_initialize to
calculate the maximum BG overhead correctly, since it doesn't seem to know
about metabg.

Of course there's the question of whether or not we really /want/ people
formatting 500T ext4 filesystems.  meta_bg is not turned on by default, so
the defaults will still fail unless they know to pass that option.

(Frankly, doing so is probably insane.)

--D

> #
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
