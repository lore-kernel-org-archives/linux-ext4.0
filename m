From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in
 ext4_setattr()
Date: Wed, 18 May 2011 16:13:56 +1000
Message-ID: <20110518061356.GY19446@dastard>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
 <4DD33AA9.9060104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jiaying Zhang <jiayingz@google.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:14861 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020Ab1ERGST (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 02:18:19 -0400
Content-Disposition: inline
In-Reply-To: <4DD33AA9.9060104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 10:19:05PM -0500, Eric Sandeen wrote:
> On 5/17/11 5:59 PM, Jiaying Zhang wrote:
> > There is a bug in commit c8d46e41 "ext4: Add flag to files with blocks
> > intentionally past EOF" that if we fallocate a file with FALLOC_FL_KEEP_SIZE
> > flag and then ftruncate the file to a size larger than the file's i_size,
> > any allocated but unwritten blocks will be freed but the file size is set
> > to the size that ftruncate specifies.
> > 
> > Here is a simple test to reproduce the problem:
> >   1. fallocate a 12k size file with KEEP_SIZE flag
> >   2. write the first 4k
> >   3. ftruncate the file to 8k
> > Then 'ls -l' shows that the i_size of the file becomes 8k but debugfs
> > shows the file has only the first written block left.
> 
> To be honest I'm not 100% certain what the fiesystem -should- do in this case.
> 
> If I go through that same sequence on xfs, I get 4k written / 8k unwritten:
> 
> # xfs_bmap -vp testfile
> testfile:
>  EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET              TOTAL FLAGS
>    0: [0..7]:          2648750760..2648750767  3 (356066400..356066407)     8 00000
>    1: [8..23]:         2648750768..2648750783  3 (356066408..356066423)    16 10000

Ok, so that's the case for a _truncate up_ from 4k to 8k:

$ rm /mnt/test/foo
$ xfs_io -f -c "resvsp 0 12k" -c stat -c "bmap -vp" -c "pwrite 0 4k" -c "fsync" -c "bmap -vp" -c "t 8k" -c "bmap -vp" -c stat /mnt/test/foo
fd.path = "/mnt/test/foo"
fd.flags = non-sync,non-direct,read-write
stat.ino = 71
stat.type = regular file
stat.size = 0
stat.blocks = 24
fsxattr.xflags = 0x2 [-p------------]
fsxattr.projid = 0
fsxattr.extsize = 0
fsxattr.nextents = 1
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136
/mnt/test/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..23]:         9712..9735        0 (9712..9735)        24 10000
wrote 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0000 sec (156 MiB/sec and 40000.0000 ops/sec)
/mnt/test/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          9712..9719        0 (9712..9719)         8 00000
   1: [8..23]:         9720..9735        0 (9720..9735)        16 10000
/mnt/test/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          9712..9719        0 (9712..9719)         8 00000
   1: [8..23]:         9720..9735        0 (9720..9735)        16 10000
fd.path = "/mnt/test/foo"
fd.flags = non-sync,non-direct,read-write
stat.ino = 71
stat.type = regular file
stat.size = 8192
stat.blocks = 24
fsxattr.xflags = 0x2 [-p------------]
fsxattr.projid = 0
fsxattr.extsize = 0
fsxattr.nextents = 2
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136

But you get a different result on truncate down:

$rm /mnt/test/foo
$ xfs_io -f -c "truncate 12k" -c "resvsp 0 12k" -c stat -c "bmap -vp" -c "pwrite 0 4k" -c "fsync" -c "bmap -vp" -c "t 8k" -c "bmap -vp" -c stat /mnt/test/foo
fd.path = "/mnt/test/foo"
fd.flags = non-sync,non-direct,read-write
stat.ino = 71
stat.type = regular file
stat.size = 12288
stat.blocks = 24
fsxattr.xflags = 0x2 [-p------------]
fsxattr.projid = 0
fsxattr.extsize = 0
fsxattr.nextents = 1
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136
/mnt/test/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..23]:         9584..9607        0 (9584..9607)        24 10000
wrote 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0000 sec (217.014 MiB/sec and 55555.5556 ops/sec)
/mnt/test/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          9584..9591        0 (9584..9591)         8 00000
   1: [8..23]:         9592..9607        0 (9592..9607)        16 10000
/mnt/test/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          9584..9591        0 (9584..9591)         8 00000
   1: [8..15]:         9592..9599        0 (9592..9599)         8 10000
fd.path = "/mnt/test/foo"
fd.flags = non-sync,non-direct,read-write
stat.ino = 71
stat.type = regular file
stat.size = 8192
stat.blocks = 16
fsxattr.xflags = 0x2 [-p------------]
fsxattr.projid = 0
fsxattr.extsize = 0
fsxattr.nextents = 2
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136

IOWs, on XFS a truncate up does not change the preallocation at all,
while a truncate down will _always_ remove preallocation beyond the
new EOF.  It's always had this behaviour w.r.t. to truncate(2) and
preallocation beyond EOF.

> I think this is a different result from ext4, either with or without your patch.
> 
> On ext4 I get size 8k, but only the first 4k mapped, as you say.
> 
> I don't recall when truncate is supposed to free fallocated blocks, and from what point?

It's entirely up to the filesystem how it treats blocks beyond EOF
during truncation. XFS frees them on truncate down, because it is
much safer to just truncate away everything beyond the new EOF than
to leave written extents beyond EOF as potential landmines.

Indeed, that's why calling vmtruncate() as a bad fix. If you have:


	       NUUUUUUUUUUWWWWWWWWWOUUUUUUUUU
       ....----+----------+--------+--------+
               A	  B        C        D

Where	A = new EOF (N)
	A->B = unwritten (U)
	B->C = written (W)
	C = old EOF (O)
	C->D = unwritten (U)

Then just calling vmtruncate() will leave the blocks in the range
B->C as written blocks. Hence then doing an extending truncate back
out to D will expose stale data rather than zeros in the range
B->C....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
