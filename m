From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] blockgroup_lock.h: simplify definition of NR_BG_LOCKS
Date: Wed, 14 Sep 2016 15:09:30 -0600
Message-ID: <3F033C47-E636-42D1-AFCD-FCBCBF795ED4@dilger.ca>
References: <1473881320-123184-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_EB2F5A84-6BCB-4840-8ACF-BC4233606F9F"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473881320-123184-1-git-send-email-ebiggers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_EB2F5A84-6BCB-4840-8ACF-BC4233606F9F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 14, 2016, at 1:28 PM, Eric Biggers <ebiggers@google.com> wrote:
>=20
> We can use ilog2() to more easily produce the desired NR_BG_LOCKS.  =
This
> works because ilog2() is evaluated at compile-time when its argument =
is
> a compile-time constant.
>=20
> I did not change the chosen NR_BG_LOCKS values.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> include/linux/blockgroup_lock.h | 22 ++--------------------
> 1 file changed, 2 insertions(+), 20 deletions(-)
>=20
> diff --git a/include/linux/blockgroup_lock.h =
b/include/linux/blockgroup_lock.h
> index 61b583d..225bdb7 100644
> --- a/include/linux/blockgroup_lock.h
> +++ b/include/linux/blockgroup_lock.h
> @@ -10,28 +10,10 @@
> #include <linux/cache.h>
>=20
> #ifdef CONFIG_SMP
> -
> -/*
> - * We want a power-of-two.  Is there a better way than this?
> - */
> -
> -#if NR_CPUS >=3D 32
> -#define NR_BG_LOCKS	128
> -#elif NR_CPUS >=3D 16
> -#define NR_BG_LOCKS	64
> -#elif NR_CPUS >=3D 8
> -#define NR_BG_LOCKS	32
> -#elif NR_CPUS >=3D 4
> -#define NR_BG_LOCKS	16
> -#elif NR_CPUS >=3D 2
> -#define NR_BG_LOCKS	8
> +#define NR_BG_LOCKS	(4 << ilog2(NR_CPUS < 32 ? NR_CPUS : 32))
> #else
> -#define NR_BG_LOCKS	4
> -#endif
> -
> -#else	/* CONFIG_SMP */
> #define NR_BG_LOCKS	1
> -#endif	/* CONFIG_SMP */
> +#endif
>=20
> struct bgl_lock {
> 	spinlock_t lock;
> --
> 2.8.0.rc3.226.g39d4020
>=20


Cheers, Andreas






--Apple-Mail=_EB2F5A84-6BCB-4840-8ACF-BC4233606F9F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV9m8inKl2rkXzB/gAQiCFBAAqcMx2tQxMUS7eHC3diLUxASTX5ZPAsti
95gf4xROmdPwCN1+/77Qq7ppGpGJBdPgm3mqe+gJijCkSB1t+zfAruh4hQJAp1nN
TO8QT5WIdXEmtUCck0g4CKv72djgBG55lECD/1YaHspwJ7eM6Z4KDUCEnIIFFts2
ut1dJVZ9PaSaorITjPwcE9C5bu576K0K2EczELPKnABK0k0fpzhfrm9RLDEPGt4H
Qfm+UCvtstMPLOSPzti6Mx3ENtaCit4k3T1Sbd05F35Xv0AVn/umSVo1RPjGl14Q
PQZPwMQxb2ju92oNv9zi4pkmEJ4/9COcnpmNkjdxd+Uy8mbW8bgYRxv+4IzOpZTE
LgGrxmSffc0PPTe41GAkuEHzmPkbMaqjEGosvUnxHwPntoB+5bMKAFHCOn1wMD5L
J4maC5gY9FqBLv7xw1c4H0A2jQIO0OEs2GFRJZfB/mlJES7otJfzukiMcy+2Ytr0
2kU18tNk2EKgnveYNzM6xgVRstrxe3/80Ov3QKvThPS2Jfv2q5ScdjKwShnMFyAZ
d7WgANCySCBcgQyKWNRLywD+EZTJYd1pnP7uUYklT1OhG9SDxgV6caZUEUKtPqU6
5LnOxmjLh6O8nZ2PbM2r7Y4OG2VWUPuvfsuCCKZTbxOK0efwnveEo0NyfVW33PBG
UYT71fpeqoM=
=bfjg
-----END PGP SIGNATURE-----

--Apple-Mail=_EB2F5A84-6BCB-4840-8ACF-BC4233606F9F--
