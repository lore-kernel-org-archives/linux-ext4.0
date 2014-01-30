From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: FAST paper on ffsck
Date: Wed, 29 Jan 2014 19:14:01 -0800
Message-ID: <20140130031401.GD8798@birch.djwong.org>
References: <20131209180149.GA6096@thunk.org>
 <20140129185741.GA8798@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45986 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaA3DOI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jan 2014 22:14:08 -0500
Content-Disposition: inline
In-Reply-To: <20140129185741.GA8798@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 29, 2014 at 10:57:41AM -0800, Darrick J. Wong wrote:
> On Mon, Dec 09, 2013 at 01:01:49PM -0500, Theodore Ts'o wrote:
> > Andreas brought up on today's conference call Kirk McKusick's recent
> > changes[1] to try to improve fsck times for FFS, in response to the
> > recent FAST paper covering fsck speed ups for ext3, "ffsck: The Fast
> > Filesystem Checker"[2]
> > 
> > [1] http://www.mckusick.com/publications/faster_fsck.pdf
> > [2] https://www.usenix.org/system/files/conference/fast13/fast13-final52_0.pdf
> > 
> > All of the changes which Kirk outlined are ones which we had done
> > several years ago, in the early days of ext4 development.  I talked
> > about some of these in some blog entries, "Fast ext4 fsck times"[3], and
> > "Fast ext4 fsck times, revisited"[4]
> > 
> > [3] http://thunk.org/tytso/blog/2008/08/08/fast-ext4-fsck-times/
> > [4] http://thunk.org/tytso/blog/2009/02/26/fast-ext4-fsck-times-revisited/
> > 
> > (Apologies for the really bad formatting; I recovered my blog from
> > backups a few months ago, installed onto a brand-new Wordpress
> > installation --- since the old one was security bug ridden and
> > horribly obsolete --- and I haven't had a chance to fix up some of the
> > older blog entries that had explicit HTML for tables to work with the
> > new theme.)
> > 
> > One further observation from reading the ffsck paper.  Their method of
> > introducing heavy file system fragmentation resulted in a file system
> > where most of the files had external extent tree blocks; that is, the
> > trees had a depth > 1.  I have not observed this in file systems under
> > normal load, since most files are written once and not rewritten, and
> > those that are rewritten (i.e., database files) are not the common
> > case, and even then, generally aren't written in a random append
> > workload where there are hundreds of files in the same directory which
> > are appended to in random order.  So looking at at a couple file
> > systems' fsck -v output, I find results such as this:
> > 
> >              Extent depth histogram: 1229346/569/3
> >              Extent depth histogram: 332256/141
> >              Extent depth histogram: 23253/456
> > 
> > ... where the first number is the number of inode where all of the
> > extent information stored in the inode, and the second number is the
> > number of inodes with a single level of external extent tree blocks,
> > and so on.
> > 
> > As a result, I'm not seeing the fsck time degradation resulting from
> > file system aging, because with at leat my workloads, the file system
> > isn't getting fragmented in enough to result in a large number of
> > inodes with external extent tree blocks.
> > 
> > We could implement schemes to optimize fsck performance for heavily
> > fragmented file systems; a few which could be done using just e2fsck
> > optimizations, and some which would require file system format
> > changes.  However, it's not clear to me that it's worth it.
> > 
> > If folks would like help run some experiments, it would be useful to
> > run a test e2fsck on a partition: "e2fsck -Fnfvtt /dev/sdb1" and look
> > at the extent depth histogram and the I/O rates for the various e2fsck
> > passes (see below for an example).
> > 
> > If you have examples where the file system has a very large number of
> > inodes with extent tree depths > 1, it would be useful to see these
> > numbers, with a description of how old the file system has been, and
> > what sort of workload might have contributed to its aging.
> > 
> 
> I don't know about "very large", but here's what I see on the server that I
> share with some friends.  Afaik it's used mostly for VM images and test
> kernels... and other parallel-write-once files. ;)  This FS has been running
> since Nov. 2012.  That said, I think the VM images were created without
> fallocate; some of these files have tens of thousands of tiny extents.
> 
>      5386404 inodes used (4.44%, out of 121307136)
>        22651 non-contiguous files (0.4%)
>         7433 non-contiguous directories (0.1%)
>              # of inodes with ind/dind/tind blocks: 0/0/0
>              Extent depth histogram: 5526723/1334/16
>    202583901 blocks used (41.75%, out of 485198848)
>            0 bad blocks
>           34 large files
> 
>      5207070 regular files
>       313009 directories
>          576 character device files
>          192 block device files
>           11 fifos
>      1103023 links
>        94363 symbolic links (86370 fast symbolic links)
>           73 sockets
> ------------
>      6718317 files
> 
> On my main dev box, which is entirely old photos, mp3s, VM images, and kernel
> builds, I see:
> 
>      2155348 inodes used (2.94%, out of 73211904)
>        14923 non-contiguous files (0.7%)
>         1528 non-contiguous directories (0.1%)
>              # of inodes with ind/dind/tind blocks: 0/0/0
>              Extent depth histogram: 2147966/685/3
>     85967035 blocks used (29.36%, out of 292834304)
>            0 bad blocks
>            6 large files
> 
>      1862617 regular files
>       284915 directories
>          370 character device files
>           59 block device files
>            6 fifos
>       609215 links
>         7454 symbolic links (6333 fast symbolic links)
>           24 sockets
> ------------
>      2764660 files
> 
> Sadly, since I've left the LTC I no longer have access to tux1, which had a
> rather horrifically fragmented ext3.  Its backup server, which created a Time
> Machine-like series of "snapshots" with rsync --link-dest, took days to fsck,
> despite being ext4.

Well, I got a partial report -- the fs containing ISO images produced this fsck
output.  Not terribly helpful, alas.

  561392 inodes used (0.21%)
   14007 non-contiguous inodes (2.5%)
         # of inodes with ind/dind/tind blocks: 93077/7341/74
440877945 blocks used (82.12%)
       0 bad blocks
     382 large files
  492651 regular files
   36414 directories
     270 character device files
     760 block device files
       3 fifos
    2514 links
   31930 symbolic links (31398 fast symbolic links)
       4 sockets
--------
  564546 files

--D
