From: Georg Altmann <george@george-net.de>
Subject: Re: [PATCH] ext4: clarify error messages for mounting fs w/o journal
 /w journal options
Date: Fri, 12 Feb 2016 18:32:47 +0100
Message-ID: <56BE173F.2050703@george-net.de>
References: <1455283909-23354-1-git-send-email-george@george-net.de>
 <20160212170308.GC7928@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SDQsFN39onF0nQIiOfcnOoM7LQ4oDLQVO"
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160212170308.GC7928@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SDQsFN39onF0nQIiOfcnOoM7LQ4oDLQVO
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable



Am 12.02.2016 um 18:03 schrieb Theodore Ts'o:
> On Fri, Feb 12, 2016 at 02:31:49PM +0100, Georg Altmann wrote:
>> Previous message was hard to understand: When mounting a ext4 fs witho=
ut a
>> journal, but a mount option that controls journaling is used, clearly =
state
>> that the fs cannot be mounted with this option because it has no journ=
al.
>=20
> Well, technically it's possible for the file system to have a journal,
> but for journalling not to be enabled.  For example:
>=20
> root@kvm-xfstests:~# dmesg -n 7
> root@kvm-xfstests:~# mke2fs -t ext4 -Fq /dev/vdc
> /dev/vdc contains a ext4 file system
> 	created on Fri Feb 12 11:59:10 2016
> root@kvm-xfstests:~# dumpe2fs /dev/vdc | grep features
> dumpe2fs 1.43-WIP (18-May-2015)
> Filesystem features:      has_journal ext_attr resize_inode dir_index f=
iletype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink =
extra_isize metadata_csum
> Journal features:         (none)
> root@kvm-xfstests:~# mount -o noload,commit=3D1 /dev/vdc /vdc 2> /dev/n=
ull
> [  313.867505] EXT4-fs (vdc): can't mount with commit=3D1, fs mounted w=
/o journal
>=20
> So saying "fs has no journal" isn't necessarily going to be correct.
> Maybe "Can't mount with data=3Dxxx, journalling not enabled" would be
> less confusing to users?

Yes.

I do not understand the error checking logic here enough:
it could be either fs without journal or journal not enabled, right?
So how about
"can't mount with data=3Dxxx, journalling not enabled or no journal"
?

Or, if this can be justified in regard of code complexity, handle both
cases separately. Even nicer diagnostics for the user...

Should I send a new patch?

Regards,
Georg


--=20
PGP-Key: 0x1E320E65
D150 7783 A0D1 7507 1266  C5B3 BBF1 9C42 1E32 0E65

I don't like the idea of secret agencies to analyse and archive
personal communication. GnuPG is available as open source, free as as in
freedom, as a countermeasure. I use http://www.enigmail.net/ for Mozilla
Thunderbird. If you can, please use a frontend of your choice to send me
encrypted e-mail. See http://www.gnupg.org/ for an overview.


--SDQsFN39onF0nQIiOfcnOoM7LQ4oDLQVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWvhdAAAoJELvxnEIeMg5lFL0H/AwxHsfwrd1PRTIsdQ55pRAF
J55P4JBRVeTFuU58QZzftJExyQceqF0TT6TTgEdW1+9aSTc7MvYLke6A6dKpEjnc
ZqXIG8Js3SYisBz3zXn/Fn3LLFC5Glj7oSSS9IcppJ98B/HEl5HaF+3jLmr/OpjN
qJIXk1nZsU5FEXP0wj+5R92r32TJfaneqLoUjWQyqmSW3FJEteDd0encJji4RC/o
MlapQ9/qUtmXkmW0PAFN/Rl2mMpM16AvnZoW7nHlXJYlAccZFgPmNS2EPWeZppT1
/4SWIVxQlaDUwVUy2tWBkqK0iwe5Pz8yvvtyGB1Iw/Q9EPJ5MjUgcJR07GuWeJ4=
=/gMQ
-----END PGP SIGNATURE-----

--SDQsFN39onF0nQIiOfcnOoM7LQ4oDLQVO--
