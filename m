From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: add a line break for proc mb_groups display
Date: Wed, 3 Feb 2016 14:12:44 -0700
Message-ID: <87C3B4B1-7165-4C80-8A94-B903A62C33A7@dilger.ca>
References: <1454505546-4875-1-git-send-email-huaitong.han@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_4D967167-62B6-4906-85CE-03FC121B10CF"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Huaitong Han <huaitong.han@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454505546-4875-1-git-send-email-huaitong.han@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_4D967167-62B6-4906-85CE-03FC121B10CF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Feb 3, 2016, at 6:19 AM, Huaitong Han <huaitong.han@intel.com> =
wrote:
>=20
> This patch adds a line break for proc mb_groups display.
>=20
> Signed-off-by: Huaitong Han <huaitong.han@intel.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/mballoc.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 61eaf74..4424b7b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2285,7 +2285,7 @@ static int ext4_mb_seq_groups_show(struct =
seq_file *seq, void *v)
> 	if (group =3D=3D 0)
> 		seq_puts(seq, "#group: free  frags first ["
> 			      " 2^0   2^1   2^2   2^3   2^4   2^5   2^6  =
"
> -			      " 2^7   2^8   2^9   2^10  2^11  2^12  2^13 =
 ]");
> +			      " 2^7   2^8   2^9   2^10  2^11  2^12  2^13 =
 ]\n");
>=20
> 	i =3D (sb->s_blocksize_bits + 2) * =
sizeof(sg.info.bb_counters[0]) +
> 		sizeof(struct ext4_group_info);
> --
> 2.4.3
>=20


Cheers, Andreas






--Apple-Mail=_4D967167-62B6-4906-85CE-03FC121B10CF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVrJtTHKl2rkXzB/gAQhPzg/+IgB1K+mK3bHhJ7i5F0O2RXAglm14g08t
MKt7qN62ZyfeXjp27QKtB7ql3GyM5CoppZF6TmOtORFkb8pzzlNqdgnUnjg+SyUs
r7emgXDdwrvTQLSsxDSjuDsPRBM8SDSXlxBLPnCemTol9qDYqavr1DrBsc0hwmYI
RW8tE1kpyE5y6J3xgqfR5lTUXyG2afuHfbwWjnDy7+Vxr47HaEyE7/UV9Ytxkn+Z
sNKO9ACc6juvcD1QYDgYe8o2K+olXYiUxGyhaENoMEoHhUnGyzP5wxpESC0CgZ37
tstHZr3qD/f+Vykf9kwSjxs3lXK32GKCcUldm3Q3EzGWzbysWxZl5Lho9rDQaJ+p
WHtJ+vyZY/4bDFbFYZI0cNUyORJLlDPNPXZ7DQaaO0oE2AWbewjIP6D6k1QjCSSb
edlgsEa8HR9TljbF+GuN1cNlPyRI3e0uz/lLCUKr4nBcQ5+VYladlOhUkgLRQ5Nl
69eigj8DmglSFUfrftlH66FSM33yyHH3E/m8lTxvFCnClFOzKvis3w1Jz9ctoRK6
fPPS9ruozin0KWBSeyE2cJg5CW+hKwUJ80cNW8PM3bbPQEDMjXuOLK4fOsZFAT+f
4KlyM/y1J9UFLipKEeziNFsP3xpGqsi7cN5TcdbVhhFAcI73mnehxCFLmB5A2F+M
jSgomVkqmxo=
=6fhO
-----END PGP SIGNATURE-----

--Apple-Mail=_4D967167-62B6-4906-85CE-03FC121B10CF--
