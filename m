From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: JBD2: Spotted dirty metadata buffer....
Date: Wed, 6 Sep 2017 12:07:11 -0600
Message-ID: <77A4A0E4-C85C-4A9A-AB20-78754F95FEEC@dilger.ca>
References: <1744886.OgPgGFoXj7@stwm.de>
 <6EBBE85C-8A87-4D8B-9897-3D67D4B6D732@dilger.ca>
 <10283498.RxsF1TCk0q@stwm.de> <14919146.PgSzFZYKi6@stwm.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_9843D89D-7F06-44CE-B0E0-78292E7E0D0A";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Wolfgang Walter <linux@stwm.de>, Tao Ma <boyu.mt@taobao.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14919146.PgSzFZYKi6@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_9843D89D-7F06-44CE-B0E0-78292E7E0D0A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 6, 2017, at 6:46 AM, Wolfgang Walter <linux@stwm.de> wrote:
>=20
> Am Montag, 28. November 2016, 12:26:38 schrieb Wolfgang Walter:
>> Am Mittwoch, 23. November 2016, 16:40:07 schrieb Andreas Dilger:
>>> Stepping back a bit - does this problem only happen with an external
>>> journal device, or does it also happen with an internal journal?
>>=20
>> So I tried that this weekend. I got again these messages
>>=20
>> JBD2: Spotted dirty metadata buffer (dev =3D dm-22, blocknr =3D =
241763277). There's a risk of filesystem corruption in case of system =
crash.
>>=20
>> So this also happens with an internal journal.
>>=20
>=20
> [snip]
>=20
> I last tried with 4.9.46 and I still see that problem when rsyncing =
data to the filesystem: errors similar to
>=20
> JBD2: Spotted dirty metadata buffer (dev =3D dm-25, blocknr =3D =
1008028301). There's a risk of filesystem corruption in case of system =
crash.
>=20
> A later filesystem check does not show any errors.
>=20
>=20
> With 4.9.46 stable kernels I also sometimes get the following error:
>=20
> EXT4-fs error (device dm-25): ext4_iget:4501: inode #74061557: comm =
rsync: checksum invalid
> or
> EXT4-fs error (device dm-25): ext4_iget:4501: inode #155844677: comm =
nfsd: checksum invalid
>=20
> A filesystem check then says that the inode itselfs seems ok but the =
checksum is indeed wrong.
>=20
> As these inodes are inodes of very small files.
>=20
> So I finally copied all away and reinitialized the filesystem. But =
this time without -O inline_data
>=20
> Since then all works fine. So I assume there is a proplem with inodes =
and inline-data (at least until 4.9.46), maybe only with data=3Djournal.

Add Tao Ma, since he is the original inline data author, and it appears =
that Taobao
is using this feature so are probably interested in fixing any =
corruption.

Wolfgang, it would be useful if you could figure out what type of block =
the reported
blocknr=3D1008028301 is.  You can use "debugfs -c -R 'icheck 1008028301' =
/dev/dm-25".
I'd suspect, given that this is an inline data problem, that this is an =
inode table
block, but it is good to be sure.  It would also be useful to see if =
this inode
number correlates to one of the inodes that have bad checksums.

Cheers, Andreas






--Apple-Mail=_9843D89D-7F06-44CE-B0E0-78292E7E0D0A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZsDlPpIg59Q01vtYRAhbxAJ9uox29/P02R+YcftUIZttWHKe4jgCg2/za
EGh5FbLK+x55eApz5Xhmoqo=
=+Rgv
-----END PGP SIGNATURE-----

--Apple-Mail=_9843D89D-7F06-44CE-B0E0-78292E7E0D0A--
