From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: e2fsck performance for large lost+found dirs
Date: Tue, 3 Nov 2015 02:02:49 -0700
Message-ID: <50B62863-093D-4F87-9AE1-86CA61B7C402@dilger.ca>
References: <62BDBCF1-B82A-449C-BFDD-84AF76CC829E@dilger.ca> <20151102234202.GA2213@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_ED7BC4B4-9523-401E-8A41-B5FF62CBB940"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35375 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbKCJCz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Nov 2015 04:02:55 -0500
Received: by pasz6 with SMTP id z6so13062515pas.2
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2015 01:02:54 -0800 (PST)
In-Reply-To: <20151102234202.GA2213@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_ED7BC4B4-9523-401E-8A41-B5FF62CBB940
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 2, 2015, at 4:42 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Mon, Nov 02, 2015 at 03:49:38PM -0700, Andreas Dilger wrote:
>> Running e2fsck on a filesystem with a large number of disconnected =
inodes
>> can take a long time to complete.   This can happen with Lustre, =
since there
>> may be hundreds of thousands of inodes in one directory, and extent =
corruption can wipe out the whole directory (more on that in a separate
>> email).
>=20
> Or the case I saw a few months ago where a client had a =
35-million-entry
> directory which was corrupt and had to be fixed... the reason for it =
being
> that large was that it was not possible to give each department in =
this large
> bureaucracy its own directory "for reasons of political expediency". =
:)
>=20
> (XFS, but still...)
>=20
>> It is a very lengthy O(n^2) operation to reattach all disconnected =
inodes
>> to lost+found, which can take a long time if there are millions of =
them.
>>=20
>>=20
>> It would be much more efficient to keep a cursor pointing to the last =
leaf
>> block in the directory in which an entry was inserted. Since e2fsck =
is not
>> deleting entries from lost+found, and because the entry names are =
always
>> getting longer (due to scanning in increasing inode number order) =
there is
>> no value to search earlier blocks again. This would make lost+found =
insertion
>> O(1) and significantly improve e2fsck performance in this case. This =
could be
>> very fast since there is only the inode bitmap to traverse, and =
filenames are
>> "#ino" so only leaf block allocation and writes needed.
>=20
> Agreed.
>=20
>> For generic libext2fs usage (e.g. Darrick's FUSE interface) where =
entries
>> may be deleted from a directory, the cursor could be reset to the =
block of
>> any deleted entry, if it was at a lower offset.
>>=20
>> Darrick, at one time I thought you had a patch to fix this behaviour, =
but
>> I couldn't find it.  Maybe your patch was related to a similar O(n^2) =
search
>> problem with block allocation?
>=20
> Hmm... sorry, I don't recall ever doing that.
>=20
> (Bad memory, however.  Too many patches.)
>=20
>> Any thoughts about how to fix this?  I was originally thinking that I =
could
>> just cache this into the "file pointer", but no such thing exists in =
the
>> ext2fs_link() interface, only the directory inode number is passed, =
and it
>> has an additional level of indirection in that it calls the block =
iterator
>> with a callback to process each leaf block separately.  It also has =
the
>> problem that any cache would be local to ext2fs_link() and not =
visible to
>> ext2fs_unlink().
>>=20
>> I was thinking to start with ext2fs_link() calling =
ext2fs_dir_iterate2()
>> directly, just to avoid the first level of confusion in this code.  =
That
>> still doesn't allow passing a starting offset for the iteration, =
however.
>>=20
>> Next, cache the block number into the link_struct state and skip the =
leaf
>> block searches if block number < cursor, but that still needs =
iterating
>> over all the blocks to skip to the last one.
>>=20
>> Should I just call ext2fs_block_iterate2() in e2fsck_reconnect_file()
>> and keep the mechanics local to e2fsck?  I thought it might be a good
>> generic optimization, but the interfaces make this difficult.
>=20
> Uggghhh.... :)
>=20
> So I started to look at ext2fs_link -> ext2fs_dir_iterate2 ->
> ext2fs_block_iterate3, to see if there was a way to skip to the last =
block.
> There isn't any such thing, currently.
>=20
> How about this: create a new flags value for ext2fs_link which means =
"only
> search the last block".  Weirdly, the flags argument at the moment =
seems to
> provide the ftype entry for the directory, nothing more.  So this new =
flag
> would have to be filtered out of flags before it gets used as ftype.

Hmm, but I don't want to skip to the last block, but rather "skip to the
last block that had free space.  We have a tool to re-link Lustre OST
object from lost+found back into their correct locations using =
information
stored in an xattr, which leaves behind a large empty directory (maybe =
150MB
in size) and I don't want inserts only at the end of that directory, but
rather starting at the next free block and only scan each block once.

Unfortunately, that preferred solution needs some ability to share state
across calls to ext2fs_link(), and ideally also with ext2fs_unlink().

Cheers, Andreas
> Next we create a similar "last block only" flag for dir_iterate2 so =
that we
> can convey the append-only intent to the directory iterator, which =
could take
> a shortcut in which instead of calling the block iterator, it would =
instead
> ext2fs_bmap2() to find the pblk of the last directory block and call =
the
> function ext2fs_process_dir_block on that last block.
>=20
> This isn't /quite/ as efficient as simply storing a cursor, but I =
don't know
> of a non-messy way for a client program to stuff state into a libext2 =
call.
>=20
> <shrug>
>=20
> --D
>=20
>>=20
>> Cheers, Andreas
>>=20
>>=20
>>=20
>>=20
>>=20
>=20
>=20


Cheers, Andreas






--Apple-Mail=_ED7BC4B4-9523-401E-8A41-B5FF62CBB940
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVjh4OnKl2rkXzB/gAQh4fA//U7aghctZlaVAn0mdlN+xiYiOGZ2cmJVH
7E2XnE00+fhKGUjJ5ROZD7BA7vS+V+K+KtAzHesXroEGgx3lflOrTjb8E3h8w4dY
Qs6EpX69gsJQNxVK+5aMRehMQ1UzCd1Q1RiBhvojNfps0EjLpFBKhTNllwPllkrN
VwcCImB1gWZI/l7xe5qbcjz0hqsa6F31mayxWN/jbsVCNud1Ra/7i0PyWkBDhk9e
SDOpLctZ5kj39RdCbFCHCR2Uz5L63j7eLQYkdEslfxt4YB6hKKcgz6wzjAdnUQsQ
lGe76rGKYaG7ee7Qt9fg2clN5BrOOWzTmr8VaP76YZqRBhlg3sfjU12XDa1kB1Lc
+wqVG3HBE4915flzavtplNimewf8s7JP3jeKcrRYKdlB2WqlvVdHAGza/47hCPOa
+uYUdu/AyRrlyq2wlTPyyHIK9i9m2mQhtE21D94nI7jLZcXs1h43XTsNfBSWh52S
MziLuFKz9KRE58S+K2GkR8rrhgd8VcEUqVnx2xurCDtyL4takFddQf3+HybwlI6K
UKrRuVgb+HTFxaBqIIlrCXq6gRJ6Q2+mglwXyymzuxSpoLPTBw9yFJim2KtWVfQC
e2olqf+kw2UkFdA7V8cOmm13du9SxtsES1zFBPxWj9zGORKxnvXgrvfa+/KOgE3/
3/+fFXBhGss=
=Rqb/
-----END PGP SIGNATURE-----

--Apple-Mail=_ED7BC4B4-9523-401E-8A41-B5FF62CBB940--
