From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Support fast symlinks from ext3 file systems
Date: Mon, 27 Nov 2017 11:08:53 -0700
Message-ID: <24E86306-4A6C-48AE-9999-A9D935A2DC12@dilger.ca>
References: <20171127173709.20787-1-andi@firstfloor.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_2F1B59CF-6451-4066-9FC2-F717E7062B4E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171127173709.20787-1-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_2F1B59CF-6451-4066-9FC2-F717E7062B4E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 27, 2017, at 10:37 AM, Andi Kleen <andi@firstfloor.org> wrote:
>=20
> From: Andi Kleen <ak@linux.intel.com>
>=20
> dbb3c27f5b91c4 (ext4: change fast symlink test to not rely on =
i_blocks)
> broke ~10 years old ext3 file systems created by 2.6.17. Any ELF
> executable fails because the /lib/ld-linux.so.2 fast symlink
> cannot be read anymore.
>=20
> The patch assumed fast symlinks were created in a specific way,
> but that's not true on these really old file systems.
>=20
> The new behavior is apparently needed only with the large EA inode
> feature.
>=20
> Revert to the old behavior if the large EA inode feature is not set.
>=20
> This makes my old VM boot again.
>=20
> Fixes: dbb3c27f5b91c4 (ext4: change fast symlink test to not rely ...)
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/inode.c | 9 +++++++++
> 1 file changed, 9 insertions(+)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0992d76f7ab1..6b82b0ff5e0b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -149,6 +149,15 @@ static int ext4_meta_trans_blocks(struct inode =
*inode, int lblocks,
>  */
> int ext4_inode_is_fast_symlink(struct inode *inode)
> {
> +	if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)) {
> +		int ea_blocks =3D EXT4_I(inode)->i_file_acl ?
> +				EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;
> +
> +		if (ext4_has_inline_data(inode))
> +			return 0;
> +
> +		return (S_ISLNK(inode->i_mode) && inode->i_blocks - =
ea_blocks =3D=3D 0);
> +	}
> 	return S_ISLNK(inode->i_mode) && inode->i_size &&
> 	       (inode->i_size < EXT4_N_BLOCKS * 4);
> }
> --
> 2.13.6
>=20


Cheers, Andreas






--Apple-Mail=_2F1B59CF-6451-4066-9FC2-F717E7062B4E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaHFS2pIg59Q01vtYRAg+jAJ9WN9hxybfOjAfR0gkDxU6sih+mVwCeP7MC
nKgBkTprWyVBIwCLLXFRwMw=
=pYak
-----END PGP SIGNATURE-----

--Apple-Mail=_2F1B59CF-6451-4066-9FC2-F717E7062B4E--
