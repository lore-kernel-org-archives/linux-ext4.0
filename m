From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: move halfmd4 into hash.c directly
Date: Fri, 6 Jan 2017 12:49:19 -0700
Message-ID: <CE6C201A-70B3-4A91-A43C-2F5A07554933@dilger.ca>
References: <20170106182901.4412-1-Jason@zx2c4.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_5B8D10DC-C01D-4BC7-B588-3DCB859538BF"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170106182901.4412-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_5B8D10DC-C01D-4BC7-B588-3DCB859538BF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 6, 2017, at 11:29 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>=20
> The "half md4" transform should not be used by any new code. And
> fortunately, it's only used now by ext4. Since ext4 supports several
> hashing methods, at some point it might be desirable to move to
> something like SipHash. As an intermediate step, remove half md4 from
> cryptohash.h and lib, and make it just a local function in ext4's
> hash.c. There's precedent for doing this; the other function ext can =
use
> for its hashes -- TEA -- is also implemented in the same place. Also, =
by
> being a local function, this might allow gcc to perform some =
additional
> optimizations.

This is essentially a reversion of a patch applied in 2.6.11 to remove
the half-MD4 code from ext3:

=
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.11-rc2/2=
.6.11-rc2-mm2/broken-out/random-pt4-kill-duplicate-halfmd4-in-ext3-htree.p=
atch

This _just_ predates Git history so there is no commit hash for it.
A couple of trivial whitespace changes if patch is resubmitted, but it
looks fine as-is.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> ---
> fs/ext4/hash.c             | 69 =
+++++++++++++++++++++++++++++++++++++++++++++-
> include/linux/cryptohash.h |  2 --
> lib/Makefile               |  2 +-
> lib/halfmd4.c              | 67 =
--------------------------------------------
> 4 files changed, 69 insertions(+), 71 deletions(-)
> delete mode 100644 lib/halfmd4.c
>=20
> diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
> index e026aa941fd5..4d743d8f72fd 100644
> --- a/fs/ext4/hash.c
> +++ b/fs/ext4/hash.c
> @@ -10,7 +10,8 @@
>  */
>=20
> #include <linux/fs.h>
> -#include <linux/cryptohash.h>
> +#include <linux/compiler.h>
> +#include <linux/bitops.h>
> #include "ext4.h"
>=20
> #define DELTA 0x9E3779B9
> @@ -32,6 +33,72 @@ static void TEA_transform(__u32 buf[4], __u32 const =
in[])
> 	buf[1] +=3D b1;
> }
>=20
> +/* F, G and H are basic MD4 functions: selection, majority, parity */
> +#define F(x, y, z) ((z) ^ ((x) & ((y) ^ (z))))
> +#define G(x, y, z) (((x) & (y)) + (((x) ^ (y)) & (z)))
> +#define H(x, y, z) ((x) ^ (y) ^ (z))

(style) Would be nice to get an empty line here.

> +/*
> + * The generic round function.  The application is so specific that
> + * we don't bother protecting all the arguments with parens, as is =
generally
> + * good macro practice, in favor of extra legibility.
> + * Rotation is separate from addition to prevent recomputation
> + */
> +#define ROUND(f, a, b, c, d, x, s)	\
> +	(a +=3D f(b, c, d) + x, a =3D rol32(a, s))
> +#define K1 0
> +#define K2 013240474631UL
> +#define K3 015666365641UL

Blank line here too.

