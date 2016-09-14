From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] blockgroup_lock.h: remove debris from bgl_lock_ptr() conversion
Date: Wed, 14 Sep 2016 15:09:04 -0600
Message-ID: <8CA6154E-320A-4AB3-891F-05E097679438@dilger.ca>
References: <1473881279-122959-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_16E1F799-E71F-40EF-874D-A8A61D5CC968"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473881279-122959-1-git-send-email-ebiggers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_16E1F799-E71F-40EF-874D-A8A61D5CC968
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 14, 2016, at 1:27 PM, Eric Biggers <ebiggers@google.com> wrote:
>=20
> An obsolete comment and extra parentheses were left over from when the
> sb_bgl_lock() macro was replaced with the bgl_lock_ptr() function.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> include/linux/blockgroup_lock.h | 6 +-----
> 1 file changed, 1 insertion(+), 5 deletions(-)
>=20
> diff --git a/include/linux/blockgroup_lock.h =
b/include/linux/blockgroup_lock.h
> index e44b88b..61b583d 100644
> --- a/include/linux/blockgroup_lock.h
> +++ b/include/linux/blockgroup_lock.h
> @@ -49,14 +49,10 @@ static inline void bgl_lock_init(struct =
blockgroup_lock *bgl)
> 		spin_lock_init(&bgl->locks[i].lock);
> }
>=20
> -/*
> - * The accessor is a macro so we can embed a blockgroup_lock into =
different
> - * superblock types
> - */
> static inline spinlock_t *
> bgl_lock_ptr(struct blockgroup_lock *bgl, unsigned int block_group)
> {
> -	return &bgl->locks[(block_group) & (NR_BG_LOCKS-1)].lock;
> +	return &bgl->locks[block_group & (NR_BG_LOCKS-1)].lock;
> }
>=20
> #endif
> --
> 2.8.0.rc3.226.g39d4020
>=20


Cheers, Andreas






--Apple-Mail=_16E1F799-E71F-40EF-874D-A8A61D5CC968
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV9m8cXKl2rkXzB/gAQjVfA/5Aexup/Ydt3DXUoDZV3EHKBhL1N+jFdIC
/zX8q5/dIpOCUx5k3wtqP/SPYQZuDv/M52ITh292WPkjYdg5GFHiAgFwZoOyxhhf
9sIZMnjyz91XJ4yxEu1hdVVspPEkFyG11H2G4RtbwS/gWd8KKTpFaPXDT18c0Pqx
okBluod4bOQ3mupAHPOo28+JULsVHa4hdKISALDbOb9tHxwwEKCf2k6sipxymagq
/lmO1G/kHe+YBYRaBuPNlN6e823RZI8cSrB/ZxTmpyDV/XJWxozM8ZcQ/UaKiNGN
CKnww1uu9xaARvg63JHxOF4kcexvx1OvK8QrK6gHqrO7SAzsx9vT78VDAPpDnMCe
H+H1A4gppUZnOaSRzZ6j1xBFrru9rlcHWuJ2Ptx15WMRA7JWFnWMDsSWDaI10Oxi
MrLKVih8SthnRU5OxwXe5NW3IrpdQNoVRatJlYRYPB4PJta0TuvyoExs6WZxoLJr
MDbiEy2gR6aqyWxL/HmIbSqGxOSBmAcGdbJJovpV/z8XdKs5IKiYwX1N9zKiawoU
dqZXd75ILtBrZhdl5yejbw1h7qJ/bgCvfxz7YWDVCTH8P3YsJjEWAtgNi/1AO+q4
cG7aZMMEceSyBmLqkCBnJfhGtLZLTl3TaxaWfPXMT9bCV7kAu6B7eSg0kHRbIpYm
KHAJ/RZ86UM=
=y7ez
-----END PGP SIGNATURE-----

--Apple-Mail=_16E1F799-E71F-40EF-874D-A8A61D5CC968--
