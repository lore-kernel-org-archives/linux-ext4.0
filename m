From: Andre Noll <maan@systemlinux.org>
Subject: Re: Memory allocation failed, e2fsck: aborted
Date: Thu, 19 Aug 2010 15:01:23 +0200
Message-ID: <20100819130123.GU16603@skl-net.de>
References: <20100818140422.GL27457@skl-net.de> <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lzfPtAjrR1KYNfg0"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:45684 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0HSNBg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Aug 2010 09:01:36 -0400
Content-Disposition: inline
In-Reply-To: <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--lzfPtAjrR1KYNfg0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 18, 14:20, Andreas Dilger wrote:
> > This is an old 32 bit system with only 1G of ram and a 2.6.24 distro
> > kernel. I added _lots_ of swap but this did not help.
>=20
> Yeah, it is possible to have filesystems that are too large for the
> node they are running on.  There are low-priority discussions for how
> to reduce memory usage of e2fsck, but they have never been a priority
> to implement.

But e2fsck runs entirely in user space, so all memory should be
swappable, no? I think the system did not swap at all.

> > Since the file system is corrupt anyway, it is maybe easiest
> > to delete inode 245859898 with debugfs, but maybe there is
> > a better option. Moreover, since this might be some kind of
> > e2fsck-trusts-corrupt-data issue, you might be interested in looking
> > at this.
>=20
> No, I don't think this will help.  The problem is not with that inode,
> just that it is needing to allocate a structure because of nlinks=3D2
> (this is normal).
>=20
> In theory it might be possible to avoid allocating icount structures
> for every directory inode (which have icount =3D=3D 2 normally), if we
> used the "fs->inode_dir_map" bit as "+1" for the inode link count.
>=20
> In any case, this is a non-trivial fix.

I'm not sure I can follow. Are you saying we currently allocate two
struct ext2_icount for a directory inode even if .  and .. are the
only two references? So we could just omit this allocation in the
common icount =3D=3D 2 case because we know it is a directory inode
(so we have one additional reference) if fs->inode_dir_map is not NULL.

> > Further info: The ext3 file system lives on a lv within a vg whose
> > single pv is the 12 disk raid6 array. The file system stores hard
> > link based backups, so it contains _lots_ of hard links.
>=20
> Ah, that is also a major user of memory, and not necessarily one that
> optimizing the internal bitmap will help significantly.  It may well
> be that your swap cannot be used if a single allocation is in the same
> neighbourhood as the total RAM size.

Is playing with the memory overcommit knobs likely going to help?

> Every file with nlink > 1 will need an additional 8 bytes of data, and
> the insert_icount_el() function reallocates this structure every 100
> elements, so it can use AT MOST 1/2 of all memory before the new copy
> and the old one fill all available memory.
>=20
> It would probably make sense to modify the internal icount structure
> to hold a 2-level tree of arrays of e.g. 8kB chunks, or other advanced
> data structure so that it doesn't force reallocation and average .51
> memory copies of the WHOLE LIST on every insert.  This is probably
> doable with some light understanding of e2fsprogs, since the icount
> interface is well encapsulated, but it isn't something I have time for
> now.

I'm interested in having a look at the icount structure and see what
can be done to reduce memory usage. Here's a first question: There is
ext2fs_create_icount() and ext2fs_create_icount_tdb(). Is is correct
that they do the same thing, the only difference being that the tdb
variant uses an on-disk database while ext2fs_create_icount stores
everything in memory?

If so we might want to discuss first whether it is more important
to improve the performance of the on-disk database or to decrease
the memory requirements of the in-memory variant. The answer likely
depends on the amounts of disk space and RAM a typical system will
have in 5 or 10 years from now.

> If you are interested to hack/improve e2fsprogs I'd be willing to
> guide you, but if not I'd just suggest connecting this array to
> another node to run e2fsck, and consider spending the $200 needed to
> get a 64-bit system with a few GB of RAM.

Yeah right. There is already a 64bit system waiting to replace the
old one. Moving the old disks would be a PITA though because of the
lack of hot swap bays...

Thanks for your help
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--lzfPtAjrR1KYNfg0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFMbSsjWto1QDEAkw8RApZ4AJ9UBhZoTma2n61Ax69uprDGnUbDmgCgo4TC
nM0A6uFvVLX4c7CRhw3E7Dw=
=dsIO
-----END PGP SIGNATURE-----

--lzfPtAjrR1KYNfg0--
