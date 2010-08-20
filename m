From: Andre Noll <maan@systemlinux.org>
Subject: Re: Memory allocation failed, e2fsck: aborted
Date: Fri, 20 Aug 2010 16:39:43 +0200
Message-ID: <20100820143943.GZ16603@skl-net.de>
References: <20100818140422.GL27457@skl-net.de> <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca> <20100819130123.GU16603@skl-net.de> <ABE19F5B-74C8-47E9-B359-D3FB2C137087@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6749iDyxihQ87e9v"
Cc: linux-ext4 development <linux-ext4@vger.kernel.org>,
	Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:32944 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab0HTOj4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Aug 2010 10:39:56 -0400
Content-Disposition: inline
In-Reply-To: <ABE19F5B-74C8-47E9-B359-D3FB2C137087@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--6749iDyxihQ87e9v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 19, 13:03, Andreas Dilger wrote:
> On 2010-08-19, at 07:01, Andre Noll wrote:
> > On Wed, Aug 18, 14:20, Andreas Dilger wrote:
> >>> This is an old 32 bit system with only 1G of ram and a 2.6.24 distro
> >>> kernel. I added _lots_ of swap but this did not help.
> >>=20
> >> Yeah, it is possible to have filesystems that are too large for the
> >> node they are running on.  There are low-priority discussions for how
> >> to reduce memory usage of e2fsck, but they have never been a priority
> >> to implement.
> >=20
> > But e2fsck runs entirely in user space, so all memory should be
> > swappable, no? I think the system did not swap at all.
>=20
> I think the problem isn't just the TOTAL amount of RAM being used, but
> the fact that this piece of code is trying to do a SINGLE allocation
> that is HUGE.  The second problem is that the constant re-allocation
> of this huge array (every 100 insertions) means that it can never
> really exceed 1/2 of RAM in size.

I see. So you are propossing to address the second problem by
introducing a more clever algorithm for allocating the icount
structures.

> > So we could just omit this allocation in the
> > common icount =3D=3D 2 case because we know it is a directory inode
> > (so we have one additional reference) if fs->inode_dir_map is not NULL.
>=20
> Yes, that was my idea.  The main problem is that this would tie
> together parts of the e2fsck code that are currently independent, and
> I don't know how cleanly this can be done.  It deserves some further
> investigation, even for normal e2fsck usage, because it would likely
> eliminate 75% of the extra allocations in icount due to leaf
> directories (internal directories will have nlink > 2 due to child
> directories)

Looks like it is worthwhile to keep this on the TODO list :)

> >> Every file with nlink > 1 will need an additional 8 bytes of data, and
> >> the insert_icount_el() function reallocates this structure every 100
> >> elements, so it can use AT MOST 1/2 of all memory before the new copy
> >> and the old one fill all available memory.
> >>=20
> >> It would probably make sense to modify the internal icount structure
> >> to hold a 2-level tree of arrays of e.g. 8kB chunks, or other advanced
> >> data structure so that it doesn't force reallocation and average .51
> >> memory copies of the WHOLE LIST on every insert.  This is probably
> >> doable with some light understanding of e2fsprogs, since the icount
> >> interface is well encapsulated, but it isn't something I have time for
> >> now.
> >=20
> > I'm interested in having a look at the icount structure and see what
> > can be done to reduce memory usage.
>=20
> One simple way that this could be fixed fairly easily (which would
> presumably allow swap to be used) is to have a 2-level (or N-level)
> tree of allocations for the icount->list array, with the first level
> being just an array of pointers to individually-allocated arrays of
> ext2_icount_el.  The sub-arrays can be some reasonable size (maybe
> 64kB), which would give us a fan-out of 64k / 8 =3D 8k, and if the
> top-level array is (re-)allocated in chunks of, say 64 pointers, the
> number of times the top-level array needs to be reallocated would only
> be every 64 * 8192 insertions, and only the pointer array needs to be
> reallocated/copied.

Seems to be simple enough. If Ted does not object to this approach
in general, I'll try to send some patches next week.  Probably I will
need some further advise though.

> That said, any insert-optimized tree structure with a high fan-out
> would be suitable.  Elements are almost never deleted, and we would
> never need to compact the tree (it is freed as a whole when it is
> done).

IMHO the benefits of some sophisticated tree structure do not justify
to introduce a new dependency on some library that implements the
structure, especially since this would not be an optional add-on. So
I'd say we try the simple 2-level approach you sketched above. The
parameters could be fine-tuned with information from the superblock (if
available), like the fs-wide number of hard links, as Ted suggested.

> I suspect that using multi-level arrays + swap is always going to be
> more efficient than using an on-disk database.  This will maximize the
> RAM usage due to very compact storage of the icount_el data instead of
> database records with much more (2x at least) overhead, and it will
> also avoid all disk IO unless the system is actually running out of
> RAM.  Finally, all of the swap IO will be in at least PAGE_SIZE
> chunks, while tdb and friends often write 512-byte sparse records
> randomly.

Agreed. Moreover, RAM size tends to grow faster than disk space. That
32bit machine came with 1G RAM and 80G hard disks some years ago. Today
you can order servers with 512G RAM and 2T disks, so the RAM growth
rate is 512 while disk space grew "only" by a factor of 25.

> If you have a new system ready to go, you may be ahead by just doing a
> raw copy of the filesystem over to the new storage, and running e2fsck
> on that.  This also gives you the security of doing the e2fsck on a
> copy of the data, in case it does something bad.
>=20
> You could start the raw copy even if you have your current e2fsck
> running, since I suspect the current tdb-based e2fsck will be totally
> IO-bound on the database and not on IO from the filesystem.

Very good idea! I'm already copying the raw device to the new machine.

Thanks a lot
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--6749iDyxihQ87e9v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFMbpOvWto1QDEAkw8RAh/KAJ4g4bJet6ELcx9YuDNMsxsOIgcXxQCeJQDI
cAOrpE1Ms8HtCHYPyqth6yI=
=3EHG
-----END PGP SIGNATURE-----

--6749iDyxihQ87e9v--
