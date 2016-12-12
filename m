From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/6] ext4: Move is_32bit_api() to generic code
Date: Mon, 12 Dec 2016 15:29:55 -0700
Message-ID: <D40D520F-A8A9-4E65-BC75-166D846D6816@dilger.ca>
References: <1480629741-18375-1-git-send-email-richard@nod.at> <1480629741-18375-2-git-send-email-richard@nod.at>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_7E1C5E36-E290-434A-BD73-5AA994871B08"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-mtd@lists.infradead.org, david@sigma-star.at, tytso@mit.edu,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480629741-18375-2-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_7E1C5E36-E290-434A-BD73-5AA994871B08
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 1, 2016, at 3:02 PM, Richard Weinberger <richard@nod.at> wrote:
>=20
> Since UBIFS will also use this function, move it to compat.h.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>

Looks fine, could have minor improvement as mentioned below.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/dir.c          | 9 ---------
> include/linux/compat.h | 2 ++
> 2 files changed, 2 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index e8b365000d73..464e6e99d744 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -290,15 +290,6 @@ static int ext4_readdir(struct file *file, struct =
dir_context *ctx)
> 	return err;
> }
>=20
> -static inline int is_32bit_api(void)
> -{
> -#ifdef CONFIG_COMPAT
> -	return in_compat_syscall();
> -#else
> -	return (BITS_PER_LONG =3D=3D 32);
> -#endif
> -}
> -
> /*
>  * These functions convert from the major/minor hash to an f_pos
>  * value for dx directories
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index 63609398ef9f..8412382e8d08 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -730,11 +730,13 @@ asmlinkage long compat_sys_fanotify_mark(int, =
unsigned int, __u32, __u32,
> #ifndef in_compat_syscall
> static inline bool in_compat_syscall(void) { return is_compat_task(); =
}
> #endif
> +static inline int is_32bit_api(void) { return in_compat_syscall(); }
>=20
> #else

This would benefit from an annotation to make it clear what the "#if" =
is:

#else /* !CONFIG_COMPAT */

>=20
> #define is_compat_task() (0)
> static inline bool in_compat_syscall(void) { return false; }
> +static inline int is_32bit_api(void) { return BITS_PER_LONG =3D=3D =
32; }
>=20
> #endif /* CONFIG_COMPAT */


Cheers, Andreas






--Apple-Mail=_7E1C5E36-E290-434A-BD73-5AA994871B08
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWE8k5XKl2rkXzB/gAQiOeg/+KM+J1R/44BC/a9lzVSzc8X1WTXes/K6z
Dm+xZDt2en9hWHdnlju4bNKdMjPcIlTB6wfp/UvCBWJbSuN09hINQuehkoE71mNp
Vjy9Rvx2+XguqQXlLL4wjDdVejauoQUksBp/LYYiHTR/WXNxAXICHsolYQxk1mcP
tPQAOzyINT5sa1a8uah+jjodU7CJ9lRqms4J2pb6+re6bMKtlTAtnJHwcIYpbx7g
E5hQ2h5mXZkvp+pZmHZEHZsnAsEFMatd10nBEpHgF5FIOPgaj/SIFcxDrCH07Wet
Dl4CHAXKNGHKyX/lsNBBx7AZZD6RfI7I3lyIWP0N6UhGP3G8JP1k7+IKV2EvuOPL
mRSMagZf1hySyYmJOP76LmNAWQ1YTC0NJODQk25+AwAu01RCxLPGCYt1xboaIz9+
784l9Ir1n1ziNEejMMKZIVrtQhovwBxmG/8jWfPWP9bKuLPrhyzv2eDoFfmkEarN
4fPLs+HXjl1RMAnsbLSIZAzEVVA6GH0SqbAuLouFyGRjK3T5nWJt2yldgXuVWRiR
73y1pt5n7s4n18pzfH1WOEViT0/AkNvl3t01CTgdWbhP5lWCg9eywKyq/XS266gD
iJxiU8ATERCcdu/IdQhYPWGvmip1JduU9Kc1ms/0VFzxWMuIUa6S6xMGnvR5+YpQ
90zej+eZdxE=
=AsS3
-----END PGP SIGNATURE-----

--Apple-Mail=_7E1C5E36-E290-434A-BD73-5AA994871B08--