> +/*
> + * Basic cut-down MD4 transform.  Returns only 32 bits of result.
> + */
> +static __u32 half_md4_transform(__u32 buf[4], __u32 const in[8])
> +{
> +	__u32 a =3D buf[0], b =3D buf[1], c =3D buf[2], d =3D buf[3];
> +
> +	/* Round 1 */
> +	ROUND(F, a, b, c, d, in[0] + K1,  3);
> +	ROUND(F, d, a, b, c, in[1] + K1,  7);
> +	ROUND(F, c, d, a, b, in[2] + K1, 11);
> +	ROUND(F, b, c, d, a, in[3] + K1, 19);
> +	ROUND(F, a, b, c, d, in[4] + K1,  3);
> +	ROUND(F, d, a, b, c, in[5] + K1,  7);
> +	ROUND(F, c, d, a, b, in[6] + K1, 11);
> +	ROUND(F, b, c, d, a, in[7] + K1, 19);
> +
> +	/* Round 2 */
> +	ROUND(G, a, b, c, d, in[1] + K2,  3);
> +	ROUND(G, d, a, b, c, in[3] + K2,  5);
> +	ROUND(G, c, d, a, b, in[5] + K2,  9);
> +	ROUND(G, b, c, d, a, in[7] + K2, 13);
> +	ROUND(G, a, b, c, d, in[0] + K2,  3);
> +	ROUND(G, d, a, b, c, in[2] + K2,  5);
> +	ROUND(G, c, d, a, b, in[4] + K2,  9);
> +	ROUND(G, b, c, d, a, in[6] + K2, 13);
> +
> +	/* Round 3 */
> +	ROUND(H, a, b, c, d, in[3] + K3,  3);
> +	ROUND(H, d, a, b, c, in[7] + K3,  9);
> +	ROUND(H, c, d, a, b, in[2] + K3, 11);
> +	ROUND(H, b, c, d, a, in[6] + K3, 15);
> +	ROUND(H, a, b, c, d, in[1] + K3,  3);
> +	ROUND(H, d, a, b, c, in[5] + K3,  9);
> +	ROUND(H, c, d, a, b, in[0] + K3, 11);
> +	ROUND(H, b, c, d, a, in[4] + K3, 15);
> +
> +	buf[0] +=3D a;
> +	buf[1] +=3D b;
> +	buf[2] +=3D c;
> +	buf[3] +=3D d;
> +
> +	return buf[1]; /* "most hashed" word */
> +}
> +#undef ROUND
> +#undef K1
> +#undef K2
> +#undef K3
> +#undef F
> +#undef G
> +#undef H
>=20
> /* The old legacy hash */
> static __u32 dx_hack_hash_unsigned(const char *name, int len)
> diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
> index f4754282c9c2..3252799832cf 100644
> --- a/include/linux/cryptohash.h
> +++ b/include/linux/cryptohash.h
> @@ -15,6 +15,4 @@ void sha_transform(__u32 *digest, const char *data, =
__u32 *W);
>=20
> void md5_transform(__u32 *hash, __u32 const *in);
>=20
> -__u32 half_md4_transform(__u32 buf[4], __u32 const in[8]);
> -
> #endif
> diff --git a/lib/Makefile b/lib/Makefile
> index bc4073a8cd08..19ea76149a37 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -31,7 +31,7 @@ lib-$(CONFIG_HAS_DMA) +=3D dma-noop.o
> lib-y	+=3D kobject.o klist.o
> obj-y	+=3D lockref.o
>=20
> -obj-y +=3D bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o =
random32.o \
> +obj-y +=3D bcd.o div64.o sort.o parser.o debug_locks.o random32.o \
> 	 bust_spinlocks.o kasprintf.o bitmap.o scatterlist.o \
> 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iov_iter.o =
clz_ctz.o \
> 	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
> diff --git a/lib/halfmd4.c b/lib/halfmd4.c
> deleted file mode 100644
> index 137e861d9690..000000000000
> --- a/lib/halfmd4.c
> +++ /dev/null
> @@ -1,67 +0,0 @@
> -#include <linux/compiler.h>
> -#include <linux/export.h>
> -#include <linux/cryptohash.h>
> -#include <linux/bitops.h>
> -
> -/* F, G and H are basic MD4 functions: selection, majority, parity */
> -#define F(x, y, z) ((z) ^ ((x) & ((y) ^ (z))))
> -#define G(x, y, z) (((x) & (y)) + (((x) ^ (y)) & (z)))
> -#define H(x, y, z) ((x) ^ (y) ^ (z))
> -
> -/*
> - * The generic round function.  The application is so specific that
> - * we don't bother protecting all the arguments with parens, as is =
generally
> - * good macro practice, in favor of extra legibility.
> - * Rotation is separate from addition to prevent recomputation
> - */
> -#define ROUND(f, a, b, c, d, x, s)	\
> -	(a +=3D f(b, c, d) + x, a =3D rol32(a, s))
> -#define K1 0
> -#define K2 013240474631UL
> -#define K3 015666365641UL
> -
> -/*
> - * Basic cut-down MD4 transform.  Returns only 32 bits of result.
> - */
> -__u32 half_md4_transform(__u32 buf[4], __u32 const in[8])
> -{
> -	__u32 a =3D buf[0], b =3D buf[1], c =3D buf[2], d =3D buf[3];
> -
> -	/* Round 1 */
> -	ROUND(F, a, b, c, d, in[0] + K1,  3);
> -	ROUND(F, d, a, b, c, in[1] + K1,  7);
> -	ROUND(F, c, d, a, b, in[2] + K1, 11);
> -	ROUND(F, b, c, d, a, in[3] + K1, 19);
> -	ROUND(F, a, b, c, d, in[4] + K1,  3);
> -	ROUND(F, d, a, b, c, in[5] + K1,  7);
> -	ROUND(F, c, d, a, b, in[6] + K1, 11);
> -	ROUND(F, b, c, d, a, in[7] + K1, 19);
> -
> -	/* Round 2 */
> -	ROUND(G, a, b, c, d, in[1] + K2,  3);
> -	ROUND(G, d, a, b, c, in[3] + K2,  5);
> -	ROUND(G, c, d, a, b, in[5] + K2,  9);
> -	ROUND(G, b, c, d, a, in[7] + K2, 13);
> -	ROUND(G, a, b, c, d, in[0] + K2,  3);
> -	ROUND(G, d, a, b, c, in[2] + K2,  5);
> -	ROUND(G, c, d, a, b, in[4] + K2,  9);
> -	ROUND(G, b, c, d, a, in[6] + K2, 13);
> -
> -	/* Round 3 */
> -	ROUND(H, a, b, c, d, in[3] + K3,  3);
> -	ROUND(H, d, a, b, c, in[7] + K3,  9);
> -	ROUND(H, c, d, a, b, in[2] + K3, 11);
> -	ROUND(H, b, c, d, a, in[6] + K3, 15);
> -	ROUND(H, a, b, c, d, in[1] + K3,  3);
> -	ROUND(H, d, a, b, c, in[5] + K3,  9);
> -	ROUND(H, c, d, a, b, in[0] + K3, 11);
> -	ROUND(H, b, c, d, a, in[4] + K3, 15);
> -
> -	buf[0] +=3D a;
> -	buf[1] +=3D b;
> -	buf[2] +=3D c;
> -	buf[3] +=3D d;
> -
> -	return buf[1]; /* "most hashed" word */
> -}
> -EXPORT_SYMBOL(half_md4_transform);
> --
> 2.11.0
>=20


