From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: [PATCH] E2fsprogs: add missing usage for No_COW
Date: Wed, 13 Jun 2012 14:38:17 +0600
Message-ID: <20120613143817.454917c8@natsu>
References: <1339573633-31023-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6kpKQEK9Yw3h.n9R7M5SxMp"; protocol="application/pgp-signature"
Cc: <linux-ext4@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1339573633-31023-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Sig_/6kpKQEK9Yw3h.n9R7M5SxMp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Jun 2012 15:47:13 +0800
Liu Bo <liubo2009@cn.fujitsu.com> wrote:

> Add the missing usage for No_COW since we've supported No_COW flag.
>=20
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  misc/chattr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/misc/chattr.c b/misc/chattr.c
> index 141ea6e..24254cc 100644
> --- a/misc/chattr.c
> +++ b/misc/chattr.c
> @@ -83,7 +83,7 @@ static unsigned long sf;
>  static void usage(void)
>  {
>  	fprintf(stderr,
> -		_("Usage: %s [-RVf] [-+=3DAacDdeijsSu] [-v version] files...\n"),
> +		_("Usage: %s [-RVf] [-+=3DAacDdeijsSuC] [-v version] files...\n"),
>  		program_name);
>  	exit(1);
>  }

These were sorted alphabetically so the better way would be to use AaCcDdei=
jsSu

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/6kpKQEK9Yw3h.n9R7M5SxMp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/YUXkACgkQTLKSvz+PZwhPmACfYa5t3VqGJ6Tt3e5Mz9zMnW7V
+WYAmwcykWJEfbcFBvtv1XohNLfE+sKi
=GC+m
-----END PGP SIGNATURE-----

--Sig_/6kpKQEK9Yw3h.n9R7M5SxMp--
