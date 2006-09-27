From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 04/12] rfc: 2fsprogs update
Date: Wed, 27 Sep 2006 10:10:15 -0400
Message-ID: <20060927141015.GA9483@thunk.org>
References: <20060926143343.GA20020@openx1.frec.bull.fr> <20060926144716.GD25755@openx1.frec.bull.fr> <20060926173253.GC4219@thunk.org> <20060927125957.GA25703@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47552 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S932269AbWI0OKS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Sep 2006 10:10:18 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060927125957.GA25703@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 27, 2006 at 02:59:57PM +0200, Alexandre Ratchov wrote:
> if blk_t stays 32bit and we want to use e2fsprogs on 64bit file syste=
ms then
> we will have to duplicate most of the current code. I mean, since =E0=
 32bit
> on-disk file system is a valid 64bit file system then the 64bit part =
of
> e2fsprogs will have to deal also with the 32bit stuff like 32bit indi=
rect
> blocks, 32bit group descriptors etc. Thus we'll have to rewrite/dumpl=
icate
> all the blk_t code on a new blk64_t branch. So we will have to mainta=
in 2
> branches of code that do the same thing:
>=20
> 	- "blk_t" branch: pure 32bit code
>=20
> 	- "blk64_t" branch: 64bit code with 32bit compatibility
>=20
> So my question is: do we want to (1) maintains both blk_t and blk64_t=
 APIs
> or (2) switch to the new "blk64_t" interface and just fix bugs in the=
 old
> interface until it dies.

Well, as I discussed later, I think we'll end up needing to make
changes to a number of these interfaces anyway --- for example, if we
get the block iterators and the bitmap interfaces, what's left?  Well,
let's see:

* The block allocation routines (ext2fs_new_block and friends) ---
	which probably wants to be changed to be based on allocating
	extents, anyway.
* The badblocks list functions --- trivial code, easy to maintain in
	parallel.
* ext2fs_bmap() -- Yup, we'll need a 64-bit version, and then we'll pro=
bably
	just implement the 32-bit version in terms of the 64-bit version
* ext2fs_read/write_dirblock, and a few others -- same thing as ext2fs_=
bmap()

The bottom line is that there really aren't that many interfaces, and
this also gives us the opportunity to clean up the interfaces as we go
along, and make sure we get them right.  To me, that's far more
important than whether or not we get e2fsprogs 64-bit capable within
some tight time window.  After all, we've missed the RHEL5 inclusion
window anyway, as far as I can tell, so I'd much rather trade off
long-term maintainability and cleanliness for a short-term getting
e2fsprogs 1.40 out the door.

> i really like the idea. Since the first time i've looked into the e2f=
sprogs
> i'm wondering why don't we use such an interface for the library sinc=
e the
> beginning. I don't see much reasons to export functions and data stru=
ctures
> that deal with the details of the file system layout.
>=20
> I see 2 different aspects for the libext2fs:
>=20
> (1) iterate/read/modify/delete inodes, files and directories; that's =
what
>     programs to access ext{2,3,4} file systems without mounting them =
may
>     want to do. Or programs to defragment, produce statistics etc...
>=20
>     these tasks don't need to know anything about the layout of the
>     file-system;
>=20
> (2) check and fix: that's what fsck does, that's a more complicated a=
nd
>     depends more closely on the file system layout.
>=20
> IMO, interfaces you propose are perfect for (1) and do most of the jo=
b for
> (2), but i don't know if they are enough for a tool like fsck. For in=
stance
> it's not clear for me how to check and repair extent indexes and head=
ers;
> how to check that the logical block number matches the block number w=
ithin
> the extent without using "lower level" routines.
>=20
> Perhaps we can always check data structures "on the fly" in the itera=
tor
> function and just return an error code if an anomaly is found; in thi=
s case
> the caller could delete the inode (or partially copy it in /lost+foun=
d,
> etc...)
>=20
> This point isn't clear for me; do you have any idea, here?

It's not clear because I've never been rigid about this point.  The
high level functions in ext2fs, such as those in fileio.c, absolutely
assume that the caller knows nothing about the filesystem layout, and
more importantly, that the filesystem is consistent.  There are some
basic checks (and there should be more) to make sure that things
aren't blatently corrupted, and the functions will return an error
message if the checks fail, but they aren't intended for use by fsck.
That corresponds to your category (1) functions, above.

But there are also those lower-level functions which are designed to
return enough information so that e2fsck can check the filesystem for
consistency, and if necessary, repair the filesystem.  A good example
of that is the block iterator functions.  There is information
returned in the callback functions which are of use only to e2fsck.
Normal application programs just ignore it. =20

And that was in my design of the block_extent_iterator as well; in
particular, I would assume that normal applications would never pass
in a function pointer to meta_func(), and that they would just simply
want to iterate over all of the extents in logical block order.
E2fsck would probably continue to call the block iterators for
traditional inods, and only call the extent interator for extent-based
inodes, and e2fsck would pass in a meta_func() callback so it would
receive information about low-level format information which is
supposed to check and possibly repair.  (See my reply to Andreas about
how meta_func would probably be called multiple times to allow e2fsck
to do what it needs to do.)

So this is a delicate balancing act, and yes, it means that we have to
balance interface cleanliness, ease of use, and efficiency across two
different use cases --- the normal application usage model, and the
e2fsck model.  One thing which makes this easier is that I've always
assumed that e2fsck and libext2fs will be upgraded in parallel.  So
e2fsck *can* depend on the low-level details about how the
extent_iterator will behave if e2fsck modifies interior node
information in the meta_func callback, since normal applications will
never use it.  =20

Also, the general rule of thumb is that while basic consistency checks
--- enough to keep libext2fs from core dumping and from doing grevious
harm to the filesystem if it is slightly corrupted --- all of the
fine-grained consistency checks and repair logic belongs in e2fsck,
not in libext2fs.  The only thing that we want to provide in libext2fs
is read/write access to low-level format data, hopefully in a useful
high-level abstraction such as the block and extent iterators, so that
e2fsck can do its job.

Does this help? =20

						- Ted

P.S.  This should probably be written up as documentation as part of
libext2fs design philosophy so that future patch writers can write
patches that I don't have to spend as much time rewriting.  :-)
-
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
