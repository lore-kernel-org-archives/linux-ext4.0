From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v2 1/4] ext4: Remove useless marking of superblock dirty
Date: Thu, 12 Apr 2012 10:20:49 +0300
Message-ID: <1334215249.13842.36.camel@sauron.fi.intel.com>
References: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
	 <1333367140-28370-2-git-send-email-artem.bityutskiy@linux.intel.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-b6aZcQLpXvmyfOFnGI3N"
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1333367140-28370-2-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-b6aZcQLpXvmyfOFnGI3N
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-04-02 at 14:45 +0300, Artem Bityutskiy wrote:
> From: Jan Kara <jack@suse.cz>
>=20
> Commit a0375156 properly notes that superblock doesn't need to be marked
> as dirty when only number of free inodes / blocks / number of directories
> changes since that is recomputed on each mount anyway. However that comme=
nt
> leaves some unnecessary markings as dirty in place. Remove these.
>=20
> Artem: tested using xfstests for both journalled and non-journalled ext4.

Hi Ted, what would be the fate of this patch-set?

--=20
Best Regards,
Artem Bityutskiy

--=-b6aZcQLpXvmyfOFnGI3N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPhoJRAAoJECmIfjd9wqK0n3EP/2/Xy/UuY3Eq5qssfgq4EUjD
pMla7CFxOQq31iq89DXSjgJSd0CPyaYQrFr24szxE8Ts0VEAgkBmB5JfuOkG7KIp
TV2ZvjG/FmYKgo0rN/U+lDWMNdgzLPOpvUK/3rfmWla/844uwacc6qPjZbgdA41m
yQ44ZUjnL5RNxnnYXBtXqVa509stNr0c1gLYkAdRIt5oLWmQz/XR0RMswe904x/o
PdJ9YNQk4qlR0oGWH5Bv5gmoFB2jYxrWDUDA3mCcQCQf67Uyk29EYVN+qZypUtq4
hxP+VPXSlqrf5SitjMiYVfk2uyiKtgfALxc9mMC1NnzkZYlpy/2XWBUanHCd38AR
M6D1dZ0u45QeSUpBFX245ld9q98MEHhFMf0cu3e7Xb2pyr6C+m+RkFwg0hSygwbu
NUNuG02/1h6BXEwEYNihxEX/H3Z9/QrihyxspD5j7wu2y11pZdrMpL9Cgll2Lver
kSMVFCXyGZBsL3C0qjg1zv5cbf4Wih4XZM6iHyBVxTG+oUR3L3gT4WhWhudu8aaS
wTT+xiJa9pBLlC/zILNU8OxvEjjyXgsYBlI5gxV6hobf/iZca3lMDTRDtHMEEHwn
gZGAyEIXmoTwCtp5YBmxE8jfMDjl5YRxBgOMpUppIo+bf3N70ZRmPB/PFy0QbKn9
AxAIwSt0w8adTOOpppqb
=rTWs
-----END PGP SIGNATURE-----

--=-b6aZcQLpXvmyfOFnGI3N--
