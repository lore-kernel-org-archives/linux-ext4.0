From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 5/6] jbd2: replace current_kernel_time64 with ktime
 equivalent
Date: Thu, 21 Jun 2018 11:32:47 -0600
Message-ID: <E233989D-59D7-4257-A50B-F2AFCB2ED8DF@dilger.ca>
References: <20180620153322.54221-1-arnd@arndb.de>
 <20180620153322.54221-5-arnd@arndb.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_74D6BF15-6A25-4C67-B5F7-BA0FDB36915D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        y2038@lists.linaro.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620153322.54221-5-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_74D6BF15-6A25-4C67-B5F7-BA0FDB36915D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jun 20, 2018, at 9:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>=20
> jbd2 is one of the few callers of current_kernel_time64(), which
> is a wrapper around ktime_get_coarse_real_ts64(). This calls the
> latter directly for consistency with the rest of the kernel that
> is moving to the ktime_get_ family of time accessors.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/jbd2/commit.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 8de0e7723316..150cc030b4d7 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -121,7 +121,7 @@ static int journal_submit_commit_record(journal_t =
*journal,
> 	struct commit_header *tmp;
> 	struct buffer_head *bh;
> 	int ret;
> -	struct timespec64 now =3D current_kernel_time64();
> +	struct timespec64 now;
>=20
> 	*cbh =3D NULL;
>=20
> @@ -134,6 +134,7 @@ static int journal_submit_commit_record(journal_t =
*journal,
> 		return 1;
>=20
> 	tmp =3D (struct commit_header *)bh->b_data;
> +	ktime_get_coarse_real_ts64(&now);
> 	tmp->h_commit_sec =3D cpu_to_be64(now.tv_sec);
> 	tmp->h_commit_nsec =3D cpu_to_be32(now.tv_nsec);
>=20
> --
> 2.9.0
>=20


Cheers, Andreas






--Apple-Mail=_74D6BF15-6A25-4C67-B5F7-BA0FDB36915D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlsr4T8ACgkQcqXauRfM
H+BYWQ/+LeQR/KV88BsBceuGWGyY53EJk5DDCyuJddZUjQFBAZenTBtPQ642zu7B
qUHcVsk4sxSyBZK7HypEs+mpiaUKAVRHZdTKCXGIXJjCmywnLbJXYB0woRNu9kQi
by9hSk49F5MR2lUOV1WALNAtvrm1dA0/w0NnbRSUJF+e65ybsN8KkWTMe6hLgc7V
JHq8cwPEdSHkQiiG+JWphPD38eB3z5PJCHLlZSieMxlyR8MGqO2eBVkTUMeVHGlI
bBcUgIFxlGp2ylj7zcTvqoFoOT6WD/7pQBv90v8TDIK5tFs1+VuNGbqT9/B6a7xW
fKKYyPgVneiaOGoKL4icvGehM5i/Kw+R9vuYdIK081ebN+oHM2oLyQkWJVwTxoBl
c0lSqB+BuzeU/B2HL7KR5NnG7xfi1UGsi2/KYCi4CWRkyLs/0JYdfu9RL9EgBobd
BnHZW34mo9Ec2zD2uxgsC76qYJWeDQpboMA5OFTmsV6E9iYW6O/cJYBVHe2nKC/4
WdykhsBddgokF0GTqRdAb4TZoF5ZslK8jyJhOx8N0J5WbhNDQtHv2fYOFT+mSH2w
SKX+0zK0jdJXUoh9ZNN4EvkaZ5fs16Wey2ruQW8iTZeiNCqU2OFYOCi7Zo4j3xhY
hAysShMtNy58H09UbA6NwLO6ChOdOjuWfO05l+vBmLee6u3wBFU=
=DUnz
-----END PGP SIGNATURE-----

--Apple-Mail=_74D6BF15-6A25-4C67-B5F7-BA0FDB36915D--