Cheers, Andreas






--Apple-Mail=_5B8D10DC-C01D-4BC7-B588-3DCB859538BF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWG/0v3Kl2rkXzB/gAQiAjQ/+J9Ph1rWS8TK506zFWQn4absKj9cSzjIj
n2DpltWbEOKBqLpXuNl0aGg3N2xvwycJWHWx1eUD5XAL5nJZXlpRyHPBhsc8Ssaw
Kx33mBqdgA7cZlfNlSmfQHLIvNA47BbuN4bmv82dB7LqSHcn+qxCBZpq87vAFXzA
eEz9AIxYxQqWpnGyXkBzLueBPv5Pke+uymYYyST7dFMAV5RK2+GF5Knryh3ajn13
XzFET+G9q13dqZ99xjn0p3+TLEgYYDRBA1mLiGYVenhyl0jfhktlf7VhG4EETHNQ
TpaE3udXPckpiu5D3fGWUyc6ohCkAKb7LbuZ9w5onAOf5y3tK4ytp9pK/Z0cgSHK
8rKABH3hUnvLQbk2slnW7FFXRqLMm2TAu0LxU47cpjX+lVZEz17YGF6z/LogB1zD
gzMoLMDuo+a2SMev2PkUINYlhu//snkUNaSTMS1CUGqrwarfGMmvx7jU4vYg2KZc
D+KnTTZy9On2W2DBF95AzV11fvpLPJ0eLC4sTpeHc0BLCer1NoYTukaSBwNB9BkN
nxudoVykftRDEYp3xtdZUl1fqyiwwj0eg2nDY5da276eQxVqa87A49LWnJy6LYgs
iWtNtL9EQQqUT5SnGcAOgJwGlD02Jj+UF1qs7aAymmA+LzZsx9eZ6AFCU6O9EXDZ
FeJQ/yknzCs=
=hCGw
-----END PGP SIGNATURE-----

--Apple-Mail=_5B8D10DC-C01D-4BC7-B588-3DCB859538BF--
