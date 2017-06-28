From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: fix __ext4_xattr_set_credits()
Date: Wed, 28 Jun 2017 16:26:39 -0600
Message-ID: <4D46B5E7-4001-44FE-BE94-82636D1F8512@dilger.ca>
References: <20170628214750.31548-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_3DD69996-ABDB-44CA-886B-5A3126E9F6B3";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170628214750.31548-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_3DD69996-ABDB-44CA-886B-5A3126E9F6B3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 28, 2017, at 3:47 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> __ext4_xattr_set_credits() calculates journal credits needed for a
> set xattr operation. Currently, credits needed for quota updates are
> added only if ea_inode feature is enabled which is wrong. Fix this by
> moving quota related additions to above ea_inode feature check.
>=20
> Fixes: 74c5bfa651af ("ext4: xattr inode deduplication")
>=20
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/xattr.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index ce12c3fb7e59..062756b4e6d8 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -845,6 +845,9 @@ static int __ext4_xattr_set_credits(struct =
super_block *sb,
> 	 */
> 	credits =3D 5;
>=20
> +	/* Quota updates. */
> +	credits +=3D EXT4_MAXQUOTAS_TRANS_BLOCKS(sb);
> +
> 	/* We are done if ea_inode feature is not enabled. */
> 	if (!ext4_has_feature_ea_inode(sb))
> 		return credits;
> @@ -878,9 +881,6 @@ static int __ext4_xattr_set_credits(struct =
super_block *sb,
> 	/* Block bitmap and group descriptor updates for each block. */
> 	credits +=3D blocks * 2;
>=20
> -	/* Quota updates. */
> -	credits +=3D EXT4_MAXQUOTAS_TRANS_BLOCKS(sb);
> -
> 	/* We may need to clone the existing xattr block in which case =
we need
> 	 * to increment ref counts for existing ea_inodes referenced by =
it.
> 	 */
> --
> 2.13.2.725.g09c95d1e9-goog
>=20


Cheers, Andreas






--Apple-Mail=_3DD69996-ABDB-44CA-886B-5A3126E9F6B3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZVC0hpIg59Q01vtYRAsSkAJ4kdi1no8xSAGQj54o180Yfjj7mFQCcD+Do
saXStyyu3hEMStvoMewoKGc=
=S7Ue
-----END PGP SIGNATURE-----

--Apple-Mail=_3DD69996-ABDB-44CA-886B-5A3126E9F6B3--
