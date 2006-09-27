From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: Re: [patch 04/12] rfc: 2fsprogs update
Date: Wed, 27 Sep 2006 14:59:57 +0200
Message-ID: <20060927125957.GA25703@openx1.frec.bull.fr>
References: <20060926143343.GA20020@openx1.frec.bull.fr> <20060926144716.GD25755@openx1.frec.bull.fr> <20060926173253.GC4219@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:20864 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932075AbWI0NAL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Sep 2006 09:00:11 -0400
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20060926173253.GC4219@thunk.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 26, 2006 at 01:32:53PM -0400, Theodore Tso wrote:
>=20
> /*
>  * Generic (non-filesystem layout specific) extents structure
>  */
> struct ext2fs_extent {
> 	blk64_t	e_pblk;		/* first physical block */
> 	blk64_t	e_lblk;		/* first logical block extent covers */
> 	int	e_len;		/* number of blocks covered by extent */
> };
>=20
>=20
> Note the use of blk64_t; yes, this means that blk_t will stay as a
> 32-bit value, and blk64_t will be used for new interfaces and be a
> 64-bit value. =20

if blk_t stays 32bit and we want to use e2fsprogs on 64bit file systems=
 then
we will have to duplicate most of the current code. I mean, since =E0 3=
2bit
on-disk file system is a valid 64bit file system then the 64bit part of
e2fsprogs will have to deal also with the 32bit stuff like 32bit indire=
ct
blocks, 32bit group descriptors etc. Thus we'll have to rewrite/dumplic=
ate
all the blk_t code on a new blk64_t branch. So we will have to maintain=
 2
branches of code that do the same thing:

	- "blk_t" branch: pure 32bit code

	- "blk64_t" branch: 64bit code with 32bit compatibility

So my question is: do we want to (1) maintains both blk_t and blk64_t A=
PIs
or (2) switch to the new "blk64_t" interface and just fix bugs in the o=
ld
interface until it dies.

Any thoughts here?

> This will get used to define an extent iterator function, that will l=
ook
> something like this:
>=20
> errcode_t ext2fs_extent_iterate(ext2_filsys fs,
> 				ext2_ino_t	ino,
> 				int	flags,
> 				char *block_buf,
> 				int (*func)(ext2_filsys fs,
> 					    struct ext2fs_extent *extent,
> 					    void	*priv_data),
> 				int (*meta_func)(ext2_filsys fs,
> 						 blk64_t blk,
> 						 int blk_type,
> 						 char *buf,
> 						 void	*priv_data),
> 				void *priv_data);
>=20
> This interface will work for both extent and non-extent-based
> inodes.... that is, if this interface is called on an inode which is
> using direct and indirect blocks, the function will Do The Right Thin=
g
> and find contiguous blocks runs which it will use to fill extent
> structures that will be passed to the callback function.  This is fin=
e,
> since extent-based interfaces will be easier and more efficient to us=
e
> anyway.
>=20
> We will also define two interfaces to manipulate the extents tree (an=
d
> which again, will Do The Right Thing on traditional non-extents based
> inods):
>=20
> errcode_t ext2fs_extent_set(ext2_filsys fs,
> 			    ext2_ino_t	ino,
> 			    ext2_ino_t	*block_buf,
> 			    struct_ext2fs_extent *extent);
>=20
> errcode_t ext2fs_extent_delete(ext2_filsys fs,
> 			       ext2_ino_t	ino,
> 			       ext2_ino_t	*block_buf,
> 			       struct_ext2fs_extent *extent);
>=20
>=20
> Both of these interfaces may require splitting an existing extent.  F=
or
> example, if ext2fs_extent_set() is passed an extent which falls in th=
e
> middle of an extent in the inode, it could result in one extent turni=
ng
> into three extents (namely the before extent, the new extent, and the
> after extent).  Similarly ext2fs_extent_delete() may be asked to dele=
te
> a sub-extent in the middle of an existing extent in the extent tree.
> This would be logically equivalent to the Windows NT "punch" operatio=
n,
> which is a more general version of truncate(), except it can remove
> blocks from the middle of a file.
>=20
>=20
> The other interface which I've started spec'ing out in my mind is a n=
ew
> form interface and implementation for bitmaps().  The new-style bitma=
ps
> will take a blk64_t type, but their biggest difference is that they w=
ill
> allow multiple different types of interfaces, much like the io_manage=
r
> abstractions we have right now abstracts our I/O reoutines.  Some
> implementations may use an extents tree to keep track of used and unu=
sed
> bits.  Anothers might use a disk file as a LRU backing store (this wi=
ll
> be necessary to support really large storage devices on systems with
> limited physical memory).  And of course, at least initially the firs=
t
> implementation we will support will be the old-fasheioned, "store the
> whole thing in memory" approach.
>=20
> So the basic idea is to implement new library abstractions which will
> work well for 32-bit extents, but which can be easily extensible to
> newer patches, and which can solve other problems as well while we're=
 at
> it (such as the people trying to use a cheap processor with small
> amounts of memory with terabytes of storagte and their having problem=
s
> with fsck running out of memory, for example).
>=20

i really like the idea. Since the first time i've looked into the e2fsp=
rogs
i'm wondering why don't we use such an interface for the library since =
the
beginning. I don't see much reasons to export functions and data struct=
ures
that deal with the details of the file system layout.

I see 2 different aspects for the libext2fs:

(1) iterate/read/modify/delete inodes, files and directories; that's wh=
at
    programs to access ext{2,3,4} file systems without mounting them ma=
y
    want to do. Or programs to defragment, produce statistics etc...

    these tasks don't need to know anything about the layout of the
    file-system;

(2) check and fix: that's what fsck does, that's a more complicated and
    depends more closely on the file system layout.

IMO, interfaces you propose are perfect for (1) and do most of the job =
for
(2), but i don't know if they are enough for a tool like fsck. For inst=
ance
it's not clear for me how to check and repair extent indexes and header=
s;
how to check that the logical block number matches the block number wit=
hin
the extent without using "lower level" routines.

Perhaps we can always check data structures "on the fly" in the iterato=
r
function and just return an error code if an anomaly is found; in this =
case
the caller could delete the inode (or partially copy it in /lost+found,
etc...)

This point isn't clear for me; do you have any idea, here?

The same question holds for a future block allocation and for inode
allocation abstract interfaces.

-- Alexandre
-
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
