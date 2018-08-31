From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: avoid arithemetic overflow that can trigger a BUG
Date: Fri, 31 Aug 2018 13:31:05 -0600
Message-ID: <A4D64426-1092-4652-9A8C-EBFD5B7655A7@dilger.ca>
References: <20180831174126.13071-1-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E79DC7BC-51AC-482F-A744-42D68FC2CE52";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180831174126.13071-1-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_E79DC7BC-51AC-482F-A744-42D68FC2CE52
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Aug 31, 2018, at 11:41 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> A maliciously crafted file system can cause an overflow when the
> results of a 64-bit calculation is stored into a 32-bit length
> parameter.
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D200623
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Reported-by: Wen Xu <wen.xu@gatech.edu>
> Cc: stable@vger.kernel.org
> ---
> fs/ext4/inode.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8f6ad7667974..1134c3473673 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3414,6 +3414,7 @@ static int ext4_iomap_begin(struct inode *inode,
> 	unsigned int blkbits =3D inode->i_blkbits;
> 	unsigned long first_block =3D offset >> blkbits;
> 	unsigned long last_block =3D (offset + length - 1) >> blkbits;
> +	unsigned long len;
> 	struct ext4_map_blocks map;
> 	bool delalloc =3D false;
> 	int ret;
> @@ -3434,7 +3435,8 @@ static int ext4_iomap_begin(struct inode *inode,
> 	}
>=20
> 	map.m_lblk =3D first_block;
> -	map.m_len =3D last_block - first_block + 1;
> +	len =3D last_block - first_block + 1;
> +	map.m_len =3D (len < UINT_MAX) ? len : UINT_MAX;

Wouldn't "(len < UINT_MAX)" always be true on a 32-bit system, or is =
there some
other limitation in that case (e.g. filesystem < 16TB) that prevents it =
from
being an issue?  Otherwise, this should use "unsigned long long len".

Cheers, Andreas






--Apple-Mail=_E79DC7BC-51AC-482F-A744-42D68FC2CE52
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAluJl3oACgkQcqXauRfM
H+A3fQ/9EX0WTy3D3VVpqEhmtCECdiJosoxy7384TSOgiPbDswrcdq5ifYqtrRI4
zwayxDlNPE3toS3OUBeaQGjBUvTXK26yza7fu1h6FcCkUw3/NorlwNkP5wU7RrXY
84g4WStN8UqbEGayszZJpl2FlA1tt+Tx3DhgMsI35a5yChZS3+YXafg777WFpSXC
vxuyAD8Iwr98DbHxI9p+3I2TMfa1hJnXWO20pJ3G0mhPsXmGZedxuQHMq7fPDaes
+S76omOeEH9EP10w4Ik+xO+GOKDf168Rwb0rSe+pSwI6PchdIXmG9rD6GEGykVvL
B2J4JKlSzOVerNE40LdRlg9KB8Zx0glWCNmQW7z5igJQTAmB5ZPRV5lPfLSiw6O2
KoFoiwt8WXq1NrJa4k35y2azTxSIW8GweUQqEbQ7cKVCVMmS3CzBboqf4+BS4fpL
aXDs2wpRQPf/2zwkEApPVPmFDiAnRtFVme+yqNmUoO50iP61rmcJ61xjZMyVGuN6
oKI4kIsaV/0VbOYAIl22QUvUKcUzdjVQl6OlTecGjGCdUVGI0qUuOZGS8SrnlTnP
klN70p7uUNlGdDW3dCVkiDqF3eGzhznh/cF3jjLyOUqNX5oUu7Hk2Y4/SuycJUwK
AZjbHtIbmr2FqMOwD/wRhIh0e+oJ5gC7DJvhZk1dx5hnht34aGU=
=ro5Q
-----END PGP SIGNATURE-----

--Apple-Mail=_E79DC7BC-51AC-482F-A744-42D68FC2CE52--
