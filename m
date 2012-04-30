From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v2 1/4] ext4: Remove useless marking of superblock dirty
Date: Mon, 30 Apr 2012 11:37:25 +0300
Message-ID: <1335775045.2584.3.camel@sauron.fi.intel.com>
References: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
	 <1333367140-28370-2-git-send-email-artem.bityutskiy@linux.intel.com>
	 <1334215249.13842.36.camel@sauron.fi.intel.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-XX/qQRnw927UyK8DsHrt"
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1334215249.13842.36.camel@sauron.fi.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-XX/qQRnw927UyK8DsHrt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-04-12 at 10:20 +0300, Artem Bityutskiy wrote:
> On Mon, 2012-04-02 at 14:45 +0300, Artem Bityutskiy wrote:
> > From: Jan Kara <jack@suse.cz>
> >=20
> > Commit a0375156 properly notes that superblock doesn't need to be marke=
d
> > as dirty when only number of free inodes / blocks / number of directori=
es
> > changes since that is recomputed on each mount anyway. However that com=
ment
> > leaves some unnecessary markings as dirty in place. Remove these.
> >=20
> > Artem: tested using xfstests for both journalled and non-journalled ext=
4.
>=20
> Hi Ted, what would be the fate of this patch-set?

Hi Ted, I am sorry for being annoying, but what do you think about these
patches?

--=20
Best Regards,
Artem Bityutskiy

--=-XX/qQRnw927UyK8DsHrt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPnk9FAAoJECmIfjd9wqK0B+EP/1B0aQpqUNtewM3b9uQhWpIY
pS2F7SJBkF2lXyldBEuxTbFe4Q/lucIJlSZ503vdwF+y/dlmMtxNLWhLuBf8Wsk/
jJFYY5V9iFu8qFPjJVTCFu2PZoWbncrYrW9QRMRol36TDhFKGdAHXj1Iz4FSSXVy
t69wRiV7u4TzD26+76RpO5HFyXAhEXnv0A/54ReK6S3D3PpOsuijt49GYG41q/HU
DSsG2kWgqV/rtQc7ZkjUU+6ZMB40gnDMP3771V+nqJhPoPwVyX04ybPAF6bivT3t
ZE4reQpfPGrIES4KmHt3pMGVR3penwkKyVYynD1JLmFsfOcavyOHmeQhzDz+pX0h
C+xjYn3J7NsIjZhMte+4XSvBTbubdUDeOnMBfeyKXvXEyLL3iUovDxzP8gF63Qyq
bPRzyFXdwrYopuKSMYo4hRmSOmtUMWFlZTC+Qb/FwkfTxkz9nr+EL1h4uoS1exr7
H+Mmku6S1Wrf7FY2Au3YJh6T0AJBVYbR4rHsNRwLMbNAknlkX3qeTh2tpYZNI3Ad
wldOgI3xAFh+n9Dap49G80RqSYweIcGGTcT7fKnCj+tpobV8b0jj8mjGk+V6zoRH
mboqGU20pWyMChiuVMbhXFTlDLZ/hf3XMYwIqFCR/ZkbUBYjNQzhGFVQOpz3vKdO
UT+bJYE52+bGJyaD+lMU
=PoBH
-----END PGP SIGNATURE-----

--=-XX/qQRnw927UyK8DsHrt--
