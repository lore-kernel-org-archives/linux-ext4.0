From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Recover from a "deleted inode referenced" situation
Date: Tue, 10 Oct 2017 14:36:59 -0600
Message-ID: <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca>
References: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_66175046-1DEC-4F44-9880-B202990870B2";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:53597 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933102AbdJJUhG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Oct 2017 16:37:06 -0400
Received: by mail-it0-f42.google.com with SMTP id n195so237761itg.2
        for <linux-ext4@vger.kernel.org>; Tue, 10 Oct 2017 13:37:05 -0700 (PDT)
In-Reply-To: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_66175046-1DEC-4F44-9880-B202990870B2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 5, 2017, at 3:31 PM, Kilian Cavalotti =
<kilian.cavalotti.work@gmail.com> wrote:
>=20
> Dear ext4 experts,
>=20
> TL;DR: I messed up a large filesystem, which now references deleted
> inodes. What's the best way to recover from this and hopefully
> reconstruct at least part of the directory hierarchy?

If the problem is only one of the partition being misaligned compared
to the logical volume, you can run the "findsuper" utility which is
part of e2fsprogs *sources* (it isn't built and packaged by default).
It will scan your block device and print out the ext2/3/4 superblocks
that it finds, along with the *byte* offset of each one found.  You
can use this to determine where the start of the filesystem should be.

This is made *much* more complex if you have other LVs on the same
storage, and the LV was increased in size over multiple iterations,
resulting in a fragmented allocation of PEs.

> Full version:
>=20
> I'm writing as a last recourse before committing data seppuku. I
> failed to observe rule #1 of disaster recovery (sit on your hands) and
> made a bad situation significantly worse. So I'm trying to figure out
> how badly I'm screwed, and if there's any hope of salvation.
>=20
> To set the stage, I have (sniff, *had*) an ext4 filesystem sitting on
> a LVM logical volume, on top of a RAID5 dmraid volume. The dmraid
> volume was expanded, then the LVM logical volume, and the ext4
> filesystem was resize2fs'ed. Except somewhere in the process,
> something failed and the ext4 filesystem was damaged. I unfortunately
> don't really know much more about the failure.
>=20
> At that point, the filesystem could be mounted read-only by using a
> backup superblock (mount -o ro,sb=3D131072), and a quick glance at it
> showed a decent directory structure, with at least top-level
> directories intact.
>=20
> So I jumped on it and started exfiltrating data from the damaged
> filesystem to an external system. Now, and that's what will cause me
> sorrow forever, I inadvertently remounted that filesystem read-write
> while the transfer was running...
>=20
> Of course, it soon started to throw errors about deleted inodes, like =
this:
>=20
> EXT4-fs error (device dm-0): ext4_lookup:1644: inode #2: comm rsync:
> deleted inode referenced: 1517
>=20
> At that point, listing the root of the filesystem generated I/O errors
> and dreadful question marks, where it displayed a valid directory
> before the r/w remount:
>=20
> $ ls /vol
> ls: cannot access backup: Input/output error
> drwxr-xr-x 2 root root 4096 Sep 28 11:10 .
> drwxr-xr-x 4 root root 4096 Sep 14  2013 ..
> -????????? ? ?    ?       ?            ? backup
> [...]
>=20
> I re-remounted read-only as soon as I realized my mistake, but the
> filesystem stayed mounted r/w for a few minutes.

It sounds like this replayed a corrupted journal over the rest of your
filesystem, leading to further corruption.

> That's where I'm at right now. I'm dd'ing the LVM device to another
> system before doing anything else, and while this is running (it will
> take a few days, as the filesystem size is close to 20TB), I'm
> pondering options.
>=20
> I guess the next logical step would be to run fsck, but I'm very
> worried that I will end up with mess of detached inodes in /lost+found
> without any way to figure out their original location in the
> filesystem...
>=20
> I read about ways to run fsck without touching the underlying
> filesystem (or image) with a LVM snapshots, or getting a copy of the
> metadata information with e2image, but I'm not really sure how to
> proceed.
>=20
> Could anybody provide pointers or advice on what to do next?

My only recommendation would be to update to the latest e2fsprogs,
since it usually fixes important issues found in older versions.

> Is there a way to undo the latest modifications done while the
> filesystem was mounted r/w?

Seems unlikely, unless you have an LVM snapshot.

> Do I have any chance to recover the initial structure and
> contents of my filesystem?

e2fsck is good at recovering what files are available, much better
than other filesystem recovery tools, but it can only work with the
data it has.

>=20
> I can obviously provide all the required information, just didn't want
> to make an already long email even longer.
>=20
>=20
> Thanks!
> --
> Kilian


Cheers, Andreas






--Apple-Mail=_66175046-1DEC-4F44-9880-B202990870B2
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ3S9spIg59Q01vtYRAmvuAJ9CQO1ufBIpYYCM6DyzwCYqLxtsmgCeKtLw
QuaMTv1qpCWSLnnzUjnxXkE=
=4IJk
-----END PGP SIGNATURE-----

--Apple-Mail=_66175046-1DEC-4F44-9880-B202990870B2--
